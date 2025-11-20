import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Hello");

    this.element.querySelector(".guess_user_answer input").focus();
  }
}
