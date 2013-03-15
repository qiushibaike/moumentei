class Tagging < ActiveRecord::Base #:nodoc:
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  #belongs_to :scope
  after_destroy :destroy_tag_if_unused
  
  private
  
  def destroy_tag_if_unused
    if Tag.destroy_unused
      if tag.taggings.count.zero?
        tag.destroy
      end
    end
  end
end
