package com.xiaoping.server.controller;

import com.xiaoping.server.pojo.Admin;
import com.xiaoping.server.pojo.RespBean;
import com.xiaoping.server.service.IAdminService;
import com.xiaoping.server.utils.AdminUtils;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

/**
 * @author 小王造轮子
 * @description 个人中心
 * @date 2022/4/30
 */
@RestController
public class AdminInfoController {

    @Autowired
    private IAdminService adminService;

    @ApiOperation(value = "更新当前用户信息")
    @PutMapping("/admin/info")
    public RespBean updateAdmin(@RequestBody Admin admin, Authentication authentication){
        if (adminService.updateById(admin)){
            SecurityContextHolder.getContext().setAuthentication(new UsernamePasswordAuthenticationToken(admin,null
                    ,authentication.getAuthorities()));
            return RespBean.success("更新成功");
        }
        return RespBean.error("更新失败");
    }

    @ApiOperation(value = "更新用户密码")
    @PutMapping("/admin/pass")
    public RespBean updateAdminPassword(@RequestBody Map<String,Object> info){
        String oldPass = (String) info.get("oldPass");
        String pass = (String) info.get("pass");
        Integer adminId = (Integer) info.get("adminId");

        return adminService.updateAdminPassword(oldPass,pass,adminId);

    }

    @ApiOperation(value = "上传头像")
    @PostMapping("/admin/uploadHeadPic")
    public RespBean uploadHeadPic(@RequestPart("file")MultipartFile file){
        return adminService.uploadHeadPic(file, AdminUtils.getCurrentAdmin().getId());
    }


}
