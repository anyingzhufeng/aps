-- ==============================================================
-- 059 inv_material_allocation（库存预留/分配表）
-- APS系统物料预留记录，跟踪每个工单/工序对物料的预留占用
-- ==============================================================

USE aps_db;

CREATE TABLE IF NOT EXISTS inv_material_allocation (
    id                      BIGINT          NOT NULL        AUTO_INCREMENT COMMENT '主键',
    allocation_no           VARCHAR(64)     NOT NULL        COMMENT '预留单号（ALL+yyyyMMdd+6位序号）',
    allocation_type         VARCHAR(16)     NOT NULL        COMMENT '预留类型：WO=工单预留，KIT=齐料预留，MANUAL=手动预留',
    priority                INT             NOT NULL        DEFAULT 5     COMMENT '优先级（1=最高）',
    work_order_id           BIGINT          NULL            COMMENT '工单ID（ord_work_order.id）',
    wo_operation_id         BIGINT          NULL            COMMENT '工序ID（ord_wo_operation.id）',
    schedule_date           DATE            NULL            COMMENT '需求日期/排产日期',
    warehouse_id            BIGINT          NOT NULL        COMMENT '仓库ID（关联mst_warehouse.id）',
    location_id             BIGINT          NULL            COMMENT '库位ID（关联mst_warehouse_location.id）',
    material_id             BIGINT          NOT NULL        COMMENT '物料ID（关联mst_item.id）',
    batch_no                VARCHAR(64)     NULL            COMMENT '批次号',
    requested_qty           DECIMAL(15,4)   NOT NULL        COMMENT '需求数量',
    allocated_qty           DECIMAL(15,4)   NOT NULL        DEFAULT 0    COMMENT '已分配数量',
    picked_qty              DECIMAL(15,4)   NOT NULL        DEFAULT 0    COMMENT '已拣货数量',
    consumed_qty            DECIMAL(15,4)   NOT NULL        DEFAULT 0    COMMENT '已消耗数量',
    returned_qty             DECIMAL(15,4)   NOT NULL        DEFAULT 0    COMMENT '已退回数量',
    unit_code               VARCHAR(16)     NOT NULL        COMMENT '单位',
    status                  VARCHAR(16)     NOT NULL        DEFAULT 'PENDING' COMMENT '状态：PENDING=待分配，PARTIAL=部分分配，ALLOCATED=已分配，PICKED=已拣货，CONSUMED=已消耗，RELEASED=已释放，CANCELLED=已取消',
    expire_time             DATETIME        NULL            COMMENT '过期时间（超过则自动释放）',
    work_order_no           VARCHAR(64)     NULL            COMMENT '关联工单编号（冗余）',
    material_code           VARCHAR(64)     NULL            COMMENT '物料编码（冗余）',
    material_name           VARCHAR(256)    NULL            COMMENT '物料名称（冗余）',
    remark                  VARCHAR(500)    NULL            COMMENT '备注',
    created_by              VARCHAR(64)     NOT NULL        COMMENT '创建人',
    created_time            DATETIME        NOT NULL        DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    modified_by             VARCHAR(64)     NULL            COMMENT '修改人',
    modified_time           DATETIME        NULL            COMMENT '修改时间',
    version                 INT             NOT NULL        DEFAULT 0     COMMENT '乐观锁版本号',
    CONSTRAINT pk_inv_material_allocation PRIMARY KEY (id),
    CONSTRAINT uk_allocation_no UNIQUE (allocation_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物料预留分配表';

-- Indexes
CREATE INDEX idx_alloc_work_order    ON inv_material_allocation(work_order_id);
CREATE INDEX idx_alloc_wo_operation ON inv_material_allocation(wo_operation_id);
CREATE INDEX idx_alloc_material      ON inv_material_allocation(material_id);
CREATE INDEX idx_alloc_warehouse    ON inv_material_allocation(warehouse_id);
CREATE INDEX idx_alloc_status       ON inv_material_allocation(status);
CREATE INDEX idx_alloc_type         ON inv_material_allocation(allocation_type);
CREATE INDEX idx_alloc_schedule_date ON inv_material_allocation(schedule_date);
CREATE INDEX idx_alloc_priority     ON inv_material_allocation(priority);
CREATE INDEX idx_alloc_expire       ON inv_material_allocation(expire_time);
CREATE INDEX idx_alloc_no           ON inv_material_allocation(allocation_no);
