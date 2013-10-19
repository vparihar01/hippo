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

end