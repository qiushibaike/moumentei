# -*- encoding : utf-8 -*-
Thread.start do
  EM.run {
    EM.add_periodic_timer( 600 ) {
      Article.recalc_alt_scores
    }
  }    
end
