module Article::ScoreAspect
  module ClassMethods
    def sync_scores_to_articles
      connection.execute 'UPDATE articles, scores SET articles.pos=scores.pos, articles.neg=scores.neg, articles.score=scores.score WHERE articles.id = scores.article_id' 
    end
    def scores_to_articles(s)
      k = []
      m = {}
      
      s.each do |i|
        k << i.article_id
        m[i.article_id] = i
      end
      
      s.replace(
        get_caches(k).each { |i| i.send(:set_score_target, m[i.id]) })
    end

    def rebuild_score
      require 'ap'
      paginated_each(:conditions => {:status => 'publish', :group_id => 2} , :order => 'id desc', :per_page => 1000) do |art|
        begin
          s = art.score        
          s.public_comments_count = art.comments.public.count
          s.pos = art.ratings.count :conditions => {:score => 1}
          s.neg = -(art.ratings.count :conditions => {:score => -1})
          s.ratings_count = s.pos + s.neg
          s.group_id = art.group_id
          s.has_picture = art.picture.file?
          s.created_at = art.created_at
          s.save
          print '.'
        rescue
        end  
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
    
    def update_score algorithm=nil
      return unless score
      algorithm = self.group.options[:score_algorithm] unless algorithm
      return unless algorithm
      new_score = eval(algorithm)
      update_attribute :score, new_score 
    end

    #lazy created score record

    #alias original_score score
    #def score
    #  if not score and status == 'publish'
    #    _create_score
    #  end
    #  original_score
    #end
    def _build_score
      self.pos = ratings.sum( :pos )+ anonymous_ratings.sum( :pos)
      self.neg = ratings.sum( :neg )+ anonymous_ratings.sum( :neg)
      self.score = self.pos+self.neg
      save
    end

    def scores &block
      if not @scores
        hash = {}
        #pay attention to the idx(article_id, score) in ratings table
        #here is a tight index scan
        connection.select_all(
            "SELECT ratings.score, count(*) as count FROM ratings WHERE article_id=#{self.id} GROUP BY score"
          ).each do |record|
            hash[record['score'].to_i] = record['count'].to_i
          end
        @scores = hash
      end
      
      return block.call(@scores) if block
      @scores
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
