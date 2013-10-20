class CreateFlavors < ActiveRecord::Migration
  def change
    create_table :flavors do |t|
      t.string :name
      t.integer :flavor_id
      t.string :vcpus
      t.string :ram
      t.string :disk
      t.string :flavour_type
      t.timestamps
    end
  end
end
