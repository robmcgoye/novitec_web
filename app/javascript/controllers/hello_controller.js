import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("HelloController connected");
    this.element.textContent = "Hello World!";
  }
}
