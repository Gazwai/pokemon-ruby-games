require "test_helper"

class PokemonTest < ActiveSupport::TestCase
  test "find builds a pokemon from the pokemon and species endpoints" do
    stub_pokemon(id: 122, name: "Mr. Mime", types: %w[psychic fairy], flavor_text: "If interrupted while\nmiming,\fit will slap the offender.")

    pokemon = Pokemon.find(122)

    assert_equal 122, pokemon.id
    assert_equal "Mr. Mime", pokemon.name
    assert_equal "https://img.example/122.png", pokemon.image_url
    assert_equal %w[psychic fairy], pokemon.types
    assert_equal "If interrupted while miming, it will slap the offender.", pokemon.flavor_text
  end

  test "find uses the newest English flavor text" do
    stub_pokemon
    stub_request(:get, ApiStubs::SPECIES_URL).to_return_json(body: {
      id: 25,
      name: "pikachu",
      names: [ { name: "Pikachu", language: { name: "en" } } ],
      flavor_text_entries: [
        { flavor_text: "Old POKéMON text.", language: { name: "en" } },
        { flavor_text: "Newer Pokémon text.", language: { name: "en" } },
        { flavor_text: "Texte récent.", language: { name: "fr" } }
      ]
    })

    assert_equal "Newer Pokémon text.", Pokemon.find(25).flavor_text
  end

  test "find returns nil when the Pokédex is unavailable" do
    stub_pokedex_outage

    assert_nil Pokemon.find(25)
  end

  test "find returns nil when the Pokédex times out" do
    stub_request(:get, ApiStubs::POKEMON_URL).to_timeout
    stub_request(:get, ApiStubs::SPECIES_URL).to_timeout

    assert_nil Pokemon.find(25)
  end

  test "correct_guess? ignores case, spacing, punctuation and accents" do
    mr_mime = Pokemon.new(id: 122, name: "Mr. Mime", image_url: "", types: [], flavor_text: nil)
    flabebe = Pokemon.new(id: 669, name: "Flabébé", image_url: "", types: [], flavor_text: nil)

    assert mr_mime.correct_guess?("mr mime")
    assert mr_mime.correct_guess?("  MR-MIME ")
    assert flabebe.correct_guess?("flabebe")
    assert_not mr_mime.correct_guess?("Mime Jr.")
    assert_not mr_mime.correct_guess?("")
  end
end
