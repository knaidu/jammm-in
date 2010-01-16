class Genre < ActiveRecord::Base
  validates_uniqueness_of :name
  
  def self.fetch(for_type, for_type_id)
    ContainsGenre.find_all_by_for_type_and_for_type_id(for_type, for_type_id).map(&:genre)
  end
  
end