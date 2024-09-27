// Generated using webpack-cli https://github.com/webpack/webpack-cli

const path = require('path');
const TerserPlugin = require("terser-webpack-plugin");
const {IgnorePlugin} = require('webpack');
const BookmarkletOutputWebpackPlugin = require("bookmarklet-output-webpack-plugin");
const DotEnv = require('dotenv-webpack');

const isProduction = process.env.NODE_ENV === 'production';

const isExtension = {
  aws: true,
  switch: true,
  panel: false,
  workday: false,
};

const config = {
  entry: {
    workday: './src/workday_timesheets.js',
    switch: './src/switchQADEV/main.js',
    panel: './src/eventPanel.js',
    aws: './src/aws_account_selector.js',
  },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: (pathData) => {
      if (isExtension[pathData.chunk.name]) {
        return `../extensions/${pathData.chunk.name}/content.js`;
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
      {
        test: /\.(png|jpe?g|gif)$/i,
        use: [
          {
            loader: 'file-loader',
          },
        ],
      }
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
