# -*- encoding : utf-8 -*-
module Reportable
  def self.included(base)
    @@model = Kernel.const_get(base.controller_name.singularize.capitalize)
    base.cattr_reader :model
  end
  
  def report
    @object = self.model.find params[:id]
    @report = Report.find_by_target(@object)
    issue = {
      :user_id => current_user.id,
      :created_at => Time.now,
      :reason => params[:reason]
    }
    if @report
      unless @report.include?(current_user)
        @report.info << issue
        @report.save!
      end
    else
      @report = Report.create(:target => @object,
          :info=>[issue])
    end

    respond_to do |format|
      format.any(:html, :mobile) {
        if request.xhr?
          render :text => '举报成功'
        else
          redirect_to :back
        end
      }
      format.js {
        render :json => @report
      }
    end
  end
end
