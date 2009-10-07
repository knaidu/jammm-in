class SongArtist < ActiveRecord::Base
  belongs_to :artist, :class_name => "User", :primary_key => "id"
  belongs_to :song
end
