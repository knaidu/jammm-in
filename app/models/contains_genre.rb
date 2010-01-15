class ContainsGenre < ActiveRecord::Base
  belongs_to :genre
  
  def self.add(genre, for_type, for_type_id)
    self.create({
      :genre_id => genre.id,
      :for_type => for_type,
      :for_type_id => for_type_id
    })
  end
  
end