package com.xiaoping.server.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xiaoping.server.pojo.Role;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author xiaoping
 * @since 2022-04-16
 */
public interface RoleMapper extends BaseMapper<Role> {

    /**
     * 根据用户id插叙角色列表
     * @param adminId
     * @return
     */
    List<Role> getRoles(Integer adminId);
}
