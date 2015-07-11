class CreateCountry < ActiveRecord::Migration
  def change
    create_table :countries, id: false do |t|
      t.string :domain, unique: true, index: true
      t.string :name_cn
      t.string :name_en
    end
  end
end
