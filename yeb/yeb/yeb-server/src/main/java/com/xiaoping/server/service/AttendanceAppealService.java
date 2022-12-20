package com.xiaoping.server.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.xiaoping.server.pojo.RespBean;
import com.xiaoping.server.pojo.RespPageBean;
import com.xiaoping.server.pojo.attendance.AttendanceAppeal;

public interface AttendanceAppealService extends IService<AttendanceAppeal> {
    /**
     * 申诉
     * @param appeal
     * @return
     */
    RespBean appeal(AttendanceAppeal appeal);

    /**
     * 获取所有申诉信息
     * @param page
     * @param keyword
     * @param type
     * @return
     */
    RespPageBean getAppeals(Page page, String keyword, Integer type);

    /**
     * 修改出勤状态
     * @param appealId
     * @param status
     * @return
     */
    RespBean updateAttendStatus(Integer appealId, Integer status);

    /**
     * 拒绝申诉
     * @param appealId
     * @return
     */
    RespBean refuseAppeal(Integer appealId);
}
