class Aws < CloudProvider
  attr_reader :connect

  def connect!
    puts "I am in Base Class method connect! racky"
    @cloud_connection = nil
    @cloud_connection = Fog::Compute.new(
        {
            :provider                 => 'AWS',
            :aws_access_key_id        => self.key,
            :aws_secret_access_key    => self.secret
        })
  end

   def self.initialize_aws_instance data,id
    instance = Instance.new
    instance.public_ip = data.public_ip_address
    instance.private_ip = data.private_ip_address
    instance.flavor_id = data.flavor_id
    instance.name = data.tags['Name']
    instance.state = data.state
    instance.instance_id = data.id
    instance.cloud_provider_id = id
    instance.save
    return instance
  end

end