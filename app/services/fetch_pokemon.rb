require "httpx"

class FetchPokemon
  def self.fetch_pokemon_by_id(id)
    response = HTTPX.get("https://pokeapi.co/api/v2/pokemon/#{id}")

    response.json
  rescue => e
    Rails.logger.error "Error fetching Pokémon #{id}: #{e.message}"
    nil
  end

  def self.fetch_pokemon_species_by_id(id)
    response = HTTPX.get("https://pokeapi.co/api/v2/pokemon-species/#{id}")

    response.json
  rescue => e
    Rails.logger.error "Error fetching Pokémon #{id}: #{e.message}"
    nil
  end
end
