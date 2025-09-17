<#if featureFlags.application.enabled!true>
package ${projectMetadata.groupId}.common.core.config;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.scheduling.annotation.EnableAsync;

/**
 * 程序注解配置
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@AutoConfiguration
@EnableAspectJAutoProxy
@EnableAsync(proxyTargetClass = true)
@ConditionalOnProperty(value = "application.enabled", havingValue = "true", matchIfMissing = true)
public class ApplicationConfig {

}

<#else>
// 应用功能已禁用，此配置类不会被生成
</#if>