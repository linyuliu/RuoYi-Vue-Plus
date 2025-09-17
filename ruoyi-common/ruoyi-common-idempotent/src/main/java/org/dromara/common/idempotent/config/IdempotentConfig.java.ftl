<#if featureFlags.idempotent.enabled!true>
package ${projectMetadata.groupId}.common.idempotent.config;

import ${projectMetadata.groupId}.common.idempotent.aspectj.RepeatSubmitAspect;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.data.redis.connection.RedisConfiguration;

/**
 * 幂等功能配置
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@AutoConfiguration(after = RedisConfiguration.class)
@ConditionalOnProperty(value = "idempotent.enabled", havingValue = "true", matchIfMissing = true)
public class IdempotentConfig {

    @Bean
    public RepeatSubmitAspect repeatSubmitAspect() {
        return new RepeatSubmitAspect();
    }

}

<#else>
// 幂等性功能已禁用，此配置类不会被生成
</#if>