require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pictures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create picture" do
    assert_difference('Picture.count') do
      post :create, :picture => { }
    end

    assert_redirected_to picture_path(assigns(:picture))
  end

  test "should show picture" do
    get :show, :id => pictures(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pictures(:one).to_param
    assert_response :success
  end

  test "should update picture" do
    put :update, :id => pictures(:one).to_param, :picture => { }
    assert_redirected_to picture_path(assigns(:picture))
  end

  test "should destroy picture" do
    assert_difference('Picture.count', -1) do
      delete :destroy, :id => pictures(:one).to_param
    end

    assert_redirected_to pictures_path
  end
end
