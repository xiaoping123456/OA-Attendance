<template>
  <div>
    <el-container>
      <el-header class="homeHeader">
        <div class="title">云协同办公</div>
        <el-dropdown class="userInfo" @command="commandHandler">
          <span class="el-dropdown-link">
            {{ user.name }}<i><img :src="user.userFace" /></i>
          </span>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item command="userinfo">个人中心</el-dropdown-item>
            <el-dropdown-item command="setting">设置</el-dropdown-item>
            <el-dropdown-item command="logout">注销登录</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </el-header>
      <el-container>
        <el-aside width="250px">
          <el-menu router unique-opened
                   active-text-color="white"
                   background-color="#222d32">
            <el-submenu :index="index+''" v-for="(item,index) in routes"
                        :key="index"
                        v-if="!item.hidden">
              <template slot="title">
                <i :class="item.iconCls" style="color:#71aeef;margin-right: 5px"></i>
                <span>{{item.name}}</span>
              </template>
              <el-menu-item :index="children.path"
                            v-for="(children,indexj) in item.children">
                            {{ children.name }}
              </el-menu-item>
            </el-submenu>
          </el-menu>
        </el-aside>
        <el-main>
          <el-breadcrumb separator-class="el-icon-arrow-right" v-if="this.$router.currentRoute.path!='/home' ">
            <el-breadcrumb-item :to="{ path: '/home' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>{{this.$router.currentRoute.name}}</el-breadcrumb-item>
          </el-breadcrumb>
          <div class="homeWelcome" v-if="this.$router.currentRoute.path=='/home' ">
            欢迎来到云协同办公系统
            <el-card class="box-card attendCard">
              <span class="welcomeText">
                {{ new Date().getHours()<12 ? '上午好' : '下午好' }}
              </span>

                <el-button ref="toAttend" type="primary" class="attendButton" @click="sign"
                  :disabled="isAttendDisabled">
                  {{ attendMark }}
                </el-button>
            </el-card>
          </div>
          <router-view class="homeRouterView"></router-view>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script>
import {getRequest} from "@/utils/api";

export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: "Home.vue",
  data(){
    return {
      user: JSON.parse(window.sessionStorage.getItem('user')),
      // 上班、下班打卡
      attendMark: '上班打卡',
      isAttendDisabled: false,
      attendMethod: ''
    }
  },
  mounted() {
    this.getCurrentDayAttendance();
  },
  methods: {
    // 判断用户是否签到
    getCurrentDayAttendance(){
        getRequest('/attend/getCurrentDayAttendance').then(resp => {

            // 还未上班打卡
            if (resp == undefined || resp == null){
                this.attendMark = '上班打卡';
                this.isAttendDisabled = false;
                this.attendMethod = 'signup()';
            }
            // 上班打卡了 还未下班打卡
            if(resp.clockInTime != null && resp.clockOutTime == null){
                this.attendMark = '下班打卡';
                this.isAttendDisabled = false;
                this.attendMethod = 'signout()';
            }
            // 已经下班打卡了
            if(resp.clockInTime != null && resp.clockOutTime != null){
                this.attendMark = '已下班打卡';
                this.isAttendDisabled = true;
            }
        })
    },
    sign(){
      // 上班打卡
      if(this.attendMark == '上班打卡'){
        getRequest('/attend/signup').then(resp => {
          // console.log(resp);
          this.getCurrentDayAttendance();
        })
      }
      // 下班打卡
      if(this.attendMark == '下班打卡'){
        getRequest('/attend/signout').then(resp => {
          // console.log(resp);
          this.getCurrentDayAttendance();
        })
      }
    },

    commandHandler(command){
      if (command == 'logout'){
        this.$confirm('此操作将注销登录, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          //退出登录
          this.postRequest('/logout');
          //删除sessionStorage中的token和user
          window.sessionStorage.removeItem("tokenStr");
          window.sessionStorage.removeItem("user");
          //清空菜单
          this.$store.commit('initRoutes',[]);
          //跳转到登录页
          this.$router.replace('/');
        }).catch(() => {
          this.$message({
            type: 'info',
            message: '已取消操作'
          });
        });
      }
    }
  },
  computed:{
    routes(){
      return this.$store.state.routes;
    }
  }
}
</script>

<style>
  .el-aside{
    background-color: #222d32;
    min-height: 100vh;
  }
  .el-menu{
    background-color: #222d32;
  }
  .el-menu span{
    color: #b8c7ce;
  }
  .el-menu .el-menu--inline{
    background-color: #2c3b41;
  }
  .el-menu .el-menu--inline li{
    color: #b8c7ce;
  }

  .homeHeader{
    background: #19a8cc;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 15px;
    box-sizing: border-box;
  }
  .homeHeader .title{
    font-size: 30px;
    font-family: 华文楷体;
    color: whitesmoke;
  }
  .homeHeader .userInfo{
      cursor: pointer;
  }
  .el-dropdown-link img{
    width: 48px;
    height: 48px;
    border-radius: 24px;
    margin-left: 8px;
  }
  .homeWelcome{
    text-align: center;
    font-size: 30px;
    font-family: 华文楷体;
    color: #71aeef;
    padding-top: 20px;
  }
  .homeRouterView{
    margin-top: 10px;
  }
  .attendCard{
      width: 300px;
      height: 200px;
  }
  .attendCard .attendButton{
      width: 180px;
      height: 140px;
      float: right;
      margin-top: 10px;
      font-size: 17px;
  }
  .el-button .attendButton .el-button--primary .el-button--small{
    background-color: #19a8cc;
  }
  .welcomeText{
    font-size: 16px;
  }

</style>