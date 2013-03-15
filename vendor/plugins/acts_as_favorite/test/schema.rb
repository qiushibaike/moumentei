ActiveRecord::Schema.define(:version => 1) do

  create_table :users, :force => true do |t|
    t.column :name, :string, :limit => 50
  end

  create_table :favorites, :force => true do |t|
    t.column :user_id,          :integer
    t.column :favorable_id,     :integer
    t.column :favorable_type,   :string, :limit => 30
    t.column :created_at,       :datetime
    t.column :updated_at,       :datetime
  end

  create_table :books, :force => true do |t|
    t.column :title,            :string, :limit => 30
  end
  
  create_table :drinks, :force => true do |t|
    t.column :title,            :string, :limit => 30
  end

end
  