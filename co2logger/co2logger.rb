#!/usr/bin/env ruby
require 'json'
require 'logger'
require_relative 'co2dev'
require_relative 'datalogger'

# 実装時点のdebianのruby(2.3.3)では配列の平均の算出が面倒なため別に定義
def mean(arr)
  r = 0.0
  arr.each do |v|
    r += v
  end
  return r / arr.size()
end

# CO2記録用関数
class Co2Logger
  def initialize
    # 設定読み出し
    conf = JSON.load(IO.read('/root/conf.json'))
    @polling_span = conf['polling_span']
    @sample = conf['sample']
    wb_size = conf['write_buffer_size']

    # Log出力設定
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::Severity::DEBUG
    # @logger.level = Logger::Severity::ERROR

    # 読み出し用デバイス初期化
    @dev = Co2Dev.new()
    @dev.open()

    # 書き出しclass初期化
    @datalogger = {
      :temp => DataLogger.new("temp", "%.2f", wb_size),
      :co2 => DataLogger.new("co2", "%d", wb_size)
    }
  end

  # データを読み込む
  # @sample個読み込み,その平均を返す
  # => {:co2 => [時間(Float), 値(Float)], :temp => [時間(Float), 値(Float)]}
  def read_data
    # サンプルを十分取得できるまで読み出し
    data = { :co2 => [], :temp => [] }
    time = { :co2 => [], :temp => [] }
    # @dev.open()
    while (data[:co2].size() < @sample) || (data[:temp].size() < @sample)
      # 読み出し
      @logger.debug('dev.read()')
      v = @dev.read()
      @logger.debug("=> #{v}")
      # サンプル配列に追加
      data.each do |k, arr|
        if v[k] && arr.size() < @sample
          data[k] << v[k]
          time[k] << Time.now().to_f()
        end
      end
    end
    # @dev.close()
    
    # 平均を算出して返す
    r = {}
    data.keys.each { |k| r[k] = [ mean(time[k]), mean(data[k]) ] }
    return r
  end

  # データを読み出し保存する
  def polling
    while true
      # HIDから読み出し
      start_time = Time.now() # 開始時間を記録
      data = read_data()
      @logger.debug("read_data() => #{data}")

      # ファイル書き出し
      data.each do |k, v|
        @datalogger[k].add(*v)
      end
      
      # 終了時間を計算し必要なだけsleep
      sleep_time = (start_time + @polling_span) - Time.now()
      if 0 < sleep_time
        @logger.debug("sleep(%d s) start" % sleep_time)
        sleep(sleep_time)
      end
    end
  end
end

# main
Co2Logger.new.polling

