class User < ActiveRecord::Base
  attr_accessible :email
  #validates_uniqueness_of :email

  def self.new_guest
    new { |u| u.guest = true }
  end

  def username
    guest ? "Guest" : name
  end

end
