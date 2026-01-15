import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "runButton",
    "submitButton",
    "attempts",
    "resultsHeader",
    "resultsStatus",
    "resultsBody"
  ]
  static values = {
    runUrl: String,
    submitUrl: String
  }

  connect() {
    this.isRunning = false
  }

  getCode() {
    const codeEditor = this.element.codeEditor
    return codeEditor ? codeEditor.getCode() : ""
  }

  async run() {
    if (this.isRunning) return
    await this.executeTests(this.runUrlValue, false)
  }

  async submit() {
    if (this.isRunning) return
    await this.executeTests(this.submitUrlValue, true)
  }

  async executeTests(url, isSubmit) {
    const code = this.getCode()
    if (!code.trim()) {
      this.showError("Please write some code before running tests.")
      return
    }

    this.isRunning = true
    this.setButtonsLoading(true)
    this.showLoading()

    try {
      const response = await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.getCSRFToken(),
          "Accept": "application/json"
        },
        body: JSON.stringify({ code: code })
      })

      const result = await response.json()

      if (response.ok) {
        this.displayResults(result, isSubmit)
        if (result.attempts !== undefined) {
          this.updateAttempts(result.attempts)
        }
      } else {
        this.showError(result.error || "An error occurred while running tests.")
      }
    } catch (error) {
      console.error("Test execution error:", error)
      this.showError("Failed to connect to the server. Please try again.")
    } finally {
      this.isRunning = false
      this.setButtonsLoading(false)
    }
  }

  displayResults(result, isSubmit) {
    try {
      const { success, output, errors, test_results, execution_time } = result

      // Update header
      if (success) {
        this.resultsHeaderTarget.className = "px-3 py-2 bg-green-100 border-b flex items-center justify-between"
        this.resultsStatusTarget.className = "text-xs text-green-700 font-medium"
        this.resultsStatusTarget.textContent = isSubmit ? "All tests passed! Solution submitted." : "All tests passed!"
      } else {
        this.resultsHeaderTarget.className = "px-3 py-2 bg-red-100 border-b flex items-center justify-between"
        this.resultsStatusTarget.className = "text-xs text-red-700 font-medium"
        this.resultsStatusTarget.textContent = "Some tests failed"
      }

      // Build results HTML
      let html = ""

      if (execution_time) {
        html += `<div class="text-gray-400 text-xs mb-3">Execution time: ${execution_time.toFixed(3)}s</div>`
      }

      // Handle errors - ensure it's an array
      const errorsArray = Array.isArray(errors) ? errors : (errors ? [errors] : [])
      if (errorsArray.length > 0 && errorsArray.some(e => e)) {
        html += `<div class="bg-red-900/50 text-red-300 p-3 rounded mb-3 whitespace-pre-wrap">${this.escapeHtml(errorsArray.filter(e => e).join("\n"))}</div>`
      }

      // Handle test results
      const examples = test_results?.examples || []
      if (examples.length > 0) {
        const passed = examples.filter(e => e.status === "passed").length
        const failed = examples.filter(e => e.status === "failed").length

        html += `<div class="mb-2 flex items-center space-x-3 text-xs">
          <span class="text-green-400">${passed} passed</span>
          <span class="text-red-400">${failed} failed</span>
        </div>`

        html += `<div class="space-y-1.5">`
        examples.forEach(example => {
          const icon = example.status === "passed" ? "text-green-400" : "text-red-400"
          const bgColor = example.status === "passed" ? "bg-green-900/30" : "bg-red-900/30"
          const statusIcon = example.status === "passed" ? "&#10003;" : "&#10007;"

          html += `<div class="p-2 rounded ${bgColor}">
            <div class="flex items-start">
              <span class="${icon} mr-1.5">${statusIcon}</span>
              <div class="flex-1">
                <div class="text-xs text-gray-200">${this.escapeHtml(example.full_description || "")}</div>
                ${example.status === "failed" && example.exception?.message ? `
                  <div class="mt-1 text-xs text-red-300 whitespace-pre-wrap">${this.escapeHtml(example.exception.message)}</div>
                ` : ""}
              </div>
            </div>
          </div>`
        })
        html += `</div>`
      }

      if (output) {
        html += `<div class="mt-2 p-2 bg-gray-800 rounded">
          <div class="text-xs text-gray-500 mb-1">Output:</div>
          <pre class="whitespace-pre-wrap text-xs text-gray-300">${this.escapeHtml(output)}</pre>
        </div>`
      }

      if (!html) {
        html = `<div class="text-gray-400 text-center py-4">No results to display</div>`
      }

      this.resultsBodyTarget.innerHTML = html

      // Handle success animation for submit
      if (isSubmit && success) {
        this.showSuccessAnimation()
      }
    } catch (error) {
      console.error("Error displaying results:", error)
      this.showError("Error displaying results: " + error.message)
    }
  }

  showLoading() {
    this.resultsHeaderTarget.className = "px-3 py-2 bg-blue-100 border-b flex items-center justify-between"
    this.resultsStatusTarget.className = "text-xs text-blue-700"
    this.resultsStatusTarget.textContent = "Running tests..."
    this.resultsBodyTarget.innerHTML = `
      <div class="flex items-center justify-center py-6 bg-gray-900">
        <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-blue-400"></div>
        <span class="ml-3 text-blue-400 text-sm">Executing your code...</span>
      </div>
    `
  }

  showError(message) {
    this.resultsHeaderTarget.className = "px-3 py-2 bg-red-50 border-b flex items-center justify-between"
    this.resultsStatusTarget.className = "text-xs text-red-600 font-medium"
    this.resultsStatusTarget.textContent = "Error"
    this.resultsBodyTarget.innerHTML = `
      <div class="bg-red-100 text-red-800 p-3 rounded-lg text-sm">
        ${this.escapeHtml(message)}
      </div>
    `
  }

  showSuccessAnimation() {
    // Create confetti-like animation
    const colors = ["#ef4444", "#f59e0b", "#10b981", "#3b82f6", "#8b5cf6"]
    for (let i = 0; i < 30; i++) {
      const confetti = document.createElement("div")
      confetti.className = "fixed pointer-events-none"
      confetti.style.cssText = `
        width: 10px;
        height: 10px;
        background: ${colors[Math.floor(Math.random() * colors.length)]};
        border-radius: 50%;
        left: ${50 + (Math.random() - 0.5) * 40}%;
        top: 50%;
        opacity: 1;
        transition: all 1s ease-out;
        z-index: 9999;
      `
      document.body.appendChild(confetti)

      setTimeout(() => {
        confetti.style.transform = `translate(${(Math.random() - 0.5) * 400}px, ${-200 - Math.random() * 200}px) rotate(${Math.random() * 720}deg)`
        confetti.style.opacity = "0"
      }, 10)

      setTimeout(() => confetti.remove(), 1100)
    }
  }

  updateAttempts(count) {
    if (this.hasAttemptsTarget) {
      this.attemptsTarget.textContent = `${count} attempts`
    }
  }

  setButtonsLoading(loading) {
    if (this.hasRunButtonTarget) {
      this.runButtonTarget.disabled = loading
      if (loading) {
        this.runButtonTarget.classList.add("opacity-50", "cursor-not-allowed")
      } else {
        this.runButtonTarget.classList.remove("opacity-50", "cursor-not-allowed")
      }
    }
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = loading
      if (loading) {
        this.submitButtonTarget.classList.add("opacity-50", "cursor-not-allowed")
      } else {
        this.submitButtonTarget.classList.remove("opacity-50", "cursor-not-allowed")
      }
    }
  }

  getCSRFToken() {
    const meta = document.querySelector('meta[name="csrf-token"]')
    return meta ? meta.content : ""
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}
