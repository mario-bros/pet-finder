import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "indicator"]
  static values = { currentIndex: Number }

  connect() {
    this.currentIndexValue = 0
    this.totalSlides = this.slideTargets.length
  }

  next() {
    this.currentIndexValue = (this.currentIndexValue + 1) % this.totalSlides
    this.updateSlides()
  }

  previous() {
    this.currentIndexValue = (this.currentIndexValue - 1 + this.totalSlides) % this.totalSlides
    this.updateSlides()
  }

  goToSlide(event) {
    this.currentIndexValue = parseInt(event.target.dataset.slideIndex)
    this.updateSlides()
  }

  updateSlides() {
    this.slideTargets.forEach((slide, index) => {
      if (index === this.currentIndexValue) {
        slide.classList.remove('opacity-0')
        slide.classList.add('opacity-100')
      } else {
        slide.classList.remove('opacity-100')
        slide.classList.add('opacity-0')
      }
    })

    this.indicatorTargets.forEach((indicator, index) => {
      if (index === this.currentIndexValue) {
        indicator.classList.remove('bg-gray-400')
        indicator.classList.add('bg-white')
      } else {
        indicator.classList.remove('bg-white')
        indicator.classList.add('bg-gray-400')
      }
    })
  }
}
