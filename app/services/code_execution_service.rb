class CodeExecutionService
  attr_reader :exercise, :code

  ErrorResult = Struct.new(:success, :output, :errors, :test_results, :execution_time, keyword_init: true)

  def initialize(exercise:, code:)
    @exercise = exercise
    @code = code
  end

  def execute
    return error_result("No code provided") if code.blank?

    sandbox.execute
  end

  def self.call(exercise:, code:)
    new(exercise: exercise, code: code).execute
  end

  private

  def sandbox
    sandbox_class.new(
      user_code: code,
      test_code: exercise.test_code
    )
  end

  def sandbox_class
    ENV["USE_DOCKER_SANDBOX"] == "true" ? DockerSandboxService : RubySandboxService
  end

  def error_result(message)
    ErrorResult.new(
      success: false,
      output: "",
      errors: [message],
      test_results: [],
      execution_time: 0
    )
  end
end
