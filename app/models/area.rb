class Area < ActiveRecord::Base
  has_one :country_area, foreign_key: :area_code
  has_one :country, through: :country_area

  self.primary_key = "area_code"
end
