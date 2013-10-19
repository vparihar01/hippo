class AddUserIdToCloudProvider < ActiveRecord::Migration
  def change
  	add_column :cloud_providers, :user_id, :integer
  end
end
