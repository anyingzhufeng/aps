-- ================================================================
-- SQL #008：mst_item（物料/产品主数据表）
-- APS开发文档 §2.2.2
-- ================================================================

-- ----------------------------
-- 表：mst_item（物料/产品主数据）
-- ----------------------------
DROP TABLE IF EXISTS mst_item;
CREATE TABLE mst_item (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    item_code           VARCHAR(50)     NOT NULL                        COMMENT '物料编码',
    item_name           VARCHAR(200)    NOT NULL                        COMMENT '物料名称',
    item_type           VARCHAR(20)     NOT NULL                        COMMENT '物料类型：RAW=原材料，SEMI=半成品，FG=成品，SUB=委外件',
    item_category       VARCHAR(50)     NOT NULL                        COMMENT '物料类别',
    unit                VARCHAR(20)     NOT NULL    DEFAULT 'PCS'       COMMENT '计量单位',
    std_cost            DECIMAL(18,4)   NOT NULL    DEFAULT 0          COMMENT '标准成本',
    std_lead_time       DECIMAL(10,2)   NOT NULL    DEFAULT 0          COMMENT '标准采购/生产提前期（天）',
    min_stock           DECIMAL(18,4)   NOT NULL    DEFAULT 0          COMMENT '最小库存量（安全库存）',
    max_stock           DECIMAL(18,4)   NULL                             COMMENT '最大库存量',
    reorder_qty         DECIMAL(18,4)   NULL                             COMMENT '再订货点',
    stock_unit          VARCHAR(20)     NOT NULL    DEFAULT 'PCS'       COMMENT '库存计量单位',
    item_spec           VARCHAR(500)    NULL                             COMMENT '规格型号',
    supplier_id         BIGINT          NULL                             COMMENT '默认供应商ID（外键→mst_supplier.id）',
    is_serial_managed   TINYINT         NOT NULL    DEFAULT 0          COMMENT '是否序列号管理',
    is_batch_managed    TINYINT         NOT NULL    DEFAULT 0          COMMENT '是否批次管理',
    status              TINYINT         NOT NULL    DEFAULT 1          COMMENT '状态：0=禁用，1=启用',
    remark              VARCHAR(500)    NULL                             COMMENT '备注',
    created_by          VARCHAR(50)     NOT NULL                        COMMENT '创建人',
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(50)     NULL                             COMMENT '更新人',
    updated_at          DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_item_code (item_code),
    KEY idx_item_type (item_type),
    KEY idx_item_category (item_category),
    KEY idx_supplier_id (supplier_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物料/产品主数据';

-- ----------------------------
-- 示例数据
-- ----------------------------
INSERT INTO mst_item (item_code, item_name, item_type, item_category, unit, std_cost, std_lead_time, min_stock, status, created_by) VALUES
('ITEM-RAW-001', 'PCB电路板A型', 'RAW', '电子元器', 'PCS', 25.0000, 7, 100, 1, 'system'),
('ITEM-RAW-002', '电容100uF', 'RAW', '电子元器', 'PCS', 0.5000, 3, 500, 1, 'system'),
('ITEM-RAW-003', '外壳组件B型', 'RAW', '结构件', 'PCS', 15.0000, 5, 50, 1, 'system'),
('ITEM-SEMI-001', '焊接半成品A', 'SEMI', '半成品', 'PCS', 45.0000, 0, 0, 1, 'system'),
('ITEM-FG-001', '成品A100', 'FG', '成品', 'PCS', 120.0000, 0, 20, 1, 'system'),
('ITEM-FG-002', '成品A200', 'FG', '成品', 'PCS', 200.0000, 0, 15, 1, 'system');
