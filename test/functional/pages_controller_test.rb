require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page" do
    assert_difference('Page.count') do
      post :create, :page => { }
    end

    assert_redirected_to page_path(assigns(:page))
  end

  test "should show page" do
    get :show, :id => pages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pages(:one).to_param
    assert_response :success
  end

  test "should update page" do
    put :update, :id => pages(:one).to_param, :page => { }
    assert_redirected_to page_path(assigns(:page))
  end

  test "should destroy page" do
    assert_difference('Page.count', -1) do
      delete :destroy, :id => pages(:one).to_param
    end

    assert_redirected_to pages_path
  end
end
