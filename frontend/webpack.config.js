const webpack = require('webpack');

module.exports = {
  context: __dirname,
  mode: "development",
  entry: "./src/lunchcoin-entry.tsx",
  devtool: "inline-source-map",
  resolve: {
    extensions: [".tsx", ".js", ".d.ts"]
  },
  output: {
    filename: "lunchcoin.js",
    path: __dirname + "/build",
  },
  module: {
    rules: [
	    {
        test: /\.tsx$/,
        exclude: /node_modules/,
        use: ["ts-loader"],
      },
      {
        test:   /\.js$/,
        use: ["source-map-loader"],
        enforce: "pre"
      },
    ],
  },
}
console.log("webpack running:");
