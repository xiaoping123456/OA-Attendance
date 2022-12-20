package com.xiaoping.server.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xiaoping.server.mapper.MenuMapper;
import com.xiaoping.server.pojo.Admin;
import com.xiaoping.server.pojo.Menu;
import com.xiaoping.server.service.IMenuService;
import com.xiaoping.server.utils.AdminUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.Collections;
import java.util.List;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author xiaoping
 * @since 2022-04-16
 */
@Service
public class MenuServiceImpl extends ServiceImpl<MenuMapper, Menu> implements IMenuService {

    @Autowired
    private MenuMapper menuMapper;
    @Autowired
    private RedisTemplate<String,Object> redisTemplate;

    /**
     * 根据用户id插叙菜单列表
     * @return
     */
    @Override
    public List<Menu> getMenusByAdminId() {
        Integer adminId = AdminUtils.getCurrentAdmin().getId();
        // ValueOperations<String,Object> valueOperations = redisTemplate.opsForValue();
        // //从redis获取菜单数据
        // List<Menu> menus =  (List<Menu>) valueOperations.get("menu_"+adminId);
        // //如果redis中没有,去数据库中获取
        // if (CollectionUtils.isEmpty(menus)){
        //     menus = menuMapper.getMenusByAdminId(adminId);
        //     //将数据设置到redis中
        //     valueOperations.set("menu_"+adminId,menus);
        // }
        // return menus;

        return menuMapper.getMenusByAdminId(adminId);
    }

    /**
     * 根据角色获取菜单列表
     * @return
     */
    @Override
    public List<Menu> getMenusWithRole() {

        return menuMapper.getMenusWithRole();
    }

    /**
     * 查询所有菜单
     * @return
     */
    @Override
    public List<Menu> getAllMenus() {
        return menuMapper.getAllMenus();
    }
}
