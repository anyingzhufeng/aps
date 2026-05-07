-- ============================================================
-- 074 sch_dispatch_rule（排程派工规则配置表）
-- 定义排程派工时的资源选择策略和规则
-- ============================================================

CREATE TABLE IF NOT EXISTS sch_dispatch_rule (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键',
    rule_code           VARCHAR(64)     NOT NULL                    COMMENT '规则编码',
    rule_name           VARCHAR(128)    NOT NULL                    COMMENT '规则名称',
    rule_type           VARCHAR(32)     NOT NULL                    COMMENT '规则类型：RESOURCE_SELECT/SORT/RESTRICT/SPLIT',
    resource_type       VARCHAR(32)     NOT NULL                    COMMENT '适用资源类型：MACHINE/WORKCENTER/LINE/STATION',
    priority            INT             NOT NULL    DEFAULT 100       COMMENT '规则优先级（越小越优先）',
    condition_expr      VARCHAR(512)    NULL                        COMMENT '触发条件表达式（JSON）',
    select_strategy     VARCHAR(32)     NULL                        COMMENT '资源选择策略：EARLIEST/LOAD_BALANCE/SKILL_MATCH/ROUND_ROBIN',
    sort_field          VARCHAR(64)     NULL                        COMMENT '排序字段',
    sort_direction      VARCHAR(8)      NULL                        DEFAULT 'ASC'    COMMENT '排序方向：ASC/DESC',
    split_enabled       TINYINT(1)      NOT NULL    DEFAULT 0         COMMENT '是否允许拆分批次',
    split_min_qty       DECIMAL(18,4)   NULL                        COMMENT '拆分最小批量',
    split_max_parts     INT             NULL                        COMMENT '最大拆分批次',
    buffer_minutes      INT             NULL                        COMMENT '缓冲时间（分钟）',
    is_active           TINYINT(1)      NOT NULL    DEFAULT 1         COMMENT '是否启用',
    remark              VARCHAR(500)    NULL                        COMMENT '备注',
    created_by          VARCHAR(64)     NOT NULL                    COMMENT '创建人',
    created_at          DATETIME        NOT NULL                    COMMENT '创建时间',
    updated_by          VARCHAR(64)     NULL                        COMMENT '修改人',
    updated_at          DATETIME        NOT NULL                    COMMENT '修改时间',
    version             INT             NOT NULL    DEFAULT 0         COMMENT '乐观锁版本号',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='排程派工规则配置表';

-- 索引
CREATE INDEX idx_rule_code        ON sch_dispatch_rule(rule_code);
CREATE INDEX idx_rule_type         ON sch_dispatch_rule(rule_type);
CREATE INDEX idx_resource_type    ON sch_dispatch_rule(resource_type);
CREATE INDEX idx_priority          ON sch_dispatch_rule(priority);
CREATE INDEX idx_is_active        ON sch_dispatch_rule(is_active);
