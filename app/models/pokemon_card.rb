class PokemonCard < Data.define(:id, :name, :image_url)
  def self.search(name)
    cards = Rails.cache.fetch([ "pokemon_cards", name ], expires_in: 1.day, skip_nil: true) do
      JsonApi.get("https://api.tcgdex.net/v2/en/cards", params: { name: })&.filter_map do |card|
        new(id: card["id"], name: card["name"], image_url: "#{card["image"]}/high.webp") if card["image"]
      end
    end

    cards || []
  end
end
