class Games::ConcentrationsController < ApplicationController
  PAIRS = 6
  ATTEMPTS = 5

  def index
    ATTEMPTS.times do
      @pokemon = Pokemon.random
      next unless @pokemon

      cards = @pokemon.cards
      next if cards.size < PAIRS

      @cards = cards.sample(PAIRS).flat_map { |card| [ card, card ] }.shuffle
      return
    end

    redirect_to root_path, alert: "Couldn't deal a hand of Pokémon cards. Please try again."
  end
end
