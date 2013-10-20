class InstanceOperations
  require 'rufus/scheduler'

  def self.rackspace_create(cloud_connection,instance)
    # create server
    Rails.logger.info "Inside rackspace create #{cloud_connection}  image_id #{instance.image_id}  flavor_id #{instance.flavor_id}"
    server = cloud_connection.servers.create :name => instance.name,
                                             :flavor_id => instance.flavor_id,
                                             :image_id => instance.image_id,
                                             :metadata => { 'fog_sample' => 'true'},
                                             :personality => [{
                                                                  :path => '/root/fog.txt',
                                                                  :contents => Base64.encode64('Fog was here!')
                                                              }]

    # reload flavor in order to retrieve all of its attributes
    Rails.logger.info "\nNow creating server '#{server.name}' the following with specifications:\n"
    instance.update_attributes(:instance_id => server.id)
    instance.save
    #puts "\t* #{flavor.ram} MB RAM"
    #puts "\t* #{flavor.disk} GB"
    #puts "\t* #{flavor.vcpus} CPU(s)"
    #puts "\t* #{image.name}"

    Rails.logger.info "\n"

    begin
      # Check every 5 seconds to see if server is in the active state (ready?).
      # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
      server.wait_for(600, 5) do

        Rails.logger.info "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        instance.update_attributes(:progress => server.progress)
        break if ready?
      end
      Rails.logger.info "[DONE]\n\n"

      Rails.logger.info "The server has been successfully created, to login onto the server:\n\n"
      Rails.logger.info "\t ssh #{server.username}@#{server.public_ip_address}\n\n"
      instance.update_attributes(:progress => server.progress,
                                 :state => server.state,
                                 :public_ip => server.addresses["public"],
                                 :private_ip => server.addresses["private"])
    rescue Fog::Errors::TimeoutError
      Rails.logger.info "[TIMEOUT]\n\n"
      Rails.logger.info "This server is currently #{server.progress}% into the build process and is taking longer to complete than expected."
      Rails.logger.info "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n"
    end
    Rails.logger.info "The #{server.username} password is #{server.password}\n\n"
    Rails.logger.info "To delete the server please execute the delete_server.rb script\n\n"
  end
  def self.aws_create(cloud_connection,instance)
    # create server
    Rails.logger.info "Inside aws create #{cloud_connection}  image_id #{instance.image_id}  flavor_id #{instance.flavor_id}"
    server = cloud_connection.servers.create :name => instance.name,
                                             :flavor_id => instance.flavor_id,
                                             :image_id => instance.image_id,
                                             :metadata => { 'fog_sample' => 'true'},
                                             :personality => [{
                                                                  :path => '/root/fog.txt',
                                                                  :contents => Base64.encode64('Fog was here!')
                                                              }]

    # reload flavor in order to retrieve all of its attributes
    Rails.logger.info "\nNow creating server '#{server.inspect}' the following with specifications:\n"
    instance.update_attributes(:instance_id => server.id)
    instance.save
    #puts "\t* #{flavor.ram} MB RAM"
    #puts "\t* #{flavor.disk} GB"
    #puts "\t* #{flavor.vcpus} CPU(s)"
    #puts "\t* #{image.name}"

    Rails.logger.info "\n"

    begin
      # Check every 5 seconds to see if server is in the active state (ready?).
      # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
      server.wait_for(600, 5) do
        Rails.logger.info "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        break if ready?
      end

      Rails.logger.info "[DONE]\n\n"
      Rails.logger.info "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"

      Rails.logger.info "The server has been successfully created, to login onto the server:\n\n"
      Rails.logger.info "\t #{server.public_ip_address}\n\n"
      instance.update_attributes(:public_ip => server.public_ip_address,
                                 :state => server.state,
                                 :private_ip => server.private_ip_address)
    rescue Fog::Errors::TimeoutError
      Rails.logger.info "[TIMEOUT]\n\n"
      Rails.logger.info "This server is currently #{server}% into the build process and is taking longer to complete than expected."
      Rails.logger.info "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n"
    end


  end
###########################################################################################
  def self.resize_rackspace_instance(service,instance)
    scheduler = Rufus::Scheduler.new


    flavor = instance.flavor_id
    puts "flavor   #{flavor.inspect}"
    # prompt user for flavor
    # resize server
    service.resize_server(instance.instance_id,flavor)
    puts "\n"
    begin
      # Check every 5 seconds to see if server is in the VERIFY_RESIZE state. 
      # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
      instance.update_attributes(:state => "Resizing")
      puts "[DONE]\n\n"
      puts "Server Has Been Successfully Resized!"
      scheduler.in '20m' do
        service.confirm_resize_server(instance.instance_id)
        instance.update_attributes(:state => "Active")

      end


    rescue Fog::Errors::TimeoutError
      puts "[TIMEOUT]\n\n"
      puts "This server is currently #{server.progress}% into the resize process and is taking longer to complete than expected."
      puts "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n"
    end
  end

  def self.resize_aws__instance(service,instance)
    scheduler = Rufus::Scheduler.new


    flavor = instance.flavor_id
    puts "flavor   #{flavor.inspect}"
    # prompt user for flavor
    # resize server
    service.resize_server(instance.instance_id,flavor)
    puts "\n"
    begin
      # Check every 5 seconds to see if server is in the VERIFY_RESIZE state.
      # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
      instance.update_attributes(:state => "Resizing")
      puts "[DONE]\n\n"
      puts "Server Has Been Successfully Resized!"
      scheduler.in '20m' do
        service.confirm_resize_server(instance.instance_id)
        instance.update_attributes(:state => "Active")

      end


    rescue Fog::Errors::TimeoutError
      puts "[TIMEOUT]\n\n"
      puts "This server is currently #{server.progress}% into the resize process and is taking longer to complete than expected."
      puts "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n"
    end
  end

  def self.stop_aws(instance,cloud_connection)
    cloud_connection.stop_instances(instance.instance_id)
  end

  def self.start_aws(instance,cloud_connection)
    cloud_connection.start_instances(instance.instance_id)
  end

  def self.reboot_instances(cloud_connection, instance)
    scheduler = Rufus::Scheduler.new
    if instance
      cloud_connection.servers.get(instance.instance_id).reboot
      instance.update_attributes(:state => "Rebooting")
      scheduler.in '2m' do
        if instance.cloud_provider.type.include?("Aws")
          instance.update_attributes(:state => "running")
        else
          instance.update_attributes(:state => "Active")
        end
      end
    else
      puts "No instances to start"
    end
  end


end