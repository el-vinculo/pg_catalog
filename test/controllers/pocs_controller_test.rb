require 'test_helper'

class PocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @poc = pocs(:one)
  end

  test "should get index" do
    get pocs_url
    assert_response :success
  end

  test "should get new" do
    get new_poc_url
    assert_response :success
  end

  test "should create poc" do
    assert_difference('Poc.count') do
      post pocs_url, params: { poc: { poc_name: @poc.poc_name } }
    end

    assert_redirected_to poc_url(Poc.last)
  end

  test "should show poc" do
    get poc_url(@poc)
    assert_response :success
  end

  test "should get edit" do
    get edit_poc_url(@poc)
    assert_response :success
  end

  test "should update poc" do
    patch poc_url(@poc), params: { poc: { poc_name: @poc.poc_name } }
    assert_redirected_to poc_url(@poc)
  end

  test "should destroy poc" do
    assert_difference('Poc.count', -1) do
      delete poc_url(@poc)
    end

    assert_redirected_to pocs_url
  end
end
