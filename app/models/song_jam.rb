class SongJam < ActiveRecord::Base
  belongs_to :song
  belongs_to :jam
  validates_uniqueness_of :jam_id, :scope => [:song_id]
end
