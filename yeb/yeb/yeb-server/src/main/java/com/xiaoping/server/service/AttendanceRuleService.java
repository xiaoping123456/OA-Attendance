package com.xiaoping.server.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xiaoping.server.pojo.RespBean;
import com.xiaoping.server.pojo.attendance.AttendanceRule;

public interface AttendanceRuleService extends IService<AttendanceRule> {
    RespBean editAttendTimeRule(AttendanceRule attendanceRule);

    AttendanceRule getAttendTimeRule();

}
