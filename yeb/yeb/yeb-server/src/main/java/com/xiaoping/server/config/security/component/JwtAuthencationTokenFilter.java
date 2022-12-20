package com.xiaoping.server.config.security.component;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author 小王造轮子
 * @description jwt登录授权过滤器
 * @date 2022/4/19
 */
public class JwtAuthencationTokenFilter extends OncePerRequestFilter {

    //OncePerRequestFilter spring中的filter默认集成OncePerRequestFilter
    //作用：够确保在一次请求中只通过一次filter，而需要重复的执行。
    //     是为了兼容不同的web container，也就是说并不是所有的container都入我们期望的只过滤一次，servlet版本不同，执行过程也不同，


    @Value("${jwt.tokenHeader}")
    private String tokenHeader;
    @Value("${jwt.tokenHead}")
    private String tokenHead;
    @Autowired
    private JwtTokenUtil jwtTokenUtil;
    @Autowired
    private UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        //拿到请求头中存储token的变量 Authorization
        String authHeader = request.getHeader(tokenHeader);
        //若存在token  判断token是否为空，是否是Bearer开头
        if(null!=authHeader && authHeader.startsWith(tokenHead)){
            //去掉token的前缀（Bearer）
            String authToken = authHeader.substring(tokenHead.length());
            //从token中获取username
            String username = jwtTokenUtil.getUserNameFromToken(authToken);
            //若token存在，但未登录（security上下文对象为空，说明未登录）
            if (null!=username && null== SecurityContextHolder.getContext().getAuthentication()){
                //登录
                UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                //验证token是否有效,重新设置用户对象（springSecurity上下文对象）
                if(jwtTokenUtil.validateToken(authToken,userDetails)){
                    UsernamePasswordAuthenticationToken authenticationToken =
                            new UsernamePasswordAuthenticationToken(userDetails,null,userDetails.getAuthorities());
                    authenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    SecurityContextHolder.getContext().setAuthentication(authenticationToken);
                }
            }
        }

        filterChain.doFilter(request,response);
    }
}
