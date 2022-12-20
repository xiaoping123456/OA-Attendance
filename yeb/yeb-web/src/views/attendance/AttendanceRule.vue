<template>
  <div>
    <el-card class="box-card card">
      <div slot="header" class="clearfix">
        <span style="font-size: large">考勤时间</span>
      </div>
      <div>
        上班时间：
        <el-time-select
            :disabled="isTimeDisabled"
            v-model="attendBegin"
            :picker-options="{
              start: '00:00',
              step: '00:15',
              end: '23:59'
            }"
            placeholder="选择时间">
        </el-time-select>
        <br>
        下班时间：
        <el-time-select
            :disabled="isTimeDisabled"
            v-model="attendEnd"
            :picker-options="{
              start: '00:00',
              step: '00:15',
              end: '23:59'
            }"
            placeholder="选择时间" style="margin-top: 10px">
        </el-time-select>
      </div>
      <!-- 修改时间-->
      <div style="float: right;margin-bottom: 10px;margin-top: 5px">
        <el-button type="danger" :disabled="isTimeEditDisabled" @click="clickEditTime">修改</el-button>
        <el-button type="primary" :disabled=" !isTimeEditDisabled " @click="editTime">保存</el-button>
      </div>
    </el-card>
  </div>
</template>

<script>
import {getRequest, putRequest} from "@/utils/api";

export default {
  name: "AttendanceRule",
  data(){
    return{
      attendBegin: '08:00',
      attendEnd: '18:00',
      isTimeDisabled: true,
      isTimeEditDisabled: false,
    }
  },
  mounted(){
      this.getTime();
  },
  methods:{
    getTime(){
        getRequest('/attend/getAttendTimeRule').then(resp => {
            console.log(resp);
            this.attendBegin = resp.attendBegin;
            this.attendEnd = resp.attendEnd;
        })
    },
    clickEditTime(){
        this.isTimeDisabled = !this.isTimeDisabled;
        this.isTimeEditDisabled = !this.isTimeEditDisabled;
    },
    editTime(){
      // 发送请求
      putRequest('/attend/editAttendTimeRule',
          {attendBegin: this.attendBegin, attendEnd: this.attendEnd}).then(resp => {
            console.log(resp);
      })
      this.isTimeDisabled = !this.isTimeDisabled;
      this.isTimeEditDisabled = !this.isTimeEditDisabled;
    }
  }
}


</script>

<style>
.card{
  width: 40%;
}

</style>