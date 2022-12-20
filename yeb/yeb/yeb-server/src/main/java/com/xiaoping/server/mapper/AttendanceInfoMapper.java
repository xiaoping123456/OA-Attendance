package com.xiaoping.server.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xiaoping.server.pojo.attendance.AttendanceAppeal;
import com.xiaoping.server.pojo.attendance.AttendanceInfo;

import java.util.List;

public interface AttendanceInfoMapper extends BaseMapper<AttendanceInfo> {

    /**
     * 获取今天的出勤记录
     * @param adminId
     * @return
     */
    AttendanceInfo getCurrentDayAttendance(Integer adminId);

    /**
     * 获取今天的出勤记录
     * @param adminId
     * @return
     */
    AttendanceInfo selectTodayAttendance(Integer adminId);

    AttendanceInfo selectByAppeal(AttendanceAppeal appeal);
}
