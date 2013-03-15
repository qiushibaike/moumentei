require 'test_helper'

class InvitationCodesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invitation_codes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invitation_code" do
    assert_difference('InvitationCode.count') do
      post :create, :invitation_code => { }
    end

    assert_redirected_to invitation_code_path(assigns(:invitation_code))
  end

  test "should show invitation_code" do
    get :show, :id => invitation_codes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => invitation_codes(:one).to_param
    assert_response :success
  end

  test "should update invitation_code" do
    put :update, :id => invitation_codes(:one).to_param, :invitation_code => { }
    assert_redirected_to invitation_code_path(assigns(:invitation_code))
  end

  test "should destroy invitation_code" do
    assert_difference('InvitationCode.count', -1) do
      delete :destroy, :id => invitation_codes(:one).to_param
    end

    assert_redirected_to invitation_codes_path
  end
end
