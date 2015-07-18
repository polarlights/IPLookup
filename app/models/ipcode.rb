class Ipcode < ActiveRecord::Base
  belongs_to :area, foreign_key: :area_code
  self.primary_key = "ip_begin"

  def ip_begin_str
    ip_begin.pack("L").unpack("C4").reverse.join(".")
  end

  def ip_end_str
    ip_end.pack("L").unpack("C4").reverse.join(".")
  end

  def ip=(ip)
    @_ip = ip
  end

  def ip
    @_ip
  end
end
