#!/usr/bin/env ruby
require_relative 'co2dev'

POLLING_SPAN = 2.0 # [s]
WRITE_SPAN = 5 * 60 # [s]

dev = Co2Dev.new()
dev.open()

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


keys = [:temp, :co2]
logger = {
  :temp => DataLogger.new("temp", "%.2f"),
  :co2 => DataLogger.new("co2", "%d")
}
t0 = Time.now

while true
  # 読み出し
  res = dev.read()

  # 所定時間ごとに1回書き出しのflag
  bufout = (Time.now - t0) > WRITE_SPAN
  if bufout then t0 = Time.now end

  # 書き出しbufferに追加
  keys.each { |key|
    if res[key] then logger[key].add(res[key]) end
    if bufout then logger[key].wo_buffer() end
  }

  sleep(POLLING_SPAN)
end

