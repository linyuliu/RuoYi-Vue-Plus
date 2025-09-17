package ${projectMetadata.groupId}.workflow.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.convert.Convert;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import ${projectMetadata.groupId}.common.core.domain.dto.UserDTO;
import ${projectMetadata.groupId}.common.core.service.DeptService;
import ${projectMetadata.groupId}.common.core.service.DictService;
import ${projectMetadata.groupId}.common.core.service.UserService;
import ${projectMetadata.groupId}.common.core.utils.DateUtils;
import ${projectMetadata.groupId}.common.core.utils.ServletUtils;
import ${projectMetadata.groupId}.common.core.utils.StreamUtils;
import ${projectMetadata.groupId}.common.core.utils.StringUtils;
import ${projectMetadata.groupId}.warm.flow.core.dto.DefJson;
import ${projectMetadata.groupId}.warm.flow.core.dto.NodeJson;
import ${projectMetadata.groupId}.warm.flow.core.dto.PromptContent;
import ${projectMetadata.groupId}.warm.flow.core.enums.NodeType;
import ${projectMetadata.groupId}.warm.flow.core.utils.MapUtil;
import ${projectMetadata.groupId}.warm.flow.orm.entity.FlowHisTask;
import ${projectMetadata.groupId}.warm.flow.orm.mapper.FlowHisTaskMapper;
import ${projectMetadata.groupId}.warm.flow.ui.service.ChartExtService;
import ${projectMetadata.groupId}.workflow.common.ConditionalOnEnable;
import ${projectMetadata.groupId}.workflow.common.constant.FlowConstant;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 流程图提示信息
 *
 * @author ${projectMetadata.author!"AprilWind"}
 */
@ConditionalOnEnable
@Slf4j
@RequiredArgsConstructor
@Service
public class FlwChartExtServiceImpl implements ChartExtService {

    private final UserService userService;
    private final DeptService deptService;
    private final FlowHisTaskMapper flowHisTaskMapper;
    private final DictService dictService;

    /**
     * 设置流程图提示信息
     *
     * @param defJson 流程定义json对象
     */
    @Override
    public void execute(DefJson defJson) {
        // 临时修复 后续版本将通过defjson获取流程实例ID
        String[] parts = ServletUtils.getRequest().getRequestURI().split("/");
        Long instanceId = Convert.toLong(parts[parts.length - 1]);

        // 根据流程实例ID查询所有相关的历史任务列表
        List<FlowHisTask> flowHisTasks = this.getHisTaskGroupedByNode(instanceId);
        if (CollUtil.isEmpty(flowHisTasks)) {
            return;
        }

        // 按节点编号（nodeCode）对历史任务进行分组
        Map<String, List<FlowHisTask>> groupedByNode = StreamUtils.groupByKey(flowHisTasks, FlowHisTask::getNodeCode);

        // 批量查询所有审批人的用户信息
        List<UserDTO> userDTOList = userService.selectListByIds(StreamUtils.toList(flowHisTasks, e -> Convert.toLong(e.getApprover())));

        // 将查询到的用户列表转换为以用户ID为key的映射
        Map<Long, UserDTO> userMap = StreamUtils.toIdentityMap(userDTOList, UserDTO::getUserId);

        Map<String, String> dictType = dictService.getAllDictByDictType(FlowConstant.WF_TASK_STATUS);

        // 遍历流程定义中的每个节点，调用处理方法，将对应节点的任务列表及用户信息传入，生成扩展提示内容
        for (NodeJson nodeJson : defJson.getNodeList()) {
            // 获取当前节点对应的历史任务列表，如果没有则返回空列表避免空指针
            List<FlowHisTask> taskList = groupedByNode.get(nodeJson.getNodeCode());
            if (CollUtil.isEmpty(taskList)) {
                continue;
            }
            // 处理当前节点的扩展信息，包括构建审批人提示内容等
            this.processNodeExtInfo(nodeJson, taskList, userMap, dictType);
        }
    }

    /**
     * 初始化流程图提示信息
     *
     * @param defJson 流程定义json对象
     */
    @Override
    public void initPromptContent(DefJson defJson) {
        defJson.setTopText("流程名称: " + defJson.getFlowName());
        defJson.getNodeList().forEach(nodeJson -> {
            nodeJson.setPromptContent(
                new PromptContent()
                    // 提示信息
                    .setInfo(
                        CollUtil.newArrayList(
                            new PromptContent.InfoItem()
                                .setPrefix("任务名称: ")
                                .setContent(nodeJson.getNodeName())
                                .setContentStyle(Map.of(
                                    "border", "1px solid #d1e9ff",
                                    "backgroundColor", "#e8f4ff",
                                    "padding", "4px 8px",
                                    "borderRadius", "4px"
                                ))
                                .setRowStyle(Map.of(
                                    "fontWeight", "bold",
                                    "margin", "0 0 6px 0",
                                    "padding", "0 0 8px 0",
                                    "borderBottom", "1px solid #ccc"
                                ))
                        )
                    )
                    // 弹窗样式
                    .setDialogStyle(MapUtil.mergeAll(
                        "position", "absolute",
                        "backgroundColor", "#fff",
                        "border", "1px solid #ccc",
                        "borderRadius", "4px",
                        "boxShadow", "0 2px 8px rgba(0, 0, 0, 0.15)",
                        "padding", "8px 12px",
                        "fontSize", "14px",
                        "zIndex", "1000",
                        "maxWidth", "500px",
                        "overflowY", "visible",
                        "overflowX", "hidden",
                        "color", "#333",
                        "pointerEvents", "auto",
                        "scrollbarWidth", "thin"
                    ))
            );
        });
    }

    /**
     * 处理节点的扩展信息，构建用于流程图悬浮提示的内容
     *
     * @param nodeJson 当前节点对象
     * @param taskList 当前节点对应的历史审批任务列表
     */
    private void processNodeExtInfo(NodeJson nodeJson, List<FlowHisTask> taskList, Map<Long, UserDTO> userMap, Map<String, String> dictType) {

        // 获取节点提示内容对象中的 info 列表，用于追加提示项
        List<PromptContent.InfoItem> info = nodeJson.getPromptContent().getInfo();

        // 遍历所有任务记录，构建提示内容
        for (FlowHisTask task : taskList) {
            UserDTO userDTO = userMap.get(Convert.toLong(task.getApprover()));
            if (ObjectUtil.isEmpty(userDTO)) {
                continue;
            }

            // 查询用户所属部门名称
            String deptName = deptService.selectDeptNameByIds(Convert.toStr(userDTO.getDeptId()));

            // 添加标题项，如：👤 张三（市场部）
            info.add(new PromptContent.InfoItem()
                .setPrefix(StringUtils.format("👥 {}（{}）", userDTO.getNickName(), deptName))
                .setPrefixStyle(Map.of(
                    "fontWeight", "bold",
                    "fontSize", "15px",
                    "color", "#333"
                ))
                .setRowStyle(Map.of(
                    "margin", "8px 0",
                    "borderBottom", "1px dashed #ccc"
                ))
            );

            // 添加具体信息项：账号、耗时、时间
            info.add(buildInfoItem("用户账号", userDTO.getUserName()));
            info.add(buildInfoItem("审批状态", dictType.get(task.getFlowStatus())));
            info.add(buildInfoItem("审批耗时", DateUtils.getTimeDifference(task.getUpdateTime(), task.getCreateTime())));
            info.add(buildInfoItem("办理时间", DateUtils.formatDateTime(task.getUpdateTime())));
        }
    }

    /**
     * 构建单条提示内容对象 InfoItem，用于悬浮窗显示（key: value）
     *
     * @param key   字段名（作为前缀）
     * @param value 字段值
     * @return 提示项对象
     */
    private PromptContent.InfoItem buildInfoItem(String key, String value) {
        return new PromptContent.InfoItem()
            // 前缀
            .setPrefix(key + ": ")
            // 前缀样式
            .setPrefixStyle(Map.of(
                "textAlign", "right",
                "color", "#444",
                "userSelect", "none",
                "display", "inline-block",
                "width", "100px",
                "paddingRight", "8px",
                "fontWeight", "500",
                "fontSize", "14px",
                "lineHeight", "24px",
                "verticalAlign", "middle"
            ))
            // 内容
            .setContent(value)
            // 内容样式
            .setContentStyle(Map.of(
                "backgroundColor", "#f7faff",
                "color", "#005cbf",
                "padding", "4px 8px",
                "fontSize", "14px",
                "borderRadius", "4px",
                "whiteSpace", "normal",
                "border", "1px solid #d0e5ff",
                "userSelect", "text",
                "lineHeight", "20px"
            ))
            // 行样式
            .setRowStyle(Map.of(
                "color", "#222",
                "alignItems", "center",
                "display", "flex",
                "marginBottom", "6px",
                "fontWeight", "400",
                "fontSize", "14px"
            ));
    }

    /**
     * 根据流程实例ID获取历史任务列表
     *
     * @param instanceId 流程实例ID
     * @return 历史任务列表
     */
    public List<FlowHisTask> getHisTaskGroupedByNode(Long instanceId) {
        LambdaQueryWrapper<FlowHisTask> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(FlowHisTask::getInstanceId, instanceId)
            .eq(FlowHisTask::getNodeType, NodeType.BETWEEN.getKey())
            .orderByDesc(FlowHisTask::getCreateTime, FlowHisTask::getUpdateTime);
        return flowHisTaskMapper.selectList(wrapper);
    }

}
