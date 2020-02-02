# データのファイル出力用クラス
# 書き出し先のファイル名とバッファの管理を行いデータのファイル書き出しを行う
class DataLogger
  def get_outfile(t)
    "/var/co2log/#{@key}-" + Time.at(t).strftime("%y%m%d") + ".csv"
  end

  def initialize(key, format, write_buffer_size)
    @key = key
    @format = format
    @ofile = nil
    @buffer = []
    @write_buffer_size = write_buffer_size
  end

  def add(time, data)
    # 出力ファイル名を確認し変化したらバッファ書き出し
    ofile2 = get_outfile(time)
    if (@ofile != ofile2)
      wo_buffer()
      @ofile = ofile2 # ファイル名更新
    end

    # データをbufferに追記しサイズが十分になったら書き出し
    @buffer << ("%d,#{@format}\n" % [time, data])
    if @write_buffer_size <= @buffer.size()
      wo_buffer()
    end
  end

  # bufferをファイルに書き出す
  def wo_buffer()
    unless @buffer.empty?
      File.open(@ofile,'a') {|fd| fd.write(@buffer.join('')) }
      @buffer.clear()
    end
  end
end
