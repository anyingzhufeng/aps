-- ============================================================
-- APS开发文档 · SQL文件 #062
-- 表名：mst_workshop_area（车间区域表）
-- 说明：记录车间内部分区信息，如组装区、焊接区、检验区等
-- 创建时间：2026-05-04 20:00
-- ============================================================

CREATE TABLE mst_workshop_area (
    id                BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    area_code         VARCHAR(50)  NOT NULL COMMENT '区域编码',
    area_name         VARCHAR(200) NOT NULL COMMENT '区域名称',
    workshop_id       BIGINT       NOT NULL COMMENT '所属车间ID（mst_workshop.id）',
    area_type        VARCHAR(32)  COMMENT '区域类型：ASSEMBLY/WELDING/INSPECTION/PACKING/STORAGE/OTHER',
    floor_no          INT          COMMENT '楼层号',
    building_no       VARCHAR(16)  COMMENT '建筑编号',
    area_sqm          DECIMAL(10,2) COMMENT '面积（平方米）',
    capacity_units    INT          COMMENT '标准产能单位/小时',
    worker_count      INT          COMMENT '标准人员数',
    equipment_ids     VARCHAR(500) COMMENT '关联设备ID列表（JSON数组）',
    parent_area_id    BIGINT       COMMENT '父区域ID（支持多级嵌套）',
    level_no          INT          DEFAULT 1 COMMENT '层级深度（1=一级区域）',
    sort_order        INT          DEFAULT 0 COMMENT '排序序号',
    status            VARCHAR(16)  NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE/INACTIVE/MAINTENANCE',
    description       VARCHAR(500) COMMENT '区域说明',
    created_by        VARCHAR(64)  NOT NULL COMMENT '创建人',
    created_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by        VARCHAR(64)  COMMENT '修改人',
    updated_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version           INT          NOT NULL DEFAULT 0 COMMENT '乐观锁版本号',
    UNIQUE KEY uk_area_code (area_code),
    KEY idx_workshop_id (workshop_id),
    KEY idx_parent_area_id (parent_area_id),
    KEY idx_area_type (area_type),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车间区域表';