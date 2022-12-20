package com.xiaoping.server.service.impl;

import com.aliyun.oss.OSS;
import com.aliyun.oss.model.CannedAccessControlList;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xiaoping.server.config.OSSConfig;
import com.xiaoping.server.config.security.component.JwtTokenUtil;
import com.xiaoping.server.mapper.AdminMapper;
import com.xiaoping.server.mapper.AdminRoleMapper;
import com.xiaoping.server.mapper.RoleMapper;
import com.xiaoping.server.pojo.Admin;
import com.xiaoping.server.pojo.AdminRole;
import com.xiaoping.server.pojo.RespBean;
import com.xiaoping.server.pojo.Role;
import com.xiaoping.server.service.IAdminService;
import com.xiaoping.server.utils.AdminUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author xiaoping
 * @since 2022-04-16
 */
@Service
public class AdminServiceImpl extends ServiceImpl<AdminMapper, Admin> implements IAdminService {

    @Autowired
    private UserDetailsService userDetailsService;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private JwtTokenUtil jwtTokenUtil;
    @Autowired
    private AdminMapper adminMapper;
    @Autowired
    private RoleMapper roleMapper;
    @Autowired
    private AdminRoleMapper adminRoleMapper;

    @Autowired
    private OSS ossClient;

    @Value("${jwt.tokenHead}")
    private String tokenHead;

    /**
     * 登录之后返回token
     *
     * @param username
     * @param password
     * @param request
     * @return
     */
    @Override
    public RespBean login(String username, String password, String code, HttpServletRequest request) {
        //判断图形验证码
        String captcha = (String) request.getSession().getAttribute("captcha");
        if (StringUtils.isEmpty(code) || !captcha.equalsIgnoreCase(code)) {
            return RespBean.error("验证码输入错误，请重新输入");
        }
        request.getSession().removeAttribute("captcha");

        UserDetails userDetails = userDetailsService.loadUserByUsername(username);
        if (null == userDetails || !passwordEncoder.matches(password, userDetails.getPassword())) {
            return RespBean.error("用户名或密码不正确");
        }
        if (!userDetails.isEnabled()) {
            return RespBean.error("账号被禁用，请联系管理员！");
        }

        //更新security登录用户对象
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(userDetails
                , null, userDetails.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authenticationToken);

        //生成token
        String token = jwtTokenUtil.generateToken(userDetails);
        Map<String, Object> tokenMap = new HashMap<>();
        tokenMap.put("token", token);
        tokenMap.put("tokenHead", tokenHead);
        return RespBean.success("登录成功", tokenMap);
    }

    @Override
    public Admin getAdminByUserName(String username) {
        QueryWrapper<Admin> queryWrapper = new QueryWrapper<Admin>()
                .eq("username", username)
                .eq("enabled", true);
        return adminMapper.selectOne(queryWrapper);
    }

    /**
     * 根据用户id插叙角色列表
     *
     * @param adminId
     * @return
     */
    @Override
    public List<Role> getRoles(Integer adminId) {
        return roleMapper.getRoles(adminId);
    }

    /**
     * 获取所有操作员
     *
     * @return
     */
    @Override
    public List<Admin> getAllAdmins(String keywords) {
        return adminMapper.getAllAdmins(AdminUtils.getCurrentAdmin().getId(), keywords);
    }

    /**
     * 更新操作员角色
     *
     * @param adminId
     * @param rids
     * @return
     */
    @Override
    @Transactional
    public RespBean updateAdminRole(Integer adminId, Integer[] rids) {
        adminRoleMapper.delete(new QueryWrapper<AdminRole>().eq("adminId", adminId));
        Integer result = adminRoleMapper.addAdminRole(adminId, rids);
        if (rids.length == result) {
            return RespBean.success("更新成功");
        }
        return RespBean.error("更新失败");
    }

    /**
     * 更新用户密码
     *
     * @param oldPass
     * @param pass
     * @param adminId
     * @return
     */
    @Override
    public RespBean updateAdminPassword(String oldPass, String pass, Integer adminId) {
        Admin admin = adminMapper.selectById(adminId);
        //判断旧密码是否正确
        if (passwordEncoder.matches(oldPass, admin.getPassword())) {
            admin.setPassword(passwordEncoder.encode(pass));
            int result = adminMapper.updateById(admin);
            if (result == 1) {
                return RespBean.success("更新成功");
            }
            return RespBean.error("更新失败");
        }
        return RespBean.error("旧密码错误");
    }

    @Override
    public RespBean uploadHeadPic(MultipartFile file, Integer id) {

        if (!ossClient.doesBucketExist(OSSConfig.BUCKET_NAME)) {
            //如果bucket不存在 则创建bucket
            ossClient.createBucket(OSSConfig.BUCKET_NAME);
            //设置访问权限 公共读
            ossClient.setBucketAcl(OSSConfig.BUCKET_NAME, CannedAccessControlList.PublicRead);
        }

        //获取上传文件流
        try {
            InputStream inputStream = file.getInputStream();
            //重命名
            String originName = file.getOriginalFilename();
            String fileType = originName.substring(originName.lastIndexOf("."));
            String fileName = UUID.randomUUID().toString().replace("-", "");
            //存储位置
            String url = "yeb/headPic/" + id + "/" + fileName + fileType;
            ossClient.putObject(OSSConfig.BUCKET_NAME, url, inputStream);
            ossClient.shutdown();
            //获取url地址
            String uploadUrl = "https://" + OSSConfig.BUCKET_NAME + "." + OSSConfig.END_POINT + "/" + url;
            Admin admin = new Admin();
            admin.setId(id);
            admin.setUserFace(uploadUrl);
            admin.setEnabled(true);
            adminMapper.updateById(admin);
            return RespBean.success("上传成功",uploadUrl);
        } catch (IOException e) {
            e.printStackTrace();
            return RespBean.error("上传失败");
        }
    }


}
