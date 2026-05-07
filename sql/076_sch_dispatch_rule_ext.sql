-- ============================================================
-- 076 sch_dispatch_rule_ext（派工规则扩展表）
-- 派工规则的扩展属性配置表
-- 记录每条规则的详细参数、适用条件及优先级权重
-- 关联：sch_dispatch_rule.id → 本表.rule_id
-- ============================================================

CREATE TABLE sch_dispatch_rule_ext (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT   COMMENT '主键',
    rule_id             BIGINT           NOT NULL                         COMMENT '关联规则ID（sch_dispatch_rule.id）',
    param_key           VARCHAR(64)      NOT NULL                         COMMENT '参数键名',
    param_value         VARCHAR(256)    NULL                             COMMENT '参数值',
    condition_expr      VARCHAR(512)    NULL                             COMMENT '条件表达式（JSON格式），满足条件时此参数生效',
    weight              DECIMAL(6,4)    NULL         DEFAULT 1.0000     COMMENT '权重系数，用于多规则评分时的加权计算',
    enabled             TINYINT(1)      NOT NULL    DEFAULT 1           COMMENT '是否启用：1=启用，0=禁用',
    remark              VARCHAR(500)    NULL                             COMMENT '备注',
    created_by          VARCHAR(64)      NOT NULL                        COMMENT '创建人',
    created_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(64)      NULL                            COMMENT '修改人',
    updated_at          DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    version             INT              NOT NULL    DEFAULT 0           COMMENT '乐观锁版本号',
    PRIMARY KEY (id),
    UNIQUE KEY uk_rule_param (rule_id, param_key),
    KEY idx_rule_id (rule_id),
    KEY idx_enabled (enabled)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='派工规则扩展表';
