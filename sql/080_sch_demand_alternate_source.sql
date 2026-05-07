-- =============================================
-- 序号：080
-- 表名：sch_demand_alternate_source（需求交替来源表）
-- 说明：记录每个调度需求的备选物料/产线来源，支持排程时多源备选
-- 作者：Claude Auto
-- 创建时间：2026-05-05
-- =============================================

CREATE TABLE sch_demand_alternate_source (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    demand_id           BIGINT           NOT NULL                        COMMENT '需求ID（关联sch_schedule_demand.id）',
    priority            INT              NOT NULL    DEFAULT 1           COMMENT '优先级（1=最高）',
    alternate_type      VARCHAR(16)      NOT NULL                        COMMENT '备选类型：MATERIAL/PRODUCT/LINE',
    alternate_code      VARCHAR(64)      NOT NULL                        COMMENT '备选编码（物料编码/产线编码）',
    substitute_ratio    DECIMAL(10,4)     NULL         DEFAULT 1.0000    COMMENT '替代比例（默认1.0）',
    extra_lead_time     INT              NULL         DEFAULT 0          COMMENT '额外提前期（小时）',
    enabled             TINYINT(1)       NOT NULL    DEFAULT 1          COMMENT '是否启用',
    created_by          VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version             INT              NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    KEY idx_demand (demand_id),
    KEY idx_priority (priority),
    KEY idx_enabled (enabled)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='需求交替来源表（多源备选）';
