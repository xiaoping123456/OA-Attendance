<template>
  <div>
    <el-table :data="list" border stripe style="width: 100%" size="medium">
      <el-table-column label="序号" type="index" width="50"></el-table-column>
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
  name: "AttendanceAppealPersonal",
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
      },{
        value: '5',
        label: '下班未打卡'
      }]
    }
  },
  mounted() {
    this.initList();
  },
  methods:{
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
      getRequest('/attend/getAppealsPersonal?currentPage='+this.currentPage+'&size='+this.size)
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