class RemoveFollowerIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :follower_id
  end
end
