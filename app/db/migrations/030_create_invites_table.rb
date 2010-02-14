class CreateInvitesTable < ActiveRecord::Migration
  
  def self.up
    
    create_table :invites do |i|
      i.column :referred_user_id, :integer
      i.column :invitee_email_id, :string
      i.column :status, :string
    end    
    
  end
  
  def self.down
    drop_table :invites
  end
end
