class CreateMainAreas < ActiveRecord::Migration
  def change
    create_table :main_areas, id: false do |t|
      t.integer :area_id, default: 0
      t.string :area_name, default: ""
      t.integer :parent_id, default: 0
    end

    add_index :main_areas, :area_id, unique: true
    add_index :main_areas, :parent_id
  end
end
