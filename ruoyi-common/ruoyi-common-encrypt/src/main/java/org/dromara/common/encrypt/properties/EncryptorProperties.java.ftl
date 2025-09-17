<#if featureFlags.apiDecrypt.enabled!true>
package ${projectMetadata.groupId}.common.encrypt.properties;

import ${projectMetadata.groupId}.common.encrypt.enumd.AlgorithmType;
import ${projectMetadata.groupId}.common.encrypt.enumd.EncodeType;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 加解密属性配置类
 *
 * @author ${projectMetadata.author!"老马"}
 * @version 4.6.0
 */
@Data
@ConfigurationProperties(prefix = "mybatis-encryptor")
@ConditionalOnProperty(value = "apiDecrypt.enabled", havingValue = "true", matchIfMissing = true)
public class EncryptorProperties {

    /**
     * 过滤开关
     */
    private Boolean enable;

    /**
     * 默认算法
     */
    private AlgorithmType algorithm;

    /**
     * 安全秘钥
     */
    private String password;

    /**
     * 公钥
     */
    private String publicKey;

    /**
     * 私钥
     */
    private String privateKey;

    /**
     * 编码方式，base64/hex
     */
    private EncodeType encode;

}

<#else>
// API加密功能已禁用，此配置类不会被生成
</#if>