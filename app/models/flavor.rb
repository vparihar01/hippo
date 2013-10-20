# == Schema Information
#
# Table name: flavors
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  flavor_id    :integer
#  vcpus        :string(255)
#  ram          :string(255)
#  disk         :string(255)
#  flavour_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Flavor < ActiveRecord::Base
  # attr_accessible :title, :body
  def self.create_flavor_for_rackspace (cloud_connection,flavour_type)
    flavor_list = cloud_connection.flavors
    store_flavor_list flavor_list, flavour_type
  end

  def self.store_flavor_list flavor_list,flavor_type
    flavor_list.each do |flavor|
      puts "_________________________"
      puts flavor.inspect
      puts "_________________________"
      initialize_flavor(flavor,flavor_type)
    end
  end

  def self.initialize_flavor data,flavor_type
    puts "################data  #{data}  #{flavor_type}"
    flavor = Flavor.new
    flavor.name = data.name
    flavor.ram = data.ram
    flavor.flavor_id = data.id
    flavor.vcpus = data.name
    flavor.disk = data.disk
    flavor.flavour_type = flavor_type
    flavor.save
  end

end
