-- ================================================================
-- SQL #028：int_interface_log（接口调用日志）
-- APS开发文档 § 接口日志表
-- ================================================================

DROP TABLE IF EXISTS int_interface_log;
CREATE TABLE int_interface_log (
    id              BIGINT          AUTO_INCREMENT  PRIMARY KEY COMMENT '主键',
    interface_code  VARCHAR(64)     NOT NULL        COMMENT '接口编号（如 ERP_PUSH_ORDER）',
    interface_name  VARCHAR(128)    NOT NULL        COMMENT '接口名称',
    direction      VARCHAR(16)     NOT NULL        COMMENT '方向：INBOUND / OUTBOUND',
    source_system   VARCHAR(64)     NOT NULL        COMMENT '来源系统',
    target_system   VARCHAR(64)     NOT NULL        COMMENT '目标系统',
    request_id      VARCHAR(128)                    COMMENT '请求唯一ID（用于幂等追踪）',
    request_time    DATETIME                        COMMENT '请求时间',
    response_time   DATETIME                        COMMENT '响应时间',
    elapsed_ms      INT                             COMMENT '耗时（毫秒）',
    status_code     VARCHAR(32)                     COMMENT 'HTTP状态码或业务码',
    is_success      TINYINT(1)      DEFAULT 1       COMMENT '是否成功：1=成功 0=失败',
    request_payload LONGTEXT                          COMMENT '请求报文（JSON/XML）',
    response_payload LONGTEXT                        COMMENT '响应报文',
    error_message   VARCHAR(512)                     COMMENT '错误描述',
    retry_count     INT           DEFAULT 0        COMMENT '重试次数',
    created_by      VARCHAR(64)                     COMMENT '创建人',
    created_at      DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_interface_code (interface_code),
    INDEX idx_request_id (request_id),
    INDEX idx_created_at (created_at),
    INDEX idx_source_system (source_system)
) COMMENT '接口调用日志表';