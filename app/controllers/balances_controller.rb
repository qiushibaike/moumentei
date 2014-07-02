# -*- encoding : utf-8 -*-
class BalancesController < ApplicationController
  before_filter :find_user

  # GET /balances/1
  # GET /balances/1.xml
  def show
    @balance = @user.balance.find(params[:id])

    respond_with @balance
  end

  def salary

  end

  protected
  def find_user
    @user = User.find params[:user_id]
  end
end
