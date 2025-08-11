import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button", "mobileMenu"]

  connect() {
    // Close dropdown when clicking outside
    this.clickOutsideHandler = this.clickOutside.bind(this)
    document.addEventListener("click", this.clickOutsideHandler)
  }

  disconnect() {
    document.removeEventListener("click", this.clickOutsideHandler)
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()

    if (this.hasMenuTarget) {
      this.menuTarget.classList.toggle("hidden")
    }

    if (this.hasMobileMenuTarget) {
      this.mobileMenuTarget.classList.toggle("hidden")
    }
  }

  clickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  close() {
    if (this.hasMenuTarget) {
      this.menuTarget.classList.add("hidden")
    }

    if (this.hasMobileMenuTarget) {
      this.mobileMenuTarget.classList.add("hidden")
    }
  }
}
