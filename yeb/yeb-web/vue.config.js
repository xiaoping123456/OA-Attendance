const { defineConfig } = require('@vue/cli-service')


//解决跨域问题  使用node.js代理转发
//node.js 代理对象
let proxyObj={}
// '/'下的所有请求
proxyObj['/']={
  //websocket
  ws:false,
  //目标地址
  target:'http://localhost:8081',
  //发送请求头host会被设置成target
  changeOrigin: true,
  //不重写请求地址
  pathReWrite:{
    '^/':'/'
  }

}


module.exports = defineConfig({
  transpileDependencies: true,
  lintOnSave: false,
  devServer:{
    host:'localhost',
    port:8080,
    proxy: proxyObj
  }
})
