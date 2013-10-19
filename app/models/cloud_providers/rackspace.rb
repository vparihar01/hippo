class Rackspace < CloudProvider

  def connect!
    puts "I am in Base Class method connect! racky"

    @cloud_connection = nil
    @cloud_connection = Fog::Compute.new(
        {
            :provider                 => 'Rackspace',
            :rackspace_api_key        => self.key,
            :rackspace_username    => self.secret ,
            :rackspace_region => :ord
        })
  end

  def fetch_cloud_data
    connect!
    puts "######connection###{@cloud_connection.inspect}#############"
    instances_list=Instance.get_instances(@cloud_connection,self.id)
    puts "######instances_list###{instances_list.inspect}#############"
    store_instance_list(instances_list,self.id)
    #self.state = server_status
    self.save
  end

  def store_instance_list instance_list,id
    instance_list.each do |server|
      puts "_________________________"
      puts server.inspect
      puts "_________________________"
      initialize_instance(server,id)
    end
  end

  def initialize_instance data,id
    puts "################ID #{id}"
    instance = Instance.new
    instance.public_ip = data.addresses["public"]
    instance.private_ip = data.addresses["private"]
    instance.flavor_id = data.flavor_id
    instance.name = data.name
    instance.instance_id = data.id
    instance.state = data.state
    instance.cloud_provider_id = id
    instance.save
    return instance
  end

end