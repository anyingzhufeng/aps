-- ============================================================
-- 069 sch_algorithm_log（排程算法执行日志表）
-- 记录每次排程调度的执行过程，便于审计与问题追踪
-- ============================================================

CREATE TABLE sch_algorithm_log (
    id              BIGINT          NOT NULL AUTO_INCREMENT  COMMENT '主键',
    demand_id       BIGINT          NOT NULL                 COMMENT '排程需求ID（sch_schedule_demand.id）',
    schedule_no     VARCHAR(64)     NOT NULL                 COMMENT '排程编号（SCH-YYYYMMDD-XXXX）',
    phase           VARCHAR(32)     NOT NULL                 COMMENT '执行阶段：INIT/LOAD_DATA/BUILD_MODEL/SOLVE/POST_PROCESS/COMPLETE/FAILED',
    step            VARCHAR(64)     NOT NULL                 COMMENT '步骤名称',
    status          VARCHAR(16)     NOT NULL                 COMMENT '状态：RUNNING/OK/WARN/ERROR',
    message         VARCHAR(1000)   DEFAULT NULL             COMMENT '日志消息',
    duration_ms     BIGINT          DEFAULT NULL             COMMENT '本步骤耗时（毫秒）',
    iteration       INT             DEFAULT NULL             COMMENT '迭代次数（如适用）',
    gap_value       DECIMAL(12,4)   DEFAULT NULL             COMMENT '最优性间隙值（如适用）',
    bound_value     DECIMAL(12,4)   DEFAULT NULL             COMMENT '边界值（如适用）',
    detail          JSON            DEFAULT NULL             COMMENT '详细信息（JSON）',
    created_by      VARCHAR(64)     NOT NULL                 COMMENT '创建人',
    created_at      DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_by      VARCHAR(64)     DEFAULT NULL             COMMENT '修改人',
    updated_at      DATETIME        NOT NULL                 COMMENT '修改时间',
    version         INT             NOT NULL                 COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    INDEX idx_demand_id      (demand_id),
    INDEX idx_schedule_no    (schedule_no),
    INDEX idx_phase          (phase),
    INDEX idx_status         (status),
    INDEX idx_created_at     (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='排程算法执行日志表';
