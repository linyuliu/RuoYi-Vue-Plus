<#if featureFlags.social.enabled!true>
package ${projectMetadata.groupId}.common.social.config.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * Social 配置属性
 *
 * @author ${projectMetadata.author!"thiszhc"}
 */
@Data
@Component
@ConfigurationProperties(prefix = "justauth")
@ConditionalOnProperty(value = "social.enabled", havingValue = "true", matchIfMissing = true)
public class SocialProperties {

    /**
     * 授权类型
     */
    private Map<String, SocialLoginConfigProperties> type;

}

<#else>
// 社交登录功能已禁用，此配置类不会被生成
</#if>