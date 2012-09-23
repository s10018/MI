require 'test_helper'

class Movies::PagerControllerTest < ActionController::TestCase
  test "should get prev" do
    get :prev
    assert_response :success
  end

  test "should get next" do
    get :next
    assert_response :success
  end

  test "should get first" do
    get :first
    assert_response :success
  end

  test "should get last" do
    get :last
    assert_response :success
  end

end
