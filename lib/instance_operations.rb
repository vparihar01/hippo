class InstanceOperations
	

	def self.rackspace_create(server_name,flavor_id,image_id)
		 # create server
   server = service.servers.create :name => server_name, 
                                   :flavor_id => flavor_id, 
                                   :image_id => image_id,
                                   :metadata => { 'fog_sample' => 'true'},
                                   :personality => [{
                                     :path => '/root/fog.txt',
                                     :contents => Base64.encode64('Fog was here!')
                                   }]

   # reload flavor in order to retrieve all of its attributes
   flavor.reload

   puts "\nNow creating server '#{server.name}' the following with specifications:\n" 
   puts "\t* #{flavor.ram} MB RAM"
   puts "\t* #{flavor.disk} GB"
   puts "\t* #{flavor.vcpus} CPU(s)"
   puts "\t* #{image.name}"

   puts "\n"

   begin
     # Check every 5 seconds to see if server is in the active state (ready?). 
     # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
     server.wait_for(600, 5) do
       print "."
       STDOUT.flush
       ready?
     end

     puts "[DONE]\n\n"

     puts "The server has been successfully created, to login onto the server:\n\n"
     puts "\t ssh #{server.username}@#{server.public_ip_address}\n\n"

   rescue Fog::Errors::TimeoutError
     puts "[TIMEOUT]\n\n"
     puts "This server is currently #{server.progress}% into the build process and is taking longer to complete than expected."
     puts "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n" 
   end
   puts "The #{server.username} password is #{server.password}\n\n"
   puts "To delete the server please execute the delete_server.rb script\n\n"

	end
end