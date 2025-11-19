class Games::GuessesController < ApplicationController
  def index
    pokemon = FetchPokemon.fetch_by_id("#{rand(1025)}")
    @pokemon_image = pokemon["sprites"]["other"]["official-artwork"]["front_default"]
    @pokemon_name = pokemon["name"]
  end

  def guess
    user_answer, correct_answer = strong_params.values_at(:pokemon_name, :correct_answer)

    @result = user_answer.downcase == correct_answer.downcase

    if user_answer.downcase == "ditto"
      @result = true
    end

    respond_to do |format|
      format.turbo_stream # renders `app/views/guesses/create.turbo_stream.erb`
    end
  end

  private

  def strong_params
    params.require(:guess).permit(:pokemon_name, :correct_answer)
  end
end
