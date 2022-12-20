<template>
<div>
  <div style=" margin-bottom: 10px;margin-top: 5px">
    <el-input style="width: 200px" placeholder="请输入用户名" v-model="name" clearable></el-input>
    <el-button icon="el-icon-search" type="primary" style="margin-left: 8px" @click="search()">搜索</el-button>
  </div>
  <div style="margin-bottom: 10px">
    当前月份：{{searchDate}}  &nbsp&nbsp&nbsp&nbsp
    <el-button type="success" @click="toPrevious">上个月</el-button>
    <el-button type="warning" @click="toCurrent">当前</el-button>
    <el-button type="primary" @click="toNext" :disabled="notNext">下个月</el-button>
  </div>
  <el-table :data="list" border stripe style="width: 100%" size="medium">
    <el-table-column label="序号" type="index" width="50"></el-table-column>
    <el-table-column label="用户名" prop="admin.name" width="150"></el-table-column>
    <el-table-column label="正常 /天" prop="count.normal" width="100"></el-table-column>
    <el-table-column label="迟到 /天" prop="count.last" width="100"></el-table-column>
    <el-table-column label="早退 /天" prop="count.early" width="100"></el-table-column>
    <el-table-column label="下班未打卡 /天" prop="count.noOut" width="120"></el-table-column>
    <el-table-column label="缺勤 /天" prop="count.noAttend" width="100"></el-table-column>
    <el-table-column label="请假 /天" prop="count.leave" width="100"></el-table-column>
  </el-table>
  <el-pagination
      style="display: flex;justify-content: center;margin-top: 15px"
      background
      layout="prev, pager, next, total"
      @current-change="handleCurrentChange"
      :total="total">
  </el-pagination>
</div>
</template>

<script>
import {formatDate, formatDateFull} from "@/utils/format";
import {getRequest} from "@/utils/api";

export default {
  name: "AttendanceAll",
  data(){
    return{
      list: [],
      currentPage: 1,
      size: 10,
      total: 0,
      name: '',
      type: 0,
      searchDate: this.dateFormat('yyyy-MM', new Date()),
      notNext: true
    }
  },
  mounted() {
    this.initList();
  },
  methods:{
    toPrevious(){
      let str = this.searchDate;
      let year = str.split('-')[0];
      let month = str.split('-')[1];
      if(month == 1){
        year = year-1;
        month = 12;
      }else{
        month = month - 1;
      }
      this.searchDate = year + (month<10?'-0':'-') + month;
      this.initList();

      if(this.searchDate >= this.dateFormat('yyyy-MM', new Date())){
        this.notNext = true;
      }else{
        this.notNext = false;
      }
    },
    toCurrent(){
      this.searchDate = this.dateFormat('yyyy-MM', new Date())
      this.initList();
      if(this.searchDate >= this.dateFormat('yyyy-MM', new Date())){
        this.notNext = true;
      }else{
        this.notNext = false;
      }
    },
    toNext(){
      let str = this.searchDate;
      let year = str.split('-')[0];
      let month = str.split('-')[1];
      if(month == 12){
        year = parseInt(year) + 1;
        month = 1;
      }else{
        month = parseInt(month) + 1;
      }
      this.searchDate = year + (month<10?'-0':'-') + month;
      this.initList();
      if(this.searchDate >= this.dateFormat('yyyy-MM', new Date())){
        this.notNext = true;
      }else{
        this.notNext = false;
      }
    },
    search(){
      this.initList();
    },
    getFormatDate(str){
      return formatDate(str);
    },
    getFormatDateFull(str){
      if (str == null) return '';
      return formatDateFull(str);
    },
    handleCurrentChange(page){
      this.currentPage = page;
      this.initLeaveInfoList();
    },
    initList(){
      getRequest('/attend/monthAttendance?currentPage='+this.currentPage+'&size='+this.size+'&name='+this.name +
          '&date=' + this.searchDate)
          .then(resp => {
            console.log(resp)
            this.list = resp.data;
            this.total = resp.total;
          })
    },
    dateFormat(fmt, date) {
      let ret;
      const opt = {
        "y+": date.getFullYear().toString(), // 年
        "M+": (date.getMonth() + 1).toString(), // 月
        "d+": date.getDate().toString(), // 日
        "H+": date.getHours().toString(), // 时
        "m+": date.getMinutes().toString(), // 分
        "S+": date.getSeconds().toString() // 秒
      };
      for (let k in opt) {
        ret = new RegExp("(" + k + ")").exec(fmt);
        if (ret) {
          fmt = fmt.replace(ret[1], (ret[1].length == 1) ? (opt[k]) : (opt[k].padStart(ret[1].length, "0")))
        };
      };
      return fmt;
    },
  }
}
</script>

<style>

</style>