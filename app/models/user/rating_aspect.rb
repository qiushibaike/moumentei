# -*- encoding : utf-8 -*-
module User::RatingAspect
  module ClassMethods

  end

  module InstanceMethods
    # user rate specific article
    def rate(article, score)
      user = self
      article = Article.find article if article.is_a?(Integer)
      post = article
      user_id = user.id
      return false if post[:user_id] == user_id

      transaction do
        post.lock!
        r = post.ratings.find_by_user_id user_id, :lock => true

        if r
          if r.score != score
            if r.score > 0
              post.decrement :pos
            else
              post.decrement :neg
            end
            post.decrement :score, r.score
            r.score = score
            r.save!
          else
            return false
          end
        else
          Rating.create :article_id => post.id,
                 :user_id => user_id,
                 :score => score
        end

        if score > 0
          post.increment :pos
          post.increment :score
        else
          post.increment :neg
          post.decrement :score
        end
        post.save!
      end
      article.calc_alt_score
    rescue ActiveRecord::RecordNotUnique
      return false
    end

    def has_rated? article
      @rated ||= {}
      case article
      when Array, ActiveRecord::Relation
        article = article.to_a
        if article.size > 0
          if article[0].is_a? Article
            ids = article.collect{|o|o.id}
          else
            ids = article
          end
          ratings.find(:all, :conditions => {:article_id => ids}).each do |i|
            @rated[i.article_id] = true
          end
          if article[0].is_a? Article
            article.each do |o|
              @rated[o.id]=false unless @rated.include?(o.id)
            end
          else
            ids.each do |i|
              @rated[i]=false unless @rated.include?(i)
            end
          end
          return @rated
        else
          return {}
        end
      when Article
        i = article.id.to_i
      else
        i = article.to_i
      end
      return @rated[i] if @rated.include? i
      @rated[i] = ratings.find(:first, :conditions => {:article_id => i})
    end

  end

  def self.included(receiver)
    receiver.extend         ClassMethods

    receiver.send :include, InstanceMethods
    receiver.has_many :ratings
  end
end
