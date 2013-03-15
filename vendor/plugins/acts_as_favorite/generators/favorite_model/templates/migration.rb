class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %>, :force => true do |t|
      t.column :user_id,            :integer
      t.column :favorable_type,     :string, :limit => 30
      t.column :favorable_id,       :integer
      t.column :created_at,         :datetime
      t.column :updated_at,         :datetime
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
