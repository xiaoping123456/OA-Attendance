package com.xiaoping.server.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xiaoping.server.mapper.AttendanceAppealMapper;
import com.xiaoping.server.pojo.RespBean;
import com.xiaoping.server.pojo.RespPageBean;
import com.xiaoping.server.pojo.attendance.AttendanceAppeal;
import com.xiaoping.server.pojo.attendance.AttendanceInfo;
import com.xiaoping.server.service.AttendanceAppealService;
import com.xiaoping.server.service.AttendanceInfoService;
import com.xiaoping.server.utils.AdminUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.LocalDateTime;

/**
 * @author 小王造轮子
 * @description
 * @date 2022/12/7
 */
@Service
public class AttendanceAppealServiceImpl extends ServiceImpl<AttendanceAppealMapper, AttendanceAppeal> implements AttendanceAppealService {

    @Resource
    private AttendanceAppealMapper appealMapper;
    @Resource
    private AttendanceInfoService infoService;

    @Override
    public RespBean appeal(AttendanceAppeal appeal) {
        appeal.setUserId(AdminUtils.getCurrentAdmin().getId());
        appeal.setCreateTime(LocalDateTime.now());
        appeal.setStatus(0);
        save(appeal);
        return RespBean.success("申诉成功，请等待管理员审核");
    }

    @Override
    public RespPageBean getAppeals(Page page, String keyword, Integer type) {
        IPage<AttendanceAppeal> pageInfo = appealMapper.getAppeal(page, keyword, type);
        return new RespPageBean(pageInfo.getTotal(), pageInfo.getRecords());
    }

    @Override
    public RespBean updateAttendStatus(Integer appealId, Integer status) {
        // 修改出勤信息状态
        AttendanceAppeal appeal = getById(appealId);
        AttendanceInfo info = infoService.getByAppeal(appeal);
        info.setAttendRemark(status);
        infoService.updateById(info);

        appeal.setStatus(1);
        updateById(appeal);
        return RespBean.success("修改成功");
    }

    @Override
    public RespBean refuseAppeal(Integer appealId) {
        AttendanceAppeal appeal = new AttendanceAppeal();
        appeal.setId(appealId);
        appeal.setStatus(1);
        updateById(appeal);
        return RespBean.success("驳回成功");
    }
}
