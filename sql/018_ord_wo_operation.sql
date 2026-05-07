-- ============================================================
-- 表：ord_wo_operation（工单工序明细）
-- 说明：记录工单的各道工序执行信息，是排程引擎的核心操作对象
-- 来源：APS 开发文档 第 20 张表
-- 序号：018
-- ============================================================

DROP TABLE IF EXISTS ord_wo_operation;

CREATE TABLE ord_wo_operation (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    work_order_id       BIGINT          NOT NULL                    COMMENT '工单主键（ord_work_order.id）',
    operation_seq       INT             NOT NULL                    COMMENT '工序序号（工单内顺序）',
    routing_operation_id BIGINT         NULL                        COMMENT '工艺路线工序主键（mst_routing_op.id）',
    workcenter_id       BIGINT          NULL                        COMMENT '工作中心主键（mst_workcenter.id）',
    machine_id          BIGINT          NULL                        COMMENT '设备主键（mst_machine.id）',
    skill_id            BIGINT          NULL                        COMMENT '所需技能主键（mst_skill.id）',
    planned_qty         DECIMAL(18,4)   NOT NULL    DEFAULT 0        COMMENT '计划加工数量',
    allocated_qty       DECIMAL(18,4)   NOT NULL    DEFAULT 0        COMMENT '已分配数量',
    completed_qty       DECIMAL(18,4)   NOT NULL    DEFAULT 0        COMMENT '已完成数量',
    status              VARCHAR(20)     NOT NULL    DEFAULT 'PENDING' COMMENT '状态：PENDING/PROCESSING/COMPLETED/HOLD',
    priority            INT             NOT NULL    DEFAULT 100       COMMENT '优先级（越小越高）',
    -- 时间窗口
    planned_start       DATETIME        NULL                        COMMENT '计划开始时间',
    planned_end         DATETIME        NULL                        COMMENT '计划结束时间',
    scheduled_start     DATETIME        NULL                        COMMENT '排程开始时间（引擎计算）',
    scheduled_end       DATETIME        NULL                        COMMENT '排程结束时间（引擎计算）',
    actual_start        DATETIME        NULL                        COMMENT '实际开始时间',
    actual_end          DATETIME        NULL                        COMMENT '实际结束时间',
    -- 加工参数
    unit_time_minutes   DECIMAL(10,2)   NULL                        COMMENT '单件加工时间（分钟）',
    setup_minutes       DECIMAL(10,2)   NULL                        COMMENT '换型准备时间（分钟）',
    teardown_minutes    DECIMAL(10,2)   NULL                        COMMENT '拆卸清理时间（分钟）',
    -- 产出参数
    output_item_id      BIGINT          NULL                        COMMENT '产出物料主键（mst_item.id）',
    output_ratio        DECIMAL(10,4)   NULL                        COMMENT '产出比例（默认1）',
    -- 异常跟踪
    exception_flag      TINYINT(1)      NOT NULL    DEFAULT 0        COMMENT '异常标记（0正常/1异常）',
    exception_desc      VARCHAR(500)    NULL                        COMMENT '异常描述',
    -- 审计字段
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at          DATETIME        NULL                        COMMENT '软删除时间',

    PRIMARY KEY (id),
    -- 工单+工序唯一索引
    UNIQUE KEY uk_woo_workorder_seq (work_order_id, operation_seq),
    -- 状态查询索引
    KEY idx_woo_workcenter_status (workcenter_id, status),
    -- 排程时间窗口查询索引
    KEY idx_woo_scheduled_start (scheduled_start),
    -- 工单状态索引
    KEY idx_woo_workorder_status (work_order_id, status),
    -- 设备负载索引
    KEY idx_woo_machine (machine_id, scheduled_start, scheduled_end),
    -- 外键（逻辑约束，MySQL InnoDB在运行时检查）
    CONSTRAINT fk_woo_workorder FOREIGN KEY (work_order_id)
        REFERENCES ord_work_order(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_woo_workcenter FOREIGN KEY (work_center_id)
        REFERENCES mst_workcenter(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_woo_machine FOREIGN KEY (machine_id)
        REFERENCES mst_machine(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_woo_routingop FOREIGN KEY (routing_operation_id)
        REFERENCES mst_routing_op(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='工单工序明细表'
;

-- 序号 20：ord_wo_operation（工单工序明细）
