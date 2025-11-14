class PokemonsController < ApplicationController
  def index
    pokemon = FetchPokemon.fetch_by_id("#{rand(1025)}")
    @pokemon_image = pokemon["sprites"]["other"]["official-artwork"]["front_default"]
    @pokemon_name = pokemon["name"]
  end
end
