require "open3"
require "json"
require "timeout"
require "tempfile"

class DockerSandboxService
  DOCKER_IMAGE = "learn_ruby_sandbox:latest"
  TIMEOUT_SECONDS = 10
  MEMORY_LIMIT = "128m"
  CPU_LIMIT = "0.5"
  PIDS_LIMIT = 20

  FORBIDDEN_PATTERNS = RubySandboxService::FORBIDDEN_PATTERNS

  Result = Data.define(:success, :output, :errors, :test_results, :execution_time)

  def initialize(user_code:, test_code:)
    @user_code = user_code
    @test_code = test_code
  end

  def execute
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    security_check = check_forbidden_patterns(@user_code)
    if security_check
      return Result.new(
        success: false,
        output: "",
        errors: "Security violation: #{security_check}",
        test_results: [],
        execution_time: 0.0
      )
    end

    result = run_in_docker
    execution_time = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time

    Result.new(
      success: result[:success],
      output: result[:output],
      errors: result[:errors],
      test_results: result[:test_results],
      execution_time: execution_time.round(3)
    )
  end

  def self.build_image!
    dockerfile_path = Rails.root.join("docker", "sandbox", "Dockerfile")
    system("docker build -t #{DOCKER_IMAGE} -f #{dockerfile_path} #{dockerfile_path.dirname}")
  end

  def self.image_exists?
    system("docker image inspect #{DOCKER_IMAGE} > /dev/null 2>&1")
  end

  private

  def check_forbidden_patterns(code)
    FORBIDDEN_PATTERNS.each do |pattern|
      if code.match?(pattern)
        matched = code.match(pattern)[0]
        return "Forbidden pattern detected: '#{matched}'"
      end
    end
    nil
  end

  def run_in_docker
    Dir.mktmpdir("docker_sandbox") do |tmpdir|
      # Write files
      File.write(File.join(tmpdir, "solution.rb"), @user_code)
      File.write(File.join(tmpdir, "solution_spec.rb"), build_spec_content)
      File.write(File.join(tmpdir, "runner.rb"), build_runner_script)

      # Execute in Docker
      execute_docker_container(tmpdir)
    end
  end

  def build_spec_content
    <<~RUBY
      require_relative 'solution'

      #{@test_code}
    RUBY
  end

  def build_runner_script
    <<~'RUBY'
      require 'json'
      require 'stringio'

      results = {
        success: false,
        output: "",
        errors: "",
        test_results: []
      }

      begin
        require 'rspec/core'
        require 'rspec/expectations'

        # Capture output
        output = StringIO.new

        RSpec.configure do |config|
          config.color = false
        end

        # Run specs
        RSpec::Core::Runner.run(
          ['--format', 'json', '--out', '/tmp/results.json', '/sandbox/solution_spec.rb'],
          $stderr,
          output
        )

        # Read results
        if File.exist?('/tmp/results.json')
          rspec_result = JSON.parse(File.read('/tmp/results.json'))

          results[:test_results] = rspec_result["examples"].map do |ex|
            {
              description: ex["full_description"],
              status: ex["status"],
              exception: ex.dig("exception", "message")
            }
          end

          results[:success] = rspec_result["summary"]["failure_count"] == 0
          results[:output] = rspec_result["summary_line"]
        end
      rescue SyntaxError => e
        results[:errors] = "Syntax Error: #{e.message}"
      rescue NameError => e
        results[:errors] = "Name Error: #{e.message}"
      rescue StandardError => e
        results[:errors] = "#{e.class}: #{e.message}"
      end

      puts "---RESULT_START---"
      puts results.to_json
      puts "---RESULT_END---"
    RUBY
  end

  def execute_docker_container(tmpdir)
    docker_cmd = build_docker_command(tmpdir)

    begin
      output = ""
      Timeout.timeout(TIMEOUT_SECONDS + 2) do
        output, status = Open3.capture2e(docker_cmd)
      end

      parse_docker_output(output)
    rescue Timeout::Error
      # Force kill container
      container_name = "sandbox_#{Process.pid}"
      system("docker kill #{container_name} 2>/dev/null")

      {
        success: false,
        output: "",
        errors: "Execution timed out (#{TIMEOUT_SECONDS} seconds limit)",
        test_results: []
      }
    rescue StandardError => e
      {
        success: false,
        output: "",
        errors: "Docker execution error: #{e.message}",
        test_results: []
      }
    end
  end

  def build_docker_command(tmpdir)
    container_name = "sandbox_#{Process.pid}_#{Time.now.to_i}"

    [
      "docker run",
      "--rm",
      "--name #{container_name}",
      "--network none",                    # No network access
      "--memory #{MEMORY_LIMIT}",          # Memory limit
      "--memory-swap #{MEMORY_LIMIT}",     # No swap
      "--cpus #{CPU_LIMIT}",               # CPU limit
      "--pids-limit #{PIDS_LIMIT}",        # Process limit
      "--read-only",                       # Read-only filesystem
      "--tmpfs /tmp:size=10M",             # Small tmpfs for temp files
      "--security-opt no-new-privileges",  # No privilege escalation
      "-v #{tmpdir}:/sandbox:ro",          # Mount code read-only
      "-w /sandbox",
      DOCKER_IMAGE,
      "ruby /sandbox/runner.rb"
    ].join(" ")
  end

  def parse_docker_output(output)
    # Extract result JSON from markers
    match = output.match(/---RESULT_START---\s*(\{.*?\})\s*---RESULT_END---/m)

    unless match
      return {
        success: false,
        output: "",
        errors: "Failed to parse Docker output: #{output.truncate(300)}",
        test_results: []
      }
    end

    parsed = JSON.parse(match[1])
    {
      success: parsed["success"],
      output: parsed["output"] || "",
      errors: parsed["errors"] || "",
      test_results: (parsed["test_results"] || []).map(&:symbolize_keys)
    }
  rescue JSON::ParserError => e
    {
      success: false,
      output: "",
      errors: "JSON parse error: #{e.message}",
      test_results: []
    }
  end
end
