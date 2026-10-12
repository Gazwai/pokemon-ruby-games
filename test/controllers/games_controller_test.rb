require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "index links to both games" do
    get root_url

    assert_response :success
    assert_select "a[href=?]", games_guess_that_pokemon_path
    assert_select "a[href=?]", games_concentrations_path
  end
end
