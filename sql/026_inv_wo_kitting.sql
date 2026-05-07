-- ================================================================
-- SQL #026：inv_wo_kitting（工单齐套检查表）
-- APS开发文档 § 表清单 026
-- ================================================================

-- ----------------------------
-- 表：inv_wo_kitting（工单齐套检查主表）
-- ----------------------------
DROP TABLE IF EXISTS inv_wo_kitting;
CREATE TABLE inv_wo_kitting (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '齐套记录ID',
    work_order_id   BIGINT          NOT NULL                        COMMENT '工单ID（外键→ord_work_order.id）',
    check_time      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '检查时间',
    plan_start_date DATE            NULL                             COMMENT '计划开工日期',
    required_date   DATE            NULL                             COMMENT '需求交付日期',
    kitting_status  TINYINT         NOT NULL    DEFAULT 1           COMMENT '齐套状态：1=待检查 2=部分齐套 3=完全齐套 4=齐套不足',
    shortage_count  INT             NOT NULL    DEFAULT 0           COMMENT '缺料项数量',
    shortage_ratio  DECIMAL(5,2)    NOT NULL    DEFAULT 0.00        COMMENT '缺料比例(%)',
    ready_qty       INT             NOT NULL    DEFAULT 0           COMMENT '已备料数量',
    total_required  INT             NOT NULL    DEFAULT 0           COMMENT '需求总数',
    checked_by      VARCHAR(64)     NULL                             COMMENT '检查人',
    batch_no        VARCHAR(64)     NULL                             COMMENT '批次号',
    remark          VARCHAR(512)    NULL                             COMMENT '备注',
    created_by      VARCHAR(64)     NOT NULL    DEFAULT 'system'    COMMENT '创建人',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by      VARCHAR(64)     NOT NULL    DEFAULT 'system'    COMMENT '更新人',
    updated_at      DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted      TINYINT         NOT NULL    DEFAULT 0           COMMENT '软删除标记',
    PRIMARY KEY (id),
    KEY idx_kitting_wo (work_order_id),
    KEY idx_kitting_status (kitting_status),
    KEY idx_kitting_check_time (check_time),
    KEY idx_kitting_plan_date (plan_start_date),
    CONSTRAINT fk_kitting_wo FOREIGN KEY (work_order_id) REFERENCES ord_work_order(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工单齐套检查主表';

-- ----------------------------
-- 表：inv_wo_kitting_line（齐套明细行）
-- ----------------------------
DROP TABLE IF EXISTS inv_wo_kitting_line;
CREATE TABLE inv_wo_kitting_line (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '明细行ID',
    kitting_id      BIGINT          NOT NULL                        COMMENT '齐套记录ID（外键→inv_wo_kitting.id）',
    item_id         BIGINT          NOT NULL                        COMMENT '物料ID（外键→mst_item.id）',
    required_qty    DECIMAL(12,4)   NOT NULL                        COMMENT '需求数量',
    allocated_qty   DECIMAL(12,4)   NOT NULL    DEFAULT 0           COMMENT '已分配数量',
    available_qty   DECIMAL(12,4)   NOT NULL    DEFAULT 0           COMMENT '可用库存数量',
    shortage_qty    DECIMAL(12,4)   NOT NULL    DEFAULT 0           COMMENT '缺料数量',
    source_location_id BIGINT       NULL                             COMMENT '库存来源地点（外键→mst_location.id）',
    source_lot_no   VARCHAR(64)     NULL                             COMMENT '批次/批号',
    allocation_type TINYINT         NOT NULL    DEFAULT 1           COMMENT '分配方式：1=自动分配 2=手动指定',
    line_status     TINYINT         NOT NULL    DEFAULT 1           COMMENT '行状态：1=待配 2=已配 3=缺料 4=取消',
    fulfill_ratio   DECIMAL(5,2)    NOT NULL    DEFAULT 0.00        COMMENT '满足比例(%)',
    work_order_id   BIGINT          NOT NULL                        COMMENT '工单ID（冗余，便于查询）',
    bom_line_id     BIGINT          NULL                             COMMENT '来源BOM明细行ID（外键→mst_bom_line.id）',
    created_by      VARCHAR(64)     NOT NULL    DEFAULT 'system'    COMMENT '创建人',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by      VARCHAR(64)     NOT NULL    DEFAULT 'system'    COMMENT '更新人',
    updated_at      DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted      TINYINT         NOT NULL    DEFAULT 0           COMMENT '软删除标记',
    PRIMARY KEY (id),
    KEY idx_kitting_line_kitting (kitting_id),
    KEY idx_kitting_line_item (item_id),
    KEY idx_kitting_line_status (line_status),
    KEY idx_kitting_line_wo (work_order_id),
    CONSTRAINT fk_kitting_line_kitting FOREIGN KEY (kitting_id) REFERENCES inv_wo_kitting(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_kitting_line_item FOREIGN KEY (item_id) REFERENCES mst_item(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_kitting_line_location FOREIGN KEY (source_location_id) REFERENCES mst_location(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工单齐套检查明细行';