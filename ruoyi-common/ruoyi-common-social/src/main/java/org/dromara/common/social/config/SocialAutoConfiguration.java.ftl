<#if featureFlags.social.enabled!true>
package ${projectMetadata.groupId}.common.social.config;

import me.zhyd.oauth.cache.AuthStateCache;
import ${projectMetadata.groupId}.common.social.config.properties.SocialProperties;
import ${projectMetadata.groupId}.common.social.utils.AuthRedisStateCache;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;

/**
 * Social 配置属性
 * @author ${projectMetadata.author!"thiszhc"}
 */
@AutoConfiguration
@EnableConfigurationProperties(SocialProperties.class)
@ConditionalOnProperty(value = "social.enabled", havingValue = "true", matchIfMissing = true)
public class SocialAutoConfiguration {

    @Bean
    public AuthStateCache authStateCache() {
        return new AuthRedisStateCache();
    }

}

<#else>
// 社交登录功能已禁用，此配置类不会被生成
</#if>