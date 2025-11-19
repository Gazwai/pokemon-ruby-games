require "test_helper"

class GuessesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get guesses_index_url
    assert_response :success
  end

  test "should get guess" do
    get guesses_guess_url
    assert_response :success
  end
end
