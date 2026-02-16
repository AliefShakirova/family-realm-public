class CreateGroupInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :group_invitations do |t|
      t.references :group, null: false, foreign_key: true
      t.string :email
      t.string :token
      t.string :status
      t.integer :invited_by
      t.datetime :expires_at

      t.timestamps
    end
  end
end
