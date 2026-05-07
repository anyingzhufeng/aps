-- ============================================================
-- 070 sch_priority_rule（排程优先级规则表）
-- 定义工单排程优先级计算规则，支持多种优先级模式组合
-- ============================================================

CREATE TABLE sch_priority_rule (
    id              BIGINT          NOT NULL AUTO_INCREMENT  COMMENT '主键',
    rule_code       VARCHAR(64)     NOT NULL                 COMMENT '规则编码',
    rule_name       VARCHAR(128)    NOT NULL                 COMMENT '规则名称',
    rule_type       VARCHAR(32)     NOT NULL                 COMMENT '规则类型：DUE_DATE/QUANTITY/ORDER_TYPE/CUSTOM',
    priority_mode   VARCHAR(16)     NOT NULL                 COMMENT '优先级模式：SALES/MRP/MANUAL/HEURISTIC',
    weight          DECIMAL(5,2)    NOT NULL DEFAULT 1.00    COMMENT '权重系数（0.00-10.00）',
    direction      VARCHAR(8)      NOT NULL DEFAULT 'ASC'    COMMENT '排序方向：ASC（越小越优先）/DESC（越大越优先）',
    expression      VARCHAR(256)    DEFAULT NULL             COMMENT '计算表达式（如适用）',
    is_active       TINYINT(1)     NOT NULL DEFAULT 1        COMMENT '是否启用',
    priority_order  INT             NOT NULL DEFAULT 0        COMMENT '规则执行顺序（数字越小越先）',
    remark          VARCHAR(500)   DEFAULT NULL             COMMENT '备注',
    created_by      VARCHAR(64)     NOT NULL                 COMMENT '创建人',
    created_at      DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_by      VARCHAR(64)     DEFAULT NULL             COMMENT '修改人',
    updated_at      DATETIME        NOT NULL                 COMMENT '修改时间',
    version         INT             NOT NULL                 COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE INDEX uk_rule_code  (rule_code),
    INDEX idx_rule_type    (rule_type),
    INDEX idx_priority_mode (priority_mode),
    INDEX idx_is_active    (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='排程优先级规则表';
