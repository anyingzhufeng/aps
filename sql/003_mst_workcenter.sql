-- ================================================================
-- APS 生产排程系统 - 主数据：工作中心（产线）
-- 文件：003_mst_workcenter.sql
-- 说明：工作中心/产线主数据表，归属车间
-- ================================================================

-- ----------------------------
-- 表：mst_workcenter（工作中心/产线主数据）
-- ----------------------------
CREATE TABLE IF NOT EXISTS mst_workcenter (
    id                  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    workshop_id        BIGINT          NOT NULL                    COMMENT '所属车间ID',
    workcenter_code    VARCHAR(50)     NOT NULL                    COMMENT '工作中心代码',
    workcenter_name    VARCHAR(200)    NOT NULL                    COMMENT '工作中心名称',
    workcenter_type    VARCHAR(50)     NOT NULL                    COMMENT '工作中心类型：ASSEMBLY-组装线/PACKAGING-包装线/INSPECTION-检测线',
    production_type    VARCHAR(50)     NOT NULL                    COMMENT '生产类型：DISCRETE-离散/MASS-大批量/JOB-.job_单',
    description        VARCHAR(500)                     DEFAULT NULL COMMENT '工作中心描述',
    location           VARCHAR(200)                     DEFAULT NULL COMMENT '所在位置/产线编号',
    manager_name       VARCHAR(100)                     DEFAULT NULL COMMENT '工作中心负责人',
    is_active          TINYINT(1)       NOT NULL    DEFAULT 1       COMMENT '是否启用：1-是，0-否',
    is_deleted         TINYINT(1)       NOT NULL    DEFAULT 0       COMMENT '软删除标记',
    version            INT              NOT NULL    DEFAULT 0       COMMENT '乐观锁版本号',
    created_at         DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at         DATETIME         NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by         VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '创建人',
    updated_by         VARCHAR(100)     NOT NULL    DEFAULT 'system' COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_workcenter_code (workcenter_code),
    KEY idx_workcenter_workshop (workshop_id),
    KEY idx_workcenter_type (workcenter_type),
    KEY idx_workcenter_prod_type (production_type),
    CONSTRAINT fk_workcenter_workshop FOREIGN KEY (workshop_id) REFERENCES mst_workshop(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工作中心/产线主数据表';

-- ----------------------------
-- 种子数据：工作中心
-- ----------------------------
INSERT INTO mst_workcenter (workshop_id, workcenter_code, workcenter_name, workcenter_type, production_type, description, location, manager_name) VALUES
(1, 'WC-A1', 'A区组装线', 'ASSEMBLY', 'DISCRETE', 'A区电子组装产线，主营消费电子组装', 'A栋1楼', '张工'),
(1, 'WC-A2', 'A区包装线', 'PACKAGING', 'MASS', 'A区自动化包装产线', 'A栋1楼', '李工'),
(2, 'WC-B1', 'B区组装线', 'ASSEMBLY', 'DISCRETE', 'B区精密组装产线', 'B栋2楼', '王工'),
(2, 'WC-B2', 'B区检测线', 'INSPECTION', 'DISCRETE', 'B区成品检测与老化线', 'B栋2楼', '赵工');
