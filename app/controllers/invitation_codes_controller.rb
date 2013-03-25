# -*- encoding : utf-8 -*-
class InvitationCodesController < ApplicationController
  before_filter :login_required
  layout 'users'
  
  def index
    @invitation_codes = InvitationCode.paginate :page => params[:page],
      :conditions => {:applicant_id => current_user.id},
      :order => 'id desc'
    @today_code = CodeLog.ensure_only(current_user)
    respond_to do |format|
      format.html # index.html.erb
      format.mobile
      format.xml  { render :xml => @invitation_codes }
    end
  end

  def new
    return redirect_to invitation_codes_path if CodeLog.ensure_only(current_user)#@today_code
    @invitation_code = InvitationCode.new

    respond_to do |format|
      format.html # new.html.erb
      format.mobile
      format.xml  { render :xml => @invitation_code }
    end
  end

#  # GET /invitation_codes/1/edit
#  def edit
#    @invitation_code = InvitationCode.find(params[:id])
#  end
#
  # POST /invitation_codes
  # POST /invitation_codes.xml
  def create
   return redirect_to invitation_codes_path if CodeLog.ensure_only(current_user)#@today_code
    days = (Date.today - current_user.created_at.to_date).to_i
    n = days / 100
    r = days % 100
    n = n + 1 if rand(100) < r
    n = 1 if n > 1
    CodeLog.create(:user_id=>current_user.id,:date=>Date.today)
    @invitation_codes = InvitationCode.generate current_user.id, n
    respond_to do |format|
      format.html { render :text => @invitation_codes.collect{|i|i.code}.join(',') }
      format.mobile { render :text => @invitation_codes.collect{|i|i.code}.join(',') }
      format.js do
        render :json => @invitation_codes.collect{|i|i.code}
      end
      #format.xml  { render :xml => @invitation_code, :status => :created, :location => @invitation_code }
    end
  end
protected
end
