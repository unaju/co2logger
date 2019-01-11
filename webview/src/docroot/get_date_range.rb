#!/usr/local/bin/ruby
# 設定可能な日付の範囲をjsonで返す
require 'cgi'

def get_range()
  r = Dir["/var/co2log/*-*.csv"].
    collect{ |v| v =~ %r!/(co2|temp)-(\d{6}).csv$! && $2 }.
    find_all{ |v| v }.minmax
  r.empty?() ? nil : r.collect{ |v| v.scan(/../).join("-") }
end

cgi = CGI.new
cgi.out(type: 'application/json', charset: 'UTF-8') do
  r = get_range
  r ? "[\"20#{r[0]}\",\"20#{r[1]}\"]" : "null"
end

