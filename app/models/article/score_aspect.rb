# -*- encoding : utf-8 -*-
module Article::ScoreAspect
  module ClassMethods
    def recalc_alt_scores
      logger.debug('recalc_alt_scores')
      where{alt_score > 0}.find_each do |article|
        article.calc_alt_score
      end
    end
  end

  module InstanceMethods
    def neg_score
      neg
    end

    def neg_score=(s)
      self.neg = -s.to_i.abs
      save
    end

    def pos_score=(s)
      pos = s.to_i.abs
      save
    end

    # pos_score
    def pos_score
      pos
    end

    # total_score
    def total_score
      score
    end

    def calc_alt_score
      self.alt_score ||= 0
      t = Time.now - (published_at || created_at)
      self.alt_score = (score + public_comments_count + 10) / (t/3600 + 2) ** 1.8
      save!
    end
  end

  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include InstanceMethods

      attr_protected :pos_score, :neg_score, :pos, :neg, :score
    end
  end
end
