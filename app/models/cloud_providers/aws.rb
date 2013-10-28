# == Schema Information
#
# Table name: cloud_providers
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  name       :string(255)
#  provider   :string(255)
#  secret     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)
#  user_id    :integer
#

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

  def fetch_cloud_data
    connect!
    puts "######connection###{@cloud_connection.inspect}#############"
    instances_list=Instance.get_instances(@cloud_connection,self.id)
    puts "######instances_list###{instances_list.inspect}#############"
    store_instance_list(instances_list,self.id)  unless instances_list.empty?
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

  def get_flavors
    flavors = Flavor.where(:flavour_type => "aws")
    unless flavors.present?
      puts "#### i didn't get the flavours of my choices so i creating my own ####"
      Flavor.create_flavor_for_rackspace connect! ,"aws"
      return Flavor.where(:flavour_type => "aws")
    end
    return flavors
  end

  def get_images
    images = Image.where(:flavour_type => "aws")
    return images
  end

  def fetch_instances
    self.instances
  end

end
