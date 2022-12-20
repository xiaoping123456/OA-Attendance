package com.xiaoping.server.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.xiaoping.server.pojo.Admin;
import com.xiaoping.server.pojo.RespBean;
import com.xiaoping.server.pojo.RespPageBean;
import com.xiaoping.server.pojo.attendance.AttendanceAppeal;
import com.xiaoping.server.pojo.attendance.AttendanceInfo;

import java.util.Date;
import java.util.Map;

public interface AttendanceInfoService extends IService<AttendanceInfo> {

    /**
     * 判断当前用户是否已签到
     * @return
     */
    AttendanceInfo getCurrentDayAttendance();

    /**
     * 上班签到
     * @return
     */
    RespBean signup();

    /**
     * 下班签到
     * @return
     */
    RespBean signout();

    /**
     * 获取某个用户一个月的出勤信息
     * @param date
     * @param uid
     * @return
     */
    Map caculateAttendanceInMonth(Date date, Integer uid);

    AttendanceInfo getByAppeal(AttendanceAppeal appeal);

    /**
     * 获取出勤月报表
     * @param role
     * @param department
     * @param name
     * @param page
     * @param date
     * @return
     */
    RespPageBean getMonthAttendance(String role, String department, String name, IPage<Admin> page, String date);
}
