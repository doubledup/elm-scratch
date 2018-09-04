use Rack::Static,
  :urls => ["/images", "/js", "/css"],
  :root => "public"

run lambda { |env|
  path = env['PATH_INFO']

  if path == "/app.js"
    [
      200,
      {
        'Content-Type'  => 'text/javascript',
        'Cache-Control' => 'public, max-age=86400'
      },
      File.open('dist/app.js', File::RDONLY)
    ]
  elsif path == "/"
    [
      200,
      {
        'Content-Type'  => 'text/html',
        'Cache-Control' => 'public, max-age=86400'
      },
      File.open('dist/index.html', File::RDONLY)
    ]
  else
    [
      400,
      {
      },
      ["LOLNO. That route is a lie, you should get your money back :\'("]
    ]
  end
}
