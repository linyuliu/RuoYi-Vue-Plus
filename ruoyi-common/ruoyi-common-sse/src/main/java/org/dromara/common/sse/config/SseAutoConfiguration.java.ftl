package ${projectMetadata.groupId}.common.sse.config;

import ${projectMetadata.groupId}.common.sse.controller.SseController;
import ${projectMetadata.groupId}.common.sse.core.SseEmitterManager;
import ${projectMetadata.groupId}.common.sse.listener.SseTopicListener;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;

/**
 * SSE 自动装配
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@AutoConfiguration
@ConditionalOnProperty(value = "sse.enabled", havingValue = "true", matchIfMissing = false)
@EnableConfigurationProperties(SseProperties.class)
<#if featureFlags.sse.enabled>
public class SseAutoConfiguration {

    @Bean
    public SseEmitterManager sseEmitterManager() {
        return new SseEmitterManager();
    }

    @Bean
    public SseTopicListener sseTopicListener() {
        return new SseTopicListener();
    }

    @Bean
    public SseController sseController(SseEmitterManager sseEmitterManager) {
        return new SseController(sseEmitterManager);
    }

}
<#else>
public class SseAutoConfiguration {
    // SSE 功能已禁用，配置类保留但为空实现
}
</#if>