# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  guest           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email
  has_many :cloud_providers
  #validates_uniqueness_of :email

  after_create {|user|
    thread = Thread.new do
      Notifier.welcome(user).deliver #Send Welcome email after registrationssss
    end
    thread.run
  }
  def self.new_guest
    new { |u| u.guest = true }
  end

  def username
    guest ? "Guest" : name
  end

end
