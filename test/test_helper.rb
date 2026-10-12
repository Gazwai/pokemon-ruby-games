ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock"
# The HTTPX adapter has to be registered before webmock/minitest enables WebMock, or HTTPX requests go out for real.
require "httpx/adapters/webmock"
require "webmock/minitest"

module ApiStubs
  POKEMON_URL = %r{\Ahttps://pokeapi\.co/api/v2/pokemon/\d+\z}
  SPECIES_URL = %r{\Ahttps://pokeapi\.co/api/v2/pokemon-species/\d+\z}
  CARDS_URL = %r{\Ahttps://api\.tcgdex\.net/v2/en/cards}

  def stub_pokemon(id: 25, name: "Pikachu", types: %w[electric], flavor_text: "It stores electricity in its cheeks.")
    stub_request(:get, POKEMON_URL).to_return_json(pokemon_response(id:, types:))
    stub_request(:get, SPECIES_URL).to_return_json(species_response(id:, name:, flavor_text:))
  end

  def pokemon_response(id: 25, types: %w[electric])
    { body: {
      id:,
      sprites: { other: { "official-artwork": { front_default: "https://img.example/#{id}.png" } } },
      types: types.map { |type| { type: { name: type } } }
    } }
  end

  def species_response(id: 25, name: "Pikachu", flavor_text: "It stores electricity in its cheeks.")
    { body: {
      id:,
      name: name.parameterize,
      names: [ { name:, language: { name: "en" } } ],
      flavor_text_entries: [ { flavor_text:, language: { name: "en" } } ]
    } }
  end

  def stub_pokedex_outage
    stub_request(:get, POKEMON_URL).to_return(status: 503)
    stub_request(:get, SPECIES_URL).to_return(status: 503)
  end

  def cards_response(count, name: "Pikachu")
    { body: Array.new(count) { |index| { id: "set-#{index}", name:, image: "https://cards.example/set/#{index}" } } }
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    include ApiStubs
  end
end
