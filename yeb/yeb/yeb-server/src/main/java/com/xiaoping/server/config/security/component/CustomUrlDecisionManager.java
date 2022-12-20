package com.xiaoping.server.config.security.component;

import org.springframework.security.access.AccessDecisionManager;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.InsufficientAuthenticationException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;

import java.util.Collection;

/**
 * 权限控制
 * @author 小王造轮子
 * @description 判断用户角色
 * @date 2022/4/24
 */
@Component
public class CustomUrlDecisionManager implements AccessDecisionManager {

    /**
     * AccessDecisionManager 自定义访问决策管理器
     * */

    //为传递的参数解决访问控制决策。只要任一 AccessDecisionVoter 返回肯定的结果，便授予访问权限。
    @Override
    public void decide(Authentication authentication, Object object, Collection<ConfigAttribute> configAttributes) throws AccessDeniedException, InsufficientAuthenticationException {
        //ConfigAttribute的作用是存储与安全系统相关的配置属性。 （此处是某个菜单需要的用户的角色，即访问某个url需要的权限）
        //此处的configAttribute是CustomFilter中getAttributes()方法的返回值
        //遍历configAttribute 若当前用户的角色满足该url所需角色 直接return，否则 抛出权限不足的异常
        for (ConfigAttribute configAttribute:configAttributes){
            //当前url所需角色
            String needRole = configAttribute.getAttribute();

            if ("ROLE_LOGIN".equals(needRole)){
                //判断角色是否登录
                if (authentication instanceof AnonymousAuthenticationToken){
                    throw new AccessDeniedException("尚未登录，请登录");
                }else{
                    //放行
                    return;
                }
            }
            //判断用户角色是否为url所需角色
            Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
            for (GrantedAuthority authority:authorities){
                if (authority.getAuthority().equals(needRole)){
                    //放行
                    return;
                }
            }
        }
        //不拥有需要的角色 则抛出异常
        throw  new AccessDeniedException("权限不足，请联系管理员");
    }

    @Override
    public boolean supports(ConfigAttribute attribute) {
        return false;
    }

    @Override
    public boolean supports(Class<?> clazz) {
        return false;
    }
}
