import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  connect() {
    this.isOpen = false
  }

  toggle() {
    this.isOpen = !this.isOpen
    this.updateMenu()
  }

  close() {
    this.isOpen = false
    this.updateMenu()
  }

  updateMenu() {
    if (this.isOpen) {
      this.sidebarTarget.classList.remove("-translate-x-full")
      this.overlayTarget.classList.remove("hidden")
    } else {
      this.sidebarTarget.classList.add("-translate-x-full")
      this.overlayTarget.classList.add("hidden")
    }
  }
}
