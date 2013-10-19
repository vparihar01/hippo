class Rackspace < CloudProvider

  def connect!
    puts "I am in Base Class method connect! racky"

    @cloud_connection = nil
    @cloud_connection = Fog::Compute.new(
        {
            :provider                 => 'Rackspace',
            :rackspace_api_key        => self.key,
            :rackspace_username    => self.secret
        })
  end

  def test
    puts "In am in base racky class"
  end

end