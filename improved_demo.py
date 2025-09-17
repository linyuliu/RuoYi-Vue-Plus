#!/usr/bin/env python3
"""
改进的模块化配置演示
演示更细致的POM模块控制和基础功能的默认禁用设置
"""

import json
import os
import sys
from pathlib import Path
from scaffolding_service import ScaffoldingService

def create_improved_config():
    """创建改进的配置，更细致的模块控制"""
    return {
        "projectMetadata": {
            "projectName": "企业微服务平台",
            "groupId": "com.enterprise.microservice",
            "artifactId": "enterprise-microservice-server", 
            "version": "2.0.0-SNAPSHOT",
            "description": "基于RuoYi-Vue-Plus的企业级微服务后台管理平台",
            "author": "企业架构团队"
        },
        "backendConfig": {
            "modulesToKeep": [
                "ruoyi-admin",
                "ruoyi-common", 
                "ruoyi-system",
                "ruoyi-generator",
                "ruoyi-modules"  # 保留modules容器，但内部子模块可细化控制
            ]
        },
        "infrastructureConfig": {
            "database": {
                "type": "mysql",
                "host": "enterprise-db.internal",
                "port": 3306,
                "username": "enterprise_user",
                "password": "enterprise_secure_2024",
                "databaseName": "enterprise_microservice_db"
            },
            "redis": {
                "host": "enterprise-redis.internal", 
                "port": 6379,
                "password": "redis_enterprise_2024",
                "database": 2
            }
        },
        "featureFlags": {
            # 基础功能，默认关闭，通过注解控制
            "sse": {"enabled": False},  # 默认禁用SSE
            "websocket": {"enabled": False},  # 默认禁用WebSocket
            "apiDecrypt": {"enabled": False},  # 默认禁用API加密
            "captcha": {"enabled": False},  # 默认禁用验证码
            
            # 核心功能，可选启用
            "threadPool": {"enabled": True, "queueCapacity": 512},
            "tenant": {"enabled": True, "excludes": ["sys_config", "sys_dict"]},
            "springDoc": {"enabled": True, "title": "企业微服务API", "version": "v2.0"},
            "xss": {"enabled": True, "excludeUrls": ["/api/upload", "/api/export"]},
            
            # 大模块功能，物理删除
            "workflow": {"enabled": False},  # 工作流模块，物理删除
            "job": {"enabled": False}  # 任务调度模块，物理删除
        },
        "customEntities": [
            {
                "tableName": "enterprise_department",
                "className": "Department", 
                "comment": "企业部门信息表",
                "fields": [
                    {"name": "id", "type": "Long", "primaryKey": True, "comment": "部门ID"},
                    {"name": "code", "type": "String", "length": 50, "nullable": False, "comment": "部门编码"},
                    {"name": "name", "type": "String", "length": 100, "nullable": False, "comment": "部门名称"},
                    {"name": "parentId", "type": "Long", "comment": "上级部门ID"},
                    {"name": "level", "type": "Integer", "comment": "部门层级"},
                    {"name": "sort", "type": "Integer", "comment": "排序"},
                    {"name": "status", "type": "String", "length": 1, "comment": "状态"}
                ]
            },
            {
                "tableName": "enterprise_employee",
                "className": "Employee",
                "comment": "企业员工信息表", 
                "fields": [
                    {"name": "id", "type": "Long", "primaryKey": True, "comment": "员工ID"},
                    {"name": "employeeNo", "type": "String", "length": 32, "nullable": False, "comment": "员工编号"},
                    {"name": "name", "type": "String", "length": 50, "nullable": False, "comment": "员工姓名"},
                    {"name": "departmentId", "type": "Long", "comment": "部门ID"},
                    {"name": "position", "type": "String", "length": 100, "comment": "职位"},
                    {"name": "phone", "type": "String", "length": 20, "comment": "手机号"},
                    {"name": "email", "type": "String", "length": 100, "comment": "邮箱"}
                ]
            }
        ]
    }

def main():
    print("🚀 改进的模块化配置演示")
    print("=" * 60)
    
    # 1. 创建改进的配置
    print("📋 1. 创建改进的企业微服务配置...")
    config = create_improved_config()
    
    print(f"   项目名称: {config['projectMetadata']['projectName']}")
    print(f"   组织ID: {config['projectMetadata']['groupId']}")
    print(f"   版本: {config['projectMetadata']['version']}")
    print(f"   保留模块: {', '.join(config['backendConfig']['modulesToKeep'])}")
    
    # 2. 显示功能开关配置
    print("\n🎛️  2. 功能开关配置:")
    for feature, settings in config['featureFlags'].items():
        status = "🟢 启用" if settings.get('enabled', False) else "🔴 禁用"
        print(f"   {feature:<15} {status}")
    
    # 3. 生成项目
    print("\n🔧 3. 生成企业微服务项目...")
    service = ScaffoldingService()
    
    output_dir = "/tmp/enterprise_microservice_platform"
    os.makedirs(output_dir, exist_ok=True)
    
    try:
        project_path = service.generate_project(config, output_dir)
        print(f"   ✅ 项目生成成功: {project_path}")
        
        # 4. 验证关键改进
        print("\n📊 4. 验证关键改进:")
        
        # 检查POM模块配置
        main_pom = Path(project_path) / "pom.xml"
        if main_pom.exists():
            pom_content = main_pom.read_text(encoding='utf-8')
            print(f"   ✅ 主POM文件存在")
            if "com.enterprise.microservice" in pom_content:
                print(f"   ✅ 组织ID正确替换")
            if "enterprise-microservice-server" in pom_content:
                print(f"   ✅ 项目ID正确替换")
        
        # 检查子模块POM
        modules_pom = Path(project_path) / "ruoyi-modules" / "pom.xml"
        if modules_pom.exists():
            modules_content = modules_pom.read_text(encoding='utf-8')
            print(f"   ✅ 子模块POM存在")
            if "ruoyi-job" not in modules_content:
                print(f"   ✅ job模块已从POM中移除")
            if "ruoyi-workflow" not in modules_content:
                print(f"   ✅ workflow模块已从POM中移除")
        
        # 检查基础功能默认禁用配置
        app_yml = Path(project_path) / "ruoyi-admin" / "src" / "main" / "resources" / "application.yml"
        if app_yml.exists():
            yml_content = app_yml.read_text(encoding='utf-8')
            print(f"   ✅ 应用配置文件存在")
            if "sse:" in yml_content and "enabled: false" in yml_content:
                print(f"   ✅ SSE默认禁用配置正确")
        
        # 检查Java配置类的条件注解
        sse_config = Path(project_path) / "ruoyi-common" / "ruoyi-common-sse" / "src" / "main" / "java" / "com" / "enterprise" / "microservice" / "common" / "sse" / "config" / "SseAutoConfiguration.java"
        if sse_config.exists():
            java_content = sse_config.read_text(encoding='utf-8')
            print(f"   ✅ SSE配置类已生成")
            if "matchIfMissing = false" in java_content:
                print(f"   ✅ SSE默认禁用注解正确")
            if "com.enterprise.microservice" in java_content:
                print(f"   ✅ Java包名替换正确")
        
        # 检查自定义实体SQL
        init_sql = Path(project_path) / "init.sql"
        if init_sql.exists():
            sql_content = init_sql.read_text(encoding='utf-8')
            print(f"   ✅ 初始化SQL文件存在 ({len(sql_content.splitlines())} 行)")
            if "enterprise_department" in sql_content:
                print(f"   ✅ 企业部门表已生成")
            if "enterprise_employee" in sql_content:
                print(f"   ✅ 企业员工表已生成")
        
        # 5. 显示最终统计
        print("\n📈 5. 最终统计:")
        project_size = sum(f.stat().st_size for f in Path(project_path).rglob('*') if f.is_file())
        print(f"   项目大小: {project_size / 1024 / 1024:.1f} MB")
        
        java_files = list(Path(project_path).rglob("*.java"))
        print(f"   Java文件数量: {len(java_files)}")
        
        config_files = list(Path(project_path).rglob("*.yml")) + list(Path(project_path).rglob("*.yaml"))
        print(f"   配置文件数量: {len(config_files)}")
        
        print(f"\n🎉 企业微服务平台生成完成!")
        print(f"📁 项目位置: {project_path}")
        
    except Exception as e:
        print(f"❌ 生成失败: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main())