class Tag < ActiveRecord::Base
  
  validates_presence_of :name, :message => "Tag name cannot be empty"
  validates_uniqueness_of :name
  has_many :contains_tags, :dependent => :destroy

  def self.add(tag_name, for_type, for_type_id)
    raise "Tag name cannot be blank" if tag_name.blank? or tag_name.nil?
    ContainsTag.add(tag_name, for_type, for_type_id)
  end
  
  def self.fetch(for_type, for_type_id)
    ContainsTag.find_all_by_for_type_and_for_type_id(for_type, for_type_id).map(&:tag)
  end
  
end
