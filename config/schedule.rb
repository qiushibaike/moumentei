# -*- encoding : utf-8 -*-
require 'rufus/scheduler'
scheduler = Rufus::Scheduler.new

scheduler.every("5m") do
  Article.recalc_alt_scores
end

scheduler.join
