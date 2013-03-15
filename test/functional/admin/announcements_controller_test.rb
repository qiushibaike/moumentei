require 'test_helper'

class AnnouncementsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:announcements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create announcement" do
    assert_difference('Announcement.count') do
      post :create, :announcement => { }
    end

    assert_redirected_to announcement_path(assigns(:announcement))
  end

  test "should show announcement" do
    get :show, :id => announcements(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => announcements(:one).to_param
    assert_response :success
  end

  test "should update announcement" do
    put :update, :id => announcements(:one).to_param, :announcement => { }
    assert_redirected_to announcement_path(assigns(:announcement))
  end

  test "should destroy announcement" do
    assert_difference('Announcement.count', -1) do
      delete :destroy, :id => announcements(:one).to_param
    end

    assert_redirected_to announcements_path
  end
end
