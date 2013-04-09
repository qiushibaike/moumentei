class RolifyCreateRoles < ActiveRecord::Migration
  def change
    add_column :roles, :resource_type, :string
    add_column :roles, :resource_id, :integer
    add_column :roles, :created_at, :datetime
    add_column :roles, :updated_at, :datetime

    #create_table(:users_roles, :id => false) do |t|
    #  t.references :user
    #  t.references :role
    #end
    rename_table :roles_users, :users_roles

    add_index(:roles, :name)
    add_index(:roles, [ :name, :resource_type, :resource_id ])
    #add_index(:users_roles, [ :user_id, :role_id ])
  end
end
