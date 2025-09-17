package ${projectMetadata.groupId}.common.encrypt.enumd;

/**
 * 编码类型
 *
 * @author ${projectMetadata.author!"老马"}
 * @version 4.6.0
 */
public enum EncodeType {

    /**
     * 默认使用yml配置
     */
    DEFAULT,

    /**
     * base64编码
     */
    BASE64,

    /**
     * 16进制编码
     */
    HEX;

}
