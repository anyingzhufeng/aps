-- ============================================================
-- 073 sch_dispatch_list_detail（排程调度清单明细表）
-- 记录每个调度指令（派工单）下的详细工序执行信息
-- 关联：sch_dispatch_list.id → 本表.dispatch_list_id
-- ============================================================

CREATE TABLE IF NOT EXISTS sch_dispatch_list_detail (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    dispatch_list_id    BIGINT          NOT NULL                    COMMENT '派工单ID（sch_dispatch_list.id）',
    operation_seq       INT             NOT NULL                    COMMENT '工序序号',
    work_order_id       BIGINT          NOT NULL                    COMMENT '工单ID（ord_work_order.id）',
    wo_operation_id     BIGINT          NOT NULL                    COMMENT '工单工序ID（ord_wo_operation.id）',
    resource_type       VARCHAR(32)     NOT NULL                    COMMENT '资源类型：MACHINE/WORKCENTER/LINE/STATION',
    resource_id         BIGINT          NOT NULL                    COMMENT '资源ID',
    resource_name       VARCHAR(128)    NULL                        COMMENT '资源名称（冗余）',
    planned_start       DATETIME        NOT NULL                    COMMENT '计划开始时间',
    planned_end         DATETIME        NOT NULL                    COMMENT '计划结束时间',
    planned_qty         DECIMAL(18,4)   NOT NULL                    COMMENT '计划数量',
    actual_start        DATETIME        NULL                        COMMENT '实际开始时间',
    actual_end          DATETIME        NULL                        COMMENT '实际结束时间',
    actual_qty          DECIMAL(18,4)   NULL                        COMMENT '实际完成数量',
    reject_qty          DECIMAL(18,4)   NULL                        COMMENT '不良数量',
    setup_minutes       INT             NULL                        COMMENT '换型/准备时间（分钟）',
    run_minutes         INT             NULL                        COMMENT '加工时间（分钟）',
    wait_minutes        INT             NULL                        COMMENT '等待时间（分钟）',
    transfer_minutes    INT             NULL                        COMMENT '搬运时间（分钟）',
    status              VARCHAR(16)     NOT NULL    DEFAULT 'PENDING'   COMMENT '状态：PENDING/READY/RUNNING/COMPLETED/PAUSED/CANCELLED',
    completion_rate      DECIMAL(5,2)    NULL        DEFAULT 0.00       COMMENT '完成率（%）',
    is_active           TINYINT(1)      NOT NULL    DEFAULT 1       COMMENT '是否有效',
    remark              VARCHAR(500)    NULL                        COMMENT '备注',
    created_by          VARCHAR(64)     NOT NULL                    COMMENT '创建人',
    created_at          DATETIME        NOT NULL                    COMMENT '创建时间',
    updated_by          VARCHAR(64)     NULL                        COMMENT '修改人',
    updated_at          DATETIME        NOT NULL                    COMMENT '修改时间',
    version             INT             NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='排程调度清单明细表';

-- 索引
CREATE INDEX idx_dispatch_list_id   ON sch_dispatch_list_detail(dispatch_list_id);
CREATE INDEX idx_wo_operation_id    ON sch_dispatch_list_detail(wo_operation_id);
CREATE INDEX idx_resource          ON sch_dispatch_list_detail(resource_type, resource_id);
CREATE INDEX idx_planned_start      ON sch_dispatch_list_detail(planned_start);
CREATE INDEX idx_status             ON sch_dispatch_list_detail(status);
