require "test_helper"

class SystemComponentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get system_components_index_url
    assert_response :success
  end

  test "should get show" do
    get system_components_show_url
    assert_response :success
  end

  test "should get new" do
    get system_components_new_url
    assert_response :success
  end

  test "should get create" do
    get system_components_create_url
    assert_response :success
  end

  test "should get edit" do
    get system_components_edit_url
    assert_response :success
  end

  test "should get update" do
    get system_components_update_url
    assert_response :success
  end

  test "should get destroy" do
    get system_components_destroy_url
    assert_response :success
  end
end
