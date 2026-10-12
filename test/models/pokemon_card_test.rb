require "test_helper"

class PokemonCardTest < ActiveSupport::TestCase
  test "search returns cards that have artwork" do
    stub_request(:get, "https://api.tcgdex.net/v2/en/cards?name=Mr.%20Mime").to_return_json(body: [
      { id: "base2-6", name: "Mr. Mime", image: "https://assets.tcgdex.net/en/base/base2/6" },
      { id: "promo-1", name: "Mr. Mime" }
    ])

    cards = PokemonCard.search("Mr. Mime")

    assert_equal [ PokemonCard.new(id: "base2-6", name: "Mr. Mime", image_url: "https://assets.tcgdex.net/en/base/base2/6/high.webp") ], cards
  end

  test "search returns no cards when TCGdex is unavailable" do
    stub_request(:get, ApiStubs::CARDS_URL).to_return(status: 500)

    assert_empty PokemonCard.search("Pikachu")
  end
end
