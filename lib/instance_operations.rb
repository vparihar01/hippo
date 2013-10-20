class InstanceOperations
  def self.rackspace_create(cloud_connection,instance)
    # create server
    Rails.logger "Inside rackspace create #{cloud_connection}  image_id #{instance.image_id}  flavor_id #{instance.flavor_id}"
    server = cloud_connection.servers.create :name => instance.name,
                                             :flavor_id => instance.flavor_id,
                                             :image_id => instance.image_id,
                                             :metadata => { 'fog_sample' => 'true'},
                                             :personality => [{
                                                                  :path => '/root/fog.txt',
                                                                  :contents => Base64.encode64('Fog was here!')
                                                              }]

    # reload flavor in order to retrieve all of its attributes
    Rails.logger "\nNow creating server '#{server.name}' the following with specifications:\n"
    instance.update_attributes(:instance_id => server.id)
    instance.save
    #puts "\t* #{flavor.ram} MB RAM"
    #puts "\t* #{flavor.disk} GB"
    #puts "\t* #{flavor.vcpus} CPU(s)"
    #puts "\t* #{image.name}"

    Rails.logger "\n"

    begin
      # Check every 5 seconds to see if server is in the active state (ready?).
      # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
      server.wait_for(600, 5) do
        Rails.logger "."
        instance.update_attributes(:progress => server.progress)
        break if ready?
      end

      Rails.logger "[DONE]\n\n"

      Rails.logger "The server has been successfully created, to login onto the server:\n\n"
      Rails.logger "\t ssh #{server.username}@#{server.public_ip_address}\n\n"
      instance.update_attributes(:progress => server.progress,
                                 :state => server.state,
                                 :public_ip => server.addresses["public"],
                                 :private_ip => server.addresses["private"])
    rescue Fog::Errors::TimeoutError
      Rails.logger "[TIMEOUT]\n\n"
      Rails.logger "This server is currently #{server.progress}% into the build process and is taking longer to complete than expected."
      Rails.logger "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n"
    end
    Rails.logger "The #{server.username} password is #{server.password}\n\n"
    Rails.logger "To delete the server please execute the delete_server.rb script\n\n"
  end
  def self.aws_create(cloud_connection,instance)
    # create server
    Rails.logger "Inside aws create #{cloud_connection}  image_id #{instance.image_id}  flavor_id #{instance.flavor_id}"
    server = cloud_connection.servers.create :name => instance.name,
                                             :flavor_id => instance.flavor_id,
                                             :image_id => instance.image_id,
                                             :metadata => { 'fog_sample' => 'true'},
                                             :personality => [{
                                                                  :path => '/root/fog.txt',
                                                                  :contents => Base64.encode64('Fog was here!')
                                                              }]

    # reload flavor in order to retrieve all of its attributes
    Rails.logger "\nNow creating server '#{server.tags['Name']}' the following with specifications:\n"
    instance.update_attributes(:instance_id => server.id)
    instance.save
    #puts "\t* #{flavor.ram} MB RAM"
    #puts "\t* #{flavor.disk} GB"
    #puts "\t* #{flavor.vcpus} CPU(s)"
    #puts "\t* #{image.name}"

    Rails.logger "\n"

    begin
      # Check every 5 seconds to see if server is in the active state (ready?).
      # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
      server.wait_for(600, 5) do
        Rails.logger "."
        break if ready?
      end

      Rails.logger "[DONE]\n\n"

      Rails.logger "The server has been successfully created, to login onto the server:\n\n"
      Rails.logger "\t #{server.public_ip_address}\n\n"
      instance.update_attributes(:public_ip => server.public_ip_address,
                                 :state => server.state,
                                 :private_ip => server.private_ip_address)
    rescue Fog::Errors::TimeoutError
      Rails.logger "[TIMEOUT]\n\n"
      Rails.logger "This server is currently #{server}% into the build process and is taking longer to complete than expected."
      Rails.logger "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n"
    end


  end
end