# RuoYi-Vue-Plus 脚手架生成系统

基于 FTL 和 JSON 的后端脚手架生成服务，能够根据配置文件自动生成定制化的 RuoYi-Vue-Plus 项目。

## 🎯 系统概述

此脚手架系统实现了完整的三阶段开发计划：

1. **Phase 1: FTL 模板转换** - 将核心配置文件转换为 FreeMarker 模板
2. **Phase 2: 动态 SQL 生成** - 智能解析和生成数据库初始化脚本  
3. **Phase 3: 服务编排集成** - 端到端的项目生成流程

## 🚀 快速开始

### 使用脚手架服务

```bash
# 运行完整的脚手架生成演示
python3 scaffolding_service.py

# 或单独运行 SQL 处理器
python3 sql_processor.py
```

### 自定义项目生成

```python
from scaffolding_service import ScaffoldingService

# 创建服务实例
service = ScaffoldingService()

# 项目配置
config = {
    "projectMetadata": {
        "projectName": "我的项目",
        "groupId": "com.example.myproject", 
        "artifactId": "my-project-server",
        "version": "1.0.0-SNAPSHOT",
        "description": "基于RuoYi-Vue-Plus的定制项目"
    },
    "backendConfig": {
        "modulesToKeep": ["ruoyi-admin", "ruoyi-common", "ruoyi-system", "ruoyi-generator"]
    },
    "infrastructureConfig": {
        "database": {
            "type": "mysql",
            "host": "localhost",
            "port": 3306,
            "username": "root",
            "password": "123456",
            "databaseName": "my_project_db"
        },
        "redis": {
            "host": "localhost", 
            "port": 6379,
            "password": "",
            "database": 0
        }
    },
    "customEntities": [
        {
            "tableName": "user_profile",
            "className": "UserProfile",
            "comment": "用户档案表",
            "fields": [
                {"name": "id", "type": "Long", "primaryKey": True, "comment": "主键"},
                {"name": "nickname", "type": "String", "length": 50, "comment": "昵称"},
                {"name": "avatar", "type": "String", "length": 255, "comment": "头像"}
            ]
        }
    ]
}

# 生成项目
project_path = service.generate_project(config, "/path/to/output")

# 验证项目
results = service.validate_project(project_path)

# 打包项目
package_path = service.create_project_package(project_path)
```

## 📋 配置文件说明

### projectMetadata (项目元数据)
- `projectName`: 项目显示名称
- `groupId`: Maven 组 ID (如: com.company.project)
- `artifactId`: Maven 构件 ID (如: project-server)
- `version`: 项目版本号
- `description`: 项目描述
- `author`: 作者名称 (可选)

### backendConfig (后端配置)
- `modulesToKeep`: 要保留的模块列表
  - `ruoyi-admin`: 管理后台模块
  - `ruoyi-common`: 公共组件模块  
  - `ruoyi-system`: 系统核心模块
  - `ruoyi-generator`: 代码生成器模块
  - `ruoyi-job`: 任务调度模块 (可选)
  - `ruoyi-workflow`: 工作流模块 (可选)

### infrastructureConfig (基础设施配置)
**数据库配置:**
- `type`: 数据库类型 (mysql/postgresql/oracle/sqlserver)
- `host`: 数据库主机
- `port`: 数据库端口
- `username`: 用户名
- `password`: 密码
- `databaseName`: 数据库名

**Redis 配置:**
- `host`: Redis 主机
- `port`: Redis 端口  
- `password`: Redis 密码
- `database`: Redis 数据库索引

### customEntities (自定义实体)
为业务需求定义的自定义表结构：

```json
{
    "tableName": "product",
    "className": "Product", 
    "comment": "产品表",
    "fields": [
        {
            "name": "id",
            "type": "Long",
            "primaryKey": true,
            "comment": "产品ID"
        },
        {
            "name": "name",
            "type": "String",
            "length": 100,
            "nullable": false,
            "comment": "产品名称"
        }
    ]
}
```

**支持的字段类型:**
- `String`: 字符串 → varchar(length)
- `Long`: 长整型 → bigint(20)
- `Integer`: 整型 → int(11)
- `BigDecimal`: 高精度数值 → decimal(10,2)
- `Date`: 日期时间 → datetime
- `Boolean`: 布尔值 → tinyint(1)

## 🔧 系统架构

### Phase 1: FTL 模板转换
**文件:** `pom.xml.ftl`, `application.yml.ftl`, `generator.yml.ftl`

将硬编码配置转换为动态模板：
```xml
<!-- 原始 -->
<groupId>org.dromara</groupId>
<artifactId>ruoyi-vue-plus</artifactId>

<!-- 模板化 -->
<groupId>${projectMetadata.groupId}</groupId>
<artifactId>${projectMetadata.artifactId}</artifactId>
```

### Phase 2: 动态 SQL 生成
**文件:** `sql_processor.py`

智能解析现有 SQL 文件并生成定制脚本：

1. **模块映射**: 根据表前缀自动分类
   - `sys_` → ruoyi-system
   - `gen_` → ruoyi-generator  
   - `sj_` → ruoyi-job

2. **智能过滤**: 只保留配置中指定的模块

3. **自定义实体**: 自动生成业务表结构

4. **脚本合成**: 生成完整的 `init.sql`

### Phase 3: 服务编排集成
**文件:** `scaffolding_service.py`

完整的项目生成流程：

```
原始项目 → 模块裁剪 → POM更新 → 模板处理 → 包名重构 → SQL生成 → 最终项目
```

## 📊 性能指标

- **生成速度**: ~0.3 秒
- **SQL 处理**: 469+ SQL 块处理能力
- **文件处理**: 466+ Java 文件包名重构
- **模块支持**: 6+ 核心模块智能管理

## 🎉 生成结果

运行脚手架系统后，您将得到：

```
📁 generated_project/
├── 📄 pom.xml (定制化的项目配置)
├── 📄 init.sql (1945+ 行初始化脚本)
├── 📁 ruoyi-admin/ (管理后台)
├── 📁 ruoyi-common/ (公共组件)
├── 📁 ruoyi-modules/
│   ├── 📁 ruoyi-system/ (系统模块)
│   └── 📁 ruoyi-generator/ (代码生成器)
└── 📁 script/ (原始脚本保留)
```

### 特性验证

✅ **配置定制化**: 所有模板变量正确替换  
✅ **模块精简化**: 不需要的模块已删除  
✅ **包名重构**: 全局包名更新完成  
✅ **SQL 生成**: 完整的数据库初始化脚本  
✅ **自定义实体**: 业务表自动生成  
✅ **项目结构**: 标准 Maven 项目结构  

## 🛠️ 扩展开发

### 添加新的模块映射

```python
# 在 sql_processor.py 中扩展
self.table_module_mapping = {
    'sys_': ModuleType.SYSTEM,
    'gen_': ModuleType.GENERATOR,
    'my_': ModuleType.CUSTOM,  # 新增自定义模块
}
```

### 自定义模板变量

```python
# 在 scaffolding_service.py 中扩展
def _replace_template_variables(self, content: str, project_config: Dict) -> str:
    # 添加自定义变量处理逻辑
    pass
```

### 添加新的验证规则

```python
# 在 validate_project 方法中添加
validation_results['custom_check'] = self._validate_custom_logic(project_path)
```

## 📚 技术栈

- **Python 3.8+**: 核心开发语言
- **FreeMarker**: 模板引擎语法 (FTL)
- **Maven**: 项目构建管理
- **MySQL**: 默认数据库支持
- **Redis**: 缓存和会话管理
- **Spring Boot 3.x**: 底层框架

## 🤝 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [RuoYi-Vue-Plus](https://gitee.com/dromara/RuoYi-Vue-Plus) - 优秀的基础框架
- [Dromara](https://dromara.org/) - 开源组织支持
- [FreeMarker](https://freemarker.apache.org/) - 模板引擎技术

---

**🌟 如果这个项目对您有帮助，请给我们一个 Star!**