# -*- encoding : utf-8 -*-
class SalariesController < ApplicationController
  before_filter :login_required
  layout 'users'
  def index
    @balance=current_user.ensure_balance
    @transactions=@balance.transactions.paginate :page => params[:page]
    @should_show_login_saraly_link=current_user.check_daily_login_salary(@balance)
    @should_show_article_saraly_link=current_user.check_daily_article_salary(@balance)
    @should_show_comment_saraly_link=current_user.check_daily_comment_salary(@balance)
  end
  
  def get_daily_login_salary
    if current_user.get_daily_login_salary
      flash[:notice]="成功领取今日登录奖励"
    end
    redirect_to :controller=>"salaries",:action=>"index"
  end

  def get_daily_article_salary
    if current_user.get_daily_article_salary
      flash[:notice]="成功领取今日发贴奖励"
    end 
    redirect_to :controller=>"salaries",:action=>"index"
  end
  
  def get_daily_comment_salary
    if current_user.get_daily_comment_salary
      flash[:notice]="成功领取今日发贴奖励"
    end
    redirect_to :controller=>"salaries",:action=>"index"
  end
end
