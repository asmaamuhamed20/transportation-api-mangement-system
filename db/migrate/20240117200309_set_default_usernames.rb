class SetDefaultUsernames < ActiveRecord::Migration[7.1]
  def up
    User.where(username: nil).update_all("username = 'user'")
  end

  def down
  end
end
