require "test_helper"

class Games::GuessesControllerTest < ActionDispatch::IntegrationTest
  test "index shows a silhouette and starts a round" do
    stub_pokemon

    get games_guess_that_pokemon_url

    assert_response :success
    assert_select "img.brightness-0[alt=?]", "A mystery Pokémon's silhouette"
    assert_select "input[name=?]", "guess[user_answer]"
    assert_no_match "Pikachu", response.body
  end

  test "index sends players home with a message when the Pokédex is down" do
    stub_pokedex_outage

    get games_guess_that_pokemon_url

    assert_redirected_to root_url
    follow_redirect!
    assert_select "[role=alert]", text: /Couldn't reach the Pokédex/
  end

  test "a correct guess is accepted whatever the case or spacing" do
    stub_pokemon(name: "Mr. Mime")
    get games_guess_that_pokemon_url

    post games_guess_that_pokemon_guess_url, params: { guess: { user_answer: "  MR MIME " } }, as: :turbo_stream

    assert_response :success
    assert_select "turbo-stream[action=update][target=round]" do
      assert_select "template", text: /Correct!/
      assert_select "template", text: /It's Mr. Mime!/
    end
  end

  test "a wrong guess reveals the answer" do
    stub_pokemon
    get games_guess_that_pokemon_url

    post games_guess_that_pokemon_guess_url, params: { guess: { user_answer: "Raichu" } }, as: :turbo_stream

    assert_select "template", text: /Not quite!/
    assert_select "template", text: /It's Pikachu!/
    assert_select "template", text: /You guessed “Raichu”/
  end

  test "guessing works without JavaScript" do
    stub_pokemon
    get games_guess_that_pokemon_url

    post games_guess_that_pokemon_guess_url, params: { guess: { user_answer: "pikachu" } }

    assert_response :success
    assert_select "[role=status]", text: "Correct!"
  end

  test "each round can only be guessed once" do
    stub_pokemon
    get games_guess_that_pokemon_url
    post games_guess_that_pokemon_guess_url, params: { guess: { user_answer: "Raichu" } }, as: :turbo_stream

    post games_guess_that_pokemon_guess_url, params: { guess: { user_answer: "Pikachu" } }, as: :turbo_stream

    assert_redirected_to games_guess_that_pokemon_url
    assert_response :see_other
  end
end
