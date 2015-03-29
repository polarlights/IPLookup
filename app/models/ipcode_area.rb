class IpcodeArea
  require_relative 'qqwry'
  SPECIAL_PROVINCES = ['广西', '宁夏', '新疆', '西藏', '香港', '澳门']

  def convert_wrydb(filename = 'qqwry.dat')
    db = ::QQWry::QQWryFile.new(filename)
    file = File.new(File.join(File.expand_path('./'), 'ipcode_area.sql'), 'w')
    checkfile = File.new(File.join(File.expand_path('./'), 'ipcode_check_source.txt'), 'w')
    file.puts "TRUNCATE TABLE ipcodes;"
    file.puts "INSERT INTO ipcodes(ip_start, ip_end, area_id, other) VALUES"
    rowcount = db.count
    db.each do |idx, record|
      area_id = find(record.country) if record.country
      other = record.area
      if area_id.blank?
        area_id = 0
        other = "#{record.country}  #{other}"
      end
      file.puts "(#{idx.ip}, #{record.ip}, #{area_id}, '#{other}')#{record.ip < 4294967295 ? ',' : ';'}"
      area = MainArea.find(area_id) rescue nil
      checkfile.puts "#{record.country}, #{area && area.area_name}"
    end
  end

  def check_export_data
    output = File.new('checkout.sql','w')
    File.open('ipcode_area.sql').each do |line|
      str = line.split(",")[0]
      area = find(str, true)
      if area.present?
        cn = str.match(/(.*[省市古疆夏藏西])*(.*[市县区盟旗])/)[2] rescue "#{str}"
        output.puts "#{str}, #{cn}, #{area}" if area != cn
      else
        output.puts "NULL: #{str}"
      end
    end
    nil
  end

  def all_provinces
    @all_provinces ||= MainArea.where(parent_id: 0)
  end

  def find(area_name, is_area_str = false)
    province = all_provinces.select { |province| area_name.start_with?(province.area_name[0...2]) }.first
    if province
      if is_area_str
      result = province.area_name
      else
        result = province.area_id
      end

      if(province.area_name.start_with?('黑龙江'))
        province_name = '黑龙江省'
      elsif SPECIAL_PROVINCES.include?(province.area_name[0...2])
        province_name = province.area_name[0...2]
      else
        province_name = province.area_name[0..2]
      end

      city_name = area_name.match(/(#{province_name})(.*?(州市|[市州盟区])){0,1}(.*[市区县旗盟]){0,1}/)
      if city_name
        sub_city_name = city_name[2]
        sub_town_name = city_name[4]
        root_id = province.area_id.to_s[0..1]
        city = MainArea.where(area_name: sub_town_name).where.not(parent_id: 0).where("area_id like '#{root_id}%%%%'").first if sub_town_name.present?
        city = MainArea.where(area_name: sub_city_name).where.not(parent_id: 0).where("area_id like '#{root_id}%%%%'").first if sub_city_name.present? && !city
        if city && is_area_str
          result = city.area_name
        elsif city
          result = city.area_id
        end
      end
    end
    return result
  end

  def check_version(db)
    version = Ipcode.last
  end
end
