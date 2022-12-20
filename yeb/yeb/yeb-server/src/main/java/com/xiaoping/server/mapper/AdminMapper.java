package com.xiaoping.server.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xiaoping.server.pojo.Admin;
import com.xiaoping.server.pojo.Menu;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author xiaoping
 * @since 2022-04-16
 */
public interface AdminMapper extends BaseMapper<Admin> {

    /**
     * 获取所有操作员
     * @param id
     * @param keywords
     * @return
     */
    List<Admin> getAllAdmins(Integer id, String keywords);

}
