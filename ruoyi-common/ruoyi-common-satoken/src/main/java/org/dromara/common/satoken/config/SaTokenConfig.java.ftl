<#if featureFlags.satoken.enabled!true>
package ${projectMetadata.groupId}.common.satoken.config;

import cn.dev33.satoken.dao.SaTokenDao;
import cn.dev33.satoken.jwt.StpLogicJwtForSimple;
import cn.dev33.satoken.stp.StpInterface;
import cn.dev33.satoken.stp.StpLogic;
import ${projectMetadata.groupId}.common.core.factory.YmlPropertySourceFactory;
import ${projectMetadata.groupId}.common.satoken.core.dao.PlusSaTokenDao;
import ${projectMetadata.groupId}.common.satoken.core.service.SaPermissionImpl;
import ${projectMetadata.groupId}.common.satoken.handler.SaTokenExceptionHandler;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.PropertySource;

/**
 * sa-token 配置
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@AutoConfiguration
@PropertySource(value = "classpath:common-satoken.yml", factory = YmlPropertySourceFactory.class)
@ConditionalOnProperty(value = "satoken.enabled", havingValue = "true", matchIfMissing = true)
public class SaTokenConfig {

    @Bean
    public StpLogic getStpLogicJwt() {
        // Sa-Token 整合 jwt (简单模式)
        return new StpLogicJwtForSimple();
    }

    /**
     * 权限接口实现(使用bean注入方便用户替换)
     */
    @Bean
    public StpInterface stpInterface() {
        return new SaPermissionImpl();
    }

    /**
     * 自定义dao层存储
     */
    @Bean
    public SaTokenDao saTokenDao() {
        return new PlusSaTokenDao();
    }

    /**
     * 异常处理器
     */
    @Bean
    public SaTokenExceptionHandler saTokenExceptionHandler() {
        return new SaTokenExceptionHandler();
    }

}

<#else>
// SA-Token功能已禁用，此配置类不会被生成
</#if>