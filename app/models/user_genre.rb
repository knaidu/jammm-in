class UserGenre < ActiveRecord::Base
  belongs_to :genre
  belongs_to :user
  validates_uniqueness_of :genre_id, :scope => [:user_id]
end