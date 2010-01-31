class ContainsTag < ActiveRecord::Base
  belongs_to :tag
  validates_uniqueness_of :tag_id, :scope => [:for_type, :for_type_id]
  
  def self.add(tag_name, for_type, for_type_id)
    tag = Tag.named(tag_name) || Tag.create(:name => tag_name)
    self.create(:tag_id => tag.id, :for_type => for_type, :for_type_id => for_type_id)
  end

end