/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50520
 Source Host           : localhost:3306
 Source Schema         : yeb

 Target Server Type    : MySQL
 Target Server Version : 50520
 File Encoding         : 65001

 Date: 20/12/2022 11:11:22
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_admin
-- ----------------------------
DROP TABLE IF EXISTS `t_admin`;
CREATE TABLE `t_admin`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `phone` char(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号码',
  `telephone` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '住宅电话',
  `address` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系地址',
  `enabled` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `userFace` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户头像',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `eid` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `eid`(`eid`) USING BTREE,
  CONSTRAINT `t_admin_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `t_employee` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_admin
-- ----------------------------
INSERT INTO `t_admin` VALUES (1, '系统管理员', '13812361398', '71937538', '香港特别行政区强县长寿柳州路p座123', 1, 'admin', '$2a$10$o7DVGK.uM0YIrN/YmcgGXOfV6OIpVJa3KthpoawZh6K3AMQGTwixO', 'https://usual-xiaowang.oss-cn-beijing.aliyuncs.com/yeb/1/62c6ed83a46e4a3fa67ce5d0e09f1f71.md', NULL, 1);
INSERT INTO `t_admin` VALUES (7, '张三', '19811733130', NULL, '山东省淄博市', 1, 'b9863532245e4f32ae816978e2d90d52', '$2a$10$vzpB1vNivFWFZmHb58z2feZ169Gg7Yz.pP0QLFfq.XeJSgmbyK.za', NULL, NULL, 228);
INSERT INTO `t_admin` VALUES (8, '李四', '19811733131', NULL, '山东省聊城市', 1, 'f208d625acce49beb05c30097fcc941e', '$2a$10$9We9MAy8Pe1n2CUM/FL26Ow0xaLvEhw/GXN4KItNSYhxgTdOhdlqW', NULL, NULL, 229);
INSERT INTO `t_admin` VALUES (9, '王五', '19811733132', NULL, '山东省威海市', 1, '4db123a09ec74004adbcd479128df708', '$2a$10$m1jD6vE3GFlrFJmxylDV5eXX1wadpuXtFRYlyBSaxWqozwOccQmby', NULL, NULL, 230);

-- ----------------------------
-- Table structure for t_admin_role
-- ----------------------------
DROP TABLE IF EXISTS `t_admin_role`;
CREATE TABLE `t_admin_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `adminId` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `rid` int(11) NULL DEFAULT NULL COMMENT '权限id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `rid`(`rid`) USING BTREE,
  INDEX `adminId`(`adminId`) USING BTREE,
  CONSTRAINT `t_admin_role_ibfk_1` FOREIGN KEY (`adminId`) REFERENCES `t_admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `t_admin_role_ibfk_2` FOREIGN KEY (`rid`) REFERENCES `t_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_admin_role
-- ----------------------------
INSERT INTO `t_admin_role` VALUES (16, 1, 6);
INSERT INTO `t_admin_role` VALUES (99, 7, 9);
INSERT INTO `t_admin_role` VALUES (100, 8, 2);
INSERT INTO `t_admin_role` VALUES (101, 9, 8);

-- ----------------------------
-- Table structure for t_appraise
-- ----------------------------
DROP TABLE IF EXISTS `t_appraise`;
CREATE TABLE `t_appraise`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `eid` int(11) NULL DEFAULT NULL COMMENT '员工id',
  `appDate` date NULL DEFAULT NULL COMMENT '考评日期',
  `appResult` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '考评结果',
  `appContent` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '考评内容',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `eid`(`eid`) USING BTREE,
  CONSTRAINT `t_appraise_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `t_employee` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_appraise
-- ----------------------------

-- ----------------------------
-- Table structure for t_attendance_appeal
-- ----------------------------
DROP TABLE IF EXISTS `t_attendance_appeal`;
CREATE TABLE `t_attendance_appeal`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `userId` int(11) NOT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `createTime` datetime NOT NULL,
  `status` int(11) NULL DEFAULT NULL COMMENT '状态：0：未审核；1：同意；2：拒绝',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_attendance_appeal
-- ----------------------------
INSERT INTO `t_attendance_appeal` VALUES (1, '2022-12-09', 1, '123132123', '2022-12-08 16:26:13', 1);
INSERT INTO `t_attendance_appeal` VALUES (2, '2022-12-04', 7, '我没迟到', '2022-12-13 15:32:10', 1);

-- ----------------------------
-- Table structure for t_attendance_info
-- ----------------------------
DROP TABLE IF EXISTS `t_attendance_info`;
CREATE TABLE `t_attendance_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `attendRemark` int(1) NULL DEFAULT NULL COMMENT '考勤标记：0：正常； 1：迟到； 2：早退； 3：缺勤；4：请假；5：下班未打卡',
  `clockInTime` datetime NULL DEFAULT NULL COMMENT '上班打卡时间',
  `clockOutTime` datetime NULL DEFAULT NULL COMMENT '下班打卡时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_attendance_info
-- ----------------------------
INSERT INTO `t_attendance_info` VALUES (6, 1, 0, '2022-12-09 16:09:56', NULL);
INSERT INTO `t_attendance_info` VALUES (7, 7, 0, '2022-12-01 07:47:35', '2022-12-01 21:47:44');
INSERT INTO `t_attendance_info` VALUES (8, 7, 0, '2022-12-02 07:47:35', '2022-12-02 21:47:44');
INSERT INTO `t_attendance_info` VALUES (9, 7, 0, '2022-12-03 07:47:35', '2022-12-03 21:47:44');
INSERT INTO `t_attendance_info` VALUES (10, 7, 0, '2022-12-04 09:47:35', '2022-12-04 21:47:44');
INSERT INTO `t_attendance_info` VALUES (11, 7, 2, '2022-12-05 07:47:35', '2022-12-05 17:47:46');
INSERT INTO `t_attendance_info` VALUES (12, 7, 0, '2022-12-06 07:47:35', '2022-12-06 21:47:44');
INSERT INTO `t_attendance_info` VALUES (13, 7, 0, '2022-12-07 07:47:35', '2022-12-07 21:47:44');
INSERT INTO `t_attendance_info` VALUES (14, 7, 0, '2022-12-08 07:47:35', '2022-12-08 21:47:44');
INSERT INTO `t_attendance_info` VALUES (15, 8, 0, '2022-12-01 07:47:35', '2022-12-01 21:47:44');
INSERT INTO `t_attendance_info` VALUES (16, 8, 0, '2022-12-02 07:47:35', '2022-12-02 21:47:44');
INSERT INTO `t_attendance_info` VALUES (17, 8, 0, '2022-12-03 07:47:35', '2022-12-03 21:47:44');
INSERT INTO `t_attendance_info` VALUES (18, 9, 0, '2022-12-07 07:47:35', '2022-12-07 21:47:44');
INSERT INTO `t_attendance_info` VALUES (19, 9, 0, '2022-12-08 07:47:35', '2022-12-08 21:47:44');

-- ----------------------------
-- Table structure for t_attendance_leave_info
-- ----------------------------
DROP TABLE IF EXISTS `t_attendance_leave_info`;
CREATE TABLE `t_attendance_leave_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `createTime` datetime NOT NULL,
  `type` int(1) NULL DEFAULT NULL COMMENT '类型：',
  `status` int(1) NOT NULL COMMENT '状态：0：待审核；1：通过；2：拒绝；3：已销假',
  `beginTime` datetime NOT NULL,
  `endTime` datetime NOT NULL,
  `info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请假信息',
  `backTime` datetime NULL DEFAULT NULL COMMENT '销假时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_attendance_leave_info
-- ----------------------------
INSERT INTO `t_attendance_leave_info` VALUES (10, 7, '2022-12-13 00:00:00', NULL, 1, '2022-12-13 16:00:00', '2022-12-14 16:00:00', '家里有事', NULL);

-- ----------------------------
-- Table structure for t_attendance_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_attendance_rule`;
CREATE TABLE `t_attendance_rule`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attendBegin` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `attendEnd` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_attendance_rule
-- ----------------------------
INSERT INTO `t_attendance_rule` VALUES (1, '08:00', '18:00');

-- ----------------------------
-- Table structure for t_department
-- ----------------------------
DROP TABLE IF EXISTS `t_department`;
CREATE TABLE `t_department`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门名称',
  `parentId` int(11) NULL DEFAULT NULL COMMENT '父id',
  `depPath` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '路径',
  `enabled` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `isParent` tinyint(1) NULL DEFAULT 0 COMMENT '是否上级',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_department
-- ----------------------------
INSERT INTO `t_department` VALUES (1, '股东会', -1, '.1', 1, 1);
INSERT INTO `t_department` VALUES (2, '董事会', 1, '.1.2', 1, 1);
INSERT INTO `t_department` VALUES (3, '总办', 2, '.1.2.3', 1, 1);
INSERT INTO `t_department` VALUES (4, '财务部', 3, '.1.2.3.4', 1, 0);
INSERT INTO `t_department` VALUES (5, '市场部', 3, '.1.2.3.5', 1, 1);
INSERT INTO `t_department` VALUES (6, '华东市场部', 5, '1.2.3.5.6', 1, 1);
INSERT INTO `t_department` VALUES (7, '华南市场部', 5, '1.2.3.5.7', 1, 0);
INSERT INTO `t_department` VALUES (8, '上海市场部', 6, '1.2.3.5.6.8', 1, 0);
INSERT INTO `t_department` VALUES (9, '西北市场部', 5, '.1.2.3.5.9', 1, 1);
INSERT INTO `t_department` VALUES (10, '贵阳市场', 9, '.1.2.3.5.9.10', 1, 1);
INSERT INTO `t_department` VALUES (11, '乌当区市场', 10, '.1.2.3.5.9.10.11', 1, 0);
INSERT INTO `t_department` VALUES (12, '技术部', 3, '.1.2.3.12', 1, 0);
INSERT INTO `t_department` VALUES (13, '运维部', 3, '.1.2.3.13', 1, 1);
INSERT INTO `t_department` VALUES (16, '测试部门3', 13, '.1.2.3.13.16', 1, 0);

-- ----------------------------
-- Table structure for t_employee
-- ----------------------------
DROP TABLE IF EXISTS `t_employee`;
CREATE TABLE `t_employee`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '员工编号',
  `name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '员工姓名',
  `gender` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '性别',
  `birthday` date NULL DEFAULT NULL COMMENT '出生日期',
  `idCard` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `wedlock` enum('已婚','未婚','离异') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '婚姻状况',
  `nationId` int(8) NULL DEFAULT NULL COMMENT '民族',
  `nativePlace` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '籍贯',
  `politicId` int(8) NULL DEFAULT NULL COMMENT '政治面貌',
  `email` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电话号码',
  `address` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系地址',
  `departmentId` int(11) NULL DEFAULT NULL COMMENT '所属部门',
  `jobLevelId` int(11) NULL DEFAULT NULL COMMENT '职称ID',
  `posId` int(11) NULL DEFAULT NULL COMMENT '职位ID',
  `engageForm` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '聘用形式',
  `tiptopDegree` enum('博士','硕士','本科','大专','高中','初中','小学','其他') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最高学历',
  `specialty` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所属专业',
  `school` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '毕业院校',
  `beginDate` date NULL DEFAULT NULL COMMENT '入职日期',
  `workState` enum('在职','离职') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '在职' COMMENT '在职状态',
  `workID` char(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工号',
  `contractTerm` double NULL DEFAULT NULL COMMENT '合同期限',
  `conversionTime` date NULL DEFAULT NULL COMMENT '转正日期',
  `notWorkDate` date NULL DEFAULT NULL COMMENT '离职日期',
  `beginContract` date NULL DEFAULT NULL COMMENT '合同起始日期',
  `endContract` date NULL DEFAULT NULL COMMENT '合同终止日期',
  `workAge` int(11) NULL DEFAULT NULL COMMENT '工龄',
  `salaryId` int(11) NULL DEFAULT NULL COMMENT '工资账套ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `departmentId`(`departmentId`) USING BTREE,
  INDEX `jobId`(`jobLevelId`) USING BTREE,
  INDEX `posId`(`posId`) USING BTREE,
  INDEX `nationId`(`nationId`) USING BTREE,
  INDEX `politicId`(`politicId`) USING BTREE,
  INDEX `workId`(`workID`) USING BTREE,
  INDEX `salaryId`(`salaryId`) USING BTREE,
  CONSTRAINT `t_employee_ibfk_1` FOREIGN KEY (`departmentId`) REFERENCES `t_department` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `t_employee_ibfk_2` FOREIGN KEY (`jobLevelId`) REFERENCES `t_joblevel` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `t_employee_ibfk_3` FOREIGN KEY (`posId`) REFERENCES `t_position` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `t_employee_ibfk_4` FOREIGN KEY (`nationId`) REFERENCES `t_nation` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `t_employee_ibfk_5` FOREIGN KEY (`politicId`) REFERENCES `t_politics_status` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `t_employee_ibfk_6` FOREIGN KEY (`salaryId`) REFERENCES `t_salary` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 231 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_employee
-- ----------------------------
INSERT INTO `t_employee` VALUES (1, '系统管理员', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '在职', '000001', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `t_employee` VALUES (228, '张三', '男', '2000-01-01', '130229200105210000', '未婚', 1, '山东省淄博市', 3, 'zhansan@163.com', '19811733130', '山东省淄博市', 12, 5, 4, '劳动合同', '本科', '软件工程', '山东理工大学', '2022-12-01', '在职', '00000002', 1, '2022-12-12', NULL, '2022-12-01', '2023-12-01', NULL, NULL);
INSERT INTO `t_employee` VALUES (229, '李四', '男', '2001-01-01', '130229200105210000', '已婚', 1, '山东省聊城市', 1, '123@163.com', '19811733131', '山东省聊城市', 12, 7, 1, '劳动合同', '硕士', '软件工程', '北京大学', '2022-11-01', '在职', '00000002', 1.08, '2022-12-01', NULL, '2022-11-01', '2023-12-01', NULL, NULL);
INSERT INTO `t_employee` VALUES (230, '王五', '男', '2000-01-01', '130229200105210000', '未婚', 2, '山东省威海市', 2, '123@163.com', '19811733132', '山东省威海市', 5, 7, 3, '劳务合同', '博士', '软件工程', '清华大学', '2022-12-01', '在职', '00000002', 1, '2022-12-02', NULL, '2022-12-01', '2023-12-01', NULL, NULL);

-- ----------------------------
-- Table structure for t_employee_ec
-- ----------------------------
DROP TABLE IF EXISTS `t_employee_ec`;
CREATE TABLE `t_employee_ec`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `eid` int(11) NULL DEFAULT NULL COMMENT '员工编号',
  `ecDate` date NULL DEFAULT NULL COMMENT '奖罚日期',
  `ecReason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '奖罚原因',
  `ecPoint` int(11) NULL DEFAULT NULL COMMENT '奖罚分',
  `ecType` int(11) NULL DEFAULT NULL COMMENT '奖罚类别，0：奖，1：罚',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `eid`(`eid`) USING BTREE,
  CONSTRAINT `t_employee_ec_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `t_employee` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_employee_ec
-- ----------------------------

-- ----------------------------
-- Table structure for t_employee_remove
-- ----------------------------
DROP TABLE IF EXISTS `t_employee_remove`;
CREATE TABLE `t_employee_remove`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `eid` int(11) NULL DEFAULT NULL COMMENT '员工id',
  `afterDepId` int(11) NULL DEFAULT NULL COMMENT '调动后部门',
  `afterJobId` int(11) NULL DEFAULT NULL COMMENT '调动后职位',
  `removeDate` date NULL DEFAULT NULL COMMENT '调动日期',
  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '调动原因',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `eid`(`eid`) USING BTREE,
  CONSTRAINT `t_employee_remove_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `t_employee` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_employee_remove
-- ----------------------------

-- ----------------------------
-- Table structure for t_employee_train
-- ----------------------------
DROP TABLE IF EXISTS `t_employee_train`;
CREATE TABLE `t_employee_train`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `eid` int(11) NULL DEFAULT NULL COMMENT '员工编号',
  `trainDate` date NULL DEFAULT NULL COMMENT '培训日期',
  `trainContent` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '培训内容',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `eid`(`eid`) USING BTREE,
  CONSTRAINT `t_employee_train_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `t_employee` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_employee_train
-- ----------------------------

-- ----------------------------
-- Table structure for t_joblevel
-- ----------------------------
DROP TABLE IF EXISTS `t_joblevel`;
CREATE TABLE `t_joblevel`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '职称名称',
  `titleLevel` enum('正高级','副高级','中级','初级','员级') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '职称等级',
  `createDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `enabled` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_joblevel
-- ----------------------------
INSERT INTO `t_joblevel` VALUES (1, '教授', '正高级', '2020-03-31 16:20:34', 1);
INSERT INTO `t_joblevel` VALUES (2, '副教授', '副高级', '2020-03-31 16:20:34', 1);
INSERT INTO `t_joblevel` VALUES (3, '助教', '初级', '2020-03-31 16:20:34', 1);
INSERT INTO `t_joblevel` VALUES (4, '讲师', '中级', '2020-03-31 16:20:34', 0);
INSERT INTO `t_joblevel` VALUES (5, '初级工程师', '初级', '2020-03-31 16:20:34', 1);
INSERT INTO `t_joblevel` VALUES (6, '中级工程师', '中级', '2020-03-31 16:20:34', 1);
INSERT INTO `t_joblevel` VALUES (7, '高级工程师', '副高级', '2020-03-31 16:20:34', 1);
INSERT INTO `t_joblevel` VALUES (8, '骨灰级工程师', '正高级', '2020-03-31 16:20:34', 1);

-- ----------------------------
-- Table structure for t_mail_log
-- ----------------------------
DROP TABLE IF EXISTS `t_mail_log`;
CREATE TABLE `t_mail_log`  (
  `msgId` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '消息id',
  `eid` int(11) NULL DEFAULT NULL COMMENT '接收员工id',
  `status` int(1) NULL DEFAULT NULL COMMENT '状态（0:消息投递中 1:投递成功 2:投递失败）',
  `routeKey` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '路由键',
  `exchange` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '交换机',
  `count` int(1) NULL DEFAULT NULL COMMENT '重试次数',
  `tryTime` datetime NULL DEFAULT NULL COMMENT '重试时间',
  `createTime` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updateTime` datetime NULL DEFAULT NULL COMMENT '更新时间',
  UNIQUE INDEX `msgId`(`msgId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_mail_log
-- ----------------------------
INSERT INTO `t_mail_log` VALUES ('02f5459d-1f0c-48bd-9c0b-e65530da4e82', 229, 0, 'mail.routing.key', 'mail.exchange', 0, '2022-12-13 13:18:37', '2022-12-13 13:17:37', '2022-12-13 13:17:37');
INSERT INTO `t_mail_log` VALUES ('05072080-0c4b-4dcb-9e00-76079a7da6b3', 222, 0, 'mail.routing.key', 'mail.exchange', 0, '2022-11-25 22:08:33', '2022-11-25 22:07:33', '2022-11-25 22:07:33');
INSERT INTO `t_mail_log` VALUES ('12345', 111, 1, 'mail.routing.key', 'mail.exchange', 0, '2022-04-29 15:39:02', '2022-04-29 15:38:02', '2022-04-29 15:38:02');
INSERT INTO `t_mail_log` VALUES ('19025f12-ff0b-47c7-9b53-400742f44fc7', 225, 0, 'mail.routing.key', 'mail.exchange', 0, '2022-11-25 22:19:29', '2022-11-25 22:18:29', '2022-11-25 22:18:29');
INSERT INTO `t_mail_log` VALUES ('1d4ca36f-d48a-4e61-a9c7-002f4ab1d09c', 107, 1, 'mail.routing.key', 'mail.exchange', 1, '2022-04-29 15:02:30', '2022-04-29 14:52:41', '2022-04-29 15:01:30');
INSERT INTO `t_mail_log` VALUES ('304b6106-9a41-43c7-94fc-5fb226ebb7fe', 230, 0, 'mail.routing.key', 'mail.exchange', 0, '2022-12-13 13:20:44', '2022-12-13 13:19:44', '2022-12-13 13:19:44');
INSERT INTO `t_mail_log` VALUES ('334d733c-04fd-444f-a545-a41524bd945e', 223, 0, 'mail.routing.key', 'mail.exchange', 0, '2022-11-25 22:08:47', '2022-11-25 22:07:47', '2022-11-25 22:07:47');
INSERT INTO `t_mail_log` VALUES ('794cb242-eb28-4db8-9f8a-0b43e9d84d96', 112, 1, 'mail.routing.key', 'mail.exchange', 0, '2022-05-11 21:39:05', '2022-05-11 21:38:05', '2022-05-11 21:38:05');
INSERT INTO `t_mail_log` VALUES ('7e0b95d4-cd31-436d-94a4-801caa3c6c12', 226, 0, 'mail.routing.key', 'mail.exchange', 0, '2022-11-25 22:19:33', '2022-11-25 22:18:33', '2022-11-25 22:18:33');
INSERT INTO `t_mail_log` VALUES ('8ffbb532-23f1-49af-83fd-27576844d062', 228, 0, 'mail.routing.key', 'mail.exchange', 0, '2022-12-13 12:05:29', '2022-12-13 12:04:29', '2022-12-13 12:04:29');
INSERT INTO `t_mail_log` VALUES ('9e204ef3-f26c-4565-b6c2-7fd7114d973d', 227, 0, 'mail.routing.key', 'mail.exchange', 0, '2022-11-25 22:20:11', '2022-11-25 22:19:11', '2022-11-25 22:19:11');
INSERT INTO `t_mail_log` VALUES ('de5230f6-579a-423d-b96a-5de945a37657', 224, 0, 'mail.routing.key', 'mail.exchange', 0, '2022-11-25 22:11:28', '2022-11-25 22:10:28', '2022-11-25 22:10:28');
INSERT INTO `t_mail_log` VALUES ('f078850e-8d4f-4db3-8f22-890dbd133f2d', 108, 2, 'mail.routing.key', 'mail.exchange', 4, '2022-04-29 15:02:30', '2022-04-29 14:56:58', '2022-04-29 15:01:30');

-- ----------------------------
-- Table structure for t_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_menu`;
CREATE TABLE `t_menu`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `url` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'url',
  `path` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'path',
  `component` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单名',
  `iconCls` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标',
  `keepAlive` tinyint(1) NULL DEFAULT NULL COMMENT '是否保持激活',
  `requireAuth` tinyint(1) NULL DEFAULT NULL COMMENT '是否要求权限',
  `parentId` int(11) NULL DEFAULT NULL COMMENT '父id',
  `enabled` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `parentId`(`parentId`) USING BTREE,
  CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`parentId`) REFERENCES `t_menu` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_menu
-- ----------------------------
INSERT INTO `t_menu` VALUES (1, '/', NULL, NULL, '所有', NULL, NULL, NULL, NULL, 1);
INSERT INTO `t_menu` VALUES (2, '/', '/home', 'Home', '员工资料', 'fa fa-user-circle-o', NULL, 1, 1, 1);
INSERT INTO `t_menu` VALUES (3, '/', '/home', 'Home', '人事管理', 'fa fa-address-card-o', NULL, 1, 1, 1);
INSERT INTO `t_menu` VALUES (4, '/', '/home', 'Home', '薪资管理', 'fa fa-money', NULL, 1, 1, 1);
INSERT INTO `t_menu` VALUES (5, '/', '/home', 'Home', '统计管理', 'fa fa-bar-chart', NULL, 1, 1, 1);
INSERT INTO `t_menu` VALUES (6, '/', '/home', 'Home', '系统管理', 'fa fa-windows', NULL, 1, 1, 1);
INSERT INTO `t_menu` VALUES (7, '/employee/basic/**', '/emp/basic', 'EmpBasic', '基本资料', NULL, NULL, 1, 2, 1);
INSERT INTO `t_menu` VALUES (8, '/employee/advanced/**', '/emp/adv', 'EmpAdv', '高级资料', NULL, NULL, 1, 2, 1);
INSERT INTO `t_menu` VALUES (9, '/personnel/emp/**', '/per/emp', 'PerEmp', '员工资料', NULL, NULL, 1, 3, 1);
INSERT INTO `t_menu` VALUES (10, '/personnel/ec/**', '/per/ec', 'PerEc', '员工奖惩', NULL, NULL, 1, 3, 1);
INSERT INTO `t_menu` VALUES (11, '/personnel/train/**', '/per/train', 'PerTrain', '员工培训', NULL, NULL, 1, 3, 1);
INSERT INTO `t_menu` VALUES (12, '/personnel/salary/**', '/per/salary', 'PerSalary', '员工调薪', NULL, NULL, 1, 3, 1);
INSERT INTO `t_menu` VALUES (13, '/personnel/remove/**', '/per/mv', 'PerMv', '员工调动', NULL, NULL, 1, 3, 1);
INSERT INTO `t_menu` VALUES (14, '/salary/sob/**', '/sal/sob', 'SalSob', '工资账套管理', NULL, NULL, 1, 4, 1);
INSERT INTO `t_menu` VALUES (15, '/salary/sobcfg/**', '/sal/sobcfg', 'SalSobCfg', '员工账套设置', NULL, NULL, 1, 4, 1);
INSERT INTO `t_menu` VALUES (16, '/salary/table/**', '/sal/table', 'SalTable', '工资表管理', NULL, NULL, 1, 4, 1);
INSERT INTO `t_menu` VALUES (17, '/salary/month/**', '/sal/month', 'SalMonth', '月末处理', NULL, NULL, 1, 4, 1);
INSERT INTO `t_menu` VALUES (18, '/salary/search/**', '/sal/search', 'SalSearch', '工资表查询', NULL, NULL, 1, 4, 1);
INSERT INTO `t_menu` VALUES (19, '/statistics/all/**', '/sta/all', 'StaAll', '综合信息统计', NULL, NULL, 1, 5, 1);
INSERT INTO `t_menu` VALUES (20, '/statistics/score/**', '/sta/score', 'StaScore', '员工积分统计', NULL, NULL, 1, 5, 1);
INSERT INTO `t_menu` VALUES (21, '/statistics/personnel/**', '/sta/pers', 'StaPers', '人事信息统计', NULL, NULL, 1, 5, 1);
INSERT INTO `t_menu` VALUES (22, '/statistics/recored/**', '/sta/record', 'StaRecord', '人事记录统计', NULL, NULL, 1, 5, 1);
INSERT INTO `t_menu` VALUES (23, '/system/basic/**', '/sys/basic', 'SysBasic', '基础信息设置', NULL, NULL, 1, 6, 1);
INSERT INTO `t_menu` VALUES (24, '/system/cfg/**', '/sys/cfg', 'SysCfg', '系统管理', NULL, NULL, 1, 6, 1);
INSERT INTO `t_menu` VALUES (25, '/system/log/**', '/sys/log', 'SysLog', '操作日志管理', NULL, NULL, 1, 6, 1);
INSERT INTO `t_menu` VALUES (26, '/system/admin/**', '/sys/admin', 'SysAdmin', '操作员管理', NULL, NULL, 1, 6, 1);
INSERT INTO `t_menu` VALUES (27, '/system/data/**', '/sys/data', 'SysData', '备份恢复数据库', NULL, NULL, 1, 6, 1);
INSERT INTO `t_menu` VALUES (28, '/system/init/**', '/sys/init', 'SysInit', '初始化数据库', NULL, NULL, 1, 6, 1);
INSERT INTO `t_menu` VALUES (29, '/', '/home', 'Home', '考勤管理', 'fa fa-user', NULL, 1, 1, 1);
INSERT INTO `t_menu` VALUES (30, '/attendance/rule/**', '/attendance/rule', 'AttendanceRule', '出勤规则', NULL, NULL, 1, 29, 1);
INSERT INTO `t_menu` VALUES (31, '/attendance/personal/**', '/attendance/personal', 'AttendancePersonal', '个人出勤', NULL, NULL, 1, 29, 1);
INSERT INTO `t_menu` VALUES (32, '/attendance/leave/**', '/attendance/leave', 'AttendanceLeave', '请假', NULL, NULL, 1, 29, 1);
INSERT INTO `t_menu` VALUES (33, '/attendance/leaveApply/**', '/attendance/leaveApply', 'AttendanceLeaveApply', '请假申请', NULL, NULL, 1, 29, 1);
INSERT INTO `t_menu` VALUES (34, '/attendance/appealManager/**', '/attendance/appealManager', 'AttendanceAppealManager', '申诉管理', NULL, NULL, 1, 29, 1);
INSERT INTO `t_menu` VALUES (35, '/attendance/appealPersonalr/**', '/attendance/appealPersonal', 'AttendanceAppealPersonal', '个人申诉', NULL, NULL, 1, 29, 1);
INSERT INTO `t_menu` VALUES (36, '/attendance/attendanceAll/**', '/attendance/attendanceAll', 'AttendanceAll', '考勤月报表', NULL, NULL, 1, 29, 1);

-- ----------------------------
-- Table structure for t_menu_role
-- ----------------------------
DROP TABLE IF EXISTS `t_menu_role`;
CREATE TABLE `t_menu_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `mid` int(11) NULL DEFAULT NULL COMMENT '菜单id',
  `rid` int(11) NULL DEFAULT NULL COMMENT '权限id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `mid`(`mid`) USING BTREE,
  INDEX `rid`(`rid`) USING BTREE,
  CONSTRAINT `t_menu_role_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `t_menu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `t_menu_role_ibfk_2` FOREIGN KEY (`rid`) REFERENCES `t_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 716 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_menu_role
-- ----------------------------
INSERT INTO `t_menu_role` VALUES (352, 7, 4);
INSERT INTO `t_menu_role` VALUES (353, 8, 4);
INSERT INTO `t_menu_role` VALUES (354, 11, 4);
INSERT INTO `t_menu_role` VALUES (591, 7, 8);
INSERT INTO `t_menu_role` VALUES (592, 8, 8);
INSERT INTO `t_menu_role` VALUES (593, 9, 8);
INSERT INTO `t_menu_role` VALUES (594, 10, 8);
INSERT INTO `t_menu_role` VALUES (595, 11, 8);
INSERT INTO `t_menu_role` VALUES (596, 12, 8);
INSERT INTO `t_menu_role` VALUES (597, 13, 8);
INSERT INTO `t_menu_role` VALUES (598, 14, 8);
INSERT INTO `t_menu_role` VALUES (599, 15, 8);
INSERT INTO `t_menu_role` VALUES (600, 16, 8);
INSERT INTO `t_menu_role` VALUES (601, 17, 8);
INSERT INTO `t_menu_role` VALUES (602, 18, 8);
INSERT INTO `t_menu_role` VALUES (603, 19, 8);
INSERT INTO `t_menu_role` VALUES (604, 20, 8);
INSERT INTO `t_menu_role` VALUES (605, 21, 8);
INSERT INTO `t_menu_role` VALUES (606, 22, 8);
INSERT INTO `t_menu_role` VALUES (607, 23, 8);
INSERT INTO `t_menu_role` VALUES (608, 24, 8);
INSERT INTO `t_menu_role` VALUES (609, 25, 8);
INSERT INTO `t_menu_role` VALUES (610, 26, 8);
INSERT INTO `t_menu_role` VALUES (611, 27, 8);
INSERT INTO `t_menu_role` VALUES (612, 28, 8);
INSERT INTO `t_menu_role` VALUES (613, 30, 8);
INSERT INTO `t_menu_role` VALUES (614, 31, 8);
INSERT INTO `t_menu_role` VALUES (615, 32, 8);
INSERT INTO `t_menu_role` VALUES (616, 33, 8);
INSERT INTO `t_menu_role` VALUES (617, 34, 8);
INSERT INTO `t_menu_role` VALUES (618, 35, 8);
INSERT INTO `t_menu_role` VALUES (619, 36, 8);
INSERT INTO `t_menu_role` VALUES (627, 14, 5);
INSERT INTO `t_menu_role` VALUES (628, 15, 5);
INSERT INTO `t_menu_role` VALUES (629, 16, 5);
INSERT INTO `t_menu_role` VALUES (630, 17, 5);
INSERT INTO `t_menu_role` VALUES (631, 18, 5);
INSERT INTO `t_menu_role` VALUES (632, 19, 5);
INSERT INTO `t_menu_role` VALUES (633, 20, 5);
INSERT INTO `t_menu_role` VALUES (634, 21, 5);
INSERT INTO `t_menu_role` VALUES (635, 22, 5);
INSERT INTO `t_menu_role` VALUES (647, 18, 9);
INSERT INTO `t_menu_role` VALUES (648, 19, 9);
INSERT INTO `t_menu_role` VALUES (649, 20, 9);
INSERT INTO `t_menu_role` VALUES (650, 31, 9);
INSERT INTO `t_menu_role` VALUES (651, 32, 9);
INSERT INTO `t_menu_role` VALUES (652, 35, 9);
INSERT INTO `t_menu_role` VALUES (667, 7, 6);
INSERT INTO `t_menu_role` VALUES (668, 8, 6);
INSERT INTO `t_menu_role` VALUES (669, 9, 6);
INSERT INTO `t_menu_role` VALUES (670, 10, 6);
INSERT INTO `t_menu_role` VALUES (671, 11, 6);
INSERT INTO `t_menu_role` VALUES (672, 12, 6);
INSERT INTO `t_menu_role` VALUES (673, 13, 6);
INSERT INTO `t_menu_role` VALUES (674, 14, 6);
INSERT INTO `t_menu_role` VALUES (675, 15, 6);
INSERT INTO `t_menu_role` VALUES (676, 16, 6);
INSERT INTO `t_menu_role` VALUES (677, 17, 6);
INSERT INTO `t_menu_role` VALUES (678, 18, 6);
INSERT INTO `t_menu_role` VALUES (679, 19, 6);
INSERT INTO `t_menu_role` VALUES (680, 20, 6);
INSERT INTO `t_menu_role` VALUES (681, 21, 6);
INSERT INTO `t_menu_role` VALUES (682, 22, 6);
INSERT INTO `t_menu_role` VALUES (683, 23, 6);
INSERT INTO `t_menu_role` VALUES (684, 24, 6);
INSERT INTO `t_menu_role` VALUES (685, 25, 6);
INSERT INTO `t_menu_role` VALUES (686, 26, 6);
INSERT INTO `t_menu_role` VALUES (687, 27, 6);
INSERT INTO `t_menu_role` VALUES (688, 28, 6);
INSERT INTO `t_menu_role` VALUES (689, 30, 6);
INSERT INTO `t_menu_role` VALUES (690, 36, 6);
INSERT INTO `t_menu_role` VALUES (691, 7, 1);
INSERT INTO `t_menu_role` VALUES (692, 8, 1);
INSERT INTO `t_menu_role` VALUES (693, 23, 1);
INSERT INTO `t_menu_role` VALUES (694, 24, 1);
INSERT INTO `t_menu_role` VALUES (695, 25, 1);
INSERT INTO `t_menu_role` VALUES (696, 26, 1);
INSERT INTO `t_menu_role` VALUES (697, 27, 1);
INSERT INTO `t_menu_role` VALUES (698, 28, 1);
INSERT INTO `t_menu_role` VALUES (699, 7, 2);
INSERT INTO `t_menu_role` VALUES (700, 8, 2);
INSERT INTO `t_menu_role` VALUES (701, 9, 2);
INSERT INTO `t_menu_role` VALUES (702, 10, 2);
INSERT INTO `t_menu_role` VALUES (703, 12, 2);
INSERT INTO `t_menu_role` VALUES (704, 13, 2);
INSERT INTO `t_menu_role` VALUES (705, 19, 2);
INSERT INTO `t_menu_role` VALUES (706, 20, 2);
INSERT INTO `t_menu_role` VALUES (707, 21, 2);
INSERT INTO `t_menu_role` VALUES (708, 22, 2);
INSERT INTO `t_menu_role` VALUES (709, 23, 2);
INSERT INTO `t_menu_role` VALUES (710, 31, 2);
INSERT INTO `t_menu_role` VALUES (711, 32, 2);
INSERT INTO `t_menu_role` VALUES (712, 33, 2);
INSERT INTO `t_menu_role` VALUES (713, 34, 2);
INSERT INTO `t_menu_role` VALUES (714, 35, 2);
INSERT INTO `t_menu_role` VALUES (715, 36, 2);

-- ----------------------------
-- Table structure for t_nation
-- ----------------------------
DROP TABLE IF EXISTS `t_nation`;
CREATE TABLE `t_nation`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '民族',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_nation
-- ----------------------------
INSERT INTO `t_nation` VALUES (1, '汉族');
INSERT INTO `t_nation` VALUES (2, '蒙古族');
INSERT INTO `t_nation` VALUES (3, '回族');
INSERT INTO `t_nation` VALUES (4, '藏族');
INSERT INTO `t_nation` VALUES (5, '维吾尔族');
INSERT INTO `t_nation` VALUES (6, '苗族');
INSERT INTO `t_nation` VALUES (7, '彝族');
INSERT INTO `t_nation` VALUES (8, '壮族');
INSERT INTO `t_nation` VALUES (9, '布依族');
INSERT INTO `t_nation` VALUES (10, '朝鲜族');
INSERT INTO `t_nation` VALUES (11, '满族');
INSERT INTO `t_nation` VALUES (12, '侗族');
INSERT INTO `t_nation` VALUES (13, '瑶族');
INSERT INTO `t_nation` VALUES (14, '白族');
INSERT INTO `t_nation` VALUES (15, '土家族');
INSERT INTO `t_nation` VALUES (16, '哈尼族');
INSERT INTO `t_nation` VALUES (17, '哈萨克族');
INSERT INTO `t_nation` VALUES (18, '傣族');
INSERT INTO `t_nation` VALUES (19, '黎族');
INSERT INTO `t_nation` VALUES (20, '傈僳族');
INSERT INTO `t_nation` VALUES (21, '佤族');
INSERT INTO `t_nation` VALUES (22, '畲族');
INSERT INTO `t_nation` VALUES (23, '高山族');
INSERT INTO `t_nation` VALUES (24, '拉祜族');
INSERT INTO `t_nation` VALUES (25, '水族');
INSERT INTO `t_nation` VALUES (26, '东乡族');
INSERT INTO `t_nation` VALUES (27, '纳西族');
INSERT INTO `t_nation` VALUES (28, '景颇族');
INSERT INTO `t_nation` VALUES (29, '柯尔克孜族');
INSERT INTO `t_nation` VALUES (30, '土族');
INSERT INTO `t_nation` VALUES (31, '达斡尔族');
INSERT INTO `t_nation` VALUES (32, '仫佬族');
INSERT INTO `t_nation` VALUES (33, '羌族');
INSERT INTO `t_nation` VALUES (34, '布朗族');
INSERT INTO `t_nation` VALUES (35, '撒拉族');
INSERT INTO `t_nation` VALUES (36, '毛难族');
INSERT INTO `t_nation` VALUES (37, '仡佬族');
INSERT INTO `t_nation` VALUES (38, '锡伯族');
INSERT INTO `t_nation` VALUES (39, '阿昌族');
INSERT INTO `t_nation` VALUES (40, '普米族');
INSERT INTO `t_nation` VALUES (41, '塔吉克族');
INSERT INTO `t_nation` VALUES (42, '怒族');
INSERT INTO `t_nation` VALUES (43, '乌孜别克族');
INSERT INTO `t_nation` VALUES (44, '俄罗斯族');
INSERT INTO `t_nation` VALUES (45, '鄂温克族');
INSERT INTO `t_nation` VALUES (46, '崩龙族');
INSERT INTO `t_nation` VALUES (47, '保安族');
INSERT INTO `t_nation` VALUES (48, '裕固族');
INSERT INTO `t_nation` VALUES (49, '京族');
INSERT INTO `t_nation` VALUES (50, '塔塔尔族');
INSERT INTO `t_nation` VALUES (51, '独龙族');
INSERT INTO `t_nation` VALUES (52, '鄂伦春族');
INSERT INTO `t_nation` VALUES (53, '赫哲族');
INSERT INTO `t_nation` VALUES (54, '门巴族');
INSERT INTO `t_nation` VALUES (55, '珞巴族');
INSERT INTO `t_nation` VALUES (56, '基诺族');

-- ----------------------------
-- Table structure for t_oplog
-- ----------------------------
DROP TABLE IF EXISTS `t_oplog`;
CREATE TABLE `t_oplog`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `addDate` date NULL DEFAULT NULL COMMENT '添加日期',
  `operate` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作内容',
  `adminid` int(11) NULL DEFAULT NULL COMMENT '操作员ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `adminid`(`adminid`) USING BTREE,
  CONSTRAINT `t_oplog_ibfk_1` FOREIGN KEY (`adminid`) REFERENCES `t_admin` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_oplog
-- ----------------------------

-- ----------------------------
-- Table structure for t_politics_status
-- ----------------------------
DROP TABLE IF EXISTS `t_politics_status`;
CREATE TABLE `t_politics_status`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '政治面貌',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_politics_status
-- ----------------------------
INSERT INTO `t_politics_status` VALUES (1, '中共党员');
INSERT INTO `t_politics_status` VALUES (2, '中共预备党员');
INSERT INTO `t_politics_status` VALUES (3, '共青团员');
INSERT INTO `t_politics_status` VALUES (4, '民革党员');
INSERT INTO `t_politics_status` VALUES (5, '民盟盟员');
INSERT INTO `t_politics_status` VALUES (6, '民建会员');
INSERT INTO `t_politics_status` VALUES (7, '民进会员');
INSERT INTO `t_politics_status` VALUES (8, '农工党党员');
INSERT INTO `t_politics_status` VALUES (9, '致公党党员');
INSERT INTO `t_politics_status` VALUES (10, '九三学社社员');
INSERT INTO `t_politics_status` VALUES (11, '台盟盟员');
INSERT INTO `t_politics_status` VALUES (12, '无党派民主人士');
INSERT INTO `t_politics_status` VALUES (13, '普通公民');

-- ----------------------------
-- Table structure for t_position
-- ----------------------------
DROP TABLE IF EXISTS `t_position`;
CREATE TABLE `t_position`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '职位',
  `createDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `enabled` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_position
-- ----------------------------
INSERT INTO `t_position` VALUES (1, '技术总监', '2020-03-31 16:20:34', 1);
INSERT INTO `t_position` VALUES (2, '运营总监', '2020-03-31 16:20:34', 1);
INSERT INTO `t_position` VALUES (3, '市场总监', '2020-03-31 16:20:34', 1);
INSERT INTO `t_position` VALUES (4, '研发工程师', '2020-03-31 16:20:34', 1);
INSERT INTO `t_position` VALUES (5, '运维工程师', '2020-03-31 16:20:34', 1);

-- ----------------------------
-- Table structure for t_role
-- ----------------------------
DROP TABLE IF EXISTS `t_role`;
CREATE TABLE `t_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名称',
  `nameZh` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_role
-- ----------------------------
INSERT INTO `t_role` VALUES (1, 'ROLE_manager', '部门经理');
INSERT INTO `t_role` VALUES (2, 'ROLE_personnel', '人事专员');
INSERT INTO `t_role` VALUES (4, 'ROLE_train', '培训主管');
INSERT INTO `t_role` VALUES (5, 'ROLE_performance', '薪酬绩效主管');
INSERT INTO `t_role` VALUES (6, 'ROLE_admin', '系统管理员');
INSERT INTO `t_role` VALUES (8, 'ROLE_test', '测试角色');
INSERT INTO `t_role` VALUES (9, 'ROLE_common', '普通员工');

-- ----------------------------
-- Table structure for t_salary
-- ----------------------------
DROP TABLE IF EXISTS `t_salary`;
CREATE TABLE `t_salary`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `basicSalary` int(11) NULL DEFAULT NULL COMMENT '基本工资',
  `bonus` int(11) NULL DEFAULT NULL COMMENT '奖金',
  `lunchSalary` int(11) NULL DEFAULT NULL COMMENT '午餐补助',
  `trafficSalary` int(11) NULL DEFAULT NULL COMMENT '交通补助',
  `allSalary` int(11) NULL DEFAULT NULL COMMENT '应发工资',
  `pensionBase` int(11) NULL DEFAULT NULL COMMENT '养老金基数',
  `pensionPer` float NULL DEFAULT NULL COMMENT '养老金比率',
  `createDate` timestamp NULL DEFAULT NULL COMMENT '启用时间',
  `medicalBase` int(11) NULL DEFAULT NULL COMMENT '医疗基数',
  `medicalPer` float NULL DEFAULT NULL COMMENT '医疗保险比率',
  `accumulationFundBase` int(11) NULL DEFAULT NULL COMMENT '公积金基数',
  `accumulationFundPer` float NULL DEFAULT NULL COMMENT '公积金比率',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_salary
-- ----------------------------
INSERT INTO `t_salary` VALUES (1, 8000, 500, 800, 400, NULL, 1000, 0.06, '2018-01-24 00:00:00', 1000, 0.06, 1000, 0.06, '市场部工资账套');
INSERT INTO `t_salary` VALUES (2, 3000, 500, 500, 500, NULL, 1800, 0.06, '2018-01-01 00:00:00', 2200, 0.06, 3200, 0.06, '人事部工资账套');
INSERT INTO `t_salary` VALUES (3, 9000, 500, 1000, 1000, NULL, 3000, 0.06, '2018-01-25 00:00:00', 3000, 0.06, 3000, 0.06, '运维部工资账套');
INSERT INTO `t_salary` VALUES (4, 5000, 500, 500, 500, NULL, 500, 0.06, '2020-04-10 14:15:45', 500, 0.06, 500, 0.06, '财务部工资账套');
INSERT INTO `t_salary` VALUES (6, 1000, 230, 230, 2330, NULL, 230, 1.2, '2022-05-12 15:31:04', 230, 0.2, 230, 0.2, 'test2');

-- ----------------------------
-- Table structure for t_salary_adjust
-- ----------------------------
DROP TABLE IF EXISTS `t_salary_adjust`;
CREATE TABLE `t_salary_adjust`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `eid` int(11) NULL DEFAULT NULL COMMENT '员工ID',
  `asDate` date NULL DEFAULT NULL COMMENT '调薪日期',
  `beforeSalary` int(11) NULL DEFAULT NULL COMMENT '调前薪资',
  `afterSalary` int(11) NULL DEFAULT NULL COMMENT '调后薪资',
  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '调薪原因',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `eid`(`eid`) USING BTREE,
  CONSTRAINT `t_salary_adjust_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `t_employee` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_salary_adjust
-- ----------------------------

-- ----------------------------
-- Table structure for t_sys_msg
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_msg`;
CREATE TABLE `t_sys_msg`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `mid` int(11) NULL DEFAULT NULL COMMENT '消息id',
  `type` int(11) NULL DEFAULT 0 COMMENT '0表示群发消息',
  `adminid` int(11) NULL DEFAULT NULL COMMENT '这条消息是给谁的',
  `state` int(11) NULL DEFAULT 0 COMMENT '0 未读 1 已读',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `adminid`(`adminid`) USING BTREE,
  INDEX `mid`(`mid`) USING BTREE,
  CONSTRAINT `t_sys_msg_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `t_sys_msg_content` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `t_sys_msg_ibfk_2` FOREIGN KEY (`adminid`) REFERENCES `t_admin` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_sys_msg
-- ----------------------------
INSERT INTO `t_sys_msg` VALUES (1, 1, 0, 1, 1);

-- ----------------------------
-- Table structure for t_sys_msg_content
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_msg_content`;
CREATE TABLE `t_sys_msg_content`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `title` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标题',
  `message` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '内容',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_sys_msg_content
-- ----------------------------
INSERT INTO `t_sys_msg_content` VALUES (1, '通知标题1', '通知内容1', '2020-03-31 16:20:34');
INSERT INTO `t_sys_msg_content` VALUES (2, '通知标题2', '通知内容2', '2020-03-31 16:20:34');
INSERT INTO `t_sys_msg_content` VALUES (3, '通知标题3', '通知内容3', '2020-03-31 16:20:34');

-- ----------------------------
-- Procedure structure for addDep
-- ----------------------------
DROP PROCEDURE IF EXISTS `addDep`;
delimiter ;;
CREATE PROCEDURE `addDep`(in depName varchar(32),in parentId int,in enabled boolean,out result int,out result2 int)
begin
  declare did int;
  declare pDepPath varchar(64);
  insert into t_department set name=depName,parentId=parentId,enabled=enabled;
  select row_count() into result;
  select last_insert_id() into did;
  set result2=did;
  select depPath into pDepPath from t_department where id=parentId;
  update t_department set depPath=concat(pDepPath,'.',did) where id=did;
  update t_department set isParent=true where id=parentId;
end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for deleteDep
-- ----------------------------
DROP PROCEDURE IF EXISTS `deleteDep`;
delimiter ;;
CREATE PROCEDURE `deleteDep`(in did int,out result int)
begin
  declare ecount int;
  declare pid int;
  declare pcount int;
  declare a int;
  select count(*) into a from t_department where id=did and isParent=false;
  if a=0 then set result=-2;
  else
  select count(*) into ecount from t_employee where departmentId=did;
  if ecount>0 then set result=-1;
  else 
  select parentId into pid from t_department where id=did;
  delete from t_department where id=did and isParent=false;
  select row_count() into result;
  select count(*) into pcount from t_department where parentId=pid;
  if pcount=0 then update t_department set isParent=false where id=pid;
  end if;
  end if;
  end if;
end
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
