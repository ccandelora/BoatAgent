require "test_helper"

class UserPromptsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_prompts_index_url
    assert_response :success
  end

  test "should get create" do
    get user_prompts_create_url
    assert_response :success
  end
end
