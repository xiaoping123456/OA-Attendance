import Vue from 'vue'
import App from './App.vue'
import router from './router'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import 'font-awesome/css/font-awesome.css'
import store from "./store"

import {postRequest} from "./utils/api";
import {getRequest} from "./utils/api";
import {putRequest} from "./utils/api";
import {deleteRequest} from "./utils/api";
import {downloadRequest} from "./utils/download";

import {initMenu} from "./utils/menu";


Vue.use(ElementUI,{size:'small'});

Vue.config.productionTip = false

//全局路由前置守卫
router.beforeEach((to,from,next)=>{
  //判断是否已登陆
  if (window.sessionStorage.getItem("tokenStr")){
    initMenu(router,store);
    //判断用户信息是否存在
    if (!window.sessionStorage.getItem('user')){
      return postRequest('/admin/info').then(resp=>{
        if (resp){
          //存入用户信息
          window.sessionStorage.setItem('user',JSON.stringify(resp));
          next();
        }
      })
    }
    next();
  }else{
    //未登录情况

    if (to.path=='/'){
      next();
    }else{
      next('/?redirect='+to.path)
    }
  }

})


Vue.prototype.postRequest = postRequest;
Vue.prototype.getRequest = getRequest;
Vue.prototype.putRequest = putRequest;
Vue.prototype.deleteRequest = deleteRequest;
Vue.prototype.downloadRequest = downloadRequest;

new Vue({
  render: h => h(App),
  store,
  router
}).$mount('#app')
