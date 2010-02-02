class SongManageMessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :song
  
  before_create{|record| record.created_at = Time.now}
  
  def self.add(song, user, message)
    self.create({
      :song_id => song.id,
      :user_id => user.id,
      :message => message
    })
  end
  
end