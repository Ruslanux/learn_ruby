import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editor", "hints"]
  static values = {
    initialCode: String
  }

  connect() {
    this.initializeEditorWhenReady()
  }

  disconnect() {
    // Clean up editor on disconnect (for Turbo navigation)
    if (this.editor) {
      this.editor.toTextArea && this.editor.toTextArea()
      this.editor = null
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
    // Don't reinitialize if editor already exists
    if (this.editor) return

    // Decode base64 initial code
    let initialCode = ""
    try {
      initialCode = atob(this.initialCodeValue)
    } catch (e) {
      console.error("Failed to decode initial code:", e)
      initialCode = "# Your code here"
    }

    // Clear the target element first
    this.editorTarget.innerHTML = ""

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

  runTests() {
    // Dispatch event to test runner
    this.dispatch("run", { detail: { code: this.getCode() } })
  }
}
