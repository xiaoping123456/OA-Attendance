package com.xiaoping.server.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xiaoping.server.pojo.MenuRole;
import com.xiaoping.server.pojo.RespBean;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author xiaoping
 * @since 2022-04-16
 */
public interface IMenuRoleService extends IService<MenuRole> {

    /**
     * 更新角色菜单
     * @param rid
     * @param mids
     * @return
     */
    RespBean updateMenuRole(Integer rid, Integer[] mids);
}
