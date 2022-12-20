package com.xiaoping.server.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xiaoping.server.pojo.RespPageBean;
import com.xiaoping.server.pojo.attendance.AttendanceLeaveInfo;

import java.util.Date;
import java.util.Map;

public interface AttendanceLeaveInfoService extends IService<AttendanceLeaveInfo> {
    /**
     * 获取个人的所有请假信息
     * @param currentPage
     * @param size
     * @return
     */
    RespPageBean getLeaveInfoListPersonal(Integer currentPage, Integer size);

    /**
     * 获取所有请假申请信息
     * @param currentPage
     * @param size
     * @param keyword
     * @param type
     * @return
     */
    RespPageBean getApply(Integer currentPage, Integer size, String keyword, Integer type);

    /**
     * 获取这个月该用户的请假信息
     * @param curDate
     * @param uid
     * @return
     */
    Map<String, Integer> getLeaveInfoCurrentMonth(Date curDate, int uid);
}
