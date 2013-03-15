module User::RatingAspect
  module ClassMethods
    
  end

  module InstanceMethods
    # user rate specific article 
    def rate article, score
      article = Article.find article if article.is_a?(Integer)
      connection.execute <<sql
      INSERT /*DELAYED*/ IGNORE INTO ratings
      (article_id, user_id, score, created_at)VALUES(#{article.id},#{id},#{score.to_i}, NOW())
sql
      if score > 0
        article.pos += score
        article.score += score
        #ScoreWorker.async_update(article)
      elsif score < 0
        article.neg += score
        article.score += score
        #connection.execute "UPDATE scores SET neg=neg-1 WHERE article_id=#{article}"
        #ScoreWorker.async_update(article)
      end
      article.save
    end
    
    def has_rated? article
      @rated ||= {}
      case article
      when Array
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
