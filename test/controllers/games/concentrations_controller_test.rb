require "test_helper"

class Games::ConcentrationsControllerTest < ActionDispatch::IntegrationTest
  test "index deals six pairs of cards" do
    stub_pokemon
    stub_request(:get, ApiStubs::CARDS_URL).to_return_json(cards_response(10))

    get games_concentrations_url

    assert_response :success
    card_ids = css_select("button[data-card-id]").map { |card| card["data-card-id"] }
    assert_equal 12, card_ids.size
    assert card_ids.tally.values.all?(2), "every card should appear exactly twice"
  end

  test "index tries another pokemon when one has too few cards" do
    stub_pokemon
    stub_request(:get, ApiStubs::SPECIES_URL).to_return_json(species_response(name: "Unown"), species_response(name: "Pikachu"))
    stub_request(:get, ApiStubs::CARDS_URL).with(query: { name: "Unown" }).to_return_json(cards_response(3, name: "Unown"))
    stub_request(:get, ApiStubs::CARDS_URL).with(query: { name: "Pikachu" }).to_return_json(cards_response(8))

    get games_concentrations_url

    assert_response :success
    assert_select "p", text: /Pikachu cards/
    assert_select "button[data-card-id]", 12
  end

  test "index sends players home after repeated failures" do
    stub_pokemon
    stub_request(:get, ApiStubs::CARDS_URL).to_return_json(cards_response(2))

    get games_concentrations_url

    assert_redirected_to root_url
    follow_redirect!
    assert_select "[role=alert]", text: /Couldn't deal a hand/
  end
end
