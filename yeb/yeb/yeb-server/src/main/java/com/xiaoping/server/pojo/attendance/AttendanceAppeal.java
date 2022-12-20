package com.xiaoping.server.pojo.attendance;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * @author 小王造轮子
 * @description
 * @date 2022/12/7
 */
@Data
@NoArgsConstructor
@TableName("t_attendance_appeal")
public class AttendanceAppeal {

    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 要申诉的 日期
     */
    private String date;

    private Integer userId;
    private String info;

    private LocalDateTime createTime;

    /**
     * 状态：0：未审核；1：同意；2：拒绝
     */
    private Integer status;

    @TableField(exist = false)
    private String username;

}
