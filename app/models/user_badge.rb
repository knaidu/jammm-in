class UserBadge < ActiveRecord::Base
  validates_uniqueness_of :user_id, :scope => :badge_id
  belongs_to :user

  def badge
    Badge.new(badge_id)
  end
  
end
