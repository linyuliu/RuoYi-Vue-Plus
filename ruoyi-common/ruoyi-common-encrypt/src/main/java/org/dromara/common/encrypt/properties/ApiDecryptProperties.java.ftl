<#if featureFlags.apiDecrypt.enabled!true>
package ${projectMetadata.groupId}.common.encrypt.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * api解密属性配置类
 * @author ${projectMetadata.author!"wdhcr"}
 */
@Data
@ConfigurationProperties(prefix = "api-decrypt")
@ConditionalOnProperty(value = "apiDecrypt.enabled", havingValue = "true", matchIfMissing = true)
public class ApiDecryptProperties {

    /**
     * 加密开关
     */
    private Boolean enabled;

    /**
     * 头部标识
     */
    private String headerFlag;

    /**
     * 响应加密公钥
     */
    private String publicKey;

    /**
     * 请求解密私钥
     */
    private String privateKey;

}

<#else>
// API加密功能已禁用，此配置类不会被生成
</#if>