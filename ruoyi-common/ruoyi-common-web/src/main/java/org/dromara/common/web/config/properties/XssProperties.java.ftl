<#if featureFlags.xss.enabled!true>
package ${projectMetadata.groupId}.common.web.config.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.ArrayList;
import java.util.List;

/**
 * xss过滤 配置属性
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@Data
@ConfigurationProperties(prefix = "xss")
@ConditionalOnProperty(value = "xss.enabled", havingValue = "true", matchIfMissing = true)
public class XssProperties {

    /**
     * Xss开关
     */
    private Boolean enabled;

    /**
     * 排除路径
     */
    private List<String> excludeUrls = new ArrayList<>();

}

<#else>
// XSS防护功能已禁用，此配置类不会被生成
</#if>