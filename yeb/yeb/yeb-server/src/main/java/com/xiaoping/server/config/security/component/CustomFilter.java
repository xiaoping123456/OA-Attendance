package com.xiaoping.server.config.security.component;

import com.xiaoping.server.pojo.Menu;
import com.xiaoping.server.pojo.Role;
import com.xiaoping.server.service.IMenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.security.web.FilterInvocation;
import org.springframework.security.web.access.intercept.FilterInvocationSecurityMetadataSource;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;

import java.util.Collection;
import java.util.List;

/**
 * 权限控制
 * @author 小王造轮子
 * @description 根据请求url分析请求所需的角色
 * @date 2022/4/23
 */
@Component
public class CustomFilter implements FilterInvocationSecurityMetadataSource {

    /**
     * 过滤器调用安全元数据源。一般情况下，我们如果需要自定义权限拦截，则需要涉及到 FilterInvocationSecurityMetadataSource 这个接口
     *  通过接口中的getAttributes方法来确定请求需要哪些角色
     */

    @Autowired
    private IMenuService menuService;

    /**
     * 正则匹配工具
     */
    AntPathMatcher antPathMatcher = new AntPathMatcher();

    //访问适用于给定安全对象的配置信息。
    @Override
    public Collection<ConfigAttribute> getAttributes(Object object) throws IllegalArgumentException {
        //获取请求的url  (RequestMapping中的url)
        String requestUrl = ((FilterInvocation) object).getRequestUrl();
        //获取角色对应的菜单列表
        List<Menu> menus = menuService.getMenusWithRole();
        for (Menu menu:menus){
            //判断请求url与菜单角色是否匹配
            //antPathMatcher.match(path1,path2) 表示path路径是否符合pattern的规范  即path2是否符合path1的形式
            if (antPathMatcher.match(menu.getUrl(),requestUrl)){
                String[] str = menu.getRoles().stream().map(Role::getName).toArray(String[]::new);
                return SecurityConfig.createList(str);
            }
        }
        //没匹配的url默认登录即可访问
        return SecurityConfig.createList("ROLE_LOGIN");
    }

    //如果可用，则返回实现类定义的所有配置信息。
    @Override
    public Collection<ConfigAttribute> getAllConfigAttributes() {
        return null;
    }

    //指示SecurityMetadataSource实现是否能够为指示的安全对象类型提供ConfigAttributes。
    @Override
    public boolean supports(Class<?> clazz) {
        return false;
    }
}
