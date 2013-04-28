# -*- encoding : utf-8 -*-
timer = Proc.new {
  EM.add_periodic_timer( 600 ) {
    Article.recalc_alt_scores
  }
}
Rails.application.config.after_initialize do
  Thread.start do
    sleep 300
    if EM.reactor_running?
      timer.call
    else
      EM.run &timer
    end
  end
end
