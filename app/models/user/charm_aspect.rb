# -*- encoding : utf-8 -*-
class User
  module CharmAspect
    def total_comments_score
      comments.public.sum :score
    end
    
    def average_comments_score
      comments.public.average :score
    end

    def total_articles_score
      Article.sum :score, :conditions => {:user_id => article_ids}
    end

    def average_articles_score
      Article.average :score, :conditions => {:user_id => article_ids}
    end

    def total_articles_comments_count
      Comment.count :conditions => {:article_id => article_ids, :status => 'publish'}
    end
    def average_articles_comments_count
      if articles.public.count > 0
        total_articles_comments_count / articles.public.count
      else
        0
      end
    end
  end
end
