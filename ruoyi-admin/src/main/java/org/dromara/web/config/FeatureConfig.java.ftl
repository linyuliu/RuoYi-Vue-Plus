package ${projectMetadata.groupId}.web.config;

<#if featureFlags.sse.enabled>
import org.dromara.common.sse.config.SseAutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * SSE 配置
 * 基于配置文件动态启用
 *
 * @author ${projectMetadata.author!"Generated"}
 */
@Configuration
@ConditionalOnProperty(value = "sse.enabled", havingValue = "true")
@Import(SseAutoConfiguration.class)
public class SseConfig {
    // SSE 自动配置
}
</#if>

<#if featureFlags.websocket.enabled>
import org.dromara.common.websocket.config.WebSocketConfig;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * WebSocket 配置
 * 基于配置文件动态启用
 *
 * @author ${projectMetadata.author!"Generated"}
 */
@Configuration
@ConditionalOnProperty(value = "websocket.enabled", havingValue = "true")
@Import(WebSocketConfig.class)
public class CustomWebSocketConfig {
    // WebSocket 自动配置
}
</#if>

<#if featureFlags.workflow.enabled>
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;

/**
 * 工作流配置
 * 基于配置文件动态启用
 *
 * @author ${projectMetadata.author!"Generated"}
 */
@Configuration
@ConditionalOnProperty(value = "warm-flow.enabled", havingValue = "true")
public class WorkflowConfig {
    // 工作流相关配置将在此处定义
}
</#if>

<#if featureFlags.threadPool.enabled>
import org.dromara.common.core.config.ThreadPoolConfig;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * 线程池配置
 * 基于配置文件动态启用
 *
 * @author ${projectMetadata.author!"Generated"}
 */
@Configuration
@ConditionalOnProperty(prefix = "thread-pool", name = "enabled", havingValue = "true")
@Import(ThreadPoolConfig.class)
public class CustomThreadPoolConfig {
    // 线程池自动配置
}
</#if>

<#if featureFlags.tenant.enabled>
import org.dromara.common.tenant.config.TenantConfig;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * 多租户配置
 * 基于配置文件动态启用
 *
 * @author ${projectMetadata.author!"Generated"}
 */
@Configuration
@ConditionalOnProperty(value = "tenant.enable", havingValue = "true")
@Import(TenantConfig.class)
public class CustomTenantConfig {
    // 多租户自动配置
}
</#if>