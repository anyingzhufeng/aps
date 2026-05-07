-- ================================================================
-- 002_mst_workshop.sql
-- 车间基础信息表（Workshop Master）
-- ================================================================
-- 摘要：定义工厂下各车间的编码、名称、类型、状态等基础信息
-- 主键：workshop_code
-- 外键：factory_code → mst_factory(factory_code)
-- 说明：一个车间属于一个工厂，一个工厂包含多个车间
-- ================================================================

-- ----------------------------
-- 1. 表结构
-- ----------------------------
DROP TABLE IF EXISTS mst_workshop;

CREATE TABLE mst_workshop (
    workshop_code    VARCHAR(20)      NOT NULL                COMMENT '车间编码（主键）',
    workshop_name    VARCHAR(100)     NOT NULL                COMMENT '车间名称',
    workshop_alias   VARCHAR(50)      NULL                    COMMENT '车间简称',
    factory_code     VARCHAR(20)      NOT NULL                COMMENT '所属工厂编码',
    workshop_type    VARCHAR(20)      NOT NULL                COMMENT '车间类型：ASSEMBLY-组装，电子/电器总装 | MACHINING-机加工，金属切削/冲压 | BATCH-批次加工，食品/化工',
    production_type  VARCHAR(20)      NOT NULL                COMMENT '生产类型：MAKE_TO_ORDER-按单生产 | MAKE_TO_STOCK-备库生产 | MIXED-混合模式',
    area_sqm         DECIMAL(10,2)    NULL                    COMMENT '车间面积（平方米）',
    manager_code     VARCHAR(20)      NULL                    COMMENT '车间主管工号',
    manager_name     VARCHAR(50)      NULL                    COMMENT '车间主管姓名',
    location_desc    VARCHAR(200)     NULL                    COMMENT '车间位置描述',
    latitude         DECIMAL(10,6)    NULL                    COMMENT '纬度（用于派工导航）',
    longitude        DECIMAL(10,6)    NULL                    COMMENT '经度（用于派工导航）',
    status           VARCHAR(20)      NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE-在用 | INACTIVE-停用 | MAINTENANCE-维护中',
    is_virtual       TINYINT(1)       NOT NULL DEFAULT 0      COMMENT '是否虚拟车间（1=虚拟，0=实体）',
    planning_horizon_days  INT        NOT NULL DEFAULT 30     COMMENT '排程视野天数（提前几天开始排）',
    scheduling_mode  VARCHAR(20)      NOT NULL DEFAULT 'FORWARD' COMMENT '排程方向：FORWARD-正向 | BACKWARD-逆向 | BIDIRECTIONAL-双向',
    time_zone        VARCHAR(50)      NOT NULL DEFAULT 'Asia/Shanghai' COMMENT '车间所在时区',
    currency_code    VARCHAR(3)       NOT NULL DEFAULT 'CNY'  COMMENT '成本结算货币',
    cost_center_code VARCHAR(20)      NULL                    COMMENT '成本中心编码',
    remarks          VARCHAR(500)     NULL                    COMMENT '备注',
    created_at       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by       VARCHAR(36)      NULL                    COMMENT '创建人',
    updated_by       VARCHAR(36)      NULL                    COMMENT '更新人',

    PRIMARY KEY (workshop_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='车间基础信息表';

-- ----------------------------
-- 2. 索引
-- ----------------------------
-- 工厂维度查询
CREATE INDEX idx_factory_code ON mst_workshop(factory_code);

-- 状态过滤
CREATE INDEX idx_status ON mst_workshop(status);

-- 车间类型
CREATE INDEX idx_workshop_type ON mst_workshop(workshop_type);

-- 主管查询
CREATE INDEX idx_manager_code ON mst_workshop(manager_code);

-- ----------------------------
-- 3. 外键约束
-- ----------------------------
ALTER TABLE mst_workshop
    ADD CONSTRAINT fk_workshop_factory
    FOREIGN KEY (factory_code) REFERENCES mst_factory(factory_code)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- ----------------------------
-- 4. 基础数据（示例）
-- ----------------------------
INSERT INTO mst_workshop (workshop_code, workshop_name, workshop_alias, factory_code, workshop_type, production_type, area_sqm, manager_code, manager_name, location_desc, status, is_virtual, planning_horizon_days, scheduling_mode, remarks) VALUES
-- 电子组装车间
('WS-ASSY-01', '电子组装一车间', '组装一', 'FAC-001', 'ASSEMBLY', 'MAKE_TO_ORDER', 1200.00, 'EMP-001', '张工', 'A栋1层', 'ACTIVE', 0, 14, 'FORWARD', '主组装线，SMT后段'),
('WS-ASSY-02', '电子组装二车间', '组装二', 'FAC-001', 'ASSEMBLY', 'MAKE_TO_ORDER', 980.00,  'EMP-002', '李工', 'A栋2层', 'ACTIVE', 0, 14, 'FORWARD', '辅组装线，包装段'),
-- 机加工车间
('WS-MACH-01', '机加工车间', '金工', 'FAC-001', 'MACHINING', 'MIXED', 2500.00, 'EMP-003', '王工', 'B栋1层', 'ACTIVE', 0, 21, 'BIDIRECTIONAL', '含CNC/冲压/焊接工段'),
-- 批次加工车间
('WS-BATCH-01', '批次加工车间', '批次', 'FAC-001', 'BATCH', 'MAKE_TO_STOCK', 1800.00, 'EMP-004', '刘工', 'C栋1层', 'ACTIVE', 0, 30, 'BACKWARD', '食品级净化车间'),
-- 虚拟车间（用于跨车间协同）
('WS-VIR-01', '虚拟总装车间', '总装协同', 'FAC-001', 'ASSEMBLY', 'MIXED', NULL, NULL, NULL, NULL, 'ACTIVE', 1, 7, 'FORWARD', '跨多条产线的协同排程虚拟节点');

-- ----------------------------
-- 5. 排程相关配置说明
-- ----------------------------
-- planning_horizon_days：
--   指从"当前日期"起提前多少天开始将工单纳入排程。
--   例：值为14表示只排未来14天内的工单，更远的工单暂不排入。
--
-- scheduling_mode：
--   FORWARD（正向）：从工单可用时间往后排，尽量早开工
--   BACKWARD（逆向）：从交期往前推，算出最晚开工时间
--   BIDIRECTIONAL（双向）：同时进行正向和逆向排程，冲突时按优先级取舍
--
-- workshop_type 业务含义：
--   ASSEMBLY（组装车间）：多品种小批量，换线频繁，需关注产线平衡
--   MACHINING（机加工车间）：设备产能固定，需考虑换型/刀具寿命
--   BATCH（批次加工）：整批投入产出，需关注批次切换清洗时间