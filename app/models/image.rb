# == Schema Information
#
# Table name: images
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  image_id     :integer
#  min_disk     :string(255)
#  min_ram      :string(255)
#  flavour_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Image < ActiveRecord::Base
  # attr_accessible :title, :body
  def self.create_image_for_rackspace (cloud_connection,flavour_type)
    image_list = cloud_connection.images
    store_image_list image_list, flavour_type
  end

  def self.store_image_list image_list,flavor_type
    image_list.each do |image|
      puts "_________________________"
      puts image.inspect
      puts "_________________________"
      initialize_image(image,flavor_type)
    end
  end

  def self.initialize_image data,flavor_type
    puts "################data  #{data}  #{flavor_type}"
    image = Image.new
    image.name = data.name
    image.min_disk = data.minDisk
    image.min_ram = data.minRam
    image.flavour_type = flavor_type
    image.save
  end
end
