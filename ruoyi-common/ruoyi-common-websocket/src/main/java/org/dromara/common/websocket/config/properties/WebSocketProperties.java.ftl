<#if featureFlags.websocketproperties.java.enabled!true>
package ${projectMetadata.groupId}.common.websocket.config.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * WebSocket 配置项
 *
 * @author ${projectMetadata.author!"zendwang"}
 */
@ConfigurationProperties("websocket")
@Data
@ConditionalOnProperty(value = "websocketproperties.java.enabled", havingValue = "true", matchIfMissing = true)
public class WebSocketProperties {

    private Boolean enabled;

    /**
     * 路径
     */
    private String path;

    /**
     *  设置访问源地址
     */
    private String allowedOrigins;
}

<#else>
// websocketproperties.java功能已禁用，此配置类不会被生成
</#if>