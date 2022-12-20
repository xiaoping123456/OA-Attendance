<template>
<div>
  <el-button type="primary" @click="leaveDialogVisible=true"
    style="margin: 15px auto;" size="medium ">申请请假</el-button>
  <el-table :data="leaveInfoList" border stripe style="width: 100%" size="medium">
    <el-table-column label="序号" type="index" width="50"></el-table-column>
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
    <el-table-column label="销假时间" width="" >
      <template slot-scope="scope">
        {{getFormatDateFull(scope.row.backTime)}}
      </template>
    </el-table-column>
    <el-table-column label="操作">
      <template slot-scope="scope">
        <el-button type="danger" v-if="scope.row.status==1" @click="back(scope.row.id)">销假</el-button>
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

  <!--  申请请假的对话框-->
  <el-dialog
      :visible.sync="leaveDialogVisible"
      title="请假申请"
      width="40%"
  >
    <el-form ref="form" label-width="150px">
      <el-form-item label="请选择请假起止日期 :">
        <el-date-picker
            v-model="timeScope"
            type="daterange"
            :picker-options="pickerOptions"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="请填写请假理由 :">
        <el-input type="textarea" v-model="leaveInfo.info"></el-input>
      </el-form-item>
    </el-form>

    <template #footer>
      <span class="dialog-footer">
        <el-button @click="cancelApply">取消</el-button>
        <el-button type="primary" @click="apply">提交</el-button>
      </span>
    </template>
  </el-dialog>

</div>
</template>

<script>
import {getRequest, postRequest} from "@/utils/api";
import {formatDate, formatDateFull} from "@/utils/format";

export default {
  name: "AttendanceLeave",
  data(){
    return{
      leaveDialogVisible: false,
      leaveInfoList: [],
      currentPage: 1,
      size: 10,
      total: 0,
      leaveInfo: {
        beginTime: '',
        endTime: '',
        info: ''
      },
      timeScope:'',
      pickerOptions: {
        disabledDate:(time)=>{
          return(time.getTime() < Date.now());
        }
      }
    }

  },
  mounted() {
    this.initLeaveInfoList();
  },
  methods:{
    getFormatDate(str){
      return formatDate(str);
    },
    getFormatDateFull(str){
      if (str == null) return '';
      return formatDateFull(str);
    },
    // 销假
    back(id){
      this.$confirm('您确定要销假吗？', '确认信息', {
        distinguishCancelAndClose: true,
        confirmButtonText: '销假',
        cancelButtonText: '取消'
      })
          .then(() => {
            postRequest('/leave/back?leaveId='+id).then(resp=>{
              resp
              this.initLeaveInfoList();
            })
          });

    },
    // 获取个人的所有请假信息
    initLeaveInfoList(){
      getRequest('/leave/getLeaveInfoListPersonal?currentPage='+this.currentPage+'&size='+this.size).then(resp => {
        this.leaveInfoList = resp.data;
        this.total = resp.total;
      })
    },
    handleCurrentChange(page){
      this.currentPage = page;
      this.initLeaveInfoList();
    },
    cancelApply(){
      this.leaveDialogVisible = false;
      this.leaveInfo.info = '';
      this.timeScope = '';
    },
    apply(){
      this.leaveInfo.beginTime = this.timeScope[0];
      this.leaveInfo.endTime = this.timeScope[1];
      postRequest('/leave/apply', this.leaveInfo).then(resp => {
        resp
        this.leaveDialogVisible = false;
        this.leaveInfo.info = '';
        this.timeScope = '';
        this.initLeaveInfoList();
      })
    }
  }
}
</script>

<style>

</style>