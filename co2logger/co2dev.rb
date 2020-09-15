#!/usr/bin/env ruby
require 'hidapi'

class Co2Dev
  def initialize(key = [0x86, 0x41, 0xc9, 0xa8, 0x7f, 0x41, 0x3c, 0xac])
    @key = key
  end

  def decrypt(key, data)
    offset  = [0x48,  0x74,  0x65,  0x6D,  0x70,  0x39,  0x39,  0x65]  #"Htemp99e"
    shuffle = [2, 4, 0, 7, 1, 6, 5, 3];
    
    phase1 = shuffle.map{|i| data[i] }
    phase2 = (0..7).map{|i| phase1[i] ^ key[i] }
    phase3 = (0..7).map{|i| ( (phase2[i] >> 3) | (phase2[ (i-1+8)%8 ] << 5) ) & 0xff }
    ctmp   = (0..7).map{|i| ( (offset[i] >> 4) | offset[i] << 4 )  & 0xff }
    result = (0..7).map{|i| (0x100 + phase3[i] - ctmp[i]) & 0xff }
    return result
  end

  def read()
    buf = @dev.read()
    res = buf.unpack("C8")
    decrypted = decrypt(@key, res)

    if decrypted[4] != 0x0d or (decrypted[0..2].inject(:+) & 0xff) != decrypted[3]
      warn "Checksum error #{_hex(buf).inspect} => #{_hex(decrypted).inspect}"
      return {}
    end
    val = decrypted[1] << 8 | decrypted[2]
    case decrypted[0]
    when 0x50 # co2
      return {:co2 => val}
    when 0x42 # temperature
      return {:temp => val / 16.0 - 273.15 }
    else
      return {}
    end
  end

  def open()
    @dev = HIDAPI.open(0x4d9, 0xa052)
    ObjectSpace.define_finalizer(self) { @dev && @dev.close }
    @dev.send_feature_report([0x00] + @key)
  end

  def close()
    @dev && @dev.close
    @dev = nil
  end

end

