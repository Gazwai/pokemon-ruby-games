require "httpx"

class FetchPokemonCard
  def self.fetch_pokemon_by_name(name)
    response = HTTPX.get("https://api.tcgdex.net/v2/en/cards?name=#{name}")

    response.json
  rescue => e
    Rails.logger.error "Error fetching Pokémon Card #{name}: #{e.message}"
    nil
  end
end
