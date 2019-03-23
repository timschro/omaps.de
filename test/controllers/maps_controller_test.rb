require 'test_helper'

class MapsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get maps_url(format: :json)
    assert_response :success
  end

end
