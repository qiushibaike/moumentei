# -*- encoding : utf-8 -*-
module User::FavoriteAspect
  #extend ActiveSupport::Concern
  def self.included(base)
    base.class_eval do 
      acts_as_favorite_user
      include InstanceMethods
    end
  end
  

  module InstanceMethods
    #alias_method :orig_has_favorite?, :has_favorite?

    def has_favorite?(ids)
      @favorites ||= {}
    #    RAILS_DEFAULT_LOGGER.info {@favorites.inspect}
      if ids.is_a? Array and ids.size > 0
        ids = ids.collect{|i| i.id} unless ids[0].is_a?(Fixnum)
        r = Favorite.find( :all,
                 :conditions => [ 'user_id = ? AND favorable_type = ? AND favorable_id in( ? )',
                                   self.id, 'Article', ids ] )
        r.each do |i|
          @favorites[i.favorable_id] = i
        end
        ids.each do |i|
          @favorites[i] = false unless @favorites.include? i
        end
        @favorites
      else
        if ids.is_a? Article
          id2 = ids.id
        else
          id2 = ids
          ids = Article.find ids
        end
        if @favorites.include? id2
          return @favorites[id2]
        else
          @favorites[id2] = super(ids)
        end
      end
    end
  end
end
