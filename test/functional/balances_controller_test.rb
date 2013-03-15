require 'test_helper'

class BalancesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:balances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create balance" do
    assert_difference('Balance.count') do
      post :create, :balance => { }
    end

    assert_redirected_to balance_path(assigns(:balance))
  end

  test "should show balance" do
    get :show, :id => balances(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => balances(:one).to_param
    assert_response :success
  end

  test "should update balance" do
    put :update, :id => balances(:one).to_param, :balance => { }
    assert_redirected_to balance_path(assigns(:balance))
  end

  test "should destroy balance" do
    assert_difference('Balance.count', -1) do
      delete :destroy, :id => balances(:one).to_param
    end

    assert_redirected_to balances_path
  end
end
