# 开发环境配置
server:
  # 服务器的HTTP端口，默认为8080
  port: 8080
  servlet:
    # 应用的访问路径
    context-path: /
  # undertow 配置
  undertow:
    # HTTP post内容的最大大小。当值为-1时，默认值为大小是无限的
    max-http-post-size: -1
    # 以下的配置会影响buffer,这些buffer会用于服务器连接的IO操作,有点类似netty的池化内存管理
    # 每块buffer的空间大小,越小的空间被利用越充分
    buffer-size: 512
    # 是否分配的直接内存
    direct-buffers: true
    threads:
      # 设置IO线程数, 它主要执行非阻塞的任务,它们会负责多个连接, 默认设置每个CPU核心一个线程
      io: 8
      # 阻塞任务线程池, 当执行类似servlet请求阻塞操作, undertow会从这个线程池中取得线程,它的值设置取决于系统的负载
      worker: 256

captcha:
  # 是否启用验证码校验
  enable: true
  # 验证码类型 math 数组计算 char 字符验证
  type: MATH
  # line 线段干扰 circle 圆圈干扰 shear 扭曲干扰
  category: CIRCLE
  # 数字验证码位数
  numberLength: 1
  # 字符验证码长度
  charLength: 4

# 日志配置
logging:
  level:
    ${projectMetadata.groupId}: @logging.level@
    org.springframework: warn
    org.mybatis.spring.mapper: error
    org.apache.fury: warn
  config: classpath:logback-plus.xml

# 用户配置
user:
  password:
    # 密码最大错误次数
    maxRetryCount: 5
    # 密码锁定时间（默认10分钟）
    lockTime: 10

# Spring配置
spring:
  application:
    name: ${projectMetadata.projectName}
  threads:
    # 开启虚拟线程 仅jdk21可用
    virtual:
      enabled: false
  # 资源信息
  messages:
    # 国际化资源文件路径
    basename: i18n/messages
  profiles:
    active: @profiles.active@
  # 文件上传
  servlet:
    multipart:
      # 单个文件大小
      max-file-size: 10MB
      # 设置总上传的文件大小
      max-request-size: 20MB
  mvc:
    # 设置静态资源路径 防止所有请求都去查静态资源
    static-path-pattern: /static/**
    format:
      date-time: yyyy-MM-dd HH:mm:ss
  jackson:
    # 日期格式化
    date-format: yyyy-MM-dd HH:mm:ss
    serialization:
      # 格式化输出
      indent_output: false
      # 忽略无法转换的对象
      fail_on_empty_beans: false
    deserialization:
      # 允许对象忽略json中不存在的属性
      fail_on_unknown_properties: false

# Sa-Token配置
sa-token:
  # token名称 (同时也是cookie名称)
  token-name: Authorization
  # 是否允许同一账号并发登录 (为true时允许一起登录, 为false时新登录挤掉旧登录)
  is-concurrent: true
  # 在多人登录同一账号时，是否共用一个token (为true时所有登录共用一个token, 为false时每次登录新建一个token)
  is-share: false
  # jwt秘钥
  jwt-secret-key: abcdefghijklmnopqrstuvwxyz

# security配置
security:
  # 排除路径
  excludes:
    - /*.html
    - /**/*.html
    - /**/*.css
    - /**/*.js
    - /favicon.ico
    - /error
    - /*/api-docs
    - /*/api-docs/**
    - /warm-flow-ui/config

# 多租户配置
tenant:
  # 是否开启
  enable: true
  # 排除表
  excludes:
    - sys_menu
    - sys_tenant
    - sys_tenant_package
    - sys_role_dept
    - sys_role_menu
    - sys_user_post
    - sys_user_role
    - sys_client
    - sys_oss_config

# MyBatisPlus配置
# https://baomidou.com/config/
mybatis-plus:
  # 自定义配置 是否全局开启逻辑删除 关闭后 所有逻辑删除功能将失效
  enableLogicDelete: true
  # 多包名使用 例如 ${projectMetadata.groupId}.**.mapper,org.xxx.**.mapper
  mapperPackage: ${projectMetadata.groupId}.**.mapper
  # 对应的 XML 文件位置
  mapperLocations: classpath*:mapper/**/*Mapper.xml
  # 实体扫描，多个package用逗号或者分号分隔
  typeAliasesPackage: ${projectMetadata.groupId}.**.domain
  global-config:
    dbConfig:
      # 主键类型
      # AUTO 自增 NONE 空 INPUT 用户输入 ASSIGN_ID 雪花 ASSIGN_UUID 唯一 UUID
      # 如需改为自增 需要将数据库表全部设置为自增
      idType: ASSIGN_ID

# 数据加密
mybatis-encryptor:
  # 是否开启加密
  enable: false
  # 默认加密算法
  algorithm: BASE64
  # 编码方式 BASE64/HEX。默认BASE64
  encode: BASE64
  # 安全秘钥 对称算法的秘钥 如：AES，SM4
  password:
  # 公私钥 非对称算法的公私钥 如：SM2，RSA
  publicKey:
  privateKey:

# api接口加密
api-decrypt:
  # 是否开启全局接口加密
  enabled: true
  # AES 加密头标识
  headerFlag: encrypt-key
  # 响应加密公钥 非对称算法的公私钥 如：SM2，RSA 使用者请自行更换
  # 对应前端解密私钥 MIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAmc3CuPiGL/LcIIm7zryCEIbl1SPzBkr75E2VMtxegyZ1lYRD+7TZGAPkvIsBcaMs6Nsy0L78n2qh+lIZMpLH8wIDAQABAkEAk82Mhz0tlv6IVCyIcw/s3f0E+WLmtPFyR9/WtV3Y5aaejUkU60JpX4m5xNR2VaqOLTZAYjW8Wy0aXr3zYIhhQQIhAMfqR9oFdYw1J9SsNc+CrhugAvKTi0+BF6VoL6psWhvbAiEAxPPNTmrkmrXwdm/pQQu3UOQmc2vCZ5tiKpW10CgJi8kCIFGkL6utxw93Ncj4exE/gPLvKcT+1Emnoox+O9kRXss5AiAMtYLJDaLEzPrAWcZeeSgSIzbL+ecokmFKSDDcRske6QIgSMkHedwND1olF8vlKsJUGK3BcdtM8w4Xq7BpSBwsloE=
  publicKey: MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAJnNwrj4hi/y3CCJu868ghCG5dUj8wZK++RNlTLcXoMmdZWEQ/u02RgD5LyLAXGjLOjbMtC+/J9qofpSGTKSx/MCAwEAAQ==
  # 请求解密私钥 非对称算法的公私钥 如：SM2，RSA 使用者请自行更换
  # 对应前端加密公钥 MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKoR8mX0rGKLqzcWmOzbfj64K8ZIgOdHnzkXSOVOZbFu/TJhZ7rFAN+eaGkl3C4buccQd/EjEsj9ir7ijT7h96MCAwEAAQ==
  privateKey: MIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAqhHyZfSsYourNxaY7Nt+PrgrxkiA50efORdI5U5lsW79MmFnusUA355oaSXcLhu5xxB38SMSyP2KvuKNPuH3owIDAQABAkAfoiLyL+Z4lf4Myxk6xUDgLaWGximj20CUf+5BKKnlrK+Ed8gAkM0HqoTt2UZwA5E2MzS4EI2gjfQhz5X28uqxAiEA3wNFxfrCZlSZHb0gn2zDpWowcSxQAgiCstxGUoOqlW8CIQDDOerGKH5OmCJ4Z21v+F25WaHYPxCFMvwxpcw99EcvDQIgIdhDTIqD2jfYjPTY8Jj3EDGPbH2HHuffvflECt3Ek60CIQCFRlCkHpi7hthhYhovyloRYsM+IS9h/0BzlEAuO0ktMQIgSPT3aFAgJYwKpqRYKlLDVcflZFCKY7u3UP8iWi1Qw0Y=

springdoc:
  api-docs:
    # 是否开启接口文档
    enabled: true
  info:
    # 标题
    title: '标题：${projectMetadata.projectName}多租户管理系统_接口文档'
    # 描述
    description: '描述：${projectMetadata.description}'
    # 版本
    version: '版本号: ${projectMetadata.version}'
    # 作者信息
    contact:
      name: Lion Li
      email: crazylionli@163.com
      url: https://gitee.com/dromara/RuoYi-Vue-Plus
  components:
    # 鉴权方式配置
    security-schemes:
      apiKey:
        type: APIKEY
        in: HEADER
        name: ${sa-token.token-name}
  #这里定义了两个分组，可定义多个，也可以不定义
  group-configs:
    - group: 1.演示模块
      packages-to-scan: ${projectMetadata.groupId}.demo
    - group: 2.通用模块
      packages-to-scan: ${projectMetadata.groupId}.web
    - group: 3.系统模块
      packages-to-scan: ${projectMetadata.groupId}.system
    - group: 4.代码生成模块
      packages-to-scan: ${projectMetadata.groupId}.generator
    - group: 5.工作流模块
      packages-to-scan: ${projectMetadata.groupId}.workflow

# 防止XSS攻击
xss:
  # 过滤开关
  enabled: true
  # 排除链接（多个用逗号分隔）
  excludeUrls:
    - /system/notice

# 全局线程池相关配置
# 如使用JDK21请直接使用虚拟线程 不要开启此配置
thread-pool:
  # 是否开启线程池
  enabled: false
  # 队列最大长度
  queueCapacity: 128
  # 线程池维护线程所允许的空闲时间
  keepAliveSeconds: 300

--- # 分布式锁 lock4j 全局配置
lock4j:
  # 获取分布式锁超时时间，默认为 3000 毫秒
  acquire-timeout: 3000
  # 分布式锁的超时时间，默认为 30 秒
  expire: 30000

--- # Actuator 监控端点的配置项
management:
  endpoints:
    web:
      exposure:
        include: '*'
  endpoint:
    health:
      show-details: ALWAYS
    logfile:
      external-file: ./logs/sys-console.log

--- # 默认/推荐使用sse推送
sse:
  enabled: true
  path: /resource/sse

--- # websocket
websocket:
  # 如果关闭 需要和前端开关一起关闭
  enabled: false
  # 路径
  path: /resource/websocket
  # 设置访问源地址
  allowedOrigins: '*'

--- # warm-flow工作流配置
warm-flow:
  # 是否开启工作流，默认true
  enabled: true
  # 是否开启设计器ui
  ui: true
  # 默认Authorization，如果有多个token，用逗号分隔
  token-name: ${sa-token.token-name},clientid
  # 流程状态对应的三元色
  chart-status-color:
    ## 未办理
    - 62,62,62
    ## 待办理
    - 255,205,23
    ## 已办理
    - 157,255,0

--- # 数据源配置
spring:
  datasource:
    type: com.zaxxer.hikari.HikariDataSource
    # 动态数据源文档 https://www.kancloud.cn/tracy5546/dynamic-datasource/content
    dynamic:
      # 性能分析插件(有性能损耗 不建议生产环境使用)
      p6spy: true
      # 设置默认的数据源或者数据源组,默认值即为 master
      primary: master
      # 严格模式 匹配不到数据源则报错
      strict: true
      datasource:
        # 主库数据源
        master:
          type: ${spring.datasource.type}
          driverClassName: com.mysql.cj.jdbc.Driver
          # jdbc 所有参数配置参考 https://lionli.blog.csdn.net/article/details/122018562
          # rewriteBatchedStatements=true 批处理优化 大幅提升批量插入更新删除性能(对数据库有性能损耗 使用批量操作应考虑性能问题)
          url: jdbc:${infrastructureConfig.database.type}://${infrastructureConfig.database.host}:${infrastructureConfig.database.port}/${infrastructureConfig.database.databaseName}?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8&autoReconnect=true&rewriteBatchedStatements=true&allowPublicKeyRetrieval=true&nullCatalogMeansCurrent=true
          username: ${infrastructureConfig.database.username}
          password: ${infrastructureConfig.database.password}
      hikari:
        # 最大连接池数量
        maxPoolSize: 20
        # 最小空闲线程数量
        minIdle: 10
        # 配置获取连接等待超时的时间
        connectionTimeout: 30000
        # 校验超时时间
        validationTimeout: 5000
        # 空闲连接存活最大时间，默认10分钟
        idleTimeout: 600000
        # 此属性控制池中连接的最长生命周期，值0表示无限生命周期，默认30分钟
        maxLifetime: 1800000
        # 多久检查一次连接的活性
        keepaliveTime: 30000

--- # redis 单机配置(单机与集群只能开启一个另一个需要注释掉)
spring.data:
  redis:
    # 地址
    host: ${infrastructureConfig.redis.host}
    # 端口，默认为6379
    port: ${infrastructureConfig.redis.port}
    # 数据库索引
    database: ${infrastructureConfig.redis.database}
    # redis 密码必须配置
    password: ${infrastructureConfig.redis.password}
    # 连接超时时间
    timeout: 10s
    # 是否开启ssl
    ssl.enabled: false

# redisson 配置
redisson:
  # redis key前缀
  keyPrefix:
  # 线程池数量
  threads: 4
  # Netty线程池数量
  nettyThreads: 8
  # 单节点配置
  singleServerConfig:
    # 客户端名称 不能用中文
    clientName: ${projectMetadata.projectName}
    # 最小空闲连接数
    connectionMinimumIdleSize: 8
    # 连接池大小
    connectionPoolSize: 32
    # 连接空闲超时，单位：毫秒
    idleConnectionTimeout: 10000
    # 命令等待超时，单位：毫秒
    timeout: 3000
    # 发布和订阅连接池大小
    subscriptionConnectionPoolSize: 50