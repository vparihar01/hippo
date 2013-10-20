class InstanceOperations
  def self.rackspace_create(cloud_connection,instance)
    # create server
    puts "Inside rackspace create #{cloud_connection}  image_id #{instance.image_id}  flavor_id #{instance.flavor_id}"
    server = cloud_connection.servers.create :name => instance.name,
                                             :flavor_id => instance.flavor_id,
                                             :image_id => instance.image_id,
                                             :metadata => { 'fog_sample' => 'true'},
                                             :personality => [{
                                                                  :path => '/root/fog.txt',
                                                                  :contents => Base64.encode64('Fog was here!')
                                                              }]

    # reload flavor in order to retrieve all of its attributes
    puts "\nNow creating server '#{server.name}' the following with specifications:\n"
    instance.update_attributes(:instance_id => server.id)
    instance.save
    #puts "\t* #{flavor.ram} MB RAM"
    #puts "\t* #{flavor.disk} GB"
    #puts "\t* #{flavor.vcpus} CPU(s)"
    #puts "\t* #{image.name}"

    puts "\n"

    begin
      # Check every 5 seconds to see if server is in the active state (ready?).
      # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
      server.wait_for(600, 5) do
        puts "."
        instance.update_attributes(:progress => server.progress)
        break if ready?
      end

      puts "[DONE]\n\n"

      puts "The server has been successfully created, to login onto the server:\n\n"
      puts "\t ssh #{server.username}@#{server.public_ip_address}\n\n"
      instance.update_attributes(:progress => server.progress,
                                 :state => server.state,
                                 :public_ip => server.addresses["public"],
                                 :private_ip => server.addresses["private"])
    rescue Fog::Errors::TimeoutError
      puts "[TIMEOUT]\n\n"
      puts "This server is currently #{server.progress}% into the build process and is taking longer to complete than expected."
      puts "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n"
    end
    puts "The #{server.username} password is #{server.password}\n\n"
    puts "To delete the server please execute the delete_server.rb script\n\n"

  end
end