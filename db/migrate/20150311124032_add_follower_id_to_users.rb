class AddFollowerIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :follower_id, :integer
  end
end
