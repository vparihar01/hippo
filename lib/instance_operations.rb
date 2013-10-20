class InstanceOperations
	

	def self.rackspace_create(cloud_connection,server_name,flavor_id,image_id)
		 # create server
    Rails.logger.info "Inside rackspace create #{cloud_connection}  image_id #{image_id}  flavor_id #{flavor_id}"
   server = cloud_connection.servers.create :name => server_name,
                                   :flavor_id => flavor_id, 
                                   :image_id => image_id,
                                   :metadata => { 'fog_sample' => 'true'},
                                   :personality => [{
                                     :path => '/root/fog.txt',
                                     :contents => Base64.encode64('Fog was here!')
                                   }]

   # reload flavor in order to retrieve all of its attributes
   Rails.logger.info "\nNow creating server '#{server.name}' the following with specifications:\n" 
   #Rails.logger.info "\t* #{flavor.ram} MB RAM"
   #Rails.logger.info "\t* #{flavor.disk} GB"
   #Rails.logger.info "\t* #{flavor.vcpus} CPU(s)"
   #Rails.logger.info "\t* #{image.name}"

   Rails.logger.info "\n"

   begin
     # Check every 5 seconds to see if server is in the active state (ready?). 
     # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
     server.wait_for(600, 5) do
       print "."
       STDOUT.flush
       ready?
     end

     Rails.logger.info "[DONE]\n\n"

     Rails.logger.info "The server has been successfully created, to login onto the server:\n\n"
     Rails.logger.info "\t ssh #{server.username}@#{server.public_ip_address}\n\n"

   rescue Fog::Errors::TimeoutError
     Rails.logger.info "[TIMEOUT]\n\n"
     Rails.logger.info "This server is currently #{server.progress}% into the build process and is taking longer to complete than expected."
     Rails.logger.info "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n" 
   end
   Rails.logger.info "The #{server.username} password is #{server.password}\n\n"
   Rails.logger.info "To delete the server please execute the delete_server.rb script\n\n"

	end
end