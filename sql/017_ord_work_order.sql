-- ================================================================
-- APS 生产排程系统 - 业务数据：工单主数据
-- 文件：017_ord_work_order.sql
-- 说明：工单主数据表，记录生产工单的核心信息
-- ================================================================

-- ----------------------------
-- 表：ord_work_order（工单主数据）
-- ----------------------------
CREATE TABLE IF NOT EXISTS ord_work_order (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    order_no        VARCHAR(64)     NOT NULL                    COMMENT '工单编号（系统生成，格式：WO+YYYYMMDD+6位序号）',
    priority        TINYINT         NOT NULL    DEFAULT 3       COMMENT '优先级（1=紧急，2=高，3=普通，4=低）',
    status          VARCHAR(32)     NOT NULL    DEFAULT 'PENDING' COMMENT '工单状态',
    factory_id      BIGINT          NOT NULL                    COMMENT '工厂ID',
    workshop_id     BIGINT          NULL                        COMMENT '车间ID',
    workcenter_id   BIGINT          NULL                        COMMENT '工作中心ID',
    item_id         BIGINT          NOT NULL                    COMMENT '产品/物料ID（关联mst_item）',
    bom_id          BIGINT          NULL                        COMMENT 'BOM版本ID（关联mst_bom）',
    routing_id      BIGINT          NULL                        COMMENT '工艺路线ID（关联mst_routing）',
    qty_plan        DECIMAL(18,4)   NOT NULL    DEFAULT 0        COMMENT '计划数量',
    qty_finished    DECIMAL(18,4)   NOT NULL    DEFAULT 0        COMMENT '完工数量',
    qty_rejected    DECIMAL(18,4)   NOT NULL    DEFAULT 0        COMMENT '报废数量',
    unit_cost       DECIMAL(18,4)   NULL                        COMMENT '单位成本',
    total_cost      DECIMAL(18,4)   NULL                        COMMENT '总成本',
    date_start      DATE            NULL                        COMMENT '计划开始日期',
    date_due        DATE            NOT NULL                    COMMENT '截止日期',
    date_finished   DATETIME        NULL                        COMMENT '实际完工时间',
    warehouse_id    BIGINT          NULL                        COMMENT '投料仓库ID',
    location_id     BIGINT          NULL                        COMMENT '投料工位ID',
    remarks         TEXT            NULL                        COMMENT '备注',
    ext_attrs       JSON            NULL                        COMMENT '扩展属性（JSON）',
    version         INT             NOT NULL    DEFAULT 0        COMMENT '乐观锁版本号',
    is_deleted      TINYINT(1)      NOT NULL    DEFAULT 0        COMMENT '软删除标记',
    created_by      VARCHAR(64)     NOT NULL                    COMMENT '创建人',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by      VARCHAR(64)     NULL                        COMMENT '更新人',
    updated_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_order_no (order_no),
    KEY idx_status (status),
    KEY idx_priority (priority),
    KEY idx_date_due (date_due),
    KEY idx_factory_workshop (factory_id, workshop_id),
    KEY idx_item_id (item_id),
    KEY idx_bom_id (bom_id),
    KEY idx_routing_id (routing_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工单主数据表';

-- ----------------------------
-- 表：ord_wo_operation（工单工序明细）
-- ----------------------------
CREATE TABLE IF NOT EXISTS ord_wo_operation (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    work_order_id       BIGINT          NOT NULL                    COMMENT '工单ID（关联ord_work_order）',
    operation_seq       INT             NOT NULL    DEFAULT 0        COMMENT '工序顺序号',
    workcenter_id       BIGINT          NULL                        COMMENT '工作中心ID（可动态分配）',
    machine_id          BIGINT          NULL                        COMMENT '设备ID（可动态分配）',
    std_time_minutes    DECIMAL(10,2)   NULL                        COMMENT '标准工时（分钟）',
    setup_time_minutes  DECIMAL(10,2)   NULL                        COMMENT '准备时间（分钟）',
    process_time_minutes DECIMAL(10,2)  NULL                        COMMENT '加工时间（分钟）',
    wait_time_minutes   DECIMAL(10,2)   NULL                        DEFAULT 0        COMMENT '等待时间（分钟）',
    move_time_minutes   DECIMAL(10,2)   NULL                        DEFAULT 0        COMMENT '搬运时间（分钟）',
    qty_input           DECIMAL(18,4)   NOT NULL    DEFAULT 0        COMMENT '投入数量',
    qty_output          DECIMAL(18,4)   NOT NULL    DEFAULT 0        COMMENT '产出数量',
    qty_rejected        DECIMAL(18,4)   NOT NULL    DEFAULT 0        COMMENT '报废数量',
    date_start_plan     DATETIME        NULL                        COMMENT '计划开始时间',
    date_end_plan       DATETIME        NULL                        COMMENT '计划结束时间',
    date_start_actual   DATETIME        NULL                        COMMENT '实际开始时间',
    date_end_actual     DATETIME        NULL                        COMMENT '实际结束时间',
    status              VARCHAR(32)     NOT NULL    DEFAULT 'PENDING' COMMENT '状态',
    worker_id           BIGINT          NULL                        COMMENT '作业人员ID',
    remarks             TEXT            NULL                        COMMENT '备注',
    ext_attrs           JSON            NULL                        COMMENT '扩展属性',
    version             INT             NOT NULL    DEFAULT 0        COMMENT '乐观锁版本号',
    is_deleted          TINYINT(1)      NOT NULL    DEFAULT 0        COMMENT '软删除标记',
    created_by          VARCHAR(64)     NOT NULL                    COMMENT '创建人',
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)     NULL                        COMMENT '更新人',
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_work_order_id (work_order_id),
    KEY idx_operation_seq (work_order_id, operation_seq),
    KEY idx_status (status),
    KEY idx_date_start_plan (date_start_plan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工单工序明细表';