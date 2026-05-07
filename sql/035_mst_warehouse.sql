-- ================================================================
-- 035_mst_warehouse.sql
-- 仓库与库位表（WH）
-- ================================================================

-- 仓库主数据表
CREATE TABLE mst_warehouse (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    wh_code             VARCHAR(64)     NOT NULL    COMMENT '仓库编码',
    wh_name             NVARCHAR(200)  NOT NULL    COMMENT '仓库名称',
    wh_type             TINYINT         NOT NULL    DEFAULT 1 COMMENT '仓库类型：1=原材料仓，2=成品仓，3=半成品仓，4=工具仓，5=废品仓',
    factory_id          BIGINT          NOT NULL    COMMENT '所属工厂ID',
    workshop_id         BIGINT          NULL        COMMENT '所属车间ID（可选）',
    address             NVARCHAR(500)   NULL        COMMENT '仓库地址',
    manager             VARCHAR(64)     NULL        COMMENT '仓库管理员',
    contact_phone       VARCHAR(20)     NULL        COMMENT '联系电话',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_wh_code (wh_code),
    KEY idx_factory_id  (factory_id),
    KEY idx_wh_type    (wh_type),
    KEY idx_is_active  (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='仓库主数据表';

-- 库位表（库位是仓库内的具体存放位置）
CREATE TABLE mst_location (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    location_code       VARCHAR(64)     NOT NULL    COMMENT '库位编码',
    location_name       NVARCHAR(200)  NOT NULL    COMMENT '库位名称',
    wh_id               BIGINT          NOT NULL    COMMENT '所属仓库ID',
    zone                VARCHAR(50)     NULL        COMMENT '库区（如A区/B区）',
    aisle               VARCHAR(50)     NULL        COMMENT '货架排',
    shelf               VARCHAR(50)     NULL        COMMENT '货架层',
    bin                 VARCHAR(50)     NULL        COMMENT '库位格',
    location_type       TINYINT         NOT NULL    DEFAULT 1 COMMENT '库位类型：1=存储位，2=拣货位，3=暂存位，4=质检位',
    max_capacity        DECIMAL(18,6)   NULL        COMMENT '最大容量',
    current_qty         DECIMAL(18,6)   NULL        DEFAULT 0 COMMENT '当前库存数量',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_location_code (location_code),
    KEY idx_wh_id      (wh_id),
    KEY idx_zone       (zone),
    KEY idx_is_active  (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库位表';

-- 仓库与成本中心关联
CREATE TABLE rel_warehouse_cost_center (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    wh_id               BIGINT          NOT NULL    COMMENT '仓库ID',
    cc_id               BIGINT          NOT NULL    COMMENT '成本中心ID',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_wh_cc (wh_id, cc_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='仓库与成本中心关联表';
