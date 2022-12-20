package com.xiaoping.server.task;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.xiaoping.server.pojo.Employee;
import com.xiaoping.server.pojo.MailConstants;
import com.xiaoping.server.pojo.MailLog;
import com.xiaoping.server.service.IEmployeeService;
import com.xiaoping.server.service.IMailLogService;
import org.springframework.amqp.rabbit.connection.CorrelationData;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

/**
 * @author 小王造轮子
 * @description 邮件发送定时任务
 * @date 2022/4/29
 */
//@Component
public class MailTask {

    @Autowired
    private IMailLogService mailLogService;
    @Autowired
    private IEmployeeService employeeService;
    @Autowired
    private RabbitTemplate rabbitTemplate;

    /**
     * 邮件发送定时任务
     * 10s执行1次
     */
    @Scheduled(cron = "0/30 * * * * ?")
    public void mailTask(){
        //获取所有投递中的消息 并且重试时间小于当前时间
        List<MailLog> list = mailLogService.list(new QueryWrapper<MailLog>()
                .eq("status", 0).lt("tryTime", LocalDateTime.now()));

        list.forEach(mailLog -> {
            //如果重试次数超过3次，更新状态为投递失败，不能重试
            if (mailLog.getCount()>= MailConstants.MAX_TRY_COUNT){
                mailLogService.update(new UpdateWrapper<MailLog>().set("status",2).eq("msgId",mailLog.getMsgId()));
            }
            //消息的重试次数+1，修改时间为当前时间，重试时间为当前时间加上消息超时时间
            mailLogService.update(new UpdateWrapper<MailLog>().set("count",mailLog.getCount()+1).set("updateTime",
                    LocalDateTime.now()).set("tryTime",LocalDateTime.now().plusMinutes(MailConstants.MSG_TIMEOUT))
                    .eq("msgId",mailLog.getMsgId()));
            //获取员工的id
            Employee emp = employeeService.getEmployee(mailLog.getEid()).get(0);
            //发送消息
            rabbitTemplate.convertAndSend(MailConstants.MAIL_EXCHANGE_NAME,MailConstants.MAIL_ROUTING_KEY_NAME,emp,
                    new CorrelationData(mailLog.getMsgId()));
        });

    }

}
