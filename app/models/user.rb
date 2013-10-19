class User < ActiveRecord::Base
  attr_accessible :email
  #validates_uniqueness_of :email

  def self.new_guest
    new { |u| u.guest = true }
  end

  def move_to(user)
    tasks.update_all(user_id: user.id)
  end
end
