package com.xiaoping.server.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.xiaoping.server.pojo.Admin;
import com.xiaoping.server.pojo.RespBean;
import com.xiaoping.server.pojo.RespPageBean;
import com.xiaoping.server.pojo.attendance.AttendanceAppeal;
import com.xiaoping.server.pojo.attendance.AttendanceInfo;
import com.xiaoping.server.pojo.attendance.AttendanceRule;
import com.xiaoping.server.service.AttendanceAppealService;
import com.xiaoping.server.service.AttendanceInfoService;
import com.xiaoping.server.service.AttendanceLeaveInfoService;
import com.xiaoping.server.service.AttendanceRuleService;
import com.xiaoping.server.utils.AdminUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author 小王造轮子
 * @description
 * @date 2022/11/25
 */
@RestController
@RequestMapping("/attend")
public class AttendController {

    @Autowired
    private AttendanceRuleService attendanceRuleService;
    @Autowired
    private AttendanceInfoService attendanceInfoService;
    @Autowired
    private AttendanceAppealService attendanceAppealService;
    @Autowired
    private AttendanceLeaveInfoService leaveInfoService;

    /**
     * 修改上下班时间
     * @param attendanceRule
     * @return
     */
    @PutMapping("/editAttendTimeRule")
    public RespBean editAttendTimeRule(@RequestBody AttendanceRule attendanceRule){
        return attendanceRuleService.editAttendTimeRule(attendanceRule);
    }

    /**
     * 获取上下班时间
     * @return
     */
    @GetMapping("/getAttendTimeRule")
    public AttendanceRule getAttendTimeRule(){
        return attendanceRuleService.getAttendTimeRule();
    }

    /**
     * 获取今天的出勤情况
     * @return
     */
    @GetMapping("/getCurrentDayAttendance")
    public AttendanceInfo getCurrentDayAttendance(){
        return attendanceInfoService.getCurrentDayAttendance();
    }

    /**
     * 上班打卡
     */
    @GetMapping("/signup")
    public RespBean signup(){
        return attendanceInfoService.signup();
    }

    /**
     * 下班打卡
     */
    @GetMapping("/signout")
    public RespBean signout(){
        return attendanceInfoService.signout();
    }

    /**
     * 获取某个用户某个月的出勤信息
     */
    @GetMapping("/getAttendanceInfoPersonal")
    public Map getAttendanceInfoPersonal(@RequestParam("date") String dateStr){
        Date date = null;
        try {
            date = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return attendanceInfoService.caculateAttendanceInMonth(date, AdminUtils.getCurrentAdmin().getId());
    }

    /**
     * 获取这个月该用户的请假信息
     * @param date
     * @return
     */
    @GetMapping("/leaveInfoCurrentMonth")
    public Map leaveInfoCurrentMonth(@RequestParam("date")String date){
        Date curDate = null;
        try {
            curDate = new SimpleDateFormat("yyyy-MM-dd").parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        int uid = AdminUtils.getCurrentAdmin().getId();
        return leaveInfoService.getLeaveInfoCurrentMonth(curDate, uid);
    }

    /**
     * 对某天的信息进行申诉
     * @param appeal
     * @return
     */
    @PostMapping("/appeal")
    public RespBean appeal(@RequestBody AttendanceAppeal appeal){
        return attendanceAppealService.appeal(appeal);
    }

    /**
     * 获取所有的申诉
     * @param currentPage
     * @param size
     * @return
     */
    @GetMapping("/getAppeals")
    public RespPageBean getAppeals(@RequestParam(defaultValue = "1") Integer currentPage,
                                   @RequestParam(defaultValue = "10") Integer size,
                                   @RequestParam(required = false) String keyword,
                                   @RequestParam(required = false) Integer type){
        Page<AttendanceAppeal> page = new Page<>(currentPage, size);

        return attendanceAppealService.getAppeals(page, keyword, type);
    }

    /**
     * 获取某个人的所有申诉
     * @param currentPage
     * @param size
     * @return
     */
    @GetMapping("/getAppealsPersonal")
    public RespPageBean getAppealsPersonal(@RequestParam(defaultValue = "1") Integer currentPage,
                                           @RequestParam(defaultValue = "10") Integer size){
        Page<AttendanceAppeal> page = new Page<>(currentPage, size);
        Page<AttendanceAppeal> pageInfo = attendanceAppealService.page(page, new QueryWrapper<AttendanceAppeal>()
                .eq("userId", AdminUtils.getCurrentAdmin().getId())
                .orderByDesc("createTime"));
        return new RespPageBean(pageInfo.getTotal(), pageInfo.getRecords());
    }

    /**
     * 修改出勤状态
     * @param appealId
     * @param status
     * @return
     */
    @PostMapping("/updateAttendStatus")
    public RespBean updateAttendStatus(@RequestParam("appealId") Integer appealId,
                                @RequestParam("status") Integer status){
        return attendanceAppealService.updateAttendStatus(appealId, status);
    }

    /**
     * 拒绝申诉
     * @param appealId
     * @return
     */
    @PostMapping("/refuseAppeal")
    public RespBean refuseAppeal(@RequestParam("appealId") Integer appealId){
        return attendanceAppealService.refuseAppeal(appealId);
    }

    /**
     * 获取出勤月报表
     * @param role
     * @param department
     * @param name
     * @return
     */
    @GetMapping("/monthAttendance")
    public RespPageBean allAttendance(@RequestParam(value = "role", required = false) String role,
                                      @RequestParam(value = "department", required = false) String department,
                                      @RequestParam(value = "name", required = false) String name,
                                      @RequestParam(value = "date") String date,
                                      @RequestParam(value = "currentPage", defaultValue = "1") Integer currentPage,
                                      @RequestParam(value = "size", defaultValue = "10") Integer size){
        IPage<Admin> page = new Page<>(currentPage, size);
        return attendanceInfoService.getMonthAttendance(role, department, name, page, date);
    }


}
