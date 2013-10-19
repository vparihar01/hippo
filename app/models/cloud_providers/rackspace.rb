class Rackspace < CloudProvider


  def connect!
    @connection = nil
    @connection = Fog::Compute.new(
        {
            :provider                 => 'Rackspace',
            :rackspace_api_key        => self.key,
            :rackspace_username    => self.secret
        })
  end

end