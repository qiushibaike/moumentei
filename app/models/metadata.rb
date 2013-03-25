# -*- encoding : utf-8 -*-
class Metadata < ActiveRecord::Base
  belongs_to :article
  validates_presence_of :article_id, :key
  
  #alias_method :original_value, :value
  def value
    @serialize_value ||= begin 
      ActiveSupport::JSON.decode(self[:value])
    rescue
      self[:value]
    end
  end
  #alias_method :original_value=, :value=
  def value=(new_value)
    self[:value]= @serialize_value = ActiveSupport::JSON.encode(new_value)
  end
end
