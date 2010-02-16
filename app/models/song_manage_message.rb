class SongManageMessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :song
  
  before_create{|record| record.created_at = Time.now}
  
  def self.add(song, user, message)
    smm = self.create({
      :song_id => song.id,
      :user_id => user.id,
      :message => message
    })
    smm.send_notification
    smm
  end
  
  def send_notification
    notification = Notification.add({:song_id => self.song.id, :song_message_id => self.id}, "song_message")
    notification.add_users(self.song.managers - [user])
  end
  
end
