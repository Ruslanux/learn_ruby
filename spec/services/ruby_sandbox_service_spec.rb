require 'rails_helper'

RSpec.describe RubySandboxService do
  describe "#execute" do
    context "with valid code that passes tests" do
      it "returns success result" do
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

        service = described_class.new(user_code: user_code, test_code: test_code)
        result = service.execute

        expect(result.success).to be true
        expect(result.errors).to be_empty
        expect(result.execution_time).to be > 0
      end
    end

    context "with code that fails tests" do
      it "returns failure result with test details" do
        user_code = <<~RUBY
          def hello
            "Wrong!"
          end
        RUBY

        test_code = <<~RUBY
          RSpec.describe "hello" do
            it "returns Hello!" do
              expect(hello).to eq("Hello!")
            end
          end
        RUBY

        service = described_class.new(user_code: user_code, test_code: test_code)
        result = service.execute

        expect(result.success).to be false
      end
    end

    context "with syntax errors" do
      it "returns error message" do
        user_code = <<~RUBY
          def hello
            if true
              "missing end"
          end
        RUBY

        test_code = <<~RUBY
          RSpec.describe "hello" do
            it "works" do
              expect(hello).to eq("Hello!")
            end
          end
        RUBY

        service = described_class.new(user_code: user_code, test_code: test_code)
        result = service.execute

        expect(result.success).to be false
        expect(result.errors).to be_present
      end
    end

    context "with forbidden patterns" do
      forbidden_codes = [
        { name: "File access", code: 'File.read("/etc/passwd")' },
        { name: "system call", code: 'system("ls")' },
        { name: "backticks", code: '`ls`' },
        { name: "require", code: 'require "net/http"' },
        { name: "eval", code: 'eval("1+1")' },
        { name: "ENV access", code: 'ENV["SECRET"]' },
        { name: "Process", code: 'Process.pid' },
        { name: "Socket", code: 'Socket.new(:INET, :STREAM)' },
        { name: "exit", code: 'exit(1)' }
      ]

      forbidden_codes.each do |test_case|
        it "blocks #{test_case[:name]}" do
          service = described_class.new(
            user_code: test_case[:code],
            test_code: "RSpec.describe('x') { it('y') { expect(1).to eq(1) } }"
          )
          result = service.execute

          expect(result.success).to be false
          expect(result.errors).to include("Security violation")
        end
      end
    end

    context "with safe Ruby features" do
      it "allows basic math" do
        user_code = <<~RUBY
          def calculate
            (1 + 2) * 3
          end
        RUBY

        test_code = <<~RUBY
          RSpec.describe "calculate" do
            it "returns 9" do
              expect(calculate).to eq(9)
            end
          end
        RUBY

        service = described_class.new(user_code: user_code, test_code: test_code)
        result = service.execute

        expect(result.success).to be true
      end

      it "allows array operations" do
        user_code = <<~RUBY
          def sum(numbers)
            numbers.sum
          end
        RUBY

        test_code = <<~RUBY
          RSpec.describe "sum" do
            it "sums numbers" do
              expect(sum([1, 2, 3])).to eq(6)
            end
          end
        RUBY

        service = described_class.new(user_code: user_code, test_code: test_code)
        result = service.execute

        expect(result.success).to be true
      end

      it "allows string manipulation" do
        user_code = 'def greet(name); "Hello, #{name}!"; end'

        test_code = <<~RUBY
          RSpec.describe "greet" do
            it "greets by name" do
              expect(greet("Ruby")).to eq("Hello, Ruby!")
            end
          end
        RUBY

        service = described_class.new(user_code: user_code, test_code: test_code)
        result = service.execute

        expect(result.success).to be true
      end

      it "allows classes" do
        user_code = <<~RUBY
          class Calculator
            def add(a, b)
              a + b
            end
          end
        RUBY

        test_code = <<~RUBY
          RSpec.describe Calculator do
            it "adds numbers" do
              calc = Calculator.new
              expect(calc.add(2, 3)).to eq(5)
            end
          end
        RUBY

        service = described_class.new(user_code: user_code, test_code: test_code)
        result = service.execute

        expect(result.success).to be true
      end

      it "allows blocks and iterators" do
        user_code = <<~RUBY
          def double_all(numbers)
            numbers.map { |n| n * 2 }
          end
        RUBY

        test_code = <<~RUBY
          RSpec.describe "double_all" do
            it "doubles each number" do
              expect(double_all([1, 2, 3])).to eq([2, 4, 6])
            end
          end
        RUBY

        service = described_class.new(user_code: user_code, test_code: test_code)
        result = service.execute

        expect(result.success).to be true
      end
    end
  end

  describe "Result" do
    it "is a Data class with expected attributes" do
      result = RubySandboxService::Result.new(
        success: true,
        output: "1 example, 0 failures",
        errors: "",
        test_results: [ { description: "test", status: "passed" } ],
        execution_time: 0.5
      )

      expect(result.success).to be true
      expect(result.output).to eq("1 example, 0 failures")
      expect(result.errors).to eq("")
      expect(result.test_results).to be_an(Array)
      expect(result.execution_time).to eq(0.5)
    end
  end
end
