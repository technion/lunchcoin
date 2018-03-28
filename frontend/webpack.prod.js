const webpack = require('webpack');

module.exports = {
  context: __dirname,
  mode: "production",
  entry: "./src/lunchcoin-entry.tsx",
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
    ],
  },
}
console.log("webpack running:");
