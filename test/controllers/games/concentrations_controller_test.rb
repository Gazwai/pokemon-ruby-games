require "test_helper"

class Games::ConcentrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get games_concentrations_index_url
    assert_response :success
  end
end
