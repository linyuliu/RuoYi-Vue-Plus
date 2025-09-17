<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>${projectMetadata.artifactId}</artifactId>
        <groupId>${projectMetadata.groupId}</groupId>
        <version>${projectMetadata.version}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <modules>
<#if backendConfig.modulesToKeep?seq_contains("ruoyi-demo")>
        <module>ruoyi-demo</module>
</#if>
<#if backendConfig.modulesToKeep?seq_contains("ruoyi-generator")>
        <module>ruoyi-generator</module>
</#if>
<#if backendConfig.modulesToKeep?seq_contains("ruoyi-job")>
        <module>ruoyi-job</module>
</#if>
<#if backendConfig.modulesToKeep?seq_contains("ruoyi-system")>
        <module>ruoyi-system</module>
</#if>
<#if backendConfig.modulesToKeep?seq_contains("ruoyi-workflow")>
        <module>ruoyi-workflow</module>
</#if>
    </modules>

    <artifactId>ruoyi-modules</artifactId>
    <packaging>pom</packaging>

    <description>
        ruoyi-modules 业务模块
    </description>

</project>