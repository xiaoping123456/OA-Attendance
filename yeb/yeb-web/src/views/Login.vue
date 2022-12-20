<template>
  <div class="login">
    <el-form :rules="rules"
             v-loading="loading"
             element-loading-text="正在登录..."
             element-loading-spinner="el-icon-loading"
             element-loading-background="rgba(0, 0, 0, 0.8)"
             ref="loginForm"
             :model="loginForm"
             class="loginContainer">
      <h3 class="loginTitle">系统登录</h3>
      <el-form-item prop="username">
        <el-input type="text" v-model="loginForm.username" placeholder="请输入用户名"></el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input type="password" v-model="loginForm.password" auto-complete="false" placeholder="请输入密码"></el-input>
      </el-form-item>
      <el-form-item prop="code">
        <el-input type="text" v-model="loginForm.code" auto-complete="false" placeholder="点击图片更换验证码"
                  style="width: 250px;margin-right: 5px"></el-input>
        <img :src="captchaUrl" @click="updateCaptcha">
      </el-form-item>
      <el-checkbox v-model="checked" class="loginRemember">记住我</el-checkbox>
      <el-button type="primary" style="width: 100%" @click="submitLogin">登录</el-button>
    </el-form>
  </div>
</template>

<script>


export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: "Login",
  data() {
    return {
      captchaUrl: '/captcha?time' + new Date(),
      loginForm: {
        username: '',
        password: '',
        code: ''
      },
      checked: true,
      rules: {
        username: [{required: true, message: "请输入用户名", trigger: 'blur'}],
        password: [{required: true, message: '请输入密码', trigger: 'blur'}],
        code: [{required: true, message: '请输入验证码', trigger: 'blur'}]
      },
      loading: false
    }
  },
  methods: {
    submitLogin() {
      this.$refs.loginForm.validate((valid) => {
        if (valid) {
          this.loading = true;
          this.postRequest('/login', this.loginForm).then(resp => {
            // alert(JSON.stringify(resp))
            console.log(resp)
            this.loading = false
            if (resp.code==200) {
              //存储用户token
              const tokenStr = resp.obj.tokenHead + resp.obj.token;
              window.sessionStorage.setItem("tokenStr", tokenStr);
              //清空菜单
              this.$store.commit('initRoutes',[]);
              //页面跳转
              let path = this.$route.query.redirect;
              this.$router.replace((path=='/'||path==undefined)?'/home':path);
            }
          })
        } else {
          this.$message.error('请输入所有字段');
          return false;
        }
      });
    },
    //更换验证码图片
    updateCaptcha() {
      this.captchaUrl = '/captcha?time=' + new Date();
    }
  }
}
</script>

<style>

*{
  margin: 0;
  padding: 0;
}
html,body{
  width: 100%;
  height: 100%;
}

.login{
  background-image: url("../assets/loginBackground.jpg");
  background-size: 100%;
  height: 100vh;
  display:flex;justify-content: center; align-items:center;
}

.loginContainer {
  opacity: 0.9;

  /*设置圆角的半径*/
  border-radius: 15px;
  /*指定绘图区的背景 padding-box:背景绘制在衬距方框内（剪切成衬距方框）。*/
  background-clip: padding-box;

  width: 350px;
  /*内边距*/
  padding: 15px 35px 15px 35px;
  background: #fff;
  /*设置 4 个边框的样式：*/
  border: 1px solid #eaeaea;
  /*向 div 元素添加阴影*/
  box-shadow: 0 0 25px #cac6c6;
}

.loginTitle {
  margin: 0px auto 40px auto;
  text-align: center;
}

.loginRemember {
  text-align: left;
  margin: 0px 0px 15px 0px;
}

.el-form-item__content {
  /*弹性布局*/
  display: flex;
  /*居中对齐弹性盒的各项 <div> 元素*/
  align-items: center;
}

</style>