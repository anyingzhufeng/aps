-- ================================================================
-- APS 生产排程系统 - 主数据：工艺路线
-- 文件：040_mst_routing.sql
-- 说明：工艺路线表头，定义每个产品/物料的标准生产工艺路线
-- 文档：APS开发文档 § 表清单 #011
-- ================================================================

-- ----------------------------
-- 表：mst_routing（工艺路线表头）
-- ----------------------------
DROP TABLE IF EXISTS mst_routing;
CREATE TABLE mst_routing (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '工艺路线ID',
    routing_code        VARCHAR(64)     NOT NULL                        COMMENT '工艺路线编码',
    routing_name        NVARCHAR(200)  NOT NULL                        COMMENT '工艺路线名称',
    item_id             BIGINT          NOT NULL                        COMMENT '关联产品/物料ID（外键→mst_item.id）',
    version             VARCHAR(20)     NOT NULL    DEFAULT 'v1.0'       COMMENT '版本号（如 v1.0/v2.0）',
    status              VARCHAR(20)     NOT NULL    DEFAULT 'ACTIVE'    COMMENT '状态：DRAFT-草稿/ACTIVE-激活/DEPRECATED-废弃',
    routing_type        VARCHAR(20)     NULL                            COMMENT '路线类型：STANDARD-标准/RAPID-快速/MAINTENANCE-维修',
    default_flag        TINYINT(1)      NOT NULL    DEFAULT 0           COMMENT '是否默认路线（1=默认，0=备选）',
    workcenter_id       BIGINT          NULL                            COMMENT '默认工作中心（外键→mst_workcenter.id）',
    total_std_hours     DECIMAL(8,2)    NULL                            COMMENT '标准总工时（小时）',
    total_std_yields    DECIMAL(8,2)    NULL                            COMMENT '标准产出数量',
    description         VARCHAR(1000)   NULL                            COMMENT '工艺说明',
    applicable_seasons  VARCHAR(200)    NULL                            COMMENT '适用季节（如 旺季/淡季）',
    effective_from      DATE            NULL                            COMMENT '生效日期',
    effective_to        DATE            NULL                            COMMENT '失效日期',
    approval_by         VARCHAR(100)    NULL                            COMMENT '审批人',
    approved_at         DATETIME        NULL                            COMMENT '审批时间',
    is_deleted          TINYINT(1)      NOT NULL    DEFAULT 0           COMMENT '软删除标记',
    version_num         INT             NOT NULL    DEFAULT 1           COMMENT '版本序号（每次修订+1）',
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by          VARCHAR(100)    NOT NULL    DEFAULT 'system'   COMMENT '创建人',
    updated_by          VARCHAR(100)    NOT NULL    DEFAULT 'system'   COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_routing_code_ver (routing_code, version),
    KEY idx_item_id (item_id, is_deleted),
    KEY idx_status (status, is_deleted),
    KEY idx_default_flag (item_id, default_flag),
    CONSTRAINT fk_routing_item FOREIGN KEY (item_id) REFERENCES mst_item(id),
    CONSTRAINT fk_routing_workcenter FOREIGN KEY (workcenter_id) REFERENCES mst_workcenter(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工艺路线表头';

-- ----------------------------
-- 示例数据
-- ----------------------------
INSERT INTO mst_routing (routing_code, routing_name, item_id, version, status, routing_type, default_flag, total_std_hours, effective_from) VALUES
('RT-P001-1.0', 'P001产品标准工艺路线', 1, 'v1.0', 'ACTIVE', 'STANDARD', 1, 4.50, '2026-01-01'),
('RT-P002-1.0', 'P002产品标准工艺路线', 2, 'v1.0', 'ACTIVE', 'STANDARD', 1, 6.00, '2026-01-01'),
('RT-P001-2.0', 'P001产品快速工艺路线', 1, 'v2.0', 'ACTIVE', 'RAPID', 0, 3.80, '2026-04-01');