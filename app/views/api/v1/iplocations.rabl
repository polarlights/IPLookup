object nil
node(:country) { |area| country.name }
node(:country_id) { |area| country.domain }
node(:province) { |area| area.root.name }
node(:province_id) { |area| area.root.area_code }
node(:city) { |area| area.city.try(:name) }
node(:city_id) { |area| area.city.try(:area_code) }
node(:town) { |area| area.town.name }
node(:town_id) { |area| area.town.area_code }
attributes :remark, :ip
