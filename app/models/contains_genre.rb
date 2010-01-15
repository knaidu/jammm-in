class ContainsGenre < ActiveRecord::Base
  belongs_to :genre
  validates_uniqueness_of :genre_id, :scope => [:for_type, :for_type_id]
  
  def self.add(genre, for_type, for_type_id)
    self.create({
      :genre_id => genre.id,
      :for_type => for_type,
      :for_type_id => for_type_id
    })
  end
  
end