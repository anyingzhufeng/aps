-- ================================================================
-- 表：sys_sequence（序号生成器）
-- 说明：提供全局唯一序号生成能力，支持多种业务类型和格式
-- 依赖：无
-- ================================================================

CREATE TABLE sys_sequence (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    seq_code            VARCHAR(64)     NOT NULL    COMMENT '序号编码',
    seq_name            NVARCHAR(200)   NULL        COMMENT '序号名称',
    prefix              VARCHAR(32)     NULL        COMMENT '前缀',
    suffix              VARCHAR(32)     NULL        COMMENT '后缀',
    current_value       BIGINT          NOT NULL    DEFAULT 0 COMMENT '当前序号值',
    increment_by        INT             NOT NULL    DEFAULT 1 COMMENT '步长',
    min_value           BIGINT          NOT NULL    DEFAULT 1 COMMENT '最小值',
    max_value           BIGINT          NOT NULL    DEFAULT 9999999999 COMMENT '最大值',
    cycle_flag          TINYINT         NOT NULL    DEFAULT 0 COMMENT '是否循环：0=不循环，1=循环',
    padding_length      INT             NOT NULL    DEFAULT 6 COMMENT '序号补零长度',
    date_format         VARCHAR(32)     NULL        COMMENT '日期格式（如：YYYYMMDD）',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_seq_code (seq_code),
    KEY idx_is_active   (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='序号生成器表';

-- 初始化常用序号
INSERT INTO sys_sequence (id, seq_code, seq_name, prefix, current_value, increment_by, min_value, max_value, padding_length, date_format) VALUES
    (1,  'WO',       '工单编号',     'WO',   0, 1, 1, 9999999999, 8, 'YYYYMMDD'),
    (2,  'SCH',      '排程批次号',   'SCH',  0, 1, 1, 9999999999, 8, 'YYYYMMDD'),
    (3,  'NOTIFY',   '通知编号',     'NTF',  0, 1, 1, 9999999999, 8, 'YYYYMMDD'),
    (4,  'EXC',      '异常编号',     'EXC',  0, 1, 1, 9999999999, 8, 'YYYYMMDD'),
    (5,  'INT_LOG',  '接口日志编号', 'LOG',  0, 1, 1, 9999999999, 8, 'YYYYMMDD');
