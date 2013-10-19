class CloudProvider < ActiveRecord::Base

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

  def fetch_cloud_data
    connect!
    puts "######connection###{@cloud_connection.inspect}#############"
    server_status=Instance.get_instances(@cloud_connection,self.type.downcase,self.id)
    puts "######server_status###{server_status.inspect}#############"
    #self.state = server_status
    self.save
  end
end
