const path = require('path')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')

module.exports = {
  entry: './public/index.js',

  output: {
    filename: 'app.js',
    path: path.join(__dirname, 'dist')
  },

  resolve: {
    extensions: ['.js', '.elm']
  },

  module: {
    rules: [
      {
        test: /\.html$/,
        exclude: [/node_modules/],
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
          loader: 'elm-webpack-loader',
          options: {
            optimize: true
          }
        }
      }
    ],

    noParse: /\.elm$/
  },

  optimization: {
    minimizer: [new UglifyJsPlugin({
      uglifyOptions: {
        compress: {
          pure_funcs: 'F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9',
          pure_getters: true,
          keep_fargs: false,
          unsafe_comps: true,
          unsafe: true
        },
        mangle: true
      }
    })]
  }
}
