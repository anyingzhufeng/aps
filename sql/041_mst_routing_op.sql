-- ================================================================
-- APS 生产排程系统 - 主数据：工艺路线工序明细
-- 文件：041_mst_routing_op.sql
-- 说明：工艺路线的每一道工序定义，包括工序顺序、作业时间、标准产出等
-- 文档：APS开发文档 § 表清单 #012
-- ================================================================

-- ----------------------------
-- 表：mst_routing_op（工艺路线工序明细）
-- ----------------------------
DROP TABLE IF EXISTS mst_routing_op;
CREATE TABLE mst_routing_op (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '工序明细ID',
    routing_id          BIGINT          NOT NULL                        COMMENT '工艺路线ID（外键→mst_routing.id）',
    operation_seq       INT             NOT NULL                        COMMENT '工序序号（1=第一道工序）',
    operation_code      VARCHAR(64)     NOT NULL                        COMMENT '工序编码',
    operation_name      NVARCHAR(200)  NOT NULL                        COMMENT '工序名称',
    workcenter_id       BIGINT          NULL                            COMMENT '工作中心ID（外键→mst_workcenter.id）',
    skill_id            BIGINT          NULL                            COMMENT '技能要求ID（外键→mst_skill.id）',
    std_hour            DECIMAL(8,2)    NOT NULL    DEFAULT 0           COMMENT '标准工时（小时/件）',
    std_yield           DECIMAL(8,2)    NOT NULL    DEFAULT 100         COMMENT '标准良率（%）',
    std_output_qty      INT             NOT NULL    DEFAULT 1           COMMENT '标准产出数量（每批次）',
    min_lot_size        INT             NULL        DEFAULT 1           COMMENT '最小批量',
    max_lot_size        INT             NULL                            COMMENT '最大批量',
    setup_minutes       INT             NOT NULL    DEFAULT 0           COMMENT '准备时间（分钟）',
    teardown_minutes    INT             NOT NULL    DEFAULT 0           COMMENT '结束时间（分钟）',
    transfer_minutes    INT             NOT NULL    DEFAULT 0           COMMENT '转移时间（分钟）',
    waiting_minutes     INT             NOT NULL    DEFAULT 0           COMMENT '等待时间（分钟）',
    queue_minutes       INT             NOT NULL    DEFAULT 0           COMMENT '排队时间（分钟）',
    critical_path       TINYINT(1)      NOT NULL    DEFAULT 0           COMMENT '是否关键路径工序（1=是）',
    is_inspection       TINYINT(1)      NOT NULL    DEFAULT 0           COMMENT '是否质检工序（1=是）',
    is_buffer           TINYINT(1)      NOT NULL    DEFAULT 0           COMMENT '是否缓冲工序（1=是）',
    buffer_hours        DECIMAL(6,2)    NULL                            COMMENT '缓冲时间（小时，当is_buffer=1时）',
    parent_op_id        BIGINT          NULL                            COMMENT '前道工序ID（用于工序嵌套）',
    alternative_wc_ids  VARCHAR(500)   NULL                            COMMENT '备选工作中心ID列表（逗号分隔）',
    description         VARCHAR(1000)   NULL                            COMMENT '工序描述/作业指导',
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by          VARCHAR(100)    NOT NULL    DEFAULT 'system'   COMMENT '创建人',
    updated_by          VARCHAR(100)    NOT NULL    DEFAULT 'system'   COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_routing_op_seq (routing_id, operation_seq),
    KEY idx_routing_id (routing_id),
    KEY idx_workcenter (workcenter_id),
    KEY idx_critical_path (routing_id, critical_path),
    CONSTRAINT fk_rop_routing FOREIGN KEY (routing_id) REFERENCES mst_routing(id),
    CONSTRAINT fk_rop_workcenter FOREIGN KEY (workcenter_id) REFERENCES mst_workcenter(id),
    CONSTRAINT fk_rop_skill FOREIGN KEY (skill_id) REFERENCES mst_skill(id),
    CONSTRAINT fk_rop_parent_op FOREIGN KEY (parent_op_id) REFERENCES mst_routing_op(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工艺路线工序明细';

-- ----------------------------
-- 示例数据
-- ----------------------------
INSERT INTO mst_routing_op (routing_id, operation_seq, operation_code, operation_name, workcenter_id, std_hour, std_yield, setup_minutes) VALUES
(1, 1, 'OP-001', '原材料检验', 1, 0.05, 99.5, 15),
(1, 2, 'OP-002', '毛坯加工', 2, 0.80, 98.0, 20),
(1, 3, 'OP-003', '精加工', 3, 0.60, 99.0, 10),
(1, 4, 'OP-004', '外观检验', 4, 0.10, 99.8, 5),
(1, 5, 'OP-005', '包装入库', 5, 0.15, 100.0, 10);