const path = require('path')

module.exports = {
  entry: './public/index.js',

  output: {
    filename: 'app.js',
    path: path.join(__dirname, 'public')
  },

  resolve: {
    extensions: ['.js', '.elm']
  },

  module: {
    rules: [
      {
        test: /\.html$/,
        exclude: /node_modules/,
        use: {
          loader: 'file-loader',
          options: {
            name: '[name].[ext]'
          }
        }
      },

      {
        test: /\.elm$/,
        exclude: [/node_modules/, /elm-stuff/],
        use: {
          loader: 'elm-webpack-loader'
        }
      }
    ],

    noParse: /\.elm$/
  }
}
