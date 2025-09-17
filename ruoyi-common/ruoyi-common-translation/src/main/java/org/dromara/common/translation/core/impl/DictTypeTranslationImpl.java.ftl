package ${projectMetadata.groupId}.common.translation.core.impl;

import ${projectMetadata.groupId}.common.core.service.DictService;
import ${projectMetadata.groupId}.common.core.utils.StringUtils;
import ${projectMetadata.groupId}.common.translation.annotation.TranslationType;
import ${projectMetadata.groupId}.common.translation.constant.TransConstant;
import ${projectMetadata.groupId}.common.translation.core.TranslationInterface;
import lombok.AllArgsConstructor;

/**
 * 字典翻译实现
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@AllArgsConstructor
@TranslationType(type = TransConstant.DICT_TYPE_TO_LABEL)
public class DictTypeTranslationImpl implements TranslationInterface<String> {

    private final DictService dictService;

    @Override
    public String translation(Object key, String other) {
        if (key instanceof String dictValue && StringUtils.isNotBlank(other)) {
            return dictService.getDictLabel(other, dictValue);
        }
        return null;
    }
}
