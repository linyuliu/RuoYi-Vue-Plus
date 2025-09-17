<#if featureFlags.json.enabled!true>
package ${projectMetadata.groupId}.common.json.config;

import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import lombok.extern.slf4j.Slf4j;
import ${projectMetadata.groupId}.common.json.handler.BigNumberSerializer;
import ${projectMetadata.groupId}.common.json.handler.CustomDateDeserializer;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration;
import org.springframework.context.annotation.Bean;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.TimeZone;

/**
 * jackson 配置
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@Slf4j
@AutoConfiguration(before = JacksonAutoConfiguration.class)
@ConditionalOnProperty(value = "json.enabled", havingValue = "true", matchIfMissing = true)
public class JacksonConfig {

    @Bean
    public Jackson2ObjectMapperBuilderCustomizer customizer() {
        return builder -> {
            // 全局配置序列化返回 JSON 处理
            JavaTimeModule javaTimeModule = new JavaTimeModule();
            javaTimeModule.addSerializer(Long.class, BigNumberSerializer.INSTANCE);
            javaTimeModule.addSerializer(Long.TYPE, BigNumberSerializer.INSTANCE);
            javaTimeModule.addSerializer(BigInteger.class, BigNumberSerializer.INSTANCE);
            javaTimeModule.addSerializer(BigDecimal.class, ToStringSerializer.instance);
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            javaTimeModule.addSerializer(LocalDateTime.class, new LocalDateTimeSerializer(formatter));
            javaTimeModule.addDeserializer(LocalDateTime.class, new LocalDateTimeDeserializer(formatter));
            javaTimeModule.addDeserializer(Date.class, new CustomDateDeserializer());
            builder.modules(javaTimeModule);
            builder.timeZone(TimeZone.getDefault());
            log.info("初始化 jackson 配置");
        };
    }

}

<#else>
// JSON功能已禁用，此配置类不会被生成
</#if>