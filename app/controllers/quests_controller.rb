class QuestsController < ApplicationController
  before_filter :login_required
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => Quest.quests }
    end
  end

  # GET /quests/1
  # GET /quests/1.xml
  def show
    @quest = Quest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quest }
    end
  end

  def check
    @quest = Quest.quests[params[:id]]
    q = @quest.new(current_user)
    result = q.check
    respond_to do |format|
      format.html {render :text => result}
      format.js {
        render :json => result
      }
    end
  end

  def complete
    @quest = Quest.quests[params[:id]]
    
    respond_to do |format|
      begin
        q = @quest.new(current_user)
        q.complete
        format.html {render :text => 'ok' }
      rescue RuntimeError => e
        format.html {render :text => e.message}
      end
    end
  end
end