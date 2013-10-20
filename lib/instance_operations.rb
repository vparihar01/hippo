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
###########################################################################################
  def resize_rackspace_instance(service,flavor_id)
    servers = service.servers
    #prompt user for server
    server = select_server(servers)
    # retrieve list of avaliable flavors
    flavors = service.flavors
    # prompt user for flavor
    selected_flavor = select_flavor(flavors, server)
    # resize server
    server.resize selected_flavor.id
    puts "\n"
    # wait for the resize process to start
    server.wait_for { ready?('RESIZE') } 
    begin
      # Check every 5 seconds to see if server is in the VERIFY_RESIZE state. 
      # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
      server.wait_for(1200, 5) do
        print "."
        STDOUT.flush
        ready?('VERIFY_RESIZE', ['ACTIVE', 'ERROR'])
      end
      puts "[DONE]\n\n"      
      puts "Server Has Been Successfully Resized!"
      action = get_user_input "Press 'C' To Confirm Or 'R' to Revert Resize (R/C)"
      case action.upcase
      when 'C'
        puts "\nConfirming Resize Operation"
        server.confirm_resize
      when 'R'
        puts "\nReverting Resize Operation"
        server.revert_resize
      else
        puts "\nUnrecognized Input. Exiting."
      end      
    rescue Fog::Errors::TimeoutError
      puts "[TIMEOUT]\n\n"      
      puts "This server is currently #{server.progress}% into the resize process and is taking longer to complete than expected."
      puts "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n" 
    end
  end
end