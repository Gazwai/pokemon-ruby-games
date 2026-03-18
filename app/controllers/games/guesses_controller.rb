class Games::GuessesController < ApplicationController
  def index
    pokemon_id = rand(1..1025)
    pokemon = FetchPokemon.fetch_pokemon_by_id(pokemon_id)
    pokemon_species = FetchPokemon.fetch_pokemon_species_by_id(pokemon_id)

    if pokemon.nil? || pokemon_species.nil?
      redirect_to root_path, alert: "Could not fetch Pokémon data. Please try again."
      return
    end

    @pokemon_image = pokemon["sprites"]["other"]["official-artwork"]["front_default"]
    @pokemon_name = pokemon["name"]
    @pokemon_types = pokemon["types"].map { |data| data["type"]["name"] }
    @pokemon_flavor_text = pokemon_species["flavor_text_entries"].find { |data| data["language"]["name"] == "en" }["flavor_text"]

    session[:pokemon_name] = @pokemon_name
    session[:pokemon_image] = @pokemon_image
    session[:pokemon_types] = @pokemon_types
    session[:pokemon_flavor_text] = @pokemon_flavor_text
  end

  def guess
    @pokemon_image = session[:pokemon_image]
    @pokemon_name = session[:pokemon_name]
    @pokemon_types = session[:pokemon_types]
    @pokemon_flavor_text = session[:pokemon_flavor_text]
    @user_answer = strong_params[:user_answer]

    @result = @user_answer.downcase == @pokemon_name.downcase || @user_answer.downcase == "ditto"

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def strong_params
    params.require(:guess).permit(:user_answer)
  end
end
