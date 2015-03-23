class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :invitee_name
      t.string :invitee_email
      t.text :message
      t.string :token
      t.integer :user_id
      t.timestamps
    end
  end
end
