-- ================================================================
-- APS 生产排程系统 - 排程执行：派工执行记录表
-- 文件：081_sch_dispatch_execution.sql
-- 说明：记录排程结果的实际执行情况，关联派工单与工单真实开始/结束时间
-- 作者：Claude Auto
-- 创建时间：2026-05-06
-- ================================================================

DROP TABLE IF EXISTS sch_dispatch_execution;
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE sch_dispatch_execution (
    id                      BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    dispatch_no             VARCHAR(64)      NOT NULL                        COMMENT '派工单号',
    dispatch_detail_id      BIGINT           NULL                            COMMENT '派工单明细ID（关联sch_dispatch_list_detail.id）',
    work_order_no           VARCHAR(64)      NOT NULL                        COMMENT '工单编号',
    operation_seq           INT              NULL                            COMMENT '工序序号',
    workshop_code           VARCHAR(64)      NOT NULL                        COMMENT '车间编码',
    line_code               VARCHAR(64)      NULL                            COMMENT '产线编码',
    workcenter_code         VARCHAR(64)      NULL                            COMMENT '工作中心编码',
    station_code            VARCHAR(64)      NULL                            COMMENT '工位编码',
    machine_code            VARCHAR(64)      NULL                            COMMENT '设备编码',
    worker_id               BIGINT           NULL                            COMMENT '工人ID',
    plan_start_time         DATETIME         NULL                            COMMENT '计划开始时间',
    plan_end_time           DATETIME         NULL                            COMMENT '计划结束时间',
    actual_start_time       DATETIME         NULL                            COMMENT '实际开始时间',
    actual_end_time         DATETIME         NULL                            COMMENT '实际结束时间',
    plan_quantity           DECIMAL(18,6)    NULL                            COMMENT '计划数量',
    completed_quantity      DECIMAL(18,6)    NULL         DEFAULT 0         COMMENT '完成数量',
    qualified_quantity      DECIMAL(18,6)    NULL         DEFAULT 0         COMMENT '合格数量',
    scrap_quantity          DECIMAL(18,6)    NULL         DEFAULT 0         COMMENT '报废数量',
    rework_quantity         DECIMAL(18,6)    NULL         DEFAULT 0         COMMENT '返工数量',
    execution_status        VARCHAR(16)      NOT NULL    DEFAULT 'PENDING'  COMMENT '执行状态：PENDING/RUNNING/PAUSED/COMPLETED/ABNORMAL',
    delay_reason            VARCHAR(256)     NULL                            COMMENT '延迟原因',
    efficiency_rate         DECIMAL(8,4)     NULL         DEFAULT 1.0000   COMMENT '实际效率',
    utilization_rate        DECIMAL(8,4)     NULL                            COMMENT '设备利用率',
    remarks                 VARCHAR(512)     NULL                            COMMENT '备注',
    created_by              VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at              DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by              VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at              DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version                 INT              NOT NULL    DEFAULT 0          COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    KEY idx_dispatch_no (dispatch_no),
    KEY idx_work_order (work_order_no),
    KEY idx_workshop_time (workshop_code, actual_start_time),
    KEY idx_status (execution_status),
    KEY idx_worker (worker_id),
    KEY idx_line_station (line_code, station_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='派工执行记录表（排程结果实际执行跟踪）';
