require 'test_helper'

class NewsReportControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get news_report_index_url
    assert_response :success
  end

  test "should get show" do
    get news_report_show_url
    assert_response :success
  end

  test "should get new" do
    get news_report_new_url
    assert_response :success
  end

  test "should get edit" do
    get news_report_edit_url
    assert_response :success
  end

end
