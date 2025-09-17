<#if featureFlags.translation.enabled!true>
package ${projectMetadata.groupId}.common.translation.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import ${projectMetadata.groupId}.common.translation.annotation.TranslationType;
import ${projectMetadata.groupId}.common.translation.core.TranslationInterface;
import ${projectMetadata.groupId}.common.translation.core.handler.TranslationBeanSerializerModifier;
import ${projectMetadata.groupId}.common.translation.core.handler.TranslationHandler;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.AutoConfiguration;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 翻译模块配置类
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@Slf4j
@AutoConfiguration
@ConditionalOnProperty(value = "translation.enabled", havingValue = "true", matchIfMissing = true)
public class TranslationConfig {

    @Autowired
    private List<TranslationInterface<?>> list;

    @Autowired
    private ObjectMapper objectMapper;

    @PostConstruct
    public void init() {
        Map<String, TranslationInterface<?>> map = new HashMap<>(list.size());
        for (TranslationInterface<?> trans : list) {
            if (trans.getClass().isAnnotationPresent(TranslationType.class)) {
                TranslationType annotation = trans.getClass().getAnnotation(TranslationType.class);
                map.put(annotation.type(), trans);
            } else {
                log.warn(trans.getClass().getName() + " 翻译实现类未标注 TranslationType 注解!");
            }
        }
        TranslationHandler.TRANSLATION_MAPPER.putAll(map);
        // 设置 Bean 序列化修改器
        objectMapper.setSerializerFactory(
            objectMapper.getSerializerFactory()
                .withSerializerModifier(new TranslationBeanSerializerModifier()));
    }

}

<#else>
// 翻译功能已禁用，此配置类不会被生成
</#if>