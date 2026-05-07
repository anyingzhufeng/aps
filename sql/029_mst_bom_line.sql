-- ================================================================
-- APS 生产排程系统 - 主数据：BOM明细行
-- 文件：029_mst_bom_line.sql
-- 说明：BOM（物料清单）明细行，记录每个父项物料的子项构成
-- 参考：APS开发文档 §2.2.2 §8.1 表清单 #10
-- ================================================================

-- ----------------------------
-- 表：mst_bom_line（BOM 明细行）
-- ----------------------------
DROP TABLE IF EXISTS mst_bom_line;
CREATE TABLE mst_bom_line (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    bom_id              BIGINT          NOT NULL                        COMMENT 'BOM表头ID（外键→mst_bom.id）',
    item_id             BIGINT          NOT NULL                        COMMENT '子项物料ID（外键→mst_item.id）',
    line_no             INT             NOT NULL                        COMMENT '行序号',
    qty_per_unit        DECIMAL(18,6)   NOT NULL    DEFAULT 1.0000      COMMENT '每单位父项用量',
    loss_rate           DECIMAL(8,4)    NOT NULL    DEFAULT 0           COMMENT '损耗率（0~1，如0.05=5%）',
    is_critical         TINYINT(1)      NOT NULL    DEFAULT 0           COMMENT '是否关键件：0=否，1=是',
    is_optional         TINYINT(1)      NOT NULL    DEFAULT 0           COMMENT '是否选配件：0=否，1=是',
    scrap_rate          DECIMAL(8,4)    NOT NULL    DEFAULT 0           COMMENT '报废率（0~1）',
    phantom_flag        TINYINT(1)      NOT NULL    DEFAULT 0           COMMENT '幽灵件标识：0=否，1=是（不参与库存）',
    backflush_flag      TINYINT(1)      NOT NULL    DEFAULT 0           COMMENT '倒冲发料：0=否，1=是',
    lead_time_offset    INT             NOT NULL    DEFAULT 0           COMMENT '提前期偏移（天）',
    effective_date      DATE            NOT NULL                        COMMENT '生效日期',
    obsolete_date       DATE            NULL                             COMMENT '失效日期',
    remark              VARCHAR(500)    NULL                             COMMENT '备注',
    version             INT             NOT NULL    DEFAULT 0           COMMENT '乐观锁版本号',
    is_deleted          TINYINT(1)      NOT NULL    DEFAULT 0           COMMENT '软删除标记',
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by          VARCHAR(100)    NOT NULL    DEFAULT 'system'   COMMENT '创建人',
    updated_by          VARCHAR(100)    NOT NULL    DEFAULT 'system'   COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_bom_line (bom_id, item_id, line_no),
    INDEX idx_bom_line_item (item_id),
    INDEX idx_bom_line_effective (effective_date, obsolete_date),
    CONSTRAINT fk_bom_line_bom FOREIGN KEY (bom_id)  REFERENCES mst_bom(id)     ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_bom_line_item FOREIGN KEY (item_id) REFERENCES mst_item(id)   ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BOM明细行表';
