require 'test_helper'

class ProgramServiceGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @program_service_group = program_service_groups(:one)
  end

  test "should get index" do
    get program_service_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_program_service_group_url
    assert_response :success
  end

  test "should create program_service_group" do
    assert_difference('ProgramServiceGroup.count') do
      post program_service_groups_url, params: { program_service_group: {  } }
    end

    assert_redirected_to program_service_group_url(ProgramServiceGroup.last)
  end

  test "should show program_service_group" do
    get program_service_group_url(@program_service_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_program_service_group_url(@program_service_group)
    assert_response :success
  end

  test "should update program_service_group" do
    patch program_service_group_url(@program_service_group), params: { program_service_group: {  } }
    assert_redirected_to program_service_group_url(@program_service_group)
  end

  test "should destroy program_service_group" do
    assert_difference('ProgramServiceGroup.count', -1) do
      delete program_service_group_url(@program_service_group)
    end

    assert_redirected_to program_service_groups_url
  end
end
