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
#

class Instance < ActiveRecord::Base
  attr_accessible :title, :body, :instance_id, :state, :flavor_id, :name
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

  def create_instance
    InstanceOperations.rackspace_create(self.name,self.flavor_id,self.image_id)
  end

private

end
