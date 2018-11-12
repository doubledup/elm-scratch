# frozen_string_literal: true

use Rack::Static,
    urls: ['/images', '/js', '/css'],
    root: 'public'

run lambda { |env|
  path = env['PATH_INFO']
  response_for(path)
}

RESPONSES = {
  '/app.js' =>
    [
      200,
      {
        'Content-Type'  => 'text/javascript',
        'Cache-Control' => 'public, max-age=86400',
        'Content-Encoding' => 'gzip'
      },
      'dist/app.js.gz'
    ],
  '/' =>
    [
      200,
      {
        'Content-Type'  => 'text/html',
        'Cache-Control' => 'public, max-age=86400'
      },
      'dist/index.html'
    ]
}.freeze

def response_for(path)
  response = RESPONSES[path]
  if response
    response[2] = File.open(response[2], File::RDONLY)
  else
    response = [400, {}, ['LOLNO. That route doesn\'t exist :\'(']]
  end
  response
end
