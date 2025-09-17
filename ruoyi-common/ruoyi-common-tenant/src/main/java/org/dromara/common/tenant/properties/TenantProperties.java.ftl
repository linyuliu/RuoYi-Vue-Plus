<#if featureFlags.tenantproperties.java.enabled!true>
package ${projectMetadata.groupId}.common.tenant.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.List;

/**
 * 租户 配置属性
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@Data
@ConfigurationProperties(prefix = "tenant")
@ConditionalOnProperty(value = "tenantproperties.java.enabled", havingValue = "true", matchIfMissing = true)
public class TenantProperties {

    /**
     * 是否启用
     */
    private Boolean enable;

    /**
     * 排除表
     */
    private List<String> excludes;

}

<#else>
// tenantproperties.java功能已禁用，此配置类不会被生成
</#if>