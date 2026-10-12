class Pokemon < Data.define(:id, :name, :image_url, :types, :flavor_text)
  SPECIES_COUNT = 1025

  def self.random
    find(rand(1..SPECIES_COUNT))
  end

  def self.find(id)
    Rails.cache.fetch([ "pokemon", id ], expires_in: 1.week, skip_nil: true) do
      pokemon = JsonApi.get("https://pokeapi.co/api/v2/pokemon/#{id}")
      species = JsonApi.get("https://pokeapi.co/api/v2/pokemon-species/#{id}")

      from_api(pokemon, species) if pokemon && species
    end
  end

  def self.from_api(pokemon, species)
    image_url = pokemon.dig("sprites", "other", "official-artwork", "front_default") || pokemon.dig("sprites", "front_default")
    return unless image_url

    new(
      id: species["id"],
      name: in_english(species["names"])&.dig("name") || species["name"].titleize,
      image_url:,
      types: pokemon.fetch("types", []).map { |slot| slot.dig("type", "name") },
      flavor_text: in_english(species["flavor_text_entries"].to_a.reverse)&.dig("flavor_text")&.squish
    )
  end

  def self.in_english(entries)
    entries.to_a.find { |entry| entry.dig("language", "name") == "en" }
  end

  private_class_method :from_api, :in_english

  def correct_guess?(answer)
    normalize(answer) == normalize(name)
  end

  def cards
    PokemonCard.search(name)
  end

  private
    def normalize(text)
      I18n.transliterate(text.to_s).downcase.gsub(/[^a-z0-9]/, "")
    end
end
