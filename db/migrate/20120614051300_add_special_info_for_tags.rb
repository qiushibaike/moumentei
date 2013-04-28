# -*- encoding : utf-8 -*-
class AddSpecialInfoForTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :description, :string
    add_column :tags, :icon_file_name, :string
    add_column :tags, :icon_content_type, :string
    add_column :tags, :icon_file_size, :integer
    add_column :tags, :icon_updated_at, :datetime
    add_column :tags, :hide, :boolean
  end

  def self.down
    remove_column :tags
  end
end
