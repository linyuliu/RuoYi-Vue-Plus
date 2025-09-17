package ${projectMetadata.groupId}.generator.mapper;

import com.baomidou.mybatisplus.annotation.InterceptorIgnore;
import ${projectMetadata.groupId}.common.mybatis.core.mapper.BaseMapperPlus;
import ${projectMetadata.groupId}.generator.domain.GenTableColumn;

/**
 * 业务字段 数据层
 *
 * @author ${projectMetadata.author!"Lion Li"}
 */
@InterceptorIgnore(dataPermission = "true", tenantLine = "true")
public interface GenTableColumnMapper extends BaseMapperPlus<GenTableColumn, GenTableColumn> {

}
