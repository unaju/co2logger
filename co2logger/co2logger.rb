#!/usr/bin/env ruby
require_relative 'co2dev'
require_relative 'datalogger'

# Log出力設定
require 'logger'
logger = Logger.new(STDOUT)
# logger.level = Logger::Severity::DEBUG
logger.level = Logger::Severity::ERROR

# ポーリング/書き出し間隔設定
POLLING_SPAN = 2.0 # [s]
WRITE_SPAN = 5 * 60 # [s]

# ファイル出力用クラスを温度,CO2濃度別に定義
keys = [:temp, :co2]
datalogger = {
  :temp => DataLogger.new("temp", "%.2f"),
  :co2 => DataLogger.new("co2", "%d")
}

# 書き出しループ
t0 = Time.now
dev = Co2Dev.new()
dev.open()

while true
  # 読み出し
  logger.debug('read start')
  res = dev.read()
  logger.debug('read ok')

  # 所定時間ごとに1回書き出しのflag
  bufout = (Time.now - t0) > WRITE_SPAN
  if bufout then t0 = Time.now end

  # 書き出しbufferに追加
  keys.each { |key|
    if res[key] then datalogger[key].add(res[key]) end
    if bufout then datalogger[key].wo_buffer() end
  }

  logger.debug('sleep start')
  sleep(POLLING_SPAN)
end

