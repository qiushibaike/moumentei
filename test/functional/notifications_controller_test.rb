require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notifications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notification" do
    assert_difference('Notification.count') do
      post :create, :notification => { }
    end

    assert_redirected_to notification_path(assigns(:notification))
  end

  test "should show notification" do
    get :show, :id => notifications(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => notifications(:one).to_param
    assert_response :success
  end

  test "should update notification" do
    put :update, :id => notifications(:one).to_param, :notification => { }
    assert_redirected_to notification_path(assigns(:notification))
  end

  test "should destroy notification" do
    assert_difference('Notification.count', -1) do
      delete :destroy, :id => notifications(:one).to_param
    end

    assert_redirected_to notifications_path
  end
end
