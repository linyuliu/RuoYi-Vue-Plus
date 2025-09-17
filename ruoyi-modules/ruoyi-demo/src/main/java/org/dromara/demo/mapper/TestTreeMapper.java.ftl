package ${projectMetadata.groupId}.demo.mapper;

import ${projectMetadata.groupId}.common.mybatis.annotation.DataColumn;
import ${projectMetadata.groupId}.common.mybatis.annotation.DataPermission;
import ${projectMetadata.groupId}.common.mybatis.core.mapper.BaseMapperPlus;
import ${projectMetadata.groupId}.demo.domain.TestTree;
import ${projectMetadata.groupId}.demo.domain.vo.TestTreeVo;

/**
 * 测试树表Mapper接口
 *
 * @author ${projectMetadata.author!"Lion Li"}
 * @date 2021-07-26
 */
@DataPermission({
    @DataColumn(key = "deptName", value = "dept_id"),
    @DataColumn(key = "userName", value = "user_id")
})
public interface TestTreeMapper extends BaseMapperPlus<TestTree, TestTreeVo> {

}
