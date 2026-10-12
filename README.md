# Pokémon Games

A collection of Pokémon-themed mini-games built with Ruby on Rails 8 and Hotwire.

---

## Games

* **Guess That Pokémon:** name a random Pokémon from its silhouette. Capitalisation, spacing, punctuation and accents don't matter, so `mr mime` counts for Mr. Mime.
* **Concentration:** flip trading cards two at a time to find six matching pairs, tracking your moves as you go.

---

## Description

The games use **Hotwire** (Turbo Streams and Stimulus) for SPA-like interactions without a JavaScript build step. The UI is styled with **Tailwind CSS 4** and **daisyUI 5**, compiled by `tailwindcss-rails` with daisyUI vendored as a plugin in `app/assets/tailwind`. Pokémon data comes from **PokéAPI** and card art from **TCGdex**, fetched with **HTTPX** and cached with Solid Cache.

---

## Getting Started

### Dependencies

* **Ruby** 3.3 (see `.ruby-version`)
* **Rails** 8.1

### Installing

1.  **Clone the repository:**
    ```bash
    gh repo clone Gazwai/pokemon-ruby-games
    cd pokemon-ruby-games
    ```
2.  **Install dependencies and prepare the app:**
    ```bash
    bin/setup --skip-server
    ```

### Executing program

1.  **Start the server and the Tailwind watcher:**
    ```bash
    bin/dev
    ```
2.  **Open browser:**
    ```
    http://localhost:3000
    ```

### Running the checks

```bash
bin/rails test        # API calls are stubbed with WebMock
bin/rubocop
bin/brakeman
```

### Updating daisyUI

daisyUI is vendored rather than loaded from a CDN. To upgrade it, download the latest bundle over the existing files:

```bash
cd app/assets/tailwind
curl -sLO https://github.com/saadeghi/daisyui/releases/latest/download/daisyui.mjs
curl -sLO https://github.com/saadeghi/daisyui/releases/latest/download/daisyui-theme.mjs
```

---

## Authors

[Gary Yau](https://gazwai.github.io/portfolio/)

---

## Version History

* **0.2:** Concentration game, Pokédex-themed restyle, cached API calls and a working test suite.
* **0.1:** Initial Release with "Guess that pokemon" game and core setup.

---

## License

This project is licensed under the **MIT** License - see the **LICENSE.md** file for details

---

## Acknowledgments

* **PokéAPI:** Source for all Pokémon data.
* **TCGdex:** Source for all trading card images.
* **Tailwind CSS** & **daisyUI:** Frontend styling.
* **Hotwire** (Turbo, Stimulus): Frontend interactivity.
