class SongJam < ActiveRecord::Base
  belongs_to :song
  belongs_to :jam
end
