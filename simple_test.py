#!/usr/bin/env python3
"""
简单测试脚本 - 验证系统基本功能
Simple test script to verify basic system functionality
"""

import json
import os
from pathlib import Path

def test_basic_functionality():
    """测试基本功能"""
    print("🧪 开始基本功能测试...")
    
    # 测试 1: JSON 配置加载
    print("📋 测试 1: JSON 配置加载")
    try:
        config_file = "/home/runner/work/RuoYi-Vue-Plus/RuoYi-Vue-Plus/enhanced_project_config.json"
        if os.path.exists(config_file):
            with open(config_file, 'r', encoding='utf-8') as f:
                config = json.load(f)
            print(f"   ✅ 成功加载配置: {config['projectMetadata']['projectName']}")
        else:
            print("   ⚠️  配置文件不存在，创建基本配置")
            config = create_basic_config()
    except Exception as e:
        print(f"   ❌ 配置加载失败: {e}")
        return False
    
    # 测试 2: 导入核心模块
    print("📦 测试 2: 导入核心模块")
    try:
        from scaffolding_service import ScaffoldingService
        from sql_processor import SqlProcessor
        print("   ✅ 核心模块导入成功")
    except Exception as e:
        print(f"   ❌ 模块导入失败: {e}")
        return False
    
    # 测试 3: 创建服务实例
    print("🔧 测试 3: 创建服务实例")
    try:
        service = ScaffoldingService()
        processor = SqlProcessor()
        print("   ✅ 服务实例创建成功")
    except Exception as e:
        print(f"   ❌ 服务实例创建失败: {e}")
        return False
    
    # 测试 4: 基本模板处理
    print("📝 测试 4: 基本模板处理")
    try:
        test_template = "${projectMetadata.projectName}"
        result = service._replace_template_variables(test_template, config)
        expected = config['projectMetadata']['projectName']
        if result == expected:
            print(f"   ✅ 模板处理成功: {result}")
        else:
            print(f"   ❌ 模板处理错误: 期望 {expected}, 得到 {result}")
            return False
    except Exception as e:
        print(f"   ❌ 模板处理失败: {e}")
        return False
    
    print("🎉 所有基本测试通过!")
    return True

def create_basic_config():
    """创建基本配置"""
    return {
        "projectMetadata": {
            "projectName": "测试项目",
            "groupId": "com.test.project",
            "artifactId": "test-project-server",
            "version": "1.0.0-SNAPSHOT",
            "description": "基本测试项目",
            "author": "测试团队"
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
            "sse": {"enabled": True},
            "websocket": {"enabled": False},
            "threadPool": {"enabled": True},
            "tenant": {"enabled": True}
        },
        "infrastructureConfig": {
            "database": {
                "type": "mysql",
                "host": "localhost",
                "port": 3306,
                "username": "root",
                "password": "password",
                "databaseName": "test_db"
            },
            "redis": {
                "host": "localhost",
                "port": 6379,
                "password": "",
                "database": 0
            }
        }
    }

def test_simple_generation():
    """测试简单项目生成"""
    print("\n🚀 开始简单项目生成测试...")
    
    try:
        from scaffolding_service import ScaffoldingService
        
        # 创建基本配置
        config = create_basic_config()
        
        # 保存测试配置
        test_config_file = "/tmp/simple_test_config.json"
        with open(test_config_file, 'w', encoding='utf-8') as f:
            json.dump(config, f, ensure_ascii=False, indent=2)
        print(f"📄 测试配置已保存: {test_config_file}")
        
        # 创建服务并生成项目
        service = ScaffoldingService()
        output_dir = "/tmp/simple_test_project"
        
        print("🔧 开始生成简单测试项目...")
        project_path = service.generate_project(config, output_dir)
        
        # 验证生成结果
        if os.path.exists(project_path):
            print(f"✅ 项目生成成功: {project_path}")
            
            # 检查关键文件
            key_files = [
                "pom.xml",
                "init.sql",
                "ruoyi-admin/src/main/resources/application.yml"
            ]
            
            for key_file in key_files:
                file_path = os.path.join(project_path, key_file)
                if os.path.exists(file_path):
                    print(f"   ✅ 关键文件存在: {key_file}")
                else:
                    print(f"   ❌ 关键文件缺失: {key_file}")
            
            return True
        else:
            print("❌ 项目生成失败")
            return False
            
    except Exception as e:
        print(f"❌ 简单生成测试失败: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """主函数"""
    print("=" * 50)
    print("🧪 RuoYi-Vue-Plus 脚手架系统 - 基本测试")
    print("=" * 50)
    
    # 基本功能测试
    if not test_basic_functionality():
        print("❌ 基本功能测试失败，停止测试")
        return False
    
    # 简单生成测试
    if not test_simple_generation():
        print("❌ 简单生成测试失败")
        return False
    
    print("\n🎉 所有测试通过! 系统运行正常")
    print("📚 可以运行以下命令进行完整测试:")
    print("   python3 demo.py")
    print("   python3 modular_demo.py")
    
    return True

if __name__ == "__main__":
    main()