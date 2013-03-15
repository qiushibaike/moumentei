require File.dirname(__FILE__) + '/identity'

module ActsAsFavorite

  module UserExtensions
    def self.included( recipient )
      recipient.extend( ClassMethods )
    end
    
    module ClassMethods
      def acts_as_favorite_user
        has_many :favorites
        has_many :favorables, :through => :favorites
        include ActsAsFavorite::UserExtensions::InstanceMethods
        include ActsAsFavorite::Identity::UserExtensions::InstanceMethods 
      end
    end
    
    module InstanceMethods

      # Returns a polymorphic array of all user favorites 
      def all_favorites
        self.favorites.map{|f| f.favorable }
      end
            
      # Returns trur/false if the provided object is a favorite of the users
      def has_favorite?( favorite_obj )
        favorite = get_favorite( favorite_obj )
        favorite ? self.favorites.exists?( favorite.id ) : false
      end
      
      # Sets the object as a favorite of the users
      def has_favorite( favorite_obj )
        favorite = get_favorite( favorite_obj )
#        connection.execute <<sql
#    INSERT DELAYED IGNORE INTO f
#    (article_id, user_id, score)VALUES(#{article.id},#{id},#{score.to_i})"
#sql

        if favorite.nil?
          favorite = Favorite.create( :user_id => self.id,
                                      :favorable_type => favorite_obj.class.to_s, 
                                      :favorable_id   => favorite_obj.id )
        end
        favorite
      rescue ActiveRecord::StatementInvalid => e
        if e.message.index('Duplicate entry') > 0
          get_favorite( favorite_obj )
        else
          raise e
        end
      end
      
      # Removes an object from the users favorites
      def has_no_favorite( favorite_obj )
        favorite = get_favorite ( favorite_obj )

        # ACA: The original plugin did not properly destroy the favorite.
        # Instead, it just removed the element from the favorites list. If the
        # favorites list was refetched from the DB, surprise! It came back!
        
        if favorite
          self.favorites.delete( favorite )
          favorite_obj.favorites.delete( favorite )
          favorite.destroy
        end
      end
      
      private
      
      # Returns a favorite
      def get_favorite( favorite_obj )
        # ACA: The original plugin did not incoorporate the user id. This
        # meant that the has_many associations did not find favorites
        # properly.
        Favorite.find( :first,
                       :conditions => [ 'user_id = ? AND favorable_type = ? AND favorable_id = ?',
                                         self.id, favorite_obj.class.to_s, favorite_obj.id ] )
      end
    end
  end
  
  
  module ModelExtensions
    def self.included( recipient )
      recipient.extend( ClassMethods )
    end
    
    module ClassMethods
      def acts_as_favorite
        has_many :favorites, :as => :favorable
        has_many :favorite_users, :through => :favorites, :source => :user

        # ACA: The original plugin included unnecessary repetitions of the
        # instance method definitions as well as the below include.
        
        include ActsAsFavorite::ModelExtensions::InstanceMethods
      end      
    end
    
    module InstanceMethods    
      def accepts_favorite?( user_obj )
        user_obj.has_favorite?( self )
      end
      
      def accepts_favorite( user_obj )
        user_obj.has_favorite( self )
      end
      
      def accepts_no_favorite( user_obj )
        user_obj.has_no_favorite( self )
      end            
      
    end

  end
end