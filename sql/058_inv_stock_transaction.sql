-- ================================================================
-- 表：inv_stock_transaction（库存事务明细表）
-- 序号：058
-- 描述：库存台账的实时流水快照，记录每一次库存变动的明细行；与inv_material_transaction形成父子关系
-- ================================================================

CREATE TABLE inv_stock_transaction (
    id                      BIGINT          NOT NULL    PRIMARY KEY,
    transaction_no          VARCHAR(64)     NOT NULL    COMMENT '事务单号（关联inv_material_transaction.transaction_no）',
    transaction_id          BIGINT          NOT NULL    COMMENT '事务ID（关联inv_material_transaction.id）',
    stock_id                BIGINT          NOT NULL    COMMENT '库存台账ID（关联inv_stock.id）',
    warehouse_id            BIGINT          NOT NULL    COMMENT '仓库ID（关联mst_warehouse.id）',
    location_id             BIGINT          NULL        COMMENT '库位ID（关联mst_warehouse_location.id）',
    material_id             BIGINT          NOT NULL    COMMENT '物料ID（关联mst_item.id）',
    batch_no                VARCHAR(64)     NULL        COMMENT '批次号',
    transaction_type        VARCHAR(32)     NOT NULL    COMMENT '事务类型：RECEIVE/ISSUE/TRANSFER/ADJUST/COUNT/RETURN',
    quantity                DECIMAL(15,4)   NOT NULL    COMMENT '本行动作数量（正=入，负=出）',
    quantity_before         DECIMAL(15,4)   NOT NULL    COMMENT '操作前库存余额',
    quantity_after          DECIMAL(15,4)   NOT NULL    COMMENT '操作后库存余额',
    unit_code               VARCHAR(16)     NOT NULL    COMMENT '单位',
    price                   DECIMAL(15,4)   NULL        COMMENT '单价',
    amount                  DECIMAL(15,2)   NULL        COMMENT '金额',
    currency_code           VARCHAR(8)      NULL        DEFAULT 'CNY'  COMMENT '币种',
    reference_type          VARCHAR(32)     NULL        COMMENT '关联单据类型',
    reference_no            VARCHAR(64)     NULL        COMMENT '关联单据编号',
    reference_line_id       BIGINT          NULL        COMMENT '关联单据行ID',
    remark                  VARCHAR(256)    NULL        COMMENT '备注',
    created_by              VARCHAR(64)     NOT NULL    COMMENT '创建人',
    created_time            DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    modified_by             VARCHAR(64)     NULL        COMMENT '修改人',
    modified_time           DATETIME        NULL        COMMENT '修改时间',
    CONSTRAINT pk_inv_stock_transaction PRIMARY KEY (id)
) COMMENT '库存事务明细表';

-- Indexes
CREATE INDEX idx_st_transaction_no    ON inv_stock_transaction(transaction_no);
CREATE INDEX idx_st_transaction_id    ON inv_stock_transaction(transaction_id);
CREATE INDEX idx_st_stock_id          ON inv_stock_transaction(stock_id);
CREATE INDEX idx_st_material_id      ON inv_stock_transaction(material_id);
CREATE INDEX idx_st_warehouse_id     ON inv_stock_transaction(warehouse_id);
CREATE INDEX idx_st_created_time     ON inv_stock_transaction(created_time);
