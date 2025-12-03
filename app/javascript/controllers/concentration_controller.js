import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="concentration"
export default class extends Controller {
  static targets = ["card"];

  check(event) {
    const selectedCard = this.cardTargets.filter((card) =>
      card.classList.contains("selected")
    );

    switch (selectedCard.length) {
      case 0:
        event.currentTarget.classList = "selected";
        break;
      case 1:
        event.currentTarget.classList = "selected";

        const first = selectedCard[0];
        const second = event.currentTarget;

        if (first.dataset.attributeId === second.dataset.attributeId) {
          second.classList = "matched";
          first.classList = "matched";
        } else {
          setTimeout((event) => {
            second.classList = "";
            first.classList = "";
          }, 1000);
        }
        break;

      default:
        break;
    }

    if (selectedCard.length === 0) {
      event.currentTarget.classList = "selected";
    }
  }
}
