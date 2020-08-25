require "application_system_test_case"

class ProgramServiceGroupsTest < ApplicationSystemTestCase
  setup do
    @program_service_group = program_service_groups(:one)
  end

  test "visiting the index" do
    visit program_service_groups_url
    assert_selector "h1", text: "Program Service Groups"
  end

  test "creating a Program service group" do
    visit program_service_groups_url
    click_on "New Program Service Group"

    click_on "Create Program service group"

    assert_text "Program service group was successfully created"
    click_on "Back"
  end

  test "updating a Program service group" do
    visit program_service_groups_url
    click_on "Edit", match: :first

    click_on "Update Program service group"

    assert_text "Program service group was successfully updated"
    click_on "Back"
  end

  test "destroying a Program service group" do
    visit program_service_groups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Program service group was successfully destroyed"
  end
end
