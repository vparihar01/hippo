class CreateCloudProviders < ActiveRecord::Migration
  def change
    create_table :cloud_providers do |t|
      t.string :key
      t.string :name
      t.string :provider
      t.string :secret

      t.timestamps
    end
  end
end
