package com.xiaoping.server.converter;

import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * @author 小王造轮子
 * @description 日期转换
 * @date 2022/4/25
 */
@Component
public class DateConverter implements Converter<String, LocalDate> {
    @Override
    public LocalDate convert(String source) {
        try{
            return LocalDate.parse(source, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
}
