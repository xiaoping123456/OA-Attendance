package com.xiaoping.server.utils;

import com.xiaoping.server.pojo.Admin;
import org.springframework.security.core.context.SecurityContextHolder;

import static org.springframework.security.core.context.SecurityContextHolder.*;

/**
 * @author 小王造轮子
 * @description 操作员工具类
 * @date 2022/4/25
 */
public class AdminUtils {

    /**
     * 获取当前登录操作员
     * @return
     */
    public static Admin getCurrentAdmin() {

        return (Admin) getContext().getAuthentication().getPrincipal();
    }

}
