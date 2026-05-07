-- ============================================================
-- 表：sys_audit_log（审计日志）
-- 编号：030
-- 说明：记录所有用户操作审计日志
-- 分类：系统数据（sys）
-- ============================================================

CREATE TABLE sys_audit_log (
    id              BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    user_id         VARCHAR(64)                      COMMENT '操作用户ID',
    user_name       VARCHAR(128)                     COMMENT '操作用户名称',
    action          VARCHAR(64)      NOT NULL        COMMENT '操作动作',
    entity_type     VARCHAR(64)                      COMMENT '实体类型',
    entity_id       VARCHAR(64)                      COMMENT '实体ID',
    entity_name     VARCHAR(256)                     COMMENT '实体名称',
    request_method  VARCHAR(16)                      COMMENT 'HTTP方法',
    request_path    VARCHAR(512)                     COMMENT '请求路径',
    request_body    TEXT                             COMMENT '请求体（脱敏）',
    response_code   INT                              COMMENT '响应状态码',
    ip_address      VARCHAR(64)                      COMMENT '客户端IP',
    user_agent      VARCHAR(512)                     COMMENT 'User-Agent',
    error_message   TEXT                             COMMENT '错误信息',
    duration_ms     INT                              COMMENT '执行时长(ms)',
    created_at      DATETIME       NOT NULL  DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id),
    INDEX ix_user_id (user_id),
    INDEX ix_action (action),
    INDEX ix_entity (entity_type, entity_id),
    INDEX ix_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审计日志';
