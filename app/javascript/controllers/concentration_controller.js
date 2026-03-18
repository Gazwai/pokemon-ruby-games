import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="concentration"
export default class extends Controller {
  static targets = ["card"];

  connect() {
    this.locked = false;
  }

  check(event) {
    const clickedCard = event.currentTarget;

    if (this.locked) return;
    if (clickedCard.classList.contains("selected")) return;
    if (clickedCard.classList.contains("matched")) return;

    const selectedCards = this.cardTargets.filter((card) =>
      card.classList.contains("selected")
    );

    if (selectedCards.length === 0) {
      clickedCard.classList.add("selected");
    } else if (selectedCards.length === 1) {
      clickedCard.classList.add("selected");

      const first = selectedCards[0];
      const second = clickedCard;

      if (first.dataset.attributeId === second.dataset.attributeId) {
        first.classList.add("matched");
        second.classList.add("matched");
        first.classList.remove("selected");
        second.classList.remove("selected");
      } else {
        this.locked = true;
        setTimeout(() => {
          first.classList.remove("selected");
          second.classList.remove("selected");
          this.locked = false;
        }, 1000);
      }
    }
  }
}
