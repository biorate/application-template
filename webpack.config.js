const webpack = require('webpack');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const lerna = require('./lerna.json');
const argv = require('minimist')(process.argv.slice(2));
const production = argv.mode === 'production';
const apiUrl = 'http://localhost:3000';

module.exports = {
  output: {
    filename: 'index.js',
  },
  resolve: {
    extensions: ['.js', '.ts', '.tsx', '.css', '.scss', '.less'],
    fallback: {
      path: require.resolve('path-browserify'),
      util: require.resolve('util-browserify'),
      process: require.resolve('process/browser'),
    },
    alias: {
      process: 'process',
      '~': `${process.cwd()}/src`,
    },
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        exclude: /node_modules/,
        use: {
          loader: 'ts-loader',
        },
      },
      {
        test: /\.pug$/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'file-loader',
            options: { name: 'index.html' },
          },
          {
            loader: 'pug-html-loader',
            options: { data: {} },
          },
        ],
      },
      {
        test: /\.css$/,
        exclude: /node_modules/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            options: {
              modules: {
                localIdentName: '[local]--[hash:base64:5]',
                auto: true,
              },
            },
          },
        ],
      },
      {
        test: /\.scss$/,
        exclude: /node_modules/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            options: {
              modules: {
                localIdentName: '[local]--[hash:base64:5]',
                auto: true,
              },
            },
          },
          {
            loader: 'sass-loader',
          },
        ],
      },
      {
        test: /\.less$/,
        // exclude: /node_modules/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            options: {
              modules: {
                localIdentName: '[local]--[hash:base64:5]',
                auto: true,
              },
            },
          },
          {
            loader: 'less-loader',
            options: {
              lessOptions: {
                javascriptEnabled: true,
              },
            },
          },
        ],
      },
      {
        test: /\.(woff2?|ttf|eot|gif|png|jpe?g|bmp|svg)$/,
        use: [
          {
            loader: 'file-loader',
          },
        ],
      },
    ],
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_DEBUG': JSON.stringify(process.env.NODE_DEBUG),
      'process.env.API_URL': JSON.stringify(production ? null : apiUrl),
      'process.env.VERSION': JSON.stringify(lerna.version),
    }),
    new MiniCssExtractPlugin({ filename: 'style.css' }),
  ],
  optimization: {
    minimize: production,
    minimizer: [
      new TerserPlugin({
        parallel: true,
        terserOptions: {
          parse: {},
          compress: {},
          module: false,
          ecma: 6,
          mangle: false,
          keep_classnames: true,
          keep_fnames: false,
        },
      }),
      new CssMinimizerPlugin({
        parallel: true,
      }),
    ],
  },
  devServer: {
    // contentBase: 'dist',
    static: 'dist',
    compress: true,
    port: 10000,
    hot: true,
  },
};
