class Instrument < ActiveRecord::Base
  validates_uniqueness_of :name
  
  def self.fetch(for_type, for_type_id)
    ContainsInstrument.find_all_by_for_type_and_for_type_id(for_type, for_type_id).map(&:instrument)
  end
  
  def icon_image_url_big
    return "/images/jam.png" unless image_url
    "/images/instruments/big/#{image_url}.png"
  end
  alias icon_image_url icon_image_url_big
  
  def icon_image_url_small
    return "/images/jam.png" unless image_url
    "/images/instruments/small/#{image_url}.png"
  end
  
end