class PromotionCode < ActiveRecord::Base
  has_many :promotion_code_users, :dependent => :destroy
  
  def self.add(invites_remaining=50)
    self.create({
      :code => rand_word.upcase,
      :invites_remaining => invites_remaining
    })
  end
  
  def self.pc_from_code_str(code_str)
    c = code_str.split(";")[0].split("-")[0]
    self.find_by_code(c)
  end
  
  def decrement_invites_remaining
    self.invites_remaining = self.invites_remaining - 1
    self.save
  end
  
  def register_user(user)
    PromotionCodeUser.add(self, user)
  end
  
  def signup_link
    "http://jammm.in#code=#{code}-#{self.id};code"
  end
  
end

class PromotionCodeUser < ActiveRecord::Base
  belongs_to :promotion_code
  
  def self.add(pc, user)
    self.create(:promotion_code_id => pc.id, :user_id => user.id)
  end
  
end
