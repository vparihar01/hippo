class AddTypeToCloudProvider < ActiveRecord::Migration
  def change
    add_column :cloud_providers , :type , :string
  end
end
