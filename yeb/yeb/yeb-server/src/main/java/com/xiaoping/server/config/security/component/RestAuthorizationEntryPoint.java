package com.xiaoping.server.config.security.component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.xiaoping.server.pojo.RespBean;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @author 小王造轮子
 * @description 当未登录或者token失效 访问接口时，自定义的返回结果
 * @date 2022/4/19
 */
@Component
public class RestAuthorizationEntryPoint implements AuthenticationEntryPoint {

    //AuthenticationEntryPoint 用来解决匿名用户访问无权限资源时的异常

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException, ServletException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        RespBean bean = RespBean.error("RestAuthorizationEntryPoint + 未登录!");
        bean.setCode(401);
        out.write(new ObjectMapper().writeValueAsString(bean));
        out.flush();
        out.close();
    }
}
