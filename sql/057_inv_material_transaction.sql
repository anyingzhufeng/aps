-- ================================================================
-- 表：inv_material_transaction（物料事务表）
-- 序号：057
-- 描述：记录所有物料出入库、转移、盘点等事务流水，用于库存追溯与账务核对
-- ================================================================

CREATE TABLE inv_material_transaction (
    id                      BIGINT          NOT NULL    PRIMARY KEY,
    transaction_no          VARCHAR(64)     NOT NULL    COMMENT '事务单号',
    transaction_type        VARCHAR(32)     NOT NULL    COMMENT '事务类型：RECEIVE=入库，ISSUE=出库，TRANSFER=转移，ADJUST=调整，COUNT=盘点，RETURN=退料，TRANSFER_IN=调入，TRANSFER_OUT=调出',
    reference_type          VARCHAR(32)     NULL        COMMENT '关联单据类型：WO=工单，PO=采购单，SO=销售单，TRANSFER=调拨单，COUNT=盘点单，ADJUST=调整单',
    reference_no            VARCHAR(64)     NULL        COMMENT '关联单据编号',
    warehouse_id            BIGINT          NOT NULL    COMMENT '仓库ID（关联mst_warehouse.id）',
    location_id             BIGINT          NULL        COMMENT '库位ID（关联mst_warehouse_location.id）',
    material_id             BIGINT          NOT NULL    COMMENT '物料ID（关联mst_item.id）',
    batch_no                VARCHAR(64)     NULL        COMMENT '批次号',
    quantity                DECIMAL(15,4)   NOT NULL    COMMENT '事务数量（正数=入库，负数=出库）',
    quantity_before         DECIMAL(15,4)   NULL        COMMENT '变动前库存数量',
    quantity_after          DECIMAL(15,4)   NULL        COMMENT '变动后库存数量',
    unit_code               VARCHAR(16)     NOT NULL    COMMENT '单位',
    unit_cost               DECIMAL(15,4)   NULL        COMMENT '单位成本',
    total_cost              DECIMAL(15,4)   NULL        COMMENT '总成本',
    currency_code           VARCHAR(8)      NOT NULL    DEFAULT 'CNY' COMMENT '币种',
    exchange_rate           DECIMAL(15,6)   NOT NULL    DEFAULT 1.000000 COMMENT '汇率',
    transaction_date         DATE            NOT NULL    COMMENT '事务日期',
    transaction_time        DATETIME        NOT NULL    COMMENT '事务时间戳',
    direction               VARCHAR(16)     NOT NULL    COMMENT '方向：IN=入，OUT=出，MOVE=移动',
    from_warehouse_id       BIGINT          NULL        COMMENT '来源仓库（调拨/转移时）',
    from_location_id        BIGINT          NULL        COMMENT '来源库位（调拨/转移时）',
    to_warehouse_id         BIGINT          NULL        COMMENT '目标仓库（调拨/转移时）',
    to_location_id          BIGINT          NULL        COMMENT '目标库位（调拨/转移时）',
    work_order_id           BIGINT          NULL        COMMENT '关联工单ID（ord_work_order.id）',
    wo_operation_id         BIGINT          NULL        COMMENT '关联工序ID（ord_wo_operation.id）',
    machine_id              BIGINT          NULL        COMMENT '关联设备ID（mst_machine.id）',
    employee_id             BIGINT          NULL        COMMENT '操作员工ID',
    reason_code             VARCHAR(32)     NULL        COMMENT '事务原因代码',
    remark                  NVARCHAR(500)   NULL        COMMENT '备注',
    status                  VARCHAR(16)     NOT NULL    DEFAULT 'CONFIRMED' COMMENT '状态：PENDING=待确认，CONFIRMED=已确认，CANCELLED=已取消',
    is_reversed             TINYINT         NOT NULL    DEFAULT 0 COMMENT '是否被冲销',
    reverse_transaction_id BIGINT          NULL        COMMENT '冲销事务ID（自关联）',
    created_by              VARCHAR(64)     NULL,
    created_at              DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by              VARCHAR(64)     NULL,
    updated_at              DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_transaction_no (transaction_no),
    KEY idx_transaction_type (transaction_type),
    KEY idx_reference       (reference_type, reference_no),
    KEY idx_warehouse_id    (warehouse_id),
    KEY idx_material_id    (material_id),
    KEY idx_batch_no       (batch_no),
    KEY idx_transaction_date(transaction_date),
    KEY idx_work_order_id   (work_order_id),
    KEY idx_status          (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物料事务表';

-- 初始化说明
-- RECEIVE: 采购入库、工单完工入库、调拨入库
-- ISSUE: 工单领料、工单退料、调拨出库
-- TRANSFER: 库位转移（同一仓库内库位调整）
-- ADJUST: 盘点调整、报损报溢
-- COUNT: 盘点产生的差异确认
-- RETURN: 工单退料到线边仓
