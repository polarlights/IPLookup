class CreateAreaCountry < ActiveRecord::Migration
  def change
    create_table :country_areas, id: false do |t|
      t.string :area_code, index: true, foreign_key: true
      t.string :domain, index: true, foreign_key: true
    end
  end
end
