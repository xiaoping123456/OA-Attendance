package com.xiaoping.server.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xiaoping.server.mapper.AttendanceInfoMapper;
import com.xiaoping.server.pojo.Admin;
import com.xiaoping.server.pojo.RespBean;
import com.xiaoping.server.pojo.RespPageBean;
import com.xiaoping.server.pojo.attendance.AttendanceAppeal;
import com.xiaoping.server.pojo.attendance.AttendanceInfo;
import com.xiaoping.server.pojo.attendance.AttendanceRule;
import com.xiaoping.server.pojo.vo.AdminVo;
import com.xiaoping.server.service.AttendanceInfoService;
import com.xiaoping.server.service.AttendanceLeaveInfoService;
import com.xiaoping.server.service.AttendanceRuleService;
import com.xiaoping.server.service.IAdminService;
import com.xiaoping.server.utils.AdminUtils;
import com.xiaoping.server.utils.AttendanceUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * @author 小王造轮子
 * @description
 * @date 2022/11/27
 */
@Service
public class AttendanceInfoServiceImpl extends ServiceImpl<AttendanceInfoMapper, AttendanceInfo> implements AttendanceInfoService {

    @Autowired
    private AttendanceRuleService attendanceRuleService;
    @Resource
    private AttendanceInfoMapper attendanceInfoMapper;
    @Autowired
    private AttendanceLeaveInfoService leaveInfoService;
    @Autowired
    private IAdminService adminService;

    @Override
    public AttendanceInfo getCurrentDayAttendance() {
        Admin currentAdmin = AdminUtils.getCurrentAdmin();
        AttendanceInfo currentDayAttendance = attendanceInfoMapper.getCurrentDayAttendance(currentAdmin.getId());
        return currentDayAttendance;
    }

    @Override
    public RespBean signup() {
        // 获取当前用户信息
        Admin currentAdmin = AdminUtils.getCurrentAdmin();
        // 获取签到的时间规则
        AttendanceRule attendTimeRule = attendanceRuleService.getAttendTimeRule();
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        String currentTime = sdf.format(new Date());
        AttendanceInfo attendanceInfo = new AttendanceInfo();
        attendanceInfo.setUserId(currentAdmin.getId());
        attendanceInfo.setClockInTime(LocalDateTime.now());
        if (currentTime.compareTo(attendTimeRule.getAttendBegin()) <= 0){
            // 上班时间正常
            attendanceInfo.setAttendRemark(0);
            save(attendanceInfo);
            return RespBean.success("打卡成功，开始美好的一天");
        } else if(currentTime.compareTo(attendTimeRule.getAttendEnd()) >= 0) {
            // 上班时间晚于下班时间 无法上班签到 即缺勤
            return RespBean.error("抱歉，已下班，无法上班打卡");
        } else {
            // 上班迟到
            attendanceInfo.setAttendRemark(1);
            save(attendanceInfo);
            return RespBean.success("打卡成功，您已迟到，好好上班噢");
        }
    }

    @Override
    public RespBean signout() {
        // 获取当前用户信息
        Admin currentAdmin = AdminUtils.getCurrentAdmin();
        // 获取签到的时间规则
        AttendanceRule attendTimeRule = attendanceRuleService.getAttendTimeRule();
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        String currentTime = sdf.format(new Date());

        AttendanceInfo attendanceInfo = attendanceInfoMapper.selectTodayAttendance(currentAdmin.getId());
        if(attendanceInfo == null){
            return RespBean.error("您今天还未打卡");
        }
        attendanceInfo.setClockOutTime(LocalDateTime.now());
        if (currentTime.compareTo(attendTimeRule.getAttendEnd()) > 0){
            // 下班正常
            attendanceInfo.setAttendRemark(0);
            updateById(attendanceInfo);
            return RespBean.success("打卡成功，辛苦啦");
        } else {
            // 下班早退
            attendanceInfo.setAttendRemark(2);
            updateById(attendanceInfo);
            return RespBean.success("打卡成功，早退了哟小伙子");
        }

    }



    @Override
    public Map caculateAttendanceInMonth(Date date, Integer uid) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        // 起始日期 这个月第一天
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        Date beginTime = calendar.getTime();
        // 结束日期 下个月第一天
        calendar.add(Calendar.MONTH, 1);
        Date endTime = calendar.getTime();

        List<AttendanceInfo> attendanceInfoList = list(new QueryWrapper<AttendanceInfo>()
                .eq("userId", uid)
                .between("clockInTime", beginTime, endTime));
        // 该用户这个月的请假信息  1:请假 0:非请假
        Map<String, Integer> leaveInfoCurrentMonth = leaveInfoService.getLeaveInfoCurrentMonth(date, uid);
        Map<String, String> attendanceMap = new HashMap<>();
        Map<String, Integer> countMap = new HashMap<>();
        int noAttend = 0, noOut = 0, last = 0, early = 0, leave = 0, normal = 0;
        // 先把出勤信息放进Map
        AttendanceRule rule = attendanceRuleService.getAttendTimeRule();
        for(AttendanceInfo info : attendanceInfoList){
            String key = info.getClockInTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

            if (info.getAttendRemark() == 0){
                attendanceMap.put(key, "√");
                normal++;
                continue;
            }else if(info.getAttendRemark() == 1){
                attendanceMap.put(key, "迟到");
                last++;
                continue;
            }else if(info.getAttendRemark() == 2){
                attendanceMap.put(key, "早退");
                early++;
                continue;
            }else if(info.getAttendRemark() == 3){
                attendanceMap.put(key, "缺勤");
                noAttend++;
                continue;
            }else if(info.getAttendRemark() == 4){
                attendanceMap.put(key, "请假");
                leave++;
                continue;
            }else if(info.getAttendRemark() == 5){
                attendanceMap.put(key, "下班未打卡");
                noOut++;
                continue;
            }

            if(leaveInfoCurrentMonth.get(key) == 1){
                attendanceMap.put(key, "请假");
                leave++;
                continue;
            }

            if(info.getClockOutTime() == null){
                attendanceMap.put(key, "下班未打卡");
                noOut++;
            }else if(AttendanceUtils.dateToHHmm(info.getClockInTime()).compareTo(rule.getAttendBegin()) >= 0 && AttendanceUtils.dateToHHmm(info.getClockOutTime()).compareTo(rule.getAttendBegin()) <= 0){
                attendanceMap.put(key, "迟到 & 早退");
                last++;
                early++;
            } else if(AttendanceUtils.dateToHHmm(info.getClockInTime()).compareTo(rule.getAttendBegin()) >= 0){
                attendanceMap.put(key, "迟到");
                last++;
            }else if(AttendanceUtils.dateToHHmm(info.getClockOutTime()).compareTo(rule.getAttendEnd()) <= 0){
                attendanceMap.put(key, "早退");
                early++;
            }else{
                attendanceMap.put(key, "√");
                normal++;
            }
        }
        Set<String> keys = leaveInfoCurrentMonth.keySet();
        for(String key : keys){
            try {
                if(new Date().compareTo(new SimpleDateFormat("yyyy-MM-dd").parse(key)) <= 0){
                    attendanceMap.put(key, "no");
                    continue;
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }
            if(leaveInfoCurrentMonth.get(key) == 1 && !attendanceMap.containsKey(key)){
                attendanceMap.put(key, "请假");
                leave++;
            }else if (leaveInfoCurrentMonth.get(key) == 0 && !attendanceMap.containsKey(key)){
                attendanceMap.put(key, "缺勤");
                noAttend++;
            }
        }
        countMap.put("normal", normal);
        countMap.put("noAttend", noAttend);
        countMap.put("leave", leave);
        countMap.put("last", last);
        countMap.put("early", early);
        countMap.put("noOut", noOut);
        Map<String, Map> resMap = new HashMap<>();
        resMap.put("attendance", attendanceMap);
        resMap.put("count", countMap);

        return resMap;
    }

    @Override
    public AttendanceInfo getByAppeal(AttendanceAppeal appeal) {
        return attendanceInfoMapper.selectByAppeal(appeal);
    }

    @Override
    public RespPageBean getMonthAttendance(String role, String department, String name, IPage<Admin> page, String date) {
        QueryWrapper<Admin> wrapper = new QueryWrapper<>();
        if(name != null && !name.equals("")){
            wrapper.like("name", name);
        }
        // 获取用户
        List<Admin> adminList = adminService.page(page, wrapper).getRecords();
        List<Map> res = new ArrayList<>();
        for(Admin admin : adminList){
            Map<String, Object> map = new HashMap<>();
            map.put("admin", new AdminVo(admin.getId(), admin.getName()));
            Date searchDate = null;
            try {
                searchDate = new SimpleDateFormat("yyyy-MM").parse(date);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            Map attendanceInMonthMap = caculateAttendanceInMonth(searchDate, admin.getId());
            map.put("count", attendanceInMonthMap.get("count"));
            res.add(map);
        }
        return new RespPageBean(new Long(res.size()), res);
    }
}
