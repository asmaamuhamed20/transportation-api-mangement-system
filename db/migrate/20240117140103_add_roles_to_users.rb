class AddRolesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :roles, :string
  end
end
