#!/usr/bin/env ruby
#
#This script will download provinces data from http://www.stats.gov.cn/tjsj/tjbz/, and convert it to sql file. 
#
#SQL Database Structure
#
#exp: 130421 邯郸县, It's 河北省邯郸市邯郸县
# area_id: integer.  the province id. ie: 130421:  邯郸县 
# area_name: string. the name of the area. 邯郸县
# parent_id: integer. the parent id of the area. id: 130400
#
# Unique Index: idx_area_id(area_id); 
# Index:  idx_parent_id(parent_id)

require 'nokogiri'
require 'open-uri'

class String
  BLANK_RE = /\A[[:space:]]*\z/

  def blank?
    BLANK_RE === self
  end
end

class Area
  attr_reader :parent_id, :area_id, :area_name

  def initialize(area_id, parent_id, area_name)
    @area_id = area_id
    @parent_id = parent_id
    @area_name = area_name
  end

  class << self
    @@nbsp = Nokogiri::HTML("&nbsp;").text
    @@top_parent_id = nil
    @@sub_parent_id = nil

    def parse_area(area_str)
      area_code, area_name = strip_nbsp(area_str).split
      if area_code.end_with?("0000") #It's a top area. end with XX0000
        @@top_parent_id = area_code
        @@sub_parent_id = 0
        parent_id = 0
      elsif area_code.end_with?("00") #It's match XXXX00
        @@sub_parent_id = area_code
        parent_id = @@top_parent_id
      else
        parent_id = @@sub_parent_id
      end

      new(area_code, parent_id, area_name)
    end

    def strip_nbsp(str)
      str.gsub("#@@nbsp", "")
    end
    private :new
  end
end



class StatsGovDownloader
  def initialize(home_page)
    home_page_uri = open(home_page)
    home_page_doc = Nokogiri::HTML(home_page_uri)
    newest_data_page = home_page + home_page_doc.at_css("ul.center_list_contlist li a")[:href].gsub(/\.\//, "")
    puts newest_data_page
    @newest_data_doc = Nokogiri::HTML(open(newest_data_page))
  end

  def to_sql
    area_sql = File.new(File.join(File.expand_path('./'), "table_area.sql"), 'w+')
    parse_data.each_with_index do |data, idx|
      area = Area.parse_area(data.text)
      puts "#{data.text}" unless area
      area_sql.puts get_single_sql(area, idx, parse_data.count)
    end if parse_data.count > 0
    puts "there are #{parse_data.count} records processed."
  end

private
def get_single_sql(area, idx, count_size)
  result = ""
  result += "REPLACE INTO main_areas(AREA_ID, PARENT_ID, AREA_NAME) VALUES\n" if(idx == 0)
  result += "(#{area.area_id}, #{area.parent_id}, '#{area.area_name}')#{idx < count_size - 1 ? ',' : ';'}"
end

def parse_data
  @parsed_data ||= @newest_data_doc.css(".TRS_Editor p").select{ |ele| !ele.text.blank? }
end
end

# home_page = "http://www.stats.gov.cn/tjsj/tjbz/xzqhdm/"
# StatsGovDownloader.new(home_page).to_sql
