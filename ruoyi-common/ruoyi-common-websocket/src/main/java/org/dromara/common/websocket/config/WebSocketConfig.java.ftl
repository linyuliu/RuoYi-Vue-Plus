package ${projectMetadata.groupId}.common.websocket.config;

<#if featureFlags.websocket.enabled>
import cn.hutool.core.util.StrUtil;
import ${projectMetadata.groupId}.common.websocket.config.properties.WebSocketProperties;
import ${projectMetadata.groupId}.common.websocket.handler.PlusWebSocketHandler;
import ${projectMetadata.groupId}.common.websocket.interceptor.PlusWebSocketInterceptor;
import ${projectMetadata.groupId}.common.websocket.listener.WebSocketTopicListener;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.server.HandshakeInterceptor;

/**
 * WebSocket 配置
 *
 * @author ${projectMetadata.author!"zendwang"}
 */
@AutoConfiguration
@ConditionalOnProperty(value = "websocket.enabled", havingValue = "true")
@EnableConfigurationProperties(WebSocketProperties.class)
@EnableWebSocket
public class WebSocketConfig {

    @Bean
    public WebSocketConfigurer webSocketConfigurer(HandshakeInterceptor handshakeInterceptor,
                                                   WebSocketHandler webSocketHandler, WebSocketProperties webSocketProperties) {
        // 如果WebSocket的路径为空，则设置默认路径为 "${featureFlags.websocket.path!"/websocket"}"
        if (StrUtil.isBlank(webSocketProperties.getPath())) {
            webSocketProperties.setPath("${featureFlags.websocket.path!"/websocket"}");
        }

        // 如果允许跨域访问的地址为空，则设置为 "${featureFlags.websocket.allowedOrigins!"*"}"
        if (StrUtil.isBlank(webSocketProperties.getAllowedOrigins())) {
            webSocketProperties.setAllowedOrigins("${featureFlags.websocket.allowedOrigins!"*"}");
        }

        // 返回一个WebSocketConfigurer对象，用于配置WebSocket
        return registry -> registry
            // 添加WebSocket处理程序和拦截器到指定路径，设置允许的跨域来源
            .addHandler(webSocketHandler, webSocketProperties.getPath())
            .addInterceptors(handshakeInterceptor)
            .setAllowedOrigins(webSocketProperties.getAllowedOrigins());
    }

    @Bean
    public HandshakeInterceptor handshakeInterceptor() {
        return new PlusWebSocketInterceptor();
    }

    @Bean
    public WebSocketHandler webSocketHandler() {
        return new PlusWebSocketHandler();
    }

    @Bean
    public WebSocketTopicListener topicListener() {
        return new WebSocketTopicListener();
    }
}
<#else>
// WebSocket 功能已禁用，此配置类不会被生成
</#if>