package ${projectMetadata.groupId}.common.ratelimiter.config;

<#if featureFlags.rateLimit.enabled!true>
import ${projectMetadata.groupId}.common.ratelimiter.aspectj.RateLimiterAspect;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.data.redis.connection.RedisConfiguration;

/**
 * 限流配置
 *
 * @author ${projectMetadata.author!"guangxin"}
 * @date 2023/1/18
 */
@AutoConfiguration(after = RedisConfiguration.class)
@ConditionalOnProperty(value = "rate-limit.enabled", havingValue = "true", matchIfMissing = true)
public class RateLimiterConfig {

    @Bean
    public RateLimiterAspect rateLimiterAspect() {
        return new RateLimiterAspect();
    }

}
<#else>
// 限流功能已禁用，此配置类不会被生成
</#if>