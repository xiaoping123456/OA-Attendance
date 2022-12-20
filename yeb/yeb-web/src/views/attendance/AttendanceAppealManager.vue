<template>
  <div>
    <div style=" margin-bottom: 10px;margin-top: 5px">
      <el-input style="width: 200px" placeholder="请输入用户名" v-model="keyword" clearable></el-input>
      <el-button icon="el-icon-search" type="primary" style="margin-left: 8px" @click="search()">搜索</el-button>
    </div>

    <el-table :data="list" border stripe style="width: 100%" size="medium">
      <el-table-column label="序号" type="index" width="50"></el-table-column>
      <el-table-column label="用户" prop="username" width="100"></el-table-column>
      <el-table-column label="申诉的日期" prop="date" width="100"></el-table-column>
      <el-table-column prop="info" label="申诉理由" width="400"/>
      <el-table-column prop="status" label="状态" width="130" >
        <template slot-scope="scope">
          <el-tag
              :type="scope.row.status=='0'?'warning':(scope.row.status=='1'?'success':(scope.row.status=='2'?'danger':'info'))">
            {{scope.row.status=='0'?'待操作':(scope.row.status=='1'?'通过':'拒绝')}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="申诉时间" width="" >
        <template slot-scope="scope">
          {{getFormatDateFull(scope.row.createTime)}}
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="success" v-if="scope.row.status==0" @click="edit(scope.row.id)">修改</el-button>
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

    <el-dialog
        title="修改状态"
        :visible.sync="dialogVisible"
        width="30%">
      请选择更改的状态：
      <el-select v-model="statusValue" placeholder="请选择">
        <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value">
        </el-option>
      </el-select>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="updateStatus">确 定</el-button>
      </span>
    </el-dialog>


  </div>
</template>

<script>
import {getRequest, postRequest} from "@/utils/api";
import {formatDate, formatDateFull} from "@/utils/format";

export default {
  name: "AttendanceAppealManager",
  data(){
    return{
      list: [],
      currentPage: 1,
      size: 10,
      total: 0,
      keyword: '',
      type: 0,
      appealId: 0,
      dialogVisible: false,
      statusValue: 0,
      options: [{
        value: '0',
        label: '正常'
      }, {
        value: '1',
        label: '迟到'
      }, {
        value: '2',
        label: '早退'
      }, {
        value: '3',
        label: '缺勤'
      }, {
        value: '4',
        label: '请假'
      }]
    }
  },
  mounted() {
    this.initList();
  },
  methods:{
    search(){
      this.initList();
    },
    edit(id){
      this.dialogVisible = true;
      this.appealId = id;
    },
    updateStatus(){
      this.$confirm('您确定修改该出勤状态吗？', '确认信息', {
        distinguishCancelAndClose: true,
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      })
          .then(() => {
            postRequest('/attend/updateAttendStatus?appealId='+this.appealId+'&status='+this.statusValue).then(resp=>{
              resp
              this.initList();
              this.dialogVisible = false;
            })
          });
    },
    refuse(){
      this.$confirm('您确定拒绝该申诉吗？', '确认信息', {
        distinguishCancelAndClose: true,
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      })
          .then(() => {
            postRequest('/attend/refuseAppeal?appealId='+this.appealId).then(resp=>{
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
      getRequest('/attend/getAppeals?currentPage='+this.currentPage+'&size='+this.size+'&keyword='+this.keyword+'&type='+this.type)
          .then(resp => {
            console.log(resp)
            this.list = resp.data;
            this.total = resp.total;
          })
    }
  }
}
</script>

<style scoped>

</style>