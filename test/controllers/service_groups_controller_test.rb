require 'test_helper'

class ServiceGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service_group = service_groups(:one)
  end

  test "should get index" do
    get service_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_service_group_url
    assert_response :success
  end

  test "should create service_group" do
    assert_difference('ServiceGroup.count') do
      post service_groups_url, params: { service_group: { name: @service_group.name } }
    end

    assert_redirected_to service_group_url(ServiceGroup.last)
  end

  test "should show service_group" do
    get service_group_url(@service_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_service_group_url(@service_group)
    assert_response :success
  end

  test "should update service_group" do
    patch service_group_url(@service_group), params: { service_group: { name: @service_group.name } }
    assert_redirected_to service_group_url(@service_group)
  end

  test "should destroy service_group" do
    assert_difference('ServiceGroup.count', -1) do
      delete service_group_url(@service_group)
    end

    assert_redirected_to service_groups_url
  end
end
