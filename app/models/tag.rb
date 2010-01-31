class Tag < ActiveRecord::Base
  
  validates_uniqueness_of :name
  
  def self.add(tag_name, for_type, for_type_id)
    ContainsTag.add(tag_name, for_type, for_type_id)
  end
  
  def self.fetch(for_type, for_type_id)
    ContainsTag.find_all_by_for_type_and_for_type_id(for_type, for_type_id).map(&:tag)
  end
  
end