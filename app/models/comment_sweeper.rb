# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class CommentSweeper < ActionController::Caching::Sweeper
  observe Comment

  def after_save comment
    expire_comment(comment)
  end
  
  def after_destroy comment
    expire_comment(comment)
  end
  
  def expire_comment(comment)
    #ScoreWorker.async_update(comment.article_id)
  end
end
