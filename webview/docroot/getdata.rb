#!/usr/local/bin/ruby
# 指定した日付の範囲のデータを読み込んでjson出力
require 'cgi'
require 'date'
# require 'logger'

def getdata(arg)
  # log設定
  # log = Logger.new('/var/log/getdata.log')
  # log.level = Logger::DEBUG

  # return/argument準備
  r = {:co2 => [], :temp => []}
  d_min, d_max = arg.collect{|v| Date.parse v }.minmax
  # log.info("#{d_min..d_max}")

  # 期間中のファイルから読み出し
  (d_min..d_max).each do |d|
    ft = d.strftime("%y%m%d")

    # co2, tempをそれぞれ読み出し
    r.keys.each do |k|
      f = "/var/co2log/#{k}-#{ft}.csv"
      # log.info(f)
      if File.exists?(f)
        # csvそのままで読み[]で囲ってjsonのArrayにする
        r[k] += IO.read(f).split(/\n/).collect{|l| "[#{l}]"}
      end
    end

  end
  # 結果を生成
  return "{\"co2\":[#{r[:co2].join(',')}],\"temp\":[#{r[:temp].join(',')}]}"

rescue => exception
  return nil
end

cgi = CGI.new
r = getdata([cgi['d1'], cgi['d2']])

if r then
  cgi.out(type: 'application/json', charset: 'UTF-8', status: 'OK'){ r }
else # bad reguest
  cgi.out(type: 'application/json', status: 'BAD_REQUEST'){ "null" }
end

