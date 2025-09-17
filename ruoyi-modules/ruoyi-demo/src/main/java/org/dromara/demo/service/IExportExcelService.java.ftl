package ${projectMetadata.groupId}.demo.service;

import jakarta.servlet.http.HttpServletResponse;

/**
 * 导出下拉框Excel示例
 *
 * @author ${projectMetadata.author!"Emil.Zhang"}
 */
public interface IExportExcelService {

    /**
     * 导出下拉框
     *
     * @param response /
     */
    void exportWithOptions(HttpServletResponse response);
}
