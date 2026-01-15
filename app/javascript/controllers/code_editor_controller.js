import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editor", "hints", "solution", "solutionButton"]
  static values = {
    initialCode: String
  }

  connect() {
    // Store current code before Turbo cache
    document.addEventListener("turbo:before-cache", this.beforeCache.bind(this))
    this.initializeEditorWhenReady()
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.beforeCache.bind(this))
    // Don't destroy editor on disconnect - let Turbo handle it
  }

  beforeCache() {
    // Save current code to a data attribute before caching
    if (this.editor) {
      this.editorTarget.dataset.savedCode = this.editor.getValue()
    }
  }

  initializeEditorWhenReady() {
    // Check if CodeMirror is loaded
    if (typeof CodeMirror === "undefined") {
      // Retry after a short delay
      setTimeout(() => this.initializeEditorWhenReady(), 50)
      return
    }

    // Use requestAnimationFrame to ensure DOM is ready
    requestAnimationFrame(() => {
      this.initializeEditor()
    })
  }

  initializeEditor() {
    // Check if CodeMirror already exists in this element
    const existingCM = this.editorTarget.querySelector(".CodeMirror")
    if (existingCM) {
      // Try to get existing CodeMirror instance
      if (existingCM.CodeMirror) {
        this.editor = existingCM.CodeMirror
        this.element.codeEditor = this
        return
      }
      // Remove stale CodeMirror element
      existingCM.remove()
    }

    // Get initial code - prefer saved code (from Turbo cache), then initial value
    let initialCode = ""
    if (this.editorTarget.dataset.savedCode) {
      initialCode = this.editorTarget.dataset.savedCode
      delete this.editorTarget.dataset.savedCode
    } else {
      try {
        initialCode = atob(this.initialCodeValue)
      } catch (e) {
        console.error("Failed to decode initial code:", e)
        initialCode = "# Your code here"
      }
    }

    // Initialize CodeMirror
    this.editor = CodeMirror(this.editorTarget, {
      value: initialCode,
      mode: "ruby",
      theme: "dracula",
      lineNumbers: true,
      indentUnit: 2,
      tabSize: 2,
      indentWithTabs: false,
      lineWrapping: true,
      matchBrackets: true,
      autoCloseBrackets: true,
      extraKeys: {
        "Tab": (cm) => {
          if (cm.somethingSelected()) {
            cm.indentSelection("add")
          } else {
            cm.replaceSelection("  ", "end")
          }
        },
        "Shift-Tab": (cm) => {
          cm.indentSelection("subtract")
        },
        "Cmd-Enter": () => this.runTests(),
        "Ctrl-Enter": () => this.runTests()
      }
    })

    // Force refresh to ensure proper rendering
    setTimeout(() => {
      if (this.editor) {
        this.editor.refresh()
      }
    }, 10)

    // Make editor accessible to other controllers
    this.element.codeEditor = this
  }

  getCode() {
    return this.editor ? this.editor.getValue() : ""
  }

  setCode(code) {
    if (this.editor) {
      this.editor.setValue(code)
    }
  }

  reset() {
    if (confirm("Reset code to starter code? Your changes will be lost.")) {
      try {
        const initialCode = atob(this.initialCodeValue)
        this.setCode(initialCode)
      } catch (e) {
        console.error("Failed to decode initial code:", e)
      }
    }
  }

  toggleHints() {
    if (this.hasHintsTarget) {
      this.hintsTarget.classList.toggle("hidden")
    }
  }

  toggleSolution() {
    if (this.hasSolutionTarget && this.hasSolutionButtonTarget) {
      const isHidden = this.solutionTarget.classList.toggle("hidden")
      const showText = this.solutionButtonTarget.dataset.showText
      const hideText = this.solutionButtonTarget.dataset.hideText
      this.solutionButtonTarget.textContent = isHidden ? showText : hideText
    }
  }

  runTests() {
    // Dispatch event to test runner
    this.dispatch("run", { detail: { code: this.getCode() } })
  }
}
