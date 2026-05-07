-- ============================================================
-- APS 开发文档 - SQL 文件 #093
-- 表名：mst_workshop（车间主表）- 完整版（含所有业务字段）
-- 说明：作为工厂下的生产组织单元，记录车间基础信息与配置参数
-- 创建时间：2026-05-07
-- ============================================================

-- -----------------------------------------------------------
-- 1. 表结构
-- -----------------------------------------------------------
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE IF NOT EXISTS mst_workshop (
    -- 主键 & 编码
    workshop_id     CHAR(10)        NOT NULL COMMENT '车间编码（主键）',
    workshop_name   VARCHAR(100)   NOT NULL COMMENT '车间名称',
    workshop_type   VARCHAR(20)    DEFAULT 'production' COMMENT '车间类型：production/gateway/utility',
    
    -- 所属关系
    factory_id      CHAR(10)        NOT NULL COMMENT '所属工厂编码',
    parent_id       CHAR(10)        NULL     COMMENT '上级车间编码（用于多级车间）',
    
    -- 基础信息
    manager_id      CHAR(10)        NULL     COMMENT '车间负责人ID',
    location        VARCHAR(200)    NULL     COMMENT '地理位置/厂房地址',
    area_sqm        DECIMAL(10,2)   NULL     COMMENT '车间面积（平方米）',
    
    -- 状态 & 开关
    is_active       TINYINT(1)      DEFAULT 1 COMMENT '是否启用：1启用 0禁用',
    status          VARCHAR(20)    DEFAULT 'normal' COMMENT '状态：normal/maintenance/idle/offline',
    
    -- 产能参数
    max_worker_cnt  INT             DEFAULT 0 COMMENT '最大容纳工人数',
    max_machine_cnt INT             DEFAULT 0 COMMENT '最大机器数',
    throughput_cap  DECIMAL(12,2)   DEFAULT 0 COMMENT '日产能上限（标准工时）',
    
    -- 时间配置
    calendar_id     CHAR(10)        NULL     COMMENT '关联日历ID',
    shift_count     INT             DEFAULT 1 COMMENT '每日班次数',
    
    -- 成本信息
    cost_center_id  CHAR(10)        NULL     COMMENT '成本中心',
    overhead_rate   DECIMAL(8,4)   DEFAULT 0 COMMENT '制造费用分摊率',
    
    -- 扩展字段（JSON）
    ext_data        JSON           NULL     COMMENT '扩展属性（JSON）',
    
    -- ERP 同步
    erp_workshop_code VARCHAR(50)   NULL     COMMENT 'ERP车间编码（对接用）',
    sync_status     VARCHAR(20)    DEFAULT 'synced' COMMENT '同步状态',
    last_sync_time  DATETIME        NULL     COMMENT '最后同步时间',
    
    -- 审计字段
    created_at      DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(50)     DEFAULT 'system' COMMENT '创建人',
    updated_by      VARCHAR(50)     DEFAULT 'system' COMMENT '更新人',
    is_deleted      TINYINT(1)      DEFAULT 0 COMMENT '逻辑删除标记',
    
    CONSTRAINT pk_mst_workshop PRIMARY KEY (workshop_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车间主表';

-- -----------------------------------------------------------
-- 2. 索引
-- -----------------------------------------------------------
CREATE INDEX idx_workshop_factory ON mst_workshop(factory_id);
CREATE INDEX idx_workshop_parent   ON mst_workshop(parent_id);
CREATE INDEX idx_workshop_manager  ON mst_workshop(manager_id);
CREATE INDEX idx_workshop_status   ON mst_workshop(status, is_active);
CREATE INDEX idx_workshop_erp      ON mst_workshop(erp_workshop_code);

-- -----------------------------------------------------------
-- 3. 外键约束
-- -----------------------------------------------------------
ALTER TABLE mst_workshop
    ADD CONSTRAINT fk_workshop_factory
        FOREIGN KEY (factory_id) REFERENCES mst_factory(factory_id)
        ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE mst_workshop
    ADD CONSTRAINT fk_workshop_parent
        FOREIGN KEY (parent_id) REFERENCES mst_workshop(workshop_id)
        ON DELETE SET NULL ON UPDATE CASCADE;

-- -----------------------------------------------------------
-- 4. 初始数据
-- -----------------------------------------------------------
INSERT INTO mst_workshop (workshop_id, workshop_name, workshop_type,
    factory_id, max_worker_cnt, max_machine_cnt, is_active, status)
VALUES
    ('WSH001', '组装一车间',     'production', 'FAC001', 80,  40,  1, 'normal'),
    ('WSH002', '组装二车间',     'production', 'FAC001', 60,  30,  1, 'normal'),
    ('WSH003', '焊接车间',       'production', 'FAC001', 40,  50,  1, 'normal'),
    ('WSH004', '冲压车间',       'production', 'FAC002', 30,  20,  1, 'normal'),
    ('WSH005', '表面处理车间',   'production', 'FAC002', 25,  15,  1, 'maintenance'),
    ('WSH006', '物流转运车间',   'gateway',    'FAC001', 10,   5,  1, 'normal'),
    ('WSH007', '公用工程车间',   'utility',    'FAC001',  5,   3,  1, 'normal');

-- -----------------------------------------------------------
-- 5. 视图（车间产能汇总）
-- -----------------------------------------------------------
CREATE OR REPLACE VIEW v_workshop_capacity AS
SELECT
    w.workshop_id,
    w.workshop_name,
    w.factory_id,
    w.workshop_type,
    w.max_worker_cnt,
    w.max_machine_cnt,
    w.throughput_cap,
    w.status,
    w.is_active,
    COALESCE(c.workdays_year, 250) AS workdays_year,
    ROUND(w.throughput_cap * COALESCE(c.workdays_year, 250), 2) AS annual_capacity
FROM mst_workshop w
LEFT JOIN mst_calendar c ON w.calendar_id = c.calendar_id
WHERE w.is_deleted = 0;
