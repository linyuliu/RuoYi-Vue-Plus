<#if featureFlags.security.enabled!true>
package com.aizuda.snailjob.server.starter.filter;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 权限安全配置
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@Configuration
@ConditionalOnProperty(value = "security.enabled", havingValue = "true", matchIfMissing = true)
public class SecurityConfig {

    @Value("${spring.boot.admin.client.username}")
    private String username;
    @Value("${spring.boot.admin.client.password}")
    private String password;

    @Bean
    public FilterRegistrationBean<ActuatorAuthFilter> actuatorFilterRegistrationBean() {
        FilterRegistrationBean<ActuatorAuthFilter> registrationBean = new FilterRegistrationBean<>();
        registrationBean.setFilter(new ActuatorAuthFilter(username, password));
        registrationBean.addUrlPatterns("/actuator", "/actuator/*");
        return registrationBean;
    }

}

<#else>
// 权限安全功能已禁用，此配置类不会被生成
</#if>