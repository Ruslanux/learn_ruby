import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon", "button"]

  connect() {
    this.isOpen = false
    // On large screens, always show content
    this.checkScreenSize()
    window.addEventListener("resize", this.checkScreenSize.bind(this))
  }

  disconnect() {
    window.removeEventListener("resize", this.checkScreenSize.bind(this))
  }

  checkScreenSize() {
    // lg breakpoint is 1024px
    if (window.innerWidth >= 1024) {
      this.contentTarget.classList.remove("hidden")
      this.contentTarget.classList.add("lg:block")
    } else if (!this.isOpen) {
      this.contentTarget.classList.add("hidden")
    }
  }

  toggle() {
    // Only toggle on mobile/tablet
    if (window.innerWidth >= 1024) return

    this.isOpen = !this.isOpen

    if (this.isOpen) {
      this.contentTarget.classList.remove("hidden")
      if (this.hasIconTarget) {
        this.iconTarget.classList.add("rotate-180")
      }
    } else {
      this.contentTarget.classList.add("hidden")
      if (this.hasIconTarget) {
        this.iconTarget.classList.remove("rotate-180")
      }
    }
  }
}
