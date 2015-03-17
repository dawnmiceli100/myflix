class ChangeResetNameInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :reset_digest, :reset_token
  end
end
