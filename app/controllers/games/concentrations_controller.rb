class Games::ConcentrationsController < ApplicationController
  def index
    pokemon_id = rand(1025)
    pokemon_name = FetchPokemon.fetch_pokemon_by_id("#{pokemon_id}")["name"]

    pokemon_cards = FetchPokemonCard.fetch_pokemon_by_name("#{pokemon_name}")
    filtered_pokemon_cards = pokemon_cards.filter { |card| card["image"] }

    @chosen_cards = filtered_pokemon_cards.take(4)

    @shuffled_cards = [@chosen_cards, @chosen_cards].flatten.shuffle
  end
end
