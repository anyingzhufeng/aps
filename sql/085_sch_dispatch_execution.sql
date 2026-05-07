-- ================================================================
-- APS 生产排程系统 - 排程数据：派工执行记录表
-- 文件：085_sch_dispatch_execution.sql
-- 说明：记录排程结果的实际执行情况，关联派工单与工单真实开始/结束时间，用于实际进度追踪与排程回退分析
-- 作者：Claude Auto
-- 创建时间：2026-05-07
-- ================================================================

-- ----------------------------
-- Table: sch_dispatch_execution
-- ----------------------------
DROP TABLE IF EXISTS sch_dispatch_execution;

DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE sch_dispatch_execution (
    id                      BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    dispatch_list_id        BIGINT           NOT NULL                        COMMENT '关联派工单ID（sch_dispatch_list）',
    dispatch_detail_id       BIGINT           NOT NULL                        COMMENT '关联派工单明细ID',
    wo_operation_id          BIGINT           NOT NULL                        COMMENT '关联工单工序ID（ord_wo_operation）',
    actual_start_time        DATETIME         NULL                            COMMENT '实际开始时间',
    actual_end_time          DATETIME         NULL                            COMMENT '实际结束时间',
    actual_quantity          DECIMAL(18,6)    NULL                            COMMENT '实际完成数量',
    rejected_quantity        DECIMAL(18,6)    NULL         DEFAULT 0.000      COMMENT '不良品数量',
    status                   VARCHAR(16)      NOT NULL    DEFAULT 'PENDING'   COMMENT '状态：PENDING/IN_PROGRESS/COMPLETED/ABORTED',
    execution_mode           VARCHAR(16)      NULL                            COMMENT '执行模式：AUTO/MANUAL',
    operator_id             VARCHAR(64)      NULL                            COMMENT '操作员ID',
    remarks                  TEXT             NULL                            COMMENT '备注',
    created_by               VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at               DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by               VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at               DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version                  INT              NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    KEY idx_dispatch (dispatch_list_id),
    KEY idx_wo_op (wo_operation_id),
    KEY idx_status (status),
    KEY idx_actual_time (actual_start_time, actual_end_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='派工执行记录表';
