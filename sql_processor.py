#!/usr/bin/env python3
"""
Phase 2: 动态 SQL 脚本生成
目标: 开发一套逻辑，能够根据 project.json 的配置，智能地生成一份干净、完整的 init.sql 初始化脚本。

实现以下任务:
- 任务 2.1: SQL 脚本解析与模块映射
- 任务 2.2: SQL 脚本过滤与拼接  
- 任务 2.3: 自定义实体 SQL 生成
- 任务 2.4: 最终脚本合成
"""

import json
import re
import os
from typing import Dict, List, Set, Tuple
from dataclasses import dataclass
from enum import Enum

class ModuleType(Enum):
    """模块类型枚举"""
    SYSTEM = "ruoyi-system"
    GENERATOR = "ruoyi-generator" 
    JOB = "ruoyi-job"
    WORKFLOW = "ruoyi-workflow"
    ADMIN = "ruoyi-admin"
    COMMON = "ruoyi-common"

@dataclass
class SqlBlock:
    """SQL 语句块"""
    content: str
    table_name: str
    module: ModuleType
    block_type: str  # 'CREATE_TABLE', 'INSERT', 'INDEX', etc.

@dataclass
class CustomField:
    """自定义字段"""
    name: str
    type: str
    length: int = None
    nullable: bool = True
    primary_key: bool = False
    primaryKey: bool = False  # Alternative naming for compatibility
    comment: str = ""
    
    def __post_init__(self):
        # Handle alternative naming
        if self.primaryKey:
            self.primary_key = True

@dataclass
class CustomEntity:
    """自定义实体"""
    table_name: str
    class_name: str
    fields: List[CustomField]
    comment: str = ""

class SqlProcessor:
    """SQL 处理器"""
    
    def __init__(self, sql_dir: str = "/home/runner/work/RuoYi-Vue-Plus/RuoYi-Vue-Plus/script/sql"):
        self.sql_dir = sql_dir
        self.table_module_mapping = self._build_table_module_mapping()
        self.sql_blocks: List[SqlBlock] = []
        
    def _build_table_module_mapping(self) -> Dict[str, ModuleType]:
        """建立表前缀到模块名的映射规则"""
        return {
            'sys_': ModuleType.SYSTEM,
            'gen_': ModuleType.GENERATOR,
            'sj_': ModuleType.JOB,     # SnailJob 相关表
            'qrtz_': ModuleType.JOB,   # Quartz 相关表
            'wf_': ModuleType.WORKFLOW  # Warm-Flow 工作流表
        }
    
    def parse_sql_files(self) -> List[SqlBlock]:
        """任务 2.1: SQL 脚本解析与模块映射"""
        print("🔍 Phase 2.1: 解析 SQL 脚本并建立模块映射")
        
        sql_files = [
            'ry_vue_5.X.sql',
            'ry_job.sql', 
            'ry_workflow.sql'
        ]
        
        all_blocks = []
        
        for sql_file in sql_files:
            file_path = os.path.join(self.sql_dir, sql_file)
            if os.path.exists(file_path):
                print(f"  📄 解析文件: {sql_file}")
                blocks = self._parse_single_sql_file(file_path)
                all_blocks.extend(blocks)
                print(f"    ✅ 找到 {len(blocks)} 个SQL块")
        
        self.sql_blocks = all_blocks
        self._print_module_summary()
        return all_blocks
    
    def _parse_single_sql_file(self, file_path: str) -> List[SqlBlock]:
        """解析单个SQL文件"""
        blocks = []
        
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 改进的 CREATE TABLE 匹配模式
        # 匹配 create table 语句，支持大小写和各种格式
        create_table_pattern = r'create\s+table\s+(?:`?(\w+)`?)\s*\([^;]+\)[^;]*;'
        
        for match in re.finditer(create_table_pattern, content, re.IGNORECASE | re.DOTALL):
            table_name = match.group(1).lower()
            sql_content = match.group(0).strip()
            
            # 确定模块类型
            module = self._determine_module(table_name)
            
            blocks.append(SqlBlock(
                content=sql_content,
                table_name=table_name,
                module=module,
                block_type='CREATE_TABLE'
            ))
        
        # 改进的 INSERT 匹配模式
        # 匹配 insert into 语句，支持多行和各种格式
        insert_pattern = r'insert\s+into\s+(?:`?(\w+)`?)[^;]*;'
        
        for match in re.finditer(insert_pattern, content, re.IGNORECASE | re.DOTALL):
            table_name = match.group(1).lower()
            sql_content = match.group(0).strip()
            
            module = self._determine_module(table_name)
            
            blocks.append(SqlBlock(
                content=sql_content,
                table_name=table_name,
                module=module,
                block_type='INSERT'
            ))
        
        return blocks
    
    def _determine_module(self, table_name: str) -> ModuleType:
        """根据表名确定所属模块"""
        table_name = table_name.lower()
        
        for prefix, module in self.table_module_mapping.items():
            if table_name.startswith(prefix):
                return module
        
        # 默认归类到系统模块
        return ModuleType.SYSTEM
    
    def _print_module_summary(self):
        """打印模块统计信息"""
        module_counts = {}
        for block in self.sql_blocks:
            module = block.module
            if module not in module_counts:
                module_counts[module] = {'tables': set(), 'total_blocks': 0}
            module_counts[module]['tables'].add(block.table_name)
            module_counts[module]['total_blocks'] += 1
        
        print("  📊 模块统计:")
        for module, stats in module_counts.items():
            print(f"    {module.value}: {len(stats['tables'])} 张表, {stats['total_blocks']} 个SQL块")
    
    def filter_and_concatenate(self, modules_to_keep: List[str]) -> str:
        """任务 2.2: SQL 脚本过滤与拼接"""
        print("🔧 Phase 2.2: 根据模块配置过滤SQL脚本")
        
        # 转换模块名到枚举
        keep_modules = set()
        for module_name in modules_to_keep:
            for module_enum in ModuleType:
                if module_enum.value == module_name:
                    keep_modules.add(module_enum)
                    break
        
        print(f"  📋 保留模块: {[m.value for m in keep_modules]}")
        
        # 过滤SQL块
        filtered_blocks = []
        for block in self.sql_blocks:
            if block.module in keep_modules:
                filtered_blocks.append(block)
        
        print(f"  ✅ 过滤后保留 {len(filtered_blocks)} 个SQL块")
        
        # 按类型分组并排序
        create_blocks = [b for b in filtered_blocks if b.block_type == 'CREATE_TABLE']
        insert_blocks = [b for b in filtered_blocks if b.block_type == 'INSERT']
        
        # 拼接SQL
        sql_parts = []
        sql_parts.append("-- 核心模块表结构")
        sql_parts.append("-- Generated by RuoYi-Vue-Plus Scaffolding System")
        sql_parts.append("-- " + "="*60)
        sql_parts.append("")
        
        # 添加表结构
        for block in create_blocks:
            sql_parts.append(f"-- {block.table_name} ({block.module.value})")
            sql_parts.append(block.content)
            sql_parts.append("")
        
        # 添加初始数据
        sql_parts.append("-- " + "="*60)
        sql_parts.append("-- 初始数据")
        sql_parts.append("-- " + "="*60)
        sql_parts.append("")
        
        for block in insert_blocks:
            sql_parts.append(f"-- {block.table_name} 初始数据")
            sql_parts.append(block.content)
            sql_parts.append("")
        
        return "\n".join(sql_parts)
    
    def generate_custom_entity_sql(self, entities: List[Dict]) -> str:
        """任务 2.3: 自定义实体 SQL 生成"""
        print("🎯 Phase 2.3: 生成自定义实体SQL")
        
        if not entities:
            print("  ℹ️  没有自定义实体，跳过生成")
            return ""
        
        sql_parts = []
        sql_parts.append("-- " + "="*60)
        sql_parts.append("-- 自定义业务表")
        sql_parts.append("-- " + "="*60)
        sql_parts.append("")
        
        for entity_config in entities:
            print(f"  🔨 生成实体: {entity_config.get('className', 'Unknown')}")
            
            entity = CustomEntity(
                table_name=entity_config.get('tableName', ''),
                class_name=entity_config.get('className', ''),
                fields=[CustomField(**field) for field in entity_config.get('fields', [])],
                comment=entity_config.get('comment', f"{entity_config.get('className', '')}表")
            )
            
            sql = self._generate_table_sql(entity)
            sql_parts.append(sql)
            sql_parts.append("")
        
        return "\n".join(sql_parts)
    
    def _generate_table_sql(self, entity: CustomEntity) -> str:
        """生成单个表的SQL"""
        lines = []
        lines.append(f"-- {entity.comment}")
        lines.append(f"CREATE TABLE `{entity.table_name}` (")
        
        # 生成字段定义
        field_lines = []
        for field in entity.fields:
            field_def = self._generate_field_definition(field)
            field_lines.append(f"    {field_def}")
        
        # 添加标准字段
        standard_fields = [
            "`create_dept` bigint(20) NULL DEFAULT NULL COMMENT '创建部门'",
            "`create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建者'", 
            "`create_time` datetime NULL DEFAULT NULL COMMENT '创建时间'",
            "`update_by` bigint(20) NULL DEFAULT NULL COMMENT '更新者'",
            "`update_time` datetime NULL DEFAULT NULL COMMENT '更新时间'",
            "`del_flag` char(1) NULL DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）'"
        ]
        
        field_lines.extend(standard_fields)
        
        # 添加主键
        primary_keys = [f.name for f in entity.fields if f.primary_key]
        if primary_keys:
            field_lines.append(f"    PRIMARY KEY (`{'`, `'.join(primary_keys)}`)")
        
        lines.append(",\n".join(field_lines))
        lines.append(f") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='{entity.comment}';")
        
        return "\n".join(lines)
    
    def _generate_field_definition(self, field: CustomField) -> str:
        """生成字段定义"""
        # 映射Java类型到MySQL类型
        type_mapping = {
            'String': 'varchar(255)',
            'Long': 'bigint(20)',
            'Integer': 'int(11)', 
            'BigDecimal': 'decimal(10,2)',
            'Date': 'datetime',
            'Boolean': 'tinyint(1)'
        }
        
        mysql_type = type_mapping.get(field.type, 'varchar(255)')
        
        # 处理长度
        if field.length and field.type == 'String':
            mysql_type = f'varchar({field.length})'
        
        # 构建字段定义
        null_spec = "NULL" if field.nullable else "NOT NULL"
        
        # 主键字段自动设置为NOT NULL AUTO_INCREMENT
        if field.primary_key:
            if field.type in ['Long', 'Integer']:
                return f"`{field.name}` {mysql_type} NOT NULL AUTO_INCREMENT COMMENT '{field.comment or field.name}'"
        
        return f"`{field.name}` {mysql_type} {null_spec} COMMENT '{field.comment or field.name}'"
    
    def generate_final_script(self, project_config: Dict) -> str:
        """任务 2.4: 最终脚本合成"""
        print("🚀 Phase 2.4: 合成最终初始化脚本")
        
        # 解析SQL文件
        self.parse_sql_files()
        
        # 过滤核心模块SQL
        modules_to_keep = project_config.get('backendConfig', {}).get('modulesToKeep', [])
        core_sql = self.filter_and_concatenate(modules_to_keep)
        
        # 生成自定义实体SQL
        custom_entities = project_config.get('customEntities', [])
        custom_sql = self.generate_custom_entity_sql(custom_entities)
        
        # 合并最终脚本
        final_parts = []
        final_parts.append("-- ========================================")
        final_parts.append("-- RuoYi-Vue-Plus 脚手架初始化脚本")
        final_parts.append(f"-- 项目: {project_config.get('projectMetadata', {}).get('projectName', 'Unknown')}")
        final_parts.append(f"-- 生成时间: {self._get_current_timestamp()}")
        final_parts.append("-- ========================================")
        final_parts.append("")
        final_parts.append("SET NAMES utf8mb4;")
        final_parts.append("SET FOREIGN_KEY_CHECKS = 0;")
        final_parts.append("")
        
        final_parts.append(core_sql)
        
        if custom_sql:
            final_parts.append(custom_sql)
        
        final_parts.append("")
        final_parts.append("SET FOREIGN_KEY_CHECKS = 1;")
        
        final_script = "\n".join(final_parts)
        
        print(f"  ✅ 最终脚本生成完成，共 {len(final_script.splitlines())} 行")
        
        return final_script
    
    def _get_current_timestamp(self) -> str:
        """获取当前时间戳"""
        from datetime import datetime
        return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def main():
    """主函数，演示SQL处理功能"""
    print("=" * 60)
    print("🔧 Phase 2: 动态 SQL 脚本生成演示")
    print("=" * 60)
    
    # 测试配置
    test_config = {
        "projectMetadata": {
            "projectName": "测试项目",
            "groupId": "com.mycompany.testproject",
            "artifactId": "test-project-server",
            "version": "1.0.0-SNAPSHOT",
            "description": "一个由RuoYi-Vue-Plus生成的最小化后端服务。"
        },
        "backendConfig": {
            "modulesToKeep": [
                "ruoyi-admin",
                "ruoyi-common", 
                "ruoyi-system",
                "ruoyi-generator"
            ]
        },
        "customEntities": [
            {
                "tableName": "product",
                "className": "Product",
                "comment": "产品管理表",
                "fields": [
                    {
                        "name": "id",
                        "type": "Long",
                        "primaryKey": True,
                        "comment": "产品ID"
                    },
                    {
                        "name": "name",
                        "type": "String",
                        "length": 100,
                        "nullable": False,
                        "comment": "产品名称"
                    },
                    {
                        "name": "description",
                        "type": "String",
                        "length": 500,
                        "comment": "产品描述"
                    },
                    {
                        "name": "price",
                        "type": "BigDecimal",
                        "comment": "产品价格"
                    },
                    {
                        "name": "status",
                        "type": "Integer",
                        "nullable": False,
                        "comment": "状态(0=禁用 1=启用)"
                    }
                ]
            }
        ]
    }
    
    # 创建SQL处理器
    processor = SqlProcessor()
    
    # 生成最终脚本
    final_sql = processor.generate_final_script(test_config)
    
    # 保存结果
    output_file = "/tmp/init.sql"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(final_sql)
    
    print(f"\n🎉 SQL 脚本生成完成!")
    print(f"📁 输出文件: {output_file}")
    print(f"📊 脚本统计: {len(final_sql.splitlines())} 行, {len(final_sql)} 字符")
    
    # 显示部分内容
    print("\n📄 脚本预览 (前50行):")
    print("-" * 50)
    lines = final_sql.splitlines()
    for i, line in enumerate(lines[:50], 1):
        print(f"{i:3d}: {line}")
    
    if len(lines) > 50:
        print(f"... (还有 {len(lines) - 50} 行)")

if __name__ == "__main__":
    main()