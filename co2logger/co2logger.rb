#!/usr/bin/env ruby
require_relative 'co2dev'

POLLING_SPAN = 2.0 # [s]

dev = Co2Dev.new()
dev.open()

while true
  res = dev.read()
  valfmt = {:temp => "%.2f", :co2 => "%d"}
  [:temp, :co2].each { |key|
    next unless res[key]
    t = Time.now
    file = "/var/co2log/" + t.strftime("#{key}-%y%m%d.csv")
    data = "#{t.to_i},#{valfmt[key] % res[key]}\n"
    File.open(file,'a') {|fd| fd.write(data) }
  }
  sleep(POLLING_SPAN)
end

