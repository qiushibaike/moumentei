module Article::ScoreAspect
  module ClassMethods

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
  end
  
  def self.included(base)
    base.class_eval do 
      extend ClassMethods
      include InstanceMethods

      attr_protected :pos_score, :neg_score, :pos, :neg, :score
    end
  end
end
