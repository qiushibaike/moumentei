require File.dirname(__FILE__) + '/lib/acts_as_favorite'
ActiveRecord::Base.send( :include, 
  ActsAsFavorite::UserExtensions, 
  ActsAsFavorite::ModelExtensions
)
