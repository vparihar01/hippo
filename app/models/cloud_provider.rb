class CloudProvider < ActiveRecord::Base

<<<<<<< HEAD
  #require 'instance_states.rb'
  #include InstanceStates
  #cattr_accessor :STATES
=======
  # require 'instance_states.rb'
  # include InstanceStates
  # cattr_accessor :STATES
>>>>>>> 5b419e2b090f3506a8c6f1e0edcacc5769409fc8
  attr_accessible :key, :name, :provider, :secret, :type
  attr_reader :connect

  after_create :fetch_cloud_data

  has_many :instances
  belongs_to :user

  def connect!
    @cloud_connection = nil
    puts "I am in Super Class method connect!"
  end

  def test
    puts "In am in super class"
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
<<<<<<< HEAD


  def fetch_cloud_data
    connect!
    puts "######connection###{@cloud_connection.inspect}#############"
    server_status=Instance.get_instances(@cloud_connection,self.type.downcase,self.id)
    puts "######server_status###{server_status.inspect}#############"
    #self.state = server_status
    self.save
  end
end
=======
end

>>>>>>> 5b419e2b090f3506a8c6f1e0edcacc5769409fc8
