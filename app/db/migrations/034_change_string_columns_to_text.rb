class ChangeStringColumnsToText < ActiveRecord::Migration
  def self.up
		change_column :bugs_body, :message, :text
		change_column :user_message_streams, :body, :text
		change_column :song_manage_messages, :message, :text
		change_column :comments, :comment, :text
  end
  
  def self.down
		change_column :bugs_body, :message, :string
		change_column :user_message_streams, :body, :string
		change_column :song_manage_messages, :message, :string
		change_column :comments, :comment, :string
	end
end
