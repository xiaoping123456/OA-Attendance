package com.xiaoping.server.utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * @author 小王造轮子
 * @description
 * @date 2022/12/9
 */
public class AttendanceUtils {

    public static String dateToHHmm(LocalDateTime date){
        return date.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

}
