class JamArtist < ActiveRecord::Base
  belongs_to :jam
  belongs_to :artist, :class_name => "User", :primary_key => 'id', :foreign_key => 'artist_id'
  validates_uniqueness_of :artist_id, :scope => [:jam_id]
  
  def instruments
    Instrument.fetch("jam_artist", self.id)
  end
  
  def remove_instrument(instrument)
    ci = ContainsInstrument.find_by_for_type_and_for_type_id_and_instrument_id("jam_artist", id, instrument.id)
  end
  
end
