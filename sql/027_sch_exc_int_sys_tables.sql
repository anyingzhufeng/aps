-- ================================================================
-- SQL #027：系统日志表（exc/sch/int/sys）
-- APS开发文档 § 表清单 027-030
-- ================================================================

-- ----------------------------
-- 表：exc_exception（异常记录主表）
-- ----------------------------
DROP TABLE IF EXISTS exc_exception;
CREATE TABLE exc_exception (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '异常记录ID',
    exception_code      VARCHAR(32)      NOT NULL                        COMMENT '异常编码',
    exception_type      TINYINT          NOT NULL                        COMMENT '异常类型：1=排程异常 2=资源冲突 3=齐套不足 4=产能超限 5=工序堵死 6=外接接口异常 9=其他',
    work_order_id       BIGINT          NULL                             COMMENT '关联工单ID（外键→ord_work_order.id）',
    operation_id        BIGINT          NULL                             COMMENT '关联工序ID（外键→ord_wo_operation.id）',
    machine_id          BIGINT          NULL                             COMMENT '关联设备ID（外键→mst_machine.id）',
    workcenter_id       BIGINT          NULL                             COMMENT '关联工作中心ID（外键→mst_workcenter.id）',
    schedule_result_id  BIGINT          NULL                             COMMENT '关联排程结果ID',
    title               VARCHAR(256)     NOT NULL                        COMMENT '异常标题',
    message             TEXT             NULL                             COMMENT '异常详细信息',
    severity            TINYINT          NOT NULL    DEFAULT 2           COMMENT '严重等级：1=提示 2=警告 3=严重 4=致命',
    state               TINYINT          NOT NULL    DEFAULT 1           COMMENT '处理状态：1=新建 2=已确认 3=处理中 4=已解决 5=已关闭 9=忽略',
    context_json        JSON             NULL                             COMMENT '异常上下文数据(JSON)',
    trace_id            VARCHAR(128)     NULL                             COMMENT '调用链路追踪ID',
    source_system       VARCHAR(64)      NULL                             COMMENT '来源系统',
    occur_time          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '发生时间',
    assigned_to         VARCHAR(64)      NULL                             COMMENT '处理人',
    assigned_time       DATETIME         NULL                             COMMENT '指派时间',
    resolved_time       DATETIME         NULL                             COMMENT '解决时间',
    resolution          TEXT             NULL                             COMMENT '处理方案',
    created_by          VARCHAR(64)      NOT NULL    DEFAULT 'system'   COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NOT NULL    DEFAULT 'system'   COMMENT '更新人',
    updated_at          DATETIME         NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted          TINYINT          NOT NULL    DEFAULT 0           COMMENT '软删除标记',
    PRIMARY KEY (id),
    KEY idx_exc_code (exception_code),
    KEY idx_exc_type (exception_type),
    KEY idx_exc_severity (severity),
    KEY idx_exc_state (state),
    KEY idx_exc_occur_time (occur_time),
    KEY idx_exc_work_order (work_order_id),
    KEY idx_exc_machine (machine_id),
    KEY idx_exc_assignee (assigned_to),
    KEY idx_exc_trace (trace_id),
    CONSTRAINT fk_exc_wo FOREIGN KEY (work_order_id) REFERENCES ord_work_order(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_exc_operation FOREIGN KEY (operation_id) REFERENCES ord_wo_operation(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_exc_machine FOREIGN KEY (machine_id) REFERENCES mst_machine(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='APS异常记录主表';

-- ----------------------------
-- 表：exc_notification_log（通知日志表）
-- ----------------------------
DROP TABLE IF EXISTS exc_notification_log;
CREATE TABLE exc_notification_log (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '通知记录ID',
    notification_type    TINYINT          NOT NULL                        COMMENT '通知类型：1=邮件 2=短信 3=企业微信 4=钉钉 5=系统消息 9=其他',
    recipient           VARCHAR(256)     NOT NULL                        COMMENT '接收人地址/账号',
    recipient_name      VARCHAR(128)     NULL                             COMMENT '接收人姓名',
    title               VARCHAR(256)     NOT NULL                        COMMENT '通知标题',
    content             TEXT             NOT NULL                        COMMENT '通知内容',
    template_code       VARCHAR(64)      NULL                             COMMENT '消息模板编码',
    template_params     JSON             NULL                             COMMENT '模板参数(JSON)',
    send_status         TINYINT          NOT NULL    DEFAULT 1           COMMENT '发送状态：1=待发送 2=发送中 3=成功 4=失败 9=取消',
    send_time           DATETIME         NULL                             COMMENT '实际发送时间',
    retry_count         INT              NOT NULL    DEFAULT 0           COMMENT '重试次数',
    max_retry           INT              NOT NULL    DEFAULT 3           COMMENT '最大重试次数',
    error_message       VARCHAR(512)     NULL                             COMMENT '失败原因',
    exception_id        BIGINT          NULL                             COMMENT '关联异常ID（外键→exc_exception.id）',
    work_order_id       BIGINT          NULL                             COMMENT '关联工单ID（外键→ord_work_order.id）',
    schedule_result_id  BIGINT          NULL                             COMMENT '关联排程结果ID',
    scheduled_time      DATETIME         NULL                             COMMENT '计划发送时间',
    created_by          VARCHAR(64)      NOT NULL    DEFAULT 'system'   COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NOT NULL    DEFAULT 'system'   COMMENT '更新人',
    updated_at          DATETIME         NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted          TINYINT          NOT NULL    DEFAULT 0           COMMENT '软删除标记',
    PRIMARY KEY (id),
    KEY idx_notif_type (notification_type),
    KEY idx_notif_status (send_status),
    KEY idx_notif_recipient (recipient),
    KEY idx_notif_exc (exception_id),
    KEY idx_notif_scheduled (scheduled_time),
    KEY idx_notif_send_time (send_time),
    CONSTRAINT fk_notif_exc FOREIGN KEY (exception_id) REFERENCES exc_exception(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_notif_wo FOREIGN KEY (work_order_id) REFERENCES ord_work_order(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='APS通知日志表';

-- ----------------------------
-- 表：int_interface_log（接口调用日志表）
-- ----------------------------
DROP TABLE IF EXISTS int_interface_log;
CREATE TABLE int_interface_log (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '日志ID',
    interface_code      VARCHAR(64)      NOT NULL                        COMMENT '接口编码',
    interface_name      VARCHAR(128)     NOT NULL                        COMMENT '接口名称',
    direction           TINYINT          NOT NULL                        COMMENT '调用方向：1=上行(APS→外部) 2=下行(外部→APS)',
    request_method      VARCHAR(16)      NULL                             COMMENT 'HTTP方法',
    request_url         VARCHAR(512)     NULL                             COMMENT '请求URL',
    request_headers     JSON             NULL                             COMMENT '请求头(JSON)',
    request_body        LONGTEXT         NULL                             COMMENT '请求体',
    request_time        DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '请求时间',
    response_status     INT              NULL                             COMMENT 'HTTP状态码',
    response_headers    JSON             NULL                             COMMENT '响应头(JSON)',
    response_body       LONGTEXT         NULL                             COMMENT '响应体',
    response_time       DATETIME         NULL                             COMMENT '响应时间',
    elapsed_ms          INT              NULL                             COMMENT '耗时(毫秒)',
    result_code         VARCHAR(32)      NULL                             COMMENT '业务结果码',
    result_message      VARCHAR(512)     NULL                             COMMENT '结果描述',
    call_status         TINYINT          NOT NULL    DEFAULT 1           COMMENT '调用状态：1=进行中 2=成功 3=失败 9=超时',
    biz_object_type     VARCHAR(64)      NULL                             COMMENT '业务对象类型',
    biz_object_id       VARCHAR(128)     NULL                             COMMENT '业务对象ID',
    work_order_id       BIGINT          NULL                             COMMENT '关联工单ID',
    trace_id            VARCHAR(128)     NULL                             COMMENT '追踪ID',
    client_ip           VARCHAR(64)      NULL                             COMMENT '客户端IP',
    app_version         VARCHAR(32)      NULL                             COMMENT '应用版本',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at          DATETIME         NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted          TINYINT          NOT NULL    DEFAULT 0           COMMENT '软删除标记',
    PRIMARY KEY (id),
    KEY idx_int_code (interface_code),
    KEY idx_int_direction (direction),
    KEY idx_int_status (call_status),
    KEY idx_int_request_time (request_time),
    KEY idx_int_response_time (response_time),
    KEY idx_int_result_code (result_code),
    KEY idx_int_trace (trace_id),
    KEY idx_int_biz (biz_object_type, biz_object_id),
    KEY idx_int_elapsed (elapsed_ms)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='接口调用日志表';

-- ----------------------------
-- 表：sch_schedule_log（排程执行日志表）
-- ----------------------------
DROP TABLE IF EXISTS sch_schedule_log;
CREATE TABLE sch_schedule_log (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '日志ID',
    schedule_type       TINYINT          NOT NULL                        COMMENT '排程类型：1=自动排程 2=手动触发 3=模拟分析 4=重排',
    schedule_mode       VARCHAR(32)      NULL                             COMMENT '排程模式：MILP/GA/CP-SAT',
    trigger_source      VARCHAR(64)      NULL                             COMMENT '触发来源：system/scheduler/manual/api',
    planning_horizon_start DATE          NULL                             COMMENT '排程计划开始日期',
    planning_horizon_end   DATE          NULL                             COMMENT '排程计划结束日期',
    workcenter_filter   JSON             NULL                             COMMENT '工作中心过滤范围(JSON)',
    wo_filter           JSON             NULL                             COMMENT '工单过滤条件(JSON)',
    start_time          DATETIME         NOT NULL                        COMMENT '开始时间',
    end_time            DATETIME         NULL                             COMMENT '结束时间',
    elapsed_ms          INT              NULL                             COMMENT '耗时(毫秒)',
    total_wo_count      INT              NOT NULL    DEFAULT 0           COMMENT '参与工单总数',
    scheduled_wo_count  INT              NOT NULL    DEFAULT 0           COMMENT '成功排程工单数',
    failed_wo_count     INT              NOT NULL    DEFAULT 0           COMMENT '排程失败工单数',
    total_ops_count     INT              NOT NULL    DEFAULT 0           COMMENT '总工序数',
    exception_count     INT              NOT NULL    DEFAULT 0           COMMENT '异常数量',
    target_kpi_json     JSON             NULL                             COMMENT '目标KPI指标(JSON)',
    actual_kpi_json     JSON             NULL                             COMMENT '实际KPI指标(JSON)',
    solver_status       VARCHAR(64)      NULL                             COMMENT '求解器状态：Optimal/Feasible/Infeasible/Timeout',
    solution_gap        DECIMAL(8,4)     NULL                             COMMENT '解的gap值(%)',
    iterations          INT              NULL                             COMMENT '迭代次数',
    branch_count        INT              NULL                             COMMENT '分支数',
    executor_id         VARCHAR(64)      NULL                             COMMENT '执行人ID',
    machine_name        VARCHAR(128)     NULL                             COMMENT '执行机器名',
    memory_used_mb      INT              NULL                             COMMENT '内存使用(MB)',
    created_by          VARCHAR(64)      NOT NULL    DEFAULT 'system'   COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NOT NULL    DEFAULT 'system'   COMMENT '更新人',
    updated_at          DATETIME         NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted          TINYINT          NOT NULL    DEFAULT 0           COMMENT '软删除标记',
    PRIMARY KEY (id),
    KEY idx_schlog_type (schedule_type),
    KEY idx_schlog_mode (schedule_mode),
    KEY idx_schlog_trigger (trigger_source),
    KEY idx_schlog_start (start_time),
    KEY idx_schlog_end (end_time),
    KEY idx_schlog_executor (executor_id),
    KEY idx_schlog_solved_status (solver_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='排程执行日志表';

-- ----------------------------
-- 表：sys_audit_log（审计日志表）
-- ----------------------------
DROP TABLE IF EXISTS sys_audit_log;
CREATE TABLE sys_audit_log (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '日志ID',
    module              VARCHAR(64)      NOT NULL                        COMMENT '模块',
    action              VARCHAR(64)      NOT NULL                        COMMENT '操作类型',
    action_desc         VARCHAR(256)     NULL                             COMMENT '操作描述',
    user_id             VARCHAR(64)      NULL                             COMMENT '操作用户ID',
    user_name           VARCHAR(128)     NULL                             COMMENT '操作用户名',
    user_ip             VARCHAR(64)      NULL                             COMMENT '用户IP',
    user_agent          VARCHAR(512)     NULL                             COMMENT 'User-Agent',
    object_type         VARCHAR(64)      NULL                             COMMENT '对象类型',
    object_id           VARCHAR(128)     NULL                             COMMENT '对象ID',
    object_name         VARCHAR(256)     NULL                             COMMENT '对象名称',
    operation_type      VARCHAR(32)      NULL                             COMMENT '操作类型：CREATE/UPDATE/DELETE/LOGIN/LOGOUT/EXPORT/IMPORT',
    before_value        JSON             NULL                             COMMENT '变更前值(JSON)',
    after_value         JSON             NULL                             COMMENT '变更后值(JSON)',
    change_summary      TEXT             NULL                             COMMENT '变更摘要',
    result              TINYINT          NOT NULL    DEFAULT 1           COMMENT '结果：1=成功 2=失败 9=异常',
    error_message       VARCHAR(512)     NULL                             COMMENT '错误信息',
    operate_time        DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    elapsed_ms          INT              NULL                             COMMENT '操作耗时(毫秒)',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    is_deleted          TINYINT          NOT NULL    DEFAULT 0           COMMENT '软删除标记',
    PRIMARY KEY (id),
    KEY idx_audit_module (module),
    KEY idx_audit_action (action),
    KEY idx_audit_user (user_id),
    KEY idx_audit_object (object_type, object_id),
    KEY idx_audit_operate_time (operate_time),
    KEY idx_audit_result (result),
    KEY idx_audit_user_ip (user_ip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统审计日志表';