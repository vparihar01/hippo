class CloudProvider < ActiveRecord::Base

  # require 'instance_states.rb'
  # include InstanceStates
  # cattr_accessor :STATES
  attr_accessible :key, :name, :provider, :secret, :type
  attr_reader :connect

  after_create :connect

  has_many :instances

  def connect
    @connection = nil
    @connection = Fog::Compute.new(
        {
            :provider                 => self.type,
            :rackspace_api_key        => self.key,
            :rackspace_username    => self.secret
        })
    puts "######connection###{@connection.inspect}#############"
    server_status=Instance.get_instances(@connection,self.type.downcase,self.id)
    puts "######server_status###{server_status.inspect}#############"
    #self.state = server_status
    self.save
  end


  #To Make The Parent Class Aware of Its Children

  def self.select_options
    puts "#######{descendants.map{ |c| c.to_s }.sort}"
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

