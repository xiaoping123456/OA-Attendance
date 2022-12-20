package com.xiaoping.server.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xiaoping.server.mapper.AttendanceLeaveInfoMapper;
import com.xiaoping.server.pojo.RespPageBean;
import com.xiaoping.server.pojo.attendance.AttendanceLeaveInfo;
import com.xiaoping.server.service.AttendanceLeaveInfoService;
import com.xiaoping.server.utils.AdminUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;

/**
 * @author 小王造轮子
 * @description
 * @date 2022/11/30
 */
@Service
public class AttendanceLeaveInfoServiceImpl extends ServiceImpl<AttendanceLeaveInfoMapper, AttendanceLeaveInfo> implements AttendanceLeaveInfoService {

    @Resource
    private AttendanceLeaveInfoMapper leaveInfoMapper;

    @Override
    public RespPageBean getLeaveInfoListPersonal(Integer currentPage, Integer size) {
        Page<AttendanceLeaveInfo> page = new Page<>(currentPage, size);
        IPage<AttendanceLeaveInfo> pageInfo = page(page, new QueryWrapper<AttendanceLeaveInfo>()
                .eq("userId", AdminUtils.getCurrentAdmin().getId())
                .orderByDesc("createTime"));
        return new RespPageBean(pageInfo.getTotal(), pageInfo.getRecords());
    }

    @Override
    public RespPageBean getApply(Integer currentPage, Integer size, String keyword, Integer type) {
        Page<AttendanceLeaveInfo> page = new Page<>(currentPage, size);
        IPage<AttendanceLeaveInfo> pageInfo = leaveInfoMapper.getApply(page, keyword, type);
        return new RespPageBean(pageInfo.getTotal(), pageInfo.getRecords());
    }

    @Override
    public Map<String, Integer> getLeaveInfoCurrentMonth(Date curDate, int uid) {
        // 获取起始日期
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(curDate);
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        Date beginTime = calendar.getTime();
        calendar.add(Calendar.MONTH, 1);
        Date endTime = calendar.getTime();
        List<AttendanceLeaveInfo> leaveInfoList = list(new QueryWrapper<AttendanceLeaveInfo>()
                .eq("userId", uid)
                .eq("status", 1)
                .and(qr -> qr.between("beginTime", beginTime, endTime)
                        .or()
                        .between("endTime", beginTime, endTime)
                        .or((qr2 -> {
                            qr2.le("beginTime", beginTime).ge("endTime", endTime);
                        })))
        );

        // 存储一个月内每天是否在请假中  1:请假 0:非请假
        Map<String, Integer> resMap = new HashMap<>();
        int[] daysArr = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int days = daysArr[curDate.getMonth()];
        Calendar tempCalendar = Calendar.getInstance();
        tempCalendar.setTime(curDate);
        tempCalendar.set(Calendar.DAY_OF_MONTH, 1);
        for(int i=1;i<=days;i++){
            String key = new SimpleDateFormat("yyyy-MM-dd").format(tempCalendar.getTime());
            Date curTime = tempCalendar.getTime();
            int flag = 0;
            for(AttendanceLeaveInfo leaveInfo : leaveInfoList){
                // 当前日期在请假时间中
                if(curTime.compareTo(asDate(leaveInfo.getBeginTime())) >= 0
                        && curTime.compareTo(asDate(leaveInfo.getEndTime())) <= 0){
                    resMap.put(key, 1);
                    flag = 1;
                    break;
                }
            }
            if (flag == 0) {
                resMap.put(key, 0);
            }
            // 天数+1
            tempCalendar.add(Calendar.DAY_OF_MONTH, 1);
        }
        return resMap;
    }

    /**
     * LocalDateTime => Date
     * @param localDateTime
     * @return
     */
    public static Date asDate(LocalDateTime localDateTime) {
        return Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
    }
}
