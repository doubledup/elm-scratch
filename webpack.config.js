const path = require('path')

module.exports = {
  entry: {
    app: './public/index.js'
  },
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'public/js')
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/node_modules/, /elm-stuff/],
        use: {
          loader: 'elm-webpack-loader'
        }
      }
    ]
  }
}
