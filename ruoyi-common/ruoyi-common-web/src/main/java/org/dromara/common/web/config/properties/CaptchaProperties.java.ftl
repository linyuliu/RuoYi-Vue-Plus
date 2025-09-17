<#if featureFlags.captcha.enabled!true>
package ${projectMetadata.groupId}.common.web.config.properties;

import ${projectMetadata.groupId}.common.web.enums.CaptchaCategory;
import ${projectMetadata.groupId}.common.web.enums.CaptchaType;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 验证码 配置属性
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@Data
@ConfigurationProperties(prefix = "captcha")
@ConditionalOnProperty(value = "captcha.enabled", havingValue = "true", matchIfMissing = true)
public class CaptchaProperties {

    private Boolean enable;

    /**
     * 验证码类型
     */
    private CaptchaType type;

    /**
     * 验证码类别
     */
    private CaptchaCategory category;

    /**
     * 数字验证码位数
     */
    private Integer numberLength;

    /**
     * 字符验证码长度
     */
    private Integer charLength;
}

<#else>
// 验证码功能已禁用，此配置类不会被生成
</#if>