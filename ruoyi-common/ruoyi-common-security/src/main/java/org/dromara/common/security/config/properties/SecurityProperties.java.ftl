<#if featureFlags.security.enabled!true>
package ${projectMetadata.groupId}.common.security.config.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Security 配置属性
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@Data
@ConfigurationProperties(prefix = "security")
@ConditionalOnProperty(value = "security.enabled", havingValue = "true", matchIfMissing = true)
public class SecurityProperties {

    /**
     * 排除路径
     */
    private String[] excludes;


}

<#else>
// 权限安全功能已禁用，此配置类不会被生成
</#if>