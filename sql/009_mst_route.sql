-- ================================================================
-- SQL #009：mst_route / mst_route_operation（工艺路线及工序）
-- APS开发文档 §2.2.2
-- ================================================================

-- ----------------------------
-- 表：mst_route（工艺路线表头）
-- ----------------------------
DROP TABLE IF EXISTS mst_route;
CREATE TABLE mst_route (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    route_code      VARCHAR(50)     NOT NULL                        COMMENT '工艺路线编码',
    route_name      VARCHAR(200)    NOT NULL                        COMMENT '工艺路线名称',
    item_id         BIGINT          NOT NULL                        COMMENT '对应产品ID（外键→mst_item.id）',
    version         VARCHAR(20)     NOT NULL    DEFAULT 'V1.0'     COMMENT '版本号',
    default_flag    TINYINT         NOT NULL    DEFAULT 0          COMMENT '是否默认路线：0=否，1=是',
    status          TINYINT         NOT NULL    DEFAULT 1          COMMENT '状态：0=草稿，1=生效，2=禁用',
    remark          VARCHAR(500)    NULL                             COMMENT '备注',
    created_by      VARCHAR(50)     NOT NULL                        COMMENT '创建人',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by      VARCHAR(50)     NULL                             COMMENT '更新人',
    updated_at      DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_route_item_version (route_code, version),
    KEY idx_item_id (item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工艺路线表头';

-- ----------------------------
-- 表：mst_route_operation（工艺路线工序明细）
-- ----------------------------
DROP TABLE IF EXISTS mst_route_operation;
CREATE TABLE mst_route_operation (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    route_id            BIGINT          NOT NULL                        COMMENT '工艺路线ID（外键→mst_route.id）',
    operation_no        INT             NOT NULL                        COMMENT '工序序号',
    operation_code      VARCHAR(50)     NOT NULL                        COMMENT '工序编码',
    operation_name      VARCHAR(200)    NOT NULL                        COMMENT '工序名称',
    workcenter_id       BIGINT          NULL                             COMMENT '工作中心ID（外键→mst_workcenter.id）',
    work_time_min       DECIMAL(10,2)   NOT NULL    DEFAULT 0          COMMENT '加工时间（分钟）',
    setup_time_min      DECIMAL(10,2)   NOT NULL    DEFAULT 0          COMMENT '准备时间（分钟）',
    teardown_time_min   DECIMAL(10,2)   NOT NULL    DEFAULT 0          COMMENT '拆卸时间（分钟）',
    batch_size          INT             NOT NULL    DEFAULT 1          COMMENT '批量大小（每批件数）',
    overlap_ratio       DECIMAL(5,4)    NOT NULL    DEFAULT 0          COMMENT '工序重叠率（0~1），0=串行，1=完全重叠',
    move_time_min       DECIMAL(10,2)   NOT NULL    DEFAULT 0          COMMENT '转移时间（分钟）',
    quality_check       TINYINT         NOT NULL    DEFAULT 0          COMMENT '是否需要质检',
    is_critical          TINYINT         NOT NULL    DEFAULT 0          COMMENT '是否关键工序',
    priority            INT             NOT NULL    DEFAULT 100         COMMENT '优先级（越小越高）',
    next_operation_no   INT             NULL                             COMMENT '下一道工序序号（NULL表示最后一道）',
    remark              VARCHAR(500)    NULL                             COMMENT '备注',
    created_by          VARCHAR(50)     NOT NULL                        COMMENT '创建人',
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_by          VARCHAR(50)     NULL                             COMMENT '更新人',
    updated_at          DATETIME        NULL     ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_route_id (route_id),
    KEY idx_workcenter_id (workcenter_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工艺路线工序明细';

-- ----------------------------
-- 示例数据
-- ----------------------------
INSERT INTO mst_route (route_code, route_name, item_id, version, default_flag, status, created_by) VALUES
('RT-A100-001', '成品A100标准工艺路线', 5, 'V1.0', 1, 1, 'system'),
('RT-A200-001', '成品A200标准工艺路线', 6, 'V1.0', 1, 1, 'system');

INSERT INTO mst_route_operation (route_id, operation_no, operation_code, operation_name, workcenter_id, work_time_min, setup_time_min, batch_size, is_critical, priority, created_by) VALUES
(1, 10, 'OP-SMT', 'SMT贴装', 3, 30.00, 15.00, 50, 1, 10, 'system'),
(1, 20, 'OP-AOI', 'AOI光学检测', 4, 10.00, 5.00, 100, 1, 20, 'system'),
(1, 30, 'OP-ASM', '组装', 3, 45.00, 10.00, 20, 0, 30, 'system'),
(1, 40, 'OP-TEST', '功能测试', 4, 20.00, 5.00, 10, 1, 40, 'system'),
(1, 50, 'OP-PACK', '包装入库', 5, 5.00, 2.00, 100, 0, 50, 'system');
