# -*- encoding : utf-8 -*-
class Metadata < ActiveRecord::Base
  self.table_name = 'metadatas'
  belongs_to :article
  validates_presence_of :article_id, :key
  
  serialize :value, JSONColumn.new
end
