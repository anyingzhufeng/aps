-- ================================================================
-- APS 生产排程系统 - 排程数据：派工单明细
-- 文件：075_sch_dispatch_list_detail.sql
-- 说明：派工单明细表，记录每个派工单下的工序明细及实际执行信息
-- ================================================================

-- ----------------------------
-- 表：sch_dispatch_list_detail（派工单明细）
-- ----------------------------
DROP TABLE IF EXISTS sch_dispatch_list_detail;
CREATE TABLE sch_dispatch_list_detail (
    id                      BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    dispatch_id             BIGINT           NOT NULL                        COMMENT '派工单ID（外键→sch_dispatch_list.id）',
    wo_operation_id         BIGINT           NOT NULL                        COMMENT '工单工序ID（外键→ord_wo_operation.id）',
    sequence_no             INT              NOT NULL    DEFAULT 1           COMMENT '明细顺序号',
    dispatch_qty            DECIMAL(18,4)    NOT NULL                        COMMENT '派工数量',
    dispatched_resource_id  BIGINT           NULL                            COMMENT '派工资源ID（设备/工位/产线）',
    dispatched_resource_type VARCHAR(32)     NULL                            COMMENT '资源类型：MACHINE/WORKCENTER/LINE/STATION',
    dispatched_resource_name VARCHAR(128)    NULL                            COMMENT '资源名称',
    plan_start_time         DATETIME         NULL                            COMMENT '计划开始时间',
    plan_end_time           DATETIME         NULL                            COMMENT '计划结束时间',
    plan_duration_minutes   INT              NULL                            COMMENT '计划时长（分钟）',
    actual_start_time       DATETIME         NULL                            COMMENT '实际开始时间',
    actual_end_time         DATETIME         NULL                            COMMENT '实际结束时间',
    actual_duration_minutes INT              NULL                            COMMENT '实际时长（分钟）',
    output_qty              DECIMAL(18,4)    NULL    DEFAULT 0             COMMENT '产出数量',
    qualified_qty           DECIMAL(18,4)    NULL    DEFAULT 0             COMMENT '合格数量',
    reject_qty               DECIMAL(18,4)    NULL    DEFAULT 0             COMMENT '报废数量',
    rework_qty              DECIMAL(18,4)    NULL    DEFAULT 0             COMMENT '返工数量',
    setup_time_minutes      INT              NULL    DEFAULT 0             COMMENT '准备时间（分钟）',
    run_time_minutes        INT              NULL    DEFAULT 0             COMMENT '加工时间（分钟）',
    wait_time_minutes       INT              NULL    DEFAULT 0             COMMENT '等待时间（分钟）',
    transfer_time_minutes   INT              NULL    DEFAULT 0             COMMENT '搬运时间（分钟）',
    status                  VARCHAR(20)      NOT NULL    DEFAULT 'PENDING'   COMMENT '状态：PENDING/PENDING_START/IN_PROGRESS/PAUSED/COMPLETED/CANCELLED',
    is_split                TINYINT(1)       NOT NULL    DEFAULT 0           COMMENT '是否拆分批次',
    parent_detail_id        BIGINT           NULL                            COMMENT '父明细ID（拆分时引用原记录）',
    priority_override       INT              NULL                            COMMENT '优先级覆盖值（为空则继承工单优先级）',
    skill_requirement       VARCHAR(128)     NULL                            COMMENT '技能要求（JSON格式）',
    tool_requirement         VARCHAR(128)     NULL                            COMMENT '工装要求（JSON格式）',
    quality_flag            TINYINT(1)       NOT NULL    DEFAULT 0           COMMENT '是否需要质检',
    remark                  VARCHAR(500)     NULL                            COMMENT '备注',
    created_by              VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at              DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by              VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at              DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version                 INT              NOT NULL    DEFAULT 0           COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_dispatch_seq (dispatch_id, sequence_no),
    KEY idx_wo_operation_id (wo_operation_id),
    KEY idx_dispatched_resource (dispatched_resource_id, dispatched_resource_type),
    KEY idx_plan_time (plan_start_time, plan_end_time),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='派工单明细表';
