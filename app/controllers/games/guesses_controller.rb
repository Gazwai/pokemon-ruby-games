class Games::GuessesController < ApplicationController
  def index
    @pokemon = Pokemon.random

    if @pokemon
      session[:pokemon_id] = @pokemon.id
    else
      redirect_to root_path, alert: "Couldn't reach the Pokédex. Please try again."
    end
  end

  def guess
    pokemon_id = session.delete(:pokemon_id)
    @pokemon = Pokemon.find(pokemon_id) if pokemon_id

    unless @pokemon
      redirect_to games_guess_that_pokemon_path, status: :see_other, notice: "That round has ended. Here's a new Pokémon."
      return
    end

    @answer = params.expect(guess: [ :user_answer ])[:user_answer]
    @correct = @pokemon.correct_guess?(@answer)

    respond_to do |format|
      format.turbo_stream
      format.html { render :index }
    end
  end
end
