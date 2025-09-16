package ${projectMetadata.groupId}.common.web.config;

import jakarta.servlet.DispatcherType;
import ${projectMetadata.groupId}.common.web.config.properties.XssProperties;
import ${projectMetadata.groupId}.common.web.filter.RepeatableFilter;
<#if featureFlags.xss.enabled>
import ${projectMetadata.groupId}.common.web.filter.XssFilter;
</#if>
import org.springframework.boot.autoconfigure.AutoConfiguration;
<#if featureFlags.xss.enabled>
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
</#if>
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;

/**
 * Filter配置
 * XSS防护: ${featureFlags.xss.enabled?c}
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@AutoConfiguration
@EnableConfigurationProperties(XssProperties.class)
public class FilterConfig {

<#if featureFlags.xss.enabled>
    @Bean
    @ConditionalOnProperty(value = "xss.enabled", havingValue = "true")
    public FilterRegistrationBean<XssFilter> xssFilterRegistration() {
        FilterRegistrationBean<XssFilter> registration = new FilterRegistrationBean<>();
        registration.setDispatcherTypes(DispatcherType.REQUEST);
        registration.setFilter(new XssFilter());
        registration.addUrlPatterns("/*");
        registration.setName("xssFilter");
        registration.setOrder(FilterRegistrationBean.HIGHEST_PRECEDENCE + 1);
        return registration;
    }
</#if>

    @Bean
    public FilterRegistrationBean<RepeatableFilter> someFilterRegistration() {
        FilterRegistrationBean<RepeatableFilter> registration = new FilterRegistrationBean<>();
        registration.setFilter(new RepeatableFilter());
        registration.addUrlPatterns("/*");
        registration.setName("repeatableFilter");
        registration.setOrder(FilterRegistrationBean.LOWEST_PRECEDENCE);
        return registration;
    }

}