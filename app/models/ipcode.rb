class Ipcode < ActiveRecord::Base
  self.primary_key = "ip_start"
  belongs_to :area, class_name: "MainArea", foreign_key: 'area_id'
end
