require 'webrick'

Thread.start do
  WEBrick::HTTPServer.new(
    DocumentRoot: '.',
    Port: 7777,
    BindAddress: '127.0.0.1'
  ).start
end
gets
