class Games::GuessesController < ApplicationController
  def index
    pokemon_id = rand(1025)
    pokemon = FetchPokemon.fetch_pokemon_by_id("#{pokemon_id}")
    pokemon_species = FetchPokemon.fetch_pokemon_species_by_id("#{pokemon_id}")
    @pokemon_image = pokemon["sprites"]["other"]["official-artwork"]["front_default"]
    @pokemon_name = pokemon["name"]
    @pokemon_types = pokemon["types"].map { |data| data["type"]["name"] }
    @pokemon_flavor_text = pokemon_species["flavor_text_entries"].find { |data| data["language"]["name"] == "en" }["flavor_text"]
  end

  def guess
    @pokemon_image = strong_params[:image]
    @pokemon_name = strong_params[:pokemon_name]
    @pokemon_types = strong_params[:types].split(",")
    @pokemon_flavor_text = strong_params[:flavor_text]
    @user_answer = strong_params[:user_answer]

    @result = @user_answer.downcase == @pokemon_name.downcase

    if @user_answer.downcase == "ditto"
      @result = true
    end

    respond_to do |format|
      format.turbo_stream # renders `app/views/guesses/create.turbo_stream.erb`
    end
  end

  private

  def strong_params
    params.require(:guess).permit(:pokemon_name, :user_answer, :image, :types, :flavor_text)
  end
end
