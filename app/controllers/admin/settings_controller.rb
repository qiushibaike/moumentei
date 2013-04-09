# -*- encoding : utf-8 -*-
class Admin::SettingsController < Admin::BaseController
  def edit
    Setting.replacelist = {} unless Setting.replacelist.is_a?(Hash)
    Setting.blacklist = [] unless Setting.blacklist.is_a?(Array)
  end

  def update
    if params[:setting][:replacelist]
      words = params[:setting]['replacelist'].split(/\s+/)
      words << '?' if words.length.odd? #ensure even-number length to make a hash
      Setting.replacelist = Hash[*words]
      params[:setting].delete(:replacelist)
    end
    if params[:setting][:blacklist]
      Setting['blacklist'] = params[:setting]['blacklist'].split(/[\r\n]+/)
      params[:setting].delete(:blacklist)
    end
    params[:setting].each_pair do |key, value|
      Setting[key] = value
    end
    redirect_to :action => :edit
  end
end
