-- ================================================================
-- APS 生产排程系统 - 通知日志：exc_notification_log
-- 文件：049_exc_notification_log.sql
-- 说明：通知日志表，记录异常告警向各渠道（邮件/钉钉/短信/企微）的推送记录
-- 参考：APS开发文档 §8.1 表清单 #27
-- ================================================================

CREATE TABLE exc_notification_log (
    id                      BIGINT          NOT NULL    PRIMARY KEY,
    exc_id                  BIGINT          NULL        COMMENT '关联异常ID（exc_exception.id）',
    notification_no         VARCHAR(64)     NOT NULL    COMMENT '通知流水号',
    channel                 VARCHAR(32)     NOT NULL    COMMENT '通知渠道：EMAIL=邮件，DINGTALK=钉钉，SMS=短信，WECOM=企微，WEBHOOK=自定义',
    recipient               VARCHAR(500)    NOT NULL    COMMENT '接收人（邮件地址/手机号/用户ID）',
    recipient_name          NVARCHAR(200)   NULL        COMMENT '接收人姓名',
    subject                 NVARCHAR(500)   NOT NULL    COMMENT '通知标题',
    content                 TEXT            NOT NULL    COMMENT '通知内容',
    priority                TINYINT         NOT NULL    DEFAULT 3 COMMENT '优先级：1=紧急，2=重要，3=一般，4=低',
    send_status             VARCHAR(32)     NOT NULL    COMMENT '发送状态：PENDING=待发送，SENDING=发送中，SUCCESS=成功，FAILED=失败，PARTIAL=部分成功',
    send_at                 DATETIME        NULL        COMMENT '实际发送时间',
    retry_count             INT             NOT NULL    DEFAULT 0 COMMENT '重试次数',
    max_retry               INT             NOT NULL    DEFAULT 3 COMMENT '最大重试次数',
    first_attempt_at        DATETIME        NULL        COMMENT '首次尝试时间',
    last_attempt_at         DATETIME        NULL        COMMENT '最后尝试时间',
    last_error              NVARCHAR(500)   NULL        COMMENT '最后错误信息',
    ext_message_id          VARCHAR(128)    NULL        COMMENT '第三方消息ID（如钉钉messageId）',
    ext_response            TEXT            NULL        COMMENT '第三方响应原文',
    read_status             TINYINT         NOT NULL    DEFAULT 0 COMMENT '是否已读：0=未读，1=已读',
    read_at                 DATETIME        NULL        COMMENT '阅读时间',
    read_by                 VARCHAR(64)     NULL        COMMENT '阅读人',
    is_active               TINYINT         NOT NULL    DEFAULT 1,
    created_by              VARCHAR(64)     NULL,
    created_at              DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by              VARCHAR(64)     NULL,
    updated_at              DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uk_notification_no   (notification_no),
    KEY idx_exc_id           (exc_id),
    KEY idx_channel          (channel),
    KEY idx_send_status      (send_status),
    KEY idx_priority         (priority),
    KEY idx_recipient        (recipient),
    KEY idx_send_at          (send_at),
    KEY idx_created_at       (created_at),
    KEY idx_read_status      (read_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='异常通知日志表';

-- 触发器：新增通知后自动更新异常表的已通知计数
DELIMITER $$

CREATE TRIGGER trg_notification_after_insert
AFTER INSERT ON exc_notification_log
FOR EACH ROW
BEGIN
    IF NEW.exc_id IS NOT NULL AND NEW.send_status = 'SUCCESS' THEN
        UPDATE exc_exception
        SET notified_count = notified_count + 1,
            last_notified_at = NEW.send_at,
            updated_at = NOW()
        WHERE id = NEW.exc_id;
    END IF;
END$$

DELIMITER ;
