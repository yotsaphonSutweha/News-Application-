require "application_system_test_case"

class NewsWritersTest < ApplicationSystemTestCase
  setup do
    @news_writer = news_writers(:one)
  end

  test "visiting the index" do
    visit news_writers_url
    assert_selector "h1", text: "News Writers"
  end

  test "creating a News writer" do
    visit news_writers_url
    click_on "New News Writer"

    fill_in "Bio", with: @news_writer.bio
    fill_in "Firstname", with: @news_writer.firstName
    fill_in "Password", with: @news_writer.password
    fill_in "Role", with: @news_writer.role
    fill_in "Secondname", with: @news_writer.secondName
    fill_in "Username", with: @news_writer.username
    click_on "Create News writer"

    assert_text "News writer was successfully created"
    click_on "Back"
  end

  test "updating a News writer" do
    visit news_writers_url
    click_on "Edit", match: :first

    fill_in "Bio", with: @news_writer.bio
    fill_in "Firstname", with: @news_writer.firstName
    fill_in "Password", with: @news_writer.password
    fill_in "Role", with: @news_writer.role
    fill_in "Secondname", with: @news_writer.secondName
    fill_in "Username", with: @news_writer.username
    click_on "Update News writer"

    assert_text "News writer was successfully updated"
    click_on "Back"
  end

  test "destroying a News writer" do
    visit news_writers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "News writer was successfully destroyed"
  end
end
