class CreateTableArea < ActiveRecord::Migration
  def change
    create_table :areas, id: false do |t|
      t.string :area_code, unique: true, index: true
      t.string :parent_code, index: true
      t.string :name
    end
  end
end
