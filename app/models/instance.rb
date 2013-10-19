class Instance < ActiveRecord::Base
  # attr_accessible :title, :body
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

private

end
