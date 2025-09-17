<#if featureFlags.i18n.enabled!true>
package ${projectMetadata.groupId}.common.web.config;

import ${projectMetadata.groupId}.common.web.core.I18nLocaleResolver;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.web.servlet.WebMvcAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.LocaleResolver;

/**
 * 国际化配置
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@AutoConfiguration(before = WebMvcAutoConfiguration.class)
@ConditionalOnProperty(value = "i18n.enabled", havingValue = "true", matchIfMissing = true)
public class I18nConfig {

    @Bean
    public LocaleResolver localeResolver() {
        return new I18nLocaleResolver();
    }

}

<#else>
// 国际化功能已禁用，此配置类不会被生成
</#if>