class JamArtist < ActiveRecord::Base
  belongs_to :jam
  belongs_to :artist, :class_name => "User", :primary_key => 'id', :foreign_key => 'artist_id'

end
