package com.xiaoping.server.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.xiaoping.server.pojo.attendance.AttendanceAppeal;

public interface AttendanceAppealMapper extends BaseMapper<AttendanceAppeal> {

    IPage<AttendanceAppeal> getAppeal(Page<AttendanceAppeal> page, String keyword, Integer type);

}
