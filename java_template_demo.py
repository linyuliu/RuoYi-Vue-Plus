#!/usr/bin/env python3
"""
Java代码FTL模板化演示
演示如何将Java配置类转换为FTL模板，实现完全的模块化控制
"""

import json
import os
from pathlib import Path
from scaffolding_service import ScaffoldingService

def demo_java_ftl_templates():
    """演示Java FTL模板系统"""
    
    print("🚀 Java代码FTL模板化演示")
    print("=" * 60)
    print("✨ 功能：将Java配置类转换为FTL模板")
    print("🎯 目标：实现完全的模块化代码控制")
    print()
    
    # 高级Java模板化配置
    java_template_config = {
        "projectMetadata": {
            "projectName": "企业级微服务平台",
            "groupId": "com.enterprise.microservice",
            "artifactId": "microservice-platform-server",
            "version": "2.0.0-RELEASE",
            "description": "基于RuoYi-Vue-Plus的企业级微服务管理平台",
            "author": "企业架构团队"
        },
        "backendConfig": {
            "modulesToKeep": [
                "ruoyi-admin",
                "ruoyi-common", 
                "ruoyi-system",
                "ruoyi-generator"
            ]
        },
        "featureFlags": {
            # 服务端推送 - 启用
            "sse": {
                "enabled": True,
                "path": "/enterprise/sse"
            },
            # WebSocket - 禁用 (演示Java类完全不生成)
            "websocket": {
                "enabled": False,
                "path": "/enterprise/websocket",
                "allowedOrigins": "https://enterprise.example.com"
            },
            # 线程池 - 启用高性能配置
            "threadPool": {
                "enabled": True,
                "queueCapacity": 512,
                "keepAliveSeconds": 900
            },
            # API加密 - 启用
            "apiDecrypt": {
                "enabled": True,
                "headerFlag": "X-Enterprise-Encrypt"
            },
            # 多租户 - 启用
            "tenant": {
                "enabled": True,
                "excludes": [
                    "sys_menu",
                    "sys_tenant",
                    "sys_tenant_package",
                    "enterprise_config",
                    "enterprise_settings"
                ]
            },
            # 工作流 - 禁用
            "workflow": {
                "enabled": False
            },
            # API文档 - 启用自定义
            "springDoc": {
                "enabled": True,
                "title": "企业级微服务API",
                "description": "完整的企业级微服务接口文档"
            },
            # XSS防护 - 启用
            "xss": {
                "enabled": True,
                "excludeUrls": [
                    "/enterprise/upload",
                    "/enterprise/import",
                    "/api/content"
                ]
            },
            # 验证码 - 启用扭曲类型
            "captcha": {
                "enabled": True,
                "type": "CHAR",
                "category": "SHEAR"
            }
        },
        "infrastructureConfig": {
            "database": {
                "type": "mysql",
                "host": "enterprise-mysql.internal",
                "port": 3306,
                "username": "enterprise_user",
                "password": "enterprise_secure_2024",
                "databaseName": "enterprise_microservice_db"
            },
            "redis": {
                "host": "enterprise-redis.internal",
                "port": 6379,
                "password": "redis_enterprise_2024",
                "database": 3
            }
        },
        "customEntities": [
            {
                "tableName": "enterprise_service",
                "className": "Service",
                "comment": "企业服务注册表",
                "fields": [
                    {
                        "name": "id",
                        "type": "Long",
                        "primaryKey": True,
                        "comment": "服务ID"
                    },
                    {
                        "name": "service_name",
                        "type": "String",
                        "length": 200,
                        "nullable": False,
                        "comment": "服务名称"
                    },
                    {
                        "name": "service_url",
                        "type": "String",
                        "length": 500,
                        "comment": "服务URL"
                    },
                    {
                        "name": "version",
                        "type": "String",
                        "length": 50,
                        "nullable": False,
                        "comment": "服务版本"
                    },
                    {
                        "name": "health_check_url",
                        "type": "String",
                        "length": 500,
                        "comment": "健康检查URL"
                    },
                    {
                        "name": "status",
                        "type": "Integer",
                        "nullable": False,
                        "comment": "服务状态(1=正常 2=异常 3=维护)"
                    }
                ]
            }
        ]
    }
    
    # 保存配置
    config_file = "/tmp/java_template_config.json"
    with open(config_file, 'w', encoding='utf-8') as f:
        json.dump(java_template_config, f, ensure_ascii=False, indent=2)
    
    print(f"📄 Java模板配置已保存: {config_file}")
    
    # 显示配置信息
    print("\n📋 Java模板化项目配置:")
    print(f"   项目名称: {java_template_config['projectMetadata']['projectName']}")
    print(f"   组织标识: {java_template_config['projectMetadata']['groupId']}")
    print(f"   项目版本: {java_template_config['projectMetadata']['version']}")
    print(f"   自定义实体: {len(java_template_config['customEntities'])} 个")
    
    print("\n🎛️  Java类生成控制:")
    feature_flags = java_template_config['featureFlags']
    java_configs = [
        ('SSE配置类', 'sse', 'SseAutoConfiguration.java'),
        ('WebSocket配置类', 'websocket', 'WebSocketConfig.java'),
        ('线程池配置类', 'threadPool', 'ThreadPoolConfig.java'),
        ('多租户配置类', 'tenant', 'TenantConfig.java'),
        ('API加密配置类', 'apiDecrypt', 'ApiDecryptAutoConfiguration.java'),
        ('API文档配置类', 'springDoc', 'SpringDocConfig.java'),
        ('过滤器配置类', 'xss', 'FilterConfig.java'),
        ('验证码配置类', 'captcha', 'CaptchaConfig.java')
    ]
    
    for name, key, filename in java_configs:
        if key in feature_flags and isinstance(feature_flags[key], dict):
            status = "🟢 生成" if feature_flags[key].get('enabled', False) else "🔴 跳过"
            print(f"   {name:15} {status:8} ({filename})")
        else:
            print(f"   {name:15} ⚪ 默认   ({filename})")
    
    # 生成项目
    print("\n🚀 开始生成Java模板化项目...")
    service = ScaffoldingService()
    output_dir = "/tmp/enterprise_microservice_platform"
    
    project_path = service.generate_project(java_template_config, output_dir)
    
    # 验证Java模板处理结果
    print("\n🔍 验证Java模板处理结果...")
    verify_java_templates(project_path, java_template_config)
    
    # 统计生成的Java文件
    print("\n📊 Java配置类生成统计:")
    count_generated_java_files(project_path)
    
    # 显示生成的文件内容示例
    print("\n📄 生成的Java配置类示例:")
    show_generated_java_examples(project_path, java_template_config)
    
    # 打包项目
    print("\n📦 打包企业级项目...")
    package_path = service.create_project_package(project_path, "/tmp/enterprise_microservice_platform.zip")
    
    print("\n🎉 Java模板化项目生成成功!")
    print(f"   📁 项目目录: {project_path}")
    print(f"   📦 项目包: {package_path}")
    print(f"   📄 配置文件: {config_file}")
    
    print("\n✨ Java模板化特性说明:")
    print("1. ✅ 启用的功能模块 → 生成对应Java配置类")
    print("2. ❌ 禁用的功能模块 → 完全不生成Java文件")
    print("3. 🔧 包名全局替换 → 所有Java类使用新的包结构")
    print("4. 📝 作者信息模板化 → 统一的代码作者和版权信息")
    print("5. 🎯 条件注解生成 → @ConditionalOnProperty自动添加")
    
    return project_path

def verify_java_templates(project_path: str, config: dict):
    """验证Java模板处理结果"""
    
    feature_flags = config['featureFlags']
    project_meta = config['projectMetadata']
    
    # 检查包名替换
    sample_java_file = os.path.join(project_path, "ruoyi-common/ruoyi-common-sse/src/main/java/org/dromara/common/sse/config/SseAutoConfiguration.java")
    if os.path.exists(sample_java_file):
        with open(sample_java_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        if project_meta['groupId'] in content:
            print("   ✅ Java文件包名替换成功")
        else:
            print("   ❌ Java文件包名替换失败")
    
    # 检查生成的Java配置类
    java_configs = [
        ('SSE', 'sse', 'ruoyi-common/ruoyi-common-sse/src/main/java/org/dromara/common/sse/config/SseAutoConfiguration.java'),
        ('WebSocket', 'websocket', 'ruoyi-common/ruoyi-common-websocket/src/main/java/org/dromara/common/websocket/config/WebSocketConfig.java'),
        ('ThreadPool', 'threadPool', 'ruoyi-common/ruoyi-common-core/src/main/java/org/dromara/common/core/config/ThreadPoolConfig.java'),
        ('Tenant', 'tenant', 'ruoyi-common/ruoyi-common-tenant/src/main/java/org/dromara/common/tenant/config/TenantConfig.java')
    ]
    
    for name, key, relative_path in java_configs:
        file_path = os.path.join(project_path, relative_path)
        if key in feature_flags and isinstance(feature_flags[key], dict):
            enabled = feature_flags[key].get('enabled', False)
            if enabled:
                if os.path.exists(file_path):
                    print(f"   ✅ {name}配置类已生成")
                else:
                    print(f"   ❌ {name}配置类生成失败")
            else:
                # 对于禁用的功能，检查是否有注释说明
                if os.path.exists(file_path):
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    if "已禁用" in content:
                        print(f"   ✅ {name}配置类正确标记为禁用")
                    else:
                        print(f"   ⚠️  {name}配置类存在但未正确处理")

def count_generated_java_files(project_path: str):
    """统计生成的Java文件"""
    
    java_files = []
    config_dirs = [
        "ruoyi-common/ruoyi-common-sse/src/main/java",
        "ruoyi-common/ruoyi-common-websocket/src/main/java", 
        "ruoyi-common/ruoyi-common-core/src/main/java",
        "ruoyi-common/ruoyi-common-tenant/src/main/java",
        "ruoyi-common/ruoyi-common-encrypt/src/main/java",
        "ruoyi-common/ruoyi-common-doc/src/main/java",
        "ruoyi-common/ruoyi-common-web/src/main/java"
    ]
    
    for config_dir in config_dirs:
        full_dir = os.path.join(project_path, config_dir)
        if os.path.exists(full_dir):
            for root, dirs, files in os.walk(full_dir):
                for file in files:
                    if file.endswith('.java') and 'config' in root.lower():
                        java_files.append(os.path.join(root, file))
    
    print(f"   📊 找到配置类Java文件: {len(java_files)} 个")
    for java_file in java_files[:10]:  # 显示前10个
        rel_path = os.path.relpath(java_file, project_path)
        print(f"      📄 {rel_path}")
    
    if len(java_files) > 10:
        print(f"      ... 还有 {len(java_files) - 10} 个文件")

def show_generated_java_examples(project_path: str, config: dict):
    """显示生成的Java配置类示例"""
    
    # 显示SSE配置类示例（如果启用）
    if config['featureFlags']['sse']['enabled']:
        sse_file = os.path.join(project_path, "ruoyi-common/ruoyi-common-sse/src/main/java/org/dromara/common/sse/config/SseAutoConfiguration.java")
        if os.path.exists(sse_file):
            print("\n   📄 SSE自动配置类 (SseAutoConfiguration.java):")
            with open(sse_file, 'r', encoding='utf-8') as f:
                lines = f.readlines()
            
            # 显示前15行
            for i, line in enumerate(lines[:15]):
                print(f"      {i+1:2d}: {line.rstrip()}")
            print("      ...")
    
    # 显示WebSocket配置类示例（如果禁用，显示禁用注释）
    if not config['featureFlags']['websocket']['enabled']:
        websocket_file = os.path.join(project_path, "ruoyi-common/ruoyi-common-websocket/src/main/java/org/dromara/common/websocket/config/WebSocketConfig.java")
        if os.path.exists(websocket_file):
            print("\n   📄 WebSocket配置类 (WebSocketConfig.java) - 已禁用:")
            with open(websocket_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            if "已禁用" in content:
                print("      // WebSocket 功能已禁用，此配置类不会被生成")
            else:
                print("      内容已被条件模板控制...")

def main():
    """主函数"""
    try:
        demo_java_ftl_templates()
    except Exception as e:
        print(f"❌ Java模板化演示出错: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()