import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "time"]

  connect() {
    this.seconds = 0
    this.startTimer()
  }

  disconnect() {
    this.stopTimer()
  }

  startTimer() {
    this.interval = setInterval(() => {
      this.seconds++
      this.updateDisplay()
    }, 1000)
  }

  stopTimer() {
    if (this.interval) {
      clearInterval(this.interval)
      this.interval = null
    }
  }

  updateDisplay() {
    if (this.hasTimeTarget) {
      const minutes = Math.floor(this.seconds / 60)
      const secs = this.seconds % 60
      this.timeTarget.textContent = `${this.pad(minutes)}:${this.pad(secs)}`
    }
  }

  pad(num) {
    return num.toString().padStart(2, "0")
  }

  getElapsedSeconds() {
    return this.seconds
  }

  reset() {
    this.seconds = 0
    this.updateDisplay()
  }
}
