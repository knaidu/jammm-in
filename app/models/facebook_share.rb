class FacebookShare < ActiveRecord::Base
  belongs_to :user
  set_table_name "facebook_share"
  validates_presence_of :user_id
end