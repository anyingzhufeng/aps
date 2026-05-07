-- ================================================================
-- APS 生产排程系统 - 主数据：设备
-- 文件：004_mst_machine.sql
-- 说明：设备主数据表，归属工作中心
-- ================================================================

-- ----------------------------
-- 表：mst_machine（设备主数据）
-- ----------------------------
CREATE TABLE IF NOT EXISTS mst_machine (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    workcenter_id   BIGINT          NOT NULL                    COMMENT '所属工作中心ID',
    machine_code    VARCHAR(50)     NOT NULL                    COMMENT '设备编号',
    machine_name    VARCHAR(200)    NOT NULL                    COMMENT '设备名称',
    machine_type    VARCHAR(50)     NOT NULL                    COMMENT '设备类型：CNC/贴片机/SMT回流焊/波峰焊/ATE/老化箱/包装机/检测台',
    brand_model     VARCHAR(200)                     DEFAULT NULL COMMENT '品牌型号',
    serial_number   VARCHAR(100)                     DEFAULT NULL COMMENT '序列号',
    location        VARCHAR(200)                     DEFAULT NULL COMMENT '安装位置',
    status          VARCHAR(20)      NOT NULL    DEFAULT 'IDLE' COMMENT '设备状态：IDLE-空闲/RUNNING-运行/MAINTENANCE-维护/BREAKDOWN-故障/OFFLINE-离线',
    setup_time_min  DECIMAL(10,2)   NOT NULL    DEFAULT 0       COMMENT '换型准备时间（分钟）',
    cycle_time_base DECIMAL(10,2)   NOT NULL    DEFAULT 0       COMMENT '基准节拍时间（秒/件）',
    capacity_pcs_hr DECIMAL(10,2)                   DEFAULT NULL COMMENT '产能（件/小时）',
    is_virtual      TINYINT(1)       NOT NULL    DEFAULT 0       COMMENT '是否虚拟设备（用于排程模拟）',
    is_active       TINYINT(1)       NOT NULL    DEFAULT 1       COMMENT '是否启用：1-是，0-否',
    is_deleted      TINYINT(1)       NOT NULL    DEFAULT 0       COMMENT '软删除标记',
    version         INT              NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',
    created_at      DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '创建人',
    updated_by      VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_machine_code (machine_code),
    KEY idx_machine_workcenter (workcenter_id),
    KEY idx_machine_type (machine_type),
    KEY idx_machine_status (status),
    CONSTRAINT fk_machine_workcenter FOREIGN KEY (workcenter_id) REFERENCES mst_workcenter(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备主数据表';

-- ----------------------------
-- 种子数据：设备
-- ----------------------------
INSERT INTO mst_machine (workcenter_id, machine_code, machine_name, machine_type, brand_model, serial_number, location, status, setup_time_min, cycle_time_base, capacity_pcs_hr) VALUES
-- WC-A1（A区组装线）
(1, 'MC-A1-01', 'A1 SMT贴片机#1',    'SMT贴片机',    'Yamaha YS24',   'SN-YAM-001', 'A栋1楼-产线1', 'IDLE', 30, 12.5,  288),
(1, 'MC-A1-02', 'A1 SMT贴片机#2',    'SMT贴片机',    'Yamaha YS24',   'SN-YAM-002', 'A栋1楼-产线1', 'IDLE', 30, 12.5,  288),
(1, 'MC-A1-03', 'A1 回流焊炉',        '回流焊',        'BTU Pyramax',   'SN-BTU-001', 'A栋1楼-产线1', 'IDLE', 20, 15.0,  240),
(1, 'MC-A1-04', 'A1 波峰焊',          '波峰焊',        'Electrovert',   'SN-ELC-001', 'A栋1楼-产线1', 'IDLE', 25, 18.0,  200),
(1, 'MC-A1-05', 'A1 AOI检测仪',       'ATE',           'OGP SmartScope','SN-OGP-001', 'A栋1楼-产线1', 'IDLE', 10, 8.0,   450),
-- WC-A2（A区包装线）
(2, 'MC-A2-01', 'A2 高速包装机#1',   '包装机',        'Bosch SVE',     'SN-BOS-001', 'A栋1楼-产线2', 'IDLE', 15, 6.0,   600),
(2, 'MC-A2-02', 'A2 高速包装机#2',   '包装机',        'Bosch SVE',     'SN-BOS-002', 'A栋1楼-产线2', 'IDLE', 15, 6.0,   600),
-- WC-B1（B区组装线）
(3, 'MC-B1-01', 'B1 CNC加工中心#1',  'CNC',           'DMG MORI NLX',  'SN-DMG-001', 'B栋2楼-产线1', 'IDLE', 60, 180.0, 20),
(3, 'MC-B1-02', 'B1 CNC加工中心#2',  'CNC',           'DMG MORI NLX',  'SN-DMG-002', 'B栋2楼-产线1', 'IDLE', 60, 180.0, 20),
(3, 'MC-B1-03', 'B1 精密检测台',      '检测台',        'Zeiss Contura', 'SN-ZEI-001', 'B栋2楼-产线1', 'IDLE', 10, 120.0, 30),
-- WC-B2（B区检测线）
(4, 'MC-B2-01', 'B2 ATE测试机#1',    'ATE',           'LTX-Credence',  'SN-LTX-001', 'B栋2楼-产线2', 'IDLE', 20, 60.0,  60),
(4, 'MC-B2-02', 'B2 老化箱#1',        '老化箱',        'ESPEC SUV',     'SN-ESP-001', 'B栋2楼-产线2', 'IDLE', 5,  300.0, 12),
(4, 'MC-B2-03', 'B2 外观检测台',      '检测台',        'Cognex IS2000', 'SN-COG-001', 'B栋2楼-产线2', 'IDLE', 10, 15.0,  240);
