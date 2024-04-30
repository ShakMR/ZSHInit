// Generated using webpack-cli https://github.com/webpack/webpack-cli

const path = require('path');
const TerserPlugin = require("terser-webpack-plugin");
const {IgnorePlugin} = require('webpack');
const BookmarkletOutputWebpackPlugin = require("bookmarklet-output-webpack-plugin");
const DotEnv = require('dotenv-webpack');

const isProduction = process.env.NODE_ENV === 'production';


const config = {
  entry: {
    workday: './src/workday_timesheets.js',
    switch: './src/switchQADEV.js',
    panel: './src/eventPanel.js',
  },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].js'
  },
  plugins: [
    new BookmarkletOutputWebpackPlugin({newFile: true}),
    new IgnorePlugin({resourceRegExp: /server_data.json/}),
    new DotEnv(),
  ],
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/i,
        loader: 'babel-loader',
      },
      {
        test: /\.html$/i,
        loader: "html-loader",
      },
    ],
  },
  optimization: {
    minimize: true,
  },
};

module.exports = () => {
  if (isProduction) {
    config.mode = 'production';


  } else {
    config.mode = 'development';
  }
  return config;
};
