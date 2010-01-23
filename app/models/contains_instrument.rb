class ContainsInstrument < ActiveRecord::Base
  belongs_to :instrument
  validates_uniqueness_of :instrument_id, :scope => [:for_type, :for_type_id]
  
  def self.add(instrument, for_type, for_type_id)
    self.create({
      :instrument_id => instrument.id,
      :for_type => for_type,
      :for_type_id => for_type_id
    })
  end
  
end