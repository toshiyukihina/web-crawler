require 'webrick'

class TestContentServlet < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(req, res)
    res.body = case req.path
               when %r!.html$! then html_content(req.path)
               when %r!.txt$! then text_content(req.path)
               else "dummy"
               end

    res.content_type = WEBrick::HTTPUtils.mime_type(
      req.path_info,
      WEBrick::HTTPUtils::DefaultMimeTypes
    )
  end

  def html_content(path)
    node = path[0..-6]
    <<HTML
<html>
  <head>
    <title>#{path}</title>
  </head>
  <body>
    <p><a href="#{node}/1.html">#{node}/1.html</a></p>
    <p><a href="#{node}/2.html">#{node}/2.html</a></p>
    <p><a href="#{node}.txt">#{node}.txt</a></p>
    <p><a href="http://localhost:7777#{node}.org">#{node}.org</a></p>
    <p><a href="/1.html">/1.html</a></p>
  </body>
</html>
HTML
  end

  def text_content(path)
    "This is #{path}"
  end
  
end

server = WEBrick::HTTPServer.new(BindAddress: '127.0.0.1', Port: 7777)
server.mount('/', TestContentServlet)

trap("INT") { server.shutdown }

server.start
