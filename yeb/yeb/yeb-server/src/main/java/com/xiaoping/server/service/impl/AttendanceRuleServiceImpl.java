package com.xiaoping.server.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xiaoping.server.mapper.AppraiseMapper;
import com.xiaoping.server.mapper.AttendanceRuleMapper;
import com.xiaoping.server.pojo.Appraise;
import com.xiaoping.server.pojo.RespBean;
import com.xiaoping.server.pojo.attendance.AttendanceRule;
import com.xiaoping.server.service.AttendanceRuleService;
import org.springframework.stereotype.Service;

/**
 * @author 小王造轮子
 * @description
 * @date 2022/11/25
 */
@Service
public class AttendanceRuleServiceImpl extends ServiceImpl<AttendanceRuleMapper, AttendanceRule> implements AttendanceRuleService {



    @Override
    public RespBean editAttendTimeRule(AttendanceRule attendanceRule) {
        if (update(attendanceRule, null)){
            return RespBean.success("修改成功");
        }
        return RespBean.error("修改失败");
    }

    @Override
    public AttendanceRule getAttendTimeRule() {
        AttendanceRule rule = getOne(null);
        return rule;
    }
}
