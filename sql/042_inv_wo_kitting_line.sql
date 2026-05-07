-- ================================================================
-- APS 生产排程系统 - 业务数据：工单齐套明细行
-- 文件：042_inv_wo_kitting_line.sql
-- 说明：齐套检查结果明细行，记录每个物料的齐套状态
-- 参考：APS开发文档 §2.3.3 §8.1 表清单
-- ================================================================

-- ----------------------------
-- 表：inv_wo_kitting_line（齐套明细行）
-- ----------------------------
DROP TABLE IF EXISTS inv_wo_kitting_line;
CREATE TABLE inv_wo_kitting_line (
    id                  BIGINT          NOT NULL AUTO_INCREMENT,
    kitting_id          BIGINT          NOT NULL,                -- 关联 inv_wo_kitting.id
    work_order_id       BIGINT          NOT NULL,                -- 工单ID（冗余便于查询）
    material_id         BIGINT          NOT NULL,                -- 物料ID
    material_code       VARCHAR(50)     NOT NULL,               -- 物料编码（冗余）
    material_name       NVARCHAR(200)   DEFAULT NULL,           -- 物料名称（冗余）
    warehouse_id        BIGINT          DEFAULT NULL,           -- 首选仓库
    required_qty        DECIMAL(18,6)   NOT NULL DEFAULT 0,      -- 需求数量
    allocated_qty       DECIMAL(18,6)   NOT NULL DEFAULT 0,      -- 已分配数量
    available_qty       DECIMAL(18,6)   NOT NULL DEFAULT 0,      -- 可用量（含在途）
    shortage_qty        DECIMAL(18,6)   NOT NULL DEFAULT 0,      -- 短缺数量
    kitting_status      VARCHAR(20)     NOT NULL DEFAULT 'PENDING',  -- PENDING / PARTIAL / READY / OVERAGE
    remark              NVARCHAR(500)   DEFAULT NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by          VARCHAR(50)     NOT NULL,
    updated_by          VARCHAR(50)     NOT NULL,
    is_deleted          TINYINT(1)      NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX idx_kitting_id (kitting_id),
    INDEX idx_wo_id (work_order_id),
    INDEX idx_material_id (material_id),
    INDEX idx_kitting_status (kitting_status),
    CONSTRAINT fk_kitting_line_kitting FOREIGN KEY (kitting_id) REFERENCES inv_wo_kitting(id),
    CONSTRAINT fk_kitting_line_material FOREIGN KEY (material_id) REFERENCES mst_item(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
