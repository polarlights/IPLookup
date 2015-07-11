class CountryArea < ActiveRecord::Base
  belongs_to :country, foreign_key: :domain
  belongs_to :area, foreign_key: :area_code
end
