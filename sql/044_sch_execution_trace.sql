-- ================================================================
-- APS 生产排程系统 - 排程执行过程追溯表
-- 文件：044_sch_execution_trace.sql
-- 说明：排程执行过程追溯，记录每个调度决策的时间戳与上下文
-- 参考：APS开发文档 §2.3.3 §8.1 表清单
-- ================================================================

-- 表：sch_execution_trace（排程执行过程追溯）
CREATE TABLE sch_execution_trace (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  PRIMARY KEY,
    trace_id            VARCHAR(64)     NOT NULL    COMMENT '追溯批次ID（同一批排程共享同一trace_id）',
    schedule_id         BIGINT          NULL        COMMENT '关联的排程结果ID',
    trace_seq           INT             NOT NULL    DEFAULT 0 COMMENT '执行步骤序号',
    trace_stage         VARCHAR(32)     NOT NULL    COMMENT '执行阶段：INIT/PREPROCESS/SOLVE/POSTPROCESS/COMPLETE/FAIL',
    trace_event         VARCHAR(64)     NOT NULL    COMMENT '事件名称',
    trace_message       TEXT            NULL        COMMENT '详细描述/上下文',
    work_order_id       BIGINT          NULL        COMMENT '涉及的工单ID',
    operation_id        BIGINT          NULL        COMMENT '涉及的工序ID',
    machine_id          BIGINT          NULL        COMMENT '涉及的设备ID',
    decision_type       VARCHAR(32)     NULL        COMMENT '决策类型：ASSIGN/DELAY/SKIP/SWITCH/WAIT',
    decision_reason     VARCHAR(255)    NULL        COMMENT '决策原因码',
    objective_delta     DECIMAL(18,6)   NULL        COMMENT '目标函数变化量',
    elapsed_ms          INT             NULL        COMMENT '该步骤耗时（毫秒）',
    iteration_count     INT             NULL        COMMENT '迭代次数（GA/CP-SAT用）',
    solution_quality    DECIMAL(18,6)   NULL        COMMENT '当前解质量评分',
    feasible_flag       TINYINT         NULL        COMMENT '是否可行解（1=可行，0=不可行）',
    constraint_violated VARCHAR(255)    NULL        COMMENT '违背的约束名称',
    solver_snapshot     JSON            NULL        COMMENT '求解器快照状态JSON',
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_trace_id_seq (trace_id, trace_seq),
    KEY idx_schedule_id (schedule_id),
    KEY idx_trace_stage (trace_stage),
    KEY idx_work_order_id (work_order_id),
    KEY idx_machine_id (machine_id),
    KEY idx_decision_type (decision_type),
    KEY idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='排程执行过程追溯表';
