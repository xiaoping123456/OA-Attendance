package com.xiaoping.server.pojo.attendance;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * @author 小王造轮子
 * @description
 * @date 2022/11/25
 */
@Data
@TableName("t_attendance_info")
public class AttendanceInfo {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer userId;

    private LocalDateTime clockInTime;
    private LocalDateTime clockOutTime;

    /**
     * 考勤标记：0：正常； 1：迟到； 2：早退； 3：缺勤；4：请假；5：下班未打卡
     */
    private Integer attendRemark;


}
