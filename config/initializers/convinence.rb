class Integer
  def inet_ntoa
     raise "OutOfBoundary, Please Check Again. It from 0 to 4294967295" if( self < 0 || self > 4294967295 )
     [self].pack('N').unpack('C4').join('.')
  end
end

class String
  def inet_aton
    to_str.split('.').map do |str| 
      raise "OutOfIPBoundary, Please Check Again." if(str.to_i < 0 || str.to_i > 255)
      str.to_i
    end.pack('C4').unpack('N')[0]
  end
end
