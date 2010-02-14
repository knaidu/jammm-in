class TwitterShare < ActiveRecord::Base
  belongs_to :user
  set_table_name "twitter_share"
  validates_presence_of :user_id
  
end