require "open3"
require "json"
require "timeout"
require "tempfile"

class RubySandboxService
  TIMEOUT_SECONDS = 10
  MEMORY_LIMIT_MB = 128

  FORBIDDEN_PATTERNS = [
    /\bFile\b/,
    /\bIO\b/,
    /\bDir\b/,
    /\bFileUtils\b/,
    /\bPathname\b/,
    /\brequire\s/,
    /\brequire_relative\b/,
    /\bload\b/,
    /\bautoload\b/,
    /\beval\b/,
    /\binstance_eval\b/,
    /\bclass_eval\b/,
    /\bmodule_eval\b/,
    /\bBinding\b/,
    /\b`/,                    # backticks
    /\bsystem\b/,
    /\bexec\b/,
    /\bspawn\b/,
    /\bfork\b/,
    /\bProcess\b/,
    /\bKernel\.system\b/,
    /\bKernel\.exec\b/,
    /\bKernel\.`/,
    /\bOpen3\b/,
    /\bPTY\b/,
    /\bSocket\b/,
    /\bTCPSocket\b/,
    /\bUDPSocket\b/,
    /\bNet::/,
    /\bHTTP\b/,
    /\bURI\b/,
    /\bOpenURI\b/,
    /\bGem\b/,
    /\bENV\b/,
    /\bARGV\b/,
    /\b__FILE__\b/,
    /\b__dir__\b/,
    /\bObjectSpace\b/,
    /\bGC\b/,
    /\bTracePoint\b/,
    /\bset_trace_func\b/,
    /\bDRb\b/,
    /\bFiddle\b/,
    /\bWIN32OLE\b/,
    /\bSyscall\b/,
    /\bexit\b/,
    /\babort\b/,
    /\bat_exit\b/
  ].freeze

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

    result = run_in_sandbox
    execution_time = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time

    Result.new(
      success: result[:success],
      output: result[:output],
      errors: result[:errors],
      test_results: result[:test_results],
      execution_time: execution_time.round(3)
    )
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

  def run_in_sandbox
    Dir.mktmpdir("ruby_sandbox") do |tmpdir|
      runner_file = File.join(tmpdir, "runner.rb")
      results_file = File.join(tmpdir, "results.json")

      File.write(runner_file, build_runner_script(results_file))

      execute_with_timeout(runner_file, results_file)
    end
  end

  def build_runner_script(results_file)
    require "base64"
    encoded_user_code = Base64.strict_encode64(@user_code)
    encoded_test_code = Base64.strict_encode64(@test_code)

    <<~RUBY
      require 'json'
      require 'tempfile'
      require 'base64'

      results = {
        success: false,
        output: "",
        errors: "",
        test_results: []
      }

      begin
        # Decode user code from base64
        user_code = Base64.strict_decode64("#{encoded_user_code}")
        test_code = Base64.strict_decode64("#{encoded_test_code}")

        solution_file = Tempfile.new(['solution', '.rb'])
        solution_file.write(user_code)
        solution_file.close

        spec_file = Tempfile.new(['spec', '.rb'])
        spec_file.write("require '\#{solution_file.path}'\\n\\n\#{test_code}")
        spec_file.close

        require 'rspec/core'

        # Capture output
        output_file = Tempfile.new(['output', '.json'])

        # Configure RSpec
        RSpec.configure do |config|
          config.color = false
        end

        # Run specs
        RSpec::Core::Runner.run([
          '--format', 'json',
          '--out', output_file.path,
          spec_file.path
        ])

        # Parse results
        if File.exist?(output_file.path) && File.size(output_file.path) > 0
          rspec_output = JSON.parse(File.read(output_file.path))

          results[:test_results] = rspec_output["examples"].map do |ex|
            {
              description: ex["full_description"],
              status: ex["status"],
              exception: ex.dig("exception", "message")
            }
          end

          failure_count = rspec_output["summary"]["failure_count"] || 0
          errors_outside = rspec_output["summary"]["errors_outside_of_examples_count"] || 0

          results[:success] = failure_count == 0 && errors_outside == 0
          results[:output] = rspec_output["summary_line"]

          if errors_outside > 0
            results[:errors] = "\#{errors_outside} error(s) occurred outside of examples (likely syntax error)"
          end
        end

        solution_file.unlink
        spec_file.unlink
        output_file.unlink

      rescue SyntaxError => e
        results[:errors] = "Syntax Error: \#{e.message}"
      rescue NameError => e
        results[:errors] = "Name Error: \#{e.message}"
      rescue StandardError => e
        results[:errors] = "\#{e.class}: \#{e.message}"
      end

      File.write("#{results_file}", results.to_json)
    RUBY
  end

  def execute_with_timeout(runner_file, results_file)
    begin
      Timeout.timeout(TIMEOUT_SECONDS) do
        _output, _status = Open3.capture2e("ruby", runner_file)
      end

      parse_results_file(results_file)
    rescue Timeout::Error
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
        errors: "Execution error: #{e.message}",
        test_results: []
      }
    end
  end

  def parse_results_file(results_file)
    return default_error_result("Results file not found") unless File.exist?(results_file)

    content = File.read(results_file)
    return default_error_result("Empty results") if content.blank?

    parsed = JSON.parse(content)
    {
      success: parsed["success"],
      output: parsed["output"] || "",
      errors: parsed["errors"] || "",
      test_results: (parsed["test_results"] || []).map(&:symbolize_keys)
    }
  rescue JSON::ParserError => e
    default_error_result("Failed to parse results: #{e.message}")
  end

  def default_error_result(message)
    {
      success: false,
      output: "",
      errors: message,
      test_results: []
    }
  end
end
