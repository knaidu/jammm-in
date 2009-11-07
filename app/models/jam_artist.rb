class JamArtist < ActiveRecord::Base
  belongs_to :jam
  belongs_to :artist, :class_name => "User", :primary_key => 'id', :foreign_key => 'artist_id'
  validates_uniqueness_of :artist_id, :scope => [:jam_id]
  
end
