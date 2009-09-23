class User < ActiveRecord::Base

  def personal_info
    attributes
  end
  
end
