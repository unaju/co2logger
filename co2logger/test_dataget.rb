#!/usr/bin/env ruby
=begin
co2/tempのデータを読み出せるタイミングの調査用
usage: $ docker-compose run --rm --entrypoint ruby co2logger "/root/test_dataget.rb" | tee data.csv
  ctrl+cで終了
=end

require_relative 'co2dev'

t0 = Time.now
dev = Co2Dev.new
dev.open

while res = dev.read
  t = "%.3f" % (Time.now() - t0)
  [:temp, :co2].each do |key|
    if res[key] then
      puts("#{t},#{key},#{"%.1f" % res[key]}")
    end
  end
  sleep 5
end


