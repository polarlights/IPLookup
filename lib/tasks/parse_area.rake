namespace :iplookup do
  namespace :area do
    desc "Download and parse the area code to database"
    task :parse_area_code => :environment do
      require 'nokogiri'
      require 'open-uri'

      source_url = ENV["SOURCE_URL"]
      unless source_url.present?
        STDOUT.print "Please set the SOURCE_URL\n"
        return
      end

      regexp_province = /[1-9]\d0{4}/
      regexp_city = /[1-9]\d{3}0{2}/
      shixiaqu = "市辖区"
      xian = "县"
      skip_area_names = [shixiaqu, xian]
      city_area_code, province_code = %w(NULL NULL)


      sql = File.open("/tmp/area_sql.sql", "w")
      province_sql = File.open("/tmp/province_country.sql", "w")
      sql << "SET AUTOCOMMIT=0;\n"
      province_sql << "SET AUTOCOMMIT=0;\n"
      sql << "DELETE FROM areas;\n"
      province_sql << "DELETE FROM country_areas;\n"
      sql << "INSERT INTO areas(area_code, parent_code, name) VALUES\n"
      province_sql << "INSERT INTO country_areas(domain, area_code) VALUES\n"

      doc = Nokogiri::HTML(open(source_url))
      doc.css(".xilan_con table tr").each do |tr|
        tds = tr.css("td p span")
        area_code = tds[0].text.strip
        area_name = tds[1].text.strip
        if area_name.match(/直辖县级行政区划/)
          city_area_code = province_code
          next
        end
        next if skip_area_names.include? area_name
        if area_code.match(regexp_province)
          parent_code = 'NULL'
          city_area_code = province_code = area_code
          province_sql << "(\"CN\", \"#{area_code}\"),\n"
        elsif area_code.match(regexp_city)
          parent_code = province_code
          city_area_code = area_code
        else
          parent_code = city_area_code
        end
        sql << "(#{area_code}, #{parent_code}, \"#{area_name}\"),\n"
      end

      sql << "(710000, NULL, \"台湾省\"),\n"
      sql << "(810000, NULL, \"香港特别行政区\"),\n"
      sql << "(820000, NULL, \"澳门特别行政区\");\n"
      province_sql << "(\"CN\", \"710000\"),\n(\"CN\", \"810000\"),\n(\"CN\", \"820000\");\n"
      sql << "COMMIT;\n"
      province_sql << "COMMIT;\n"
      sql.close
      province_sql.close
    end #end of task
  end
end
