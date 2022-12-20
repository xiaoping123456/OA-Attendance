package com.xiaoping.server.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xiaoping.server.pojo.AdminRole;
import com.xiaoping.server.pojo.RespBean;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author xiaoping
 * @since 2022-04-16
 */
public interface AdminRoleMapper extends BaseMapper<AdminRole> {

    /**
     * 更新操作员角色
     * @param adminId
     * @param rids
     * @return
     */
    Integer addAdminRole(@Param("adminId") Integer adminId, @Param("rids") Integer[] rids);
}
