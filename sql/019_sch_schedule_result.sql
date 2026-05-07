-- ============================================================
-- 表：sch_schedule_result（排程结果）
-- 说明：记录排程引擎的执行结果，包含每个工序的时间窗口安排
-- 来源：APS 开发文档 第 21 张表
-- 序号：019
-- ============================================================

DROP TABLE IF EXISTS sch_schedule_result;

CREATE TABLE sch_schedule_result (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    schedule_batch_id   VARCHAR(50)     NOT NULL                    COMMENT '排程批次号（同一批次所有结果共享）',
    work_order_id       BIGINT          NOT NULL                    COMMENT '工单主键（ord_work_order.id）',
    wo_operation_id     BIGINT          NOT NULL                    COMMENT '工单工序主键（ord_wo_operation.id）',
    workcenter_id       BIGINT          NULL                        COMMENT '工作中心主键（mst_workcenter.id）',
    machine_id          BIGINT          NULL                        COMMENT '设备主键（mst_machine.id）',
    worker_id           BIGINT          NULL                        COMMENT '工人主键（mst_worker.id）',
    scheduled_start     DATETIME        NOT NULL                    COMMENT '排程开始时间',
    scheduled_end       DATETIME        NOT NULL                    COMMENT '排程结束时间',
    scheduled_qty       DECIMAL(18,4)   NOT NULL    DEFAULT 0        COMMENT '排程数量',
    -- 资源利用
    utilization_pct     DECIMAL(5,2)   NULL                        COMMENT '设备利用率（%）',
    idle_minutes        DECIMAL(10,2)   NULL                        COMMENT '空闲时间（分钟）',
    -- 甘特图专用
    gantt_color         VARCHAR(20)     NULL                        COMMENT '甘特图颜色（HEX）',
    gantt_row           INT             NULL                        COMMENT '甘特图行序号（视觉排版）',
    -- 约束满足标志
    constraint_satisfied VARCHAR(500)   NULL                        COMMENT '满足的约束条件（JSON摘要）',
    constraint_violated VARCHAR(500)    NULL                        COMMENT '违反的约束条件（JSON摘要）',
    -- 目标函数
    makespan_minutes    DECIMAL(10,2)   NULL                        COMMENT '该工序makespan贡献（分钟）',
    tardiness_minutes   DECIMAL(10,2)   NULL                        COMMENT '延迟分钟数（>0为延迟）',
    -- 执行状态
    status              VARCHAR(20)     NOT NULL    DEFAULT 'SCHEDULED' COMMENT '状态：SCHEDULED/FIRM/IN_PROGRESS/COMPLETED',
    -- 审计字段
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at          DATETIME        NULL                        COMMENT '软删除时间',

    PRIMARY KEY (id),
    -- 批次号查询
    KEY idx_ssr_batch (schedule_batch_id, created_at),
    -- 工单排程结果
    KEY idx_ssr_workorder (work_order_id),
    -- 按时间查询（甘特图加载）
    KEY idx_ssr_timerange (scheduled_start, scheduled_end),
    -- 延迟工序查询
    KEY idx_ssr_tardiness (tardiness_minutes),
    -- 设备负载视图
    KEY idx_ssr_machine (machine_id, scheduled_start, scheduled_end),
    -- 外键
    CONSTRAINT fk_ssr_workorder FOREIGN KEY (work_order_id)
        REFERENCES ord_work_order(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ssr_operation FOREIGN KEY (wo_operation_id)
        REFERENCES ord_wo_operation(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ssr_workcenter FOREIGN KEY (workcenter_id)
        REFERENCES mst_workcenter(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_ssr_machine FOREIGN KEY (machine_id)
        REFERENCES mst_machine(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='排程结果表'
;

-- 序号 19：sch_schedule_result（排程结果）
