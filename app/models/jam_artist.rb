class JamArtist < ActiveRecord::Base
  belongs_to :jam
  has_one :artist, :class_name => "User", :primary_key => 'artist_id', :foreign_key => 'id'

end
