class PublishedJam < ActiveRecord::Base
  belongs_to :jam
  validates_uniqueness_of :jam_id
  
  def self.add(jam)
    self.create({:jam_id => jam.id})
  end
end
