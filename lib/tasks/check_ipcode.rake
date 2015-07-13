namespace :iplookup do
  namespace :ipcode do
    task :check_invalid_data => :environment do
      sql = File.new("/tmp/ipcodes.sql", 'w')
      sql << "SET AUTOCOMMIT=0;\n"
      sql << "DELETE FROM ipcodes;\n"
      sql << "BEGIN;\n"
      sql << "INSERT INTO ipcodes(ip_begin, ip_end, area_code, remark) VALUES\n"
      country_file = File.new(Rails.root.join("no_country.txt"), 'w')
      city_file = File.new(Rails.root.join("no_city.txt"), 'w')
      town_file = File.new(Rails.root.join("no_town.txt"), 'w')
      regexp_xzq = /(.*行政区)/
      regexp_shi_qu = /(.*市)(.*[区县])?/
      regexp_sheng_shi_qu = /(.*省|.*自治区)(.*?[州|市]?[市州盟区])?(.*[市区县旗盟])?/
      all_countries = Country.all.to_a

      File.open(Rails.root.join("country.txt")).each do |file|
          ip_bein, ip_end, full_name, remark = file.split("|")
          remark.strip!.gsub!(/CZ88\.NET/, '')
          full_name.gsub!(/IANA\p{Han}*/, 'IANA')
          if full_name.match regexp_sheng_shi_qu
            province, city, town = $1, $2, $3
            result = area_province = Area.where(name: province).first
            if city && area_province
              area_city = Area.where(parent_code: area_province.area_code, name: city).first
              if area_city
                result = area_city
                if town
                  area_town = Area.where(parent_code: area_city.area_code, name: town).first
                  if area_town
                    result = area_town
                  else
                   town_file << "#{file}/#{province}/#{city}\n"
                  end #end of area_town
                end
              else
                city_file << "#{file}/#{province}/#{city}/#{area_province.area_code}\n"
              end #end of city
            end
          elsif full_name.match regexp_shi_qu
            province, city = $1, $2
            result = area_province = Area.where(name: province).first
            if city
              area_city = Area.where(parent_code: result.area_code, name: city).first
              if area_city
                result = area_city
              else
                city_file << "#{file}/#{province}/#{city}\n"
              end #end of city
            end

          elsif full_name.match regexp_xzq
            province = $1
            result = area_province = Area.where(name: province).first
          else
           country =  all_countries.select { |country| country.name_cn == full_name }.first
           if country
             result = Area.find_or_create_by(area_code: country.domain, name: country.name_cn)
           else
             country_file << "#{file}\n"
           end
          end

          if result.present?
            sql << "(#{ip_bein}, #{ip_end}, \"#{result.area_code}\", \"#{remark}\"),\n"
          end

      end

      sql << "COMMIT;\n"
      sql.close

    end
  end
end
