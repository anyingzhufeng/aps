-- ================================================================
-- APS 生产排程系统 - 异常处理：exc_exception
-- 文件：048_exc_exception.sql
-- 说明：异常记录主数据表，记录排程及执行过程中产生的各类异常
-- 参考：APS开发文档 §8.1 表清单 #26
-- ================================================================

CREATE TABLE IF NOT EXISTS exc_exception (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '异常记录ID',
    exc_code        VARCHAR(50)     NOT NULL                    COMMENT '异常编码',
    exc_type        VARCHAR(30)     NOT NULL                    COMMENT '异常类型：SCHEDULE（排程异常）、EQUIPMENT（设备异常）、QUALITY（质量异常）、MATERIAL（物料异常）、ORDER（工单异常）',
    priority        TINYINT         NOT NULL    DEFAULT 3       COMMENT '优先级：1=紧急，2=高，3=普通，4=低',
    title           VARCHAR(200)    NOT NULL                    COMMENT '异常标题',
    description     TEXT                                    COMMENT '异常描述',
    machine_id      BIGINT                                      COMMENT '关联设备ID（设备类异常）',
    work_order_id   BIGINT                                      COMMENT '关联工单ID（工单类异常）',
    workcenter_id   BIGINT                                      COMMENT '关联工作中心ID',
    severity        VARCHAR(20)     NOT NULL    DEFAULT 'MEDIUM'COMMENT '严重程度：LOW/MEDIUM/HIGH/CRITICAL',
    status          VARCHAR(20)     NOT NULL    DEFAULT 'OPEN'  COMMENT '状态：OPEN/ACKNOWLEDGED/IN_PROGRESS/RESOLVED/CLOSED/CANCELLED',
    raised_by       VARCHAR(50)     NOT NULL                    COMMENT '触发人/系统',
    raised_at       DATETIME        NOT NULL                    COMMENT '发生时间',
    acknowledged_at DATETIME                                    COMMENT '确认时间',
    acknowledged_by VARCHAR(50)                                 COMMENT '确认人',
    resolved_at     DATETIME                                    COMMENT '解决时间',
    resolved_by     VARCHAR(50)                                 COMMENT '解决人',
    resolution      TEXT                                    COMMENT '解决方案',
    external_ref_no VARCHAR(100)                                COMMENT '外部参考号（如MES工单号、ERP单据号）',
    schedule_version VARCHAR(50)                                 COMMENT '排程版本号（排程异常时填写）',
    extra_data      JSON                                     COMMENT '扩展数据（JSON格式存储异常上下文）',
    is_acknowledged TINYINT(1)      NOT NULL    DEFAULT 0       COMMENT '是否已确认',
    is_resolved     TINYINT(1)      NOT NULL    DEFAULT 0       COMMENT '是否已解决',
    is_deleted      TINYINT(1)      NOT NULL    DEFAULT 0       COMMENT '软删除标记',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(50)     NOT NULL                    COMMENT '创建人',
    updated_by      VARCHAR(50)     NOT NULL                    COMMENT '更新人',
    version         INT             NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',

    PRIMARY KEY (id),
    UNIQUE KEY uk_exc_code (exc_code),

    -- 索引：异常类型+时间查询
    KEY ix_exc_type_created (exc_type, created_at),
    -- 索引：状态+优先级（异常工作台首页）
    KEY ix_status_priority (status, priority),
    -- 索引：设备关联
    KEY ix_machine (machine_id),
    -- 索引：工单关联
    KEY ix_work_order (work_order_id),
    -- 索引：排程版本历史
    KEY ix_schedule_version (schedule_version),
    -- 索引：待处理异常（OPEN态按优先级排序）
    KEY ix_open_priority (status, priority, created_at)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='异常记录表';

-- ================================================================
-- 异常类型说明（供参考，应用层应维护枚举）
-- ================================================================
-- SCHEDULE      排程异常：无法满足交期、资源冲突、超时等
-- EQUIPMENT     设备异常：设备故障、急停、维护中等
-- QUALITY       质量异常：工序质量问题、首检不合格
-- MATERIAL      物料异常：缺料、齐套不足、来料不良
-- ORDER         工单异常：工单变更、紧急插单、工单取消
-- ================================================================

-- ================================================================
-- 触发场景说明
-- ================================================================
-- 1. 排程引擎求解失败或超时：算法服务写入 exc_code=SCH_TIMEOUT / SCH_INFEASIBLE
-- 2. 设备突发故障：MES 推送 event_type=EQUIPMENT_ALARM，写入 exc_type=EQUIPMENT
-- 3. 工单缺料：齐套检查发现库存不足，工单级写入 exc_type=MATERIAL
-- 4. 工序超期：后台任务扫描 ord_wo_operation，due_date 过期则写入 exc_type=ORDER
-- 5. 质量首检不合格：QC 录入后写入 exc_type=QUALITY
-- ================================================================