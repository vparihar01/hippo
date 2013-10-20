# == Schema Information
#
# Table name: instances
#
#  id                :integer          not null, primary key
#  title             :string(255)
#  instance_id       :string(255)
#  state             :string(255)
#  flavor_id         :string(255)
#  name              :string(255)
#  private_ip        :string(255)
#  public_ip         :string(255)
#  cloud_provider_id :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  image_id          :string(255)
#  progress          :string(255)
#

class Instance < ActiveRecord::Base
  attr_accessible :title, :body, :instance_id, :state, :flavor_id, :name,:private_ip, :public_ip, :image_id, :progress
  #validates_presence_of :name

  belongs_to :cloud_provider

  #
  # fetch instances
  #
  def self.get_instances connections,id
    puts "################ID #{id}"
    instance_list=connections.servers
    return instance_list
  end

  #
  # stopping / starting
  #

  def stop_instance(instance)
    if instance
      puts "Stopping instance: " + instance_to_stop.inspect
      @ec2.stop_instances({:instance_id => instance})
    else
      puts "No instances to stop"
    end
  end

  def start_instances(instance)
    if instance
      puts "Starting instances: " + instance.inspect
      @compute.servers.get(instance).start
    else
      puts "No instances to start"
    end
  end


  def reboot_instances(instance)
    if instance
      puts "Starting instances: " + instance.inspect
      @compute.servers.get(instance).reboot
    else
      puts "No instances to start"
    end
  end

  def create_instance(cloud_connection)
    logger.info("INside the thread ##############################")
    logger.info("##############{cloud_connection.inspect}#################")
    thread = Thread.new do
      if self.cloud_provider.type.include?("Aws")
        InstanceOperations.aws_create(cloud_connection,self)
      else
        InstanceOperations.rackspace_create(cloud_connection,self)
      end
    end
    thread.run
  end

  def resize_instance(cloud_connection)
    if self.cloud_provider.type.include?("Aws")
      InstanceOperations.resize_aws__instance(cloud_connection,self)
    else
      InstanceOperations.resize_rackspace_instance(cloud_connection,self)
    end
  end

  private

end
