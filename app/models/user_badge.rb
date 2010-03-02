class UserBadge < ActiveRecord::Base
  validates_uniqueness_of :user_id, :scope => :badge_id
  belongs_to :user
  
  before_save {|record| record.created_at = Time.now}

  def badge
    puts "sdfsdf"
    Badge.new(badge_id)
  end
  
end
