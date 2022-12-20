package com.xiaoping.server.config.security.component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.xiaoping.server.pojo.RespBean;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @author 小王造轮子
 * @description 拒绝访问控制器  当访问接口没有权限时，自定义返回结果
 * @date 2022/4/19
 */
@Component
public class RestfulAccessDeniedHandler implements AccessDeniedHandler {

    //AccessDeineHandler 用来解决认证过的用户访问无权限资源时的异常

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException) throws IOException, ServletException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        RespBean bean = RespBean.error("RestfulAccessDeniedHandler + 权限不足!");
        bean.setCode(403);
        out.write(new ObjectMapper().writeValueAsString(bean));
        out.flush();
        out.close();
    }
}
