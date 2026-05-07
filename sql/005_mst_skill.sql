-- ================================================================
-- SQL #005：mst_skill（技能/工种主数据表）
-- APS开发文档 §5.1.5
-- ================================================================

-- ----------------------------
-- 表：mst_skill（技能/工种主数据）
-- ----------------------------
DROP TABLE IF EXISTS mst_skill;
CREATE TABLE mst_skill (
    id              BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '主键ID',
    skill_code      VARCHAR(50)     NOT NULL                        COMMENT '技能编码',
    skill_name      VARCHAR(200)    NOT NULL                        COMMENT '技能名称',
    skill_category  VARCHAR(50)     NOT NULL                        COMMENT '技能类别（焊接/组装/检测/包装/维修等）',
    description     VARCHAR(500)    NULL                             COMMENT '技能描述',
    is_active       TINYINT(1)      NOT NULL    DEFAULT 1           COMMENT '是否启用（1=是，0=否）',
    created_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      VARCHAR(100)    NOT NULL    DEFAULT 'system'    COMMENT '创建人',
    updated_by      VARCHAR(100)    NOT NULL    DEFAULT 'system'   COMMENT '更新人',
    PRIMARY KEY (id),
    UNIQUE KEY uk_skill_code (skill_code),
    KEY idx_skill_category (skill_category),
    KEY idx_skill_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='技能/工种主数据表';

-- ----------------------------
-- 种子数据：技能
-- ----------------------------
INSERT INTO mst_skill (skill_code, skill_name, skill_category, description) VALUES
-- 生产线操作技能
('SKL-SMT',    'SMT贴片操作',      '焊接',    'SMT贴片机操作与编程，能独立完成贴装调试'),
('SKL-REF',    '回流焊操作',        '焊接',    '回流焊炉温度曲线设置与调试'),
('SKL-WAVE',   '波峰焊操作',        '焊接',    '波峰焊机操作与焊锡参数调整'),
('SKL-AOI',    'AOI光学检测',       '检测',    'AOI设备操作与误报率优化'),
('SKL-CNC',    'CNC加工中心操作',   '加工',    'CNC数控编程与加工操作'),
('SKL-ATE',    'ATE测试操作',       '检测',    'ICT/FCT自动测试设备操作'),
('SKL-PACK',   '包装操作',          '包装',    '产品包装与出货检查'),
('SKL-MAINT',  '设备维修',          '维修',    '设备日常维护与故障排除'),
('SKL-QC',     '质量检验',          '检测',    'QC检验标准执行与判定'),
('SKL-MAT',    '物料管理',          '仓储',    '物料收发与库存管理');
