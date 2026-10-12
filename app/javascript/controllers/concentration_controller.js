import { Controller } from "@hotwired/stimulus";

const MISMATCH_DELAY = 1000;
const FLIP_DURATION = 500;

export default class extends Controller {
  static targets = ["card", "moves", "matches", "victory"];

  connect() {
    this.moves = 0;
    this.matches = 0;
    this.locked = false;
  }

  flip({ currentTarget: card }) {
    if (this.locked || card.hasAttribute("data-face-up")) return;

    this.#turnFaceUp(card);

    const unmatched = this.cardTargets.filter(
      (target) => target.hasAttribute("data-face-up") && !target.hasAttribute("data-matched")
    );
    if (unmatched.length < 2) return;

    this.#countMove();

    const [first, second] = unmatched;
    if (first.dataset.cardId === second.dataset.cardId) {
      this.#match(first, second);
    } else {
      this.locked = true;
      setTimeout(() => {
        this.#turnFaceDown(first);
        this.#turnFaceDown(second);
        this.locked = false;
      }, MISMATCH_DELAY);
    }
  }

  #turnFaceUp(card) {
    card.toggleAttribute("data-face-up", true);
    card.setAttribute("aria-label", card.dataset.cardLabel);
  }

  #turnFaceDown(card) {
    card.removeAttribute("data-face-up");
    card.setAttribute("aria-label", "Face-down card");
  }

  #match(...cards) {
    cards.forEach((card) => {
      card.toggleAttribute("data-matched", true);
      card.setAttribute("aria-disabled", "true");
    });

    this.matches++;
    this.matchesTarget.textContent = this.matches;

    if (this.matches === this.cardTargets.length / 2) {
      setTimeout(() => this.victoryTarget.showModal(), FLIP_DURATION);
    }
  }

  #countMove() {
    this.moves++;
    this.movesTargets.forEach((target) => (target.textContent = this.moves));
  }
}
