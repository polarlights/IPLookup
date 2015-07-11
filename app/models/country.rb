class Country < ActiveRecord::Base
  has_many :country_areas, foreign_key: :domain
  has_many :areas, through: :country_areas

  self.primary_key = "domain"
end
