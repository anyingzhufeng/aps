-- ============================================================
-- APS开发文档 · SQL文件 #061
-- 表名：mst_workshop（车间表）- 详细版
-- 说明：车间完整字段定义，包含区域、产能、状态等
-- 创建时间：2026-05-04 19:00
-- ============================================================

CREATE TABLE mst_workshop (
    id                BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    workshop_code     VARCHAR(50)  NOT NULL UNIQUE COMMENT '车间编码',
    workshop_name     VARCHAR(200) NOT NULL COMMENT '车间名称',
    factory_id        BIGINT       NOT NULL COMMENT '所属工厂ID',
    area_sqm          DECIMAL(10,2) COMMENT '面积（平方米）',
    capacity_units    INT          COMMENT '标准产能单位/小时',
    manager_id        BIGINT       COMMENT '车间负责人ID',
    contact_phone     VARCHAR(30)  COMMENT '联系电话',
    location_detail   VARCHAR(500) COMMENT '详细地址',
    latitude          DECIMAL(10,6) COMMENT '纬度',
    longitude         DECIMAL(10,6) COMMENT '经度',
    workshop_type     VARCHAR(30)  COMMENT '车间类型：assembly/production/packaging/warehouse',
    status            TINYINT DEFAULT 1 COMMENT '状态：0=禁用 1=启用',
    description       VARCHAR(1000) COMMENT '描述',
    created_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by        VARCHAR(100),
    updated_by        VARCHAR(100),
    is_deleted        TINYINT DEFAULT 0,
    version           INT DEFAULT 0,
    INDEX idx_factory (factory_id),
    INDEX idx_status (status),
    INDEX idx_code (workshop_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车间主数据表';

-- 初始数据：示例车间
INSERT INTO mst_workshop (workshop_code, workshop_name, factory_id, area_sqm, capacity_units, workshop_type, status) VALUES
('WS-A01', 'A区装配车间', 1, 1200.00, 200, 'assembly', 1),
('WS-B01', 'B区生产车间', 1, 2500.00, 500, 'production', 1),
('WS-C01', 'C区包装车间', 1, 800.00, 300, 'packaging', 1);
