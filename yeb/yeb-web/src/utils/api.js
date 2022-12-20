import axios from 'axios'
import {Message} from 'element-ui'
import router from '../router'

//请求拦截器
axios.interceptors.request.use(config=>{
    //如果token存在,之后的请求携带这个token
    if(window.sessionStorage.getItem("tokenStr")){
        config.headers['Authorization'] = window.sessionStorage.getItem("tokenStr");
    }
    return config;
},error=>{
    console.log(error)
})


// 响应拦截器
axios.interceptors.response.use(success => {
    // 业务逻辑错误
    if(success.status && success.status==200){
        if(success.data.code==500||success.data.code==401||success.data.code==403){
            Message.error({message:success.data.message});
            return success.data;
        }
        if(success.data.message){
            Message.success({message:success.data.message});
            return success.data;
        }
    }
    return success.data;
},error => {
    console.log(error)
    //接口错误
    if(error.response.code==500||error.response.code==404){
        Message.error({message:'服务器被吃了。。'});
    }else if(error.response.code==403){
        Message.error({message:'权限不足,请联系管理员'});
    }else if(error.response.code==401){
        Message.error({message:'尚未登录，请登录'});
        router.replace("/");
    }else{
        if(error.response.data.message){
            Message.error({message:error.response.data.message});
        }else{
            Message.error({message:'未知错误'});
        }
    }
    return;
});

let base = '';

//传送json格式的post请求
export const postRequest = (url,params) => {
    return axios({
        method: 'post',
        url: `${base}${url}`,
        data: params
    })
}

//传送json格式的get请求
export const getRequest = (url,params) =>{
    return axios({
        method: 'get',
        url: `${base}${url}`,
        params: params
    })
}

//传送json格式的put请求
export const putRequest = (url,params) =>{
    return axios({
        method: 'put',
        url: `${base}${url}`,
        data: params
    })
}

//传送json格式的delete请求
export const deleteRequest = (url,params) =>{
    if (params==undefined){
        return axios({
            method: 'delete',
            url: `${base}${url}`,
        })
    }else{
        return axios({
            method: 'delete',
            url: `${base}${url}`+params,
        })
    }

}