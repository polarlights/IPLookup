namespace :iplookup do
  namespace :area do
    desc "Download and parse the area code to database"
    task :parse_country_data => :environment do
      require 'open-uri'
      require 'nokogiri'

      sql = File.open("/tmp/country_sql.sql", "w")
      sql << "ActiveRecord::Base.transaction do\n"
      source_url = "http://mysf.mofcom.gov.cn/jsp/country_code.jsp"
      doc = Nokogiri::HTML(open(source_url))
      doc.css("table.pb_table tbody tr").each do |tr|
       domain, name_en, name_cn = tr.css("td:not(:first)").map(&:text)
       sql << "Country.create(domain: \"#{domain}\", name_cn: \"#{name_cn}\", name_en: \"#{name_en}\");\n"
      end
      sql << "end\n"
      sql.close
    end
  end
end
