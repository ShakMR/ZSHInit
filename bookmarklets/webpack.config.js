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
    aws: './src/aws_account_selector.js',
  },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: (pathData) => {
      if (pathData.chunk.name === 'aws') {
        return '../extensions/aws/[name].js';
      }
      return '[name].js';
    }
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
        loader: "raw-loader",
      },
      {
        test: /\.css$/i,
        use: ["style-loader","css-loader"],
      },
    ],
  },
  optimization: {
    minimize: false,
  },
  devtool: false,
};

module.exports = () => {
  if (isProduction) {
    config.mode = 'production';


  } else {
    config.mode = 'development';
  }
  return config;
};
