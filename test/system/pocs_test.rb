require "application_system_test_case"

class PocsTest < ApplicationSystemTestCase
  setup do
    @poc = pocs(:one)
  end

  test "visiting the index" do
    visit pocs_url
    assert_selector "h1", text: "Pocs"
  end

  test "creating a Poc" do
    visit pocs_url
    click_on "New Poc"

    fill_in "Poc name", with: @poc.poc_name
    click_on "Create Poc"

    assert_text "Poc was successfully created"
    click_on "Back"
  end

  test "updating a Poc" do
    visit pocs_url
    click_on "Edit", match: :first

    fill_in "Poc name", with: @poc.poc_name
    click_on "Update Poc"

    assert_text "Poc was successfully updated"
    click_on "Back"
  end

  test "destroying a Poc" do
    visit pocs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Poc was successfully destroyed"
  end
end
