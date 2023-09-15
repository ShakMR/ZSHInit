// Generated using webpack-cli https://github.com/webpack/webpack-cli

const path = require('path');
const TerserPlugin = require("terser-webpack-plugin");

const isProduction = process.env.NODE_ENV == 'production';


const config = {
    entry: {
        workday: './src/workday_timesheets.js',
    },
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].js'
    },
    plugins: [
        // Add your plugins here
        // Learn more about plugins from https://webpack.js.org/configuration/plugins/
    ],
    module: {
        rules: [
            {
                test: /\.(js|jsx)$/i,
                loader: 'babel-loader',
            },
        ],
    },
    optimization: {
        minimizer: [new TerserPlugin({
            terserOptions: {
                format: {
                    comments: false,
                }
            },
            extractComments: false,
        })],
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
