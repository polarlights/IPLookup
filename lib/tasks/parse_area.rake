namespace :iplookup do
  namespace :area do
    desc "Download and parse the area code to database"
    task :parse_area_code => :environment do
      require 'nokogori'
      require 'open-uri'

      source_url = env["SOURCE_URL"]
      unless source_url.present?
        STDOUT.print "Please set the SOURCE_URL\n"
        return
      end

      regexp_province = /[1-9]{2}0{4}/
      regexp_city = /[1-9]{2}\d[1-9]{1}0{2}/
      parent_id = 0

      sql = File.open("/tmp/area_sql.sql", "w")
      sql << "SET AUTOCOMMIT=0;\n"
      sql << "DELETE area;\n"
      sql << "INSERT INTO area(area_code, parent_code, name) VALUES"

      doc = Nokogiri::HTML(open(source_url))
      doc.css(".xilan_con table tr").each do |tr|
        tr.css("td p span").each do |td|
          sql << "insert into "
        end
      end
    end
  end
end
