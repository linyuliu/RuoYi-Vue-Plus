<#if featureFlags.sseproperties.java.enabled!true>
package ${projectMetadata.groupId}.common.sse.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * SSE 配置项
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@Data
@ConfigurationProperties("sse")
@ConditionalOnProperty(value = "sseproperties.java.enabled", havingValue = "true", matchIfMissing = true)
public class SseProperties {

    private Boolean enabled;

    /**
     * 路径
     */
    private String path;
}

<#else>
// sseproperties.java功能已禁用，此配置类不会被生成
</#if>