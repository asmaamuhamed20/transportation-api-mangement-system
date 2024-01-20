require "test_helper"

class Api::V1::SystemStatisticsControllerTest < ActionDispatch::IntegrationTest
  test "should get total_rides_count" do
    get api_v1_system_statistics_total_rides_count_url
    assert_response :success
  end

  test "should get daily_rides_count" do
    get api_v1_system_statistics_daily_rides_count_url
    assert_response :success
  end

  test "should get total_drivers_count" do
    get api_v1_system_statistics_total_drivers_count_url
    assert_response :success
  end
end
