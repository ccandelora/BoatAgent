require "test_helper"

class AiRecommendationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ai_recommendations_index_url
    assert_response :success
  end

  test "should get show" do
    get ai_recommendations_show_url
    assert_response :success
  end

  test "should get convert" do
    get ai_recommendations_convert_url
    assert_response :success
  end
end
