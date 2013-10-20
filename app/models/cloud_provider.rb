# == Schema Information
#
# Table name: cloud_providers
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  name       :string(255)
#  provider   :string(255)
#  secret     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)
#  user_id    :integer
#

class CloudProvider < ActiveRecord::Base

  #require 'instance_states.rb'
  #include InstanceStates
  #cattr_accessor :STATES

  attr_accessible :key, :name, :provider, :secret, :type, :user_id
  attr_reader :connect

  after_create :fetch_cloud_data

  has_many :instances
  belongs_to :user

  def connect!
    @cloud_connection = nil
    puts "I am in Super Class method connect!"
  end

  #To Make The Parent Class Aware of Its Children

  def self.select_options
    puts "#######{descendants.map{ |c| c.to_s.camelcase }.sort}"
    descendants.map{ |c| c.to_s }.sort
  end

  def self.inherited(child)
    child.instance_eval do
      def model_name
        CloudProvider.model_name
      end
    end
    super
  end

end

require_dependency "cloud_providers/aws.rb"
require_dependency "cloud_providers/rackspace.rb"
