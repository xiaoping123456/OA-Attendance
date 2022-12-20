package com.xiaoping.server.pojo.attendance;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.xiaoping.server.pojo.Admin;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * @author 小王造轮子
 * @description
 * @date 2022/11/25
 */
@Data
@TableName("t_attendance_leave_info")
public class AttendanceLeaveInfo {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private Integer userId;
    private LocalDateTime createTime;
    /**
     * 类型：
     */
    private Integer type;
    /**
     * 状态：0：待审核；1：通过；2：拒绝；3：已销假
     */
    private Integer status;
    private LocalDateTime beginTime;
    private LocalDateTime endTime;
    private String info;

    /**
     * 销假时间
     */
    private LocalDateTime backTime;

    @TableField(exist = false)
    private String username;

}
