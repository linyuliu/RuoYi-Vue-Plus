<#if featureFlags.monitor.enabled!true>
package ${projectMetadata.groupId}.monitor.admin.config;

import de.codecentric.boot.admin.server.config.EnableAdminServer;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.task.TaskExecutionAutoConfiguration;
import org.springframework.boot.task.ThreadPoolTaskExecutorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

/**
 * springboot-admin server配置类
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@Configuration
@EnableAdminServer
@ConditionalOnProperty(value = "monitor.enabled", havingValue = "true", matchIfMissing = true)
public class AdminServerConfig {

    @Lazy
    @Bean(name = TaskExecutionAutoConfiguration.APPLICATION_TASK_EXECUTOR_BEAN_NAME)
    @ConditionalOnMissingBean(Executor.class)
    public ThreadPoolTaskExecutor applicationTaskExecutor(ThreadPoolTaskExecutorBuilder builder) {
        return builder.build();
    }


}

<#else>
// 监控功能已禁用，此配置类不会被生成
</#if>