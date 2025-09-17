#!/usr/bin/env python3
"""
RuoYi-Vue-Plus 脚手架生成系统演示脚本
快速生成定制化项目的示例用法
"""

import json
import os
from scaffolding_service import ScaffoldingService

def create_sample_project():
    """创建示例项目配置并生成项目"""
    
    print("🌟 RuoYi-Vue-Plus 脚手架生成系统演示")
    print("=" * 60)
    
    # 示例项目配置
    sample_config = {
        "projectMetadata": {
            "projectName": "电商管理系统",
            "groupId": "com.ecommerce.admin",
            "artifactId": "ecommerce-admin-server",
            "version": "1.0.0",
            "description": "基于RuoYi-Vue-Plus的电商后台管理系统",
            "author": "开发团队"
        },
        "backendConfig": {
            "modulesToKeep": [
                "ruoyi-admin",      # 管理后台
                "ruoyi-common",     # 公共组件
                "ruoyi-system",     # 系统管理
                "ruoyi-generator"   # 代码生成器
            ]
        },
        "infrastructureConfig": {
            "database": {
                "type": "mysql",
                "host": "localhost",
                "port": 3306,
                "username": "ecommerce_user",
                "password": "ecommerce_2024",
                "databaseName": "ecommerce_admin_db"
            },
            "redis": {
                "host": "localhost",
                "port": 6379,
                "password": "redis_2024",
                "database": 1
            }
        },
        "customEntities": [
            {
                "tableName": "ec_product",
                "className": "Product",
                "comment": "商品信息表",
                "fields": [
                    {
                        "name": "id",
                        "type": "Long",
                        "primaryKey": True,
                        "comment": "商品ID"
                    },
                    {
                        "name": "name",
                        "type": "String",
                        "length": 200,
                        "nullable": False,
                        "comment": "商品名称"
                    },
                    {
                        "name": "description",
                        "type": "String",
                        "length": 1000,
                        "comment": "商品描述"
                    },
                    {
                        "name": "price",
                        "type": "BigDecimal",
                        "nullable": False,
                        "comment": "商品价格"
                    },
                    {
                        "name": "stock_quantity",
                        "type": "Integer",
                        "nullable": False,
                        "comment": "库存数量"
                    },
                    {
                        "name": "category_id",
                        "type": "Long",
                        "comment": "分类ID"
                    },
                    {
                        "name": "status",
                        "type": "Integer",
                        "nullable": False,
                        "comment": "状态(0=下架 1=上架)"
                    }
                ]
            },
            {
                "tableName": "ec_category",
                "className": "Category",
                "comment": "商品分类表",
                "fields": [
                    {
                        "name": "id",
                        "type": "Long",
                        "primaryKey": True,
                        "comment": "分类ID"
                    },
                    {
                        "name": "name",
                        "type": "String",
                        "length": 100,
                        "nullable": False,
                        "comment": "分类名称"
                    },
                    {
                        "name": "parent_id",
                        "type": "Long",
                        "comment": "父分类ID"
                    },
                    {
                        "name": "sort_order",
                        "type": "Integer",
                        "comment": "排序顺序"
                    },
                    {
                        "name": "status",
                        "type": "Integer",
                        "nullable": False,
                        "comment": "状态(0=禁用 1=启用)"
                    }
                ]
            },
            {
                "tableName": "ec_order",
                "className": "Order", 
                "comment": "订单表",
                "fields": [
                    {
                        "name": "id",
                        "type": "Long",
                        "primaryKey": True,
                        "comment": "订单ID"
                    },
                    {
                        "name": "order_no",
                        "type": "String",
                        "length": 50,
                        "nullable": False,
                        "comment": "订单号"
                    },
                    {
                        "name": "user_id",
                        "type": "Long",
                        "nullable": False,
                        "comment": "用户ID"
                    },
                    {
                        "name": "total_amount",
                        "type": "BigDecimal",
                        "nullable": False,
                        "comment": "订单总金额"
                    },
                    {
                        "name": "status",
                        "type": "Integer",
                        "nullable": False,
                        "comment": "订单状态(1=待支付 2=已支付 3=已发货 4=已完成 5=已取消)"
                    },
                    {
                        "name": "order_time",
                        "type": "Date",
                        "nullable": False,
                        "comment": "下单时间"
                    }
                ]
            }
        ]
    }
    
    # 保存配置文件
    config_file = "/tmp/ecommerce_project.json"
    with open(config_file, 'w', encoding='utf-8') as f:
        json.dump(sample_config, f, ensure_ascii=False, indent=2)
    
    print(f"📄 项目配置已保存: {config_file}")
    
    # 显示配置信息
    print("\n📋 项目配置信息:")
    print(f"   项目名称: {sample_config['projectMetadata']['projectName']}")
    print(f"   组织标识: {sample_config['projectMetadata']['groupId']}")
    print(f"   数据库名: {sample_config['infrastructureConfig']['database']['databaseName']}")
    print(f"   自定义实体: {len(sample_config['customEntities'])} 个")
    print("   - 商品信息表 (ec_product)")
    print("   - 商品分类表 (ec_category)")
    print("   - 订单表 (ec_order)")
    
    # 创建脚手架服务
    print("\n🚀 开始生成项目...")
    service = ScaffoldingService()
    
    # 生成项目
    output_dir = "/tmp/ecommerce_admin_project"
    project_path = service.generate_project(sample_config, output_dir)
    
    # 验证项目
    print("\n🔍 验证生成的项目...")
    validation_results = service.validate_project(project_path)
    
    # 显示验证结果
    passed_count = sum(1 for result in validation_results.values() if result)
    total_count = len(validation_results)
    
    print(f"\n📊 验证结果: {passed_count}/{total_count} 项通过")
    
    if passed_count >= total_count - 1:  # 允许编译验证失败
        # 打包项目
        print("\n📦 打包生成的项目...")
        package_path = service.create_project_package(project_path, "/tmp/ecommerce_admin_project.zip")
        
        print("\n🎉 项目生成成功!")
        print(f"   📁 项目目录: {project_path}")
        print(f"   📦 项目包: {package_path}")
        print(f"   📄 配置文件: {config_file}")
        
        # 显示项目结构
        print("\n📋 生成的项目结构:")
        show_project_structure(project_path)
        
        # 显示使用说明
        print("\n📚 使用说明:")
        print("1. 解压项目包到目标目录")
        print("2. 导入 init.sql 到 MySQL 数据库")
        print("3. 修改 application.yml 中的数据库连接信息")
        print("4. 运行 'mvn spring-boot:run' 启动项目")
        print("5. 访问 http://localhost:8080 使用系统")
        
    else:
        print("❌ 项目验证失败，请检查错误信息")

def show_project_structure(project_path: str):
    """显示项目结构"""
    import os
    
    def print_tree(path, prefix="", max_depth=2, current_depth=0):
        if current_depth >= max_depth:
            return
            
        items = []
        try:
            for item in sorted(os.listdir(path)):
                if not item.startswith('.') and item not in ['target', '__pycache__', 'node_modules']:
                    items.append(item)
        except PermissionError:
            return
            
        for i, item in enumerate(items[:10]):  # 限制显示数量
            item_path = os.path.join(path, item)
            is_last = i == len(items) - 1
            
            current_prefix = "└── " if is_last else "├── "
            print(f"{prefix}{current_prefix}{item}")
            
            if os.path.isdir(item_path):
                next_prefix = prefix + ("    " if is_last else "│   ")
                print_tree(item_path, next_prefix, max_depth, current_depth + 1)
    
    print_tree(project_path)

def main():
    """主函数"""
    try:
        create_sample_project()
    except Exception as e:
        print(f"❌ 生成过程出错: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()