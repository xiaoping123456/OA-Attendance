<template>

  <div>
    <div>
      <el-descriptions title="本月考勤情况">
        <el-descriptions-item label="出勤天数"><el-tag type="success">{{this.normal}}</el-tag></el-descriptions-item>
        <el-descriptions-item label="缺勤天数"><el-tag type="danger">{{this.noAttend}}</el-tag></el-descriptions-item>
        <el-descriptions-item label="请假天数"><el-tag >{{this.leave}}</el-tag></el-descriptions-item>
        <el-descriptions-item label="迟到天数"><el-tag type="warning">{{this.last}}</el-tag></el-descriptions-item>
        <el-descriptions-item label="早退天数"><el-tag type="warning">{{this.early}}</el-tag></el-descriptions-item>
      </el-descriptions>

    </div>

    <el-calendar id="calendar" v-model="valueDate">
      <template
          slot="dateCell"
          slot-scope="{date, data}">
        <div class="calendar-day">{{ data.day.split('-').slice(2).join('-') }}</div>
        <el-tag type="danger" v-if="handleSelected(data.day) == '缺勤' ">缺勤 </el-tag>
        <el-tag type="success" v-else-if="handleSelected(data.day) == '√' ">√ </el-tag>
        <el-tag  v-else-if="handleSelected(data.day) == '下班未打卡' ">下班未打卡 </el-tag>
        <el-tag type="warning" v-else-if="handleSelected(data.day) == '迟到 & 早退' ">迟到 & 早退 </el-tag>
        <el-tag type="warning" v-else-if="handleSelected(data.day) == '迟到' ">迟到 </el-tag>
        <el-tag type="warning" v-else-if="handleSelected(data.day) == '早退' ">早退 </el-tag>
        <el-tag type="warning" v-else-if="handleSelected(data.day) == '请假' ">请假 </el-tag>
        <br>
        <el-button style="float: right" type="primary" size="mini"
                   v-if=" handleSelected(data.day) != 'no'  " @click="showAppealDialog(data.day)">申诉</el-button>
      </template>
    </el-calendar>

    <el-dialog
        title="申诉"
        :visible.sync="appealDialogVisible"
        width="50%">
        <el-form>
          <el-form-item label="请输入申诉的理由: ">
            <el-input type="textarea" rows="5" v-model="appeal.info"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="appealDialogVisible = false">取 消</el-button>
          <el-button type="primary" @click=" doAppeal() ">确 定</el-button>
        </span>
    </el-dialog>
  </div>
</template>
<style>
.el-tag{
  width: 100px;
  font-size: 14px;
  text-align: center;
}
.el-calendar-day .el-button--mini{
  width: 30px;
  height: 15px;
  padding: 0;
}
.el-calendar{
  width: 95%;
}
</style>

<script>
import {getRequest, postRequest} from "@/utils/api";

export default {
  name: "AttendancePersonal",
  data() {
    return {
      //日历数组
      attendanceDetailsData: new Map(),
      valueDate: '',
      currentMonthDate: '',
      normal: 0,
      last: 0,
      early: 0,
      noAttend: 0,
      noLeave: 0,
      leave: 0,
      appeal:{
        info: '',
        date: ''
      },
      appealDialogVisible: false
    }
  },
  computed:{

  },
  mounted() {
    this.currentMonthDate = this.dateFormat("YYYY-mm-dd", new Date());
    this.initAttendanceDetails();

    this.$nextTick(() => {
      // 点击上个月
      let prevBtn = document.querySelector('.el-calendar__button-group .el-button-group>button:nth-child(1)');
      prevBtn.addEventListener('click', () => {
        let date = this.dateFormat('YYYY-mm-dd',this.valueDate)
        this.currentMonthDate = date
        this.initAttendanceDetails();
      })
      // 点击今天
      let currBtn = document.querySelector('.el-calendar__button-group .el-button-group>button:nth-child(2)');
      currBtn.addEventListener('click', () => {
        let date = this.dateFormat('YYYY-mm-dd',this.valueDate)
        let date2 = date.substr(0, 7) + '-01';
        this.currentMonthDate = date2;
        this.initAttendanceDetails();
      })
      // 点击下个月
      let nextBtn = document.querySelector('.el-calendar__button-group .el-button-group>button:nth-child(3)');
      nextBtn.addEventListener('click', () => {
        let date = this.dateFormat('YYYY-mm-dd',this.valueDate)
        this.currentMonthDate = date
        this.initAttendanceDetails();
      })
    })
  },
  methods:{
    showAppealDialog(day){
      this.appealDialogVisible = true;
      this.appeal = {
        info : '',
        date : day
      }
    },
    doAppeal(){
      postRequest('/attend/appeal', this.appeal).then(resp => {
        resp
        this.appealDialogVisible = false;
        this.appeal = {
          info : '',
          date : ''
        }
      })
    },

    async initAttendanceDetails(){
      getRequest('/attend/getAttendanceInfoPersonal?date='+this.currentMonthDate).then(resp => {
        console.log(resp)
        this.normal = resp.count.normal;
        this.last = resp.count.last;
        this.early = resp.count.early;
        this.noAttend = resp.count.noAttend;
        this.noLeave = resp.count.noOut;
        this.leave = resp.count.leave;

        this.attendanceDetailsData = new Map(Object.entries(resp.attendance));
      })

    },
    handleSelected(day) {
      if(new Date(day) > new Date())
        return 'no';
      if (day.substr(0,7) != this.currentMonthDate.substr(0, 7))
        return 'no';
      return this.attendanceDetailsData.get(day);
    },

    /**
     * @param {Object} fmt 需要的时间格式 例如：'YYYY-mm-dd'
     * @param {Object} date 格林尼治时间
     */
    dateFormat(fmt, date) {
      let ret;
      const opt = {
        "Y+": date.getFullYear().toString(), // 年
        "m+": (date.getMonth() + 1).toString(), // 月
        "d+": date.getDate().toString(), // 日
        "H+": date.getHours().toString(), // 时
        "M+": date.getMinutes().toString(), // 分
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
