require 'test_helper'

class ListItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:list_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create list_item" do
    assert_difference('ListItem.count') do
      post :create, :list_item => { }
    end

    assert_redirected_to list_item_path(assigns(:list_item))
  end

  test "should show list_item" do
    get :show, :id => list_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => list_items(:one).to_param
    assert_response :success
  end

  test "should update list_item" do
    put :update, :id => list_items(:one).to_param, :list_item => { }
    assert_redirected_to list_item_path(assigns(:list_item))
  end

  test "should destroy list_item" do
    assert_difference('ListItem.count', -1) do
      delete :destroy, :id => list_items(:one).to_param
    end

    assert_redirected_to list_items_path
  end
end
