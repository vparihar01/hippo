class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :image_id
      t.string :min_disk
      t.string :min_ram
      t.string :flavour_type
      t.timestamps
    end

    add_column :instances, :image_id ,:string
    add_column :instances, :progress ,:string
  end
end
