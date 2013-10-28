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

class Rackspace < CloudProvider

  def connect!
    puts "I am in Base Class method connect! racky"
    @cloud_connection || nil
    puts "I am in Base Class method connect! #{@cloud_connection.inspect}"
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
    store_instance_list(instances_list,self.id) unless instances_list.empty?
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
    instance.image_id = data.image_id
    instance.cloud_provider_id = id
    instance.progress = data.progress
    instance.save
    return instance
  end

  def get_flavors
    flavors = Flavor.where(:flavour_type => "Rackspace")
    unless flavors.present?
      puts "#### i didn't get the flavours of my choices so i creating my own ####"
      Flavor.create_flavor_for_rackspace connect! ,"rackspace"
      return Flavor.where(:flavour_type => "Rackspace")
    end
    return flavors
  end

  def get_images
    images = Image.where(:flavour_type => "Rackspace")
    unless images.present?
      puts "#### i didn't get the images of my choices so i creating my own ####"
      Image.create_image_for_rackspace connect! ,"rackspace"
      return Image.where(:flavour_type => "Rackspace")
    end
    return images
  end

  def fetch_instances
    self.instances
  end

end
