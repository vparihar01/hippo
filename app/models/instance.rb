class Instance < ActiveRecord::Base
  # attr_accessible :title, :body
  #validates_presence_of :name

  belongs_to :cloud_provider

  #
  # fetch instances
  #
  def self.get_instances connections,provider,id
    puts "################ID #{id}"
    instance_list=connections.servers
    store_instance_list(instance_list,provider,id)
    return "Complete"
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

  def self.store_instance_list instance_list,provider,id
    instance_list.each do |server|
      puts "_________________________"
      puts server.inspect
      puts "_________________________"
      provider=="aws" ?  Aws.initialize_aws_instance(server,id) : Rackspace.initialize_rackspace_instance(server,id)
    end
  end
end
