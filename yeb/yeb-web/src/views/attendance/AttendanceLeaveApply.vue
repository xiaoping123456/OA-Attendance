<template>
<div>
  <div style=" margin-bottom: 10px;margin-top: 5px">
    <el-input style="width: 200px" placeholder="请输入用户名" v-model="keyword" clearable></el-input>
    <el-button icon="el-icon-search" type="primary" style="margin-left: 8px" @click="search()">搜索</el-button>
  </div>

  <el-table :data="list" border stripe style="width: 100%" size="medium">
    <el-table-column label="序号" type="index" width="50"></el-table-column>
    <el-table-column label="用户" prop="username" width="100"></el-table-column>
    <el-table-column  label="请假开始日期" width="130" >
      <template slot-scope="scope">
        {{getFormatDate(scope.row.beginTime)}}
      </template>
    </el-table-column>
    <el-table-column prop="endTime" label="请假结束日期" width="130" >
      <template slot-scope="scope">
        {{getFormatDate(scope.row.endTime)}}
      </template>
    </el-table-column>
    <el-table-column prop="info" label="请假理由" width="350"/>
    <el-table-column prop="status" label="状态" width="120" >
      <template slot-scope="scope">
        <el-tag
            :type="scope.row.status=='0'?'warning':(scope.row.status=='1'?'success':(scope.row.status=='2'?'danger':'info'))">
          {{scope.row.status=='0'?'待审核':(scope.row.status=='1'?'通过':(scope.row.status=='2'?'拒绝':'已销假'))}}
        </el-tag>
      </template>
    </el-table-column>
    <el-table-column label="申请时间" width="" >
      <template slot-scope="scope">
        {{getFormatDateFull(scope.row.createTime)}}
      </template>
    </el-table-column>
    <el-table-column label="操作">
      <template slot-scope="scope">
        <el-button type="success" v-if="scope.row.status==0" @click="agree(scope.row.id)">同意</el-button>
        <el-button type="danger" v-if="scope.row.status==0" @click="refuse(scope.row.id)">拒绝</el-button>
      </template>
    </el-table-column>
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
import {getRequest, postRequest} from "@/utils/api";
import {formatDate, formatDateFull} from "@/utils/format";

export default {
  name: "AttendanceLeaveApply",
  data(){
    return{
      list: [],
      currentPage: 1,
      size: 10,
      total: 0,
      keyword: '',
      type: 0
    }
  },
  mounted() {
    this.initList();
  },
  methods:{
    search(){
      this.initList();
    },
    agree(id){
      this.$confirm('您确定同意该请假申请吗？', '确认信息', {
        distinguishCancelAndClose: true,
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      })
          .then(() => {
            postRequest('/leave/agree?id='+id).then(resp=>{
              resp
              this.initList();
            })
          });
    },
    refuse(id){
      this.$confirm('您确定拒绝该请假申请吗？', '确认信息', {
        distinguishCancelAndClose: true,
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      })
          .then(() => {
            postRequest('/leave/refuse?id='+id).then(resp=>{
              resp
              this.initList();
            })
          });
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
      getRequest('/leave/getApply?currentPage='+this.currentPage+'&size='+this.size+'&keyword='+this.keyword+'&type='+this.type)
          .then(resp => {
          this.list = resp.data;
          this.total = resp.total;
      })
    }
  }
}
</script>

<style>

</style>