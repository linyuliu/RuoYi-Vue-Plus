<#if featureFlags.workflow.enabled!true>
package ${projectMetadata.groupId}.workflow.config;

import ${projectMetadata.groupId}.workflow.common.ConditionalOnEnable;
import org.springframework.context.annotation.Configuration;

/**
 * warmFlow配置
 *
 * @author ${projectMetadata.author!"may"}
 */
@ConditionalOnEnable
@Configuration
@ConditionalOnProperty(value = "workflow.enabled", havingValue = "true", matchIfMissing = true)
public class WarmFlowConfig {

}


<#else>
// 工作流功能已禁用，此配置类不会被生成
</#if>