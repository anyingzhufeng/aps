-- ================================================================
-- SQL #006：mst_product（产品/物料主数据表）
-- APS开发文档 §5.1.6
-- ================================================================

-- ----------------------------
-- 表：mst_product（产品/物料主数据）
-- ----------------------------
DROP TABLE IF EXISTS mst_product;
CREATE TABLE mst_product (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    product_code        VARCHAR(50)     NOT NULL                        COMMENT '产品编码',
    product_name        VARCHAR(200)    NOT NULL                        COMMENT '产品名称',
    product_category    VARCHAR(50)     NOT NULL                        COMMENT '产品类别（电子元器/结构件/成品等）',
    unit                VARCHAR(20)     NOT NULL    DEFAULT 'PCS'      COMMENT '计量单位',
    bom_version         VARCHAR(20)     NULL                             COMMENT 'BOM版本号',
    std_cost            DECIMAL(18,4)   NOT NULL    DEFAULT 0          COMMENT '标准成本',
    std_cycle_time      DECIMAL(10,2)   NOT NULL    DEFAULT 0          COMMENT '标准生产周期（小时）',
    min_lot_size        INT             NOT NULL    DEFAULT 1           COMMENT '最小批量',
    max_lot_size        INT             NULL                             COMMENT '最大批量',
    shelf_life_days     INT             NULL                             COMMENT '保质期（天）',
    is_active           TINYINT(1)      NOT NULL    DEFAULT 1           COMMENT '是否启用（1=是，0=否）',
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by          VARCHAR(100)    NOT NULL    DEFAULT 'system'    COMMENT '创建人',
    updated_by          VARCHAR(100)    NOT NULL    DEFAULT 'system'   COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_product_code (product_code),
    KEY idx_product_category (product_category),
    KEY idx_product_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品/物料主数据表';

-- ----------------------------
-- 种子数据：产品
-- ----------------------------
INSERT INTO mst_product (product_code, product_name, product_category, unit, std_cost, std_cycle_time, min_lot_size, max_lot_size) VALUES
-- 电子产品
('PROD-PCB-001',  'PCB主板 V2.1',       '电子元器',  'PCS',   128.5000,  2.50,   10,     500),
('PROD-SMT-001', 'SMT贴片组件 A1',     '电子元器',  'PCS',   45.2000,   1.20,   20,     1000),
('PROD-ASM-001', '装配半成品 B1',      '半成品',    'PCS',   230.0000,  3.00,   5,      200),
('PROD-FG-001',  '成品主机 X100',     '成品',      'PCS',   1580.0000, 1.00,   1,      50),
('PROD-FG-002',  '成品配件包 Y20',    '成品',      'SET',   320.0000,  0.50,   5,      100),
-- 结构件
('PROD-CASE-001','塑料外壳 C型',       '结构件',    'PCS',   18.5000,   0.30,   50,     2000),
('PROD-SCREW-001','螺丝套装 M3',      '结构件',    'SET',   2.5000,    0.10,   100,    5000),
('PROD-CABLE-001','线束组件 W1',      '结构件',    'PCS',   12.8000,   0.40,   30,     1000),
('PROD-DISP-001','显示屏模组 D7',     '电子元器',  'PCS',   280.0000,  0.80,   5,      200),
('PROD-PACK-001','包装盒 P1',         '包装材料',  'PCS',   1.5000,    0.05,   200,    10000);
