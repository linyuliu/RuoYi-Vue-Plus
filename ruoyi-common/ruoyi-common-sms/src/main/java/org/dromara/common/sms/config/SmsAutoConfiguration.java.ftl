<#if featureFlags.sms.enabled!true>
package ${projectMetadata.groupId}.common.sms.config;

import ${projectMetadata.groupId}.common.sms.core.dao.PlusSmsDao;
import ${projectMetadata.groupId}.common.sms.handler.SmsExceptionHandler;
import ${projectMetadata.groupId}.sms4j.api.dao.SmsDao;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;

/**
 * 短信配置类
 *
 * @author ${projectMetadata.author!"Feng"}
 */
@AutoConfiguration(after = {RedisAutoConfiguration.class})
@ConditionalOnProperty(value = "sms.enabled", havingValue = "true", matchIfMissing = true)
public class SmsAutoConfiguration {

    @Primary
    @Bean
    public SmsDao smsDao() {
        return new PlusSmsDao();
    }

    /**
     * 异常处理器
     */
    @Bean
    public SmsExceptionHandler smsExceptionHandler() {
        return new SmsExceptionHandler();
    }

}

<#else>
// 短信功能已禁用，此配置类不会被生成
</#if>