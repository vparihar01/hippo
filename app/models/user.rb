class User < ActiveRecord::Base
  attr_accessible :email
  has_many :cloud_providers
  #validates_uniqueness_of :email

  def self.new_guest
    new { |u| u.guest = true }
  end

  def username
    guest ? "Guest" : name
  end

end
