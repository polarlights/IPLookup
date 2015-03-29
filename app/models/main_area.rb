class MainArea < ActiveRecord::Base
  self.primary_key = "area_id"
  has_one :ipcode, foreign_key: :area_id
end
