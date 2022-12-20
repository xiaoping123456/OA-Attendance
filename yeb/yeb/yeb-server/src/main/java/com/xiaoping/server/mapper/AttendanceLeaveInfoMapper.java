package com.xiaoping.server.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.xiaoping.server.pojo.attendance.AttendanceLeaveInfo;

public interface AttendanceLeaveInfoMapper extends BaseMapper<AttendanceLeaveInfo> {

    IPage<AttendanceLeaveInfo> getApply(Page<AttendanceLeaveInfo> page, String keyword, Integer type);

}
