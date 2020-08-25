require "application_system_test_case"

class ServiceGroupsTest < ApplicationSystemTestCase
  setup do
    @service_group = service_groups(:one)
  end

  test "visiting the index" do
    visit service_groups_url
    assert_selector "h1", text: "Service Groups"
  end

  test "creating a Service group" do
    visit service_groups_url
    click_on "New Service Group"

    fill_in "Name", with: @service_group.name
    click_on "Create Service group"

    assert_text "Service group was successfully created"
    click_on "Back"
  end

  test "updating a Service group" do
    visit service_groups_url
    click_on "Edit", match: :first

    fill_in "Name", with: @service_group.name
    click_on "Update Service group"

    assert_text "Service group was successfully updated"
    click_on "Back"
  end

  test "destroying a Service group" do
    visit service_groups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Service group was successfully destroyed"
  end
end
