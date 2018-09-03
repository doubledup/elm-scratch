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
      File.open('public/app.js', File::RDONLY)
    ]
  else
    [
      200,
      {
        'Content-Type'  => 'text/html',
        'Cache-Control' => 'public, max-age=86400'
      },
      File.open('public/index.html', File::RDONLY)
    ]
  end
}
