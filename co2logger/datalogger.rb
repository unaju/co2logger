# データのファイル出力用クラス
class DataLogger
  def get_outfile(t = Time.now)
    "/var/co2log/#{@key}-" + t.strftime("%y%m%d") + ".csv"
  end

  def initialize(key, format)
    @key = key
    @format = format
    @ofile = get_outfile()
    @buffer = ""
  end

  def add(data)
    t = Time.now
    data = "#{t.to_i},#{@format % data}\n"
    
    # 出力ファイル名が変わる場合はbuffer書き出し
    ofile2 = get_outfile(t)
    if @ofile != ofile2
      wo_buffer
      @ofile = ofile2
    end

    # データをbufferに追記
    @buffer += data
  end

  # bufferをファイルに書き出す
  def wo_buffer()
    unless @buffer.empty?
      File.open(@ofile,'a') {|fd| fd.write(@buffer) }
      @buffer = ""
    end
  end
end
