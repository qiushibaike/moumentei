class QuestLogsController < ApplicationController
  # GET /quest_logs
  # GET /quest_logs.xml
  def index
    @quest_logs = QuestLog.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quest_logs }
    end
  end

  # GET /quest_logs/1
  # GET /quest_logs/1.xml
  def show
    @quest_log = QuestLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quest_log }
    end
  end

  # GET /quest_logs/new
  # GET /quest_logs/new.xml
  def new
    @quest_log = QuestLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quest_log }
    end
  end

  # GET /quest_logs/1/edit
  def edit
    @quest_log = QuestLog.find(params[:id])
  end

  # POST /quest_logs
  # POST /quest_logs.xml
  def create
    @quest_log = QuestLog.new(params[:quest_log])

    respond_to do |format|
      if @quest_log.save
        format.html { redirect_to(@quest_log, :notice => 'QuestLog was successfully created.') }
        format.xml  { render :xml => @quest_log, :status => :created, :location => @quest_log }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quest_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quest_logs/1
  # PUT /quest_logs/1.xml
  def update
    @quest_log = QuestLog.find(params[:id])

    respond_to do |format|
      if @quest_log.update_attributes(params[:quest_log])
        format.html { redirect_to(@quest_log, :notice => 'QuestLog was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quest_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /quest_logs/1
  # DELETE /quest_logs/1.xml
  def destroy
    @quest_log = QuestLog.find(params[:id])
    @quest_log.destroy

    respond_to do |format|
      format.html { redirect_to(quest_logs_url) }
      format.xml  { head :ok }
    end
  end
end
