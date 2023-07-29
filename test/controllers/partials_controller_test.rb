require "test_helper"

class PartialsControllerTest < ActionDispatch::IntegrationTest
  test "should get student" do
    get partials_student_url
    assert_response :success
  end

  test "should get admin" do
    get partials_admin_url
    assert_response :success
  end

  test "should get employee" do
    get partials_employee_url
    assert_response :success
  end
end
