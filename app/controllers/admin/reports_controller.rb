# -*- encoding : utf-8 -*-
class Admin::ReportsController < Admin::BaseController
  def index
    params[:type] ||= 'Comment'
    @reports = Report.find :all, :conditions => ["target_type= ? and operator_id IS NULL ", params[:type]]
    @targets = @reports.collect{|r|r.target}
  end

  def batch
    params[:report].each_pair do |id, result|
      report = Report.find id
      result = result[:result]
      if result != 'skip'
      report.result= result
      report.operator_id = current_user.id
      report.save!
      end
    end
    params[:punishment].each_pair do |id, result|
      user = User.find id
      case result[:type]
      when 'suspend'
        user.suspend
        UserNotifier.suspend(user).deliver
      when 'silence'
        
      when 'noop'
      end
    end
    redirect_to :back
  end
  
  def ignore
    @report = Report.find params[:id]
    @report.result = 'ignore'
    @report.operator_id = current_user.id
    @report.operated_at = Time.now
    @report.save!
    redirect_to :back
  end
  
  def remove
    @report = Report.find params[:id]
    @target = @report.target
    case @target
    when Article
    when Comment
      @target.status = 'private'
      @target.save!
    end
    @report.result = 'remove'
    @report.operator_id = current_user.id
    @report.save!
    redirect_to :back
  end
  
  def destroy
    @report = Report.find params[:id]
    @report.destroy
    redirect_to :back
  end
end
