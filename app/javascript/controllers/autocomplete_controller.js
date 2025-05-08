import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.suggestions = this.inputTarget.dataset.autocompleteSource
      ? JSON.parse(this.inputTarget.dataset.autocompleteSource)
      : []
    this.dropdown = null

    this.inputTarget.addEventListener("input", this.showSuggestions.bind(this))
    this.inputTarget.addEventListener("blur", this.closeDropdown.bind(this))
  }

  showSuggestions(event) {
    const value = event.target.value.toLowerCase()
    this.closeDropdown()

    if (!value) return

    const matches = this.suggestions.filter(item =>
      item.toLowerCase().includes(value)
    )

    if (matches.length === 0) return

    this.dropdown = document.createElement("ul")
    this.dropdown.className = "autocomplete-dropdown"
    this.dropdown.style.position = "absolute"
    this.dropdown.style.zIndex = "1000"
    this.dropdown.style.background = "white"
    this.dropdown.style.border = "1px solid #ccc"
    this.dropdown.style.listStyle = "none"
    this.dropdown.style.padding = "0"
    this.dropdown.style.margin = "0"
    this.dropdown.style.width = this.inputTarget.offsetWidth + "px"

    matches.forEach(match => {
      const item = document.createElement("li")
      item.textContent = match
      item.style.padding = "0.5em"
      item.style.cursor = "pointer"
      item.addEventListener("mousedown", (e) => {
        e.preventDefault() // Prevent blur event
        this.inputTarget.value = match
        this.closeDropdown()
      })
      this.dropdown.appendChild(item)
    })

    // Position dropdown
    const rect = this.inputTarget.getBoundingClientRect()
    this.dropdown.style.left = rect.left + window.scrollX + "px"
    this.dropdown.style.top = rect.bottom + window.scrollY + "px"

    document.body.appendChild(this.dropdown)
  }

  closeDropdown() {
    if (this.dropdown) {
      this.dropdown.remove()
      this.dropdown = null
    }
  }
}
