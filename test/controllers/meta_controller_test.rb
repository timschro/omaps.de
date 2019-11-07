require 'test_helper'

class MetaControllerTest < ActionDispatch::IntegrationTest
  test 'should get imprint' do
    get meta_imprint_url
    assert_response :success
  end
end
