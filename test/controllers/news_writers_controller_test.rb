require 'test_helper'

class NewsWritersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @news_writer = news_writers(:one)
  end

  test "should get index" do
    get news_writers_url
    assert_response :success
  end

  test "should get new" do
    get new_news_writer_url
    assert_response :success
  end

  test "should create news_writer" do
    assert_difference('NewsWriter.count') do
      post news_writers_url, params: { news_writer: { bio: @news_writer.bio, firstName: @news_writer.firstName, password: @news_writer.password, role: @news_writer.role, secondName: @news_writer.secondName, username: @news_writer.username } }
    end

    assert_redirected_to news_writer_url(NewsWriter.last)
  end

  test "should show news_writer" do
    get news_writer_url(@news_writer)
    assert_response :success
  end

  test "should get edit" do
    get edit_news_writer_url(@news_writer)
    assert_response :success
  end

  test "should update news_writer" do
    patch news_writer_url(@news_writer), params: { news_writer: { bio: @news_writer.bio, firstName: @news_writer.firstName, password: @news_writer.password, role: @news_writer.role, secondName: @news_writer.secondName, username: @news_writer.username } }
    assert_redirected_to news_writer_url(@news_writer)
  end

  test "should destroy news_writer" do
    assert_difference('NewsWriter.count', -1) do
      delete news_writer_url(@news_writer)
    end

    assert_redirected_to news_writers_url
  end
end
