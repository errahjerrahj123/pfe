require "test_helper"

class ConfigurationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get configuration_index_url
    assert_response :success
  end

  test "should get settings" do
    get configuration_settings_url
    assert_response :success
  end

  test "should get advanced" do
    get configuration_advanced_url
    assert_response :success
  end

  test "should get add_weekly_holidays" do
    get configuration_add_weekly_holidays_url
    assert_response :success
  end
end
