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

  def test
    puts "In am in base racky class"
  end

 def self.initialize_rackspace_instance data,id
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