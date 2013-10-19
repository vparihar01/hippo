class Aws < CloudProvider
  attr_reader :connection

  def connect!
    @connection = nil
    @connection = Fog::Compute.new(
        {
            :provider                 => 'AWS',
            :rackspace_api_key        => self.key,
            :rackspace_username    => self.secret
        })
  end

end