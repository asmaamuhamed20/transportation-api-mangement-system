class RemoveAuthenticationTokenFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :authentication_token, :string
  end
end
