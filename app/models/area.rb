class Area < ActiveRecord::Base
  has_one :country_area, foreign_key: :area_code
  has_one :country, through: :country_area
  has_many :ipcodes, foreign_key: :area_code

  self.primary_key = "area_code"

  def parent
    @parent ||= parent_code.nil? ? nil : Area.find(parent_code)
  end

  def parents
    @parents ||= []
    if @parents.blank?
      _parent = parent
      until _parent.nil?
        @parents << _parent
        puts _parent.name
        _parent = _parent.parent
      end
    end
    @parents
  end

  def children
    @children ||= Area.where(parent_code: area_code)
  end

  def siblings
    @siblings ||= Area.where(parent_code: parent_code).where.not(area_code: area_code)
  end

  def root
    @root ||= Area.find("#{area_code[0..1]}0000")
  end
end
