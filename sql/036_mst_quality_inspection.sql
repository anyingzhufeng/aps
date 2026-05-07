-- ================================================================
-- 036_mst_quality_inspection.sql
-- 质量管理：质检标准与检验单
-- ================================================================

-- 质检标准定义表（每种物料/工序的质量检查规则）
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE qms_inspection_standard (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    standard_code       VARCHAR(64)     NOT NULL    COMMENT '质检标准编码',
    standard_name       NVARCHAR(200)  NOT NULL    COMMENT '质检标准名称',
    item_id             BIGINT          NULL        COMMENT '关联物料ID（可选，不填则为通用标准）',
    routing_op_id       BIGINT          NULL        COMMENT '关联工序ID（可选）',
    check_type          TINYINT         NOT NULL    DEFAULT 1 COMMENT '检查类型：1=来料检验 IQC，2=过程检验 IPQC，3=成品检验 OQC，4=出货检验',
    sample_plan         VARCHAR(50)     NULL        COMMENT '抽样方案：AQL标准 如 MIL-STD-105E',
    aql_level           DECIMAL(3,2)    NULL        COMMENT 'AQL 接收质量限',
    inspection_type     TINYINT         NOT NULL    DEFAULT 1 COMMENT '检验方式：1=全检，2=抽检，3=免检',
    check_items         JSON            NULL        COMMENT '检查项目 JSON：[{"item":"外观","method":"目测","criteria":"无划伤","acc_type":"count","ucl":"","lcl":"","usl":""}]',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_standard_code (standard_code),
    KEY idx_item_id    (item_id),
    KEY idx_routing_op_id (routing_op_id),
    KEY idx_check_type  (check_type),
    KEY idx_is_active  (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='质检标准定义表';

-- 检验单主表
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE qms_inspection_order (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    iorder_no           VARCHAR(64)     NOT NULL    COMMENT '检验单号',
    iorder_type         TINYINT         NOT NULL    COMMENT '检验类型：1=IQC来料，2=IPQC过程，3=OQC成品，4=FQC完工',
    standard_id         BIGINT          NULL        COMMENT '质检标准ID',
    item_id             BIGINT          NOT NULL    COMMENT '检验物料ID',
    wo_id               BIGINT          NULL        COMMENT '关联工单ID（过程/成品检验）',
    wo_operation_id     BIGINT          NULL        COMMENT '关联工序ID',
    batch_no            VARCHAR(64)     NULL        COMMENT '批次号',
    sample_qty          INT             NULL        COMMENT '抽样数量',
    inspected_qty       INT             NULL        DEFAULT 0 COMMENT '已检验数量',
    pass_qty            INT             NULL        DEFAULT 0 COMMENT '合格数量',
    fail_qty            INT             NULL        DEFAULT 0 COMMENT '不合格数量',
    inspection_result   TINYINT         NULL        COMMENT '检验结果：1=合格，2=不合格，3=让步接收，4=特采',
    defect_rate         DECIMAL(8,4)    NULL        COMMENT '不合格率',
    aql_verdict         VARCHAR(10)     NULL        COMMENT 'AQL判定：ACCEPT/REJECT',
    inspector_id        VARCHAR(64)     NULL        COMMENT '质检员ID',
    inspect_at          DATETIME        NULL        COMMENT '检验时间',
    remark              NVARCHAR(500)   NULL        COMMENT '备注',
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_iorder_no (iorder_no),
    KEY idx_iorder_type (iorder_type),
    KEY idx_item_id    (item_id),
    KEY idx_wo_id      (wo_id),
    KEY idx_batch_no   (batch_no),
    KEY idx_inspector_id (inspector_id),
    KEY idx_inspect_at (inspect_at),
    KEY idx_inspection_result (inspection_result)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='检验单主表';

-- 检验单明细行（每条检验记录）
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE qms_inspection_order_line (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    iorder_id           BIGINT          NOT NULL    COMMENT '检验单ID',
    check_item         VARCHAR(200)    NOT NULL    COMMENT '检查项目名称',
    check_method       VARCHAR(200)    NULL        COMMENT '检验方法',
    check_criteria      NVARCHAR(500)   NULL        COMMENT '判定标准',
    inspection_type     TINYINT         NOT NULL    DEFAULT 2 COMMENT '检验方式：1=计数型，2=计量型',
    sample_size         INT             NULL        COMMENT '抽样数',
    pass_count          INT             NULL        DEFAULT 0 COMMENT '合格数',
    fail_count          INT             NULL        DEFAULT 0 COMMENT '不合格数',
    measured_value      DECIMAL(18,6)   NULL        COMMENT '实测值（计量型）',
    usl                 DECIMAL(18,6)   NULL        COMMENT '规格上限 USL',
    ucl                 DECIMAL(18,6)   NULL        COMMENT '控制上限 UCL',
    lcl                 DECIMAL(18,6)   NULL        COMMENT '控制下限 LCL',
    lsl                 DECIMAL(18,6)   NULL        COMMENT '规格下限 LSL',
    cpk                 DECIMAL(8,4)    NULL        COMMENT '过程能力指数 CPK',
    line_result         TINYINT         NULL        COMMENT '单项判定：1=合格，2=不合格',
    defect_id           BIGINT          NULL        COMMENT '缺陷ID（关联缺陷代码表）',
    remark              NVARCHAR(200)   NULL        COMMENT '备注',
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_iorder_id  (iorder_id),
    KEY idx_defect_id  (defect_id),
    KEY idx_line_result (line_result)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='检验单明细行';

-- 缺陷代码表
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE qms_defect_code (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    defect_code         VARCHAR(64)     NOT NULL    COMMENT '缺陷代码',
    defect_name         NVARCHAR(200)  NOT NULL    COMMENT '缺陷名称',
    defect_level        TINYINT         NOT NULL    COMMENT '缺陷等级：1=严重（CR），2=主要（MA），3=次要（MI）',
    defect_category     VARCHAR(50)     NULL        COMMENT '缺陷类别：外观/功能/尺寸/性能',
    owner_dept          VARCHAR(64)     NULL        COMMENT '责任部门',
    is_active           TINYINT         NOT NULL    DEFAULT 1,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64)     NULL,
    updated_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_defect_code (defect_code),
    KEY idx_defect_level (defect_level),
    KEY idx_defect_category (defect_category),
    KEY idx_is_active  (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='缺陷代码表';

-- 质检报告附件表
DROP TABLE IF EXISTS CREATE TABLE;
CREATE TABLE qms_inspection_attachment (
    id                  BIGINT          NOT NULL    PRIMARY KEY,
    iorder_id           BIGINT          NOT NULL    COMMENT '检验单ID',
    file_name           VARCHAR(255)    NOT NULL    COMMENT '文件名',
    file_path           VARCHAR(500)    NOT NULL    COMMENT '文件路径',
    file_type           VARCHAR(50)     NULL        COMMENT '文件类型：photo/report/certificate',
    file_size           BIGINT          NULL        COMMENT '文件大小（字节）',
    uploaded_by         VARCHAR(64)     NULL,
    uploaded_at         DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    created_by          VARCHAR(64)     NULL,
    created_at          DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    KEY idx_iorder_id  (iorder_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='质检报告附件表';
