-- ================================================================
-- SQL #007：mst_bom（Bill of Materials 表头）
-- APS开发文档 §2.2.2
-- ================================================================

-- ----------------------------
-- 表：mst_bom（BOM 表头）
-- ----------------------------
DROP TABLE IF EXISTS mst_bom;
CREATE TABLE mst_bom (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    bom_code        VARCHAR(50)     NOT NULL                        COMMENT 'BOM编码',
    bom_name        VARCHAR(200)    NOT NULL                        COMMENT 'BOM名称',
    item_id         BIGINT          NOT NULL                        COMMENT '产品/物料ID（外键→mst_item.id）',
    version         VARCHAR(20)     NOT NULL    DEFAULT 'V1.0'     COMMENT 'BOM版本',
    effective_date  DATE            NOT NULL                        COMMENT '生效日期',
    expired_date    DATE            NULL                             COMMENT '失效日期（NULL表示永久有效）',
    status          TINYINT         NOT NULL    DEFAULT 1           COMMENT '状态：0=草稿，1=生效，2=禁用',
    remark          VARCHAR(500)    NULL                             COMMENT '备注',
    created_by      VARCHAR(50)     NOT NULL                        COMMENT '创建人',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by      VARCHAR(50)     NULL                             COMMENT '更新人',
    updated_at      DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_bom_code_version (bom_code, version),
    KEY idx_item_id (item_id),
    KEY idx_effective_date (effective_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='BOM表头';

-- ----------------------------
-- 表：mst_bom_line（BOM 明细行）
-- ----------------------------
DROP TABLE IF EXISTS mst_bom_line;
CREATE TABLE mst_bom_line (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    bom_id          BIGINT          NOT NULL                        COMMENT 'BOM表头ID（外键→mst_bom.id）',
    line_no         INT             NOT NULL                        COMMENT '行号',
    component_id    BIGINT          NOT NULL                        COMMENT '子件物料ID（外键→mst_item.id）',
    qty_per         DECIMAL(18,6)   NOT NULL    DEFAULT 1          COMMENT '单位用量（每父件用量）',
    scrap_rate      DECIMAL(8,4)    NOT NULL    DEFAULT 0          COMMENT '报废率（%）',
    lead_time_days  DECIMAL(10,2)   NOT NULL    DEFAULT 0          COMMENT '采购/生产提前期（天）',
    is_optional     TINYINT         NOT NULL    DEFAULT 0           COMMENT '是否可选件：0=必选，1=可选',
    position_no     VARCHAR(50)     NULL                             COMMENT '位号（用于电子行业SMT）',
    remark          VARCHAR(500)    NULL                             COMMENT '备注',
    created_by      VARCHAR(50)     NOT NULL                        COMMENT '创建人',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by      VARCHAR(50)     NULL                             COMMENT '更新人',
    updated_at      DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_bom_id (bom_id),
    KEY idx_component_id (component_id),
    CONSTRAINT fk_bom_line_bom FOREIGN KEY (bom_id) REFERENCES mst_bom(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='BOM明细行';

-- ----------------------------
-- 示例数据
-- ----------------------------
INSERT INTO mst_bom (bom_code, bom_name, item_id, version, effective_date, status, created_by) VALUES
('BOM-A100', '成品A100标准BOM', 1, 'V1.0', '2026-01-01', 1, 'system'),
('BOM-A200', '成品A200标准BOM', 2, 'V1.0', '2026-01-01', 1, 'system');

INSERT INTO mst_bom_line (bom_id, line_no, component_id, qty_per, scrap_rate, lead_time_days, created_by) VALUES
(1, 1, 10, 2.0000, 0.0000, 0, 'system'),
(1, 2, 11, 1.0000, 0.0100, 5, 'system'),
(1, 3, 12, 4.0000, 0.0000, 3, 'system'),
(2, 1, 13, 1.5000, 0.0000, 0, 'system'),
(2, 2, 14, 2.0000, 0.0050, 7, 'system');
