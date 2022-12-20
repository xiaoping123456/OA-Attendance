package com.xiaoping.server;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.xiaoping.server.mapper.AttendanceLeaveInfoMapper;
import com.xiaoping.server.pojo.Joblevel;
import com.xiaoping.server.pojo.attendance.AttendanceLeaveInfo;
import com.xiaoping.server.service.IJoblevelService;
import javafx.beans.binding.ObjectBinding;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import javax.annotation.Resource;

/**
 * @author 小王造轮子
 * @description test
 * @date 2022/5/7
 */
@SpringBootTest
public class Test {

    @Autowired
    private IJoblevelService joblevelService;
    @Resource
    private AttendanceLeaveInfoMapper leaveInfoMapper;

    @org.junit.jupiter.api.Test
    public void test(){
        Joblevel joblevel = new Joblevel();
        joblevel.setId(9);
        joblevel.setName("asdf");
        joblevelService.updateById(joblevel);
    }

    @org.junit.jupiter.api.Test
    public void testGetApply(){
        Page<AttendanceLeaveInfo> page = new Page<>(1, 10);
        IPage<AttendanceLeaveInfo> pageInfo = leaveInfoMapper.getApply(page, null, null);
        System.out.println(pageInfo.getRecords());
    }

}
