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

  def self.new_guest
    new { |u| u.guest = true }
  end

  def username
    guest ? "Guest" : name
  end

  def update_instances
    self.cloud_providers.each do |c|
      cloud_connection = c.connect!
      instances = c.fetch_instances
      InstanceOperations.compare_instance_data(cloud_connection,instances)
    end
  end

end
