# -*- encoding : utf-8 -*-
class BalancesController < ApplicationController
  before_filter :find_user

  # GET /balances/1
  # GET /balances/1.xml
  def show
    @balance = @user.balance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @balance }
    end
  end

  def salary
    
  end

  protected
  def find_user
    @user = User.find params[:user_id]
  rescue ActiveRecord::RecordNotFound
    show_404
  end
end
