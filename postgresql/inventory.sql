/*
 Navicat Premium Data Transfer

 Source Server         : DB_MAIN
 Source Server Type    : PostgreSQL
 Source Server Version : 120005
 Source Host           : 10.1.91.130:9999
 Source Catalog        : sale
 Source Schema         : inventory

 Target Server Type    : PostgreSQL
 Target Server Version : 120005
 File Encoding         : 65001

 Date: 02/12/2021 09:19:05
*/


-- ----------------------------
-- Type structure for gtrgm
-- ----------------------------
DROP TYPE IF EXISTS "inventory"."gtrgm";
CREATE TYPE "inventory"."gtrgm" (
  INPUT = "inventory"."gtrgm_in",
  OUTPUT = "inventory"."gtrgm_out",
  INTERNALLENGTH = VARIABLE,
  CATEGORY = U,
  DELIMITER = ','
);
ALTER TYPE "inventory"."gtrgm" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for config_require_used_time_before_mnp_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."config_require_used_time_before_mnp_id_seq";
CREATE SEQUENCE "inventory"."config_require_used_time_before_mnp_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."config_require_used_time_before_mnp_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for ftp_file_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."ftp_file_id_seq";
CREATE SEQUENCE "inventory"."ftp_file_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."ftp_file_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for isdn_format_search_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."isdn_format_search_id_seq";
CREATE SEQUENCE "inventory"."isdn_format_search_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."isdn_format_search_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for isdn_head_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."isdn_head_id_seq";
CREATE SEQUENCE "inventory"."isdn_head_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."isdn_head_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for isdn_his_detail_detail_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."isdn_his_detail_detail_id_seq";
CREATE SEQUENCE "inventory"."isdn_his_detail_detail_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."isdn_his_detail_detail_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for isdn_his_his_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."isdn_his_his_id_seq";
CREATE SEQUENCE "inventory"."isdn_his_his_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."isdn_his_his_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for isdn_his_new_his_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."isdn_his_new_his_id_seq";
CREATE SEQUENCE "inventory"."isdn_his_new_his_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."isdn_his_new_his_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for isdn_rule_beta_rule_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."isdn_rule_beta_rule_id_seq";
CREATE SEQUENCE "inventory"."isdn_rule_beta_rule_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."isdn_rule_beta_rule_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for isdn_rule_type_beta_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."isdn_rule_type_beta_id_seq";
CREATE SEQUENCE "inventory"."isdn_rule_type_beta_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."isdn_rule_type_beta_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for kit_his_detail_detail_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."kit_his_detail_detail_id_seq";
CREATE SEQUENCE "inventory"."kit_his_detail_detail_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."kit_his_detail_detail_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for kit_his_his_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."kit_his_his_id_seq";
CREATE SEQUENCE "inventory"."kit_his_his_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."kit_his_his_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for kit_insert_history_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."kit_insert_history_id_seq";
CREATE SEQUENCE "inventory"."kit_insert_history_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."kit_insert_history_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for kit_job_info_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."kit_job_info_id_seq";
CREATE SEQUENCE "inventory"."kit_job_info_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."kit_job_info_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for kit_package_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."kit_package_id_seq";
CREATE SEQUENCE "inventory"."kit_package_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."kit_package_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for log_kit_job_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."log_kit_job_id_seq";
CREATE SEQUENCE "inventory"."log_kit_job_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."log_kit_job_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for log_transaction_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."log_transaction_id_seq";
CREATE SEQUENCE "inventory"."log_transaction_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."log_transaction_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for option_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."option_id_seq";
CREATE SEQUENCE "inventory"."option_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."option_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for option_value_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."option_value_id_seq";
CREATE SEQUENCE "inventory"."option_value_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."option_value_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for paging_config_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."paging_config_id_seq";
CREATE SEQUENCE "inventory"."paging_config_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."paging_config_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for pre_kit_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."pre_kit_id_seq";
CREATE SEQUENCE "inventory"."pre_kit_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."pre_kit_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for sim_authen_log_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."sim_authen_log_id_seq";
CREATE SEQUENCE "inventory"."sim_authen_log_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."sim_authen_log_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for sim_history_detail_detail_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."sim_history_detail_detail_id_seq";
CREATE SEQUENCE "inventory"."sim_history_detail_detail_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."sim_history_detail_detail_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for sim_history_his_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inventory"."sim_history_his_id_seq";
CREATE SEQUENCE "inventory"."sim_history_his_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;
ALTER SEQUENCE "inventory"."sim_history_his_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Table structure for config_require_used_time_before_mnp
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."config_require_used_time_before_mnp";
CREATE TABLE "inventory"."config_require_used_time_before_mnp" (
  "id" int4 NOT NULL DEFAULT nextval('"inventory".config_require_used_time_before_mnp_id_seq'::regclass),
  "isdn_price_range" int4range NOT NULL,
  "require_used_time" int4,
  "create_at" timestamp(0),
  "create_by" varchar COLLATE "pg_catalog"."default",
  "update_at" timestamp(0),
  "update_by" varchar COLLATE "pg_catalog"."default",
  "isdn_rule_type" int4
)
;
ALTER TABLE "inventory"."config_require_used_time_before_mnp" OWNER TO "postgres";

-- ----------------------------
-- Table structure for ftp_file
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."ftp_file";
CREATE TABLE "inventory"."ftp_file" (
  "id" int8 NOT NULL DEFAULT nextval('"inventory".ftp_file_id_seq'::regclass),
  "ftp_user" varchar(255) COLLATE "pg_catalog"."default",
  "file_name" varchar(255) COLLATE "pg_catalog"."default",
  "ftp_host" varchar(255) COLLATE "pg_catalog"."default",
  "uploaded_at" varchar(255) COLLATE "pg_catalog"."default",
  "ftp_pass" varchar(255) COLLATE "pg_catalog"."default",
  "cust_id" varchar(255) COLLATE "pg_catalog"."default",
  "function" varchar(255) COLLATE "pg_catalog"."default",
  "ftp_path" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."ftp_file" OWNER TO "postgres";

-- ----------------------------
-- Table structure for home_network
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."home_network";
CREATE TABLE "inventory"."home_network" (
  "id" int8 NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."home_network" OWNER TO "postgres";

-- ----------------------------
-- Table structure for isdn
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn";
CREATE TABLE "inventory"."isdn" (
  "isdn" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "create_at" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "status_id" int8,
  "type_id" int8 DEFAULT 0,
  "price_custom" int8,
  "price_default" int8,
  "role_id" int8,
  "shop_id" int8 DEFAULT 0,
  "update_at" timestamp(6),
  "object_holding" int2 DEFAULT 0,
  "sold" int2 DEFAULT 0,
  "level" int8,
  "version" int8,
  "mnp" int2 DEFAULT 0,
  "session_keeping" varchar COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."isdn" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."isdn"."isdn" IS 'Định danh số điện thoại';
COMMENT ON COLUMN "inventory"."isdn"."create_at" IS 'Ngày thêm số vào kho';
COMMENT ON COLUMN "inventory"."isdn"."create_by" IS 'Người thêm số';
COMMENT ON COLUMN "inventory"."isdn"."update_by" IS 'Người cập nhật';
COMMENT ON COLUMN "inventory"."isdn"."status_id" IS 'Trạng thái số';
COMMENT ON COLUMN "inventory"."isdn"."type_id" IS 'Loại số';
COMMENT ON COLUMN "inventory"."isdn"."price_custom" IS 'Giá đã điều chỉnh';
COMMENT ON COLUMN "inventory"."isdn"."price_default" IS 'Giá mặc định';
COMMENT ON COLUMN "inventory"."isdn"."role_id" IS 'Rule số đẹp';
COMMENT ON COLUMN "inventory"."isdn"."shop_id" IS 'id shop đang giữ số';
COMMENT ON COLUMN "inventory"."isdn"."update_at" IS 'Ngày cập nhật';
COMMENT ON COLUMN "inventory"."isdn"."object_holding" IS 'Đối tượng đang giữ số';
COMMENT ON COLUMN "inventory"."isdn"."sold" IS 'Trạng thái đã bán: 0 - chưa bán , 1 - đã bán';
COMMENT ON COLUMN "inventory"."isdn"."mnp" IS 'Đánh dấu số mnp (0 - Số reddi, 1 - Số Mnp)';

-- ----------------------------
-- Table structure for isdn_beta
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_beta";
CREATE TABLE "inventory"."isdn_beta" (
  "isdn" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "role_id" int8
)
;
ALTER TABLE "inventory"."isdn_beta" OWNER TO "postgres";

-- ----------------------------
-- Table structure for isdn_bk211101
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_bk211101";
CREATE TABLE "inventory"."isdn_bk211101" (
  "isdn" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "create_at" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "status_id" int8,
  "type_id" int8 DEFAULT 0,
  "price_custom" int8,
  "price_default" int8,
  "role_id" int8,
  "shop_id" int8 DEFAULT 0,
  "update_at" timestamp(6),
  "object_holding" int2 DEFAULT 0,
  "sold" int2 DEFAULT 0,
  "level" int8,
  "version" int8,
  "mnp" int2 DEFAULT 0
)
;
ALTER TABLE "inventory"."isdn_bk211101" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."isdn_bk211101"."isdn" IS 'Định danh số điện thoại';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."create_at" IS 'Ngày thêm số vào kho';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."create_by" IS 'Người thêm số';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."update_by" IS 'Người cập nhật';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."status_id" IS 'Trạng thái số';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."type_id" IS 'Loại số';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."price_custom" IS 'Giá đã điều chỉnh';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."price_default" IS 'Giá mặc định';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."role_id" IS 'Rule số đẹp';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."shop_id" IS 'id shop đang giữ số';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."update_at" IS 'Ngày cập nhật';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."object_holding" IS 'Đối tượng đang giữ số';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."sold" IS 'Trạng thái đã bán: 0 - chưa bán , 1 - đã bán';
COMMENT ON COLUMN "inventory"."isdn_bk211101"."mnp" IS 'Đánh dấu số mnp (0 - Số reddi, 1 - Số Mnp)';

-- ----------------------------
-- Table structure for isdn_format_search
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_format_search";
CREATE TABLE "inventory"."isdn_format_search" (
  "id" int8 NOT NULL DEFAULT nextval('"inventory".isdn_format_search_id_seq'::regclass),
  "format" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "status" int8,
  "priority" int4
)
;
ALTER TABLE "inventory"."isdn_format_search" OWNER TO "postgres";

-- ----------------------------
-- Table structure for isdn_head
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_head";
CREATE TABLE "inventory"."isdn_head" (
  "isdn_head" varchar(10) COLLATE "pg_catalog"."default",
  "create_date" timestamp(6),
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "id" int4 NOT NULL DEFAULT nextval('"inventory".isdn_head_id_seq'::regclass)
)
;
ALTER TABLE "inventory"."isdn_head" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."isdn_head"."isdn_head" IS 'Đầu số';
COMMENT ON COLUMN "inventory"."isdn_head"."create_date" IS 'Ngày tạo';
COMMENT ON COLUMN "inventory"."isdn_head"."creator" IS 'Người tạo';
COMMENT ON COLUMN "inventory"."isdn_head"."description" IS 'Mô tả';
COMMENT ON COLUMN "inventory"."isdn_head"."id" IS 'id của bảng';

-- ----------------------------
-- Table structure for isdn_his
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_his";
CREATE TABLE "inventory"."isdn_his" (
  "action" varchar(50) COLLATE "pg_catalog"."default",
  "create_date" timestamp(6),
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "user_action" varchar(255) COLLATE "pg_catalog"."default",
  "isdn" varchar(255) COLLATE "pg_catalog"."default",
  "his_id" int4 NOT NULL DEFAULT nextval('"inventory".isdn_his_his_id_seq'::regclass),
  "reason_id" int4,
  "reason" text COLLATE "pg_catalog"."default",
  "attack_file" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."isdn_his" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."isdn_his"."action" IS 'Hành động diễn ra';
COMMENT ON COLUMN "inventory"."isdn_his"."create_date" IS 'Ngày tạo';
COMMENT ON COLUMN "inventory"."isdn_his"."description" IS 'Mô tả';
COMMENT ON COLUMN "inventory"."isdn_his"."user_action" IS 'Người tác động ';
COMMENT ON COLUMN "inventory"."isdn_his"."isdn" IS 'Số bị tác động';
COMMENT ON COLUMN "inventory"."isdn_his"."his_id" IS 'id của bảng';
COMMENT ON COLUMN "inventory"."isdn_his"."reason_id" IS 'id lý do';
COMMENT ON COLUMN "inventory"."isdn_his"."reason" IS 'chi tiết lý do thay đổi ';
COMMENT ON COLUMN "inventory"."isdn_his"."attack_file" IS 'file đính kèm(nếu có)';

-- ----------------------------
-- Table structure for isdn_his_detail
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_his_detail";
CREATE TABLE "inventory"."isdn_his_detail" (
  "description" text COLLATE "pg_catalog"."default",
  "detail_id" int4 NOT NULL DEFAULT nextval('"inventory".isdn_his_detail_detail_id_seq'::regclass),
  "his_id" int8
)
;
ALTER TABLE "inventory"."isdn_his_detail" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."isdn_his_detail"."description" IS 'Mô tả';
COMMENT ON COLUMN "inventory"."isdn_his_detail"."detail_id" IS 'id của bảng';
COMMENT ON COLUMN "inventory"."isdn_his_detail"."his_id" IS 'id của bảng lịch sử thay đổi số';

-- ----------------------------
-- Table structure for isdn_his_new
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_his_new";
CREATE TABLE "inventory"."isdn_his_new" (
  "isdn" varchar(255) COLLATE "pg_catalog"."default",
  "his_id" int8 NOT NULL DEFAULT nextval('"inventory".isdn_his_new_his_id_seq'::regclass),
  "name_field" varchar COLLATE "pg_catalog"."default",
  "value_before" varchar COLLATE "pg_catalog"."default",
  "value_after" varchar COLLATE "pg_catalog"."default",
  "change_on" timestamp(0),
  "change_by" varchar COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."isdn_his_new" OWNER TO "postgres";

-- ----------------------------
-- Table structure for isdn_imsi_hlr
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_imsi_hlr";
CREATE TABLE "inventory"."isdn_imsi_hlr" (
  "id" varchar(255) COLLATE "pg_catalog"."default",
  "imsi_hlr" varchar(255) COLLATE "pg_catalog"."default",
  "updated_date" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."isdn_imsi_hlr" OWNER TO "postgres";

-- ----------------------------
-- Table structure for isdn_masan
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_masan";
CREATE TABLE "inventory"."isdn_masan" (
  "isdn" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "create_at" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "status_id" int8,
  "update_at" timestamp(6)
)
;
ALTER TABLE "inventory"."isdn_masan" OWNER TO "postgres";

-- ----------------------------
-- Table structure for isdn_role_mapping
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_role_mapping";
CREATE TABLE "inventory"."isdn_role_mapping" (
  "isdn" int8 NOT NULL,
  "role_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "inventory"."isdn_role_mapping" OWNER TO "postgres";

-- ----------------------------
-- Table structure for isdn_rule
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_rule";
CREATE TABLE "inventory"."isdn_rule" (
  "rule_id" int8 NOT NULL DEFAULT nextval('"inventory".isdn_rule_beta_rule_id_seq'::regclass),
  "rule_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "regex" text COLLATE "pg_catalog"."default",
  "status" int4 DEFAULT 0,
  "level" int4 DEFAULT 1,
  "default_price" int8,
  "description" text COLLATE "pg_catalog"."default",
  "example" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."isdn_rule" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."isdn_rule"."rule_id" IS 'id của bảng';
COMMENT ON COLUMN "inventory"."isdn_rule"."rule_name" IS 'Tên loại số đep';
COMMENT ON COLUMN "inventory"."isdn_rule"."regex" IS 'Regex của loại số đẹp';
COMMENT ON COLUMN "inventory"."isdn_rule"."status" IS 'Trạng thái của rule';
COMMENT ON COLUMN "inventory"."isdn_rule"."level" IS 'Độ ưu tiên của rule';
COMMENT ON COLUMN "inventory"."isdn_rule"."default_price" IS 'Giá mặc định của rule';
COMMENT ON COLUMN "inventory"."isdn_rule"."description" IS 'Mô tả';
COMMENT ON COLUMN "inventory"."isdn_rule"."example" IS 'Ví dụ về rule';

-- ----------------------------
-- Table structure for isdn_rule_bk12072021
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_rule_bk12072021";
CREATE TABLE "inventory"."isdn_rule_bk12072021" (
  "rule_id" int8 NOT NULL,
  "rule_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "regex" text COLLATE "pg_catalog"."default",
  "status" int4 DEFAULT 0,
  "level" int4 DEFAULT 1,
  "default_price" int8,
  "description" text COLLATE "pg_catalog"."default",
  "example" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."isdn_rule_bk12072021" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."isdn_rule_bk12072021"."rule_id" IS 'id của bảng';
COMMENT ON COLUMN "inventory"."isdn_rule_bk12072021"."rule_name" IS 'Tên loại số đep';
COMMENT ON COLUMN "inventory"."isdn_rule_bk12072021"."regex" IS 'Regex của loại số đẹp';
COMMENT ON COLUMN "inventory"."isdn_rule_bk12072021"."status" IS 'Trạng thái của rule';
COMMENT ON COLUMN "inventory"."isdn_rule_bk12072021"."level" IS 'Độ ưu tiên của rule';
COMMENT ON COLUMN "inventory"."isdn_rule_bk12072021"."default_price" IS 'Giá mặc định của rule';
COMMENT ON COLUMN "inventory"."isdn_rule_bk12072021"."description" IS 'Mô tả';
COMMENT ON COLUMN "inventory"."isdn_rule_bk12072021"."example" IS 'Ví dụ về rule';

-- ----------------------------
-- Table structure for isdn_rule_copy1
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_rule_copy1";
CREATE TABLE "inventory"."isdn_rule_copy1" (
  "rule_id" int8 NOT NULL,
  "rule_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "regex" text COLLATE "pg_catalog"."default",
  "status" int4 DEFAULT 0,
  "level" int4 DEFAULT 1,
  "default_price" int8,
  "description" text COLLATE "pg_catalog"."default",
  "example" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."isdn_rule_copy1" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."isdn_rule_copy1"."rule_id" IS 'id của bảng';
COMMENT ON COLUMN "inventory"."isdn_rule_copy1"."rule_name" IS 'Tên loại số đep';
COMMENT ON COLUMN "inventory"."isdn_rule_copy1"."regex" IS 'Regex của loại số đẹp';
COMMENT ON COLUMN "inventory"."isdn_rule_copy1"."status" IS 'Trạng thái của rule';
COMMENT ON COLUMN "inventory"."isdn_rule_copy1"."level" IS 'Độ ưu tiên của rule';
COMMENT ON COLUMN "inventory"."isdn_rule_copy1"."default_price" IS 'Giá mặc định của rule';
COMMENT ON COLUMN "inventory"."isdn_rule_copy1"."description" IS 'Mô tả';
COMMENT ON COLUMN "inventory"."isdn_rule_copy1"."example" IS 'Ví dụ về rule';

-- ----------------------------
-- Table structure for isdn_rule_type
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_rule_type";
CREATE TABLE "inventory"."isdn_rule_type" (
  "id" int8 NOT NULL DEFAULT nextval('"inventory".isdn_rule_type_beta_id_seq'::regclass),
  "rule_type" int8,
  "rule_id" int8,
  "description" text COLLATE "pg_catalog"."default",
  "note" varchar(100) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."isdn_rule_type" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."isdn_rule_type"."rule_type" IS 'Loại rule ( 1 - Số thường, 2 - Số ngày sinh, 3 - Số đẹp)';

-- ----------------------------
-- Table structure for isdn_rule_type_bk120721
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_rule_type_bk120721";
CREATE TABLE "inventory"."isdn_rule_type_bk120721" (
  "id" int8 NOT NULL,
  "rule_type" int8,
  "rule_id" int8,
  "description" text COLLATE "pg_catalog"."default",
  "note" varchar(100) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."isdn_rule_type_bk120721" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."isdn_rule_type_bk120721"."rule_type" IS 'Loại rule ( 1 - Số thường, 2 - Số ngày sinh, 3 - Số đẹp)';

-- ----------------------------
-- Table structure for isdn_type
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."isdn_type";
CREATE TABLE "inventory"."isdn_type" (
  "type_id" int8 NOT NULL,
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "type_name" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."isdn_type" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."isdn_type"."type_id" IS 'id bản ghi';
COMMENT ON COLUMN "inventory"."isdn_type"."description" IS 'mô tả';
COMMENT ON COLUMN "inventory"."isdn_type"."type_name" IS 'tên kiểu';

-- ----------------------------
-- Table structure for kit
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."kit";
CREATE TABLE "inventory"."kit" (
  "create_date" timestamp(0),
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "im_serial" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "isdn" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "status_id" int8 NOT NULL,
  "package_id" int8,
  "shop_id" int8 DEFAULT 0,
  "subpackage_id" int8,
  "price" int8,
  "object_holding" int2 NOT NULL DEFAULT 0,
  "level" int8,
  "sold" int8
)
;
ALTER TABLE "inventory"."kit" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."kit"."create_date" IS 'Ngày đấu nối';
COMMENT ON COLUMN "inventory"."kit"."creator" IS 'Người đấu nối';
COMMENT ON COLUMN "inventory"."kit"."description" IS 'Mô tả';
COMMENT ON COLUMN "inventory"."kit"."im_serial" IS 'Mã sim';
COMMENT ON COLUMN "inventory"."kit"."isdn" IS 'Số điện thoại';
COMMENT ON COLUMN "inventory"."kit"."status_id" IS '0-Chờ duyệt ; 1- Đã đấu nối KIT ; 3 - Xóa; 5 -Actived';
COMMENT ON COLUMN "inventory"."kit"."package_id" IS 'Gói cước chính';
COMMENT ON COLUMN "inventory"."kit"."shop_id" IS 'id Shop đang giữ số';
COMMENT ON COLUMN "inventory"."kit"."subpackage_id" IS 'Gói cước phụ';
COMMENT ON COLUMN "inventory"."kit"."price" IS 'Giá kit';
COMMENT ON COLUMN "inventory"."kit"."object_holding" IS 'Đối tượng đang giữ kit';
COMMENT ON COLUMN "inventory"."kit"."sold" IS 'Trạng thái bán: 0 - Chưa bán, 1 - Đã bán';

-- ----------------------------
-- Table structure for kit_bk1706
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."kit_bk1706";
CREATE TABLE "inventory"."kit_bk1706" (
  "create_date" timestamp(0),
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "im_serial" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "isdn" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "status_id" int8 NOT NULL,
  "package_id" int8,
  "shop_id" int8 DEFAULT 0,
  "subpackage_id" int8,
  "price" int8,
  "object_holding" int2 NOT NULL DEFAULT 0,
  "level" int8,
  "sold" int8
)
;
ALTER TABLE "inventory"."kit_bk1706" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."kit_bk1706"."create_date" IS 'Ngày đấu nối';
COMMENT ON COLUMN "inventory"."kit_bk1706"."creator" IS 'Người đấu nối';
COMMENT ON COLUMN "inventory"."kit_bk1706"."description" IS 'Mô tả';
COMMENT ON COLUMN "inventory"."kit_bk1706"."im_serial" IS 'Mã sim';
COMMENT ON COLUMN "inventory"."kit_bk1706"."isdn" IS 'Số điện thoại';
COMMENT ON COLUMN "inventory"."kit_bk1706"."status_id" IS '0-Chờ duyệt ; 1- Đã đấu nối KIT ; 3 - Xóa';
COMMENT ON COLUMN "inventory"."kit_bk1706"."package_id" IS 'Gói cước chính';
COMMENT ON COLUMN "inventory"."kit_bk1706"."shop_id" IS 'id Shop đang giữ số';
COMMENT ON COLUMN "inventory"."kit_bk1706"."subpackage_id" IS 'Gói cước phụ';
COMMENT ON COLUMN "inventory"."kit_bk1706"."price" IS 'Giá kit';
COMMENT ON COLUMN "inventory"."kit_bk1706"."object_holding" IS 'Đối tượng đang giữ kit';

-- ----------------------------
-- Table structure for kit_his
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."kit_his";
CREATE TABLE "inventory"."kit_his" (
  "action" varchar(255) COLLATE "pg_catalog"."default",
  "create_date" timestamp(6),
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "user_action" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "isdn" varchar(255) COLLATE "pg_catalog"."default",
  "im_serial" varchar(255) COLLATE "pg_catalog"."default",
  "his_id" int4 NOT NULL DEFAULT nextval('"inventory".kit_his_his_id_seq'::regclass),
  "reason_id" int4,
  "reason" text COLLATE "pg_catalog"."default",
  "attack_file" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."kit_his" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."kit_his"."action" IS 'Hành động tác động';
COMMENT ON COLUMN "inventory"."kit_his"."create_date" IS 'Ngày tác động';
COMMENT ON COLUMN "inventory"."kit_his"."description" IS 'Mô tả';
COMMENT ON COLUMN "inventory"."kit_his"."user_action" IS 'Người tác động';
COMMENT ON COLUMN "inventory"."kit_his"."isdn" IS 'Số điện thoại';
COMMENT ON COLUMN "inventory"."kit_his"."im_serial" IS 'Mã sim';
COMMENT ON COLUMN "inventory"."kit_his"."his_id" IS 'id của bảng';
COMMENT ON COLUMN "inventory"."kit_his"."reason_id" IS 'id lý do';
COMMENT ON COLUMN "inventory"."kit_his"."reason" IS 'chi tiết lý do thay đổi ';
COMMENT ON COLUMN "inventory"."kit_his"."attack_file" IS 'file đính kèm(nếu có)';

-- ----------------------------
-- Table structure for kit_his_detail
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."kit_his_detail";
CREATE TABLE "inventory"."kit_his_detail" (
  "description" text COLLATE "pg_catalog"."default",
  "detail_id" int4 NOT NULL DEFAULT nextval('"inventory".kit_his_detail_detail_id_seq'::regclass),
  "his_id" int8 NOT NULL
)
;
ALTER TABLE "inventory"."kit_his_detail" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."kit_his_detail"."description" IS 'Mô tả';
COMMENT ON COLUMN "inventory"."kit_his_detail"."detail_id" IS 'id của bảng';
COMMENT ON COLUMN "inventory"."kit_his_detail"."his_id" IS 'id của bảng lịch sử thay đổi kit';

-- ----------------------------
-- Table structure for kit_insert_history
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."kit_insert_history";
CREATE TABLE "inventory"."kit_insert_history" (
  "create_date" timestamp(6),
  "type" varchar(255) COLLATE "pg_catalog"."default",
  "quantity" int8,
  "staff" varchar(255) COLLATE "pg_catalog"."default",
  "content" text COLLATE "pg_catalog"."default",
  "id" int8 NOT NULL DEFAULT nextval('"inventory".kit_insert_history_id_seq'::regclass)
)
;
ALTER TABLE "inventory"."kit_insert_history" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."kit_insert_history"."create_date" IS 'Ngày đấu nối';
COMMENT ON COLUMN "inventory"."kit_insert_history"."type" IS 'Loại đấu nối ';
COMMENT ON COLUMN "inventory"."kit_insert_history"."quantity" IS 'Số lượng kit đấu nối';
COMMENT ON COLUMN "inventory"."kit_insert_history"."staff" IS 'Nhân viên đấu nối';
COMMENT ON COLUMN "inventory"."kit_insert_history"."content" IS 'Nội dung đấu nối';
COMMENT ON COLUMN "inventory"."kit_insert_history"."id" IS 'id của bảng';

-- ----------------------------
-- Table structure for kit_insert_type
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."kit_insert_type";
CREATE TABLE "inventory"."kit_insert_type" (
  "id" int4 NOT NULL,
  "type" varchar(255) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."kit_insert_type" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."kit_insert_type"."id" IS 'id của bảng';
COMMENT ON COLUMN "inventory"."kit_insert_type"."type" IS 'Loại đấu kit';
COMMENT ON COLUMN "inventory"."kit_insert_type"."description" IS 'Mô tả';

-- ----------------------------
-- Table structure for kit_job_info
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."kit_job_info";
CREATE TABLE "inventory"."kit_job_info" (
  "id" int8 NOT NULL DEFAULT nextval('"inventory".kit_job_info_id_seq'::regclass),
  "file_url" text COLLATE "pg_catalog"."default",
  "user_action" varchar(255) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "package_id" int8,
  "extension" varchar(10) COLLATE "pg_catalog"."default",
  "shop_id" int8,
  "create_at" timestamp(6),
  "execute_at" timestamp(6),
  "status" int2,
  "action" varchar(255) COLLATE "pg_catalog"."default",
  "sub_package_id" int8,
  "sms_amt" int8,
  "call_amt" int8,
  "data_amt" int8,
  "isdn_list" varchar(255) COLLATE "pg_catalog"."default",
  "sim_list" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."kit_job_info" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."kit_job_info"."id" IS 'id của bảng';
COMMENT ON COLUMN "inventory"."kit_job_info"."file_url" IS 'danh sách isdn';
COMMENT ON COLUMN "inventory"."kit_job_info"."user_action" IS 'người thực hiện';
COMMENT ON COLUMN "inventory"."kit_job_info"."description" IS 'mô tả';
COMMENT ON COLUMN "inventory"."kit_job_info"."package_id" IS 'id gói cơ bản';
COMMENT ON COLUMN "inventory"."kit_job_info"."extension" IS 'định dạng file cần xuất';
COMMENT ON COLUMN "inventory"."kit_job_info"."shop_id" IS 'id shop thực hiện';
COMMENT ON COLUMN "inventory"."kit_job_info"."create_at" IS 'Thời gian lưu thông tin ';
COMMENT ON COLUMN "inventory"."kit_job_info"."execute_at" IS 'Thời gian job  chạy';
COMMENT ON COLUMN "inventory"."kit_job_info"."status" IS '0 - Đã thực thi // 1 - Chưa thực thi';
COMMENT ON COLUMN "inventory"."kit_job_info"."action" IS 'INSERT // DELETE';
COMMENT ON COLUMN "inventory"."kit_job_info"."sub_package_id" IS 'id gói chính';
COMMENT ON COLUMN "inventory"."kit_job_info"."sms_amt" IS 'Số sms cho gói cước tùy chỉnh';
COMMENT ON COLUMN "inventory"."kit_job_info"."call_amt" IS 'Số phút gọi cho gói cước tùy chỉnh';
COMMENT ON COLUMN "inventory"."kit_job_info"."data_amt" IS 'Số data cho gói cước tùy chỉnh';

-- ----------------------------
-- Table structure for kit_package
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."kit_package";
CREATE TABLE "inventory"."kit_package" (
  "id" int8 NOT NULL DEFAULT nextval('"inventory".kit_package_id_seq'::regclass),
  "isdn" varchar(255) COLLATE "pg_catalog"."default",
  "im_serial" varchar(255) COLLATE "pg_catalog"."default",
  "package_id" int8,
  "status" int8
)
;
ALTER TABLE "inventory"."kit_package" OWNER TO "postgres";

-- ----------------------------
-- Table structure for level
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."level";
CREATE TABLE "inventory"."level" (
  "name" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar COLLATE "pg_catalog"."default",
  "id" int8 NOT NULL
)
;
ALTER TABLE "inventory"."level" OWNER TO "postgres";

-- ----------------------------
-- Table structure for log_kit_job
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."log_kit_job";
CREATE TABLE "inventory"."log_kit_job" (
  "file_url" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "total" int4,
  "created_at" timestamp(6),
  "kit_job_id" int8,
  "id" int8 NOT NULL DEFAULT nextval('"inventory".log_kit_job_id_seq'::regclass),
  "error_message" varchar(255) COLLATE "pg_catalog"."default",
  "type" int4
)
;
ALTER TABLE "inventory"."log_kit_job" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."log_kit_job"."type" IS '0-error, 1- ds thành công, 2-ds thất bại';

-- ----------------------------
-- Table structure for log_transaction
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."log_transaction";
CREATE TABLE "inventory"."log_transaction" (
  "id" int8 NOT NULL DEFAULT nextval('"inventory".log_transaction_id_seq'::regclass),
  "session_id" varchar(100) COLLATE "pg_catalog"."default",
  "ip" varchar(50) COLLATE "pg_catalog"."default",
  "uri" varchar(500) COLLATE "pg_catalog"."default",
  "ws_code" varchar(255) COLLATE "pg_catalog"."default",
  "request" text COLLATE "pg_catalog"."default",
  "response" text COLLATE "pg_catalog"."default",
  "start_time" timestamp(6),
  "end_time" timestamp(6),
  "time_run" int8,
  "error_code" int4,
  "error_message" text COLLATE "pg_catalog"."default",
  "username" varchar(255) COLLATE "pg_catalog"."default",
  "language" varchar(20) COLLATE "pg_catalog"."default",
  "app_name" varchar(100) COLLATE "pg_catalog"."default",
  "version_app_name" varchar(100) COLLATE "pg_catalog"."default",
  "version_code" int4,
  "device_name" varchar(255) COLLATE "pg_catalog"."default",
  "device_os" varchar(50) COLLATE "pg_catalog"."default",
  "version_os" varchar(30) COLLATE "pg_catalog"."default",
  "imei" varchar(255) COLLATE "pg_catalog"."default",
  "host_name" varchar(255) COLLATE "pg_catalog"."default",
  "status" int4
)
;
ALTER TABLE "inventory"."log_transaction" OWNER TO "postgres";

-- ----------------------------
-- Table structure for object_holding
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."object_holding";
CREATE TABLE "inventory"."object_holding" (
  "id" int2 NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."object_holding" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."object_holding"."id" IS 'id của bảng';
COMMENT ON COLUMN "inventory"."object_holding"."name" IS 'Tên đối tượng';
COMMENT ON COLUMN "inventory"."object_holding"."description" IS 'Mô tả';

-- ----------------------------
-- Table structure for ocs_reconciliation
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."ocs_reconciliation";
CREATE TABLE "inventory"."ocs_reconciliation" (
  "isdn" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "inventory"."ocs_reconciliation" OWNER TO "postgres";

-- ----------------------------
-- Table structure for option
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."option";
CREATE TABLE "inventory"."option" (
  "id" int8 NOT NULL DEFAULT nextval('"inventory".option_id_seq'::regclass),
  "code" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "status" int4,
  "created_time" timestamp(0) DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "inventory"."option" OWNER TO "postgres";

-- ----------------------------
-- Table structure for option_value
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."option_value";
CREATE TABLE "inventory"."option_value" (
  "id" int8 NOT NULL DEFAULT nextval('"inventory".option_value_id_seq'::regclass),
  "option_code" varchar(255) COLLATE "pg_catalog"."default",
  "value" text COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "status" int4,
  "created_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "inventory"."option_value" OWNER TO "postgres";

-- ----------------------------
-- Table structure for paging_config
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."paging_config";
CREATE TABLE "inventory"."paging_config" (
  "id" int8 NOT NULL DEFAULT nextval('"inventory".paging_config_id_seq'::regclass),
  "number_page_show" int4,
  "number_row_on_page" int4
)
;
ALTER TABLE "inventory"."paging_config" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."paging_config"."number_page_show" IS 'Số page hiển thị cho khách hàng';
COMMENT ON COLUMN "inventory"."paging_config"."number_row_on_page" IS 'Số bản ghi trong 1 page';

-- ----------------------------
-- Table structure for pre_kit
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."pre_kit";
CREATE TABLE "inventory"."pre_kit" (
  "id" int8 NOT NULL DEFAULT nextval('"inventory".pre_kit_id_seq'::regclass),
  "isdn" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "sim_serial" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(0),
  "updated_at" timestamp(0),
  "reason" varchar COLLATE "pg_catalog"."default",
  "expire_date" timestamp(0),
  "status" int2,
  "basic_package_ocs_code" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "main_package_ocs_code" varchar COLLATE "pg_catalog"."default",
  "active_code" varchar COLLATE "pg_catalog"."default",
  "shop_id" int8 DEFAULT 0
)
;
ALTER TABLE "inventory"."pre_kit" OWNER TO "postgres";

-- ----------------------------
-- Table structure for ra_isdn_backup
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."ra_isdn_backup";
CREATE TABLE "inventory"."ra_isdn_backup" (
  "isdn" varchar(10) COLLATE "pg_catalog"."default",
  "create_at" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "status_id" int8,
  "type_id" int8,
  "price_custom" int8,
  "price_default" int8,
  "role_id" int8,
  "shop_id" int8,
  "update_at" date,
  "object_holding" int2,
  "sold" int2,
  "level" int8
)
;
ALTER TABLE "inventory"."ra_isdn_backup" OWNER TO "postgres";

-- ----------------------------
-- Table structure for ra_isdn_dump_20200619112400
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."ra_isdn_dump_20200619112400";
CREATE TABLE "inventory"."ra_isdn_dump_20200619112400" (
  "isdn" varchar(10) COLLATE "pg_catalog"."default",
  "create_at" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "status_id" int8,
  "type_id" int8,
  "price_custom" int8,
  "price_default" int8,
  "role_id" int8,
  "shop_id" int8,
  "update_at" timestamp(6),
  "object_holding" int2,
  "sold" int2,
  "level" int8
)
;
ALTER TABLE "inventory"."ra_isdn_dump_20200619112400" OWNER TO "postgres";

-- ----------------------------
-- Table structure for sim
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."sim";
CREATE TABLE "inventory"."sim" (
  "im_serial" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "create_date" timestamp(6),
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_date" timestamp(6),
  "status_id" int8 NOT NULL,
  "price_default" int8,
  "shop_id" int8 DEFAULT 0,
  "object_holding" int2 DEFAULT 0,
  "iccid" varchar COLLATE "pg_catalog"."default",
  "pin" varchar(255) COLLATE "pg_catalog"."default",
  "puk" varchar(255) COLLATE "pg_catalog"."default",
  "pin2" varchar(255) COLLATE "pg_catalog"."default",
  "puk2" varchar(255) COLLATE "pg_catalog"."default",
  "code_adm" varchar(255) COLLATE "pg_catalog"."default",
  "ki" varchar(255) COLLATE "pg_catalog"."default",
  "imsi" varchar(255) COLLATE "pg_catalog"."default",
  "authen_sim" bool,
  "warehouse_entry_code" varchar(100) COLLATE "pg_catalog"."default",
  "sim_reference" varchar(100) COLLATE "pg_catalog"."default",
  "sold" int2,
  "level" int8,
  "esim_qrcode" text COLLATE "pg_catalog"."default",
  "ipa_string" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."sim" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."sim"."im_serial" IS 'số serial';
COMMENT ON COLUMN "inventory"."sim"."create_date" IS 'ngày tạo';
COMMENT ON COLUMN "inventory"."sim"."creator" IS 'người tạo';
COMMENT ON COLUMN "inventory"."sim"."description" IS 'mô tả';
COMMENT ON COLUMN "inventory"."sim"."update_by" IS 'người cập nhật';
COMMENT ON COLUMN "inventory"."sim"."update_date" IS 'ngày cập nhật';
COMMENT ON COLUMN "inventory"."sim"."status_id" IS 'id trạng thái';
COMMENT ON COLUMN "inventory"."sim"."price_default" IS 'giá tiền mặc định của sim';
COMMENT ON COLUMN "inventory"."sim"."shop_id" IS 'id của shop đang giữ sim';
COMMENT ON COLUMN "inventory"."sim"."object_holding" IS 'đối tượng đang giữ sim';
COMMENT ON COLUMN "inventory"."sim"."iccid" IS 'iccid';
COMMENT ON COLUMN "inventory"."sim"."pin" IS 'pin';
COMMENT ON COLUMN "inventory"."sim"."puk" IS 'puk';
COMMENT ON COLUMN "inventory"."sim"."pin2" IS 'pin2';
COMMENT ON COLUMN "inventory"."sim"."puk2" IS 'puk2';
COMMENT ON COLUMN "inventory"."sim"."code_adm" IS 'code_adm';
COMMENT ON COLUMN "inventory"."sim"."ki" IS 'ki';
COMMENT ON COLUMN "inventory"."sim"."imsi" IS 'imsi';
COMMENT ON COLUMN "inventory"."sim"."authen_sim" IS 'sim đã được authen chưa';
COMMENT ON COLUMN "inventory"."sim"."warehouse_entry_code" IS 'mã lô sim nhập vào kho';
COMMENT ON COLUMN "inventory"."sim"."sold" IS 'Trạng thái đã bán: 0 - Chưa bán , 1 - Đã bán';
COMMENT ON COLUMN "inventory"."sim"."esim_qrcode" IS 'Mã Qrcode của esim';
COMMENT ON COLUMN "inventory"."sim"."ipa_string" IS 'Ipa của Esim dùng để gen QrCode (Lưu thêm sau này có thể dùng đến)';

-- ----------------------------
-- Table structure for sim_authen_log
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."sim_authen_log";
CREATE TABLE "inventory"."sim_authen_log" (
  "id" int8 NOT NULL DEFAULT nextval('"inventory".sim_authen_log_id_seq'::regclass),
  "imsi" varchar(255) COLLATE "pg_catalog"."default",
  "ki" varchar(255) COLLATE "pg_catalog"."default",
  "cmd" varchar(255) COLLATE "pg_catalog"."default",
  "resp" varchar(255) COLLATE "pg_catalog"."default",
  "create_date" timestamp(6)
)
;
ALTER TABLE "inventory"."sim_authen_log" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."sim_authen_log"."id" IS 'id của bảng';
COMMENT ON COLUMN "inventory"."sim_authen_log"."create_date" IS 'Ngày gọi API';

-- ----------------------------
-- Table structure for sim_authen_logg
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."sim_authen_logg";
CREATE TABLE "inventory"."sim_authen_logg" (
  "im_serial" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "imsi" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "res_imsi" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "is_imsi_notmatch" bool NOT NULL,
  "ki" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "res_ki" varchar(255) COLLATE "pg_catalog"."default",
  "is_ki_notmatch" bool,
  "authen_sim" bool,
  "resp" varchar(1000) COLLATE "pg_catalog"."default",
  "is_rq_error" bool,
  "rq_error" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."sim_authen_logg" OWNER TO "postgres";

-- ----------------------------
-- Table structure for sim_beta
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."sim_beta";
CREATE TABLE "inventory"."sim_beta" (
  "im_serial" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "create_date" timestamp(6),
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_date" timestamp(6),
  "status_id" int8 NOT NULL,
  "price_default" int8,
  "shop_id" int8 DEFAULT 0,
  "object_holding" int2 DEFAULT 0,
  "iccid" varchar COLLATE "pg_catalog"."default",
  "pin" varchar(255) COLLATE "pg_catalog"."default",
  "puk" varchar(255) COLLATE "pg_catalog"."default",
  "pin2" varchar(255) COLLATE "pg_catalog"."default",
  "puk2" varchar(255) COLLATE "pg_catalog"."default",
  "code_adm" varchar(255) COLLATE "pg_catalog"."default",
  "ki" varchar(255) COLLATE "pg_catalog"."default",
  "imsi" varchar(255) COLLATE "pg_catalog"."default",
  "authen_sim" bool,
  "warehouse_entry_code" varchar(100) COLLATE "pg_catalog"."default",
  "sim_reference" varchar(100) COLLATE "pg_catalog"."default",
  "sold" int2,
  "level" int8
)
;
ALTER TABLE "inventory"."sim_beta" OWNER TO "postgres";

-- ----------------------------
-- Table structure for sim_bk0609
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."sim_bk0609";
CREATE TABLE "inventory"."sim_bk0609" (
  "im_serial" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "create_date" timestamp(6),
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_date" timestamp(6),
  "status_id" int8 NOT NULL,
  "price_default" int8,
  "shop_id" int8 DEFAULT 0,
  "object_holding" int2 DEFAULT 0,
  "iccid" varchar COLLATE "pg_catalog"."default",
  "pin" varchar(255) COLLATE "pg_catalog"."default",
  "puk" varchar(255) COLLATE "pg_catalog"."default",
  "pin2" varchar(255) COLLATE "pg_catalog"."default",
  "puk2" varchar(255) COLLATE "pg_catalog"."default",
  "code_adm" varchar(255) COLLATE "pg_catalog"."default",
  "ki" varchar(255) COLLATE "pg_catalog"."default",
  "imsi" varchar(255) COLLATE "pg_catalog"."default",
  "authen_sim" bool,
  "warehouse_entry_code" varchar(100) COLLATE "pg_catalog"."default",
  "sim_reference" varchar(100) COLLATE "pg_catalog"."default",
  "sold" int2,
  "level" int8
)
;
ALTER TABLE "inventory"."sim_bk0609" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."sim_bk0609"."im_serial" IS 'số serial';
COMMENT ON COLUMN "inventory"."sim_bk0609"."create_date" IS 'ngày tạo';
COMMENT ON COLUMN "inventory"."sim_bk0609"."creator" IS 'người tạo';
COMMENT ON COLUMN "inventory"."sim_bk0609"."description" IS 'mô tả';
COMMENT ON COLUMN "inventory"."sim_bk0609"."update_by" IS 'người cập nhật';
COMMENT ON COLUMN "inventory"."sim_bk0609"."update_date" IS 'ngày cập nhật';
COMMENT ON COLUMN "inventory"."sim_bk0609"."status_id" IS 'id trạng thái';
COMMENT ON COLUMN "inventory"."sim_bk0609"."price_default" IS 'giá tiền mặc định của sim';
COMMENT ON COLUMN "inventory"."sim_bk0609"."shop_id" IS 'id của shop đang giữ sim';
COMMENT ON COLUMN "inventory"."sim_bk0609"."object_holding" IS 'đối tượng đang giữ sim';
COMMENT ON COLUMN "inventory"."sim_bk0609"."iccid" IS 'iccid';
COMMENT ON COLUMN "inventory"."sim_bk0609"."pin" IS 'pin';
COMMENT ON COLUMN "inventory"."sim_bk0609"."puk" IS 'puk';
COMMENT ON COLUMN "inventory"."sim_bk0609"."pin2" IS 'pin2';
COMMENT ON COLUMN "inventory"."sim_bk0609"."puk2" IS 'puk2';
COMMENT ON COLUMN "inventory"."sim_bk0609"."code_adm" IS 'code_adm';
COMMENT ON COLUMN "inventory"."sim_bk0609"."ki" IS 'ki';
COMMENT ON COLUMN "inventory"."sim_bk0609"."imsi" IS 'imsi';
COMMENT ON COLUMN "inventory"."sim_bk0609"."authen_sim" IS 'sim đã được authen chưa';
COMMENT ON COLUMN "inventory"."sim_bk0609"."warehouse_entry_code" IS 'mã lô sim nhập vào kho';
COMMENT ON COLUMN "inventory"."sim_bk0609"."sold" IS 'Trạng thái đã bán: 0 - Chưa bán , 1 - Đã bán';

-- ----------------------------
-- Table structure for sim_bk0906
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."sim_bk0906";
CREATE TABLE "inventory"."sim_bk0906" (
  "im_serial" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "create_date" timestamp(6),
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_date" timestamp(6),
  "status_id" int8 NOT NULL,
  "price_default" int8,
  "shop_id" int8 DEFAULT 0,
  "object_holding" int2 DEFAULT 0,
  "iccid" varchar COLLATE "pg_catalog"."default",
  "pin" varchar(255) COLLATE "pg_catalog"."default",
  "puk" varchar(255) COLLATE "pg_catalog"."default",
  "pin2" varchar(255) COLLATE "pg_catalog"."default",
  "puk2" varchar(255) COLLATE "pg_catalog"."default",
  "code_adm" varchar(255) COLLATE "pg_catalog"."default",
  "ki" varchar(255) COLLATE "pg_catalog"."default",
  "imsi" varchar(255) COLLATE "pg_catalog"."default",
  "authen_sim" bool,
  "warehouse_entry_code" varchar(100) COLLATE "pg_catalog"."default",
  "sim_reference" varchar(100) COLLATE "pg_catalog"."default",
  "sold" int2,
  "level" int8
)
;
ALTER TABLE "inventory"."sim_bk0906" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."sim_bk0906"."im_serial" IS 'số serial';
COMMENT ON COLUMN "inventory"."sim_bk0906"."create_date" IS 'ngày tạo';
COMMENT ON COLUMN "inventory"."sim_bk0906"."creator" IS 'người tạo';
COMMENT ON COLUMN "inventory"."sim_bk0906"."description" IS 'mô tả';
COMMENT ON COLUMN "inventory"."sim_bk0906"."update_by" IS 'người cập nhật';
COMMENT ON COLUMN "inventory"."sim_bk0906"."update_date" IS 'ngày cập nhật';
COMMENT ON COLUMN "inventory"."sim_bk0906"."status_id" IS 'id trạng thái';
COMMENT ON COLUMN "inventory"."sim_bk0906"."price_default" IS 'giá tiền mặc định của sim';
COMMENT ON COLUMN "inventory"."sim_bk0906"."shop_id" IS 'id của shop đang giữ sim';
COMMENT ON COLUMN "inventory"."sim_bk0906"."object_holding" IS 'đối tượng đang giữ sim';
COMMENT ON COLUMN "inventory"."sim_bk0906"."iccid" IS 'iccid';
COMMENT ON COLUMN "inventory"."sim_bk0906"."pin" IS 'pin';
COMMENT ON COLUMN "inventory"."sim_bk0906"."puk" IS 'puk';
COMMENT ON COLUMN "inventory"."sim_bk0906"."pin2" IS 'pin2';
COMMENT ON COLUMN "inventory"."sim_bk0906"."puk2" IS 'puk2';
COMMENT ON COLUMN "inventory"."sim_bk0906"."code_adm" IS 'code_adm';
COMMENT ON COLUMN "inventory"."sim_bk0906"."ki" IS 'ki';
COMMENT ON COLUMN "inventory"."sim_bk0906"."imsi" IS 'imsi';
COMMENT ON COLUMN "inventory"."sim_bk0906"."authen_sim" IS 'sim đã được authen chưa';
COMMENT ON COLUMN "inventory"."sim_bk0906"."warehouse_entry_code" IS 'mã lô sim nhập vào kho';
COMMENT ON COLUMN "inventory"."sim_bk0906"."sold" IS 'Trạng thái đã bán: 0 - chưa bán , 1 - đã bán';

-- ----------------------------
-- Table structure for sim_bk1506
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."sim_bk1506";
CREATE TABLE "inventory"."sim_bk1506" (
  "im_serial" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "create_date" timestamp(6),
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_date" timestamp(6),
  "status_id" int8 NOT NULL,
  "price_default" int8,
  "shop_id" int8 DEFAULT 0,
  "object_holding" int2 DEFAULT 0,
  "iccid" varchar COLLATE "pg_catalog"."default",
  "pin" varchar(255) COLLATE "pg_catalog"."default",
  "puk" varchar(255) COLLATE "pg_catalog"."default",
  "pin2" varchar(255) COLLATE "pg_catalog"."default",
  "puk2" varchar(255) COLLATE "pg_catalog"."default",
  "code_adm" varchar(255) COLLATE "pg_catalog"."default",
  "ki" varchar(255) COLLATE "pg_catalog"."default",
  "imsi" varchar(255) COLLATE "pg_catalog"."default",
  "authen_sim" bool,
  "warehouse_entry_code" varchar(100) COLLATE "pg_catalog"."default",
  "sim_reference" varchar(100) COLLATE "pg_catalog"."default",
  "sold" int2,
  "level" int8
)
;
ALTER TABLE "inventory"."sim_bk1506" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."sim_bk1506"."im_serial" IS 'số serial';
COMMENT ON COLUMN "inventory"."sim_bk1506"."create_date" IS 'ngày tạo';
COMMENT ON COLUMN "inventory"."sim_bk1506"."creator" IS 'người tạo';
COMMENT ON COLUMN "inventory"."sim_bk1506"."description" IS 'mô tả';
COMMENT ON COLUMN "inventory"."sim_bk1506"."update_by" IS 'người cập nhật';
COMMENT ON COLUMN "inventory"."sim_bk1506"."update_date" IS 'ngày cập nhật';
COMMENT ON COLUMN "inventory"."sim_bk1506"."status_id" IS 'id trạng thái';
COMMENT ON COLUMN "inventory"."sim_bk1506"."price_default" IS 'giá tiền mặc định của sim';
COMMENT ON COLUMN "inventory"."sim_bk1506"."shop_id" IS 'id của shop đang giữ sim';
COMMENT ON COLUMN "inventory"."sim_bk1506"."object_holding" IS 'đối tượng đang giữ sim';
COMMENT ON COLUMN "inventory"."sim_bk1506"."iccid" IS 'iccid';
COMMENT ON COLUMN "inventory"."sim_bk1506"."pin" IS 'pin';
COMMENT ON COLUMN "inventory"."sim_bk1506"."puk" IS 'puk';
COMMENT ON COLUMN "inventory"."sim_bk1506"."pin2" IS 'pin2';
COMMENT ON COLUMN "inventory"."sim_bk1506"."puk2" IS 'puk2';
COMMENT ON COLUMN "inventory"."sim_bk1506"."code_adm" IS 'code_adm';
COMMENT ON COLUMN "inventory"."sim_bk1506"."ki" IS 'ki';
COMMENT ON COLUMN "inventory"."sim_bk1506"."imsi" IS 'imsi';
COMMENT ON COLUMN "inventory"."sim_bk1506"."authen_sim" IS 'sim đã được authen chưa';
COMMENT ON COLUMN "inventory"."sim_bk1506"."warehouse_entry_code" IS 'mã lô sim nhập vào kho';
COMMENT ON COLUMN "inventory"."sim_bk1506"."sold" IS 'Trạng thái đã bán: 0 - chưa bán , 1 - đã bán';

-- ----------------------------
-- Table structure for sim_bk1706
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."sim_bk1706";
CREATE TABLE "inventory"."sim_bk1706" (
  "im_serial" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "create_date" timestamp(6),
  "creator" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_date" timestamp(6),
  "status_id" int8 NOT NULL,
  "price_default" int8,
  "shop_id" int8 DEFAULT 0,
  "object_holding" int2 DEFAULT 0,
  "iccid" varchar COLLATE "pg_catalog"."default",
  "pin" varchar(255) COLLATE "pg_catalog"."default",
  "puk" varchar(255) COLLATE "pg_catalog"."default",
  "pin2" varchar(255) COLLATE "pg_catalog"."default",
  "puk2" varchar(255) COLLATE "pg_catalog"."default",
  "code_adm" varchar(255) COLLATE "pg_catalog"."default",
  "ki" varchar(255) COLLATE "pg_catalog"."default",
  "imsi" varchar(255) COLLATE "pg_catalog"."default",
  "authen_sim" bool,
  "warehouse_entry_code" varchar(100) COLLATE "pg_catalog"."default",
  "sim_reference" varchar(100) COLLATE "pg_catalog"."default",
  "sold" int2,
  "level" int8
)
;
ALTER TABLE "inventory"."sim_bk1706" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."sim_bk1706"."im_serial" IS 'số serial';
COMMENT ON COLUMN "inventory"."sim_bk1706"."create_date" IS 'ngày tạo';
COMMENT ON COLUMN "inventory"."sim_bk1706"."creator" IS 'người tạo';
COMMENT ON COLUMN "inventory"."sim_bk1706"."description" IS 'mô tả';
COMMENT ON COLUMN "inventory"."sim_bk1706"."update_by" IS 'người cập nhật';
COMMENT ON COLUMN "inventory"."sim_bk1706"."update_date" IS 'ngày cập nhật';
COMMENT ON COLUMN "inventory"."sim_bk1706"."status_id" IS 'id trạng thái';
COMMENT ON COLUMN "inventory"."sim_bk1706"."price_default" IS 'giá tiền mặc định của sim';
COMMENT ON COLUMN "inventory"."sim_bk1706"."shop_id" IS 'id của shop đang giữ sim';
COMMENT ON COLUMN "inventory"."sim_bk1706"."object_holding" IS 'đối tượng đang giữ sim';
COMMENT ON COLUMN "inventory"."sim_bk1706"."iccid" IS 'iccid';
COMMENT ON COLUMN "inventory"."sim_bk1706"."pin" IS 'pin';
COMMENT ON COLUMN "inventory"."sim_bk1706"."puk" IS 'puk';
COMMENT ON COLUMN "inventory"."sim_bk1706"."pin2" IS 'pin2';
COMMENT ON COLUMN "inventory"."sim_bk1706"."puk2" IS 'puk2';
COMMENT ON COLUMN "inventory"."sim_bk1706"."code_adm" IS 'code_adm';
COMMENT ON COLUMN "inventory"."sim_bk1706"."ki" IS 'ki';
COMMENT ON COLUMN "inventory"."sim_bk1706"."imsi" IS 'imsi';
COMMENT ON COLUMN "inventory"."sim_bk1706"."authen_sim" IS 'sim đã được authen chưa';
COMMENT ON COLUMN "inventory"."sim_bk1706"."warehouse_entry_code" IS 'mã lô sim nhập vào kho';
COMMENT ON COLUMN "inventory"."sim_bk1706"."sold" IS 'Trạng thái đã bán: 0 - chưa bán , 1 - đã bán';

-- ----------------------------
-- Table structure for sim_history
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."sim_history";
CREATE TABLE "inventory"."sim_history" (
  "action" varchar(50) COLLATE "pg_catalog"."default",
  "create_date" timestamp(6),
  "description" text COLLATE "pg_catalog"."default",
  "user_action" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "im_serial" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "his_id" int4 NOT NULL DEFAULT nextval('"inventory".sim_history_his_id_seq'::regclass),
  "reason_id" int4,
  "reason" text COLLATE "pg_catalog"."default",
  "attack_file" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."sim_history" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."sim_history"."action" IS 'hành động';
COMMENT ON COLUMN "inventory"."sim_history"."create_date" IS 'ngày tạo';
COMMENT ON COLUMN "inventory"."sim_history"."description" IS 'mô tả';
COMMENT ON COLUMN "inventory"."sim_history"."user_action" IS 'người thực thi';
COMMENT ON COLUMN "inventory"."sim_history"."im_serial" IS 'số serial';
COMMENT ON COLUMN "inventory"."sim_history"."his_id" IS 'id bản ghi';
COMMENT ON COLUMN "inventory"."sim_history"."reason_id" IS 'id lý do';
COMMENT ON COLUMN "inventory"."sim_history"."reason" IS 'chi tiết lý do thay đổi ';
COMMENT ON COLUMN "inventory"."sim_history"."attack_file" IS 'file đính kèm(nếu có)';

-- ----------------------------
-- Table structure for sim_history_detail
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."sim_history_detail";
CREATE TABLE "inventory"."sim_history_detail" (
  "description" text COLLATE "pg_catalog"."default",
  "detail_id" int4 NOT NULL DEFAULT nextval('"inventory".sim_history_detail_detail_id_seq'::regclass),
  "his_id" int8 NOT NULL
)
;
ALTER TABLE "inventory"."sim_history_detail" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."sim_history_detail"."description" IS 'mô tả';
COMMENT ON COLUMN "inventory"."sim_history_detail"."detail_id" IS 'id bản ghi';
COMMENT ON COLUMN "inventory"."sim_history_detail"."his_id" IS 'id log';

-- ----------------------------
-- Table structure for status
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."status";
CREATE TABLE "inventory"."status" (
  "status_id" int8 NOT NULL,
  "status_name" varchar(255) COLLATE "pg_catalog"."default",
  "status_table" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "inventory"."status" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."status"."status_id" IS 'id bản ghi';
COMMENT ON COLUMN "inventory"."status"."status_name" IS 'tên trạng thái';
COMMENT ON COLUMN "inventory"."status"."status_table" IS 'tên bảng';

-- ----------------------------
-- Table structure for stock
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."stock";
CREATE TABLE "inventory"."stock" (
  "id" int8 NOT NULL,
  "key" varchar(255) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "status" int8
)
;
ALTER TABLE "inventory"."stock" OWNER TO "postgres";
COMMENT ON COLUMN "inventory"."stock"."status" IS 'Cho phép có được update từ kho hay ko';

-- ----------------------------
-- Table structure for test_list_isdn
-- ----------------------------
DROP TABLE IF EXISTS "inventory"."test_list_isdn";
CREATE TABLE "inventory"."test_list_isdn" (
  "isdn" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "environment" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "department" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "status" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "inventory"."test_list_isdn" OWNER TO "postgres";

-- ----------------------------
-- Procedure structure for classifyisdn
-- ----------------------------
DROP PROCEDURE IF EXISTS "inventory"."classifyisdn"("isdnparam" _varchar, "roleparam" _int4, "createdateparam" varchar, "useractionparam" varchar);
CREATE OR REPLACE PROCEDURE "inventory"."classifyisdn"("isdnparam" _varchar, "roleparam" _int4, "createdateparam" varchar, "useractionparam" varchar)
 AS $BODY$
BEGIN
WITH
L0 AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL
SELECT 1 UNION ALL SELECT 1 UNION ALL
SELECT 1 UNION ALL SELECT 1) AS D(c)), -- 6^1
L1 AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B), -- 6^2
L2 AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B), -- 6^4
L3 AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B), -- 6^8
Nums AS (SELECT row_number() OVER() AS k FROM L3)
UPDATE inventory.stock_isdn ISDN_UPDATE SET (role_id) = (
	SELECT roleParam[k]
	from Nums
	where k < POWER(10, lengthNumberParam)
	AND ISDN_UPDATE.isdn = isdnParam[k]
);
INSERT INTO inventory.isdn_his(action,create_date, description,user_action,isdn) 
SELECT 'UPDATE', CAST(createDateParam AS TIMESTAMP), 'Update Role', userActionParam, isdnParam[k]
FROM Nums;
END;
$BODY$
  LANGUAGE plpgsql;
ALTER PROCEDURE "inventory"."classifyisdn"("isdnparam" _varchar, "roleparam" _int4, "createdateparam" varchar, "useractionparam" varchar) OWNER TO "postgres";

-- ----------------------------
-- Function structure for f_random_sample
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."f_random_sample"("_limit" int4, "_gaps" numeric);
CREATE OR REPLACE FUNCTION "inventory"."f_random_sample"("_limit" int4=1000, "_gaps" numeric=1.03)
  RETURNS SETOF "inventory"."isdn_his" AS $BODY$
DECLARE
   _surplus  int := _limit * _gaps;
   _estimate int := (           -- get current estimate from system
      SELECT c.reltuples * _gaps
      FROM   pg_class c
      WHERE  c.oid = 'isdn_his'::regclass);
BEGIN

   RETURN QUERY
   WITH RECURSIVE random_pick AS (
      SELECT *
      FROM  (
         SELECT 1 + trunc(random() * _estimate)::int
         FROM   generate_series(1, _surplus) g
         LIMIT  _surplus           -- hint for query planner
         ) r (his_id)
      JOIN   isdn_his USING (his_id)        -- eliminate misses

      UNION                        -- eliminate dupes
      SELECT *
      FROM  (
         SELECT 1 + trunc(random() * _estimate)::int
         FROM   random_pick        -- just to make it recursive
         LIMIT  _limit             -- hint for query planner
         ) r (his_id)
      JOIN   isdn_his USING (his_id)        -- eliminate misses
   )
   SELECT *
   FROM   random_pick
   LIMIT  _limit;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "inventory"."f_random_sample"("_limit" int4, "_gaps" numeric) OWNER TO "postgres";

-- ----------------------------
-- Function structure for f_random_sample
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."f_random_sample"("_limit" int4, "_gaps" float4);
CREATE OR REPLACE FUNCTION "inventory"."f_random_sample"("_limit" int4=1000, "_gaps" float4=1.03)
  RETURNS SETOF "inventory"."isdn_his" AS $BODY$
DECLARE
   _surplus  int := _limit * _gaps;
   _estimate int := (           -- get current estimate from system
      SELECT c.reltuples * _gaps
      FROM   pg_class c
      WHERE  c.oid = 'isdn_his'::regclass);
BEGIN

   RETURN QUERY
   WITH RECURSIVE random_pick AS (
      SELECT *
      FROM  (
         SELECT 1 + trunc(random() * _estimate)::int
         FROM   generate_series(1, _surplus) g
         LIMIT  _surplus           -- hint for query planner
         ) r (his_id)
      JOIN   isdn_his USING (his_id)        -- eliminate misses

      UNION                        -- eliminate dupes
      SELECT *
      FROM  (
         SELECT 1 + trunc(random() * _estimate)::int
         FROM   random_pick        -- just to make it recursive
         LIMIT  _limit             -- hint for query planner
         ) r (his_id)
      JOIN   isdn_his USING (his_id)        -- eliminate misses
   )
   SELECT *
   FROM   random_pick
   LIMIT  _limit;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "inventory"."f_random_sample"("_limit" int4, "_gaps" float4) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gin_extract_query_trgm
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gin_extract_query_trgm"(text, internal, int2, internal, internal, internal, internal);
CREATE OR REPLACE FUNCTION "inventory"."gin_extract_query_trgm"(text, internal, int2, internal, internal, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gin_extract_query_trgm'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gin_extract_query_trgm"(text, internal, int2, internal, internal, internal, internal) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gin_extract_value_trgm
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gin_extract_value_trgm"(text, internal);
CREATE OR REPLACE FUNCTION "inventory"."gin_extract_value_trgm"(text, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gin_extract_value_trgm'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gin_extract_value_trgm"(text, internal) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gin_trgm_consistent
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gin_trgm_consistent"(internal, int2, text, int4, internal, internal, internal, internal);
CREATE OR REPLACE FUNCTION "inventory"."gin_trgm_consistent"(internal, int2, text, int4, internal, internal, internal, internal)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'gin_trgm_consistent'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gin_trgm_consistent"(internal, int2, text, int4, internal, internal, internal, internal) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gin_trgm_triconsistent
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gin_trgm_triconsistent"(internal, int2, text, int4, internal, internal, internal);
CREATE OR REPLACE FUNCTION "inventory"."gin_trgm_triconsistent"(internal, int2, text, int4, internal, internal, internal)
  RETURNS "pg_catalog"."char" AS '$libdir/pg_trgm', 'gin_trgm_triconsistent'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gin_trgm_triconsistent"(internal, int2, text, int4, internal, internal, internal) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gtrgm_compress
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gtrgm_compress"(internal);
CREATE OR REPLACE FUNCTION "inventory"."gtrgm_compress"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gtrgm_compress'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gtrgm_compress"(internal) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gtrgm_consistent
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gtrgm_consistent"(internal, text, int2, oid, internal);
CREATE OR REPLACE FUNCTION "inventory"."gtrgm_consistent"(internal, text, int2, oid, internal)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'gtrgm_consistent'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gtrgm_consistent"(internal, text, int2, oid, internal) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gtrgm_decompress
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gtrgm_decompress"(internal);
CREATE OR REPLACE FUNCTION "inventory"."gtrgm_decompress"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gtrgm_decompress'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gtrgm_decompress"(internal) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gtrgm_distance
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gtrgm_distance"(internal, text, int2, oid, internal);
CREATE OR REPLACE FUNCTION "inventory"."gtrgm_distance"(internal, text, int2, oid, internal)
  RETURNS "pg_catalog"."float8" AS '$libdir/pg_trgm', 'gtrgm_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gtrgm_distance"(internal, text, int2, oid, internal) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gtrgm_in
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gtrgm_in"(cstring);
CREATE OR REPLACE FUNCTION "inventory"."gtrgm_in"(cstring)
  RETURNS "inventory"."gtrgm" AS '$libdir/pg_trgm', 'gtrgm_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gtrgm_in"(cstring) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gtrgm_out
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gtrgm_out"("inventory"."gtrgm");
CREATE OR REPLACE FUNCTION "inventory"."gtrgm_out"("inventory"."gtrgm")
  RETURNS "pg_catalog"."cstring" AS '$libdir/pg_trgm', 'gtrgm_out'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gtrgm_out"("inventory"."gtrgm") OWNER TO "postgres";

-- ----------------------------
-- Function structure for gtrgm_penalty
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gtrgm_penalty"(internal, internal, internal);
CREATE OR REPLACE FUNCTION "inventory"."gtrgm_penalty"(internal, internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gtrgm_penalty'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gtrgm_penalty"(internal, internal, internal) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gtrgm_picksplit
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gtrgm_picksplit"(internal, internal);
CREATE OR REPLACE FUNCTION "inventory"."gtrgm_picksplit"(internal, internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gtrgm_picksplit'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gtrgm_picksplit"(internal, internal) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gtrgm_same
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gtrgm_same"("inventory"."gtrgm", "inventory"."gtrgm", internal);
CREATE OR REPLACE FUNCTION "inventory"."gtrgm_same"("inventory"."gtrgm", "inventory"."gtrgm", internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/pg_trgm', 'gtrgm_same'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gtrgm_same"("inventory"."gtrgm", "inventory"."gtrgm", internal) OWNER TO "postgres";

-- ----------------------------
-- Function structure for gtrgm_union
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."gtrgm_union"(internal, internal);
CREATE OR REPLACE FUNCTION "inventory"."gtrgm_union"(internal, internal)
  RETURNS "inventory"."gtrgm" AS '$libdir/pg_trgm', 'gtrgm_union'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."gtrgm_union"(internal, internal) OWNER TO "postgres";

-- ----------------------------
-- Procedure structure for insertisdn
-- ----------------------------
DROP PROCEDURE IF EXISTS "inventory"."insertisdn"("firstnumberparam" varchar, "createdateparam" varchar, "creatorparam" varchar, "lengthnumberparam" int4, "descriptionparam" text);
CREATE OR REPLACE PROCEDURE "inventory"."insertisdn"("firstnumberparam" varchar, "createdateparam" varchar, "creatorparam" varchar, "lengthnumberparam" int4, "descriptionparam" text)
 AS $BODY$
BEGIN
WITH
L0 AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL
SELECT 1 UNION ALL SELECT 1 UNION ALL
SELECT 1 UNION ALL SELECT 1) AS D(c)), -- 6^1
L1 AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B), -- 6^2
L2 AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B), -- 6^4
L3 AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B), -- 6^8
Nums AS (SELECT row_number() OVER() AS k FROM L3)
INSERT INTO inventory.stock_isdn (isdn, create_at, create_by, status_id, role_id) SELECT firstNumberParam || LPAD(k::text, lengthNumberParam, '0'), createDateParam::TIMESTAMP,creatorParam, 0,0
from Nums
where k < POWER(10, lengthNumberParam)
AND NOT EXISTS (
SELECT isdn FROM inventory.stock_isdn WHERE isdn = (firstNumberParam || LPAD(k::text, lengthNumberParam, '0')));
INSERT INTO inventory.isdn_his(action,create_date, description,user_action,isdn) SELECT 'insert',createDateParam::TIMESTAMP, '', creatorParam, isdn
FROM inventory.stock_isdn
WHERE inventory.stock_isdn.isdn LIKE CONCAT(firstNumberParam, '%');

INSERT INTO inventory.isdn_his_detail(description, his_id) SELECT descriptionParam, his_id
FROM inventory.isdn_his
WHERE inventory.isdn_his.isdn LIKE CONCAT(firstNumberParam, '%');
END;
$BODY$
  LANGUAGE plpgsql;
ALTER PROCEDURE "inventory"."insertisdn"("firstnumberparam" varchar, "createdateparam" varchar, "creatorparam" varchar, "lengthnumberparam" int4, "descriptionparam" text) OWNER TO "postgres";

-- ----------------------------
-- Procedure structure for insertisdnnewtable
-- ----------------------------
DROP PROCEDURE IF EXISTS "inventory"."insertisdnnewtable"("firstnumberparam" varchar, "createdateparam" varchar, "creatorparam" varchar, "lengthnumberparam" int4, "descriptionparam" text, "pricedefaultparam" int8);
CREATE OR REPLACE PROCEDURE "inventory"."insertisdnnewtable"("firstnumberparam" varchar, "createdateparam" varchar, "creatorparam" varchar, "lengthnumberparam" int4, "descriptionparam" text, "pricedefaultparam" int8)
 AS $BODY$
BEGIN
WITH
L0 AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL
SELECT 1 UNION ALL SELECT 1 UNION ALL
SELECT 1 UNION ALL SELECT 1) AS D(c)), -- 6^1
L1 AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B ) , -- 6^2
L2 AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B ), -- 6^4
L3 AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B ), -- 6^8
Nums AS (SELECT row_number() OVER() AS k FROM L3)
INSERT INTO inventory.isdn (isdn, create_at, create_by, status_id, role_id, price_default) SELECT firstNumberParam || LPAD(k::text, lengthNumberParam, '0'), createDateParam::TIMESTAMP,creatorParam, 0,0, priceDefaultParam
from Nums
where k < POWER(10, lengthNumberParam)
AND NOT EXISTS (
SELECT isdn FROM inventory.isdn WHERE isdn = (firstNumberParam || LPAD(k::text, lengthNumberParam, '0')));

END;
$BODY$
  LANGUAGE plpgsql;
ALTER PROCEDURE "inventory"."insertisdnnewtable"("firstnumberparam" varchar, "createdateparam" varchar, "creatorparam" varchar, "lengthnumberparam" int4, "descriptionparam" text, "pricedefaultparam" int8) OWNER TO "postgres";

-- ----------------------------
-- Procedure structure for insertkit
-- ----------------------------
DROP PROCEDURE IF EXISTS "inventory"."insertkit"("listisdnparam" varchar, "listsimparam" varchar, "isdnlength" int4, "createdate" varchar, "creatorparam" varchar);
CREATE OR REPLACE PROCEDURE "inventory"."insertkit"("listisdnparam" varchar, "listsimparam" varchar, "isdnlength" int4, "createdate" varchar, "creatorparam" varchar)
 AS $BODY$
BEGIN
WITH
L0 AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL
SELECT 1 UNION ALL SELECT 1 UNION ALL
SELECT 1 UNION ALL SELECT 1) AS D(c)), -- 6^1
L1 AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B), -- 6^2
L2 AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B), -- 6^4
L3 AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B), -- 6^8
Nums AS (SELECT row_number() OVER() AS k FROM L3),    
Isdn AS (
SELECT isdnList[k] AS isdn, row_number() OVER() AS h
FROM Nums,
(
	SELECT CAST(string_to_array(listIsdnParam, ',') as VARCHAR[]) AS isdnList  
) LIST_ISDN
WHERE NOT EXISTS (
SELEcT kit.isdn
FROM inventory.kit
WHERE kit.isdn LIKE isdnList[k] )
AND k <= isdnLength
AND EXISTS(
	SELECT isdn 
	FROM inventory.stock_isdn isdn
	WHERE isdn.isdn = isdnList[k]
	AND isdn.status_id <> 0 
)
),
Sim AS (
SELECT listSim[k] AS sim, row_number() OVER() AS h
FROM Nums,
(
	SELECT CAST(string_to_array(listSimParam, ',') as VARCHAR[]) AS listSim 
) LIST_SIM
WHERE NOT EXISTS (
SELEcT kit.im_serial
FROM inventory.kit kit
WHERE kit.im_serial LIKE listSim[k] )
AND k <= isdnLength
AND EXISTS(
	SELECT im_serial
	FROM inventory.sim sim
	WHERE sim.im_serial = listSim[k]
	AND sim.status_id = 1
)
),
KIT AS (
SELECT isdn , sim
FROM Isdn, Sim
WHERE Isdn.h = Sim.h
)

INSERT INTO inventory.kit (isdn, im_serial, create_date,status_id) SELECT isdn, sim , createDate::TIMESTAMP, 1  FROM KIT;

INSERT INTO inventory.kit_his(isdn, im_serial, action, user_action, description, create_date) 
SELECT isdn, im_serial, 'INSERT',creatorParam, 'Đấu kit theo lô', createDate::TIMESTAMP
FROM inventory.kit kit
WHERE kit.create_date = createDate::TIMESTAMP;

UPDATE inventory.sim  sim SET status_id = 5 WHERE sim.im_serial IN (
	SELECT im_serial
	FROM inventory.kit kit
	WHERE kit.create_date = createDate::TIMESTAMP
);
END;
$BODY$
  LANGUAGE plpgsql;
ALTER PROCEDURE "inventory"."insertkit"("listisdnparam" varchar, "listsimparam" varchar, "isdnlength" int4, "createdate" varchar, "creatorparam" varchar) OWNER TO "postgres";

-- ----------------------------
-- Procedure structure for insertkit1
-- ----------------------------
DROP PROCEDURE IF EXISTS "inventory"."insertkit1"("listisdn" _varchar, "listsim" _varchar);
CREATE OR REPLACE PROCEDURE "inventory"."insertkit1"("listisdn" _varchar, "listsim" _varchar)
 AS $BODY$
BEGIN
WITH
	L0 AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL 
	SELECT 1 UNION ALL SELECT 1 UNION ALL 
	SELECT 1 UNION ALL SELECT 1) AS D(c)), -- 6^1
	L1 AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),	-- 6^2
	L2 AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),	-- 6^4
	L3 AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),	-- 6^8
	Nums AS (SELECT row_number() OVER() AS k FROM L3)
SELECT isdn , sim , k
			FROM (SELECT listIsdn[k] AS isdn, k
			FROM Nums
			WHERE NOT EXISTS (SELEcT isdn , im_serial FROM kit WHERE kit.isdn LIKE listIsdn[k] )) isdn
		,
		
			(SELECT listSim[k] AS sim
			FROM Nums
			WHERE NOT EXISTS (SELEcT im_serial FROM kit WHERE kit.im_serial LIKE listSim[k])) sim
			WHERE k < 5;

END;
$BODY$
  LANGUAGE plpgsql;
ALTER PROCEDURE "inventory"."insertkit1"("listisdn" _varchar, "listsim" _varchar) OWNER TO "postgres";

-- ----------------------------
-- Procedure structure for insertsimlist
-- ----------------------------
DROP PROCEDURE IF EXISTS "inventory"."insertsimlist"("imserial" _varchar, "createdateparam" varchar, "creatorparam" varchar, "descriptionsimparam" text, "descriohisparam" text, "maxlength" int4);
CREATE OR REPLACE PROCEDURE "inventory"."insertsimlist"("imserial" _varchar, "createdateparam" varchar, "creatorparam" varchar, "descriptionsimparam" text, "descriohisparam" text, "maxlength" int4)
 AS $BODY$
BEGIN
	WITH
	L0 AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL 
	SELECT 1 UNION ALL SELECT 1 UNION ALL 
	SELECT 1 UNION ALL SELECT 1) AS D(c)), -- 6^1
	L1 AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),	-- 6^2
	L2 AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),	-- 6^4
	L3 AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),	-- 6^8
	Nums AS (SELECT row_number() OVER() AS k FROM L3)
	INSERT INTO inventory.sim (im_serial, create_date, creator, description, status_id) 
	SELECT imSerial[k], cast(createDateParam AS TIMESTAMP),creatorParam,descriptionSimParam, 0
	from Nums 
	where k <= maxLength
		AND NOT EXISTS (
			SELECT im_serial FROM inventory.sim WHERE im_serial = ANY(imSerial)
		);
	INSERT INTO inventory.sim_history(action,create_date, description,user_action,im_serial) 
	SELECT 'insert',cast(createDateParam AS TIMESTAMP), '', creatorParam, im_serial
	FROM inventory.sim 
	WHERE inventory.sim.im_serial = ANY(imSerial);

	INSERT INTO inventory.sim_history_detail(description, his_id) SELECT descrioHisParam, his_id
	FROM inventory.sim_history 
	WHERE inventory.sim_history.im_serial =  ANY(imSerial);
END;
$BODY$
  LANGUAGE plpgsql;
ALTER PROCEDURE "inventory"."insertsimlist"("imserial" _varchar, "createdateparam" varchar, "creatorparam" varchar, "descriptionsimparam" text, "descriohisparam" text, "maxlength" int4) OWNER TO "postgres";

-- ----------------------------
-- Procedure structure for insertstatus
-- ----------------------------
DROP PROCEDURE IF EXISTS "inventory"."insertstatus"("statusname" varchar, INOUT "success" int4);
CREATE OR REPLACE PROCEDURE "inventory"."insertstatus"(IN "statusname" varchar, INOUT "success" int4)
 AS $BODY$
	BEGIN
		INSERT INTO inventory.status(status_id, status_name, status_table) VALUES(8,statusName,'');
		SELECT 1 INTO success ;
	END;
$BODY$
  LANGUAGE plpgsql;
ALTER PROCEDURE "inventory"."insertstatus"("statusname" varchar, INOUT "success" int4) OWNER TO "postgres";

-- ----------------------------
-- Procedure structure for insertstatus
-- ----------------------------
DROP PROCEDURE IF EXISTS "inventory"."insertstatus"("statusname" varchar);
CREATE OR REPLACE PROCEDURE "inventory"."insertstatus"("statusname" varchar)
 AS $BODY$
	BEGIN
		INSERT INTO inventory.status(status_id, status_name, status_table) VALUES(8,statusName,'');
		PERFORM 1 ;
	END;
$BODY$
  LANGUAGE plpgsql;
ALTER PROCEDURE "inventory"."insertstatus"("statusname" varchar) OWNER TO "postgres";

-- ----------------------------
-- Procedure structure for selectkit
-- ----------------------------
DROP PROCEDURE IF EXISTS "inventory"."selectkit"("listisdn" varchar, "listsim" varchar, "isdnlength" int4, "createdate" varchar, "creator" varchar);
CREATE OR REPLACE PROCEDURE "inventory"."selectkit"("listisdn" varchar, "listsim" varchar, "isdnlength" int4, "createdate" varchar, "creator" varchar)
 AS $BODY$
BEGIN
WITH
L0 AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL
SELECT 1 UNION ALL SELECT 1 UNION ALL
SELECT 1 UNION ALL SELECT 1) AS D(c)), -- 6^1
L1 AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B), -- 6^2
L2 AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B), -- 6^4
L3 AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B), -- 6^8
Nums AS (SELECT row_number() OVER() AS k FROM L3),    
Isdn AS (
SELECT isdnList[k] AS isdn, row_number() OVER() AS h
FROM Nums,
(
	SELECT CAST(string_to_array(listIsdn, ',') as VARCHAR[]) AS isdnList  
) LIST_ISDN
WHERE NOT EXISTS (
SELEcT kit.isdn
FROM kit
WHERE kit.isdn LIKE listIsdn[k] )
AND k <= isdnLength
AND EXISTS(
	SELECT isdn 
	FROM isdn
	WHERE isdn.isdn = listIsdn[k]
	AND isdn.status_id <> 0 
)
)

SELECT * FROM Isdn ;
END;
$BODY$
  LANGUAGE plpgsql;
ALTER PROCEDURE "inventory"."selectkit"("listisdn" varchar, "listsim" varchar, "isdnlength" int4, "createdate" varchar, "creator" varchar) OWNER TO "postgres";

-- ----------------------------
-- Function structure for set_limit
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."set_limit"(float4);
CREATE OR REPLACE FUNCTION "inventory"."set_limit"(float4)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'set_limit'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "inventory"."set_limit"(float4) OWNER TO "postgres";

-- ----------------------------
-- Function structure for show_limit
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."show_limit"();
CREATE OR REPLACE FUNCTION "inventory"."show_limit"()
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'show_limit'
  LANGUAGE c STABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."show_limit"() OWNER TO "postgres";

-- ----------------------------
-- Function structure for show_trgm
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."show_trgm"(text);
CREATE OR REPLACE FUNCTION "inventory"."show_trgm"(text)
  RETURNS "pg_catalog"."_text" AS '$libdir/pg_trgm', 'show_trgm'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."show_trgm"(text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for similarity
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."similarity"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."similarity"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'similarity'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."similarity"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for similarity_dist
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."similarity_dist"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."similarity_dist"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'similarity_dist'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."similarity_dist"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for similarity_op
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."similarity_op"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."similarity_op"(text, text)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'similarity_op'
  LANGUAGE c STABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."similarity_op"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for strict_word_similarity
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."strict_word_similarity"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."strict_word_similarity"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'strict_word_similarity'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."strict_word_similarity"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for strict_word_similarity_commutator_op
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."strict_word_similarity_commutator_op"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."strict_word_similarity_commutator_op"(text, text)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'strict_word_similarity_commutator_op'
  LANGUAGE c STABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."strict_word_similarity_commutator_op"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for strict_word_similarity_dist_commutator_op
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."strict_word_similarity_dist_commutator_op"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."strict_word_similarity_dist_commutator_op"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'strict_word_similarity_dist_commutator_op'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."strict_word_similarity_dist_commutator_op"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for strict_word_similarity_dist_op
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."strict_word_similarity_dist_op"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."strict_word_similarity_dist_op"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'strict_word_similarity_dist_op'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."strict_word_similarity_dist_op"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for strict_word_similarity_op
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."strict_word_similarity_op"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."strict_word_similarity_op"(text, text)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'strict_word_similarity_op'
  LANGUAGE c STABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."strict_word_similarity_op"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for word_similarity
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."word_similarity"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."word_similarity"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'word_similarity'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."word_similarity"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for word_similarity_commutator_op
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."word_similarity_commutator_op"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."word_similarity_commutator_op"(text, text)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'word_similarity_commutator_op'
  LANGUAGE c STABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."word_similarity_commutator_op"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for word_similarity_dist_commutator_op
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."word_similarity_dist_commutator_op"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."word_similarity_dist_commutator_op"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'word_similarity_dist_commutator_op'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."word_similarity_dist_commutator_op"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for word_similarity_dist_op
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."word_similarity_dist_op"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."word_similarity_dist_op"(text, text)
  RETURNS "pg_catalog"."float4" AS '$libdir/pg_trgm', 'word_similarity_dist_op'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."word_similarity_dist_op"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Function structure for word_similarity_op
-- ----------------------------
DROP FUNCTION IF EXISTS "inventory"."word_similarity_op"(text, text);
CREATE OR REPLACE FUNCTION "inventory"."word_similarity_op"(text, text)
  RETURNS "pg_catalog"."bool" AS '$libdir/pg_trgm', 'word_similarity_op'
  LANGUAGE c STABLE STRICT
  COST 1;
ALTER FUNCTION "inventory"."word_similarity_op"(text, text) OWNER TO "postgres";

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."config_require_used_time_before_mnp_id_seq"
OWNED BY "inventory"."config_require_used_time_before_mnp"."id";
SELECT setval('"inventory"."config_require_used_time_before_mnp_id_seq"', 11, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."ftp_file_id_seq"
OWNED BY "inventory"."ftp_file"."id";
SELECT setval('"inventory"."ftp_file_id_seq"', 309, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
SELECT setval('"inventory"."isdn_format_search_id_seq"', 21, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."isdn_head_id_seq"
OWNED BY "inventory"."isdn_head"."id";
SELECT setval('"inventory"."isdn_head_id_seq"', 20003, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."isdn_his_detail_detail_id_seq"
OWNED BY "inventory"."isdn_his_detail"."detail_id";
SELECT setval('"inventory"."isdn_his_detail_detail_id_seq"', 137990, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."isdn_his_his_id_seq"
OWNED BY "inventory"."isdn_his"."his_id";
SELECT setval('"inventory"."isdn_his_his_id_seq"', 137990, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."isdn_his_new_his_id_seq"
OWNED BY "inventory"."isdn_his_new"."his_id";
SELECT setval('"inventory"."isdn_his_new_his_id_seq"', 3327396, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."isdn_rule_beta_rule_id_seq"
OWNED BY "inventory"."isdn_rule"."rule_id";
SELECT setval('"inventory"."isdn_rule_beta_rule_id_seq"', 2, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."isdn_rule_type_beta_id_seq"
OWNED BY "inventory"."isdn_rule_type"."id";
SELECT setval('"inventory"."isdn_rule_type_beta_id_seq"', 229, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."kit_his_detail_detail_id_seq"
OWNED BY "inventory"."kit_his_detail"."detail_id";
SELECT setval('"inventory"."kit_his_detail_detail_id_seq"', 2548, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."kit_his_his_id_seq"
OWNED BY "inventory"."kit_his"."his_id";
SELECT setval('"inventory"."kit_his_his_id_seq"', 20826, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."kit_insert_history_id_seq"
OWNED BY "inventory"."kit_insert_history"."id";
SELECT setval('"inventory"."kit_insert_history_id_seq"', 18967, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."kit_job_info_id_seq"
OWNED BY "inventory"."kit_job_info"."id";
SELECT setval('"inventory"."kit_job_info_id_seq"', 2, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."kit_package_id_seq"
OWNED BY "inventory"."kit_package"."id";
SELECT setval('"inventory"."kit_package_id_seq"', 843, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."log_kit_job_id_seq"
OWNED BY "inventory"."log_kit_job"."id";
SELECT setval('"inventory"."log_kit_job_id_seq"', 2, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."log_transaction_id_seq"
OWNED BY "inventory"."log_transaction"."id";
SELECT setval('"inventory"."log_transaction_id_seq"', 1226255, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."option_id_seq"
OWNED BY "inventory"."option"."id";
SELECT setval('"inventory"."option_id_seq"', 2, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."option_value_id_seq"
OWNED BY "inventory"."option_value"."id";
SELECT setval('"inventory"."option_value_id_seq"', 2, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."paging_config_id_seq"
OWNED BY "inventory"."paging_config"."id";
SELECT setval('"inventory"."paging_config_id_seq"', 2, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."pre_kit_id_seq"
OWNED BY "inventory"."pre_kit"."id";
SELECT setval('"inventory"."pre_kit_id_seq"', 62, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."sim_authen_log_id_seq"
OWNED BY "inventory"."sim_authen_log"."id";
SELECT setval('"inventory"."sim_authen_log_id_seq"', 2728, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."sim_history_detail_detail_id_seq"
OWNED BY "inventory"."sim_history_detail"."detail_id";
SELECT setval('"inventory"."sim_history_detail_detail_id_seq"', 102451, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inventory"."sim_history_his_id_seq"
OWNED BY "inventory"."sim_history"."his_id";
SELECT setval('"inventory"."sim_history_his_id_seq"', 102465, true);

-- ----------------------------
-- Primary Key structure for table config_require_used_time_before_mnp
-- ----------------------------
ALTER TABLE "inventory"."config_require_used_time_before_mnp" ADD CONSTRAINT "config_require_used_time_before_mnp_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table ftp_file
-- ----------------------------
ALTER TABLE "inventory"."ftp_file" ADD CONSTRAINT "ftp_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table home_network
-- ----------------------------
ALTER TABLE "inventory"."home_network" ADD CONSTRAINT "home_network_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table isdn
-- ----------------------------
CREATE INDEX "isdn_status_id_idx" ON "inventory"."isdn" USING btree (
  "status_id" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE INDEX "isdn_trgm_gin" ON "inventory"."isdn" USING gin (
  "isdn" COLLATE "pg_catalog"."default" "inventory"."gin_trgm_ops"
);

-- ----------------------------
-- Triggers structure for table isdn
-- ----------------------------
CREATE TRIGGER "locksold_isdnv2" BEFORE INSERT OR UPDATE OF "sold" ON "inventory"."isdn"
FOR EACH ROW
EXECUTE PROCEDURE "public"."locksold_isdnv2"();
ALTER TABLE "inventory"."isdn" DISABLE TRIGGER "locksold_isdnv2";
CREATE TRIGGER "log_isdn" AFTER UPDATE ON "inventory"."isdn"
FOR EACH ROW
WHEN (((old.shop_id <> new.shop_id) OR (old.price_custom <> new.price_custom) OR (old.price_default <> new.price_default) OR (old.status_id <> new.status_id) OR (old.level <> new.level) OR ((old.object_holding <> new.object_holding) AND (old.sold <> new.sold))))
EXECUTE PROCEDURE "public"."log_isdn_change"();

-- ----------------------------
-- Primary Key structure for table isdn
-- ----------------------------
ALTER TABLE "inventory"."isdn" ADD CONSTRAINT "isdn_pkey" PRIMARY KEY ("isdn");

-- ----------------------------
-- Primary Key structure for table isdn_beta
-- ----------------------------
ALTER TABLE "inventory"."isdn_beta" ADD CONSTRAINT "isdn_beta_pkey" PRIMARY KEY ("isdn");

-- ----------------------------
-- Indexes structure for table isdn_bk211101
-- ----------------------------
CREATE UNIQUE INDEX "isdn_index_copy8" ON "inventory"."isdn_bk211101" USING btree (
  "isdn" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Triggers structure for table isdn_bk211101
-- ----------------------------
CREATE TRIGGER "locksold_isdnv2" BEFORE INSERT OR UPDATE OF "sold" ON "inventory"."isdn_bk211101"
FOR EACH ROW
EXECUTE PROCEDURE "public"."locksold_isdnv2"();
ALTER TABLE "inventory"."isdn_bk211101" DISABLE TRIGGER "locksold_isdnv2";
CREATE TRIGGER "log_isdn" AFTER UPDATE ON "inventory"."isdn_bk211101"
FOR EACH ROW
EXECUTE PROCEDURE "public"."log_isdn_change"();

-- ----------------------------
-- Primary Key structure for table isdn_bk211101
-- ----------------------------
ALTER TABLE "inventory"."isdn_bk211101" ADD CONSTRAINT "isdn_copy2_pkey" PRIMARY KEY ("isdn");

-- ----------------------------
-- Primary Key structure for table isdn_head
-- ----------------------------
ALTER TABLE "inventory"."isdn_head" ADD CONSTRAINT "isdn_head_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table isdn_his
-- ----------------------------
ALTER TABLE "inventory"."isdn_his" ADD CONSTRAINT "isdn_his_pkey" PRIMARY KEY ("his_id");

-- ----------------------------
-- Primary Key structure for table isdn_his_detail
-- ----------------------------
ALTER TABLE "inventory"."isdn_his_detail" ADD CONSTRAINT "isdn_his_detail_pkey" PRIMARY KEY ("detail_id");

-- ----------------------------
-- Primary Key structure for table isdn_his_new
-- ----------------------------
ALTER TABLE "inventory"."isdn_his_new" ADD CONSTRAINT "isdn_his_new_pkey" PRIMARY KEY ("his_id");

-- ----------------------------
-- Primary Key structure for table isdn_masan
-- ----------------------------
ALTER TABLE "inventory"."isdn_masan" ADD CONSTRAINT "isdn_masan_pkey" PRIMARY KEY ("isdn");

-- ----------------------------
-- Primary Key structure for table isdn_role_mapping
-- ----------------------------
ALTER TABLE "inventory"."isdn_role_mapping" ADD CONSTRAINT "isdn_role_mapping_pkey" PRIMARY KEY ("isdn", "role_id");

-- ----------------------------
-- Primary Key structure for table isdn_rule
-- ----------------------------
ALTER TABLE "inventory"."isdn_rule" ADD CONSTRAINT "isdn_rule_beta_pkey" PRIMARY KEY ("rule_id");

-- ----------------------------
-- Primary Key structure for table isdn_rule_bk12072021
-- ----------------------------
ALTER TABLE "inventory"."isdn_rule_bk12072021" ADD CONSTRAINT "isdn_rule_copy1_pkey" PRIMARY KEY ("rule_id");

-- ----------------------------
-- Primary Key structure for table isdn_rule_copy1
-- ----------------------------
ALTER TABLE "inventory"."isdn_rule_copy1" ADD CONSTRAINT "isdn_rule_copy1_pkey1" PRIMARY KEY ("rule_id");

-- ----------------------------
-- Primary Key structure for table isdn_rule_type
-- ----------------------------
ALTER TABLE "inventory"."isdn_rule_type" ADD CONSTRAINT "isdn_rule_type_beta_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table isdn_rule_type_bk120721
-- ----------------------------
ALTER TABLE "inventory"."isdn_rule_type_bk120721" ADD CONSTRAINT "isdn_rule_type_copy1_rule_id_key" UNIQUE ("rule_id");

-- ----------------------------
-- Primary Key structure for table isdn_rule_type_bk120721
-- ----------------------------
ALTER TABLE "inventory"."isdn_rule_type_bk120721" ADD CONSTRAINT "isdn_rule_type_copy1_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table isdn_type
-- ----------------------------
ALTER TABLE "inventory"."isdn_type" ADD CONSTRAINT "isdn_type_pkey" PRIMARY KEY ("type_id");

-- ----------------------------
-- Primary Key structure for table kit
-- ----------------------------
ALTER TABLE "inventory"."kit" ADD CONSTRAINT "kit_pkey" PRIMARY KEY ("im_serial", "isdn");

-- ----------------------------
-- Primary Key structure for table kit_bk1706
-- ----------------------------
ALTER TABLE "inventory"."kit_bk1706" ADD CONSTRAINT "kit_copy1_pkey" PRIMARY KEY ("im_serial", "isdn");

-- ----------------------------
-- Primary Key structure for table kit_his
-- ----------------------------
ALTER TABLE "inventory"."kit_his" ADD CONSTRAINT "kit_his_pkey" PRIMARY KEY ("his_id");

-- ----------------------------
-- Primary Key structure for table kit_his_detail
-- ----------------------------
ALTER TABLE "inventory"."kit_his_detail" ADD CONSTRAINT "kit_his_detail_pkey" PRIMARY KEY ("detail_id");

-- ----------------------------
-- Primary Key structure for table kit_insert_history
-- ----------------------------
ALTER TABLE "inventory"."kit_insert_history" ADD CONSTRAINT "kit_insert_history_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table kit_insert_type
-- ----------------------------
ALTER TABLE "inventory"."kit_insert_type" ADD CONSTRAINT "kit_insert_type_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table kit_job_info
-- ----------------------------
ALTER TABLE "inventory"."kit_job_info" ADD CONSTRAINT "kit_job_info_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table kit_package
-- ----------------------------
ALTER TABLE "inventory"."kit_package" ADD CONSTRAINT "kit_package_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table level
-- ----------------------------
ALTER TABLE "inventory"."level" ADD CONSTRAINT "level_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table log_kit_job
-- ----------------------------
ALTER TABLE "inventory"."log_kit_job" ADD CONSTRAINT "log_kit_job_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table log_transaction
-- ----------------------------
ALTER TABLE "inventory"."log_transaction" ADD CONSTRAINT "log_transaction_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table object_holding
-- ----------------------------
ALTER TABLE "inventory"."object_holding" ADD CONSTRAINT "object_holding_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table ocs_reconciliation
-- ----------------------------
ALTER TABLE "inventory"."ocs_reconciliation" ADD CONSTRAINT "ocs_reconciliation_pkey" PRIMARY KEY ("isdn");

-- ----------------------------
-- Primary Key structure for table option
-- ----------------------------
ALTER TABLE "inventory"."option" ADD CONSTRAINT "option_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table option_value
-- ----------------------------
ALTER TABLE "inventory"."option_value" ADD CONSTRAINT "option_value_pk" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table paging_config
-- ----------------------------
ALTER TABLE "inventory"."paging_config" ADD CONSTRAINT "paging_config_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table pre_kit
-- ----------------------------
ALTER TABLE "inventory"."pre_kit" ADD CONSTRAINT "pre_kit_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table sim
-- ----------------------------
ALTER TABLE "inventory"."sim" ADD CONSTRAINT "iccid_unique" UNIQUE ("iccid");
ALTER TABLE "inventory"."sim" ADD CONSTRAINT "imsi_unique" UNIQUE ("imsi");

-- ----------------------------
-- Primary Key structure for table sim
-- ----------------------------
ALTER TABLE "inventory"."sim" ADD CONSTRAINT "sim_pkey" PRIMARY KEY ("im_serial");

-- ----------------------------
-- Primary Key structure for table sim_authen_log
-- ----------------------------
ALTER TABLE "inventory"."sim_authen_log" ADD CONSTRAINT "sim_authen_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table sim_authen_logg
-- ----------------------------
ALTER TABLE "inventory"."sim_authen_logg" ADD CONSTRAINT "checkauthsim_pk" PRIMARY KEY ("im_serial");

-- ----------------------------
-- Primary Key structure for table sim_beta
-- ----------------------------
ALTER TABLE "inventory"."sim_beta" ADD CONSTRAINT "sim_beta_pkey" PRIMARY KEY ("im_serial");

-- ----------------------------
-- Uniques structure for table sim_bk0609
-- ----------------------------
ALTER TABLE "inventory"."sim_bk0609" ADD CONSTRAINT "sim_copy1_iccid_key3" UNIQUE ("iccid");
ALTER TABLE "inventory"."sim_bk0609" ADD CONSTRAINT "sim_copy1_imsi_key3" UNIQUE ("imsi");

-- ----------------------------
-- Primary Key structure for table sim_bk0609
-- ----------------------------
ALTER TABLE "inventory"."sim_bk0609" ADD CONSTRAINT "sim_copy1_pkey3" PRIMARY KEY ("im_serial");

-- ----------------------------
-- Uniques structure for table sim_bk0906
-- ----------------------------
ALTER TABLE "inventory"."sim_bk0906" ADD CONSTRAINT "sim_copy1_iccid_key" UNIQUE ("iccid");
ALTER TABLE "inventory"."sim_bk0906" ADD CONSTRAINT "sim_copy1_imsi_key" UNIQUE ("imsi");

-- ----------------------------
-- Primary Key structure for table sim_bk0906
-- ----------------------------
ALTER TABLE "inventory"."sim_bk0906" ADD CONSTRAINT "sim_copy1_pkey" PRIMARY KEY ("im_serial");

-- ----------------------------
-- Uniques structure for table sim_bk1506
-- ----------------------------
ALTER TABLE "inventory"."sim_bk1506" ADD CONSTRAINT "sim_copy1_iccid_key1" UNIQUE ("iccid");
ALTER TABLE "inventory"."sim_bk1506" ADD CONSTRAINT "sim_copy1_imsi_key1" UNIQUE ("imsi");

-- ----------------------------
-- Primary Key structure for table sim_bk1506
-- ----------------------------
ALTER TABLE "inventory"."sim_bk1506" ADD CONSTRAINT "sim_copy1_pkey1" PRIMARY KEY ("im_serial");

-- ----------------------------
-- Uniques structure for table sim_bk1706
-- ----------------------------
ALTER TABLE "inventory"."sim_bk1706" ADD CONSTRAINT "sim_copy1_iccid_key2" UNIQUE ("iccid");
ALTER TABLE "inventory"."sim_bk1706" ADD CONSTRAINT "sim_copy1_imsi_key2" UNIQUE ("imsi");

-- ----------------------------
-- Primary Key structure for table sim_bk1706
-- ----------------------------
ALTER TABLE "inventory"."sim_bk1706" ADD CONSTRAINT "sim_copy1_pkey2" PRIMARY KEY ("im_serial");

-- ----------------------------
-- Primary Key structure for table sim_history
-- ----------------------------
ALTER TABLE "inventory"."sim_history" ADD CONSTRAINT "sim_history_pkey" PRIMARY KEY ("his_id");

-- ----------------------------
-- Primary Key structure for table sim_history_detail
-- ----------------------------
ALTER TABLE "inventory"."sim_history_detail" ADD CONSTRAINT "sim_history_detail_pkey" PRIMARY KEY ("detail_id");

-- ----------------------------
-- Indexes structure for table status
-- ----------------------------
CREATE INDEX "status_indexx" ON "inventory"."status" USING btree (
  "status_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table status
-- ----------------------------
ALTER TABLE "inventory"."status" ADD CONSTRAINT "status_pkey" PRIMARY KEY ("status_id");

-- ----------------------------
-- Primary Key structure for table stock
-- ----------------------------
ALTER TABLE "inventory"."stock" ADD CONSTRAINT "stock_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table isdn
-- ----------------------------
ALTER TABLE "inventory"."isdn" ADD CONSTRAINT "isdn_type_fk" FOREIGN KEY ("type_id") REFERENCES "inventory"."isdn_type" ("type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "inventory"."isdn" ADD CONSTRAINT "status_isdn_fk" FOREIGN KEY ("status_id") REFERENCES "inventory"."status" ("status_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table isdn_bk211101
-- ----------------------------
ALTER TABLE "inventory"."isdn_bk211101" ADD CONSTRAINT "isdn_copy2_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "inventory"."status" ("status_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "inventory"."isdn_bk211101" ADD CONSTRAINT "isdn_copy2_type_id_fkey" FOREIGN KEY ("type_id") REFERENCES "inventory"."isdn_type" ("type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table isdn_his
-- ----------------------------
ALTER TABLE "inventory"."isdn_his" ADD CONSTRAINT "fkppphcdd670yhdjq1cmm1syio2" FOREIGN KEY ("isdn") REFERENCES "inventory"."isdn" ("isdn") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table isdn_his_detail
-- ----------------------------
ALTER TABLE "inventory"."isdn_his_detail" ADD CONSTRAINT "fkgqqm194oigq4fbxskqgq1bdy" FOREIGN KEY ("his_id") REFERENCES "inventory"."isdn_his" ("his_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table kit
-- ----------------------------
ALTER TABLE "inventory"."kit" ADD CONSTRAINT "fkprq1pq579t5gj982hlii2rekp" FOREIGN KEY ("im_serial") REFERENCES "inventory"."sim" ("im_serial") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "inventory"."kit" ADD CONSTRAINT "kit-isdn-fk" FOREIGN KEY ("isdn") REFERENCES "inventory"."isdn" ("isdn") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "inventory"."kit" ADD CONSTRAINT "kit-status-fk" FOREIGN KEY ("status_id") REFERENCES "inventory"."status" ("status_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table kit_bk1706
-- ----------------------------
ALTER TABLE "inventory"."kit_bk1706" ADD CONSTRAINT "kit_copy1_isdn_fkey" FOREIGN KEY ("isdn") REFERENCES "inventory"."isdn" ("isdn") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "inventory"."kit_bk1706" ADD CONSTRAINT "kit_copy1_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "inventory"."status" ("status_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table kit_his_detail
-- ----------------------------
ALTER TABLE "inventory"."kit_his_detail" ADD CONSTRAINT "his_fk" FOREIGN KEY ("his_id") REFERENCES "inventory"."kit_his" ("his_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table sim
-- ----------------------------
ALTER TABLE "inventory"."sim" ADD CONSTRAINT "fk90mfllrfb0yoww9wol5xdq6qt" FOREIGN KEY ("status_id") REFERENCES "inventory"."status" ("status_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table sim_bk0609
-- ----------------------------
ALTER TABLE "inventory"."sim_bk0609" ADD CONSTRAINT "sim_copy1_status_id_fkey3" FOREIGN KEY ("status_id") REFERENCES "inventory"."status" ("status_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table sim_bk0906
-- ----------------------------
ALTER TABLE "inventory"."sim_bk0906" ADD CONSTRAINT "sim_copy1_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "inventory"."status" ("status_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table sim_bk1506
-- ----------------------------
ALTER TABLE "inventory"."sim_bk1506" ADD CONSTRAINT "sim_copy1_status_id_fkey1" FOREIGN KEY ("status_id") REFERENCES "inventory"."status" ("status_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table sim_bk1706
-- ----------------------------
ALTER TABLE "inventory"."sim_bk1706" ADD CONSTRAINT "sim_copy1_status_id_fkey2" FOREIGN KEY ("status_id") REFERENCES "inventory"."status" ("status_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table sim_history
-- ----------------------------
ALTER TABLE "inventory"."sim_history" ADD CONSTRAINT "fkblaf09byymk5rwv2t1qepjdif" FOREIGN KEY ("im_serial") REFERENCES "inventory"."sim" ("im_serial") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table sim_history_detail
-- ----------------------------
ALTER TABLE "inventory"."sim_history_detail" ADD CONSTRAINT "fkh4fxvrnyuo5ujfa1vlbubif4c" FOREIGN KEY ("his_id") REFERENCES "inventory"."sim_history" ("his_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
