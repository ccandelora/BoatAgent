require "test_helper"

class MaintenanceTasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get maintenance_tasks_index_url
    assert_response :success
  end

  test "should get show" do
    get maintenance_tasks_show_url
    assert_response :success
  end

  test "should get new" do
    get maintenance_tasks_new_url
    assert_response :success
  end

  test "should get create" do
    get maintenance_tasks_create_url
    assert_response :success
  end

  test "should get edit" do
    get maintenance_tasks_edit_url
    assert_response :success
  end

  test "should get update" do
    get maintenance_tasks_update_url
    assert_response :success
  end

  test "should get destroy" do
    get maintenance_tasks_destroy_url
    assert_response :success
  end

  test "should get complete" do
    get maintenance_tasks_complete_url
    assert_response :success
  end
end
