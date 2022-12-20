package com.xiaoping.server.pojo.attendance;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * @author 小王造轮子
 * @description
 * @date 2022/11/25
 */
@Data
@TableName("t_attendance_rule")
public class AttendanceRule {

    @TableId
    private Integer id;

    private String attendBegin; // 考勤开始时间
    private String attendEnd;   // 考勤结束时间

}
