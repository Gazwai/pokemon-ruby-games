class Games::ConcentrationsController < ApplicationController
  def index
    pokemon_id = rand(1..1025)
    pokemon = FetchPokemon.fetch_pokemon_by_id(pokemon_id)

    if pokemon.nil?
      redirect_to root_path, alert: "Could not fetch Pokémon data. Please try again."
      return
    end

    pokemon_cards = FetchPokemonCard.fetch_pokemon_by_name(pokemon["name"])

    if pokemon_cards.nil?
      redirect_to root_path, alert: "Could not fetch Pokémon cards. Please try again."
      return
    end

    filtered_pokemon_cards = pokemon_cards.filter { |card| card["image"] }

    if filtered_pokemon_cards.length < 6
      redirect_to games_concentrations_path
      return
    end

    @chosen_cards = filtered_pokemon_cards.take(6)
    @shuffled_cards = [ @chosen_cards, @chosen_cards ].flatten.shuffle
  end
end
