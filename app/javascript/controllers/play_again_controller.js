import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  play(event) {
    if (event.repeat) return;

    this.element.click();
  }
}
