# -*- encoding : utf-8 -*-
class Page < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  belongs_to :parent, :class_name => 'Page'
  has_many :children, :class_name => 'Page', :foreign_key => 'parent_id'
  #attr_protected :slug, :path
  validates_presence_of :slug
  validates_uniqueness_of :slug, :scope => [:group_id, :parent_id]

  before_save :determine_path

  def determine_path
    self.path = parent ? File.join(parent.try(:path).to_s, slug) : slug unless slug.blank?
  end
end
