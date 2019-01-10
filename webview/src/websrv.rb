#!/usr/bin/env ruby
require 'webrick'

srvconf = {
  :DocumentRoot => '/src/docroot/',
  :BindAddress => '0.0.0.0',
  :Port => 8080
}

module WEBrick::HTTPServlet
  FileHandler.add_handler('rb', CGIHandler)
end
srv = WEBrick::HTTPServer.new(srvconf)

trap("INT"){ srv.shutdown }
srv.start
