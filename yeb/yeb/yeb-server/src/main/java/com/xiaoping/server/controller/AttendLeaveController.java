package com.xiaoping.server.controller;

import com.xiaoping.server.pojo.RespBean;
import com.xiaoping.server.pojo.RespPageBean;
import com.xiaoping.server.pojo.attendance.AttendanceLeaveInfo;
import com.xiaoping.server.service.AttendanceLeaveInfoService;
import com.xiaoping.server.utils.AdminUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

/**
 * @author 小王造轮子
 * @description
 * @date 2022/11/30
 */
@RequestMapping("/leave")
@RestController
public class AttendLeaveController {

    @Autowired
    private AttendanceLeaveInfoService leaveInfoService;

    /**
     * 请假申请
     *
     * @param leaveInfo
     * @return
     */
    @PostMapping("/apply")
    public RespBean apply(@RequestBody AttendanceLeaveInfo leaveInfo) {
        leaveInfo.setStatus(0);
        leaveInfo.setCreateTime(LocalDateTime.of(LocalDate.now(), LocalTime.MIN));
        leaveInfo.setUserId(AdminUtils.getCurrentAdmin().getId());
        leaveInfoService.save(leaveInfo);
        return RespBean.success("请假申请成功，请等待hr审核");
    }

    /**
     * 获取个人的所有请假信息
     *
     * @param currentPage
     * @param size
     * @return
     */
    @GetMapping("/getLeaveInfoListPersonal")
    public RespPageBean getLeaveInfoListPersonal(@RequestParam(defaultValue = "1") Integer currentPage,
                                                 @RequestParam(defaultValue = "10") Integer size) {
        return leaveInfoService.getLeaveInfoListPersonal(currentPage, size);
    }

    /**
     * 销假
     * @param leaveId
     * @return
     */
    @PostMapping("/back")
    public RespBean back(@RequestParam("leaveId") Integer leaveId) {
        AttendanceLeaveInfo attendanceLeaveInfo = new AttendanceLeaveInfo();
        attendanceLeaveInfo.setId(leaveId);
        attendanceLeaveInfo.setStatus(3);
        attendanceLeaveInfo.setBackTime(LocalDateTime.now());
        leaveInfoService.updateById(attendanceLeaveInfo);
        return RespBean.success("销假成功");
    }

    /**
     * 获取所有请假申请信息
     * @param currentPage
     * @param size
     * @param keyword
     * @param type
     * @return
     */
    @GetMapping("/getApply")
    public RespPageBean getApply(@RequestParam(defaultValue = "1") Integer currentPage,
                                 @RequestParam(defaultValue = "10") Integer size,
                                 @RequestParam(required = false) String keyword,
                                 @RequestParam(required = false) Integer type){
        return leaveInfoService.getApply(currentPage, size, keyword, type);
    }

    /**
     * 同意请假申请
     * @param id
     * @return
     */
    @PostMapping("/agree")
    public RespBean agree(@RequestParam("id") Integer id){
        AttendanceLeaveInfo attendanceLeaveInfo = new AttendanceLeaveInfo();
        attendanceLeaveInfo.setId(id);
        attendanceLeaveInfo.setStatus(1);
        leaveInfoService.updateById(attendanceLeaveInfo);
        return RespBean.success("操作成功");
    }

    /**
     * 拒绝请假申请
     * @param id
     * @return
     */
    @PostMapping("/refuse")
    public RespBean refuse(@RequestParam("id") Integer id){
        AttendanceLeaveInfo attendanceLeaveInfo = new AttendanceLeaveInfo();
        attendanceLeaveInfo.setId(id);
        attendanceLeaveInfo.setStatus(2);
        leaveInfoService.updateById(attendanceLeaveInfo);
        return RespBean.success("操作成功");
    }

}
