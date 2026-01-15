namespace :sandbox do
  desc "Benchmark RubySandboxService vs DockerSandboxService"
  task benchmark: :environment do
    user_code = <<~RUBY
      def hello
        "Hello!"
      end
    RUBY

    test_code = <<~RUBY
      RSpec.describe "hello" do
        it "returns Hello!" do
          expect(hello).to eq("Hello!")
        end
      end
    RUBY

    puts "=" * 60
    puts "Sandbox Benchmark"
    puts "=" * 60

    # Test RubySandboxService
    puts "\n📦 RubySandboxService (process-based):"
    times = []
    3.times do |i|
      result = RubySandboxService.new(user_code: user_code, test_code: test_code).execute
      times << result.execution_time
      puts "  Run #{i + 1}: #{result.execution_time}s (#{result.success ? '✅ passed' : '❌ failed'})"
    end
    avg_ruby = times.sum / times.size
    puts "  Average: #{avg_ruby.round(3)}s"

    # Test DockerSandboxService
    puts "\n🐳 DockerSandboxService (Docker-based):"
    if DockerSandboxService.image_exists?
      times = []
      3.times do |i|
        result = DockerSandboxService.new(user_code: user_code, test_code: test_code).execute
        times << result.execution_time
        status = result.success ? '✅ passed' : "❌ failed: #{result.errors}"
        puts "  Run #{i + 1}: #{result.execution_time}s (#{status})"
      end
      avg_docker = times.sum / times.size
      puts "  Average: #{avg_docker.round(3)}s"

      puts "\n" + "=" * 60
      puts "Comparison:"
      puts "  Process-based: #{avg_ruby.round(3)}s"
      puts "  Docker-based:  #{avg_docker.round(3)}s"
      puts "  Difference:    #{(avg_docker - avg_ruby).round(3)}s (#{((avg_docker / avg_ruby - 1) * 100).round(1)}% slower)"
    else
      puts "  ⚠️  Docker image 'learn_ruby_sandbox:latest' not found."
      puts "  Build it with: docker build -t learn_ruby_sandbox:latest -f docker/sandbox/Dockerfile docker/sandbox/"
    end

    puts "=" * 60
  end

  desc "Build Docker sandbox image"
  task build_image: :environment do
    puts "Building Docker sandbox image..."
    DockerSandboxService.build_image!
    puts "Done!"
  end
end
