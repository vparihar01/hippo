class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.string :title
      t.string :instance_id
      t.string :state
      t.string :flavor_id
      t.string :name
      t.string :private_ip
      t.string :public_ip
      t.string :cloud_provider_id

      t.timestamps
    end
  end
end
