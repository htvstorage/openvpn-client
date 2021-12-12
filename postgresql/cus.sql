--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5
-- Dumped by pg_dump version 12.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: account; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA account;


ALTER SCHEMA account OWNER TO postgres;

--
-- Name: complain; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA complain;


ALTER SCHEMA complain OWNER TO postgres;

--
-- Name: customer; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA customer;


ALTER SCHEMA customer OWNER TO postgres;

--
-- Name: gamification; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA gamification;


ALTER SCHEMA gamification OWNER TO postgres;

--
-- Name: log; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA log;


ALTER SCHEMA log OWNER TO postgres;

--
-- Name: mnp; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA mnp;


ALTER SCHEMA mnp OWNER TO postgres;

--
-- Name: notification; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA notification;


ALTER SCHEMA notification OWNER TO postgres;

--
-- Name: otp; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA otp;


ALTER SCHEMA otp OWNER TO postgres;

--
-- Name: subscriber; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA subscriber;


ALTER SCHEMA subscriber OWNER TO postgres;

--
-- Name: log_change_ag_user(); Type: FUNCTION; Schema: account; Owner: postgres
--

CREATE FUNCTION account.log_change_ag_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
	insert into account.log_update_ag_user (value_old, value_new, "user",ag_user_id,created_time) values (old.status, new.status, session_user,new.id, current_timestamp);
	return new;
	exception when others then  RAISE NOTICE 'error insert';
	return new;
end;
$$;


ALTER FUNCTION account.log_change_ag_user() OWNER TO postgres;

--
-- Name: log_change_chanel(); Type: FUNCTION; Schema: account; Owner: postgres
--

CREATE FUNCTION account.log_change_chanel() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
	insert into account.log_update_chanel (new_value, old_value, "user", created_time, user_name, ag_user_id) values (new.status, old.status, session_user, current_timestamp, new.user_name, new.ag_user_id);
	return new;
	exception when others then  RAISE NOTICE 'error insert';
	return new;
end;
$$;


ALTER FUNCTION account.log_change_chanel() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ids; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ids (
    id integer NOT NULL
);


ALTER TABLE public.ids OWNER TO postgres;

--
-- Name: example_array_input(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.example_array_input(integer[]) RETURNS SETOF public.ids
    LANGUAGE plpgsql
    AS $_$
DECLARE
        in_clause ALIAS FOR $1;
        clause  TEXT;
        rec     RECORD;
BEGIN
        FOR rec IN SELECT id FROM ids WHERE id = ANY(in_clause)
        LOOP
                RETURN NEXT rec;
        END LOOP;
        -- final return
        RETURN;
END
$_$;


ALTER FUNCTION public.example_array_input(integer[]) OWNER TO postgres;

--
-- Name: account_his; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.account_his (
    id bigint NOT NULL,
    account_id bigint,
    action character varying(255),
    chanel_act character varying(255),
    chanel_id bigint,
    ip character varying(255),
    user_act character varying(255)
);


ALTER TABLE account.account_his OWNER TO postgres;

--
-- Name: account_his_detail; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.account_his_detail (
    id bigint NOT NULL,
    his_id bigint
);


ALTER TABLE account.account_his_detail OWNER TO postgres;

--
-- Name: account_his_detail_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.account_his_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.account_his_detail_id_seq OWNER TO postgres;

--
-- Name: account_his_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.account_his_detail_id_seq OWNED BY account.account_his_detail.id;


--
-- Name: account_his_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.account_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.account_his_id_seq OWNER TO postgres;

--
-- Name: account_his_id_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.account_his_id_seq OWNED BY account.account_his.id;


--
-- Name: ag_access_log; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_access_log (
    id character varying(255) NOT NULL,
    access_time timestamp without time zone NOT NULL,
    host character varying(1000),
    log_out_time timestamp without time zone,
    status bigint,
    user_name character varying(1000)
);


ALTER TABLE account.ag_access_log OWNER TO postgres;

--
-- Name: ag_action_log; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_action_log (
    id character varying(255) NOT NULL,
    action_code character varying(200),
    description character varying(2000),
    ip character varying(200),
    issue_datetime timestamp without time zone,
    pk_id character varying(200),
    pk_type bigint,
    reason_id bigint,
    user_name character varying(1000)
);


ALTER TABLE account.ag_action_log OWNER TO postgres;

--
-- Name: ag_action_log_detail; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_action_log_detail (
    id character varying(255) NOT NULL,
    col_name character varying(200),
    issue_datetime timestamp without time zone,
    new_value character varying(800),
    old_value character varying(800),
    row_id bigint,
    table_name character varying(200),
    ag_action_log_id character varying(255)
);


ALTER TABLE account.ag_action_log_detail OWNER TO postgres;

--
-- Name: ag_api_resource; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_api_resource (
    id character varying(255) NOT NULL,
    api_code character varying(1000) NOT NULL,
    api_key character varying(400) NOT NULL,
    api_name character varying(2000),
    api_name_en character varying(2000),
    api_template character varying(800),
    authenticate bigint,
    authenticate_otp bigint,
    created_time timestamp without time zone,
    creator character varying(200),
    description character varying(2000),
    expired_date timestamp without time zone,
    last_updated_time timestamp without time zone,
    last_updator character varying(200),
    status bigint,
    version character varying(800),
    ag_throttling_id character varying(255)
);


ALTER TABLE account.ag_api_resource OWNER TO postgres;

--
-- Name: COLUMN ag_api_resource.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.id IS 'Id của bảng ';


--
-- Name: COLUMN ag_api_resource.api_code; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.api_code IS 'api code';


--
-- Name: COLUMN ag_api_resource.api_key; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.api_key IS 'api key';


--
-- Name: COLUMN ag_api_resource.api_name; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.api_name IS 'tên api';


--
-- Name: COLUMN ag_api_resource.api_name_en; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.api_name_en IS 'tên api ngôn ngữ tiếng anh';


--
-- Name: COLUMN ag_api_resource.api_template; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.api_template IS 'template api';


--
-- Name: COLUMN ag_api_resource.authenticate; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.authenticate IS 'có authen api hay không: 0 - không , 1 - có';


--
-- Name: COLUMN ag_api_resource.authenticate_otp; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.authenticate_otp IS 'có authen otp hay không: 0 - không,1 - có';


--
-- Name: COLUMN ag_api_resource.created_time; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.created_time IS 'thời gian khai báo api';


--
-- Name: COLUMN ag_api_resource.creator; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.creator IS 'người tạo api';


--
-- Name: COLUMN ag_api_resource.description; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.description IS 'mô tả api';


--
-- Name: COLUMN ag_api_resource.expired_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.expired_date IS 'thời gian hết hiệu lực api';


--
-- Name: COLUMN ag_api_resource.last_updated_time; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.last_updated_time IS 'lần update thông tin cuối cùng api';


--
-- Name: COLUMN ag_api_resource.last_updator; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.last_updator IS 'người update cuối cùng';


--
-- Name: COLUMN ag_api_resource.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.status IS 'trạng thái api';


--
-- Name: COLUMN ag_api_resource.version; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource.version IS 'version api';


--
-- Name: ag_api_resource_detail; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_api_resource_detail (
    id character varying(255) NOT NULL,
    api_template character varying(800),
    base_path character varying(4000),
    created_time timestamp without time zone,
    creator character varying(200),
    description character varying(2000),
    end_point_address character varying(2000) NOT NULL,
    end_point_type bigint NOT NULL,
    expired_date timestamp without time zone,
    functions character varying(1600),
    is_namespace_par bigint,
    last_updated_time timestamp without time zone,
    last_updator character varying(200),
    method character varying(4000),
    status bigint NOT NULL,
    target_namespace character varying(1600),
    timeout bigint,
    version character varying(800),
    ag_api_resource_id character varying(255)
);


ALTER TABLE account.ag_api_resource_detail OWNER TO postgres;

--
-- Name: COLUMN ag_api_resource_detail.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.id IS 'id của bảng';


--
-- Name: COLUMN ag_api_resource_detail.api_template; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.api_template IS 'teamplate api';


--
-- Name: COLUMN ag_api_resource_detail.base_path; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.base_path IS 'đường dẫn api gốc';


--
-- Name: COLUMN ag_api_resource_detail.created_time; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.created_time IS 'thời gian tạo';


--
-- Name: COLUMN ag_api_resource_detail.creator; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.creator IS 'người tạo';


--
-- Name: COLUMN ag_api_resource_detail.description; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.description IS 'mô tả api';


--
-- Name: COLUMN ag_api_resource_detail.end_point_address; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.end_point_address IS 'đường dẫn cuối của api';


--
-- Name: COLUMN ag_api_resource_detail.expired_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.expired_date IS 'ngày hết hiệu lục';


--
-- Name: COLUMN ag_api_resource_detail.functions; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.functions IS 'tính năng';


--
-- Name: COLUMN ag_api_resource_detail.is_namespace_par; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.is_namespace_par IS 'check name space';


--
-- Name: COLUMN ag_api_resource_detail.last_updated_time; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.last_updated_time IS 'thời gian lần cuối chỉnh sửa';


--
-- Name: COLUMN ag_api_resource_detail.last_updator; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.last_updator IS 'người cuối cùng chỉnh sửa';


--
-- Name: COLUMN ag_api_resource_detail.method; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.method IS 'method';


--
-- Name: COLUMN ag_api_resource_detail.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.status IS 'trạng thái';


--
-- Name: COLUMN ag_api_resource_detail.timeout; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.timeout IS 'thời gian time out';


--
-- Name: COLUMN ag_api_resource_detail.version; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.version IS 'phiên bản';


--
-- Name: COLUMN ag_api_resource_detail.ag_api_resource_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_api_resource_detail.ag_api_resource_id IS 'id link tới bảng tài nguyên api';


--
-- Name: ag_app_function; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_app_function (
    id character varying(255) NOT NULL,
    created_date timestamp without time zone,
    description character varying(2000),
    status bigint,
    ag_application_id character varying(255),
    ag_function_id character varying(255)
);


ALTER TABLE account.ag_app_function OWNER TO postgres;

--
-- Name: COLUMN ag_app_function.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_app_function.id IS 'id của bảng';


--
-- Name: COLUMN ag_app_function.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_app_function.created_date IS 'ngày tạo';


--
-- Name: COLUMN ag_app_function.description; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_app_function.description IS 'mô tả';


--
-- Name: COLUMN ag_app_function.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_app_function.status IS 'trạng thái';


--
-- Name: COLUMN ag_app_function.ag_application_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_app_function.ag_application_id IS 'mapping với id của ứng dụng';


--
-- Name: COLUMN ag_app_function.ag_function_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_app_function.ag_function_id IS 'mapping với id của chức năng';


--
-- Name: ag_app_role; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_app_role (
    id character varying(255) NOT NULL,
    created_date timestamp without time zone,
    description character varying(2000),
    status bigint,
    ag_application_id character varying(255),
    ag_role_id character varying(255)
);


ALTER TABLE account.ag_app_role OWNER TO postgres;

--
-- Name: COLUMN ag_app_role.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_app_role.id IS '⁯id của bảng';


--
-- Name: COLUMN ag_app_role.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_app_role.created_date IS 'ngày tạo bảng';


--
-- Name: COLUMN ag_app_role.description; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_app_role.description IS 'mô tả bảng';


--
-- Name: COLUMN ag_app_role.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_app_role.status IS 'trạng thái của bảng';


--
-- Name: COLUMN ag_app_role.ag_application_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_app_role.ag_application_id IS 'id của ứng dụng';


--
-- Name: COLUMN ag_app_role.ag_role_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_app_role.ag_role_id IS 'id của luật';


--
-- Name: ag_application; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_application (
    id character varying(255) NOT NULL,
    app_code character varying(1000) NOT NULL,
    app_name character varying(1000),
    app_name_en character varying(1000),
    created_date timestamp without time zone,
    description character varying(2000),
    facebook_app_id character varying(1000),
    facebook_app_secret character varying(1000),
    google_app_id character varying(1000),
    google_app_secret character varying(1000),
    status bigint
);


ALTER TABLE account.ag_application OWNER TO postgres;

--
-- Name: COLUMN ag_application.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_application.id IS 'id của bảng';


--
-- Name: COLUMN ag_application.app_code; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_application.app_code IS 'mã code của ứng dụng';


--
-- Name: COLUMN ag_application.app_name; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_application.app_name IS 'tên của ứng dụng';


--
-- Name: COLUMN ag_application.app_name_en; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_application.app_name_en IS 'tên của ứng dụng ngôn ngữ tiếng anh';


--
-- Name: COLUMN ag_application.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_application.created_date IS 'ngày tạo';


--
-- Name: COLUMN ag_application.description; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_application.description IS 'mô tả';


--
-- Name: COLUMN ag_application.facebook_app_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_application.facebook_app_id IS 'id facebook của ứng dụng';


--
-- Name: COLUMN ag_application.facebook_app_secret; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_application.facebook_app_secret IS 'secert của ứng dụng trên face book';


--
-- Name: COLUMN ag_application.google_app_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_application.google_app_id IS 'id trên google của ứng dụng';


--
-- Name: COLUMN ag_application.google_app_secret; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_application.google_app_secret IS 'sercert của ứng dụng trên google';


--
-- Name: COLUMN ag_application.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_application.status IS 'trang thái của úng dụng';


--
-- Name: ag_chanel; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_chanel (
    type integer NOT NULL,
    status integer NOT NULL,
    user_name character varying(1000) NOT NULL,
    ag_user_id bigint,
    id bigint NOT NULL,
    full_name character varying(255)
);


ALTER TABLE account.ag_chanel OWNER TO postgres;

--
-- Name: COLUMN ag_chanel.type; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_chanel.type IS 'kiểu đăng nhập: 1- sdt, 2-fb, 3-gg, 4-tk mbc';


--
-- Name: COLUMN ag_chanel.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_chanel.status IS 'trạng thái đăng nhập: 1-active, 2-delete';


--
-- Name: COLUMN ag_chanel.user_name; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_chanel.user_name IS 'tên đăng nhập';


--
-- Name: COLUMN ag_chanel.ag_user_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_chanel.ag_user_id IS 'mapping với thông tin user';


--
-- Name: COLUMN ag_chanel.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_chanel.id IS 'id của bảng';


--
-- Name: COLUMN ag_chanel.full_name; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_chanel.full_name IS 'tên đầy đu của user';


--
-- Name: ag_chanel_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.ag_chanel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.ag_chanel_id_seq OWNER TO postgres;

--
-- Name: ag_chanel_id_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.ag_chanel_id_seq OWNED BY account.ag_chanel.id;


--
-- Name: ag_domain; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_domain (
    id character varying(255) NOT NULL,
    created_date timestamp without time zone,
    description character varying(2000),
    domain_code character varying(1000),
    domain_name character varying(1000) NOT NULL,
    domain_name_en character varying(1000),
    status bigint
);


ALTER TABLE account.ag_domain OWNER TO postgres;

--
-- Name: COLUMN ag_domain.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_domain.id IS 'id của bảng';


--
-- Name: COLUMN ag_domain.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_domain.created_date IS 'ngày tạo';


--
-- Name: COLUMN ag_domain.description; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_domain.description IS 'mô tả';


--
-- Name: COLUMN ag_domain.domain_code; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_domain.domain_code IS 'mã domain';


--
-- Name: COLUMN ag_domain.domain_name; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_domain.domain_name IS 'tên domain';


--
-- Name: COLUMN ag_domain.domain_name_en; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_domain.domain_name_en IS 'tên domain tiếng anh';


--
-- Name: COLUMN ag_domain.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_domain.status IS 'trạng thái của bảng';


--
-- Name: ag_error_code; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_error_code (
    id character varying(255) NOT NULL,
    code character varying(200),
    description character varying(2000),
    title character varying(1000)
);


ALTER TABLE account.ag_error_code OWNER TO postgres;

--
-- Name: COLUMN ag_error_code.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_error_code.id IS 'id của bảng';


--
-- Name: COLUMN ag_error_code.code; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_error_code.code IS 'mã lỗi';


--
-- Name: COLUMN ag_error_code.description; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_error_code.description IS 'mô tả lỗi';


--
-- Name: COLUMN ag_error_code.title; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_error_code.title IS 'mô tả ngắn';


--
-- Name: ag_function; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_function (
    id character varying(255) NOT NULL,
    created_date timestamp without time zone,
    description character varying(2000),
    function_code character varying(1000) NOT NULL,
    function_name character varying(1000) NOT NULL,
    function_name_en character varying(1000),
    status bigint
);


ALTER TABLE account.ag_function OWNER TO postgres;

--
-- Name: COLUMN ag_function.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function.id IS 'id của bảng';


--
-- Name: COLUMN ag_function.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function.created_date IS 'ngày tạo';


--
-- Name: COLUMN ag_function.description; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function.description IS 'mô tả';


--
-- Name: COLUMN ag_function.function_code; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function.function_code IS 'mã function';


--
-- Name: COLUMN ag_function.function_name; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function.function_name IS 'tên function';


--
-- Name: COLUMN ag_function.function_name_en; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function.function_name_en IS 'tên function tiếng anh';


--
-- Name: COLUMN ag_function.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function.status IS 'trang thái';


--
-- Name: ag_function_api; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_function_api (
    id character varying(255) NOT NULL,
    created_date timestamp without time zone,
    description character varying(2000),
    status bigint,
    ag_api_resource_id character varying(255),
    ag_function_id character varying(255)
);


ALTER TABLE account.ag_function_api OWNER TO postgres;

--
-- Name: COLUMN ag_function_api.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function_api.id IS 'id của bảng';


--
-- Name: COLUMN ag_function_api.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function_api.created_date IS 'ngày tạo';


--
-- Name: COLUMN ag_function_api.description; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function_api.description IS 'mô tả';


--
-- Name: COLUMN ag_function_api.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function_api.status IS 'trang thái';


--
-- Name: COLUMN ag_function_api.ag_api_resource_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function_api.ag_api_resource_id IS 'mapping với bảng api';


--
-- Name: COLUMN ag_function_api.ag_function_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_function_api.ag_function_id IS 'mapping vói bảng function';


--
-- Name: ag_log_transaction; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_log_transaction (
    id character varying(255) NOT NULL,
    api_url character varying(4000),
    end_time timestamp without time zone,
    ip character varying(200),
    request character varying(4000),
    resource_method character varying(1020),
    response character varying(4000),
    result bigint,
    session_id character varying(800),
    start_time timestamp without time zone,
    ag_api_resource_id character varying(255),
    ag_application_id character varying(255),
    ag_domain_id character varying(255)
);


ALTER TABLE account.ag_log_transaction OWNER TO postgres;

--
-- Name: ag_map_app; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_map_app (
    id bigint NOT NULL,
    status bigint,
    ag_app_id character varying(255),
    ag_app_map_id character varying(255)
);


ALTER TABLE account.ag_map_app OWNER TO postgres;

--
-- Name: ag_map_app_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.ag_map_app_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.ag_map_app_id_seq OWNER TO postgres;

--
-- Name: ag_map_app_id_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.ag_map_app_id_seq OWNED BY account.ag_map_app.id;


--
-- Name: ag_prefix_domain; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_prefix_domain (
    id character varying(255) NOT NULL,
    changed_time timestamp without time zone,
    prefix character varying(200) NOT NULL,
    status bigint,
    ag_domain_id character varying(255)
);


ALTER TABLE account.ag_prefix_domain OWNER TO postgres;

--
-- Name: COLUMN ag_prefix_domain.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_prefix_domain.id IS 'id';


--
-- Name: COLUMN ag_prefix_domain.changed_time; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_prefix_domain.changed_time IS 'thời gian thay đổi';


--
-- Name: COLUMN ag_prefix_domain.prefix; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_prefix_domain.prefix IS 'mã prefix';


--
-- Name: COLUMN ag_prefix_domain.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_prefix_domain.status IS 'trang thái';


--
-- Name: COLUMN ag_prefix_domain.ag_domain_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_prefix_domain.ag_domain_id IS 'id của domain';


--
-- Name: ag_role; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_role (
    id character varying(255) NOT NULL,
    create_date timestamp without time zone,
    description character varying(2000),
    role_code character varying(1000),
    role_name character varying(800) NOT NULL,
    role_name_en character varying(800),
    status bigint
);


ALTER TABLE account.ag_role OWNER TO postgres;

--
-- Name: COLUMN ag_role.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role.id IS 'id';


--
-- Name: COLUMN ag_role.create_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role.create_date IS 'ngày tạo';


--
-- Name: COLUMN ag_role.description; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role.description IS 'mô tả';


--
-- Name: COLUMN ag_role.role_code; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role.role_code IS 'mã luật';


--
-- Name: COLUMN ag_role.role_name; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role.role_name IS 'tên luật';


--
-- Name: COLUMN ag_role.role_name_en; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role.role_name_en IS 'tên luật tiếng anh';


--
-- Name: COLUMN ag_role.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role.status IS 'trạng thái';


--
-- Name: ag_role_app; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_role_app (
    id character varying(255) NOT NULL,
    created_date timestamp without time zone,
    description character varying(2000),
    status bigint,
    ag_application_id character varying(255),
    ag_role_id character varying(255)
);


ALTER TABLE account.ag_role_app OWNER TO postgres;

--
-- Name: COLUMN ag_role_app.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role_app.id IS 'id';


--
-- Name: COLUMN ag_role_app.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role_app.created_date IS 'ngày tạo';


--
-- Name: COLUMN ag_role_app.description; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role_app.description IS 'mô tả';


--
-- Name: COLUMN ag_role_app.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role_app.status IS 'trạng thái';


--
-- Name: COLUMN ag_role_app.ag_application_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role_app.ag_application_id IS 'id của ứng dụng';


--
-- Name: COLUMN ag_role_app.ag_role_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role_app.ag_role_id IS 'id của luật';


--
-- Name: ag_role_function; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_role_function (
    id character varying(255) NOT NULL,
    created_date timestamp without time zone,
    description character varying(2000),
    status bigint,
    ag_function_id character varying(255),
    ag_role_id character varying(255)
);


ALTER TABLE account.ag_role_function OWNER TO postgres;

--
-- Name: COLUMN ag_role_function.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role_function.id IS 'id';


--
-- Name: COLUMN ag_role_function.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role_function.created_date IS 'ngày tạo';


--
-- Name: COLUMN ag_role_function.description; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role_function.description IS 'mô tả';


--
-- Name: COLUMN ag_role_function.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role_function.status IS 'trạng thái';


--
-- Name: COLUMN ag_role_function.ag_function_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role_function.ag_function_id IS 'id function';


--
-- Name: COLUMN ag_role_function.ag_role_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_role_function.ag_role_id IS 'id luật';


--
-- Name: ag_system_user_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.ag_system_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.ag_system_user_id_seq OWNER TO postgres;

--
-- Name: ag_system_user; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_system_user (
    id bigint DEFAULT nextval('account.ag_system_user_id_seq'::regclass) NOT NULL,
    changed_date timestamp without time zone,
    email character varying(800),
    password character varying(2000) NOT NULL,
    phone character varying(200),
    registered_date timestamp without time zone,
    require_change bigint,
    salt_value character varying(400),
    status bigint,
    user_name character varying(800) NOT NULL,
    ag_domain_id character varying(255)
);


ALTER TABLE account.ag_system_user OWNER TO postgres;

--
-- Name: COLUMN ag_system_user.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_system_user.id IS 'id';


--
-- Name: COLUMN ag_system_user.changed_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_system_user.changed_date IS 'ngày thay đổi';


--
-- Name: COLUMN ag_system_user.email; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_system_user.email IS 'email';


--
-- Name: COLUMN ag_system_user.password; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_system_user.password IS 'mật khẩu';


--
-- Name: COLUMN ag_system_user.phone; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_system_user.phone IS 'số điện thoại';


--
-- Name: COLUMN ag_system_user.registered_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_system_user.registered_date IS 'ngày đăng ký';


--
-- Name: COLUMN ag_system_user.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_system_user.status IS 'trạng thái';


--
-- Name: COLUMN ag_system_user.user_name; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_system_user.user_name IS 'tên đăng nhập';


--
-- Name: COLUMN ag_system_user.ag_domain_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_system_user.ag_domain_id IS 'domain áp dụng';


--
-- Name: ag_throttling; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_throttling (
    id character varying(255) NOT NULL,
    created_date timestamp without time zone,
    request_number bigint NOT NULL,
    status bigint,
    throttling_name character varying(1000) NOT NULL,
    throttling_name_en character varying(1000)
);


ALTER TABLE account.ag_throttling OWNER TO postgres;

--
-- Name: ag_user; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_user (
    changed_time timestamp(6) without time zone,
    last_login_time timestamp(6) without time zone,
    password character varying(2000),
    registered_date character varying(60),
    status bigint,
    ag_domain_id character varying(255),
    id bigint NOT NULL,
    expired_date timestamp(6) without time zone,
    personal_wallet boolean DEFAULT false NOT NULL,
    shop_wallet boolean DEFAULT false,
    old_password character varying(2000),
    email character varying(4000),
    phone character varying(200),
    require_change double precision,
    salt_value character varying(200)
);


ALTER TABLE account.ag_user OWNER TO postgres;

--
-- Name: COLUMN ag_user.changed_time; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user.changed_time IS 'thời gian thay đổi';


--
-- Name: COLUMN ag_user.last_login_time; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user.last_login_time IS 'lần đăng nhập cuối';


--
-- Name: COLUMN ag_user.password; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user.password IS 'mật khẩu';


--
-- Name: COLUMN ag_user.registered_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user.registered_date IS 'ngày đăng ký';


--
-- Name: COLUMN ag_user.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user.status IS '1: active, 2:lock';


--
-- Name: COLUMN ag_user.ag_domain_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user.ag_domain_id IS 'id của domain';


--
-- Name: COLUMN ag_user.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user.id IS 'id';


--
-- Name: COLUMN ag_user.expired_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user.expired_date IS 'ngày hết hạn';


--
-- Name: COLUMN ag_user.personal_wallet; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user.personal_wallet IS 'đã có ví cá nhân chưa';


--
-- Name: COLUMN ag_user.shop_wallet; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user.shop_wallet IS 'đã có ví đại lý chưa';


--
-- Name: COLUMN ag_user.old_password; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user.old_password IS 'mật khẩu phục vụ cho callback';


--
-- Name: ag_user_app; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_user_app (
    id character varying(255) NOT NULL,
    created_date timestamp without time zone,
    status bigint,
    ag_application_id character varying(255),
    ag_system_user_id bigint,
    ag_user_id bigint
);


ALTER TABLE account.ag_user_app OWNER TO postgres;

--
-- Name: COLUMN ag_user_app.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_app.id IS 'id của bảng';


--
-- Name: COLUMN ag_user_app.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_app.created_date IS 'ngày tạo';


--
-- Name: COLUMN ag_user_app.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_app.status IS 'trạng thái';


--
-- Name: COLUMN ag_user_app.ag_application_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_app.ag_application_id IS 'Id của ứng dụng';


--
-- Name: COLUMN ag_user_app.ag_system_user_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_app.ag_system_user_id IS 'Id của user hệ thống';


--
-- Name: COLUMN ag_user_app.ag_user_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_app.ag_user_id IS 'Id của user';


--
-- Name: ag_user_app_trial; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_user_app_trial (
    created_date timestamp(6) without time zone NOT NULL,
    ag_application_id character varying(255),
    ag_user_trial_id bigint,
    status bigint NOT NULL,
    id integer NOT NULL,
    ag_system_user_id character varying(255)
);


ALTER TABLE account.ag_user_app_trial OWNER TO postgres;

--
-- Name: COLUMN ag_user_app_trial.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_app_trial.created_date IS 'ngày tạo';


--
-- Name: COLUMN ag_user_app_trial.ag_application_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_app_trial.ag_application_id IS 'Id ứng dụng';


--
-- Name: COLUMN ag_user_app_trial.ag_user_trial_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_app_trial.ag_user_trial_id IS 'Id user trial';


--
-- Name: COLUMN ag_user_app_trial.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_app_trial.status IS 'Trạng thái';


--
-- Name: COLUMN ag_user_app_trial.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_app_trial.id IS 'Id của bảng';


--
-- Name: ag_user_app_trial_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.ag_user_app_trial_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.ag_user_app_trial_id_seq OWNER TO postgres;

--
-- Name: ag_user_app_trial_id_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.ag_user_app_trial_id_seq OWNED BY account.ag_user_app_trial.id;


--
-- Name: ag_user_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.ag_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.ag_user_id_seq OWNER TO postgres;

--
-- Name: ag_user_id_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.ag_user_id_seq OWNED BY account.ag_user.id;


--
-- Name: ag_user_role; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_user_role (
    id character varying(255) NOT NULL,
    created_date timestamp without time zone,
    status bigint,
    ag_role_id character varying(255),
    ag_system_user_id bigint,
    ag_user_id bigint
);


ALTER TABLE account.ag_user_role OWNER TO postgres;

--
-- Name: COLUMN ag_user_role.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_role.id IS 'Id của bảng';


--
-- Name: COLUMN ag_user_role.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_role.created_date IS 'ngày tạo';


--
-- Name: COLUMN ag_user_role.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_role.status IS 'trạng thái';


--
-- Name: COLUMN ag_user_role.ag_role_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_role.ag_role_id IS 'id của luật';


--
-- Name: COLUMN ag_user_role.ag_system_user_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_role.ag_system_user_id IS 'id user hệ thống';


--
-- Name: COLUMN ag_user_role.ag_user_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_role.ag_user_id IS 'id của user';


--
-- Name: ag_user_role_trial; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_user_role_trial (
    created_date timestamp(6) without time zone NOT NULL,
    ag_role_id character varying(255),
    ag_user_trial_id bigint,
    status bigint,
    id integer NOT NULL,
    ag_system_user_id character varying(255)
);


ALTER TABLE account.ag_user_role_trial OWNER TO postgres;

--
-- Name: COLUMN ag_user_role_trial.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_role_trial.created_date IS 'ngày tạo';


--
-- Name: COLUMN ag_user_role_trial.ag_role_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_role_trial.ag_role_id IS 'id của luật';


--
-- Name: COLUMN ag_user_role_trial.ag_user_trial_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_role_trial.ag_user_trial_id IS 'id của user trial';


--
-- Name: COLUMN ag_user_role_trial.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_role_trial.status IS 'trạng thái';


--
-- Name: COLUMN ag_user_role_trial.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_role_trial.id IS 'id của bảng';


--
-- Name: ag_user_role_trial_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.ag_user_role_trial_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.ag_user_role_trial_id_seq OWNER TO postgres;

--
-- Name: ag_user_role_trial_id_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.ag_user_role_trial_id_seq OWNED BY account.ag_user_role_trial.id;


--
-- Name: ag_user_trial; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.ag_user_trial (
    device_id character varying(255) NOT NULL,
    created_date timestamp(6) without time zone NOT NULL,
    expired_date timestamp(6) without time zone,
    ag_application_id bigint,
    ag_role_id bigint,
    id integer NOT NULL,
    status integer,
    number_of_login integer NOT NULL
);


ALTER TABLE account.ag_user_trial OWNER TO postgres;

--
-- Name: COLUMN ag_user_trial.device_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_trial.device_id IS 'id của thiết bị';


--
-- Name: COLUMN ag_user_trial.created_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_trial.created_date IS 'ngày tạo';


--
-- Name: COLUMN ag_user_trial.expired_date; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_trial.expired_date IS 'ngày hết hạn';


--
-- Name: COLUMN ag_user_trial.ag_application_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_trial.ag_application_id IS 'id của ứng dụng';


--
-- Name: COLUMN ag_user_trial.ag_role_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_trial.ag_role_id IS 'id luật';


--
-- Name: COLUMN ag_user_trial.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_trial.id IS 'id của bảng';


--
-- Name: COLUMN ag_user_trial.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_trial.status IS 'trang thái';


--
-- Name: COLUMN ag_user_trial.number_of_login; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.ag_user_trial.number_of_login IS 'số lần login';


--
-- Name: ag_user_trial_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.ag_user_trial_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.ag_user_trial_id_seq OWNER TO postgres;

--
-- Name: ag_user_trial_id_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.ag_user_trial_id_seq OWNED BY account.ag_user_trial.id;


--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.hibernate_sequence OWNER TO postgres;

--
-- Name: log_login_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.log_login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.log_login_id_seq OWNER TO postgres;

--
-- Name: log_login; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.log_login (
    id bigint DEFAULT nextval('account.log_login_id_seq'::regclass) NOT NULL,
    ip character varying(50),
    uri character varying(500),
    create_time timestamp without time zone,
    host_name character varying(255),
    prefix character varying(200),
    app_code character varying(1000),
    language character varying(100),
    username character varying(1000),
    device_id character varying(2000),
    firebase_token character varying(2000),
    device_name character varying(2000),
    session_id character varying(2000),
    token character varying(2000),
    ag_user_id bigint,
    ag_user_system_id bigint,
    type bigint
);


ALTER TABLE account.log_login OWNER TO postgres;

--
-- Name: COLUMN log_login.type; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.log_login.type IS '1-Login, 2-Logout, 3-Login admin, 4-Logout admin';


--
-- Name: log_login_id_seq1; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.log_login_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.log_login_id_seq1 OWNER TO postgres;

--
-- Name: log_login_id_seq1; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.log_login_id_seq1 OWNED BY account.log_login.id;


--
-- Name: log_tracking_lock; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.log_tracking_lock (
    id bigint NOT NULL,
    action bigint,
    create_time timestamp without time zone,
    status bigint,
    target_tracking character varying(2000),
    type bigint,
    ws_code character varying(2000)
);


ALTER TABLE account.log_tracking_lock OWNER TO postgres;

--
-- Name: COLUMN log_tracking_lock.action; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.log_tracking_lock.action IS '1-Login,2-Register,3-Call api';


--
-- Name: COLUMN log_tracking_lock.status; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.log_tracking_lock.status IS '1-Success, 2-Fail';


--
-- Name: COLUMN log_tracking_lock.type; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.log_tracking_lock.type IS '1-user, 2-session, 3-ip';


--
-- Name: log_tracking_lock_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.log_tracking_lock_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.log_tracking_lock_id_seq OWNER TO postgres;

--
-- Name: log_tracking_lock_id_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.log_tracking_lock_id_seq OWNED BY account.log_tracking_lock.id;


--
-- Name: log_transaction; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.log_transaction (
    id bigint NOT NULL,
    session_id character varying(100),
    ip character varying(50),
    uri character varying(500),
    ws_code character varying(255),
    request text,
    response text,
    start_time timestamp(6) without time zone,
    end_time timestamp(6) without time zone,
    time_run bigint,
    error_code integer,
    error_message text,
    username character varying(255),
    language character varying(20),
    app_name character varying(100),
    version_app_name character varying(100),
    version_code integer,
    device_name character varying(255),
    device_os character varying(50),
    version_os character varying(30),
    imei character varying(255),
    host_name character varying(255),
    status integer
);


ALTER TABLE account.log_transaction OWNER TO postgres;

--
-- Name: COLUMN log_transaction.id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.log_transaction.id IS 'id của bảng';


--
-- Name: COLUMN log_transaction.session_id; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.log_transaction.session_id IS 'session';


--
-- Name: COLUMN log_transaction.ip; Type: COMMENT; Schema: account; Owner: postgres
--

COMMENT ON COLUMN account.log_transaction.ip IS 'ip của máy client';


--
-- Name: log_transaction_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.log_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.log_transaction_id_seq OWNER TO postgres;

--
-- Name: log_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.log_transaction_id_seq OWNED BY account.log_transaction.id;


--
-- Name: log_update_ag_user; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.log_update_ag_user (
    id bigint NOT NULL,
    "user" character varying,
    created_time timestamp with time zone,
    value_old text,
    value_new text,
    ag_user_id bigint
);


ALTER TABLE account.log_update_ag_user OWNER TO postgres;

--
-- Name: log_update_ag_user_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.log_update_ag_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.log_update_ag_user_id_seq OWNER TO postgres;

--
-- Name: log_update_ag_user_id_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.log_update_ag_user_id_seq OWNED BY account.log_update_ag_user.id;


--
-- Name: log_update_chanel; Type: TABLE; Schema: account; Owner: postgres
--

CREATE TABLE account.log_update_chanel (
    id bigint NOT NULL,
    "user" character varying,
    created_time timestamp with time zone,
    old_value text,
    new_value text,
    user_name character varying,
    ag_user_id bigint
);


ALTER TABLE account.log_update_chanel OWNER TO postgres;

--
-- Name: log_update_chanel_id_seq; Type: SEQUENCE; Schema: account; Owner: postgres
--

CREATE SEQUENCE account.log_update_chanel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account.log_update_chanel_id_seq OWNER TO postgres;

--
-- Name: log_update_chanel_id_seq; Type: SEQUENCE OWNED BY; Schema: account; Owner: postgres
--

ALTER SEQUENCE account.log_update_chanel_id_seq OWNED BY account.log_update_chanel.id;


--
-- Name: category; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.category (
    category_id bigint NOT NULL,
    category_name character varying(255),
    description character varying(255),
    estimate_time integer,
    code character varying(255)
);


ALTER TABLE complain.category OWNER TO postgres;

--
-- Name: COLUMN category.category_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.category.category_id IS 'Id loại khiếu nại';


--
-- Name: COLUMN category.category_name; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.category.category_name IS 'Tên loại khiếu nại';


--
-- Name: COLUMN category.description; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.category.description IS 'Mô tả';


--
-- Name: COLUMN category.estimate_time; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.category.estimate_time IS 'Thời gian ước tính';


--
-- Name: COLUMN category.code; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.category.code IS 'Mã đã ngôn ngữ';


--
-- Name: category_category_id_seq; Type: SEQUENCE; Schema: complain; Owner: postgres
--

CREATE SEQUENCE complain.category_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE complain.category_category_id_seq OWNER TO postgres;

--
-- Name: category_category_id_seq; Type: SEQUENCE OWNED BY; Schema: complain; Owner: postgres
--

ALTER SEQUENCE complain.category_category_id_seq OWNED BY complain.category.category_id;


--
-- Name: complain_his_detail; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.complain_his_detail (
    detail_id bigint NOT NULL,
    description text,
    his_id bigint
);


ALTER TABLE complain.complain_his_detail OWNER TO postgres;

--
-- Name: COLUMN complain_his_detail.detail_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_his_detail.detail_id IS 'id lịch sử khiếu nại chi tiết';


--
-- Name: COLUMN complain_his_detail.description; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_his_detail.description IS 'Mô tả ';


--
-- Name: COLUMN complain_his_detail.his_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_his_detail.his_id IS 'id lịch sử khiếu nại';


--
-- Name: complain_his_detail_detail_id_seq; Type: SEQUENCE; Schema: complain; Owner: postgres
--

CREATE SEQUENCE complain.complain_his_detail_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE complain.complain_his_detail_detail_id_seq OWNER TO postgres;

--
-- Name: complain_his_detail_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: complain; Owner: postgres
--

ALTER SEQUENCE complain.complain_his_detail_detail_id_seq OWNED BY complain.complain_his_detail.detail_id;


--
-- Name: complain_history; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.complain_history (
    his_id bigint NOT NULL,
    action character varying(255),
    create_date timestamp without time zone,
    description character varying(255),
    user_action character varying(255),
    complain_id bigint
);


ALTER TABLE complain.complain_history OWNER TO postgres;

--
-- Name: COLUMN complain_history.his_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_history.his_id IS 'id lịch sử khiếu nại';


--
-- Name: COLUMN complain_history.action; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_history.action IS 'Hành động';


--
-- Name: COLUMN complain_history.create_date; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_history.create_date IS 'Ngày tạo';


--
-- Name: COLUMN complain_history.description; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_history.description IS 'Mô tả';


--
-- Name: COLUMN complain_history.user_action; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_history.user_action IS 'Người tác động';


--
-- Name: COLUMN complain_history.complain_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_history.complain_id IS 'Id khiếu nại';


--
-- Name: complain_history_his_id_seq; Type: SEQUENCE; Schema: complain; Owner: postgres
--

CREATE SEQUENCE complain.complain_history_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE complain.complain_history_his_id_seq OWNER TO postgres;

--
-- Name: complain_history_his_id_seq; Type: SEQUENCE OWNED BY; Schema: complain; Owner: postgres
--

ALTER SEQUENCE complain.complain_history_his_id_seq OWNED BY complain.complain_history.his_id;


--
-- Name: complain_management; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.complain_management (
    complain_id bigint NOT NULL,
    content text,
    create_date timestamp(0) without time zone,
    department_handling bigint,
    phone character varying(255),
    rate integer NOT NULL,
    sender character varying(255),
    staff_hadling bigint,
    start_time timestamp without time zone,
    title character varying(255),
    category_id bigint,
    status_id bigint,
    comment_of_customer text,
    cust_id bigint,
    update_date timestamp without time zone,
    sources_id bigint,
    prioritize_id bigint
);


ALTER TABLE complain.complain_management OWNER TO postgres;

--
-- Name: COLUMN complain_management.complain_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.complain_id IS 'id khiếu nại';


--
-- Name: COLUMN complain_management.content; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.content IS 'Nội dung khiếu nại';


--
-- Name: COLUMN complain_management.create_date; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.create_date IS 'Ngày tạo';


--
-- Name: COLUMN complain_management.department_handling; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.department_handling IS 'Bộ phần tiếp nhận';


--
-- Name: COLUMN complain_management.phone; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.phone IS 'Số điện thoại';


--
-- Name: COLUMN complain_management.rate; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.rate IS 'Đánh giá';


--
-- Name: COLUMN complain_management.sender; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.sender IS 'Người gửi';


--
-- Name: COLUMN complain_management.staff_hadling; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.staff_hadling IS 'Nhân viên tiếp nhận';


--
-- Name: COLUMN complain_management.start_time; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.start_time IS 'Thời gian bắt đầu ';


--
-- Name: COLUMN complain_management.title; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.title IS 'Tiêu đề';


--
-- Name: COLUMN complain_management.category_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.category_id IS 'Loại khiếu nại';


--
-- Name: COLUMN complain_management.status_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.status_id IS 'Trạng thái khiếu nại';


--
-- Name: COLUMN complain_management.comment_of_customer; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.comment_of_customer IS 'Bình luận của khách hàng';


--
-- Name: COLUMN complain_management.cust_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.cust_id IS 'Mã khách hàng';


--
-- Name: COLUMN complain_management.update_date; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.update_date IS 'Ngày cập nhật';


--
-- Name: COLUMN complain_management.sources_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.sources_id IS 'Nguồn tiếp nhận';


--
-- Name: COLUMN complain_management.prioritize_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.complain_management.prioritize_id IS 'Mức độ ưu tiên';


--
-- Name: complain_management_complain_id_seq; Type: SEQUENCE; Schema: complain; Owner: postgres
--

CREATE SEQUENCE complain.complain_management_complain_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE complain.complain_management_complain_id_seq OWNER TO postgres;

--
-- Name: complain_management_complain_id_seq; Type: SEQUENCE OWNED BY; Schema: complain; Owner: postgres
--

ALTER SEQUENCE complain.complain_management_complain_id_seq OWNED BY complain.complain_management.complain_id;


--
-- Name: config_stringee; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.config_stringee (
    id character varying(255) NOT NULL,
    name character varying(255),
    value character varying(255),
    note character varying(255)
);


ALTER TABLE complain.config_stringee OWNER TO postgres;

--
-- Name: COLUMN config_stringee.id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.config_stringee.id IS 'Id của bảng';


--
-- Name: COLUMN config_stringee.name; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.config_stringee.name IS 'Tên trường';


--
-- Name: COLUMN config_stringee.value; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.config_stringee.value IS 'Giá trị của trường';


--
-- Name: COLUMN config_stringee.note; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.config_stringee.note IS 'Ghi chú';


--
-- Name: department_tmp; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.department_tmp (
    department_id bigint NOT NULL,
    department_name character varying(255) NOT NULL,
    description character varying(255)
);


ALTER TABLE complain.department_tmp OWNER TO postgres;

--
-- Name: COLUMN department_tmp.department_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.department_tmp.department_id IS 'id Bộ phân tiếp nhận';


--
-- Name: COLUMN department_tmp.department_name; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.department_tmp.department_name IS 'Tên bộ phận tiếp nhận';


--
-- Name: COLUMN department_tmp.description; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.department_tmp.description IS 'Mô tả';


--
-- Name: happy_call; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.happy_call (
    id bigint NOT NULL,
    name character varying(255),
    create_at timestamp(6) without time zone,
    update_at timestamp without time zone,
    creator character varying(255),
    content text,
    status bigint,
    create_by character varying(255)
);


ALTER TABLE complain.happy_call OWNER TO postgres;

--
-- Name: happy_call_id_seq; Type: SEQUENCE; Schema: complain; Owner: postgres
--

CREATE SEQUENCE complain.happy_call_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE complain.happy_call_id_seq OWNER TO postgres;

--
-- Name: happy_call_id_seq; Type: SEQUENCE OWNED BY; Schema: complain; Owner: postgres
--

ALTER SEQUENCE complain.happy_call_id_seq OWNED BY complain.happy_call.id;


--
-- Name: log_transaction; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.log_transaction (
    id bigint NOT NULL,
    session_id character varying(100),
    ip character varying(50),
    uri character varying(500),
    ws_code character varying(255),
    request text,
    response text,
    start_time timestamp(6) without time zone,
    end_time timestamp(6) without time zone,
    time_run bigint,
    error_code integer,
    error_message text,
    username character varying(255),
    language character varying(20),
    app_name character varying(100),
    version_app_name character varying(100),
    version_code integer,
    device_name character varying(255),
    device_os character varying(50),
    version_os character varying(30),
    imei character varying(255),
    host_name character varying(255),
    status integer
);


ALTER TABLE complain.log_transaction OWNER TO postgres;

--
-- Name: log_transaction_id_seq; Type: SEQUENCE; Schema: complain; Owner: postgres
--

CREATE SEQUENCE complain.log_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE complain.log_transaction_id_seq OWNER TO postgres;

--
-- Name: log_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: complain; Owner: postgres
--

ALTER SEQUENCE complain.log_transaction_id_seq OWNED BY complain.log_transaction.id;


--
-- Name: prioritize; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.prioritize (
    prioritize_id bigint NOT NULL,
    prioritize character varying(255)
);


ALTER TABLE complain.prioritize OWNER TO postgres;

--
-- Name: COLUMN prioritize.prioritize_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.prioritize.prioritize_id IS 'id mức độ ưu tiên';


--
-- Name: COLUMN prioritize.prioritize; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.prioritize.prioritize IS 'mức độ ưu tiên';


--
-- Name: response; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.response (
    response_id bigint NOT NULL,
    create_time timestamp(6) without time zone,
    customer_response text,
    staff_response text,
    complain_id bigint,
    action_name character varying(255),
    respondent character varying(255)
);


ALTER TABLE complain.response OWNER TO postgres;

--
-- Name: COLUMN response.response_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.response.response_id IS 'id ';


--
-- Name: COLUMN response.create_time; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.response.create_time IS 'Thời gian tạo';


--
-- Name: COLUMN response.customer_response; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.response.customer_response IS 'Phản hồi từ khách hàng';


--
-- Name: COLUMN response.staff_response; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.response.staff_response IS 'Phản hồi từ nhân viên';


--
-- Name: COLUMN response.complain_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.response.complain_id IS 'id khiếu nại';


--
-- Name: COLUMN response.action_name; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.response.action_name IS 'Tên hành động';


--
-- Name: COLUMN response.respondent; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.response.respondent IS 'Người trả lời';


--
-- Name: response_response_id_seq; Type: SEQUENCE; Schema: complain; Owner: postgres
--

CREATE SEQUENCE complain.response_response_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE complain.response_response_id_seq OWNER TO postgres;

--
-- Name: response_response_id_seq; Type: SEQUENCE OWNED BY; Schema: complain; Owner: postgres
--

ALTER SEQUENCE complain.response_response_id_seq OWNED BY complain.response.response_id;


--
-- Name: source; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.source (
    source_id bigint NOT NULL,
    source_name character varying(255)
);


ALTER TABLE complain.source OWNER TO postgres;

--
-- Name: COLUMN source.source_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.source.source_id IS 'id Nguồn tiếp nhận';


--
-- Name: COLUMN source.source_name; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.source.source_name IS 'Tên nguồn tiếp nhận';


--
-- Name: staff_tmp; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.staff_tmp (
    staff_id bigint NOT NULL,
    staff_name character varying(255) NOT NULL,
    department_id bigint NOT NULL,
    description character varying(255)
);


ALTER TABLE complain.staff_tmp OWNER TO postgres;

--
-- Name: COLUMN staff_tmp.staff_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.staff_tmp.staff_id IS 'id nhân viên';


--
-- Name: COLUMN staff_tmp.staff_name; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.staff_tmp.staff_name IS 'tên nhân viên';


--
-- Name: COLUMN staff_tmp.department_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.staff_tmp.department_id IS 'id bộ phận tiếp nhận';


--
-- Name: COLUMN staff_tmp.description; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.staff_tmp.description IS 'Mô tả';


--
-- Name: status; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.status (
    status_id bigint NOT NULL,
    description character varying(255),
    status_name character varying(255)
);


ALTER TABLE complain.status OWNER TO postgres;

--
-- Name: COLUMN status.status_id; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.status.status_id IS 'id Trạng thái';


--
-- Name: COLUMN status.description; Type: COMMENT; Schema: complain; Owner: postgres
--

COMMENT ON COLUMN complain.status.description IS 'Tên trạng thái';


--
-- Name: status_happy_call; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.status_happy_call (
    id bigint NOT NULL,
    name character varying(255)
);


ALTER TABLE complain.status_happy_call OWNER TO postgres;

--
-- Name: status_status_id_seq; Type: SEQUENCE; Schema: complain; Owner: postgres
--

CREATE SEQUENCE complain.status_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE complain.status_status_id_seq OWNER TO postgres;

--
-- Name: status_status_id_seq; Type: SEQUENCE OWNED BY; Schema: complain; Owner: postgres
--

ALTER SEQUENCE complain.status_status_id_seq OWNED BY complain.status.status_id;


--
-- Name: stringee_call; Type: TABLE; Schema: complain; Owner: postgres
--

CREATE TABLE complain.stringee_call (
    id integer NOT NULL,
    call_id character varying NOT NULL,
    agent character varying,
    customer character varying,
    start_time bigint,
    end_time bigint,
    url character varying,
    type integer NOT NULL,
    status integer NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL
);


ALTER TABLE complain.stringee_call OWNER TO postgres;

--
-- Name: stringee_call_id_seq; Type: SEQUENCE; Schema: complain; Owner: postgres
--

CREATE SEQUENCE complain.stringee_call_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE complain.stringee_call_id_seq OWNER TO postgres;

--
-- Name: stringee_call_id_seq1; Type: SEQUENCE; Schema: complain; Owner: postgres
--

CREATE SEQUENCE complain.stringee_call_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE complain.stringee_call_id_seq1 OWNER TO postgres;

--
-- Name: stringee_call_id_seq1; Type: SEQUENCE OWNED BY; Schema: complain; Owner: postgres
--

ALTER SEQUENCE complain.stringee_call_id_seq1 OWNED BY complain.stringee_call.id;


--
-- Name: account_type; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.account_type (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    status integer DEFAULT 1,
    cust_id bigint
);


ALTER TABLE customer.account_type OWNER TO postgres;

--
-- Name: account_type_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.account_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.account_type_id_seq OWNER TO postgres;

--
-- Name: account_type_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.account_type_id_seq OWNED BY customer.account_type.id;


--
-- Name: action; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.action (
    id integer NOT NULL,
    description character varying(255),
    name character varying(255)
);


ALTER TABLE customer.action OWNER TO postgres;

--
-- Name: COLUMN action.id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.action.id IS 'id của bảng';


--
-- Name: COLUMN action.description; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.action.description IS 'mô tả';


--
-- Name: COLUMN action.name; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.action.name IS 'tên';


--
-- Name: action_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.action_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.action_id_seq OWNER TO postgres;

--
-- Name: action_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.action_id_seq OWNED BY customer.action.id;


--
-- Name: call_log; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.call_log (
    id bigint NOT NULL,
    code character varying(255),
    function character varying(255),
    ws_code character varying(255),
    url character varying(255),
    req text,
    res text,
    "time" character varying
);


ALTER TABLE customer.call_log OWNER TO postgres;

--
-- Name: call_log_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.call_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.call_log_id_seq OWNER TO postgres;

--
-- Name: call_log_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.call_log_id_seq OWNED BY customer.call_log.id;


--
-- Name: charge_package_extend; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.charge_package_extend (
    id bigint NOT NULL,
    cycle integer,
    package_price bigint,
    isdn character varying(100),
    package_name character varying(150),
    excute_date timestamp with time zone,
    status character varying DEFAULT 1
);


ALTER TABLE customer.charge_package_extend OWNER TO postgres;

--
-- Name: charge_package_extend_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.charge_package_extend_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.charge_package_extend_id_seq OWNER TO postgres;

--
-- Name: charge_package_extend_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.charge_package_extend_id_seq OWNED BY customer.charge_package_extend.id;


--
-- Name: cmp_service_log; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.cmp_service_log (
    id bigint NOT NULL,
    request_uri text,
    request_method text,
    request text,
    response text,
    created_at timestamp(6) without time zone
);


ALTER TABLE customer.cmp_service_log OWNER TO postgres;

--
-- Name: COLUMN cmp_service_log.id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.cmp_service_log.id IS 'id của bảng';


--
-- Name: COLUMN cmp_service_log.request_uri; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.cmp_service_log.request_uri IS 'url request';


--
-- Name: COLUMN cmp_service_log.request_method; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.cmp_service_log.request_method IS 'method';


--
-- Name: COLUMN cmp_service_log.request; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.cmp_service_log.request IS 'request gửi lên';


--
-- Name: COLUMN cmp_service_log.response; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.cmp_service_log.response IS 'response trả về';


--
-- Name: COLUMN cmp_service_log.created_at; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.cmp_service_log.created_at IS 'ngày tạo';


--
-- Name: cmp_service_log_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.cmp_service_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.cmp_service_log_id_seq OWNER TO postgres;

--
-- Name: cmp_service_log_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.cmp_service_log_id_seq OWNED BY customer.cmp_service_log.id;


--
-- Name: cuong_temp; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.cuong_temp (
    account_id bigint,
    address character varying(255),
    city bigint,
    country bigint,
    cust_code character varying(255),
    cust_name character varying(255),
    district bigint,
    gender smallint,
    language character varying(255),
    phone character varying(255),
    receive_notifi_ads character varying(255),
    village character varying(255),
    parent_id bigint,
    status_id integer,
    cust_type integer,
    cust_id bigint,
    avatar character varying(500),
    email character varying(255),
    date_of_birth timestamp(6) without time zone,
    tax_code character varying(255),
    path character varying(255),
    identify_number character varying(255),
    identify_type character varying(255),
    create_date timestamp(0) without time zone,
    isdn_registed character varying(255),
    subscriber character varying(255),
    description character varying(255),
    number_employee integer,
    trust_text_percent integer,
    trust_image_percent integer,
    group_id character varying(50),
    kyc_job integer,
    avatar_reddi character varying(500)
);


ALTER TABLE customer.cuong_temp OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer (
    account_id bigint,
    address character varying(255),
    city bigint,
    country bigint,
    cust_code character varying(255) NOT NULL,
    cust_name character varying(255),
    district bigint,
    gender smallint,
    language character varying(255),
    phone character varying(255),
    receive_notifi_ads character varying(255),
    village character varying(255),
    parent_id bigint,
    status_id integer NOT NULL,
    cust_type integer,
    cust_id bigint NOT NULL,
    avatar character varying(500),
    email character varying(255),
    date_of_birth timestamp(6) without time zone,
    tax_code character varying(255),
    path character varying(255),
    identify_number character varying(255),
    identify_type character varying(255),
    create_date timestamp(0) without time zone,
    isdn_registed character varying(255),
    subscriber text,
    description text,
    number_employee integer,
    trust_text_percent integer,
    trust_image_percent integer,
    group_id character varying(50),
    kyc_job integer DEFAULT 0 NOT NULL,
    avatar_reddi character varying(500),
    is_trust boolean DEFAULT false NOT NULL,
    is_send_to_vcm integer,
    update_at timestamp without time zone,
    is_masan_customer boolean DEFAULT false
);


ALTER TABLE customer.customer OWNER TO postgres;

--
-- Name: COLUMN customer.account_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.account_id IS 'id của bảng tài khoản';


--
-- Name: COLUMN customer.address; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.address IS 'địa chỉ';


--
-- Name: COLUMN customer.city; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.city IS 'tỉnh';


--
-- Name: COLUMN customer.country; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.country IS 'quốc gia';


--
-- Name: COLUMN customer.cust_code; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.cust_code IS 'mã khách hàng';


--
-- Name: COLUMN customer.cust_name; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.cust_name IS 'tên khách hàng';


--
-- Name: COLUMN customer.district; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.district IS 'quận';


--
-- Name: COLUMN customer.gender; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.gender IS '0 - Male / 1 - Female';


--
-- Name: COLUMN customer.language; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.language IS 'ngôn ngữ';


--
-- Name: COLUMN customer.phone; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.phone IS 'điện thoại liện hệ';


--
-- Name: COLUMN customer.receive_notifi_ads; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.receive_notifi_ads IS 'nhận tin nhắn quoảng cáo';


--
-- Name: COLUMN customer.village; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.village IS 'xã';


--
-- Name: COLUMN customer.parent_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.parent_id IS 'khách hàng cha (với trường hợp là kh doanh nghiệp)';


--
-- Name: COLUMN customer.status_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.status_id IS 'trạng thái';


--
-- Name: COLUMN customer.cust_type; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.cust_type IS 'loại khách hàng';


--
-- Name: COLUMN customer.cust_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.cust_id IS 'id khách hàng';


--
-- Name: COLUMN customer.avatar; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.avatar IS 'ảnh đại diện';


--
-- Name: COLUMN customer.email; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.email IS 'email';


--
-- Name: COLUMN customer.date_of_birth; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.date_of_birth IS 'ngày sinh nhật';


--
-- Name: COLUMN customer.tax_code; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.tax_code IS 'mã số thuế';


--
-- Name: COLUMN customer.path; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.path IS 'cây thư cha con của khách hàng doanh nghiệp';


--
-- Name: COLUMN customer.identify_number; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.identify_number IS 'mã số định danh cá nhân';


--
-- Name: COLUMN customer.identify_type; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.identify_type IS 'loại mã định danh';


--
-- Name: COLUMN customer.create_date; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.create_date IS 'ngày tạo';


--
-- Name: COLUMN customer.isdn_registed; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.isdn_registed IS 'số thuê bao đã đăng ký (admin)';


--
-- Name: COLUMN customer.subscriber; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.subscriber IS 'tất cả thuê bao đã đăng ký';


--
-- Name: COLUMN customer.description; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.description IS 'Mô tả thông tin khách hàng';


--
-- Name: COLUMN customer.number_employee; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.number_employee IS 'Số lượng nhân viên';


--
-- Name: COLUMN customer.trust_text_percent; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.trust_text_percent IS '% ddooj tin caayj khi detech';


--
-- Name: COLUMN customer.trust_image_percent; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.trust_image_percent IS '% do tin cay';


--
-- Name: COLUMN customer.kyc_job; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.kyc_job IS 'Đánh dấu khách hàng được kyc theo lô //1 - kyc theo lô';


--
-- Name: COLUMN customer.avatar_reddi; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.avatar_reddi IS 'Avatar hiển thị trên app';


--
-- Name: COLUMN customer.is_trust; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.is_trust IS 'Đã được phê duyệt hay chưa';


--
-- Name: COLUMN customer.is_masan_customer; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer.is_masan_customer IS 'true: là khách hàng mua từ masan, false: khách reddi bình thường';


--
-- Name: customer_account; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer_account (
    account_id bigint NOT NULL,
    cust_id bigint NOT NULL,
    created_at character varying(255),
    role_id integer,
    status integer DEFAULT 1,
    create_date character varying(255),
    status_id integer,
    id bigint,
    isdn character varying(255),
    group_id character varying(255)
);


ALTER TABLE customer.customer_account OWNER TO postgres;

--
-- Name: COLUMN customer_account.account_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_account.account_id IS 'id tài khoản';


--
-- Name: COLUMN customer_account.cust_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_account.cust_id IS 'id khách hàng';


--
-- Name: COLUMN customer_account.created_at; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_account.created_at IS 'thời gian tạo';


--
-- Name: COLUMN customer_account.role_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_account.role_id IS 'id luật';


--
-- Name: COLUMN customer_account.status; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_account.status IS 'trạng thái';


--
-- Name: COLUMN customer_account.create_date; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_account.create_date IS 'ngày  tạo';


--
-- Name: COLUMN customer_account.status_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_account.status_id IS 'trạng thái';


--
-- Name: COLUMN customer_account.id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_account.id IS 'id của bảng ';


--
-- Name: COLUMN customer_account.isdn; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_account.isdn IS 'Số điện thoại đại diện OCS';


--
-- Name: COLUMN customer_account.group_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_account.group_id IS 'Group Id OCS cấp';


--
-- Name: customer_cust_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.customer_cust_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.customer_cust_id_seq OWNER TO postgres;

--
-- Name: customer_cust_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.customer_cust_id_seq OWNED BY customer.customer.cust_id;


--
-- Name: customer_bk1009; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer_bk1009 (
    account_id bigint,
    address character varying(255),
    city bigint,
    country bigint,
    cust_code character varying(255) NOT NULL,
    cust_name character varying(255),
    district bigint,
    gender smallint,
    language character varying(255),
    phone character varying(255),
    receive_notifi_ads character varying(255),
    village character varying(255),
    parent_id bigint,
    status_id integer NOT NULL,
    cust_type integer,
    cust_id bigint DEFAULT nextval('customer.customer_cust_id_seq'::regclass) NOT NULL,
    avatar character varying(500),
    email character varying(255),
    date_of_birth timestamp(6) without time zone,
    tax_code character varying(255),
    path character varying(255),
    identify_number character varying(255),
    identify_type character varying(255),
    create_date timestamp(0) without time zone,
    isdn_registed character varying(255),
    subscriber character varying(255),
    description character varying(255),
    number_employee integer,
    trust_text_percent integer,
    trust_image_percent integer,
    group_id character varying(50),
    kyc_job integer DEFAULT 0 NOT NULL,
    avatar_reddi character varying(500),
    is_trust boolean DEFAULT false NOT NULL
);


ALTER TABLE customer.customer_bk1009 OWNER TO postgres;

--
-- Name: COLUMN customer_bk1009.account_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.account_id IS 'id của bảng tài khoản';


--
-- Name: COLUMN customer_bk1009.address; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.address IS 'địa chỉ';


--
-- Name: COLUMN customer_bk1009.city; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.city IS 'tỉnh';


--
-- Name: COLUMN customer_bk1009.country; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.country IS 'quốc gia';


--
-- Name: COLUMN customer_bk1009.cust_code; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.cust_code IS 'mã khách hàng';


--
-- Name: COLUMN customer_bk1009.cust_name; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.cust_name IS 'tên khách hàng';


--
-- Name: COLUMN customer_bk1009.district; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.district IS 'quận';


--
-- Name: COLUMN customer_bk1009.gender; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.gender IS '0 - Male / 1 - Female';


--
-- Name: COLUMN customer_bk1009.language; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.language IS 'ngôn ngữ';


--
-- Name: COLUMN customer_bk1009.phone; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.phone IS 'điện thoại liện hệ';


--
-- Name: COLUMN customer_bk1009.receive_notifi_ads; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.receive_notifi_ads IS 'nhận tin nhắn quoảng cáo';


--
-- Name: COLUMN customer_bk1009.village; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.village IS 'xã';


--
-- Name: COLUMN customer_bk1009.parent_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.parent_id IS 'khách hàng cha (với trường hợp là kh doanh nghiệp)';


--
-- Name: COLUMN customer_bk1009.status_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.status_id IS 'trạng thái';


--
-- Name: COLUMN customer_bk1009.cust_type; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.cust_type IS 'loại khách hàng';


--
-- Name: COLUMN customer_bk1009.cust_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.cust_id IS 'id khách hàng';


--
-- Name: COLUMN customer_bk1009.avatar; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.avatar IS 'ảnh đại diện';


--
-- Name: COLUMN customer_bk1009.email; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.email IS 'email';


--
-- Name: COLUMN customer_bk1009.date_of_birth; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.date_of_birth IS 'ngày sinh nhật';


--
-- Name: COLUMN customer_bk1009.tax_code; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.tax_code IS 'mã số thuế';


--
-- Name: COLUMN customer_bk1009.path; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.path IS 'cây thư cha con của khách hàng doanh nghiệp';


--
-- Name: COLUMN customer_bk1009.identify_number; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.identify_number IS 'mã số định danh cá nhân';


--
-- Name: COLUMN customer_bk1009.identify_type; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.identify_type IS 'loại mã định danh';


--
-- Name: COLUMN customer_bk1009.create_date; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.create_date IS 'ngày tạo';


--
-- Name: COLUMN customer_bk1009.isdn_registed; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.isdn_registed IS 'số thuê bao đã đăng ký (admin)';


--
-- Name: COLUMN customer_bk1009.subscriber; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.subscriber IS 'tất cả thuê bao đã đăng ký';


--
-- Name: COLUMN customer_bk1009.description; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.description IS 'Mô tả thông tin khách hàng';


--
-- Name: COLUMN customer_bk1009.number_employee; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.number_employee IS 'Số lượng nhân viên';


--
-- Name: COLUMN customer_bk1009.trust_text_percent; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.trust_text_percent IS '% ddooj tin caayj khi detech';


--
-- Name: COLUMN customer_bk1009.trust_image_percent; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.trust_image_percent IS '% do tin cay';


--
-- Name: COLUMN customer_bk1009.kyc_job; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.kyc_job IS 'Đánh dấu khách hàng được kyc theo lô //1 - kyc theo lô';


--
-- Name: COLUMN customer_bk1009.avatar_reddi; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.avatar_reddi IS 'Avatar hiển thị trên app';


--
-- Name: COLUMN customer_bk1009.is_trust; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_bk1009.is_trust IS 'Đã được phê duyệt hay chưa';


--
-- Name: customer_config; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer_config (
    config_id integer NOT NULL,
    limit_enter_opt integer NOT NULL,
    limit_phone_number integer NOT NULL,
    limit_account_personal integer NOT NULL,
    limit_account_enterprise integer NOT NULL,
    limit_cap_document integer,
    limit_cap_face integer
);


ALTER TABLE customer.customer_config OWNER TO postgres;

--
-- Name: COLUMN customer_config.config_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_config.config_id IS 'id của bảng';


--
-- Name: COLUMN customer_config.limit_enter_opt; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_config.limit_enter_opt IS 'số lần nhập sai mã otp tối đa';


--
-- Name: COLUMN customer_config.limit_phone_number; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_config.limit_phone_number IS 'số lượng số điện thoại có tối đa';


--
-- Name: COLUMN customer_config.limit_account_personal; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_config.limit_account_personal IS 'Số lượng thuê bao tối đa cá nhân có thể có';


--
-- Name: COLUMN customer_config.limit_account_enterprise; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_config.limit_account_enterprise IS 'Số lượng thuê bao tối đa doanh nghiệp có thể có';


--
-- Name: customer_document; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer_document (
    description character varying(400),
    value character varying(400),
    cust_id bigint NOT NULL,
    status_id integer,
    doc_type_id integer NOT NULL,
    identify_number character varying(255),
    cust_doc_id bigint NOT NULL,
    date_of_issued character varying(255),
    expiration_date character varying(255),
    issued_by character varying(255),
    img_type integer
);


ALTER TABLE customer.customer_document OWNER TO postgres;

--
-- Name: COLUMN customer_document.description; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_document.description IS 'mô tả';


--
-- Name: COLUMN customer_document.value; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_document.value IS 'giá trị';


--
-- Name: COLUMN customer_document.cust_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_document.cust_id IS 'id khách hàng';


--
-- Name: COLUMN customer_document.status_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_document.status_id IS 'trạng thái';


--
-- Name: COLUMN customer_document.doc_type_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_document.doc_type_id IS 'loại tài liệu';


--
-- Name: COLUMN customer_document.identify_number; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_document.identify_number IS 'số định danh ';


--
-- Name: COLUMN customer_document.cust_doc_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_document.cust_doc_id IS 'id tài liệu của khách';


--
-- Name: COLUMN customer_document.date_of_issued; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_document.date_of_issued IS 'ngày cấp';


--
-- Name: COLUMN customer_document.expiration_date; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_document.expiration_date IS 'ngày hết hạn';


--
-- Name: COLUMN customer_document.issued_by; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_document.issued_by IS 'nơi cấp';


--
-- Name: COLUMN customer_document.img_type; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_document.img_type IS '0 - mặt trước / 1 - mặt sau / 2 - chỉ có một mặt';


--
-- Name: customer_document_cust_doc_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.customer_document_cust_doc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.customer_document_cust_doc_id_seq OWNER TO postgres;

--
-- Name: customer_document_cust_doc_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.customer_document_cust_doc_id_seq OWNED BY customer.customer_document.cust_doc_id;


--
-- Name: customer_econtract_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.customer_econtract_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.customer_econtract_id_seq OWNER TO postgres;

--
-- Name: customer_econtract; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer_econtract (
    id bigint DEFAULT nextval('customer.customer_econtract_id_seq'::regclass) NOT NULL,
    cust_id bigint NOT NULL,
    isdn character varying(255) NOT NULL,
    e_contract_link character varying(500) NOT NULL,
    signature_link character varying(500) NOT NULL,
    "createAt" timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updateAt" timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    econtract_code character varying(255),
    status smallint
);


ALTER TABLE customer.customer_econtract OWNER TO postgres;

--
-- Name: customer_history; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer_history (
    action character varying(200),
    create_date timestamp(6) without time zone,
    description text,
    cust_id bigint NOT NULL,
    reason_name character varying(255),
    reason_description character varying(1000),
    cust_his_id bigint NOT NULL,
    note character varying(255),
    table_change character varying(255),
    account_id bigint,
    user_name character varying(255),
    description_object jsonb
);


ALTER TABLE customer.customer_history OWNER TO postgres;

--
-- Name: customer_history_cust_his_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.customer_history_cust_his_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.customer_history_cust_his_id_seq OWNER TO postgres;

--
-- Name: customer_history_cust_his_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.customer_history_cust_his_id_seq OWNED BY customer.customer_history.cust_his_id;


--
-- Name: customer_history_detail; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer_history_detail (
    description text,
    cust_his_id bigint NOT NULL,
    id bigint NOT NULL,
    field_name character varying(255),
    before_value character varying(255),
    after_value character varying(255),
    table_change character varying(255)
);


ALTER TABLE customer.customer_history_detail OWNER TO postgres;

--
-- Name: customer_history_detail_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.customer_history_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.customer_history_detail_id_seq OWNER TO postgres;

--
-- Name: customer_history_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.customer_history_detail_id_seq OWNED BY customer.customer_history_detail.id;


--
-- Name: customer_kyc_confidence; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer_kyc_confidence (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    cust_id bigint,
    dateofbirth character varying(255),
    dateofexpire character varying(255),
    dateofissue character varying(255),
    district character varying(255),
    gender character varying(255),
    hometown character varying(255),
    idnumber character varying(255),
    name character varying(255),
    nationality character varying(255),
    permanentaddress character varying(255),
    placeofissue character varying(255),
    province character varying(255),
    status integer,
    updated_at timestamp without time zone
);


ALTER TABLE customer.customer_kyc_confidence OWNER TO postgres;

--
-- Name: customer_kyc_confidence_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.customer_kyc_confidence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.customer_kyc_confidence_id_seq OWNER TO postgres;

--
-- Name: customer_kyc_confidence_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.customer_kyc_confidence_id_seq OWNED BY customer.customer_kyc_confidence.id;


--
-- Name: customer_param; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer_param (
    id bigint NOT NULL,
    name character varying(255),
    code character varying(255),
    value character varying(255),
    status bigint
);


ALTER TABLE customer.customer_param OWNER TO postgres;

--
-- Name: customer_param_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.customer_param_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.customer_param_id_seq OWNER TO postgres;

--
-- Name: customer_param_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.customer_param_id_seq OWNED BY customer.customer_param.id;


--
-- Name: customer_status; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer_status (
    status_id integer NOT NULL,
    description character varying(400),
    genaral character varying(255),
    name character varying(400)
);


ALTER TABLE customer.customer_status OWNER TO postgres;

--
-- Name: COLUMN customer_status.status_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_status.status_id IS 'id của bảng';


--
-- Name: COLUMN customer_status.description; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_status.description IS 'mô tả';


--
-- Name: COLUMN customer_status.genaral; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_status.genaral IS 'các bảng dung chung';


--
-- Name: COLUMN customer_status.name; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_status.name IS 'tên';


--
-- Name: customer_type; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customer_type (
    cust_type_id integer NOT NULL,
    description character varying(255),
    name character varying(255)
);


ALTER TABLE customer.customer_type OWNER TO postgres;

--
-- Name: COLUMN customer_type.cust_type_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_type.cust_type_id IS 'id của bảng';


--
-- Name: COLUMN customer_type.description; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_type.description IS 'mô tả';


--
-- Name: COLUMN customer_type.name; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.customer_type.name IS 'tên';


--
-- Name: customer_type_cust_type_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.customer_type_cust_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.customer_type_cust_type_id_seq OWNER TO postgres;

--
-- Name: customer_type_cust_type_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.customer_type_cust_type_id_seq OWNED BY customer.customer_type.cust_type_id;


--
-- Name: distribution_resource; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.distribution_resource (
    id bigint NOT NULL,
    resource_id bigint NOT NULL,
    cust_id bigint NOT NULL,
    unit character varying(100) NOT NULL,
    rank character varying(100) NOT NULL,
    account_type_id bigint,
    created_by bigint NOT NULL,
    status integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    msisdn character varying(11)
);


ALTER TABLE customer.distribution_resource OWNER TO postgres;

--
-- Name: distribution_resource_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.distribution_resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.distribution_resource_id_seq OWNER TO postgres;

--
-- Name: distribution_resource_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.distribution_resource_id_seq OWNED BY customer.distribution_resource.id;


--
-- Name: document_type; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.document_type (
    doc_type_id integer NOT NULL,
    description character varying(400),
    name character varying(400),
    cust_type integer
);


ALTER TABLE customer.document_type OWNER TO postgres;

--
-- Name: COLUMN document_type.doc_type_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.document_type.doc_type_id IS 'id của bảng';


--
-- Name: COLUMN document_type.description; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.document_type.description IS 'mô tả tài liệu';


--
-- Name: COLUMN document_type.name; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.document_type.name IS 'tên tài liệu';


--
-- Name: COLUMN document_type.cust_type; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.document_type.cust_type IS '1 - Cá nhân // 2 - Doanh nghiệp // 3 - Cá nhân & Doanh nghiệp';


--
-- Name: kyc_job; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.kyc_job (
    id bigint NOT NULL,
    file_path character varying(255),
    is_read boolean,
    status integer,
    create_date timestamp(6) without time zone,
    create_by character varying(255),
    read_date timestamp(6) without time zone,
    note character varying(255),
    title character varying(255)
);


ALTER TABLE customer.kyc_job OWNER TO postgres;

--
-- Name: kyc_job_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.kyc_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.kyc_job_id_seq OWNER TO postgres;

--
-- Name: kyc_job_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.kyc_job_id_seq OWNED BY customer.kyc_job.id;


--
-- Name: kyc_job_log; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.kyc_job_log (
    id bigint NOT NULL,
    job_id bigint,
    create_date timestamp(6) without time zone,
    file_success character varying(255),
    file_fail character varying(255),
    status bigint,
    reason_fail text
);


ALTER TABLE customer.kyc_job_log OWNER TO postgres;

--
-- Name: kyc_job_log_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.kyc_job_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.kyc_job_log_id_seq OWNER TO postgres;

--
-- Name: kyc_job_log_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.kyc_job_log_id_seq OWNED BY customer.kyc_job_log.id;


--
-- Name: log_transaction; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.log_transaction (
    id bigint NOT NULL,
    session_id character varying(100),
    ip character varying(50),
    uri character varying(500),
    ws_code character varying(255),
    request text,
    response text,
    start_time timestamp(6) without time zone,
    end_time timestamp(6) without time zone,
    time_run bigint,
    error_code integer,
    error_message text,
    username character varying(255),
    language character varying(20),
    app_name character varying(100),
    version_app_name character varying(100),
    version_code integer,
    device_name character varying(255),
    device_os character varying(50),
    version_os character varying(30),
    imei character varying(255),
    host_name character varying(255),
    status integer
);


ALTER TABLE customer.log_transaction OWNER TO postgres;

--
-- Name: log_transaction_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.log_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.log_transaction_id_seq OWNER TO postgres;

--
-- Name: log_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.log_transaction_id_seq OWNED BY customer.log_transaction.id;


--
-- Name: resources; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.resources (
    id bigint NOT NULL,
    call_on_net bigint,
    call_off_net bigint,
    sms_on_net bigint,
    sms_off_net bigint,
    quota double precision,
    hour_in_day character varying(100),
    day_in_week character varying(100),
    day_in_month character varying(100),
    status integer DEFAULT 0,
    created_at timestamp(0) without time zone,
    resource_name character varying(100),
    updated_at timestamp(0) without time zone,
    cust_id bigint,
    month_in_year character varying(64)
);


ALTER TABLE customer.resources OWNER TO postgres;

--
-- Name: manage_resource_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.manage_resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.manage_resource_id_seq OWNER TO postgres;

--
-- Name: manage_resource_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.manage_resource_id_seq OWNED BY customer.resources.id;


--
-- Name: package_vcm_send; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.package_vcm_send (
    id bigint NOT NULL,
    cust_id bigint NOT NULL,
    subcriber character varying(200),
    excute_time timestamp(6) without time zone,
    request text,
    response text,
    status smallint DEFAULT 0,
    package_id character varying,
    source character varying(100)
);


ALTER TABLE customer.package_vcm_send OWNER TO postgres;

--
-- Name: COLUMN package_vcm_send.status; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.package_vcm_send.status IS '0: thất bại, 1: thành công';


--
-- Name: package_vcm_send_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.package_vcm_send_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.package_vcm_send_id_seq OWNER TO postgres;

--
-- Name: package_vcm_send_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.package_vcm_send_id_seq OWNED BY customer.package_vcm_send.id;


--
-- Name: permission; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.permission (
    id integer NOT NULL,
    description character varying(255),
    name character varying(255),
    slug character varying(255),
    created_at character varying(255),
    creator character varying(255),
    status integer DEFAULT 1
);


ALTER TABLE customer.permission OWNER TO postgres;

--
-- Name: COLUMN permission.id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.permission.id IS 'id của bảng';


--
-- Name: COLUMN permission.description; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.permission.description IS 'mô tả';


--
-- Name: COLUMN permission.name; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.permission.name IS 'tên ';


--
-- Name: COLUMN permission.slug; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.permission.slug IS 'tên quyền bỏ dấu';


--
-- Name: COLUMN permission.created_at; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.permission.created_at IS 'ngày tạo';


--
-- Name: COLUMN permission.creator; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.permission.creator IS 'người tạo';


--
-- Name: COLUMN permission.status; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.permission.status IS 'trạng thái';


--
-- Name: permission_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.permission_id_seq OWNER TO postgres;

--
-- Name: permission_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.permission_id_seq OWNED BY customer.permission.id;


--
-- Name: role_account_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.role_account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.role_account_id_seq OWNER TO postgres;

--
-- Name: role_account; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.role_account (
    role_id integer DEFAULT nextval('customer.role_account_id_seq'::regclass) NOT NULL,
    role_name character varying(255) NOT NULL,
    description character varying(1000),
    created_at character varying(255),
    creator character varying(255),
    status integer DEFAULT 1
);


ALTER TABLE customer.role_account OWNER TO postgres;

--
-- Name: COLUMN role_account.role_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_account.role_id IS 'Id bản ghi
';


--
-- Name: COLUMN role_account.role_name; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_account.role_name IS 'tên quyền';


--
-- Name: COLUMN role_account.description; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_account.description IS 'mô tả';


--
-- Name: COLUMN role_account.created_at; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_account.created_at IS 'ngày tạo';


--
-- Name: COLUMN role_account.creator; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_account.creator IS 'người tạo';


--
-- Name: COLUMN role_account.status; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_account.status IS 'trạng thái';


--
-- Name: role_permission; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.role_permission (
    action_id integer NOT NULL,
    permission_id integer NOT NULL,
    role_id integer NOT NULL,
    created_at character varying(255),
    creator character varying(255)
);


ALTER TABLE customer.role_permission OWNER TO postgres;

--
-- Name: COLUMN role_permission.action_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_permission.action_id IS 'Mã hành động';


--
-- Name: COLUMN role_permission.permission_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_permission.permission_id IS 'Mã quyền';


--
-- Name: COLUMN role_permission.role_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_permission.role_id IS 'Mã phân quyền';


--
-- Name: COLUMN role_permission.created_at; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_permission.created_at IS 'Ngày tạo';


--
-- Name: COLUMN role_permission.creator; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_permission.creator IS 'Người tạo';


--
-- Name: role_resource; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.role_resource (
    cust_id bigint NOT NULL,
    role_id integer NOT NULL,
    call_in bigint,
    call_out bigint,
    created_at character varying(255),
    creator character varying(255),
    data bigint,
    end_day integer,
    end_time integer,
    sms_in bigint,
    sms_out bigint,
    start_day integer,
    start_time integer
);


ALTER TABLE customer.role_resource OWNER TO postgres;

--
-- Name: COLUMN role_resource.cust_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_resource.cust_id IS 'Mã khách hàng';


--
-- Name: COLUMN role_resource.role_id; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_resource.role_id IS 'Mã vai trò';


--
-- Name: COLUMN role_resource.call_in; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_resource.call_in IS 'Lượt gọi vào';


--
-- Name: COLUMN role_resource.call_out; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_resource.call_out IS 'lượt gọi đi';


--
-- Name: COLUMN role_resource.created_at; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_resource.created_at IS 'ngày tạo';


--
-- Name: COLUMN role_resource.creator; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_resource.creator IS 'người tạo';


--
-- Name: COLUMN role_resource.data; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_resource.data IS 'dung lượng';


--
-- Name: COLUMN role_resource.sms_in; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_resource.sms_in IS 'tin nhắn tới';


--
-- Name: COLUMN role_resource.sms_out; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.role_resource.sms_out IS 'tin nhắn đi';


--
-- Name: status_account_customer; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.status_account_customer (
    status_id integer NOT NULL,
    description character varying(255),
    name character varying(255)
);


ALTER TABLE customer.status_account_customer OWNER TO postgres;

--
-- Name: transaction_vcm_point; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.transaction_vcm_point (
    id bigint NOT NULL,
    cust_id bigint,
    invoice_no character varying NOT NULL,
    amount bigint,
    id_type character varying,
    phone character varying,
    excute_time timestamp without time zone,
    transaction_status integer DEFAULT 0,
    request text,
    response text,
    source character varying,
    transaction_type integer DEFAULT 1,
    red_point integer
);


ALTER TABLE customer.transaction_vcm_point OWNER TO postgres;

--
-- Name: COLUMN transaction_vcm_point.transaction_type; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.transaction_vcm_point.transaction_type IS '0: Redeem, 1: Awd';


--
-- Name: transaction_vcm_point_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

CREATE SEQUENCE customer.transaction_vcm_point_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer.transaction_vcm_point_id_seq OWNER TO postgres;

--
-- Name: transaction_vcm_point_id_seq; Type: SEQUENCE OWNED BY; Schema: customer; Owner: postgres
--

ALTER SEQUENCE customer.transaction_vcm_point_id_seq OWNED BY customer.transaction_vcm_point.id;


--
-- Name: transfer_money_config; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.transfer_money_config (
    id bigint NOT NULL,
    active_date integer,
    minimum_money bigint,
    maximum_money bigint,
    cost_transfer bigint,
    tran_per_day integer,
    cost_unit character varying(255)
);


ALTER TABLE customer.transfer_money_config OWNER TO postgres;

--
-- Name: COLUMN transfer_money_config.cost_unit; Type: COMMENT; Schema: customer; Owner: postgres
--

COMMENT ON COLUMN customer.transfer_money_config.cost_unit IS 'PERCENT or VND';


--
-- Name: exp_table; Type: TABLE; Schema: gamification; Owner: postgres
--

CREATE TABLE gamification.exp_table (
    id integer NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createDateTime" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" character varying(50),
    "lastChangedDateTime" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "expBase" integer NOT NULL,
    "expGrowth" numeric(2,1) NOT NULL,
    "rewardBase" integer NOT NULL,
    "rewardGrowth" numeric(2,1) NOT NULL,
    "configId" character varying NOT NULL
);


ALTER TABLE gamification.exp_table OWNER TO postgres;

--
-- Name: exp_table_id_seq; Type: SEQUENCE; Schema: gamification; Owner: postgres
--

CREATE SEQUENCE gamification.exp_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gamification.exp_table_id_seq OWNER TO postgres;

--
-- Name: exp_table_id_seq; Type: SEQUENCE OWNED BY; Schema: gamification; Owner: postgres
--

ALTER SEQUENCE gamification.exp_table_id_seq OWNED BY gamification.exp_table.id;


--
-- Name: log_transaction; Type: TABLE; Schema: gamification; Owner: postgres
--

CREATE TABLE gamification.log_transaction (
    end_time timestamp with time zone,
    endpoint character varying(500),
    id integer NOT NULL,
    ip character varying(55),
    req_body character varying(500),
    req_param character varying(500),
    req_query character varying(500),
    response text,
    start_time timestamp with time zone,
    time_ms integer
);


ALTER TABLE gamification.log_transaction OWNER TO postgres;

--
-- Name: log_transaction_id_seq; Type: SEQUENCE; Schema: gamification; Owner: postgres
--

CREATE SEQUENCE gamification.log_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gamification.log_transaction_id_seq OWNER TO postgres;

--
-- Name: log_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: gamification; Owner: postgres
--

ALTER SEQUENCE gamification.log_transaction_id_seq OWNED BY gamification.log_transaction.id;


--
-- Name: reward; Type: TABLE; Schema: gamification; Owner: postgres
--

CREATE TABLE gamification.reward (
    id integer NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createDateTime" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" character varying(50),
    "lastChangedDateTime" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    type character varying NOT NULL,
    amount integer NOT NULL,
    expire timestamp without time zone NOT NULL
);


ALTER TABLE gamification.reward OWNER TO postgres;

--
-- Name: reward_id_seq; Type: SEQUENCE; Schema: gamification; Owner: postgres
--

CREATE SEQUENCE gamification.reward_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gamification.reward_id_seq OWNER TO postgres;

--
-- Name: reward_id_seq; Type: SEQUENCE OWNED BY; Schema: gamification; Owner: postgres
--

ALTER SEQUENCE gamification.reward_id_seq OWNED BY gamification.reward.id;


--
-- Name: task; Type: TABLE; Schema: gamification; Owner: postgres
--

CREATE TABLE gamification.task (
    id integer NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createDateTime" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" character varying(50),
    "lastChangedDateTime" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying NOT NULL,
    remarks character varying NOT NULL,
    "isRepeatable" boolean NOT NULL,
    frequency character varying,
    "baseRewardExp" integer NOT NULL
);


ALTER TABLE gamification.task OWNER TO postgres;

--
-- Name: task_id_seq; Type: SEQUENCE; Schema: gamification; Owner: postgres
--

CREATE SEQUENCE gamification.task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gamification.task_id_seq OWNER TO postgres;

--
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: gamification; Owner: postgres
--

ALTER SEQUENCE gamification.task_id_seq OWNED BY gamification.task.id;


--
-- Name: user; Type: TABLE; Schema: gamification; Owner: postgres
--

CREATE TABLE gamification."user" (
    id integer NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createDateTime" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" character varying(50),
    "lastChangedDateTime" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "userLoginId" character varying NOT NULL,
    username character varying,
    "profileImageUrl" character varying,
    "signatureImageUrl" character varying,
    email character varying,
    password character varying NOT NULL,
    "userRole" character varying NOT NULL,
    exp integer,
    "overcapExp" integer,
    level integer,
    "expToNextLevel" integer
);


ALTER TABLE gamification."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: gamification; Owner: postgres
--

CREATE SEQUENCE gamification.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gamification.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: gamification; Owner: postgres
--

ALTER SEQUENCE gamification.user_id_seq OWNED BY gamification."user".id;


--
-- Name: user_task; Type: TABLE; Schema: gamification; Owner: postgres
--

CREATE TABLE gamification.user_task (
    id integer NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createDateTime" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdBy" character varying(50),
    "lastChangedDateTime" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "userId" integer NOT NULL,
    "taskId" integer NOT NULL,
    "isRedeemed" boolean NOT NULL,
    "isCompleted" boolean NOT NULL,
    "isActive" boolean NOT NULL,
    "redeemedAt" timestamp with time zone
);


ALTER TABLE gamification.user_task OWNER TO postgres;

--
-- Name: user_task_id_seq; Type: SEQUENCE; Schema: gamification; Owner: postgres
--

CREATE SEQUENCE gamification.user_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gamification.user_task_id_seq OWNER TO postgres;

--
-- Name: user_task_id_seq; Type: SEQUENCE OWNED BY; Schema: gamification; Owner: postgres
--

ALTER SEQUENCE gamification.user_task_id_seq OWNED BY gamification.user_task.id;


--
-- Name: log_detect_image; Type: TABLE; Schema: log; Owner: postgres
--

CREATE TABLE log.log_detect_image (
    link_image_front character varying(255),
    id_number character varying(255),
    name character varying(255),
    issue_date character varying(255),
    expire_date character varying(255),
    address character varying(255),
    dob character varying(255),
    gender bigint,
    document_type character varying(255),
    user_create character varying(255),
    client_type character varying(255),
    time_total bigint,
    time_get_config bigint,
    time_call_google bigint,
    time_read_file bigint,
    time_detect bigint,
    time_init bigint,
    time_end_process bigint,
    hostname character varying(255),
    create_time timestamp(6) without time zone,
    id integer NOT NULL,
    error_code integer,
    error_message character varying(255),
    link_image_back character varying(255),
    end_time timestamp(6) without time zone,
    place_issue character varying(255),
    nationality character varying(255)
);


ALTER TABLE log.log_detect_image OWNER TO postgres;

--
-- Name: log_detect_passport_id_seq; Type: SEQUENCE; Schema: log; Owner: postgres
--

CREATE SEQUENCE log.log_detect_passport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE log.log_detect_passport_id_seq OWNER TO postgres;

--
-- Name: log_detect_passport_id_seq; Type: SEQUENCE OWNED BY; Schema: log; Owner: postgres
--

ALTER SEQUENCE log.log_detect_passport_id_seq OWNED BY log.log_detect_image.id;


--
-- Name: log_transaction_customer; Type: TABLE; Schema: log; Owner: postgres
--

CREATE TABLE log.log_transaction_customer (
    id bigint NOT NULL,
    app_name character varying(255),
    device_name character varying(255),
    device_os character varying(255),
    end_time timestamp without time zone,
    error_code integer,
    host_name character varying(255),
    imei character varying(255),
    ip character varying(255),
    language character varying(255),
    error_message character varying(255),
    request character varying(255),
    response character varying(255),
    session_id character varying(255),
    start_time timestamp without time zone,
    status bigint,
    time_run bigint,
    uri character varying(255),
    username character varying(255),
    version_app_name character varying(255),
    version_code integer,
    version_os character varying(255),
    ws_code character varying(255)
);


ALTER TABLE log.log_transaction_customer OWNER TO postgres;

--
-- Name: log_transaction_customer_id_seq; Type: SEQUENCE; Schema: log; Owner: postgres
--

CREATE SEQUENCE log.log_transaction_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE log.log_transaction_customer_id_seq OWNER TO postgres;

--
-- Name: log_transaction_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: log; Owner: postgres
--

ALTER SEQUENCE log.log_transaction_customer_id_seq OWNED BY log.log_transaction_customer.id;


--
-- Name: log_transaction_inventory; Type: TABLE; Schema: log; Owner: postgres
--

CREATE TABLE log.log_transaction_inventory (
    id bigint NOT NULL,
    app_name character varying(255),
    device_name character varying(255),
    device_os character varying(255),
    end_time timestamp without time zone,
    error_code integer,
    host_name character varying(255),
    imei character varying(255),
    ip character varying(255),
    language character varying(255),
    error_message character varying(255),
    request character varying(255),
    response character varying(255),
    session_id character varying(255),
    start_time timestamp without time zone,
    status bigint,
    time_run bigint,
    uri character varying(255),
    username character varying(255),
    version_app_name character varying(255),
    version_code integer,
    version_os character varying(255),
    ws_code character varying(255)
);


ALTER TABLE log.log_transaction_inventory OWNER TO postgres;

--
-- Name: log_transaction_inventory_id_seq; Type: SEQUENCE; Schema: log; Owner: postgres
--

CREATE SEQUENCE log.log_transaction_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE log.log_transaction_inventory_id_seq OWNER TO postgres;

--
-- Name: log_transaction_inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: log; Owner: postgres
--

ALTER SEQUENCE log.log_transaction_inventory_id_seq OWNED BY log.log_transaction_inventory.id;


--
-- Name: log_transaction_subscriber; Type: TABLE; Schema: log; Owner: postgres
--

CREATE TABLE log.log_transaction_subscriber (
    id bigint NOT NULL,
    app_name character varying(255),
    device_name character varying(255),
    device_os character varying(255),
    end_time timestamp without time zone,
    error_code integer,
    host_name character varying(255),
    imei character varying(255),
    ip character varying(255),
    language character varying(255),
    error_message character varying(255),
    request character varying(255),
    response character varying(255),
    session_id character varying(255),
    start_time timestamp without time zone,
    status bigint,
    time_run bigint,
    uri character varying(255),
    username character varying(255),
    version_app_name character varying(255),
    version_code integer,
    version_os character varying(255),
    ws_code character varying(255)
);


ALTER TABLE log.log_transaction_subscriber OWNER TO postgres;

--
-- Name: log_transaction_subscriber_id_seq; Type: SEQUENCE; Schema: log; Owner: postgres
--

CREATE SEQUENCE log.log_transaction_subscriber_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE log.log_transaction_subscriber_id_seq OWNER TO postgres;

--
-- Name: log_transaction_subscriber_id_seq; Type: SEQUENCE OWNED BY; Schema: log; Owner: postgres
--

ALTER SEQUENCE log.log_transaction_subscriber_id_seq OWNED BY log.log_transaction_subscriber.id;


--
-- Name: callback_log; Type: TABLE; Schema: mnp; Owner: postgres
--

CREATE TABLE mnp.callback_log (
    id bigint NOT NULL,
    request_id bigint,
    trans_id character varying,
    created_time timestamp(6) without time zone,
    description text,
    ws_code character varying(255)
);


ALTER TABLE mnp.callback_log OWNER TO postgres;

--
-- Name: callback_log_id_seq; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.callback_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.callback_log_id_seq OWNER TO postgres;

--
-- Name: callback_log_id_seq; Type: SEQUENCE OWNED BY; Schema: mnp; Owner: postgres
--

ALTER SEQUENCE mnp.callback_log_id_seq OWNED BY mnp.callback_log.id;


--
-- Name: cancel_request_info_id_seq; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.cancel_request_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.cancel_request_info_id_seq OWNER TO postgres;

--
-- Name: cancel_request_info; Type: TABLE; Schema: mnp; Owner: postgres
--

CREATE TABLE mnp.cancel_request_info (
    id bigint DEFAULT nextval('mnp.cancel_request_info_id_seq'::regclass) NOT NULL,
    request_id bigint,
    reason_list text,
    file text,
    created_time timestamp(6) without time zone
);


ALTER TABLE mnp.cancel_request_info OWNER TO postgres;

--
-- Name: COLUMN cancel_request_info.request_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.cancel_request_info.request_id IS 'id YCCM';


--
-- Name: COLUMN cancel_request_info.reason_list; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.cancel_request_info.reason_list IS 'Danh sách lý do hủy chuyển mạng';


--
-- Name: COLUMN cancel_request_info.file; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.cancel_request_info.file IS 'Link file Phiếu yêu cầu';


--
-- Name: document_id_seq; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.document_id_seq OWNER TO postgres;

--
-- Name: document; Type: TABLE; Schema: mnp; Owner: postgres
--

CREATE TABLE mnp.document (
    id bigint DEFAULT nextval('mnp.document_id_seq'::regclass) NOT NULL,
    identify_number character varying(255),
    link text,
    type integer,
    status integer,
    request_id bigint,
    sub_id bigint,
    representative_id bigint,
    img_type integer,
    created_time timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE mnp.document OWNER TO postgres;

--
-- Name: COLUMN document.id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.document.id IS ' ';


--
-- Name: COLUMN document.identify_number; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.document.identify_number IS 'Số giấy tờ';


--
-- Name: COLUMN document.link; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.document.link IS 'Link ảnh giấy tờ';


--
-- Name: COLUMN document.type; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.document.type IS 'Loại giấy tờ';


--
-- Name: COLUMN document.status; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.document.status IS 'Trạng thái';


--
-- Name: COLUMN document.request_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.document.request_id IS 'Nếu là giấy tờ cho request thì sẽ có request_id';


--
-- Name: COLUMN document.sub_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.document.sub_id IS 'Nếu là giấy tờ cho sub thì sẽ có sub_id';


--
-- Name: COLUMN document.representative_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.document.representative_id IS 'Nếu là giấy tờ cho người đại diện sẽ có representative_id';


--
-- Name: COLUMN document.img_type; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.document.img_type IS 'Loại ảnh ( 0 - mặt trước / 1 - mặt sau / 2 - chỉ có một mặt)';


--
-- Name: mnp_call_log_id_seq; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.mnp_call_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.mnp_call_log_id_seq OWNER TO postgres;

--
-- Name: mnp_call_log; Type: TABLE; Schema: mnp; Owner: postgres
--

CREATE TABLE mnp.mnp_call_log (
    id bigint DEFAULT nextval('mnp.mnp_call_log_id_seq'::regclass) NOT NULL,
    url text,
    request_method character varying(255),
    request text,
    response text,
    headers text,
    created_time timestamp(6) without time zone,
    status integer,
    code character varying(255)
);


ALTER TABLE mnp.mnp_call_log OWNER TO postgres;

--
-- Name: option; Type: TABLE; Schema: mnp; Owner: postgres
--

CREATE TABLE mnp.option (
    id bigint NOT NULL,
    code character varying(255),
    name character varying(255),
    description text,
    status integer,
    created_time timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE mnp.option OWNER TO postgres;

--
-- Name: option_id_seq; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.option_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.option_id_seq OWNER TO postgres;

--
-- Name: option_id_seq1; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.option_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.option_id_seq1 OWNER TO postgres;

--
-- Name: option_id_seq1; Type: SEQUENCE OWNED BY; Schema: mnp; Owner: postgres
--

ALTER SEQUENCE mnp.option_id_seq1 OWNED BY mnp.option.id;


--
-- Name: option_value_id_seq; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.option_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.option_value_id_seq OWNER TO postgres;

--
-- Name: option_value; Type: TABLE; Schema: mnp; Owner: postgres
--

CREATE TABLE mnp.option_value (
    id bigint DEFAULT nextval('mnp.option_value_id_seq'::regclass) NOT NULL,
    option_code character varying,
    value text,
    description text,
    status integer,
    created_time timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE mnp.option_value OWNER TO postgres;

--
-- Name: order_tmp_info_id_seq; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.order_tmp_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.order_tmp_info_id_seq OWNER TO postgres;

--
-- Name: order_tmp_info; Type: TABLE; Schema: mnp; Owner: postgres
--

CREATE TABLE mnp.order_tmp_info (
    id bigint DEFAULT nextval('mnp.order_tmp_info_id_seq'::regclass) NOT NULL,
    code character varying(255),
    request_id bigint,
    name character varying(255),
    phone character varying(255),
    email character varying(255),
    city_id integer,
    city_name character varying(255),
    district_id integer,
    district_name character varying(255),
    village_id integer,
    village_name character varying(255),
    address text,
    total_order bigint,
    delivery_fee bigint,
    total_final bigint,
    created_time timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    pay_type integer,
    pay_done boolean,
    pay_at timestamp(6) without time zone
);


ALTER TABLE mnp.order_tmp_info OWNER TO postgres;

--
-- Name: COLUMN order_tmp_info.code; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.code IS 'Mã order tạm thời dùng để thanh toán';


--
-- Name: COLUMN order_tmp_info.request_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.request_id IS 'id của YCCM';


--
-- Name: COLUMN order_tmp_info.name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.name IS 'Tên khách hàng';


--
-- Name: COLUMN order_tmp_info.phone; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.phone IS 'Số điện thoại liên lạc';


--
-- Name: COLUMN order_tmp_info.city_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.city_id IS 'id Tỉnh/TP';


--
-- Name: COLUMN order_tmp_info.city_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.city_name IS 'Tên tỉnh thành phố';


--
-- Name: COLUMN order_tmp_info.district_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.district_id IS 'id Quận/Huyện';


--
-- Name: COLUMN order_tmp_info.district_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.district_name IS 'Tên Quận / Huyện';


--
-- Name: COLUMN order_tmp_info.village_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.village_id IS 'id Phường/Xã';


--
-- Name: COLUMN order_tmp_info.village_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.village_name IS 'Tên Phường/Xã';


--
-- Name: COLUMN order_tmp_info.address; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.address IS 'Địa chỉ chi tiết';


--
-- Name: COLUMN order_tmp_info.total_order; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.total_order IS 'Tổng tiền đơn hàng';


--
-- Name: COLUMN order_tmp_info.delivery_fee; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.delivery_fee IS 'Phí vận chuyển';


--
-- Name: COLUMN order_tmp_info.total_final; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.total_final IS 'Tổng tiền cuối cùng';


--
-- Name: COLUMN order_tmp_info.created_time; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.created_time IS 'Thời gian tạo';


--
-- Name: COLUMN order_tmp_info.pay_type; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.pay_type IS 'Hình thức thanh toán: 1 - online, 2 - cod, 3 - bank transfer, 4 - topup, 5 - pay by link; ...';


--
-- Name: COLUMN order_tmp_info.pay_done; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.pay_done IS 'Đã hoàn thành thanh toán hay chưa';


--
-- Name: COLUMN order_tmp_info.pay_at; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.order_tmp_info.pay_at IS 'Thời gian hoàn thành thanh toán';


--
-- Name: registry_mnp; Type: TABLE; Schema: mnp; Owner: postgres
--

CREATE TABLE mnp.registry_mnp (
    id bigint NOT NULL,
    status integer,
    email character varying(255),
    isdn character varying(12),
    created_time timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    last_update timestamp(6) without time zone,
    shop_id bigint,
    order_code character varying(255) NOT NULL,
    shop_name character varying,
    package_name character varying,
    package_price bigint,
    package_id bigint,
    sim_serial character varying,
    dno_name character varying,
    dno_code character varying,
    sub_type character varying,
    gender smallint,
    issue_date date,
    issue_by character varying,
    identify_number character varying,
    name character varying,
    country_id integer,
    country_name character varying,
    date_of_birth date,
    address character varying,
    contract_link text
);


ALTER TABLE mnp.registry_mnp OWNER TO postgres;

--
-- Name: registry_mnp_id_seq; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.registry_mnp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.registry_mnp_id_seq OWNER TO postgres;

--
-- Name: registry_mnp_id_seq; Type: SEQUENCE OWNED BY; Schema: mnp; Owner: postgres
--

ALTER SEQUENCE mnp.registry_mnp_id_seq OWNED BY mnp.registry_mnp.id;


--
-- Name: representative_info_id_seq; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.representative_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.representative_info_id_seq OWNER TO postgres;

--
-- Name: representative_info; Type: TABLE; Schema: mnp; Owner: postgres
--

CREATE TABLE mnp.representative_info (
    id bigint DEFAULT nextval('mnp.representative_info_id_seq'::regclass) NOT NULL,
    name character varying(255),
    identify_number character varying(255),
    issue_date date,
    issue_by character varying(255),
    date_of_birth date,
    country_id integer,
    country_name character varying(255),
    city_id integer,
    city_name character varying(255),
    district_id integer,
    district_name character varying(255),
    village_id integer,
    village_name character varying(255),
    address text,
    phone_contact character varying(255),
    status integer,
    request_id bigint,
    created_time timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    email character varying(255),
    gender smallint,
    identify_type integer
);


ALTER TABLE mnp.representative_info OWNER TO postgres;

--
-- Name: COLUMN representative_info.name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.name IS 'Tên người đại diện';


--
-- Name: COLUMN representative_info.identify_number; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.identify_number IS 'Số giấy tờ';


--
-- Name: COLUMN representative_info.issue_date; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.issue_date IS 'Ngày cấp';


--
-- Name: COLUMN representative_info.issue_by; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.issue_by IS 'Nơi cấp';


--
-- Name: COLUMN representative_info.date_of_birth; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.date_of_birth IS 'Ngày sinh';


--
-- Name: COLUMN representative_info.country_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.country_id IS 'id Quốc gia';


--
-- Name: COLUMN representative_info.country_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.country_name IS 'Tên quốc gia';


--
-- Name: COLUMN representative_info.city_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.city_id IS 'id Tỉnh/TP';


--
-- Name: COLUMN representative_info.city_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.city_name IS 'Tên tỉnh thành phố';


--
-- Name: COLUMN representative_info.district_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.district_id IS 'id Quận/ Huyện';


--
-- Name: COLUMN representative_info.district_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.district_name IS 'Tên quận/ Huyện';


--
-- Name: COLUMN representative_info.village_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.village_id IS 'id Phường/ Xã';


--
-- Name: COLUMN representative_info.village_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.village_name IS 'Tên phường/xã';


--
-- Name: COLUMN representative_info.address; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.address IS 'Địa chỉ chi tiết';


--
-- Name: COLUMN representative_info.phone_contact; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.phone_contact IS 'Số điện thoại liên lạc';


--
-- Name: COLUMN representative_info.status; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.status IS 'Trạng thái';


--
-- Name: COLUMN representative_info.request_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.request_id IS 'id YCCM';


--
-- Name: COLUMN representative_info.email; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.email IS 'Email của người đại diện';


--
-- Name: COLUMN representative_info.identify_type; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.representative_info.identify_type IS 'Loại giấy tờ';


--
-- Name: request_mnp_id_seq; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.request_mnp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.request_mnp_id_seq OWNER TO postgres;

--
-- Name: request_mnp; Type: TABLE; Schema: mnp; Owner: postgres
--

CREATE TABLE mnp.request_mnp (
    id bigint DEFAULT nextval('mnp.request_mnp_id_seq'::regclass) NOT NULL,
    code character varying(255) NOT NULL,
    trans_id character varying(255),
    name character varying(255),
    identify_number character varying(255),
    identify_type integer,
    issue_date date,
    issue_by character varying(255),
    country_id integer,
    country_name character varying(255),
    city_id integer,
    city_name character varying(255),
    district_id integer,
    district_name character varying(255),
    village_id integer,
    village_name character varying(255),
    address text,
    request_type integer,
    status integer,
    date_of_birth date,
    gender smallint,
    email character varying(255),
    phone_contact character varying(12),
    address_delivery text,
    violation smallint,
    created_time timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    last_update timestamp(6) without time zone,
    cust_type integer DEFAULT 0,
    expiration_date timestamp(6) without time zone,
    npr_tid character varying,
    reason_port_out character varying,
    reason_reject_port_out character varying
);


ALTER TABLE mnp.request_mnp OWNER TO postgres;

--
-- Name: COLUMN request_mnp.code; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.code IS 'Mã YCCM';


--
-- Name: COLUMN request_mnp.trans_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.trans_id IS 'Mã trans_id từ MNP Gateway trả về';


--
-- Name: COLUMN request_mnp.name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.name IS 'Tên khách hàng/ Tên công ty';


--
-- Name: COLUMN request_mnp.identify_number; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.identify_number IS 'Số giấy tờ';


--
-- Name: COLUMN request_mnp.identify_type; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.identify_type IS 'Loại giấy tờ (id)';


--
-- Name: COLUMN request_mnp.issue_date; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.issue_date IS 'Ngày cấp';


--
-- Name: COLUMN request_mnp.issue_by; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.issue_by IS 'Nơi cấp';


--
-- Name: COLUMN request_mnp.country_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.country_id IS 'id Quốc gia';


--
-- Name: COLUMN request_mnp.country_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.country_name IS 'Tên quốc gia';


--
-- Name: COLUMN request_mnp.city_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.city_id IS 'id Tỉnh/TP';


--
-- Name: COLUMN request_mnp.city_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.city_name IS 'Tên tỉnh/TP';


--
-- Name: COLUMN request_mnp.district_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.district_id IS 'id quận/ huyện';


--
-- Name: COLUMN request_mnp.district_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.district_name IS 'Tên quận/huyện';


--
-- Name: COLUMN request_mnp.village_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.village_id IS 'id Xã/phường';


--
-- Name: COLUMN request_mnp.village_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.village_name IS 'Tên xã/phường';


--
-- Name: COLUMN request_mnp.address; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.address IS 'Địa chỉ chi tiết';


--
-- Name: COLUMN request_mnp.request_type; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.request_type IS 'Loại YCCM (0 - Chuyển đi, 1 - Chuyển đến)';


--
-- Name: COLUMN request_mnp.status; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.status IS 'Trạng thái của YCCM';


--
-- Name: COLUMN request_mnp.date_of_birth; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.date_of_birth IS 'Ngày sinh';


--
-- Name: COLUMN request_mnp.gender; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.gender IS 'Giới tính (0 - Nam, 1 - Nữ)';


--
-- Name: COLUMN request_mnp.phone_contact; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.phone_contact IS 'Số điện thoại liên lạc';


--
-- Name: COLUMN request_mnp.address_delivery; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.address_delivery IS 'Địa chỉ giao hàng';


--
-- Name: COLUMN request_mnp.violation; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.violation IS '0 - Không cần hậu kiểm , 1 - Cần hậu kiểm';


--
-- Name: COLUMN request_mnp.created_time; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.created_time IS 'Thời gian tạo';


--
-- Name: COLUMN request_mnp.last_update; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.last_update IS 'Thời gian cập nhật cuối cùng';


--
-- Name: COLUMN request_mnp.cust_type; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.cust_type IS 'Loại khách hàng ( 0 - Cá nhân, 1 - Doanh nghiệp)';


--
-- Name: COLUMN request_mnp.expiration_date; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.expiration_date IS 'Ngày hết hạn của giấy tờ';


--
-- Name: COLUMN request_mnp.npr_tid; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.npr_tid IS 'Mã YCCM cục trả về';


--
-- Name: COLUMN request_mnp.reason_port_out; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.reason_port_out IS 'Lý do chuyển mạng đi';


--
-- Name: COLUMN request_mnp.reason_reject_port_out; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp.reason_reject_port_out IS 'Lý do từ chối chuyển đi';


--
-- Name: request_mnp_tracking_id_seq; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.request_mnp_tracking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.request_mnp_tracking_id_seq OWNER TO postgres;

--
-- Name: request_mnp_tracking; Type: TABLE; Schema: mnp; Owner: postgres
--

CREATE TABLE mnp.request_mnp_tracking (
    id bigint DEFAULT nextval('mnp.request_mnp_tracking_id_seq'::regclass) NOT NULL,
    request_id bigint,
    status integer,
    status_name character varying(255),
    description text,
    created_time timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE mnp.request_mnp_tracking OWNER TO postgres;

--
-- Name: COLUMN request_mnp_tracking.request_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp_tracking.request_id IS 'id YCCM';


--
-- Name: COLUMN request_mnp_tracking.status; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp_tracking.status IS 'id Trạng thái của YCCM';


--
-- Name: COLUMN request_mnp_tracking.status_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp_tracking.status_name IS 'Tên trạng thái';


--
-- Name: COLUMN request_mnp_tracking.description; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp_tracking.description IS 'Mô tả chi tiết của trạng thái';


--
-- Name: COLUMN request_mnp_tracking.created_time; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.request_mnp_tracking.created_time IS 'Thời gian thay đổi trạng thái';


--
-- Name: sub_mnp_info_id_seq; Type: SEQUENCE; Schema: mnp; Owner: postgres
--

CREATE SEQUENCE mnp.sub_mnp_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mnp.sub_mnp_info_id_seq OWNER TO postgres;

--
-- Name: sub_mnp_info; Type: TABLE; Schema: mnp; Owner: postgres
--

CREATE TABLE mnp.sub_mnp_info (
    id bigint DEFAULT nextval('mnp.sub_mnp_info_id_seq'::regclass) NOT NULL,
    request_id bigint NOT NULL,
    request_code character varying(255),
    isdn character varying(12),
    serial character varying(255),
    dno_code character varying(255),
    rno_code character varying(255),
    dno_name character varying(255),
    rno_name character varying(255),
    package_id integer,
    package_name character varying(255),
    sub_type_dno character varying(255),
    sub_type_rno character varying,
    contract_date date,
    primary_sub boolean,
    contract_number character varying(255),
    identify_number character varying(255),
    issue_date date,
    issue_by character varying(255),
    name character varying(255),
    date_of_birth date,
    gender smallint,
    email character varying(255),
    country_id integer,
    country_name character varying(255),
    city_id integer,
    city_name character varying(255),
    district_id integer,
    district_name character varying(255),
    village_id integer,
    village_name character varying(255),
    address text,
    status integer,
    created_time timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    last_update timestamp(6) without time zone,
    package_code character varying(255),
    violation smallint DEFAULT 0,
    violation_reasons text,
    expiration_date timestamp(6) without time zone
);


ALTER TABLE mnp.sub_mnp_info OWNER TO postgres;

--
-- Name: COLUMN sub_mnp_info.request_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.request_id IS 'id YCCM';


--
-- Name: COLUMN sub_mnp_info.request_code; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.request_code IS 'Mã YCCM';


--
-- Name: COLUMN sub_mnp_info.isdn; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.isdn IS 'Số thuê bao chuyển mạng';


--
-- Name: COLUMN sub_mnp_info.serial; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.serial IS 'Serial đấu nối ';


--
-- Name: COLUMN sub_mnp_info.dno_code; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.dno_code IS 'Mã nhà Nhà mạng gốc';


--
-- Name: COLUMN sub_mnp_info.rno_code; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.rno_code IS 'Mã Nhà mạng đến';


--
-- Name: COLUMN sub_mnp_info.dno_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.dno_name IS 'Tên nhà mạng gốc';


--
-- Name: COLUMN sub_mnp_info.rno_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.rno_name IS 'Tên nhà mạng đến';


--
-- Name: COLUMN sub_mnp_info.package_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.package_id IS 'id gói cước khi chuyển mạng đến';


--
-- Name: COLUMN sub_mnp_info.package_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.package_name IS 'Tên gói cước';


--
-- Name: COLUMN sub_mnp_info.sub_type_dno; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.sub_type_dno IS 'Loại thuê bao ở nhà mạng gốc(PRE_PAID : Trả trước, POST_PAID : Trả sau)';


--
-- Name: COLUMN sub_mnp_info.sub_type_rno; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.sub_type_rno IS 'Loại thuê bao ở nhà mạng đến (PRE_PAID : Trả trước, POST_PAID : Trả sau)';


--
-- Name: COLUMN sub_mnp_info.contract_date; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.contract_date IS 'Ngày kí hợp đồng ở DNO';


--
-- Name: COLUMN sub_mnp_info.primary_sub; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.primary_sub IS 'Đánh dấu thuê bao đại diện ( 1 - Thuê bao đại diện, 0 - Không phải)';


--
-- Name: COLUMN sub_mnp_info.contract_number; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.contract_number IS 'Số hợp đồng ';


--
-- Name: COLUMN sub_mnp_info.identify_number; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.identify_number IS 'Số giấy tờ';


--
-- Name: COLUMN sub_mnp_info.issue_date; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.issue_date IS 'Ngày cấp';


--
-- Name: COLUMN sub_mnp_info.issue_by; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.issue_by IS 'Nơi cấp';


--
-- Name: COLUMN sub_mnp_info.name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.name IS 'Tên chủ thuê bao';


--
-- Name: COLUMN sub_mnp_info.date_of_birth; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.date_of_birth IS 'Ngày sinh';


--
-- Name: COLUMN sub_mnp_info.gender; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.gender IS 'Giới tính (0 -Nam, 1 - Nữ , 2 - Khác)';


--
-- Name: COLUMN sub_mnp_info.country_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.country_id IS 'id Quốc gia';


--
-- Name: COLUMN sub_mnp_info.country_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.country_name IS 'Tên quốc gia';


--
-- Name: COLUMN sub_mnp_info.city_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.city_id IS 'id Tỉnh/TP';


--
-- Name: COLUMN sub_mnp_info.city_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.city_name IS 'Tên tỉnh thành phố';


--
-- Name: COLUMN sub_mnp_info.district_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.district_id IS 'id Quận/Huyện';


--
-- Name: COLUMN sub_mnp_info.district_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.district_name IS 'Tên Quận / Huyện';


--
-- Name: COLUMN sub_mnp_info.village_id; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.village_id IS 'id Phường/Xã';


--
-- Name: COLUMN sub_mnp_info.village_name; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.village_name IS 'Tên Phường/Xã';


--
-- Name: COLUMN sub_mnp_info.address; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.address IS 'Địa chỉ chi tiết';


--
-- Name: COLUMN sub_mnp_info.status; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.status IS 'Trạng thái';


--
-- Name: COLUMN sub_mnp_info.created_time; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.created_time IS 'Thời gian tạo';


--
-- Name: COLUMN sub_mnp_info.last_update; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.last_update IS 'Thời gian cập nhật cuối cùng';


--
-- Name: COLUMN sub_mnp_info.package_code; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.package_code IS 'Mã gói cước';


--
-- Name: COLUMN sub_mnp_info.violation; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.violation IS '0 - Không cần hậu kiểm, 1 - Cần hậu kiểm';


--
-- Name: COLUMN sub_mnp_info.violation_reasons; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.violation_reasons IS 'Lý do hậu kiểm';


--
-- Name: COLUMN sub_mnp_info.expiration_date; Type: COMMENT; Schema: mnp; Owner: postgres
--

COMMENT ON COLUMN mnp.sub_mnp_info.expiration_date IS 'Thời gian hết hạn giấy tờ';


--
-- Name: black_list; Type: TABLE; Schema: otp; Owner: postgres
--

CREATE TABLE otp.black_list (
    id bigint NOT NULL,
    isdn character varying(255),
    create_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    action character varying(255),
    description text,
    status smallint
);


ALTER TABLE otp.black_list OWNER TO postgres;

--
-- Name: black_list_id_seq; Type: SEQUENCE; Schema: otp; Owner: postgres
--

CREATE SEQUENCE otp.black_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE otp.black_list_id_seq OWNER TO postgres;

--
-- Name: black_list_id_seq; Type: SEQUENCE OWNED BY; Schema: otp; Owner: postgres
--

ALTER SEQUENCE otp.black_list_id_seq OWNED BY otp.black_list.id;


--
-- Name: check_otp_history; Type: TABLE; Schema: otp; Owner: postgres
--

CREATE TABLE otp.check_otp_history (
    id bigint NOT NULL,
    isdn character varying(255),
    create_date timestamp(6) without time zone,
    action character varying(255),
    wrong_amt integer
);


ALTER TABLE otp.check_otp_history OWNER TO postgres;

--
-- Name: COLUMN check_otp_history.wrong_amt; Type: COMMENT; Schema: otp; Owner: postgres
--

COMMENT ON COLUMN otp.check_otp_history.wrong_amt IS 'Số lần check sai liên tiếp';


--
-- Name: check_otp_history_id_seq; Type: SEQUENCE; Schema: otp; Owner: postgres
--

CREATE SEQUENCE otp.check_otp_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE otp.check_otp_history_id_seq OWNER TO postgres;

--
-- Name: check_otp_history_id_seq; Type: SEQUENCE OWNED BY; Schema: otp; Owner: postgres
--

ALTER SEQUENCE otp.check_otp_history_id_seq OWNED BY otp.check_otp_history.id;


--
-- Name: check_otp_mail_history; Type: TABLE; Schema: otp; Owner: postgres
--

CREATE TABLE otp.check_otp_mail_history (
    id bigint NOT NULL,
    email character varying(255),
    create_date timestamp(6) without time zone,
    action character varying(255),
    wrong_amt integer
);


ALTER TABLE otp.check_otp_mail_history OWNER TO postgres;

--
-- Name: COLUMN check_otp_mail_history.wrong_amt; Type: COMMENT; Schema: otp; Owner: postgres
--

COMMENT ON COLUMN otp.check_otp_mail_history.wrong_amt IS 'Số lần check sai liên tiếp';


--
-- Name: check_otp_mail_history_id_seq; Type: SEQUENCE; Schema: otp; Owner: postgres
--

CREATE SEQUENCE otp.check_otp_mail_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE otp.check_otp_mail_history_id_seq OWNER TO postgres;

--
-- Name: check_otp_mail_history_id_seq; Type: SEQUENCE OWNED BY; Schema: otp; Owner: postgres
--

ALTER SEQUENCE otp.check_otp_mail_history_id_seq OWNED BY otp.check_otp_mail_history.id;


--
-- Name: code_message; Type: TABLE; Schema: otp; Owner: postgres
--

CREATE TABLE otp.code_message (
    id bigint NOT NULL,
    app_name character varying(255),
    app_code character varying(255),
    google_code character varying(255)
);


ALTER TABLE otp.code_message OWNER TO postgres;

--
-- Name: log_transaction; Type: TABLE; Schema: otp; Owner: postgres
--

CREATE TABLE otp.log_transaction (
    id bigint NOT NULL,
    session_id character varying(100),
    ip character varying(50),
    uri character varying(500),
    ws_code character varying(255),
    request text,
    response text,
    start_time timestamp(6) without time zone,
    end_time timestamp(6) without time zone,
    time_run bigint,
    error_code integer,
    error_message text,
    username character varying(255),
    language character varying(20),
    app_name character varying(100),
    version_app_name character varying(100),
    version_code integer,
    device_name character varying(255),
    device_os character varying(50),
    version_os character varying(30),
    imei character varying(255),
    host_name character varying(255),
    status integer
);


ALTER TABLE otp.log_transaction OWNER TO postgres;

--
-- Name: log_transaction_id_seq; Type: SEQUENCE; Schema: otp; Owner: postgres
--

CREATE SEQUENCE otp.log_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE otp.log_transaction_id_seq OWNER TO postgres;

--
-- Name: log_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: otp; Owner: postgres
--

ALTER SEQUENCE otp.log_transaction_id_seq OWNED BY otp.log_transaction.id;


--
-- Name: option; Type: TABLE; Schema: otp; Owner: postgres
--

CREATE TABLE otp.option (
    id bigint NOT NULL,
    code character varying(255),
    name character varying(255),
    description text,
    status integer,
    created_time timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE otp.option OWNER TO postgres;

--
-- Name: option_id_seq; Type: SEQUENCE; Schema: otp; Owner: postgres
--

CREATE SEQUENCE otp.option_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE otp.option_id_seq OWNER TO postgres;

--
-- Name: option_id_seq; Type: SEQUENCE OWNED BY; Schema: otp; Owner: postgres
--

ALTER SEQUENCE otp.option_id_seq OWNED BY otp.option.id;


--
-- Name: option_value; Type: TABLE; Schema: otp; Owner: postgres
--

CREATE TABLE otp.option_value (
    id bigint NOT NULL,
    option_code character varying,
    value text,
    description text,
    status integer,
    created_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE otp.option_value OWNER TO postgres;

--
-- Name: option_value_id_seq; Type: SEQUENCE; Schema: otp; Owner: postgres
--

CREATE SEQUENCE otp.option_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE otp.option_value_id_seq OWNER TO postgres;

--
-- Name: option_value_id_seq; Type: SEQUENCE OWNED BY; Schema: otp; Owner: postgres
--

ALTER SEQUENCE otp.option_value_id_seq OWNED BY otp.option_value.id;


--
-- Name: otp; Type: TABLE; Schema: otp; Owner: postgres
--

CREATE TABLE otp.otp (
    isdn character varying(255) NOT NULL,
    code character varying(255) NOT NULL,
    action character varying(255) NOT NULL,
    status integer NOT NULL,
    created_date timestamp(6) without time zone NOT NULL,
    expired_date timestamp(6) without time zone NOT NULL,
    modified_date timestamp(6) without time zone,
    id bigint NOT NULL
);


ALTER TABLE otp.otp OWNER TO postgres;

--
-- Name: otp_code; Type: TABLE; Schema: otp; Owner: postgres
--

CREATE TABLE otp.otp_code (
    id bigint NOT NULL,
    otp_code character varying(255),
    status bigint,
    time_alive integer
);


ALTER TABLE otp.otp_code OWNER TO postgres;

--
-- Name: COLUMN otp_code.id; Type: COMMENT; Schema: otp; Owner: postgres
--

COMMENT ON COLUMN otp.otp_code.id IS 'id của bảng';


--
-- Name: COLUMN otp_code.otp_code; Type: COMMENT; Schema: otp; Owner: postgres
--

COMMENT ON COLUMN otp.otp_code.otp_code IS 'mã otp';


--
-- Name: COLUMN otp_code.status; Type: COMMENT; Schema: otp; Owner: postgres
--

COMMENT ON COLUMN otp.otp_code.status IS 'trạng thái otp';


--
-- Name: COLUMN otp_code.time_alive; Type: COMMENT; Schema: otp; Owner: postgres
--

COMMENT ON COLUMN otp.otp_code.time_alive IS 'Thời gian tồn tại mã otp';


--
-- Name: otp_config; Type: TABLE; Schema: otp; Owner: postgres
--

CREATE TABLE otp.otp_config (
    id bigint NOT NULL,
    limit_time integer,
    limit_amt integer,
    limit_time_check integer,
    limit_amt_check integer
);


ALTER TABLE otp.otp_config OWNER TO postgres;

--
-- Name: COLUMN otp_config.limit_time; Type: COMMENT; Schema: otp; Owner: postgres
--

COMMENT ON COLUMN otp.otp_config.limit_time IS 'Check trong khoảng thời gian (đơn vị phút)';


--
-- Name: COLUMN otp_config.limit_amt; Type: COMMENT; Schema: otp; Owner: postgres
--

COMMENT ON COLUMN otp.otp_config.limit_amt IS 'Số otp tối đa trong 1 khoảng thời gian';


--
-- Name: COLUMN otp_config.limit_time_check; Type: COMMENT; Schema: otp; Owner: postgres
--

COMMENT ON COLUMN otp.otp_config.limit_time_check IS 'Giới hạn khoảng thời gian check otp';


--
-- Name: COLUMN otp_config.limit_amt_check; Type: COMMENT; Schema: otp; Owner: postgres
--

COMMENT ON COLUMN otp.otp_config.limit_amt_check IS 'Giới hạn số lần check otp trong 1 khoảng thời gian';


--
-- Name: otp_email; Type: TABLE; Schema: otp; Owner: postgres
--

CREATE TABLE otp.otp_email (
    id bigint NOT NULL,
    action character varying(255),
    code character varying(255),
    created_date timestamp without time zone,
    email character varying(255),
    expired_date timestamp without time zone,
    status integer
);


ALTER TABLE otp.otp_email OWNER TO postgres;

--
-- Name: otp_email_id_seq; Type: SEQUENCE; Schema: otp; Owner: postgres
--

CREATE SEQUENCE otp.otp_email_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE otp.otp_email_id_seq OWNER TO postgres;

--
-- Name: otp_email_id_seq; Type: SEQUENCE OWNED BY; Schema: otp; Owner: postgres
--

ALTER SEQUENCE otp.otp_email_id_seq OWNED BY otp.otp_email.id;


--
-- Name: otp_id_seq; Type: SEQUENCE; Schema: otp; Owner: postgres
--

CREATE SEQUENCE otp.otp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE otp.otp_id_seq OWNER TO postgres;

--
-- Name: otp_id_seq; Type: SEQUENCE OWNED BY; Schema: otp; Owner: postgres
--

ALTER SEQUENCE otp.otp_id_seq OWNED BY otp.otp.id;


--
-- Name: abc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.abc (
    id bigint NOT NULL
);


ALTER TABLE public.abc OWNER TO postgres;

--
-- Name: abc_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.abc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.abc_id_seq OWNER TO postgres;

--
-- Name: abc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.abc_id_seq OWNED BY public.abc.id;


--
-- Name: ag_api_resource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ag_api_resource (
    id character varying(255) NOT NULL,
    api_code character varying(1000) NOT NULL,
    api_key character varying(400),
    api_name character varying(2000),
    api_name_en character varying(2000),
    api_template character varying(800),
    authenticate bigint,
    authenticate_otp bigint,
    created_time timestamp(6) without time zone,
    creator character varying(200),
    description character varying(2000),
    expired_date timestamp(6) without time zone,
    last_updated_time timestamp(6) without time zone,
    last_updator character varying(200),
    status bigint,
    version character varying(800),
    ag_throttling_id character varying(255)
);


ALTER TABLE public.ag_api_resource OWNER TO postgres;

--
-- Name: custommerdfsdfsdf; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.custommerdfsdfsdf (
    id character varying(255) NOT NULL,
    status bigint
);


ALTER TABLE public.custommerdfsdfsdf OWNER TO postgres;

--
-- Name: my_seq_gen; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.my_seq_gen
    START WITH 205
    INCREMENT BY 12
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.my_seq_gen OWNER TO postgres;

--
-- Name: retail_order_retail_order_tracking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.retail_order_retail_order_tracking (
    retailorder_order_id bigint NOT NULL,
    tracking_id bigint NOT NULL
);


ALTER TABLE public.retail_order_retail_order_tracking OWNER TO postgres;

--
-- Name: scan_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scan_log (
    id bigint NOT NULL,
    session_id character varying(100),
    ws_code character varying(100),
    app_code character varying(100),
    count_request integer NOT NULL,
    time_created timestamp without time zone,
    schema character varying(100),
    username character varying(100)
);


ALTER TABLE public.scan_log OWNER TO postgres;

--
-- Name: scan_log_count_request_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scan_log_count_request_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scan_log_count_request_seq OWNER TO postgres;

--
-- Name: scan_log_count_request_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scan_log_count_request_seq OWNED BY public.scan_log.count_request;


--
-- Name: scan_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scan_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scan_log_id_seq OWNER TO postgres;

--
-- Name: scan_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scan_log_id_seq OWNED BY public.scan_log.id;


--
-- Name: account_sub; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.account_sub (
    id bigint NOT NULL,
    acc_name character varying(255),
    acc_key character varying(255),
    ocs_id bigint,
    acc_type character varying(255),
    is_acm smallint,
    unit character varying(255),
    status_id bigint
);


ALTER TABLE subscriber.account_sub OWNER TO postgres;

--
-- Name: COLUMN account_sub.is_acm; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.account_sub.is_acm IS '0 - TK thường / 1 - TK tích lũy';


--
-- Name: account_sub_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.account_sub_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.account_sub_id_seq OWNER TO postgres;

--
-- Name: account_sub_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.account_sub_id_seq OWNED BY subscriber.account_sub.id;


--
-- Name: advance_money_config; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.advance_money_config (
    id bigint NOT NULL,
    balance bigint,
    time_active integer,
    advance_payment smallint
);


ALTER TABLE subscriber.advance_money_config OWNER TO postgres;

--
-- Name: COLUMN advance_money_config.balance; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.advance_money_config.balance IS 'Số dư tài khoản chính';


--
-- Name: COLUMN advance_money_config.time_active; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.advance_money_config.time_active IS 'Thời gian kích hoạt thuê bao ( ngày)';


--
-- Name: COLUMN advance_money_config.advance_payment; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.advance_money_config.advance_payment IS 'Nợ ứng tiền // 0 - Không check nợ // 1 - Check có nợ ko ';


--
-- Name: advance_money_config_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.advance_money_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.advance_money_config_id_seq OWNER TO postgres;

--
-- Name: advance_money_config_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.advance_money_config_id_seq OWNED BY subscriber.advance_money_config.id;


--
-- Name: call_log; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.call_log (
    id bigint NOT NULL,
    code character varying(255),
    function character varying(255),
    ws_code character varying(255),
    url character varying(255),
    req text,
    res text,
    "time" character varying(255)
);


ALTER TABLE subscriber.call_log OWNER TO postgres;

--
-- Name: call_log_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.call_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.call_log_id_seq OWNER TO postgres;

--
-- Name: call_log_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.call_log_id_seq OWNED BY subscriber.call_log.id;


--
-- Name: cmp_service_log; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.cmp_service_log (
    id bigint NOT NULL,
    request_uri character varying(255),
    request_method character varying(255),
    request character varying(255),
    response text,
    created_at timestamp(6) without time zone
);


ALTER TABLE subscriber.cmp_service_log OWNER TO postgres;

--
-- Name: cmp_service_log_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.cmp_service_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.cmp_service_log_id_seq OWNER TO postgres;

--
-- Name: cmp_service_log_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.cmp_service_log_id_seq OWNED BY subscriber.cmp_service_log.id;


--
-- Name: commitment_cycle; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.commitment_cycle (
    id bigint NOT NULL,
    sub_id bigint,
    isdn character varying(12),
    package_id bigint,
    total_cycle integer,
    current_cycle integer,
    debt_cycle integer,
    status integer,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    package_price bigint,
    package_code_ocs character varying(255),
    is_send_extend_success boolean,
    is_send_extend_unsuccess boolean,
    is_send_warning_befor_oneway_lock boolean,
    is_send_oneway_lock boolean,
    is_send_warning_befor_twoway_lock boolean,
    is_send_warning_befor_twoway_lock_to_oneway_lock boolean,
    is_send_warning_befor_restore boolean,
    is_send_warning_befor_extend boolean,
    debt_cycle_2 integer,
    is_send_twoway_lock boolean,
    is_send_warning_twoway_lock_to_oneway_lock boolean,
    isdn_type integer
);


ALTER TABLE subscriber.commitment_cycle OWNER TO postgres;

--
-- Name: COLUMN commitment_cycle.package_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.commitment_cycle.package_id IS 'id gói cam kết';


--
-- Name: COLUMN commitment_cycle.total_cycle; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.commitment_cycle.total_cycle IS 'Tổng số chu kì cam kết';


--
-- Name: COLUMN commitment_cycle.current_cycle; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.commitment_cycle.current_cycle IS 'chu kì cam kết hiện tại';


--
-- Name: COLUMN commitment_cycle.debt_cycle; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.commitment_cycle.debt_cycle IS 'chu kì cam kết đang nợ';


--
-- Name: COLUMN commitment_cycle.status; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.commitment_cycle.status IS '0- mở, 1 chặn 1 chiều, 2 chặn 2 chiều, 3 xoá';


--
-- Name: commitment_cycle_bak_20210427; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.commitment_cycle_bak_20210427 (
    id bigint,
    sub_id bigint,
    isdn character varying(12),
    package_id bigint,
    total_cycle integer,
    current_cycle integer,
    debt_cycle integer,
    status integer,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    package_price bigint,
    package_code_ocs character varying(255),
    is_send_extend_success boolean,
    is_send_extend_unsuccess boolean,
    is_send_warning_befor_oneway_lock boolean,
    is_send_oneway_lock boolean,
    is_send_warning_befor_twoway_lock boolean,
    is_send_warning_befor_twoway_lock_to_oneway_lock boolean,
    is_send_warning_befor_restore boolean,
    is_send_warning_befor_extend boolean,
    debt_cycle_2 integer,
    is_send_twoway_lock boolean,
    is_send_warning_twoway_lock_to_oneway_lock boolean
);


ALTER TABLE subscriber.commitment_cycle_bak_20210427 OWNER TO postgres;

--
-- Name: commitment_cycle_history; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.commitment_cycle_history (
    his_id bigint NOT NULL,
    sub_id bigint,
    isdn character varying(12),
    package_id bigint,
    total_cycle integer,
    current_cycle integer,
    debt_cycle integer,
    status integer,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    package_price bigint,
    id bigint,
    his_created_at timestamp(6) without time zone,
    is_extend_success boolean,
    package_code_ocs character varying(255),
    is_send_extend_success boolean,
    is_send_extend_unsuccess boolean,
    is_send_warning_befor_oneway_lock boolean,
    is_send_oneway_lock boolean,
    is_send_warning_befor_twoway_lock boolean,
    is_send_warning_befor_twoway_lock_to_oneway_lock boolean,
    is_send_warning_befor_restore boolean,
    is_send_warning_befor_extend boolean,
    debt_cycle_2 integer
);


ALTER TABLE subscriber.commitment_cycle_history OWNER TO postgres;

--
-- Name: COLUMN commitment_cycle_history.package_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.commitment_cycle_history.package_id IS 'id gói cam kết';


--
-- Name: COLUMN commitment_cycle_history.total_cycle; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.commitment_cycle_history.total_cycle IS 'Tổng số chu kì cam kết';


--
-- Name: COLUMN commitment_cycle_history.current_cycle; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.commitment_cycle_history.current_cycle IS 'chu kì cam kết hiện tại';


--
-- Name: COLUMN commitment_cycle_history.debt_cycle; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.commitment_cycle_history.debt_cycle IS 'chu kì cam kết đang nợ';


--
-- Name: COLUMN commitment_cycle_history.status; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.commitment_cycle_history.status IS '0- mở, 1 chặn 1 chiều, 2 chặn 2 chiều, 3 xoá';


--
-- Name: commitment_cycle_history_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.commitment_cycle_history_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.commitment_cycle_history_his_id_seq OWNER TO postgres;

--
-- Name: commitment_cycle_history_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.commitment_cycle_history_his_id_seq OWNED BY subscriber.commitment_cycle_history.his_id;


--
-- Name: commitment_cycle_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.commitment_cycle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.commitment_cycle_id_seq OWNER TO postgres;

--
-- Name: commitment_cycle_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.commitment_cycle_id_seq OWNED BY subscriber.commitment_cycle.id;


--
-- Name: config_cash_advance; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.config_cash_advance (
    id bigint NOT NULL,
    syntax character varying(255),
    description character varying(255),
    code character varying(255),
    money bigint,
    fee bigint,
    fee_type character varying(255)
);


ALTER TABLE subscriber.config_cash_advance OWNER TO postgres;

--
-- Name: COLUMN config_cash_advance.money; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.config_cash_advance.money IS 'số tiền ứng';


--
-- Name: COLUMN config_cash_advance.fee; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.config_cash_advance.fee IS 'phí ứng tiền';


--
-- Name: COLUMN config_cash_advance.fee_type; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.config_cash_advance.fee_type IS 'PERCENT / VALUE';


--
-- Name: config_time_cancel; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.config_time_cancel (
    id bigint NOT NULL,
    shop_id bigint NOT NULL,
    cancel_time bigint DEFAULT 60,
    package_id integer,
    type integer,
    enable boolean DEFAULT true
);


ALTER TABLE subscriber.config_time_cancel OWNER TO postgres;

--
-- Name: config_time_cancel_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.config_time_cancel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.config_time_cancel_id_seq OWNER TO postgres;

--
-- Name: config_time_cancel_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.config_time_cancel_id_seq OWNED BY subscriber.config_time_cancel.id;


--
-- Name: customer; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.customer (
    account_id bigint,
    address character varying(255),
    city bigint,
    country bigint,
    cust_code character varying(255) NOT NULL,
    cust_name character varying(255),
    district bigint,
    gender smallint,
    language character varying(255),
    phone character varying(255),
    receive_notifi_ads character varying(255),
    village character varying(255),
    parent_id bigint,
    status_id integer NOT NULL,
    cust_type integer,
    cust_id bigint DEFAULT nextval('customer.customer_cust_id_seq'::regclass) NOT NULL,
    avatar character varying(500),
    email character varying(255),
    date_of_birth timestamp(6) without time zone,
    tax_code character varying(255),
    path character varying(255),
    identify_number character varying(255),
    identify_type character varying(255),
    create_date timestamp(0) without time zone,
    isdn_registed character varying(255),
    subscriber character varying(255),
    description character varying(255),
    number_employee integer,
    trust_text_percent integer,
    trust_image_percent integer,
    group_id character varying(50),
    kyc_job integer DEFAULT 0 NOT NULL,
    avatar_reddi character varying(500)
);


ALTER TABLE subscriber.customer OWNER TO postgres;

--
-- Name: COLUMN customer.account_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.account_id IS 'id của bảng tài khoản';


--
-- Name: COLUMN customer.address; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.address IS 'địa chỉ';


--
-- Name: COLUMN customer.city; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.city IS 'tỉnh';


--
-- Name: COLUMN customer.country; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.country IS 'quốc gia';


--
-- Name: COLUMN customer.cust_code; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.cust_code IS 'mã khách hàng';


--
-- Name: COLUMN customer.cust_name; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.cust_name IS 'tên khách hàng';


--
-- Name: COLUMN customer.district; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.district IS 'quận';


--
-- Name: COLUMN customer.gender; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.gender IS '0 - Male / 1 - Female';


--
-- Name: COLUMN customer.language; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.language IS 'ngôn ngữ';


--
-- Name: COLUMN customer.phone; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.phone IS 'điện thoại liện hệ';


--
-- Name: COLUMN customer.receive_notifi_ads; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.receive_notifi_ads IS 'nhận tin nhắn quoảng cáo';


--
-- Name: COLUMN customer.village; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.village IS 'xã';


--
-- Name: COLUMN customer.parent_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.parent_id IS 'khách hàng cha (với trường hợp là kh doanh nghiệp)';


--
-- Name: COLUMN customer.status_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.status_id IS 'trạng thái';


--
-- Name: COLUMN customer.cust_type; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.cust_type IS 'loại khách hàng';


--
-- Name: COLUMN customer.cust_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.cust_id IS 'id khách hàng';


--
-- Name: COLUMN customer.avatar; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.avatar IS 'ảnh đại diện';


--
-- Name: COLUMN customer.email; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.email IS 'email';


--
-- Name: COLUMN customer.date_of_birth; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.date_of_birth IS 'ngày sinh nhật';


--
-- Name: COLUMN customer.tax_code; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.tax_code IS 'mã số thuế';


--
-- Name: COLUMN customer.path; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.path IS 'cây thư cha con của khách hàng doanh nghiệp';


--
-- Name: COLUMN customer.identify_number; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.identify_number IS 'mã số định danh cá nhân';


--
-- Name: COLUMN customer.identify_type; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.identify_type IS 'loại mã định danh';


--
-- Name: COLUMN customer.create_date; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.create_date IS 'ngày tạo';


--
-- Name: COLUMN customer.isdn_registed; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.isdn_registed IS 'số thuê bao đã đăng ký (admin)';


--
-- Name: COLUMN customer.subscriber; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.subscriber IS 'tất cả thuê bao đã đăng ký';


--
-- Name: COLUMN customer.description; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.description IS 'Mô tả thông tin khách hàng';


--
-- Name: COLUMN customer.number_employee; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.number_employee IS 'Số lượng nhân viên';


--
-- Name: COLUMN customer.trust_text_percent; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.trust_text_percent IS '% ddooj tin caayj khi detech';


--
-- Name: COLUMN customer.trust_image_percent; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.trust_image_percent IS '% do tin cay';


--
-- Name: COLUMN customer.kyc_job; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.kyc_job IS 'Đánh dấu khách hàng được kyc theo lô //1 - kyc theo lô';


--
-- Name: COLUMN customer.avatar_reddi; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.customer.avatar_reddi IS 'Avatar hiển thị trên app';


--
-- Name: log_transaction; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.log_transaction (
    id bigint NOT NULL,
    session_id character varying(100),
    ip character varying(50),
    uri character varying(500),
    ws_code character varying(255),
    request text,
    response text,
    start_time timestamp(6) without time zone,
    end_time timestamp(6) without time zone,
    time_run bigint,
    error_code character varying(255),
    error_message text,
    username character varying(255),
    language character varying(20),
    app_name character varying(100),
    version_app_name character varying(100),
    version_code integer,
    device_name character varying(255),
    device_os character varying(50),
    version_os character varying(30),
    imei character varying(255),
    host_name character varying(255),
    status integer
);


ALTER TABLE subscriber.log_transaction OWNER TO postgres;

--
-- Name: log_transaction_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.log_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.log_transaction_id_seq OWNER TO postgres;

--
-- Name: log_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.log_transaction_id_seq OWNED BY subscriber.log_transaction.id;


--
-- Name: modify_resource_job; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.modify_resource_job (
    id bigint NOT NULL,
    key character varying(255),
    url character varying(255),
    reason character varying(255),
    reason_desc character varying(255),
    creator character varying(255),
    status bigint,
    create_date timestamp without time zone,
    execute_date timestamp without time zone
);


ALTER TABLE subscriber.modify_resource_job OWNER TO postgres;

--
-- Name: COLUMN modify_resource_job.status; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.modify_resource_job.status IS '1 - Chưa quét / 2 - Đã quét job';


--
-- Name: modify_resource_job_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.modify_resource_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.modify_resource_job_id_seq OWNER TO postgres;

--
-- Name: modify_resource_job_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.modify_resource_job_id_seq OWNED BY subscriber.modify_resource_job.id;


--
-- Name: modify_resource_job_log; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.modify_resource_job_log (
    create_date timestamp without time zone,
    file_fail character varying(255),
    file_success character varying(255),
    id bigint NOT NULL,
    job_id bigint,
    reason_fail text,
    status bigint
);


ALTER TABLE subscriber.modify_resource_job_log OWNER TO postgres;

--
-- Name: COLUMN modify_resource_job_log.status; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.modify_resource_job_log.status IS '1 - Success // 2 - Fail';


--
-- Name: modify_resource_job_log_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.modify_resource_job_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.modify_resource_job_log_id_seq OWNER TO postgres;

--
-- Name: modify_resource_job_log_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.modify_resource_job_log_id_seq OWNED BY subscriber.modify_resource_job_log.id;


--
-- Name: msisdn; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.msisdn (
    msisdn character varying(255)
);


ALTER TABLE subscriber.msisdn OWNER TO postgres;

--
-- Name: option; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.option (
    id bigint NOT NULL,
    code character varying(255),
    name character varying(255),
    description text,
    status integer,
    created_time timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE subscriber.option OWNER TO postgres;

--
-- Name: option_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.option_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.option_id_seq OWNER TO postgres;

--
-- Name: option_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.option_id_seq OWNED BY subscriber.option.id;


--
-- Name: option_value; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.option_value (
    id bigint NOT NULL,
    option_code character varying,
    value text,
    description text,
    status integer,
    created_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE subscriber.option_value OWNER TO postgres;

--
-- Name: option_value_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.option_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.option_value_id_seq OWNER TO postgres;

--
-- Name: option_value_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.option_value_id_seq OWNED BY subscriber.option_value.id;


--
-- Name: recharge_online_order; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.recharge_online_order (
    order_code character varying(255),
    sub_id bigint,
    amount bigint,
    cust_id integer,
    status smallint,
    app_code integer,
    order_id integer NOT NULL,
    isdn character varying(255),
    created_at timestamp(6) without time zone,
    updated_at timestamp without time zone,
    shop_id bigint,
    language character varying(255),
    trans_id character varying(100)
);


ALTER TABLE subscriber.recharge_online_order OWNER TO postgres;

--
-- Name: COLUMN recharge_online_order.status; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.recharge_online_order.status IS '0 - Create, 1 - paid, 2 - Nạp thành công';


--
-- Name: COLUMN recharge_online_order.shop_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.recharge_online_order.shop_id IS 'Danh cho shop nap tien ho cho khach hang';


--
-- Name: recharge_online_order_order_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.recharge_online_order_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.recharge_online_order_order_id_seq OWNER TO postgres;

--
-- Name: recharge_online_order_order_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.recharge_online_order_order_id_seq OWNED BY subscriber.recharge_online_order.order_id;


--
-- Name: sub_action_action_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_action_action_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_action_action_id_seq OWNER TO postgres;

--
-- Name: sub_action; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_action (
    action_id bigint DEFAULT nextval('subscriber.sub_action_action_id_seq'::regclass) NOT NULL,
    action_name character varying(100)
);


ALTER TABLE subscriber.sub_action OWNER TO postgres;

--
-- Name: sub_activate_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_activate_his (
    id bigint NOT NULL,
    creator character varying(255),
    description character varying(255),
    sub_id bigint,
    "time" character varying(255)
);


ALTER TABLE subscriber.sub_activate_his OWNER TO postgres;

--
-- Name: COLUMN sub_activate_his.creator; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_activate_his.creator IS 'người tạo';


--
-- Name: COLUMN sub_activate_his.sub_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_activate_his.sub_id IS 'id người đăng ký';


--
-- Name: sub_activate_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_activate_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_activate_his_id_seq OWNER TO postgres;

--
-- Name: sub_activate_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_activate_his_id_seq OWNED BY subscriber.sub_activate_his.id;


--
-- Name: sub_approve_status; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_approve_status (
    id bigint NOT NULL,
    description character varying(255),
    name character varying(255),
    type character varying(255),
    value character varying(255)
);


ALTER TABLE subscriber.sub_approve_status OWNER TO postgres;

--
-- Name: sub_approve_status_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_approve_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_approve_status_id_seq OWNER TO postgres;

--
-- Name: sub_approve_status_id_seq1; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_approve_status_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_approve_status_id_seq1 OWNER TO postgres;

--
-- Name: sub_approve_status_id_seq1; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_approve_status_id_seq1 OWNED BY subscriber.sub_approve_status.id;


--
-- Name: sub_block_call_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_block_call_his (
    id bigint NOT NULL,
    creator character varying(255),
    direct character varying(255),
    reason_desc character varying(255),
    reason_id bigint,
    status bigint,
    sub_id bigint,
    "time" character varying(255)
);


ALTER TABLE subscriber.sub_block_call_his OWNER TO postgres;

--
-- Name: COLUMN sub_block_call_his.direct; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_block_call_his.direct IS 'chiều';


--
-- Name: COLUMN sub_block_call_his.reason_desc; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_block_call_his.reason_desc IS 'lí do';


--
-- Name: COLUMN sub_block_call_his.reason_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_block_call_his.reason_id IS 'id lí do';


--
-- Name: sub_block_call_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_block_call_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_block_call_his_id_seq OWNER TO postgres;

--
-- Name: sub_block_call_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_block_call_his_id_seq OWNED BY subscriber.sub_block_call_his.id;


--
-- Name: sub_change_owner_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_change_owner_his (
    id bigint NOT NULL,
    creator character varying(255),
    new_cust_id bigint,
    new_sub_id bigint,
    old_cust_id bigint,
    old_sub_id bigint,
    reason character varying(255),
    "time" character varying(255)
);


ALTER TABLE subscriber.sub_change_owner_his OWNER TO postgres;

--
-- Name: sub_change_owner_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_change_owner_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_change_owner_his_id_seq OWNER TO postgres;

--
-- Name: sub_change_owner_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_change_owner_his_id_seq OWNED BY subscriber.sub_change_owner_his.id;


--
-- Name: sub_change_sim_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_change_sim_his (
    id bigint NOT NULL,
    creator character varying(255),
    new_sim character varying(255),
    old_sim character varying(255),
    reason character varying(255),
    sub_id bigint,
    "time" character varying(255),
    change_at timestamp without time zone,
    cust_id bigint,
    isdn character varying(255),
    payment_type bigint,
    price bigint,
    retry integer,
    shop_id bigint,
    status integer
);


ALTER TABLE subscriber.sub_change_sim_his OWNER TO postgres;

--
-- Name: COLUMN sub_change_sim_his.new_sim; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_change_sim_his.new_sim IS 'sim mới';


--
-- Name: COLUMN sub_change_sim_his.old_sim; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_change_sim_his.old_sim IS 'sim cũ';


--
-- Name: COLUMN sub_change_sim_his.sub_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_change_sim_his.sub_id IS 'id người đăng ký';


--
-- Name: sub_change_sim_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_change_sim_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_change_sim_his_id_seq OWNER TO postgres;

--
-- Name: sub_change_sim_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_change_sim_his_id_seq OWNED BY subscriber.sub_change_sim_his.id;


--
-- Name: sub_charge_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_charge_his (
    id bigint NOT NULL,
    description character varying(255),
    money bigint,
    sub_id bigint,
    "time" character varying(255),
    type character varying(255),
    trans_id character varying(255),
    partner character varying,
    money_before bigint,
    money_after bigint,
    date_before timestamp without time zone,
    date_after timestamp without time zone
);


ALTER TABLE subscriber.sub_charge_his OWNER TO postgres;

--
-- Name: COLUMN sub_charge_his.money; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_charge_his.money IS 'số tiền';


--
-- Name: COLUMN sub_charge_his.sub_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_charge_his.sub_id IS 'id người đăng ký';


--
-- Name: COLUMN sub_charge_his.type; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_charge_his.type IS 'loại';


--
-- Name: sub_charge_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_charge_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_charge_his_id_seq OWNER TO postgres;

--
-- Name: sub_charge_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_charge_his_id_seq OWNED BY subscriber.sub_charge_his.id;


--
-- Name: sub_contact_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_contact_his (
    id bigint NOT NULL,
    cost bigint,
    direct character varying(255),
    duration bigint,
    phone character varying(255),
    sub_id bigint,
    "time" character varying(255),
    type character varying(255),
    type_account character varying(255),
    is_internal integer,
    pack_id bigint
);


ALTER TABLE subscriber.sub_contact_his OWNER TO postgres;

--
-- Name: COLUMN sub_contact_his.direct; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_contact_his.direct IS 'tới';


--
-- Name: COLUMN sub_contact_his.duration; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_contact_his.duration IS 'thời lượng';


--
-- Name: COLUMN sub_contact_his.type; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_contact_his.type IS 'kiểu loại';


--
-- Name: COLUMN sub_contact_his.type_account; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_contact_his.type_account IS 'loại tài khoản';


--
-- Name: COLUMN sub_contact_his.is_internal; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_contact_his.is_internal IS 'có phải nội bộ không';


--
-- Name: sub_contact_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_contact_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_contact_his_id_seq OWNER TO postgres;

--
-- Name: sub_contact_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_contact_his_id_seq OWNED BY subscriber.sub_contact_his.id;


--
-- Name: sub_data_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_data_his (
    id bigint NOT NULL,
    cost bigint,
    data_used bigint,
    sub_id bigint,
    "time" character varying(255),
    type_account character varying(255),
    pack_id bigint
);


ALTER TABLE subscriber.sub_data_his OWNER TO postgres;

--
-- Name: COLUMN sub_data_his.data_used; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_data_his.data_used IS 'dung lượng sử dụng';


--
-- Name: COLUMN sub_data_his.type_account; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_data_his.type_account IS 'loại tài khoản';


--
-- Name: COLUMN sub_data_his.pack_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_data_his.pack_id IS 'id gói cước';


--
-- Name: sub_data_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_data_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_data_his_id_seq OWNER TO postgres;

--
-- Name: sub_data_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_data_his_id_seq OWNED BY subscriber.sub_data_his.id;


--
-- Name: sub_debt_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_debt_his (
    id bigint NOT NULL,
    description character varying(255),
    money bigint,
    sub_id bigint,
    "time" character varying(255),
    trans_id character varying(255)
);


ALTER TABLE subscriber.sub_debt_his OWNER TO postgres;

--
-- Name: sub_debt_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_debt_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_debt_his_id_seq OWNER TO postgres;

--
-- Name: sub_debt_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_debt_his_id_seq OWNED BY subscriber.sub_debt_his.id;


--
-- Name: sub_mod_expire_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_mod_expire_his (
    id bigint NOT NULL,
    creator character varying(255),
    new_expired_at character varying(255),
    old_expired_at character varying(255),
    pack_id bigint,
    reason text,
    reason_desc text,
    sub_id bigint,
    sub_pack_id bigint,
    "time" character varying(255)
);


ALTER TABLE subscriber.sub_mod_expire_his OWNER TO postgres;

--
-- Name: sub_mod_expire_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_mod_expire_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_mod_expire_his_id_seq OWNER TO postgres;

--
-- Name: sub_mod_expire_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_mod_expire_his_id_seq OWNED BY subscriber.sub_mod_expire_his.id;


--
-- Name: sub_mod_pack_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_mod_pack_his (
    id bigint NOT NULL,
    creator character varying(255),
    new_pack_id bigint,
    old_pack_id bigint,
    reason text,
    reason_desc text,
    sub_id bigint,
    "time" character varying(255)
);


ALTER TABLE subscriber.sub_mod_pack_his OWNER TO postgres;

--
-- Name: sub_mod_pack_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_mod_pack_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_mod_pack_his_id_seq OWNER TO postgres;

--
-- Name: sub_mod_pack_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_mod_pack_his_id_seq OWNED BY subscriber.sub_mod_pack_his.id;


--
-- Name: sub_mod_resource_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_mod_resource_his (
    id bigint NOT NULL,
    amount bigint,
    amt_new bigint,
    amt_old bigint,
    creator character varying(255),
    reason text,
    reason_desc text,
    resource_type integer,
    sub_id bigint,
    "time" character varying(255)
);


ALTER TABLE subscriber.sub_mod_resource_his OWNER TO postgres;

--
-- Name: sub_mod_resource_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_mod_resource_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_mod_resource_his_id_seq OWNER TO postgres;

--
-- Name: sub_mod_resource_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_mod_resource_his_id_seq OWNED BY subscriber.sub_mod_resource_his.id;


--
-- Name: sub_package; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_package (
    id bigint NOT NULL,
    amt_call bigint,
    amt_data bigint,
    amt_sms bigint,
    creator character varying(255),
    discount bigint,
    duration bigint,
    expired_at character varying(255),
    pack_id bigint,
    price bigint,
    real_price bigint,
    registered_at character varying(255),
    shop_id bigint,
    sub_id bigint,
    sub_id_sent bigint,
    type smallint NOT NULL,
    voucher_code character varying(255),
    is_main integer DEFAULT 0,
    order_code character varying(255),
    status integer DEFAULT 0,
    ocs_code character varying(255),
    isdn_charge character varying(255),
    source character varying(255),
    app_code smallint,
    language character varying(255),
    is_renew smallint DEFAULT 1 NOT NULL
);


ALTER TABLE subscriber.sub_package OWNER TO postgres;

--
-- Name: COLUMN sub_package.amt_call; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.amt_call IS 'tổng gọi ';


--
-- Name: COLUMN sub_package.amt_data; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.amt_data IS 'tổng data';


--
-- Name: COLUMN sub_package.amt_sms; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.amt_sms IS 'tổng tin nhắn';


--
-- Name: COLUMN sub_package.duration; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.duration IS 'tổng thời lượng';


--
-- Name: COLUMN sub_package.pack_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.pack_id IS 'id gói';


--
-- Name: COLUMN sub_package.voucher_code; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.voucher_code IS 'mã voucher';


--
-- Name: COLUMN sub_package.is_main; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.is_main IS '0 - gói cơ bản, 1 - gói chính, 2  - gói phụ';


--
-- Name: COLUMN sub_package.status; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.status IS '0 - chua thanh toan, 1 - active, 2 - xóa';


--
-- Name: COLUMN sub_package.isdn_charge; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.isdn_charge IS 'số điện thoại bị trừ tiền';


--
-- Name: COLUMN sub_package.source; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.source IS 'Nguồn thanh toán khi đăng ký gói ( tài khoản chính, ví, visa)';


--
-- Name: COLUMN sub_package.app_code; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.app_code IS '0 - reddi/ 1 - reddi_partner/ 2 - reddi_go/ 3 - webportal/ 4 - crm';


--
-- Name: COLUMN sub_package.language; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.language IS 'Ngôn ngữ của app vừa đăng ký gói cước';


--
-- Name: COLUMN sub_package.is_renew; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_package.is_renew IS '1 - Tự động gia hạn / 0 - Ko tự động gia hạn';


--
-- Name: sub_package_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_package_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_package_id_seq OWNER TO postgres;

--
-- Name: sub_package_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_package_id_seq OWNED BY subscriber.sub_package.id;


--
-- Name: sub_package_offer; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_package_offer (
    id bigint NOT NULL,
    created_at character varying(255),
    creator character varying(255),
    pack_id bigint,
    sub_id bigint
);


ALTER TABLE subscriber.sub_package_offer OWNER TO postgres;

--
-- Name: sub_package_offer_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_package_offer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_package_offer_id_seq OWNER TO postgres;

--
-- Name: sub_package_offer_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_package_offer_id_seq OWNED BY subscriber.sub_package_offer.id;


--
-- Name: sub_param; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_param (
    id bigint NOT NULL,
    description character varying(255),
    name character varying(255),
    type character varying(255),
    value character varying(255)
);


ALTER TABLE subscriber.sub_param OWNER TO postgres;

--
-- Name: sub_param_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_param_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_param_id_seq OWNER TO postgres;

--
-- Name: sub_param_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_param_id_seq OWNED BY subscriber.sub_param.id;


--
-- Name: sub_service; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_service (
    id bigint NOT NULL,
    duration bigint,
    expired_at character varying(255),
    price bigint,
    registered_at character varying(255),
    sub_id bigint,
    service_id bigint NOT NULL,
    creator character varying(255),
    shop_id bigint,
    sub_id_sent bigint,
    voucher_code character varying(255),
    reason character varying(255),
    reason_desc character varying(255),
    order_code character varying(255),
    status integer DEFAULT 0,
    real_price bigint,
    discount bigint,
    isdn_charge character varying(255),
    ocs_code character varying(255)
);


ALTER TABLE subscriber.sub_service OWNER TO postgres;

--
-- Name: COLUMN sub_service.sub_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_service.sub_id IS 'id người đăng ký';


--
-- Name: COLUMN sub_service.service_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_service.service_id IS 'id dịch vụ';


--
-- Name: COLUMN sub_service.shop_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_service.shop_id IS 'id cửa hàng';


--
-- Name: COLUMN sub_service.sub_id_sent; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_service.sub_id_sent IS 'id người gửi';


--
-- Name: COLUMN sub_service.voucher_code; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_service.voucher_code IS 'mã voucher';


--
-- Name: COLUMN sub_service.status; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_service.status IS '0 - chưa thanh toán, 1 - đã thanh toán , 2 - đã xóa';


--
-- Name: sub_service_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_service_his (
    id bigint NOT NULL,
    sub_service_id bigint,
    create_date timestamp without time zone,
    service_id bigint,
    status bigint
);


ALTER TABLE subscriber.sub_service_his OWNER TO postgres;

--
-- Name: COLUMN sub_service_his.id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_service_his.id IS 'id của bảng';


--
-- Name: COLUMN sub_service_his.sub_service_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_service_his.sub_service_id IS 'id dịch vụ đã được đăng ký cho thuê bao';


--
-- Name: COLUMN sub_service_his.create_date; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_service_his.create_date IS 'ngày lưu lịch sử';


--
-- Name: COLUMN sub_service_his.service_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_service_his.service_id IS 'id của dịch vụ';


--
-- Name: COLUMN sub_service_his.status; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_service_his.status IS 'trạng thái dịch vụ // 0 - Hủy // 1 - Đăng ký';


--
-- Name: sub_service_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_service_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_service_his_id_seq OWNER TO postgres;

--
-- Name: sub_service_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_service_his_id_seq OWNED BY subscriber.sub_service_his.id;


--
-- Name: sub_service_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_service_id_seq OWNER TO postgres;

--
-- Name: sub_service_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_service_id_seq OWNED BY subscriber.sub_service.id;


--
-- Name: sub_sms_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_sms_his (
    id bigint NOT NULL,
    content character varying(255),
    cost bigint,
    direct character varying(255),
    is_internal integer,
    num_of_msg bigint,
    phone character varying(255),
    sub_id bigint,
    "time" character varying(255),
    type character varying(255),
    type_account character varying(255),
    pack_id bigint
);


ALTER TABLE subscriber.sub_sms_his OWNER TO postgres;

--
-- Name: COLUMN sub_sms_his.content; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_sms_his.content IS 'nội dung';


--
-- Name: COLUMN sub_sms_his.cost; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_sms_his.cost IS 'phí';


--
-- Name: COLUMN sub_sms_his.direct; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_sms_his.direct IS 'địa chỉ tới';


--
-- Name: COLUMN sub_sms_his.is_internal; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_sms_his.is_internal IS 'nội mạng';


--
-- Name: COLUMN sub_sms_his.num_of_msg; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_sms_his.num_of_msg IS 'số tin nhắn';


--
-- Name: COLUMN sub_sms_his.phone; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_sms_his.phone IS 'số điện thoại';


--
-- Name: COLUMN sub_sms_his.sub_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_sms_his.sub_id IS 'id người đăng ký';


--
-- Name: COLUMN sub_sms_his.type_account; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_sms_his.type_account IS 'loại tài khoản';


--
-- Name: COLUMN sub_sms_his.pack_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.sub_sms_his.pack_id IS 'id gói cước ';


--
-- Name: sub_sms_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_sms_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_sms_his_id_seq OWNER TO postgres;

--
-- Name: sub_sms_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_sms_his_id_seq OWNED BY subscriber.sub_sms_his.id;


--
-- Name: sub_state; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_state (
    id bigint NOT NULL,
    sub_id bigint NOT NULL,
    k1 smallint DEFAULT 0,
    k2 smallint DEFAULT 0,
    k3 smallint DEFAULT 0,
    k4 smallint DEFAULT 0,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    k1_reason text,
    k2_reason text,
    k3_reason text
);


ALTER TABLE subscriber.sub_state OWNER TO postgres;

--
-- Name: sub_state_action_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_state_action_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_state_action_id_seq OWNER TO postgres;

--
-- Name: sub_state_action; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_state_action (
    id bigint DEFAULT nextval('subscriber.sub_state_action_id_seq'::regclass) NOT NULL,
    state character varying(3) NOT NULL,
    action_id bigint,
    enable boolean DEFAULT true
);


ALTER TABLE subscriber.sub_state_action OWNER TO postgres;

--
-- Name: sub_state_config_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_state_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_state_config_id_seq OWNER TO postgres;

--
-- Name: sub_state_config; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_state_config (
    id bigint DEFAULT nextval('subscriber.sub_state_config_id_seq'::regclass) NOT NULL,
    before_change character varying(10),
    after_change character varying(10),
    url_action character varying(100),
    state integer,
    before_change_desc character varying(255),
    after_change_desc character varying(255)
);


ALTER TABLE subscriber.sub_state_config OWNER TO postgres;

--
-- Name: sub_state_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_state_his (
    id bigint NOT NULL,
    sub_id bigint NOT NULL,
    before_change character varying(10) NOT NULL,
    after_change character varying(10) NOT NULL,
    change_time timestamp(6) without time zone,
    reason text,
    reason_id bigint,
    creator character varying(255),
    app_code character varying(10)
);


ALTER TABLE subscriber.sub_state_his OWNER TO postgres;

--
-- Name: sub_state_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_state_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_state_his_id_seq OWNER TO postgres;

--
-- Name: sub_state_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_state_his_id_seq OWNED BY subscriber.sub_state_his.id;


--
-- Name: sub_state_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_state_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_state_id_seq OWNER TO postgres;

--
-- Name: sub_state_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_state_id_seq OWNED BY subscriber.sub_state.id;


--
-- Name: sub_trans_his; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.sub_trans_his (
    id bigint NOT NULL,
    amount bigint,
    bal_after bigint,
    bal_before bigint,
    created_at character varying(255),
    description character varying(255),
    direct character varying(10),
    sub_id bigint,
    sub_received_id bigint,
    trans_id character varying(255)
);


ALTER TABLE subscriber.sub_trans_his OWNER TO postgres;

--
-- Name: sub_trans_his_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.sub_trans_his_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.sub_trans_his_id_seq OWNER TO postgres;

--
-- Name: sub_trans_his_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.sub_trans_his_id_seq OWNED BY subscriber.sub_trans_his.id;


--
-- Name: subscriber; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.subscriber (
    sub_id integer NOT NULL,
    activated_at character varying(255),
    call_direct character varying(255),
    created_at character varying(255),
    isdn character varying(255),
    m_main bigint,
    m_expired_at character varying(255),
    m_promotion bigint,
    sim_serial character varying(255),
    type character varying(255),
    cust_id bigint NOT NULL,
    status bigint NOT NULL,
    blocked_at character varying(255),
    call_in integer,
    call_out integer,
    amt_call_in bigint,
    amt_call_out bigint,
    amt_data bigint,
    amt_sms_in bigint,
    amt_sms_out bigint,
    main_pack_id bigint,
    sub_type bigint,
    sub_pakage_id bigint,
    update_at timestamp(6) without time zone,
    imei character varying(255),
    count_rekyc integer DEFAULT 0,
    last_update_user character varying(100),
    approve_date timestamp(6) without time zone,
    approve_user character varying(100),
    approve_status_id smallint,
    audit_status_id smallint,
    e_sim smallint DEFAULT 0,
    club_flag boolean
);


ALTER TABLE subscriber.subscriber OWNER TO postgres;

--
-- Name: COLUMN subscriber.activated_at; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.subscriber.activated_at IS 'ngày kích hoạt';


--
-- Name: COLUMN subscriber.isdn; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.subscriber.isdn IS 'số isdn';


--
-- Name: COLUMN subscriber.sim_serial; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.subscriber.sim_serial IS 'số serial sim';


--
-- Name: COLUMN subscriber.type; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.subscriber.type IS 'Thuê bao trả trước hoặc trả sau : PRE_PAID // POST_PAID';


--
-- Name: COLUMN subscriber.cust_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.subscriber.cust_id IS 'id khách hàng';


--
-- Name: COLUMN subscriber.blocked_at; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.subscriber.blocked_at IS 'thời điểm khóa';


--
-- Name: COLUMN subscriber.call_in; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.subscriber.call_in IS 'gọi tới';


--
-- Name: COLUMN subscriber.call_out; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.subscriber.call_out IS 'gọi đi';


--
-- Name: COLUMN subscriber.main_pack_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.subscriber.main_pack_id IS 'Gói cơ bản';


--
-- Name: COLUMN subscriber.sub_type; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.subscriber.sub_type IS '1- Thuê bao đặc biệt, 0 - Thuê bao thường';


--
-- Name: COLUMN subscriber.sub_pakage_id; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.subscriber.sub_pakage_id IS 'Gói phụ chính (gói chính)';


--
-- Name: COLUMN subscriber.e_sim; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.subscriber.e_sim IS '0 - Sim vật lý , 1 - eSIM';


--
-- Name: subscriber_config; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.subscriber_config (
    service_code character varying(255) NOT NULL,
    url character varying(1000),
    wscode character varying
);


ALTER TABLE subscriber.subscriber_config OWNER TO postgres;

--
-- Name: subscriber_ocs; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.subscriber_ocs (
    isdn character varying(255)
);


ALTER TABLE subscriber.subscriber_ocs OWNER TO postgres;

--
-- Name: subscriber_sub_id_seq; Type: SEQUENCE; Schema: subscriber; Owner: postgres
--

CREATE SEQUENCE subscriber.subscriber_sub_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber.subscriber_sub_id_seq OWNER TO postgres;

--
-- Name: subscriber_sub_id_seq; Type: SEQUENCE OWNED BY; Schema: subscriber; Owner: postgres
--

ALTER SEQUENCE subscriber.subscriber_sub_id_seq OWNED BY subscriber.subscriber.sub_id;


--
-- Name: transfer_money_config; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.transfer_money_config (
    id bigint NOT NULL,
    code character varying(255),
    fee double precision,
    fee_unit character varying(255),
    money_config bigint
);


ALTER TABLE subscriber.transfer_money_config OWNER TO postgres;

--
-- Name: COLUMN transfer_money_config.fee_unit; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.transfer_money_config.fee_unit IS 'PERCENT / VALUE';


--
-- Name: transfer_money_value; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.transfer_money_value (
    id integer NOT NULL,
    value character varying
);


ALTER TABLE subscriber.transfer_money_value OWNER TO postgres;

--
-- Name: vip_and_test; Type: TABLE; Schema: subscriber; Owner: postgres
--

CREATE TABLE subscriber.vip_and_test (
    msisdn character varying(10) NOT NULL,
    imsi character varying(15) NOT NULL,
    iccid character varying(20),
    a4ki character varying(255),
    note character varying(255)
);


ALTER TABLE subscriber.vip_and_test OWNER TO postgres;

--
-- Name: COLUMN vip_and_test.msisdn; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.vip_and_test.msisdn IS 'Số thuê bao';


--
-- Name: COLUMN vip_and_test.imsi; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.vip_and_test.imsi IS 'Imsi';


--
-- Name: COLUMN vip_and_test.iccid; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.vip_and_test.iccid IS 'Iccid';


--
-- Name: COLUMN vip_and_test.a4ki; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.vip_and_test.a4ki IS 'a4ki';


--
-- Name: COLUMN vip_and_test.note; Type: COMMENT; Schema: subscriber; Owner: postgres
--

COMMENT ON COLUMN subscriber.vip_and_test.note IS 'loại vip/test nào';


--
-- Name: account_his id; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.account_his ALTER COLUMN id SET DEFAULT nextval('account.account_his_id_seq'::regclass);


--
-- Name: account_his_detail id; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.account_his_detail ALTER COLUMN id SET DEFAULT nextval('account.account_his_detail_id_seq'::regclass);


--
-- Name: ag_chanel id; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_chanel ALTER COLUMN id SET DEFAULT nextval('account.ag_chanel_id_seq'::regclass);


--
-- Name: ag_map_app id; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_map_app ALTER COLUMN id SET DEFAULT nextval('account.ag_map_app_id_seq'::regclass);


--
-- Name: ag_user id; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user ALTER COLUMN id SET DEFAULT nextval('account.ag_user_id_seq'::regclass);


--
-- Name: ag_user_app_trial id; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_app_trial ALTER COLUMN id SET DEFAULT nextval('account.ag_user_app_trial_id_seq'::regclass);


--
-- Name: ag_user_role_trial id; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_role_trial ALTER COLUMN id SET DEFAULT nextval('account.ag_user_role_trial_id_seq'::regclass);


--
-- Name: ag_user_trial id; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_trial ALTER COLUMN id SET DEFAULT nextval('account.ag_user_trial_id_seq'::regclass);


--
-- Name: log_tracking_lock id; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.log_tracking_lock ALTER COLUMN id SET DEFAULT nextval('account.log_tracking_lock_id_seq'::regclass);


--
-- Name: log_transaction id; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.log_transaction ALTER COLUMN id SET DEFAULT nextval('account.log_transaction_id_seq'::regclass);


--
-- Name: log_update_ag_user id; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.log_update_ag_user ALTER COLUMN id SET DEFAULT nextval('account.log_update_ag_user_id_seq'::regclass);


--
-- Name: log_update_chanel id; Type: DEFAULT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.log_update_chanel ALTER COLUMN id SET DEFAULT nextval('account.log_update_chanel_id_seq'::regclass);


--
-- Name: category category_id; Type: DEFAULT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.category ALTER COLUMN category_id SET DEFAULT nextval('complain.category_category_id_seq'::regclass);


--
-- Name: complain_his_detail detail_id; Type: DEFAULT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.complain_his_detail ALTER COLUMN detail_id SET DEFAULT nextval('complain.complain_his_detail_detail_id_seq'::regclass);


--
-- Name: complain_history his_id; Type: DEFAULT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.complain_history ALTER COLUMN his_id SET DEFAULT nextval('complain.complain_history_his_id_seq'::regclass);


--
-- Name: complain_management complain_id; Type: DEFAULT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.complain_management ALTER COLUMN complain_id SET DEFAULT nextval('complain.complain_management_complain_id_seq'::regclass);


--
-- Name: happy_call id; Type: DEFAULT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.happy_call ALTER COLUMN id SET DEFAULT nextval('complain.happy_call_id_seq'::regclass);


--
-- Name: log_transaction id; Type: DEFAULT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.log_transaction ALTER COLUMN id SET DEFAULT nextval('complain.log_transaction_id_seq'::regclass);


--
-- Name: response response_id; Type: DEFAULT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.response ALTER COLUMN response_id SET DEFAULT nextval('complain.response_response_id_seq'::regclass);


--
-- Name: status status_id; Type: DEFAULT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.status ALTER COLUMN status_id SET DEFAULT nextval('complain.status_status_id_seq'::regclass);


--
-- Name: stringee_call id; Type: DEFAULT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.stringee_call ALTER COLUMN id SET DEFAULT nextval('complain.stringee_call_id_seq1'::regclass);


--
-- Name: account_type id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.account_type ALTER COLUMN id SET DEFAULT nextval('customer.account_type_id_seq'::regclass);


--
-- Name: action id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.action ALTER COLUMN id SET DEFAULT nextval('customer.action_id_seq'::regclass);


--
-- Name: call_log id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.call_log ALTER COLUMN id SET DEFAULT nextval('customer.call_log_id_seq'::regclass);


--
-- Name: charge_package_extend id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.charge_package_extend ALTER COLUMN id SET DEFAULT nextval('customer.charge_package_extend_id_seq'::regclass);


--
-- Name: cmp_service_log id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.cmp_service_log ALTER COLUMN id SET DEFAULT nextval('customer.cmp_service_log_id_seq'::regclass);


--
-- Name: customer cust_id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer ALTER COLUMN cust_id SET DEFAULT nextval('customer.customer_cust_id_seq'::regclass);


--
-- Name: customer_document cust_doc_id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_document ALTER COLUMN cust_doc_id SET DEFAULT nextval('customer.customer_document_cust_doc_id_seq'::regclass);


--
-- Name: customer_history cust_his_id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_history ALTER COLUMN cust_his_id SET DEFAULT nextval('customer.customer_history_cust_his_id_seq'::regclass);


--
-- Name: customer_history_detail id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_history_detail ALTER COLUMN id SET DEFAULT nextval('customer.customer_history_detail_id_seq'::regclass);


--
-- Name: customer_kyc_confidence id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_kyc_confidence ALTER COLUMN id SET DEFAULT nextval('customer.customer_kyc_confidence_id_seq'::regclass);


--
-- Name: customer_param id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_param ALTER COLUMN id SET DEFAULT nextval('customer.customer_param_id_seq'::regclass);


--
-- Name: customer_type cust_type_id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_type ALTER COLUMN cust_type_id SET DEFAULT nextval('customer.customer_type_cust_type_id_seq'::regclass);


--
-- Name: distribution_resource id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.distribution_resource ALTER COLUMN id SET DEFAULT nextval('customer.distribution_resource_id_seq'::regclass);


--
-- Name: kyc_job id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.kyc_job ALTER COLUMN id SET DEFAULT nextval('customer.kyc_job_id_seq'::regclass);


--
-- Name: kyc_job_log id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.kyc_job_log ALTER COLUMN id SET DEFAULT nextval('customer.kyc_job_log_id_seq'::regclass);


--
-- Name: log_transaction id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.log_transaction ALTER COLUMN id SET DEFAULT nextval('customer.log_transaction_id_seq'::regclass);


--
-- Name: package_vcm_send id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.package_vcm_send ALTER COLUMN id SET DEFAULT nextval('customer.package_vcm_send_id_seq'::regclass);


--
-- Name: permission id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.permission ALTER COLUMN id SET DEFAULT nextval('customer.permission_id_seq'::regclass);


--
-- Name: resources id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.resources ALTER COLUMN id SET DEFAULT nextval('customer.manage_resource_id_seq'::regclass);


--
-- Name: transaction_vcm_point id; Type: DEFAULT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.transaction_vcm_point ALTER COLUMN id SET DEFAULT nextval('customer.transaction_vcm_point_id_seq'::regclass);


--
-- Name: exp_table id; Type: DEFAULT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification.exp_table ALTER COLUMN id SET DEFAULT nextval('gamification.exp_table_id_seq'::regclass);


--
-- Name: log_transaction id; Type: DEFAULT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification.log_transaction ALTER COLUMN id SET DEFAULT nextval('gamification.log_transaction_id_seq'::regclass);


--
-- Name: reward id; Type: DEFAULT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification.reward ALTER COLUMN id SET DEFAULT nextval('gamification.reward_id_seq'::regclass);


--
-- Name: task id; Type: DEFAULT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification.task ALTER COLUMN id SET DEFAULT nextval('gamification.task_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification."user" ALTER COLUMN id SET DEFAULT nextval('gamification.user_id_seq'::regclass);


--
-- Name: user_task id; Type: DEFAULT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification.user_task ALTER COLUMN id SET DEFAULT nextval('gamification.user_task_id_seq'::regclass);


--
-- Name: log_detect_image id; Type: DEFAULT; Schema: log; Owner: postgres
--

ALTER TABLE ONLY log.log_detect_image ALTER COLUMN id SET DEFAULT nextval('log.log_detect_passport_id_seq'::regclass);


--
-- Name: log_transaction_customer id; Type: DEFAULT; Schema: log; Owner: postgres
--

ALTER TABLE ONLY log.log_transaction_customer ALTER COLUMN id SET DEFAULT nextval('log.log_transaction_customer_id_seq'::regclass);


--
-- Name: log_transaction_inventory id; Type: DEFAULT; Schema: log; Owner: postgres
--

ALTER TABLE ONLY log.log_transaction_inventory ALTER COLUMN id SET DEFAULT nextval('log.log_transaction_inventory_id_seq'::regclass);


--
-- Name: log_transaction_subscriber id; Type: DEFAULT; Schema: log; Owner: postgres
--

ALTER TABLE ONLY log.log_transaction_subscriber ALTER COLUMN id SET DEFAULT nextval('log.log_transaction_subscriber_id_seq'::regclass);


--
-- Name: callback_log id; Type: DEFAULT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.callback_log ALTER COLUMN id SET DEFAULT nextval('mnp.callback_log_id_seq'::regclass);


--
-- Name: option id; Type: DEFAULT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.option ALTER COLUMN id SET DEFAULT nextval('mnp.option_id_seq1'::regclass);


--
-- Name: registry_mnp id; Type: DEFAULT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.registry_mnp ALTER COLUMN id SET DEFAULT nextval('mnp.registry_mnp_id_seq'::regclass);


--
-- Name: black_list id; Type: DEFAULT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.black_list ALTER COLUMN id SET DEFAULT nextval('otp.black_list_id_seq'::regclass);


--
-- Name: check_otp_history id; Type: DEFAULT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.check_otp_history ALTER COLUMN id SET DEFAULT nextval('otp.check_otp_history_id_seq'::regclass);


--
-- Name: check_otp_mail_history id; Type: DEFAULT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.check_otp_mail_history ALTER COLUMN id SET DEFAULT nextval('otp.check_otp_mail_history_id_seq'::regclass);


--
-- Name: log_transaction id; Type: DEFAULT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.log_transaction ALTER COLUMN id SET DEFAULT nextval('otp.log_transaction_id_seq'::regclass);


--
-- Name: option id; Type: DEFAULT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.option ALTER COLUMN id SET DEFAULT nextval('otp.option_id_seq'::regclass);


--
-- Name: option_value id; Type: DEFAULT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.option_value ALTER COLUMN id SET DEFAULT nextval('otp.option_value_id_seq'::regclass);


--
-- Name: otp id; Type: DEFAULT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.otp ALTER COLUMN id SET DEFAULT nextval('otp.otp_id_seq'::regclass);


--
-- Name: otp_email id; Type: DEFAULT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.otp_email ALTER COLUMN id SET DEFAULT nextval('otp.otp_email_id_seq'::regclass);


--
-- Name: abc id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abc ALTER COLUMN id SET DEFAULT nextval('public.abc_id_seq'::regclass);


--
-- Name: scan_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_log ALTER COLUMN id SET DEFAULT nextval('public.scan_log_id_seq'::regclass);


--
-- Name: scan_log count_request; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_log ALTER COLUMN count_request SET DEFAULT nextval('public.scan_log_count_request_seq'::regclass);


--
-- Name: account_sub id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.account_sub ALTER COLUMN id SET DEFAULT nextval('subscriber.account_sub_id_seq'::regclass);


--
-- Name: advance_money_config id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.advance_money_config ALTER COLUMN id SET DEFAULT nextval('subscriber.advance_money_config_id_seq'::regclass);


--
-- Name: call_log id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.call_log ALTER COLUMN id SET DEFAULT nextval('subscriber.call_log_id_seq'::regclass);


--
-- Name: cmp_service_log id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.cmp_service_log ALTER COLUMN id SET DEFAULT nextval('subscriber.cmp_service_log_id_seq'::regclass);


--
-- Name: commitment_cycle id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.commitment_cycle ALTER COLUMN id SET DEFAULT nextval('subscriber.commitment_cycle_id_seq'::regclass);


--
-- Name: commitment_cycle_history his_id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.commitment_cycle_history ALTER COLUMN his_id SET DEFAULT nextval('subscriber.commitment_cycle_history_his_id_seq'::regclass);


--
-- Name: config_time_cancel id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.config_time_cancel ALTER COLUMN id SET DEFAULT nextval('subscriber.config_time_cancel_id_seq'::regclass);


--
-- Name: log_transaction id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.log_transaction ALTER COLUMN id SET DEFAULT nextval('subscriber.log_transaction_id_seq'::regclass);


--
-- Name: modify_resource_job id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.modify_resource_job ALTER COLUMN id SET DEFAULT nextval('subscriber.modify_resource_job_id_seq'::regclass);


--
-- Name: modify_resource_job_log id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.modify_resource_job_log ALTER COLUMN id SET DEFAULT nextval('subscriber.modify_resource_job_log_id_seq'::regclass);


--
-- Name: option id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.option ALTER COLUMN id SET DEFAULT nextval('subscriber.option_id_seq'::regclass);


--
-- Name: option_value id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.option_value ALTER COLUMN id SET DEFAULT nextval('subscriber.option_value_id_seq'::regclass);


--
-- Name: recharge_online_order order_id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.recharge_online_order ALTER COLUMN order_id SET DEFAULT nextval('subscriber.recharge_online_order_order_id_seq'::regclass);


--
-- Name: sub_activate_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_activate_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_activate_his_id_seq'::regclass);


--
-- Name: sub_approve_status id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_approve_status ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_approve_status_id_seq1'::regclass);


--
-- Name: sub_block_call_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_block_call_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_block_call_his_id_seq'::regclass);


--
-- Name: sub_change_owner_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_change_owner_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_change_owner_his_id_seq'::regclass);


--
-- Name: sub_change_sim_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_change_sim_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_change_sim_his_id_seq'::regclass);


--
-- Name: sub_charge_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_charge_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_charge_his_id_seq'::regclass);


--
-- Name: sub_contact_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_contact_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_contact_his_id_seq'::regclass);


--
-- Name: sub_data_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_data_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_data_his_id_seq'::regclass);


--
-- Name: sub_debt_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_debt_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_debt_his_id_seq'::regclass);


--
-- Name: sub_mod_expire_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_mod_expire_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_mod_expire_his_id_seq'::regclass);


--
-- Name: sub_mod_pack_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_mod_pack_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_mod_pack_his_id_seq'::regclass);


--
-- Name: sub_mod_resource_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_mod_resource_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_mod_resource_his_id_seq'::regclass);


--
-- Name: sub_package id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_package ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_package_id_seq'::regclass);


--
-- Name: sub_package_offer id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_package_offer ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_package_offer_id_seq'::regclass);


--
-- Name: sub_param id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_param ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_param_id_seq'::regclass);


--
-- Name: sub_service id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_service ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_service_id_seq'::regclass);


--
-- Name: sub_service_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_service_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_service_his_id_seq'::regclass);


--
-- Name: sub_sms_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_sms_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_sms_his_id_seq'::regclass);


--
-- Name: sub_state id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_state ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_state_id_seq'::regclass);


--
-- Name: sub_state_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_state_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_state_his_id_seq'::regclass);


--
-- Name: sub_trans_his id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_trans_his ALTER COLUMN id SET DEFAULT nextval('subscriber.sub_trans_his_id_seq'::regclass);


--
-- Name: subscriber sub_id; Type: DEFAULT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.subscriber ALTER COLUMN sub_id SET DEFAULT nextval('subscriber.subscriber_sub_id_seq'::regclass);


--
-- Name: account_his_detail account_his_detail_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.account_his_detail
    ADD CONSTRAINT account_his_detail_pkey PRIMARY KEY (id);


--
-- Name: account_his account_his_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.account_his
    ADD CONSTRAINT account_his_pkey PRIMARY KEY (id);


--
-- Name: ag_access_log ag_access_log_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_access_log
    ADD CONSTRAINT ag_access_log_pkey PRIMARY KEY (id);


--
-- Name: ag_action_log_detail ag_action_log_detail_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_action_log_detail
    ADD CONSTRAINT ag_action_log_detail_pkey PRIMARY KEY (id);


--
-- Name: ag_action_log ag_action_log_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_action_log
    ADD CONSTRAINT ag_action_log_pkey PRIMARY KEY (id);


--
-- Name: ag_api_resource_detail ag_api_resource_detail_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_api_resource_detail
    ADD CONSTRAINT ag_api_resource_detail_pkey PRIMARY KEY (id);


--
-- Name: ag_api_resource ag_api_resource_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_api_resource
    ADD CONSTRAINT ag_api_resource_pkey PRIMARY KEY (id);


--
-- Name: ag_app_function ag_app_function_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_app_function
    ADD CONSTRAINT ag_app_function_pkey PRIMARY KEY (id);


--
-- Name: ag_app_role ag_app_role_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_app_role
    ADD CONSTRAINT ag_app_role_pkey PRIMARY KEY (id);


--
-- Name: ag_application ag_application_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_application
    ADD CONSTRAINT ag_application_pkey PRIMARY KEY (id);


--
-- Name: ag_chanel ag_chanel_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_chanel
    ADD CONSTRAINT ag_chanel_pkey PRIMARY KEY (id);


--
-- Name: ag_domain ag_domain_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_domain
    ADD CONSTRAINT ag_domain_pkey PRIMARY KEY (id);


--
-- Name: ag_error_code ag_error_code_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_error_code
    ADD CONSTRAINT ag_error_code_pkey PRIMARY KEY (id);


--
-- Name: ag_function_api ag_function_api_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_function_api
    ADD CONSTRAINT ag_function_api_pkey PRIMARY KEY (id);


--
-- Name: ag_function ag_function_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_function
    ADD CONSTRAINT ag_function_pkey PRIMARY KEY (id);


--
-- Name: ag_log_transaction ag_log_transaction_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_log_transaction
    ADD CONSTRAINT ag_log_transaction_pkey PRIMARY KEY (id);


--
-- Name: ag_map_app ag_map_app_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_map_app
    ADD CONSTRAINT ag_map_app_pkey PRIMARY KEY (id);


--
-- Name: ag_prefix_domain ag_prefix_domain_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_prefix_domain
    ADD CONSTRAINT ag_prefix_domain_pkey PRIMARY KEY (id);


--
-- Name: ag_role_app ag_role_app_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_role_app
    ADD CONSTRAINT ag_role_app_pkey PRIMARY KEY (id);


--
-- Name: ag_role_function ag_role_function_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_role_function
    ADD CONSTRAINT ag_role_function_pkey PRIMARY KEY (id);


--
-- Name: ag_role ag_role_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_role
    ADD CONSTRAINT ag_role_pkey PRIMARY KEY (id);


--
-- Name: ag_system_user ag_system_user_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_system_user
    ADD CONSTRAINT ag_system_user_pkey PRIMARY KEY (id);


--
-- Name: ag_throttling ag_throttling_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_throttling
    ADD CONSTRAINT ag_throttling_pkey PRIMARY KEY (id);


--
-- Name: ag_user_app ag_user_app_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_app
    ADD CONSTRAINT ag_user_app_pkey PRIMARY KEY (id);


--
-- Name: ag_user_app_trial ag_user_app_trial_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_app_trial
    ADD CONSTRAINT ag_user_app_trial_pkey PRIMARY KEY (id);


--
-- Name: ag_user ag_user_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user
    ADD CONSTRAINT ag_user_pkey PRIMARY KEY (id);


--
-- Name: ag_user_role ag_user_role_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_role
    ADD CONSTRAINT ag_user_role_pkey PRIMARY KEY (id);


--
-- Name: ag_user_role_trial ag_user_role_trial_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_role_trial
    ADD CONSTRAINT ag_user_role_trial_pkey PRIMARY KEY (id);


--
-- Name: ag_user_trial ag_user_trial_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_trial
    ADD CONSTRAINT ag_user_trial_pkey PRIMARY KEY (id);


--
-- Name: log_login log_login_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.log_login
    ADD CONSTRAINT log_login_pkey PRIMARY KEY (id);


--
-- Name: log_tracking_lock log_tracking_lock_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.log_tracking_lock
    ADD CONSTRAINT log_tracking_lock_pkey PRIMARY KEY (id);


--
-- Name: log_transaction log_transaction_pkey; Type: CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.log_transaction
    ADD CONSTRAINT log_transaction_pkey PRIMARY KEY (id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_id);


--
-- Name: complain_his_detail complain_his_detail_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.complain_his_detail
    ADD CONSTRAINT complain_his_detail_pkey PRIMARY KEY (detail_id);


--
-- Name: complain_history complain_history_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.complain_history
    ADD CONSTRAINT complain_history_pkey PRIMARY KEY (his_id);


--
-- Name: complain_management complain_management_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.complain_management
    ADD CONSTRAINT complain_management_pkey PRIMARY KEY (complain_id);


--
-- Name: config_stringee config_stringee_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.config_stringee
    ADD CONSTRAINT config_stringee_pkey PRIMARY KEY (id);


--
-- Name: department_tmp department_tmp_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.department_tmp
    ADD CONSTRAINT department_tmp_pkey PRIMARY KEY (department_id);


--
-- Name: happy_call happy_call_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.happy_call
    ADD CONSTRAINT happy_call_pkey PRIMARY KEY (id);


--
-- Name: log_transaction log_transaction_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.log_transaction
    ADD CONSTRAINT log_transaction_pkey PRIMARY KEY (id);


--
-- Name: prioritize prioritize_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.prioritize
    ADD CONSTRAINT prioritize_pkey PRIMARY KEY (prioritize_id);


--
-- Name: response response_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.response
    ADD CONSTRAINT response_pkey PRIMARY KEY (response_id);


--
-- Name: source source_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.source
    ADD CONSTRAINT source_pkey PRIMARY KEY (source_id);


--
-- Name: staff_tmp staff_tmp_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.staff_tmp
    ADD CONSTRAINT staff_tmp_pkey PRIMARY KEY (staff_id);


--
-- Name: status_happy_call status_happy_call_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.status_happy_call
    ADD CONSTRAINT status_happy_call_pkey PRIMARY KEY (id);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (status_id);


--
-- Name: account_type account_type_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.account_type
    ADD CONSTRAINT account_type_pkey PRIMARY KEY (id);


--
-- Name: action action_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.action
    ADD CONSTRAINT action_pkey PRIMARY KEY (id);


--
-- Name: call_log call_log_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.call_log
    ADD CONSTRAINT call_log_pkey PRIMARY KEY (id);


--
-- Name: charge_package_extend charge_package_extend_pk; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.charge_package_extend
    ADD CONSTRAINT charge_package_extend_pk PRIMARY KEY (id);


--
-- Name: cmp_service_log cmp_service_log_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.cmp_service_log
    ADD CONSTRAINT cmp_service_log_pkey PRIMARY KEY (id);


--
-- Name: customer_account customer_account_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_account
    ADD CONSTRAINT customer_account_pkey PRIMARY KEY (account_id, cust_id);


--
-- Name: customer_config customer_config_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_config
    ADD CONSTRAINT customer_config_pkey PRIMARY KEY (config_id);


--
-- Name: customer_bk1009 customer_copy1_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_bk1009
    ADD CONSTRAINT customer_copy1_pkey PRIMARY KEY (cust_id);


--
-- Name: customer_document customer_document_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_document
    ADD CONSTRAINT customer_document_pkey PRIMARY KEY (cust_doc_id);


--
-- Name: customer_econtract customer_econtract_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_econtract
    ADD CONSTRAINT customer_econtract_pkey PRIMARY KEY (id);


--
-- Name: customer_history_detail customer_history_detail_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_history_detail
    ADD CONSTRAINT customer_history_detail_pkey PRIMARY KEY (id);


--
-- Name: customer_history customer_history_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_history
    ADD CONSTRAINT customer_history_pkey PRIMARY KEY (cust_his_id);


--
-- Name: customer_kyc_confidence customer_kyc_confidence_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_kyc_confidence
    ADD CONSTRAINT customer_kyc_confidence_pkey PRIMARY KEY (id);


--
-- Name: customer_param customer_param_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_param
    ADD CONSTRAINT customer_param_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (cust_id);


--
-- Name: customer_status customer_status_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_status
    ADD CONSTRAINT customer_status_pkey PRIMARY KEY (status_id);


--
-- Name: customer_type customer_type_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_type
    ADD CONSTRAINT customer_type_pkey PRIMARY KEY (cust_type_id);


--
-- Name: distribution_resource distribution_resource_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.distribution_resource
    ADD CONSTRAINT distribution_resource_pkey PRIMARY KEY (id);


--
-- Name: document_type document_type_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.document_type
    ADD CONSTRAINT document_type_pkey PRIMARY KEY (doc_type_id);


--
-- Name: kyc_job_log kyc_job_log_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.kyc_job_log
    ADD CONSTRAINT kyc_job_log_pkey PRIMARY KEY (id);


--
-- Name: kyc_job kyc_job_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.kyc_job
    ADD CONSTRAINT kyc_job_pkey PRIMARY KEY (id);


--
-- Name: log_transaction log_transaction_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.log_transaction
    ADD CONSTRAINT log_transaction_pkey PRIMARY KEY (id);


--
-- Name: resources manage_resource_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.resources
    ADD CONSTRAINT manage_resource_pkey PRIMARY KEY (id);


--
-- Name: package_vcm_send package_vcm_send_pk; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.package_vcm_send
    ADD CONSTRAINT package_vcm_send_pk PRIMARY KEY (id);


--
-- Name: permission permission_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (id);


--
-- Name: role_account role_account_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.role_account
    ADD CONSTRAINT role_account_pkey PRIMARY KEY (role_id);


--
-- Name: role_permission role_permission_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.role_permission
    ADD CONSTRAINT role_permission_pkey PRIMARY KEY (action_id, permission_id, role_id);


--
-- Name: role_resource role_resource_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.role_resource
    ADD CONSTRAINT role_resource_pkey PRIMARY KEY (cust_id, role_id);


--
-- Name: status_account_customer status_account_customer_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.status_account_customer
    ADD CONSTRAINT status_account_customer_pkey PRIMARY KEY (status_id);


--
-- Name: transaction_vcm_point transaction_vcm_point_pk; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.transaction_vcm_point
    ADD CONSTRAINT transaction_vcm_point_pk PRIMARY KEY (id);


--
-- Name: transfer_money_config transfer_money_config_pkey; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.transfer_money_config
    ADD CONSTRAINT transfer_money_config_pkey PRIMARY KEY (id);


--
-- Name: task PK_3c16f8c88e14bef92f3c6431499; Type: CONSTRAINT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification.task
    ADD CONSTRAINT "PK_3c16f8c88e14bef92f3c6431499" PRIMARY KEY (id);


--
-- Name: reward PK_6c4621656bcb6967dcc5792a33c; Type: CONSTRAINT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification.reward
    ADD CONSTRAINT "PK_6c4621656bcb6967dcc5792a33c" PRIMARY KEY (id);


--
-- Name: user_task PK_7dde5716a748e33ffaa7f5d53a4; Type: CONSTRAINT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification.user_task
    ADD CONSTRAINT "PK_7dde5716a748e33ffaa7f5d53a4" PRIMARY KEY (id);


--
-- Name: exp_table PK_d6fd27ab3413db19e8838c344bd; Type: CONSTRAINT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification.exp_table
    ADD CONSTRAINT "PK_d6fd27ab3413db19e8838c344bd" PRIMARY KEY (id);


--
-- Name: log_transaction PK_d7fb0b51ad33a7666e957662dc7; Type: CONSTRAINT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification.log_transaction
    ADD CONSTRAINT "PK_d7fb0b51ad33a7666e957662dc7" PRIMARY KEY (id);


--
-- Name: user PK_f1b67c9ddd06d97a81a91e2ea75; Type: CONSTRAINT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification."user"
    ADD CONSTRAINT "PK_f1b67c9ddd06d97a81a91e2ea75" PRIMARY KEY (id);


--
-- Name: log_detect_image log_detect_passport_pkey; Type: CONSTRAINT; Schema: log; Owner: postgres
--

ALTER TABLE ONLY log.log_detect_image
    ADD CONSTRAINT log_detect_passport_pkey PRIMARY KEY (id);


--
-- Name: log_transaction_customer log_transaction_customer_pkey; Type: CONSTRAINT; Schema: log; Owner: postgres
--

ALTER TABLE ONLY log.log_transaction_customer
    ADD CONSTRAINT log_transaction_customer_pkey PRIMARY KEY (id);


--
-- Name: log_transaction_inventory log_transaction_inventory_pkey; Type: CONSTRAINT; Schema: log; Owner: postgres
--

ALTER TABLE ONLY log.log_transaction_inventory
    ADD CONSTRAINT log_transaction_inventory_pkey PRIMARY KEY (id);


--
-- Name: log_transaction_subscriber log_transaction_subscriber_pkey; Type: CONSTRAINT; Schema: log; Owner: postgres
--

ALTER TABLE ONLY log.log_transaction_subscriber
    ADD CONSTRAINT log_transaction_subscriber_pkey PRIMARY KEY (id);


--
-- Name: callback_log callback_log_pkey; Type: CONSTRAINT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.callback_log
    ADD CONSTRAINT callback_log_pkey PRIMARY KEY (id);


--
-- Name: cancel_request_info cancel_request_info_pkey; Type: CONSTRAINT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.cancel_request_info
    ADD CONSTRAINT cancel_request_info_pkey PRIMARY KEY (id);


--
-- Name: document document_pkey; Type: CONSTRAINT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.document
    ADD CONSTRAINT document_pkey PRIMARY KEY (id);


--
-- Name: mnp_call_log mnp_call_log_pkey; Type: CONSTRAINT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.mnp_call_log
    ADD CONSTRAINT mnp_call_log_pkey PRIMARY KEY (id);


--
-- Name: option option_pkey; Type: CONSTRAINT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.option
    ADD CONSTRAINT option_pkey PRIMARY KEY (id);


--
-- Name: registry_mnp registry_mnp_pkey; Type: CONSTRAINT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.registry_mnp
    ADD CONSTRAINT registry_mnp_pkey PRIMARY KEY (id);


--
-- Name: representative_info representative_info_pkey; Type: CONSTRAINT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.representative_info
    ADD CONSTRAINT representative_info_pkey PRIMARY KEY (id);


--
-- Name: request_mnp request_mnp_pkey; Type: CONSTRAINT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.request_mnp
    ADD CONSTRAINT request_mnp_pkey PRIMARY KEY (id);


--
-- Name: request_mnp_tracking request_mnp_tracking_pkey; Type: CONSTRAINT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.request_mnp_tracking
    ADD CONSTRAINT request_mnp_tracking_pkey PRIMARY KEY (id);


--
-- Name: sub_mnp_info sub_mnp_info_pkey; Type: CONSTRAINT; Schema: mnp; Owner: postgres
--

ALTER TABLE ONLY mnp.sub_mnp_info
    ADD CONSTRAINT sub_mnp_info_pkey PRIMARY KEY (id);


--
-- Name: black_list black_list_pkey; Type: CONSTRAINT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.black_list
    ADD CONSTRAINT black_list_pkey PRIMARY KEY (id);


--
-- Name: check_otp_history check_otp_history_pkey; Type: CONSTRAINT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.check_otp_history
    ADD CONSTRAINT check_otp_history_pkey PRIMARY KEY (id);


--
-- Name: check_otp_mail_history check_otp_mail_history_pkey; Type: CONSTRAINT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.check_otp_mail_history
    ADD CONSTRAINT check_otp_mail_history_pkey PRIMARY KEY (id);


--
-- Name: code_message code_message_pkey; Type: CONSTRAINT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.code_message
    ADD CONSTRAINT code_message_pkey PRIMARY KEY (id);


--
-- Name: log_transaction log_transaction_pkey; Type: CONSTRAINT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.log_transaction
    ADD CONSTRAINT log_transaction_pkey PRIMARY KEY (id);


--
-- Name: option option_pkey; Type: CONSTRAINT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.option
    ADD CONSTRAINT option_pkey PRIMARY KEY (id);


--
-- Name: otp_code otp_code_pkey; Type: CONSTRAINT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.otp_code
    ADD CONSTRAINT otp_code_pkey PRIMARY KEY (id);


--
-- Name: otp_email otp_email_pkey; Type: CONSTRAINT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.otp_email
    ADD CONSTRAINT otp_email_pkey PRIMARY KEY (id);


--
-- Name: otp otp_pkey; Type: CONSTRAINT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.otp
    ADD CONSTRAINT otp_pkey PRIMARY KEY (id);


--
-- Name: check_otp_mail_history unique_email_action; Type: CONSTRAINT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.check_otp_mail_history
    ADD CONSTRAINT unique_email_action UNIQUE (email, action);


--
-- Name: check_otp_history unique_isdn_action; Type: CONSTRAINT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.check_otp_history
    ADD CONSTRAINT unique_isdn_action UNIQUE (isdn, action);


--
-- Name: black_list unique_isdn_action_black_list; Type: CONSTRAINT; Schema: otp; Owner: postgres
--

ALTER TABLE ONLY otp.black_list
    ADD CONSTRAINT unique_isdn_action_black_list UNIQUE (isdn, action);


--
-- Name: abc abc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abc
    ADD CONSTRAINT abc_pkey PRIMARY KEY (id);


--
-- Name: ag_api_resource ag_api_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ag_api_resource
    ADD CONSTRAINT ag_api_resource_pkey PRIMARY KEY (id);


--
-- Name: custommerdfsdfsdf custommerdfsdfsdf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custommerdfsdfsdf
    ADD CONSTRAINT custommerdfsdfsdf_pkey PRIMARY KEY (id);


--
-- Name: ids ids_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ids
    ADD CONSTRAINT ids_pkey PRIMARY KEY (id);


--
-- Name: scan_log scan_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_log
    ADD CONSTRAINT scan_log_pkey PRIMARY KEY (id);


--
-- Name: retail_order_retail_order_tracking uk_n96rt3i5oxqd8wcci9arfyaio; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retail_order_retail_order_tracking
    ADD CONSTRAINT uk_n96rt3i5oxqd8wcci9arfyaio UNIQUE (tracking_id);


--
-- Name: account_sub account_sub_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.account_sub
    ADD CONSTRAINT account_sub_pkey PRIMARY KEY (id);


--
-- Name: advance_money_config advance_money_config_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.advance_money_config
    ADD CONSTRAINT advance_money_config_pkey PRIMARY KEY (id);


--
-- Name: call_log call_log_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.call_log
    ADD CONSTRAINT call_log_pkey PRIMARY KEY (id);


--
-- Name: cmp_service_log cmp_service_log_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.cmp_service_log
    ADD CONSTRAINT cmp_service_log_pkey PRIMARY KEY (id);


--
-- Name: commitment_cycle_history commitment_cycle_copy1_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.commitment_cycle_history
    ADD CONSTRAINT commitment_cycle_copy1_pkey PRIMARY KEY (his_id);


--
-- Name: commitment_cycle commitment_cycle_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.commitment_cycle
    ADD CONSTRAINT commitment_cycle_pkey PRIMARY KEY (id);


--
-- Name: config_cash_advance config_cash_advance_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.config_cash_advance
    ADD CONSTRAINT config_cash_advance_pkey PRIMARY KEY (id);


--
-- Name: config_time_cancel config_time_cancel_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.config_time_cancel
    ADD CONSTRAINT config_time_cancel_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (cust_id);


--
-- Name: log_transaction log_transaction_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.log_transaction
    ADD CONSTRAINT log_transaction_pkey PRIMARY KEY (id);


--
-- Name: modify_resource_job_log modify_resource_job_log_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.modify_resource_job_log
    ADD CONSTRAINT modify_resource_job_log_pkey PRIMARY KEY (id);


--
-- Name: modify_resource_job modify_resource_job_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.modify_resource_job
    ADD CONSTRAINT modify_resource_job_pkey PRIMARY KEY (id);


--
-- Name: option option_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.option
    ADD CONSTRAINT option_pkey PRIMARY KEY (id);


--
-- Name: option_value option_value_pk; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.option_value
    ADD CONSTRAINT option_value_pk PRIMARY KEY (id);


--
-- Name: recharge_online_order recharge_online_order_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.recharge_online_order
    ADD CONSTRAINT recharge_online_order_pkey PRIMARY KEY (order_id);


--
-- Name: sub_action sub_action_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_action
    ADD CONSTRAINT sub_action_pkey PRIMARY KEY (action_id);


--
-- Name: sub_activate_his sub_activate_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_activate_his
    ADD CONSTRAINT sub_activate_his_pkey PRIMARY KEY (id);


--
-- Name: sub_approve_status sub_approve_status_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_approve_status
    ADD CONSTRAINT sub_approve_status_pkey PRIMARY KEY (id);


--
-- Name: sub_block_call_his sub_block_call_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_block_call_his
    ADD CONSTRAINT sub_block_call_his_pkey PRIMARY KEY (id);


--
-- Name: sub_change_owner_his sub_change_owner_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_change_owner_his
    ADD CONSTRAINT sub_change_owner_his_pkey PRIMARY KEY (id);


--
-- Name: sub_change_sim_his sub_change_sim_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_change_sim_his
    ADD CONSTRAINT sub_change_sim_his_pkey PRIMARY KEY (id);


--
-- Name: sub_charge_his sub_charge_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_charge_his
    ADD CONSTRAINT sub_charge_his_pkey PRIMARY KEY (id);


--
-- Name: sub_contact_his sub_contact_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_contact_his
    ADD CONSTRAINT sub_contact_his_pkey PRIMARY KEY (id);


--
-- Name: sub_data_his sub_data_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_data_his
    ADD CONSTRAINT sub_data_his_pkey PRIMARY KEY (id);


--
-- Name: sub_debt_his sub_debt_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_debt_his
    ADD CONSTRAINT sub_debt_his_pkey PRIMARY KEY (id);


--
-- Name: sub_mod_expire_his sub_mod_expire_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_mod_expire_his
    ADD CONSTRAINT sub_mod_expire_his_pkey PRIMARY KEY (id);


--
-- Name: sub_mod_pack_his sub_mod_pack_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_mod_pack_his
    ADD CONSTRAINT sub_mod_pack_his_pkey PRIMARY KEY (id);


--
-- Name: sub_mod_resource_his sub_mod_resource_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_mod_resource_his
    ADD CONSTRAINT sub_mod_resource_his_pkey PRIMARY KEY (id);


--
-- Name: sub_package_offer sub_package_offer_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_package_offer
    ADD CONSTRAINT sub_package_offer_pkey PRIMARY KEY (id);


--
-- Name: sub_package sub_package_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_package
    ADD CONSTRAINT sub_package_pkey PRIMARY KEY (id);


--
-- Name: sub_param sub_param_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_param
    ADD CONSTRAINT sub_param_pkey PRIMARY KEY (id);


--
-- Name: sub_service_his sub_service_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_service_his
    ADD CONSTRAINT sub_service_his_pkey PRIMARY KEY (id);


--
-- Name: sub_service sub_service_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_service
    ADD CONSTRAINT sub_service_pkey PRIMARY KEY (id);


--
-- Name: sub_sms_his sub_sms_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_sms_his
    ADD CONSTRAINT sub_sms_his_pkey PRIMARY KEY (id);


--
-- Name: sub_state_action sub_state_action_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_state_action
    ADD CONSTRAINT sub_state_action_pkey PRIMARY KEY (id);


--
-- Name: sub_state_config sub_state_config_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_state_config
    ADD CONSTRAINT sub_state_config_pkey PRIMARY KEY (id);


--
-- Name: sub_state_his sub_state_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_state_his
    ADD CONSTRAINT sub_state_his_pkey PRIMARY KEY (id);


--
-- Name: sub_state sub_state_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_state
    ADD CONSTRAINT sub_state_pkey PRIMARY KEY (id);


--
-- Name: sub_trans_his sub_trans_his_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_trans_his
    ADD CONSTRAINT sub_trans_his_pkey PRIMARY KEY (id);


--
-- Name: subscriber subscriber_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.subscriber
    ADD CONSTRAINT subscriber_pkey PRIMARY KEY (sub_id);


--
-- Name: transfer_money_config transfer_money_config_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.transfer_money_config
    ADD CONSTRAINT transfer_money_config_pkey PRIMARY KEY (id);


--
-- Name: vip_and_test vip_and_test_pkey; Type: CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.vip_and_test
    ADD CONSTRAINT vip_and_test_pkey PRIMARY KEY (msisdn);


--
-- Name: ag_chanel_user_name_idx; Type: INDEX; Schema: account; Owner: postgres
--

CREATE INDEX ag_chanel_user_name_idx ON account.ag_chanel USING btree (user_name);


--
-- Name: ag_function_api_ag_function_id_idx; Type: INDEX; Schema: account; Owner: postgres
--

CREATE INDEX ag_function_api_ag_function_id_idx ON account.ag_function_api USING btree (ag_function_id);


--
-- Name: ag_role_function_ag_role_id_idx; Type: INDEX; Schema: account; Owner: postgres
--

CREATE INDEX ag_role_function_ag_role_id_idx ON account.ag_role_function USING btree (ag_role_id);


--
-- Name: ag_system_user_ag_domain_id_idx; Type: INDEX; Schema: account; Owner: postgres
--

CREATE INDEX ag_system_user_ag_domain_id_idx ON account.ag_system_user USING btree (ag_domain_id);


--
-- Name: ag_user_app_ag_application_id_idx; Type: INDEX; Schema: account; Owner: postgres
--

CREATE INDEX ag_user_app_ag_application_id_idx ON account.ag_user_app USING btree (ag_application_id);


--
-- Name: ag_user_app_ag_user_id_idx; Type: INDEX; Schema: account; Owner: postgres
--

CREATE INDEX ag_user_app_ag_user_id_idx ON account.ag_user_app USING btree (ag_user_id);


--
-- Name: ag_user_role_ag_user_id_idx; Type: INDEX; Schema: account; Owner: postgres
--

CREATE INDEX ag_user_role_ag_user_id_idx ON account.ag_user_role USING btree (ag_user_id);


--
-- Name: charge_package_extend_id_idx; Type: INDEX; Schema: customer; Owner: postgres
--

CREATE INDEX charge_package_extend_id_idx ON customer.charge_package_extend USING btree (id);


--
-- Name: package_vcm_send_id_idx; Type: INDEX; Schema: customer; Owner: postgres
--

CREATE INDEX package_vcm_send_id_idx ON customer.package_vcm_send USING btree (id);


--
-- Name: transaction_vcm_point_id_idx; Type: INDEX; Schema: customer; Owner: postgres
--

CREATE INDEX transaction_vcm_point_id_idx ON customer.transaction_vcm_point USING btree (id);


--
-- Name: sub_state_sub_id_idx; Type: INDEX; Schema: subscriber; Owner: postgres
--

CREATE UNIQUE INDEX sub_state_sub_id_idx ON subscriber.sub_state USING btree (sub_id);


--
-- Name: ag_chanel log_changed_status; Type: TRIGGER; Schema: account; Owner: postgres
--

CREATE TRIGGER log_changed_status AFTER UPDATE ON account.ag_chanel FOR EACH ROW EXECUTE FUNCTION account.log_change_chanel();


--
-- Name: ag_user log_update_ag_user; Type: TRIGGER; Schema: account; Owner: postgres
--

CREATE TRIGGER log_update_ag_user AFTER UPDATE ON account.ag_user FOR EACH ROW WHEN ((old.status <> new.status)) EXECUTE FUNCTION account.log_change_ag_user();


--
-- Name: ag_user_app ag_user_app_fk; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_app
    ADD CONSTRAINT ag_user_app_fk FOREIGN KEY (ag_system_user_id) REFERENCES account.ag_system_user(id);


--
-- Name: ag_user_role ag_user_role_fk; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_role
    ADD CONSTRAINT ag_user_role_fk FOREIGN KEY (ag_system_user_id) REFERENCES account.ag_system_user(id);


--
-- Name: ag_prefix_domain fk1ec91ab87b806262; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_prefix_domain
    ADD CONSTRAINT fk1ec91ab87b806262 FOREIGN KEY (ag_domain_id) REFERENCES account.ag_domain(id);


--
-- Name: account_his_detail fk261of3vaopy5lvjis06xisl16; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.account_his_detail
    ADD CONSTRAINT fk261of3vaopy5lvjis06xisl16 FOREIGN KEY (his_id) REFERENCES account.account_his(id);


--
-- Name: ag_chanel fk49ce2db21b93db02; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_chanel
    ADD CONSTRAINT fk49ce2db21b93db02 FOREIGN KEY (ag_user_id) REFERENCES account.ag_user(id);


--
-- Name: ag_function_api fk626d3cac31b7efe2; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_function_api
    ADD CONSTRAINT fk626d3cac31b7efe2 FOREIGN KEY (ag_function_id) REFERENCES account.ag_function(id);


--
-- Name: ag_function_api fk626d3cac480c5b15; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_function_api
    ADD CONSTRAINT fk626d3cac480c5b15 FOREIGN KEY (ag_api_resource_id) REFERENCES account.ag_api_resource(id);


--
-- Name: ag_role_function fk8663ed2831b7efe2; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_role_function
    ADD CONSTRAINT fk8663ed2831b7efe2 FOREIGN KEY (ag_function_id) REFERENCES account.ag_function(id);


--
-- Name: ag_role_function fk8663ed2876691722; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_role_function
    ADD CONSTRAINT fk8663ed2876691722 FOREIGN KEY (ag_role_id) REFERENCES account.ag_role(id);


--
-- Name: ag_user_role fk8dd083911b93db02; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_role
    ADD CONSTRAINT fk8dd083911b93db02 FOREIGN KEY (ag_user_id) REFERENCES account.ag_user(id);


--
-- Name: ag_user_role fk8dd0839176691722; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_role
    ADD CONSTRAINT fk8dd0839176691722 FOREIGN KEY (ag_role_id) REFERENCES account.ag_role(id);


--
-- Name: ag_user_app_trial fk_user_app_trial_user; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_app_trial
    ADD CONSTRAINT fk_user_app_trial_user FOREIGN KEY (ag_user_trial_id) REFERENCES account.ag_user_trial(id);


--
-- Name: ag_user_app_trial fk_user_app_triall_application; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_app_trial
    ADD CONSTRAINT fk_user_app_triall_application FOREIGN KEY (ag_application_id) REFERENCES account.ag_application(id);


--
-- Name: ag_user_role_trial fk_user_role_trial_role; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_role_trial
    ADD CONSTRAINT fk_user_role_trial_role FOREIGN KEY (ag_role_id) REFERENCES account.ag_role(id);


--
-- Name: ag_user_role_trial fk_user_role_trial_user; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_role_trial
    ADD CONSTRAINT fk_user_role_trial_user FOREIGN KEY (ag_user_trial_id) REFERENCES account.ag_user_trial(id);


--
-- Name: ag_api_resource fka08d040cd15ca782; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_api_resource
    ADD CONSTRAINT fka08d040cd15ca782 FOREIGN KEY (ag_throttling_id) REFERENCES account.ag_throttling(id);


--
-- Name: ag_role_app fka9ba6ed176691722; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_role_app
    ADD CONSTRAINT fka9ba6ed176691722 FOREIGN KEY (ag_role_id) REFERENCES account.ag_role(id);


--
-- Name: ag_role_app fka9ba6ed17de59192; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_role_app
    ADD CONSTRAINT fka9ba6ed17de59192 FOREIGN KEY (ag_application_id) REFERENCES account.ag_application(id);


--
-- Name: ag_user_app fka9bc27a61b93db02; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_app
    ADD CONSTRAINT fka9bc27a61b93db02 FOREIGN KEY (ag_user_id) REFERENCES account.ag_user(id);


--
-- Name: ag_user_app fka9bc27a67de59192; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user_app
    ADD CONSTRAINT fka9bc27a67de59192 FOREIGN KEY (ag_application_id) REFERENCES account.ag_application(id);


--
-- Name: ag_system_user fkb2d99427b806262; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_system_user
    ADD CONSTRAINT fkb2d99427b806262 FOREIGN KEY (ag_domain_id) REFERENCES account.ag_domain(id);


--
-- Name: ag_app_function fkb532cbaf31b7efe2; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_app_function
    ADD CONSTRAINT fkb532cbaf31b7efe2 FOREIGN KEY (ag_function_id) REFERENCES account.ag_function(id);


--
-- Name: ag_app_function fkb532cbaf7de59192; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_app_function
    ADD CONSTRAINT fkb532cbaf7de59192 FOREIGN KEY (ag_application_id) REFERENCES account.ag_application(id);


--
-- Name: ag_user fkc07140447b806262; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_user
    ADD CONSTRAINT fkc07140447b806262 FOREIGN KEY (ag_domain_id) REFERENCES account.ag_domain(id);


--
-- Name: ag_api_resource_detail fkcbeeabe4480c5b15; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_api_resource_detail
    ADD CONSTRAINT fkcbeeabe4480c5b15 FOREIGN KEY (ag_api_resource_id) REFERENCES account.ag_api_resource(id);


--
-- Name: ag_log_transaction fkcdc0644a480c5b15; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_log_transaction
    ADD CONSTRAINT fkcdc0644a480c5b15 FOREIGN KEY (ag_api_resource_id) REFERENCES account.ag_api_resource(id);


--
-- Name: ag_log_transaction fkcdc0644a7b806262; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_log_transaction
    ADD CONSTRAINT fkcdc0644a7b806262 FOREIGN KEY (ag_domain_id) REFERENCES account.ag_domain(id);


--
-- Name: ag_log_transaction fkcdc0644a7de59192; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_log_transaction
    ADD CONSTRAINT fkcdc0644a7de59192 FOREIGN KEY (ag_application_id) REFERENCES account.ag_application(id);


--
-- Name: ag_action_log_detail fkd4a6f7c7773d753; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_action_log_detail
    ADD CONSTRAINT fkd4a6f7c7773d753 FOREIGN KEY (ag_action_log_id) REFERENCES account.ag_action_log(id);


--
-- Name: account_his fkelae3h5xw64qfgwp714wwqnhg; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.account_his
    ADD CONSTRAINT fkelae3h5xw64qfgwp714wwqnhg FOREIGN KEY (account_id) REFERENCES account.ag_user(id);


--
-- Name: ag_map_app fkf5d06da51a64f664; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_map_app
    ADD CONSTRAINT fkf5d06da51a64f664 FOREIGN KEY (ag_app_map_id) REFERENCES account.ag_application(id);


--
-- Name: ag_map_app fkf5d06da566ffe821; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_map_app
    ADD CONSTRAINT fkf5d06da566ffe821 FOREIGN KEY (ag_app_id) REFERENCES account.ag_application(id);


--
-- Name: ag_app_role fkff345bcd76691722; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_app_role
    ADD CONSTRAINT fkff345bcd76691722 FOREIGN KEY (ag_role_id) REFERENCES account.ag_role(id);


--
-- Name: ag_app_role fkff345bcd7de59192; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.ag_app_role
    ADD CONSTRAINT fkff345bcd7de59192 FOREIGN KEY (ag_application_id) REFERENCES account.ag_application(id);


--
-- Name: account_his fksnvr3qapcs5whkfyoh8d9rdyc; Type: FK CONSTRAINT; Schema: account; Owner: postgres
--

ALTER TABLE ONLY account.account_his
    ADD CONSTRAINT fksnvr3qapcs5whkfyoh8d9rdyc FOREIGN KEY (chanel_id) REFERENCES account.ag_chanel(id);


--
-- Name: complain_management complain-department-fk; Type: FK CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.complain_management
    ADD CONSTRAINT "complain-department-fk" FOREIGN KEY (department_handling) REFERENCES complain.department_tmp(department_id);


--
-- Name: complain_management complain-staff-handle-fk; Type: FK CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.complain_management
    ADD CONSTRAINT "complain-staff-handle-fk" FOREIGN KEY (staff_hadling) REFERENCES complain.staff_tmp(staff_id);


--
-- Name: staff_tmp department_staff_fk; Type: FK CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.staff_tmp
    ADD CONSTRAINT department_staff_fk FOREIGN KEY (department_id) REFERENCES complain.department_tmp(department_id);


--
-- Name: complain_management fk11scja8yysagjx1866t3k1vyk; Type: FK CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.complain_management
    ADD CONSTRAINT fk11scja8yysagjx1866t3k1vyk FOREIGN KEY (status_id) REFERENCES complain.status(status_id);


--
-- Name: complain_his_detail fk2m4n3osjyw195laf9uyjhm6ir; Type: FK CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.complain_his_detail
    ADD CONSTRAINT fk2m4n3osjyw195laf9uyjhm6ir FOREIGN KEY (his_id) REFERENCES complain.complain_history(his_id);


--
-- Name: complain_management fk45dgte663xfvyg3382doyt0q9; Type: FK CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.complain_management
    ADD CONSTRAINT fk45dgte663xfvyg3382doyt0q9 FOREIGN KEY (category_id) REFERENCES complain.category(category_id);


--
-- Name: response fkdmrf63ednf0invnj6qcxnapky; Type: FK CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.response
    ADD CONSTRAINT fkdmrf63ednf0invnj6qcxnapky FOREIGN KEY (complain_id) REFERENCES complain.complain_management(complain_id);


--
-- Name: complain_history fksjlyqjmj191g8y6s8mpph5213; Type: FK CONSTRAINT; Schema: complain; Owner: postgres
--

ALTER TABLE ONLY complain.complain_history
    ADD CONSTRAINT fksjlyqjmj191g8y6s8mpph5213 FOREIGN KEY (complain_id) REFERENCES complain.complain_management(complain_id);


--
-- Name: customer_bk1009 customer_copy1_cust_type_fkey; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_bk1009
    ADD CONSTRAINT customer_copy1_cust_type_fkey FOREIGN KEY (cust_type) REFERENCES customer.customer_type(cust_type_id);


--
-- Name: customer_bk1009 customer_copy1_status_id_fkey; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_bk1009
    ADD CONSTRAINT customer_copy1_status_id_fkey FOREIGN KEY (status_id) REFERENCES customer.customer_status(status_id);


--
-- Name: customer fk5egfwg6tqtw593eq629upbyjv; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer
    ADD CONSTRAINT fk5egfwg6tqtw593eq629upbyjv FOREIGN KEY (status_id) REFERENCES customer.customer_status(status_id);


--
-- Name: distribution_resource fk744dh28c8pebhbokc67jv3y5i; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.distribution_resource
    ADD CONSTRAINT fk744dh28c8pebhbokc67jv3y5i FOREIGN KEY (created_by) REFERENCES customer.customer(cust_id);


--
-- Name: customer_document fk9xmo78p6i51xlp2lclo7kme8y; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_document
    ADD CONSTRAINT fk9xmo78p6i51xlp2lclo7kme8y FOREIGN KEY (doc_type_id) REFERENCES customer.document_type(doc_type_id);


--
-- Name: distribution_resource fk_account_type; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.distribution_resource
    ADD CONSTRAINT fk_account_type FOREIGN KEY (account_type_id) REFERENCES customer.account_type(id);


--
-- Name: distribution_resource fk_customer; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.distribution_resource
    ADD CONSTRAINT fk_customer FOREIGN KEY (cust_id) REFERENCES customer.customer(cust_id);


--
-- Name: distribution_resource fk_resource; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.distribution_resource
    ADD CONSTRAINT fk_resource FOREIGN KEY (resource_id) REFERENCES customer.resources(id);


--
-- Name: customer_document fka2ods65f4u0gn53em90skv2y; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_document
    ADD CONSTRAINT fka2ods65f4u0gn53em90skv2y FOREIGN KEY (status_id) REFERENCES customer.customer_status(status_id);


--
-- Name: role_permission fkaxqtkkksr2o7sbssm7cbydnbs; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.role_permission
    ADD CONSTRAINT fkaxqtkkksr2o7sbssm7cbydnbs FOREIGN KEY (permission_id) REFERENCES customer.permission(id);


--
-- Name: customer_account fkgb6uwebqaodcxx3j35317vbiy; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_account
    ADD CONSTRAINT fkgb6uwebqaodcxx3j35317vbiy FOREIGN KEY (role_id) REFERENCES customer.role_account(role_id);


--
-- Name: role_permission fkivijemin1259uo4fwg39k8vb7; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.role_permission
    ADD CONSTRAINT fkivijemin1259uo4fwg39k8vb7 FOREIGN KEY (action_id) REFERENCES customer.action(id);


--
-- Name: customer fkotpld9elif8kam28rgbs9kqkg; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer
    ADD CONSTRAINT fkotpld9elif8kam28rgbs9kqkg FOREIGN KEY (cust_type) REFERENCES customer.customer_type(cust_type_id);


--
-- Name: role_permission fksw01od12re5ci5muet5m36c5l; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.role_permission
    ADD CONSTRAINT fksw01od12re5ci5muet5m36c5l FOREIGN KEY (role_id) REFERENCES customer.role_account(role_id);


--
-- Name: customer_document key_doc_cust; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_document
    ADD CONSTRAINT key_doc_cust FOREIGN KEY (cust_id) REFERENCES customer.customer(cust_id);


--
-- Name: customer_history key_his; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_history
    ADD CONSTRAINT key_his FOREIGN KEY (cust_id) REFERENCES customer.customer(cust_id);


--
-- Name: customer_history_detail key_his_detail; Type: FK CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customer_history_detail
    ADD CONSTRAINT key_his_detail FOREIGN KEY (cust_his_id) REFERENCES customer.customer_history(cust_his_id);


--
-- Name: user_task FK_0a1a413814297524947389f0c61; Type: FK CONSTRAINT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification.user_task
    ADD CONSTRAINT "FK_0a1a413814297524947389f0c61" FOREIGN KEY ("userId") REFERENCES gamification."user"(id);


--
-- Name: user_task FK_e3d56512dd1477747d6197ce767; Type: FK CONSTRAINT; Schema: gamification; Owner: postgres
--

ALTER TABLE ONLY gamification.user_task
    ADD CONSTRAINT "FK_e3d56512dd1477747d6197ce767" FOREIGN KEY ("taskId") REFERENCES gamification.task(id);


--
-- Name: customer fk5egfwg6tqtw593eq629upbyjv; Type: FK CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.customer
    ADD CONSTRAINT fk5egfwg6tqtw593eq629upbyjv FOREIGN KEY (status_id) REFERENCES customer.customer_status(status_id);


--
-- Name: subscriber fk5uy2fw26gscmes0nvtdcmfci; Type: FK CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.subscriber
    ADD CONSTRAINT fk5uy2fw26gscmes0nvtdcmfci FOREIGN KEY (cust_id) REFERENCES customer.customer(cust_id);


--
-- Name: subscriber fkblwcife6ctjo62mey74swrdq2; Type: FK CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.subscriber
    ADD CONSTRAINT fkblwcife6ctjo62mey74swrdq2 FOREIGN KEY (status) REFERENCES subscriber.sub_param(id);


--
-- Name: customer fkotpld9elif8kam28rgbs9kqkg; Type: FK CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.customer
    ADD CONSTRAINT fkotpld9elif8kam28rgbs9kqkg FOREIGN KEY (cust_type) REFERENCES customer.customer_type(cust_type_id);


--
-- Name: sub_block_call_his fkq5qp62yq5phek868i8y0c82kq; Type: FK CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_block_call_his
    ADD CONSTRAINT fkq5qp62yq5phek868i8y0c82kq FOREIGN KEY (reason_id) REFERENCES subscriber.sub_param(id);


--
-- Name: sub_service_his sub_service_fk; Type: FK CONSTRAINT; Schema: subscriber; Owner: postgres
--

ALTER TABLE ONLY subscriber.sub_service_his
    ADD CONSTRAINT sub_service_fk FOREIGN KEY (sub_service_id) REFERENCES subscriber.sub_service(id);


--
-- Name: SCHEMA account; Type: ACL; Schema: -; Owner: postgres
--

GRANT CREATE ON SCHEMA account TO "RA_Team";
GRANT USAGE ON SCHEMA account TO "RA_Team" WITH GRANT OPTION;
GRANT USAGE ON SCHEMA account TO subscribercusread;
GRANT USAGE ON SCHEMA account TO customer_cus_read;
GRANT USAGE ON SCHEMA account TO subscriber_cus_read;
GRANT USAGE ON SCHEMA account TO subscriber_cus_write;
GRANT USAGE ON SCHEMA account TO customer_cus_write;
GRANT USAGE ON SCHEMA account TO inventory_cus_read;
GRANT USAGE ON SCHEMA account TO inventory_cus_write;
GRANT USAGE ON SCHEMA account TO complain_cus_read;
GRANT USAGE ON SCHEMA account TO complain_cus_write;
GRANT USAGE ON SCHEMA account TO dist_cus_read;
GRANT USAGE ON SCHEMA account TO dist_cus_write;
GRANT USAGE ON SCHEMA account TO ewallet_cus_read;
GRANT USAGE ON SCHEMA account TO ewallet_cus_write;
GRANT USAGE ON SCHEMA account TO otp_cus_read;
GRANT USAGE ON SCHEMA account TO otp_cus_write;
GRANT ALL ON SCHEMA account TO thirdparty;
GRANT USAGE ON SCHEMA account TO ra_team;
GRANT CREATE ON SCHEMA account TO ra_team WITH GRANT OPTION;
GRANT ALL ON SCHEMA account TO apigw;
GRANT USAGE ON SCHEMA account TO job_create_shop_and_account;
GRANT USAGE ON SCHEMA account TO sale_cus_read;


--
-- Name: SCHEMA complain; Type: ACL; Schema: -; Owner: postgres
--

GRANT CREATE ON SCHEMA complain TO "RA_Team";
GRANT USAGE ON SCHEMA complain TO "RA_Team" WITH GRANT OPTION;
GRANT USAGE ON SCHEMA complain TO complain_cus_read;
GRANT USAGE ON SCHEMA complain TO complain_cus_write;
GRANT USAGE ON SCHEMA complain TO thirdparty;
GRANT USAGE ON SCHEMA complain TO ra_team;
GRANT CREATE ON SCHEMA complain TO ra_team WITH GRANT OPTION;


--
-- Name: SCHEMA customer; Type: ACL; Schema: -; Owner: postgres
--

GRANT CREATE ON SCHEMA customer TO "RA_Team";
GRANT USAGE ON SCHEMA customer TO "RA_Team" WITH GRANT OPTION;
GRANT USAGE ON SCHEMA customer TO subscribercusread;
GRANT USAGE ON SCHEMA customer TO customer_cus_read;
GRANT USAGE ON SCHEMA customer TO subscriber_cus_read;
GRANT USAGE ON SCHEMA customer TO subscriber_cus_write;
GRANT USAGE ON SCHEMA customer TO customer_cus_write;
GRANT USAGE ON SCHEMA customer TO sale_cus_read;
GRANT USAGE ON SCHEMA customer TO sale_cus_write;
GRANT USAGE ON SCHEMA customer TO portal_cus_read;
GRANT USAGE ON SCHEMA customer TO portal_cus_write;
GRANT USAGE ON SCHEMA customer TO dist_cus_read;
GRANT USAGE ON SCHEMA customer TO dist_cus_write;
GRANT USAGE ON SCHEMA customer TO evo_cus_read;
GRANT USAGE ON SCHEMA customer TO evo_cus_write;
GRANT USAGE ON SCHEMA customer TO ewallet_cus_read;
GRANT USAGE ON SCHEMA customer TO ewallet_cus_write;
GRANT USAGE ON SCHEMA customer TO inventory_cus_read;
GRANT USAGE ON SCHEMA customer TO inventory_cus_write;
GRANT USAGE ON SCHEMA customer TO complain_cus_read;
GRANT ALL ON SCHEMA customer TO thirdparty;
GRANT USAGE ON SCHEMA customer TO ra_team;
GRANT CREATE ON SCHEMA customer TO ra_team WITH GRANT OPTION;
GRANT ALL ON SCHEMA customer TO apigw;
GRANT ALL ON SCHEMA customer TO job_loyalty;


--
-- Name: SCHEMA gamification; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA gamification TO "RA_Team";
GRANT USAGE ON SCHEMA gamification TO ra_team;
GRANT CREATE ON SCHEMA gamification TO ra_team WITH GRANT OPTION;


--
-- Name: SCHEMA log; Type: ACL; Schema: -; Owner: postgres
--

GRANT CREATE ON SCHEMA log TO "RA_Team";
GRANT USAGE ON SCHEMA log TO "RA_Team" WITH GRANT OPTION;
GRANT ALL ON SCHEMA log TO thirdparty;
GRANT USAGE ON SCHEMA log TO ra_team;
GRANT CREATE ON SCHEMA log TO ra_team WITH GRANT OPTION;


--
-- Name: SCHEMA mnp; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA mnp TO mnp_user;
GRANT ALL ON SCHEMA mnp TO mnp;


--
-- Name: SCHEMA notification; Type: ACL; Schema: -; Owner: postgres
--

GRANT CREATE ON SCHEMA notification TO "RA_Team";
GRANT USAGE ON SCHEMA notification TO "RA_Team" WITH GRANT OPTION;
GRANT USAGE ON SCHEMA notification TO ra_team;
GRANT CREATE ON SCHEMA notification TO ra_team WITH GRANT OPTION;


--
-- Name: SCHEMA otp; Type: ACL; Schema: -; Owner: postgres
--

GRANT CREATE ON SCHEMA otp TO "RA_Team";
GRANT USAGE ON SCHEMA otp TO "RA_Team" WITH GRANT OPTION;
GRANT USAGE ON SCHEMA otp TO otp_cus_read;
GRANT USAGE ON SCHEMA otp TO otp_cus_write;
GRANT USAGE ON SCHEMA otp TO ra_team;
GRANT CREATE ON SCHEMA otp TO ra_team WITH GRANT OPTION;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT CREATE ON SCHEMA public TO "RA_Team";
GRANT USAGE ON SCHEMA public TO "RA_Team" WITH GRANT OPTION;
GRANT USAGE ON SCHEMA public TO ra_team;
GRANT CREATE ON SCHEMA public TO ra_team WITH GRANT OPTION;
GRANT ALL ON SCHEMA public TO mnp_user;
GRANT ALL ON SCHEMA public TO mnp;


--
-- Name: SCHEMA subscriber; Type: ACL; Schema: -; Owner: postgres
--

GRANT CREATE ON SCHEMA subscriber TO "RA_Team";
GRANT USAGE ON SCHEMA subscriber TO "RA_Team" WITH GRANT OPTION;
GRANT USAGE ON SCHEMA subscriber TO subscribercusread;
GRANT USAGE ON SCHEMA subscriber TO customer_cus_read;
GRANT USAGE ON SCHEMA subscriber TO subscriber_cus_read;
GRANT USAGE ON SCHEMA subscriber TO subscriber_cus_write;
GRANT USAGE ON SCHEMA subscriber TO customer_cus_write;
GRANT USAGE ON SCHEMA subscriber TO inventory_cus_read;
GRANT USAGE ON SCHEMA subscriber TO sale_cus_read;
GRANT USAGE ON SCHEMA subscriber TO sale_cus_write;
GRANT USAGE ON SCHEMA subscriber TO inventory_cus_write;
GRANT USAGE ON SCHEMA subscriber TO portal_cus_write;
GRANT USAGE ON SCHEMA subscriber TO evo_cus_read;
GRANT USAGE ON SCHEMA subscriber TO evo_cus_write;
GRANT USAGE ON SCHEMA subscriber TO ewallet_cus_read;
GRANT USAGE ON SCHEMA subscriber TO ewallet_cus_write;
GRANT USAGE ON SCHEMA subscriber TO portal_cus_read;
GRANT USAGE ON SCHEMA subscriber TO job_push_sms;
GRANT ALL ON SCHEMA subscriber TO thirdparty;
GRANT USAGE ON SCHEMA subscriber TO ra_team;
GRANT CREATE ON SCHEMA subscriber TO ra_team WITH GRANT OPTION;
GRANT ALL ON SCHEMA subscriber TO job_freeingresource;
GRANT ALL ON SCHEMA subscriber TO consumer;
GRANT USAGE ON SCHEMA subscriber TO job_create_shop_and_account;


--
-- Name: TABLE ids; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.ids TO "RA_Team";


--
-- Name: TABLE account_his; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON TABLE account.account_his TO apigw;
GRANT ALL ON TABLE account.account_his TO ngalt;


--
-- Name: TABLE account_his_detail; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON TABLE account.account_his_detail TO apigw;
GRANT ALL ON TABLE account.account_his_detail TO ngalt;


--
-- Name: SEQUENCE account_his_detail_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.account_his_detail_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.account_his_detail_id_seq TO ngalt;


--
-- Name: SEQUENCE account_his_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.account_his_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.account_his_id_seq TO ngalt;


--
-- Name: TABLE ag_access_log; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_access_log TO subscribercusread;
GRANT SELECT ON TABLE account.ag_access_log TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_access_log TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_access_log TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_access_log TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_access_log TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_access_log TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_access_log TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_access_log TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_access_log TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_access_log TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_access_log TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_access_log TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_access_log TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_access_log TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_access_log TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_access_log TO thirdparty;
GRANT ALL ON TABLE account.ag_access_log TO apigw;
GRANT ALL ON TABLE account.ag_access_log TO ngalt;


--
-- Name: TABLE ag_action_log; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_action_log TO subscribercusread;
GRANT SELECT ON TABLE account.ag_action_log TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_action_log TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_action_log TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_action_log TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_action_log TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_action_log TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_action_log TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_action_log TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_action_log TO thirdparty;
GRANT ALL ON TABLE account.ag_action_log TO apigw;
GRANT ALL ON TABLE account.ag_action_log TO ngalt;


--
-- Name: TABLE ag_action_log_detail; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_action_log_detail TO subscribercusread;
GRANT SELECT ON TABLE account.ag_action_log_detail TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_action_log_detail TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log_detail TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log_detail TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_action_log_detail TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log_detail TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_action_log_detail TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log_detail TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_action_log_detail TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log_detail TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_action_log_detail TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log_detail TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_action_log_detail TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_action_log_detail TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_action_log_detail TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_action_log_detail TO thirdparty;
GRANT ALL ON TABLE account.ag_action_log_detail TO apigw;
GRANT ALL ON TABLE account.ag_action_log_detail TO ngalt;


--
-- Name: TABLE ag_api_resource; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_api_resource TO subscribercusread;
GRANT SELECT ON TABLE account.ag_api_resource TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_api_resource TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_api_resource TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_api_resource TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_api_resource TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_api_resource TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_api_resource TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_api_resource TO thirdparty;
GRANT ALL ON TABLE account.ag_api_resource TO apigw;
GRANT ALL ON TABLE account.ag_api_resource TO ngalt;


--
-- Name: TABLE ag_api_resource_detail; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_api_resource_detail TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_api_resource_detail TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_api_resource_detail TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_api_resource_detail TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_api_resource_detail TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_api_resource_detail TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_api_resource_detail TO thirdparty;
GRANT ALL ON TABLE account.ag_api_resource_detail TO apigw;
GRANT ALL ON TABLE account.ag_api_resource_detail TO ngalt;


--
-- Name: TABLE ag_app_function; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_app_function TO subscribercusread;
GRANT SELECT ON TABLE account.ag_app_function TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_app_function TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_function TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_function TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_app_function TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_function TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_app_function TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_function TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_app_function TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_function TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_app_function TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_function TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_app_function TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_function TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_app_function TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_app_function TO thirdparty;
GRANT ALL ON TABLE account.ag_app_function TO apigw;
GRANT ALL ON TABLE account.ag_app_function TO ngalt;


--
-- Name: TABLE ag_app_role; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_app_role TO "RA_Team" WITH GRANT OPTION;
GRANT SELECT ON TABLE account.ag_app_role TO subscribercusread;
GRANT SELECT ON TABLE account.ag_app_role TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_app_role TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_role TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_role TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_app_role TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_role TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_app_role TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_role TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_app_role TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_role TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_app_role TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_role TO ewallet_cus_write;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_app_role TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_app_role TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_app_role TO thirdparty;
GRANT ALL ON TABLE account.ag_app_role TO apigw;
GRANT ALL ON TABLE account.ag_app_role TO ngalt;


--
-- Name: TABLE ag_application; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_application TO subscribercusread;
GRANT SELECT ON TABLE account.ag_application TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_application TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_application TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_application TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_application TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_application TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_application TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_application TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_application TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_application TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_application TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_application TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_application TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_application TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_application TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_application TO thirdparty;
GRANT ALL ON TABLE account.ag_application TO apigw;
GRANT ALL ON TABLE account.ag_application TO ngalt;


--
-- Name: TABLE ag_chanel; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_chanel TO subscribercusread;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_chanel TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_chanel TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_chanel TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_chanel TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_chanel TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_chanel TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_chanel TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_chanel TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_chanel TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_chanel TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_chanel TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_chanel TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_chanel TO "RA_Team";
GRANT SELECT ON TABLE account.ag_chanel TO otp_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_chanel TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_chanel TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_chanel TO thirdparty;
GRANT ALL ON TABLE account.ag_chanel TO apigw;
GRANT ALL ON TABLE account.ag_chanel TO ngalt;
GRANT SELECT ON TABLE account.ag_chanel TO job_create_shop_and_account;
GRANT SELECT ON TABLE account.ag_chanel TO sale_cus_read;


--
-- Name: SEQUENCE ag_chanel_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.ag_chanel_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.ag_chanel_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE account.ag_chanel_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.ag_chanel_id_seq TO complain_cus_write;
GRANT ALL ON SEQUENCE account.ag_chanel_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE account.ag_chanel_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.ag_chanel_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE account.ag_chanel_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.ag_chanel_id_seq TO ngalt;


--
-- Name: TABLE ag_domain; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_domain TO subscribercusread;
GRANT SELECT ON TABLE account.ag_domain TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_domain TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_domain TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_domain TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_domain TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_domain TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_domain TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_domain TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_domain TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_domain TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_domain TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_domain TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_domain TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_domain TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_domain TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_domain TO thirdparty;
GRANT ALL ON TABLE account.ag_domain TO apigw;
GRANT ALL ON TABLE account.ag_domain TO ngalt;


--
-- Name: TABLE ag_error_code; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_error_code TO subscribercusread;
GRANT SELECT ON TABLE account.ag_error_code TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_error_code TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_error_code TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_error_code TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_error_code TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_error_code TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_error_code TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_error_code TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_error_code TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_error_code TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_error_code TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_error_code TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_error_code TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_error_code TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_error_code TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_error_code TO thirdparty;
GRANT ALL ON TABLE account.ag_error_code TO apigw;
GRANT ALL ON TABLE account.ag_error_code TO ngalt;


--
-- Name: TABLE ag_function; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_function TO subscribercusread;
GRANT SELECT ON TABLE account.ag_function TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_function TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_function TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_function TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_function TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_function TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_function TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_function TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_function TO thirdparty;
GRANT ALL ON TABLE account.ag_function TO apigw;
GRANT ALL ON TABLE account.ag_function TO ngalt;


--
-- Name: TABLE ag_function_api; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_function_api TO subscribercusread;
GRANT SELECT ON TABLE account.ag_function_api TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_function_api TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function_api TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function_api TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_function_api TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function_api TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_function_api TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function_api TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_function_api TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function_api TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_function_api TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function_api TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_function_api TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_function_api TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_function_api TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_function_api TO thirdparty;
GRANT ALL ON TABLE account.ag_function_api TO apigw;
GRANT ALL ON TABLE account.ag_function_api TO ngalt;


--
-- Name: TABLE ag_log_transaction; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_log_transaction TO subscribercusread;
GRANT SELECT ON TABLE account.ag_log_transaction TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_log_transaction TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_log_transaction TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_log_transaction TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_log_transaction TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_log_transaction TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_log_transaction TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_log_transaction TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_log_transaction TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_log_transaction TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_log_transaction TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_log_transaction TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_log_transaction TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_log_transaction TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_log_transaction TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_log_transaction TO thirdparty;
GRANT ALL ON TABLE account.ag_log_transaction TO apigw;
GRANT ALL ON TABLE account.ag_log_transaction TO ngalt;


--
-- Name: TABLE ag_map_app; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_map_app TO subscribercusread;
GRANT SELECT ON TABLE account.ag_map_app TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_map_app TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_map_app TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_map_app TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_map_app TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_map_app TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_map_app TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_map_app TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_map_app TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_map_app TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_map_app TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_map_app TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_map_app TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_map_app TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_map_app TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_map_app TO thirdparty;
GRANT ALL ON TABLE account.ag_map_app TO apigw;
GRANT ALL ON TABLE account.ag_map_app TO ngalt;


--
-- Name: SEQUENCE ag_map_app_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.ag_map_app_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.ag_map_app_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE account.ag_map_app_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.ag_map_app_id_seq TO complain_cus_write;
GRANT ALL ON SEQUENCE account.ag_map_app_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE account.ag_map_app_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.ag_map_app_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE account.ag_map_app_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.ag_map_app_id_seq TO ngalt;


--
-- Name: TABLE ag_prefix_domain; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_prefix_domain TO subscribercusread;
GRANT SELECT ON TABLE account.ag_prefix_domain TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_prefix_domain TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_prefix_domain TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_prefix_domain TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_prefix_domain TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_prefix_domain TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_prefix_domain TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_prefix_domain TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_prefix_domain TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_prefix_domain TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_prefix_domain TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_prefix_domain TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_prefix_domain TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_prefix_domain TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_prefix_domain TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_prefix_domain TO thirdparty;
GRANT ALL ON TABLE account.ag_prefix_domain TO apigw;
GRANT ALL ON TABLE account.ag_prefix_domain TO ngalt;


--
-- Name: TABLE ag_role; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_role TO subscribercusread;
GRANT SELECT ON TABLE account.ag_role TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_role TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_role TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_role TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_role TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_role TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_role TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_role TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_role TO thirdparty;
GRANT ALL ON TABLE account.ag_role TO apigw;
GRANT ALL ON TABLE account.ag_role TO ngalt;


--
-- Name: TABLE ag_role_app; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_role_app TO subscribercusread;
GRANT SELECT ON TABLE account.ag_role_app TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_role_app TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_app TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_app TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_role_app TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_app TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_role_app TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_app TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_role_app TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_app TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_role_app TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_app TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_role_app TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_app TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_role_app TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_role_app TO thirdparty;
GRANT ALL ON TABLE account.ag_role_app TO apigw;
GRANT ALL ON TABLE account.ag_role_app TO ngalt;


--
-- Name: TABLE ag_role_function; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_role_function TO subscribercusread;
GRANT SELECT ON TABLE account.ag_role_function TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_role_function TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_function TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_function TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_role_function TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_function TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_role_function TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_function TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_role_function TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_function TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_role_function TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_function TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_role_function TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_role_function TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_role_function TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_role_function TO thirdparty;
GRANT ALL ON TABLE account.ag_role_function TO apigw;
GRANT ALL ON TABLE account.ag_role_function TO ngalt;


--
-- Name: SEQUENCE ag_system_user_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.ag_system_user_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.ag_system_user_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE account.ag_system_user_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.ag_system_user_id_seq TO complain_cus_write;
GRANT ALL ON SEQUENCE account.ag_system_user_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE account.ag_system_user_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.ag_system_user_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE account.ag_system_user_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.ag_system_user_id_seq TO ngalt;


--
-- Name: TABLE ag_system_user; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_system_user TO subscribercusread;
GRANT SELECT ON TABLE account.ag_system_user TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_system_user TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_system_user TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_system_user TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_system_user TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_system_user TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_system_user TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_system_user TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_system_user TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_system_user TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_system_user TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_system_user TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_system_user TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_system_user TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_system_user TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_system_user TO thirdparty;
GRANT ALL ON TABLE account.ag_system_user TO apigw;
GRANT ALL ON TABLE account.ag_system_user TO ngalt;


--
-- Name: TABLE ag_throttling; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_throttling TO subscribercusread;
GRANT SELECT ON TABLE account.ag_throttling TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_throttling TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_throttling TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_throttling TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_throttling TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_throttling TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_throttling TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_throttling TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_throttling TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_throttling TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_throttling TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_throttling TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_throttling TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_throttling TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_throttling TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_throttling TO thirdparty;
GRANT ALL ON TABLE account.ag_throttling TO apigw;
GRANT ALL ON TABLE account.ag_throttling TO ngalt;


--
-- Name: TABLE ag_user; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_user TO subscribercusread;
GRANT SELECT ON TABLE account.ag_user TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_user TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_user TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_user TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_user TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_user TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_user TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_user TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_user TO thirdparty;
GRANT ALL ON TABLE account.ag_user TO apigw;
GRANT ALL ON TABLE account.ag_user TO ngalt;


--
-- Name: TABLE ag_user_app; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_user_app TO subscribercusread;
GRANT SELECT ON TABLE account.ag_user_app TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_user_app TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_user_app TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_user_app TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_user_app TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_user_app TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_user_app TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_user_app TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_user_app TO thirdparty;
GRANT ALL ON TABLE account.ag_user_app TO apigw;
GRANT ALL ON TABLE account.ag_user_app TO ngalt;


--
-- Name: TABLE ag_user_app_trial; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_user_app_trial TO subscribercusread;
GRANT SELECT ON TABLE account.ag_user_app_trial TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_user_app_trial TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app_trial TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app_trial TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_user_app_trial TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app_trial TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_user_app_trial TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app_trial TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_user_app_trial TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app_trial TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_user_app_trial TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app_trial TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_user_app_trial TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_app_trial TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_user_app_trial TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_user_app_trial TO thirdparty;
GRANT ALL ON TABLE account.ag_user_app_trial TO apigw;
GRANT ALL ON TABLE account.ag_user_app_trial TO ngalt;


--
-- Name: SEQUENCE ag_user_app_trial_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.ag_user_app_trial_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_app_trial_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_app_trial_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_app_trial_id_seq TO complain_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_app_trial_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_app_trial_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_app_trial_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE account.ag_user_app_trial_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.ag_user_app_trial_id_seq TO ngalt;


--
-- Name: SEQUENCE ag_user_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.ag_user_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_id_seq TO complain_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE account.ag_user_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.ag_user_id_seq TO ngalt;


--
-- Name: TABLE ag_user_role; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_user_role TO subscribercusread;
GRANT SELECT ON TABLE account.ag_user_role TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_user_role TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_user_role TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_user_role TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_user_role TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_user_role TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_user_role TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_user_role TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_user_role TO thirdparty;
GRANT ALL ON TABLE account.ag_user_role TO apigw;
GRANT ALL ON TABLE account.ag_user_role TO ngalt;
GRANT SELECT,INSERT,REFERENCES,DELETE,UPDATE ON TABLE account.ag_user_role TO job_create_shop_and_account;


--
-- Name: TABLE ag_user_role_trial; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_user_role_trial TO subscribercusread;
GRANT SELECT ON TABLE account.ag_user_role_trial TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_user_role_trial TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role_trial TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role_trial TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_user_role_trial TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role_trial TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_user_role_trial TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role_trial TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_user_role_trial TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role_trial TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_user_role_trial TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role_trial TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_user_role_trial TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_role_trial TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_user_role_trial TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_user_role_trial TO thirdparty;
GRANT ALL ON TABLE account.ag_user_role_trial TO apigw;
GRANT ALL ON TABLE account.ag_user_role_trial TO ngalt;


--
-- Name: SEQUENCE ag_user_role_trial_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.ag_user_role_trial_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_role_trial_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_role_trial_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_role_trial_id_seq TO complain_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_role_trial_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_role_trial_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_role_trial_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE account.ag_user_role_trial_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.ag_user_role_trial_id_seq TO ngalt;


--
-- Name: TABLE ag_user_trial; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.ag_user_trial TO subscribercusread;
GRANT SELECT ON TABLE account.ag_user_trial TO customer_cus_read;
GRANT SELECT ON TABLE account.ag_user_trial TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_trial TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_trial TO customer_cus_write;
GRANT SELECT ON TABLE account.ag_user_trial TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_trial TO inventory_cus_write;
GRANT SELECT ON TABLE account.ag_user_trial TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_trial TO complain_cus_write;
GRANT SELECT ON TABLE account.ag_user_trial TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_trial TO dist_cus_write;
GRANT SELECT ON TABLE account.ag_user_trial TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_trial TO ewallet_cus_write;
GRANT SELECT ON TABLE account.ag_user_trial TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.ag_user_trial TO otp_cus_write;
GRANT SELECT ON TABLE account.ag_user_trial TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.ag_user_trial TO thirdparty;
GRANT ALL ON TABLE account.ag_user_trial TO apigw;
GRANT ALL ON TABLE account.ag_user_trial TO ngalt;


--
-- Name: SEQUENCE ag_user_trial_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.ag_user_trial_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_trial_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_trial_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_trial_id_seq TO complain_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_trial_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_trial_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.ag_user_trial_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE account.ag_user_trial_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.ag_user_trial_id_seq TO ngalt;


--
-- Name: SEQUENCE hibernate_sequence; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.hibernate_sequence TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.hibernate_sequence TO customer_cus_write;
GRANT ALL ON SEQUENCE account.hibernate_sequence TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.hibernate_sequence TO complain_cus_write;
GRANT ALL ON SEQUENCE account.hibernate_sequence TO dist_cus_write;
GRANT ALL ON SEQUENCE account.hibernate_sequence TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.hibernate_sequence TO thirdparty;
GRANT ALL ON SEQUENCE account.hibernate_sequence TO apigw;
GRANT ALL ON SEQUENCE account.hibernate_sequence TO ngalt;


--
-- Name: SEQUENCE log_login_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.log_login_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.log_login_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE account.log_login_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.log_login_id_seq TO complain_cus_write;
GRANT ALL ON SEQUENCE account.log_login_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE account.log_login_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.log_login_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE account.log_login_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.log_login_id_seq TO ngalt;


--
-- Name: TABLE log_login; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.log_login TO subscribercusread;
GRANT SELECT ON TABLE account.log_login TO customer_cus_read;
GRANT SELECT ON TABLE account.log_login TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_login TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_login TO customer_cus_write;
GRANT SELECT ON TABLE account.log_login TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_login TO inventory_cus_write;
GRANT SELECT ON TABLE account.log_login TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_login TO complain_cus_write;
GRANT SELECT ON TABLE account.log_login TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_login TO dist_cus_write;
GRANT SELECT ON TABLE account.log_login TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_login TO ewallet_cus_write;
GRANT SELECT ON TABLE account.log_login TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.log_login TO otp_cus_write;
GRANT SELECT ON TABLE account.log_login TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.log_login TO thirdparty;
GRANT ALL ON TABLE account.log_login TO apigw;
GRANT ALL ON TABLE account.log_login TO ngalt;


--
-- Name: SEQUENCE log_login_id_seq1; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.log_login_id_seq1 TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.log_login_id_seq1 TO customer_cus_write;
GRANT ALL ON SEQUENCE account.log_login_id_seq1 TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.log_login_id_seq1 TO complain_cus_write;
GRANT ALL ON SEQUENCE account.log_login_id_seq1 TO dist_cus_write;
GRANT ALL ON SEQUENCE account.log_login_id_seq1 TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.log_login_id_seq1 TO thirdparty;
GRANT ALL ON SEQUENCE account.log_login_id_seq1 TO apigw;
GRANT ALL ON SEQUENCE account.log_login_id_seq1 TO ngalt;


--
-- Name: TABLE log_tracking_lock; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.log_tracking_lock TO subscribercusread;
GRANT SELECT ON TABLE account.log_tracking_lock TO customer_cus_read;
GRANT SELECT ON TABLE account.log_tracking_lock TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_tracking_lock TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_tracking_lock TO customer_cus_write;
GRANT SELECT ON TABLE account.log_tracking_lock TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_tracking_lock TO inventory_cus_write;
GRANT SELECT ON TABLE account.log_tracking_lock TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_tracking_lock TO complain_cus_write;
GRANT SELECT ON TABLE account.log_tracking_lock TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_tracking_lock TO dist_cus_write;
GRANT SELECT ON TABLE account.log_tracking_lock TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_tracking_lock TO ewallet_cus_write;
GRANT SELECT ON TABLE account.log_tracking_lock TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.log_tracking_lock TO otp_cus_write;
GRANT SELECT ON TABLE account.log_tracking_lock TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.log_tracking_lock TO thirdparty;
GRANT ALL ON TABLE account.log_tracking_lock TO apigw;
GRANT ALL ON TABLE account.log_tracking_lock TO ngalt;


--
-- Name: SEQUENCE log_tracking_lock_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.log_tracking_lock_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.log_tracking_lock_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE account.log_tracking_lock_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.log_tracking_lock_id_seq TO complain_cus_write;
GRANT ALL ON SEQUENCE account.log_tracking_lock_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE account.log_tracking_lock_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.log_tracking_lock_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE account.log_tracking_lock_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.log_tracking_lock_id_seq TO ngalt;


--
-- Name: TABLE log_transaction; Type: ACL; Schema: account; Owner: postgres
--

GRANT SELECT ON TABLE account.log_transaction TO subscribercusread;
GRANT SELECT ON TABLE account.log_transaction TO customer_cus_read;
GRANT SELECT ON TABLE account.log_transaction TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_transaction TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_transaction TO customer_cus_write;
GRANT SELECT ON TABLE account.log_transaction TO inventory_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_transaction TO inventory_cus_write;
GRANT SELECT ON TABLE account.log_transaction TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_transaction TO complain_cus_write;
GRANT SELECT ON TABLE account.log_transaction TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_transaction TO dist_cus_write;
GRANT SELECT ON TABLE account.log_transaction TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE account.log_transaction TO ewallet_cus_write;
GRANT SELECT ON TABLE account.log_transaction TO "RA_Team";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE account.log_transaction TO otp_cus_write;
GRANT SELECT ON TABLE account.log_transaction TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE account.log_transaction TO thirdparty;
GRANT ALL ON TABLE account.log_transaction TO apigw;
GRANT ALL ON TABLE account.log_transaction TO ngalt;


--
-- Name: SEQUENCE log_transaction_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.log_transaction_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.log_transaction_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE account.log_transaction_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.log_transaction_id_seq TO complain_cus_write;
GRANT ALL ON SEQUENCE account.log_transaction_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE account.log_transaction_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.log_transaction_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE account.log_transaction_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.log_transaction_id_seq TO ngalt;


--
-- Name: TABLE log_update_ag_user; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON TABLE account.log_update_ag_user TO "RA_Team";
GRANT ALL ON TABLE account.log_update_ag_user TO apigw;
GRANT ALL ON TABLE account.log_update_ag_user TO complain_cus_write;
GRANT ALL ON TABLE account.log_update_ag_user TO customer_cus_write;
GRANT ALL ON TABLE account.log_update_ag_user TO dist_cus_write;
GRANT ALL ON TABLE account.log_update_ag_user TO ewallet_cus_write;
GRANT ALL ON TABLE account.log_update_ag_user TO inventory_cus_write;
GRANT ALL ON TABLE account.log_update_ag_user TO job_create_shop_and_account;
GRANT ALL ON TABLE account.log_update_ag_user TO ngalt;
GRANT ALL ON TABLE account.log_update_ag_user TO otp_cus_write;
GRANT ALL ON TABLE account.log_update_ag_user TO ra_team;
GRANT ALL ON TABLE account.log_update_ag_user TO subscriber_cus_write;
GRANT ALL ON TABLE account.log_update_ag_user TO thirdparty;


--
-- Name: SEQUENCE log_update_ag_user_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO "RA_Team";
GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO complain_cus_write;
GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO job_create_shop_and_account;
GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO ngalt;
GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO otp_cus_write;
GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO ra_team;
GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.log_update_ag_user_id_seq TO thirdparty;


--
-- Name: TABLE log_update_chanel; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON TABLE account.log_update_chanel TO "RA_Team";
GRANT ALL ON TABLE account.log_update_chanel TO apigw;
GRANT ALL ON TABLE account.log_update_chanel TO complain_cus_read;
GRANT ALL ON TABLE account.log_update_chanel TO complain_cus_write;
GRANT ALL ON TABLE account.log_update_chanel TO customer_cus_write;
GRANT ALL ON TABLE account.log_update_chanel TO dist_cus_write;
GRANT ALL ON TABLE account.log_update_chanel TO ewallet_cus_write;
GRANT ALL ON TABLE account.log_update_chanel TO inventory_cus_write;
GRANT ALL ON TABLE account.log_update_chanel TO job_create_shop_and_account;
GRANT ALL ON TABLE account.log_update_chanel TO ngalt;
GRANT ALL ON TABLE account.log_update_chanel TO otp_cus_write;
GRANT ALL ON TABLE account.log_update_chanel TO ra_team;
GRANT ALL ON TABLE account.log_update_chanel TO subscriber_cus_write;
GRANT ALL ON TABLE account.log_update_chanel TO thirdparty;


--
-- Name: SEQUENCE log_update_chanel_id_seq; Type: ACL; Schema: account; Owner: postgres
--

GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO "RA_Team";
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO apigw;
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO complain_cus_read;
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO complain_cus_write;
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO job_create_shop_and_account;
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO ngalt;
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO otp_cus_write;
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO ra_team;
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE account.log_update_chanel_id_seq TO thirdparty;


--
-- Name: TABLE category; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.category TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.category TO complain_cus_write;
GRANT SELECT ON TABLE complain.category TO "RA_Team";


--
-- Name: SEQUENCE category_category_id_seq; Type: ACL; Schema: complain; Owner: postgres
--

GRANT ALL ON SEQUENCE complain.category_category_id_seq TO complain_cus_write;


--
-- Name: TABLE complain_his_detail; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.complain_his_detail TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.complain_his_detail TO complain_cus_write;
GRANT SELECT ON TABLE complain.complain_his_detail TO "RA_Team";


--
-- Name: SEQUENCE complain_his_detail_detail_id_seq; Type: ACL; Schema: complain; Owner: postgres
--

GRANT ALL ON SEQUENCE complain.complain_his_detail_detail_id_seq TO complain_cus_write;


--
-- Name: TABLE complain_history; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.complain_history TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.complain_history TO complain_cus_write;
GRANT SELECT ON TABLE complain.complain_history TO "RA_Team";


--
-- Name: SEQUENCE complain_history_his_id_seq; Type: ACL; Schema: complain; Owner: postgres
--

GRANT ALL ON SEQUENCE complain.complain_history_his_id_seq TO complain_cus_write;


--
-- Name: TABLE complain_management; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.complain_management TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.complain_management TO complain_cus_write;
GRANT SELECT ON TABLE complain.complain_management TO "RA_Team";


--
-- Name: SEQUENCE complain_management_complain_id_seq; Type: ACL; Schema: complain; Owner: postgres
--

GRANT ALL ON SEQUENCE complain.complain_management_complain_id_seq TO complain_cus_write;


--
-- Name: TABLE config_stringee; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.config_stringee TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.config_stringee TO complain_cus_write;
GRANT SELECT ON TABLE complain.config_stringee TO "RA_Team";


--
-- Name: TABLE department_tmp; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.department_tmp TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.department_tmp TO complain_cus_write;
GRANT SELECT ON TABLE complain.department_tmp TO "RA_Team";


--
-- Name: TABLE happy_call; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.happy_call TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.happy_call TO complain_cus_write;
GRANT SELECT ON TABLE complain.happy_call TO "RA_Team";


--
-- Name: SEQUENCE happy_call_id_seq; Type: ACL; Schema: complain; Owner: postgres
--

GRANT ALL ON SEQUENCE complain.happy_call_id_seq TO complain_cus_write;


--
-- Name: TABLE log_transaction; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.log_transaction TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.log_transaction TO complain_cus_write;
GRANT SELECT ON TABLE complain.log_transaction TO "RA_Team";


--
-- Name: SEQUENCE log_transaction_id_seq; Type: ACL; Schema: complain; Owner: postgres
--

GRANT ALL ON SEQUENCE complain.log_transaction_id_seq TO complain_cus_write;


--
-- Name: TABLE prioritize; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.prioritize TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.prioritize TO complain_cus_write;
GRANT SELECT ON TABLE complain.prioritize TO "RA_Team";


--
-- Name: TABLE response; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.response TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.response TO complain_cus_write;
GRANT SELECT ON TABLE complain.response TO "RA_Team";


--
-- Name: SEQUENCE response_response_id_seq; Type: ACL; Schema: complain; Owner: postgres
--

GRANT ALL ON SEQUENCE complain.response_response_id_seq TO complain_cus_write;


--
-- Name: TABLE source; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.source TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.source TO complain_cus_write;
GRANT SELECT ON TABLE complain.source TO "RA_Team";


--
-- Name: TABLE staff_tmp; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.staff_tmp TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.staff_tmp TO complain_cus_write;
GRANT SELECT ON TABLE complain.staff_tmp TO "RA_Team";


--
-- Name: TABLE status; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.status TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.status TO complain_cus_write;
GRANT SELECT ON TABLE complain.status TO "RA_Team";


--
-- Name: TABLE status_happy_call; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT ON TABLE complain.status_happy_call TO complain_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE complain.status_happy_call TO complain_cus_write;
GRANT SELECT ON TABLE complain.status_happy_call TO "RA_Team";


--
-- Name: SEQUENCE status_status_id_seq; Type: ACL; Schema: complain; Owner: postgres
--

GRANT ALL ON SEQUENCE complain.status_status_id_seq TO complain_cus_write;


--
-- Name: TABLE stringee_call; Type: ACL; Schema: complain; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE complain.stringee_call TO thirdparty;


--
-- Name: SEQUENCE stringee_call_id_seq; Type: ACL; Schema: complain; Owner: postgres
--

GRANT ALL ON SEQUENCE complain.stringee_call_id_seq TO thirdparty;


--
-- Name: SEQUENCE stringee_call_id_seq1; Type: ACL; Schema: complain; Owner: postgres
--

GRANT ALL ON SEQUENCE complain.stringee_call_id_seq1 TO thirdparty;


--
-- Name: TABLE account_type; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.account_type TO subscribercusread;
GRANT SELECT ON TABLE customer.account_type TO customer_cus_read;
GRANT SELECT ON TABLE customer.account_type TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.account_type TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.account_type TO customer_cus_write;
GRANT SELECT ON TABLE customer.account_type TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.account_type TO sale_cus_write;
GRANT SELECT ON TABLE customer.account_type TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.account_type TO portal_cus_write;
GRANT SELECT ON TABLE customer.account_type TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.account_type TO dist_cus_write;
GRANT SELECT ON TABLE customer.account_type TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.account_type TO evo_cus_write;
GRANT SELECT ON TABLE customer.account_type TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.account_type TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.account_type TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.account_type TO inventory_cus_write;
GRANT SELECT ON TABLE customer.account_type TO "RA_Team";
GRANT ALL ON TABLE customer.account_type TO thirdparty;
GRANT ALL ON TABLE customer.account_type TO ngalt;


--
-- Name: SEQUENCE account_type_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.account_type_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.account_type_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.account_type_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.account_type_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.account_type_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.account_type_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.account_type_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.account_type_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.account_type_id_seq TO ngalt;


--
-- Name: TABLE action; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.action TO subscribercusread;
GRANT SELECT ON TABLE customer.action TO customer_cus_read;
GRANT SELECT ON TABLE customer.action TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.action TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.action TO customer_cus_write;
GRANT SELECT ON TABLE customer.action TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.action TO sale_cus_write;
GRANT SELECT ON TABLE customer.action TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.action TO portal_cus_write;
GRANT SELECT ON TABLE customer.action TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.action TO dist_cus_write;
GRANT SELECT ON TABLE customer.action TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.action TO evo_cus_write;
GRANT SELECT ON TABLE customer.action TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.action TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.action TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.action TO inventory_cus_write;
GRANT SELECT ON TABLE customer.action TO "RA_Team";
GRANT ALL ON TABLE customer.action TO thirdparty;
GRANT ALL ON TABLE customer.action TO ngalt;


--
-- Name: SEQUENCE action_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.action_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.action_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.action_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.action_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.action_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.action_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.action_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.action_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.action_id_seq TO ngalt;


--
-- Name: TABLE call_log; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.call_log TO subscribercusread;
GRANT SELECT ON TABLE customer.call_log TO customer_cus_read;
GRANT SELECT ON TABLE customer.call_log TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.call_log TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.call_log TO customer_cus_write;
GRANT SELECT ON TABLE customer.call_log TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.call_log TO sale_cus_write;
GRANT SELECT ON TABLE customer.call_log TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.call_log TO portal_cus_write;
GRANT SELECT ON TABLE customer.call_log TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.call_log TO dist_cus_write;
GRANT SELECT ON TABLE customer.call_log TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.call_log TO evo_cus_write;
GRANT SELECT ON TABLE customer.call_log TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.call_log TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.call_log TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.call_log TO inventory_cus_write;
GRANT SELECT ON TABLE customer.call_log TO "RA_Team";
GRANT ALL ON TABLE customer.call_log TO thirdparty;
GRANT ALL ON TABLE customer.call_log TO ngalt;


--
-- Name: SEQUENCE call_log_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.call_log_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.call_log_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.call_log_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.call_log_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.call_log_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.call_log_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.call_log_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.call_log_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.call_log_id_seq TO ngalt;


--
-- Name: TABLE charge_package_extend; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON TABLE customer.charge_package_extend TO thirdparty;


--
-- Name: SEQUENCE charge_package_extend_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.charge_package_extend_id_seq TO thirdparty;


--
-- Name: TABLE cmp_service_log; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.cmp_service_log TO subscribercusread;
GRANT SELECT ON TABLE customer.cmp_service_log TO customer_cus_read;
GRANT SELECT ON TABLE customer.cmp_service_log TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.cmp_service_log TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.cmp_service_log TO customer_cus_write;
GRANT SELECT ON TABLE customer.cmp_service_log TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.cmp_service_log TO sale_cus_write;
GRANT SELECT ON TABLE customer.cmp_service_log TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.cmp_service_log TO portal_cus_write;
GRANT SELECT ON TABLE customer.cmp_service_log TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.cmp_service_log TO dist_cus_write;
GRANT SELECT ON TABLE customer.cmp_service_log TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.cmp_service_log TO evo_cus_write;
GRANT SELECT ON TABLE customer.cmp_service_log TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.cmp_service_log TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.cmp_service_log TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.cmp_service_log TO inventory_cus_write;
GRANT SELECT ON TABLE customer.cmp_service_log TO "RA_Team";
GRANT ALL ON TABLE customer.cmp_service_log TO thirdparty;
GRANT ALL ON TABLE customer.cmp_service_log TO ngalt;


--
-- Name: SEQUENCE cmp_service_log_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.cmp_service_log_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.cmp_service_log_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.cmp_service_log_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.cmp_service_log_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.cmp_service_log_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.cmp_service_log_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.cmp_service_log_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.cmp_service_log_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.cmp_service_log_id_seq TO ngalt;


--
-- Name: TABLE cuong_temp; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.cuong_temp TO customer_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.cuong_temp TO customer_cus_write;
GRANT ALL ON TABLE customer.cuong_temp TO thirdparty;
GRANT ALL ON TABLE customer.cuong_temp TO ngalt;


--
-- Name: TABLE customer; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.customer TO subscribercusread;
GRANT SELECT ON TABLE customer.customer TO customer_cus_read;
GRANT SELECT ON TABLE customer.customer TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer TO customer_cus_write;
GRANT SELECT ON TABLE customer.customer TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer TO sale_cus_write;
GRANT SELECT ON TABLE customer.customer TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer TO portal_cus_write;
GRANT SELECT ON TABLE customer.customer TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer TO dist_cus_write;
GRANT SELECT ON TABLE customer.customer TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer TO evo_cus_write;
GRANT SELECT ON TABLE customer.customer TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.customer TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.customer TO inventory_cus_write;
GRANT SELECT ON TABLE customer.customer TO complain_cus_read;
GRANT SELECT ON TABLE customer.customer TO "RA_Team" WITH GRANT OPTION;
GRANT ALL ON TABLE customer.customer TO thirdparty;
GRANT ALL ON TABLE customer.customer TO apigw;
GRANT ALL ON TABLE customer.customer TO ngalt;
GRANT ALL ON TABLE customer.customer TO job_loyalty;


--
-- Name: TABLE customer_account; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.customer_account TO subscribercusread;
GRANT SELECT ON TABLE customer.customer_account TO customer_cus_read;
GRANT SELECT ON TABLE customer.customer_account TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_account TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_account TO customer_cus_write;
GRANT SELECT ON TABLE customer.customer_account TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_account TO sale_cus_write;
GRANT SELECT ON TABLE customer.customer_account TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_account TO portal_cus_write;
GRANT SELECT ON TABLE customer.customer_account TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_account TO dist_cus_write;
GRANT SELECT ON TABLE customer.customer_account TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_account TO evo_cus_write;
GRANT SELECT ON TABLE customer.customer_account TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_account TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.customer_account TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_account TO inventory_cus_write;
GRANT SELECT ON TABLE customer.customer_account TO "RA_Team";
GRANT ALL ON TABLE customer.customer_account TO thirdparty;
GRANT ALL ON TABLE customer.customer_account TO ngalt;


--
-- Name: SEQUENCE customer_cust_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.customer_cust_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.customer_cust_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.customer_cust_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.customer_cust_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.customer_cust_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.customer_cust_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.customer_cust_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.customer_cust_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.customer_cust_id_seq TO ngalt;


--
-- Name: TABLE customer_bk1009; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.customer_bk1009 TO customer_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_bk1009 TO customer_cus_write;
GRANT ALL ON TABLE customer.customer_bk1009 TO thirdparty;
GRANT ALL ON TABLE customer.customer_bk1009 TO ngalt;


--
-- Name: TABLE customer_config; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.customer_config TO subscribercusread;
GRANT SELECT ON TABLE customer.customer_config TO customer_cus_read;
GRANT SELECT ON TABLE customer.customer_config TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_config TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_config TO customer_cus_write;
GRANT SELECT ON TABLE customer.customer_config TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_config TO sale_cus_write;
GRANT SELECT ON TABLE customer.customer_config TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_config TO portal_cus_write;
GRANT SELECT ON TABLE customer.customer_config TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_config TO dist_cus_write;
GRANT SELECT ON TABLE customer.customer_config TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_config TO evo_cus_write;
GRANT SELECT ON TABLE customer.customer_config TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_config TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.customer_config TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_config TO inventory_cus_write;
GRANT SELECT ON TABLE customer.customer_config TO "RA_Team";
GRANT ALL ON TABLE customer.customer_config TO thirdparty;
GRANT ALL ON TABLE customer.customer_config TO ngalt;


--
-- Name: TABLE customer_document; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.customer_document TO subscribercusread;
GRANT SELECT ON TABLE customer.customer_document TO customer_cus_read;
GRANT SELECT ON TABLE customer.customer_document TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_document TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_document TO customer_cus_write;
GRANT SELECT ON TABLE customer.customer_document TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_document TO sale_cus_write;
GRANT SELECT ON TABLE customer.customer_document TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_document TO portal_cus_write;
GRANT SELECT ON TABLE customer.customer_document TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_document TO dist_cus_write;
GRANT SELECT ON TABLE customer.customer_document TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_document TO evo_cus_write;
GRANT SELECT ON TABLE customer.customer_document TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_document TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.customer_document TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_document TO inventory_cus_write;
GRANT SELECT ON TABLE customer.customer_document TO "RA_Team";
GRANT ALL ON TABLE customer.customer_document TO thirdparty;
GRANT ALL ON TABLE customer.customer_document TO ngalt;
GRANT ALL ON TABLE customer.customer_document TO job_loyalty;


--
-- Name: SEQUENCE customer_document_cust_doc_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.customer_document_cust_doc_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.customer_document_cust_doc_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.customer_document_cust_doc_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.customer_document_cust_doc_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.customer_document_cust_doc_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.customer_document_cust_doc_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.customer_document_cust_doc_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.customer_document_cust_doc_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.customer_document_cust_doc_id_seq TO ngalt;
GRANT ALL ON SEQUENCE customer.customer_document_cust_doc_id_seq TO job_loyalty;


--
-- Name: SEQUENCE customer_econtract_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.customer_econtract_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.customer_econtract_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.customer_econtract_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.customer_econtract_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.customer_econtract_id_seq TO ngalt;


--
-- Name: TABLE customer_econtract; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.customer_econtract TO customer_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_econtract TO customer_cus_write;
GRANT SELECT ON TABLE customer.customer_econtract TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_econtract TO sale_cus_write;
GRANT ALL ON TABLE customer.customer_econtract TO thirdparty;
GRANT ALL ON TABLE customer.customer_econtract TO subscriber_cus_write;
GRANT SELECT ON TABLE customer.customer_econtract TO subscriber_cus_read;
GRANT ALL ON TABLE customer.customer_econtract TO ngalt;


--
-- Name: TABLE customer_history; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.customer_history TO subscribercusread;
GRANT SELECT ON TABLE customer.customer_history TO customer_cus_read;
GRANT SELECT ON TABLE customer.customer_history TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history TO customer_cus_write;
GRANT SELECT ON TABLE customer.customer_history TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history TO sale_cus_write;
GRANT SELECT ON TABLE customer.customer_history TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history TO portal_cus_write;
GRANT SELECT ON TABLE customer.customer_history TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history TO dist_cus_write;
GRANT SELECT ON TABLE customer.customer_history TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history TO evo_cus_write;
GRANT SELECT ON TABLE customer.customer_history TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.customer_history TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history TO inventory_cus_write;
GRANT SELECT ON TABLE customer.customer_history TO "RA_Team";
GRANT ALL ON TABLE customer.customer_history TO thirdparty;
GRANT ALL ON TABLE customer.customer_history TO ngalt;


--
-- Name: SEQUENCE customer_history_cust_his_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.customer_history_cust_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_cust_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_cust_his_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_cust_his_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_cust_his_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_cust_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_cust_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_cust_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.customer_history_cust_his_id_seq TO ngalt;


--
-- Name: TABLE customer_history_detail; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.customer_history_detail TO subscribercusread;
GRANT SELECT ON TABLE customer.customer_history_detail TO customer_cus_read;
GRANT SELECT ON TABLE customer.customer_history_detail TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history_detail TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history_detail TO customer_cus_write;
GRANT SELECT ON TABLE customer.customer_history_detail TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history_detail TO sale_cus_write;
GRANT SELECT ON TABLE customer.customer_history_detail TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history_detail TO portal_cus_write;
GRANT SELECT ON TABLE customer.customer_history_detail TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history_detail TO dist_cus_write;
GRANT SELECT ON TABLE customer.customer_history_detail TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history_detail TO evo_cus_write;
GRANT SELECT ON TABLE customer.customer_history_detail TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history_detail TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.customer_history_detail TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_history_detail TO inventory_cus_write;
GRANT SELECT ON TABLE customer.customer_history_detail TO "RA_Team";
GRANT ALL ON TABLE customer.customer_history_detail TO thirdparty;
GRANT ALL ON TABLE customer.customer_history_detail TO ngalt;


--
-- Name: SEQUENCE customer_history_detail_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.customer_history_detail_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_detail_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_detail_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_detail_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_detail_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_detail_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_detail_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.customer_history_detail_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.customer_history_detail_id_seq TO ngalt;


--
-- Name: TABLE customer_kyc_confidence; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.customer_kyc_confidence TO customer_cus_read;
GRANT ALL ON TABLE customer.customer_kyc_confidence TO customer_cus_write;
GRANT SELECT ON TABLE customer.customer_kyc_confidence TO subscriber_cus_read;
GRANT ALL ON TABLE customer.customer_kyc_confidence TO subscriber_cus_write;
GRANT ALL ON TABLE customer.customer_kyc_confidence TO ngalt;


--
-- Name: SEQUENCE customer_kyc_confidence_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.customer_kyc_confidence_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.customer_kyc_confidence_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.customer_kyc_confidence_id_seq TO ngalt;


--
-- Name: TABLE customer_param; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.customer_param TO subscribercusread;
GRANT SELECT ON TABLE customer.customer_param TO customer_cus_read;
GRANT SELECT ON TABLE customer.customer_param TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_param TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_param TO customer_cus_write;
GRANT SELECT ON TABLE customer.customer_param TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_param TO sale_cus_write;
GRANT SELECT ON TABLE customer.customer_param TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_param TO portal_cus_write;
GRANT SELECT ON TABLE customer.customer_param TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_param TO dist_cus_write;
GRANT SELECT ON TABLE customer.customer_param TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_param TO evo_cus_write;
GRANT SELECT ON TABLE customer.customer_param TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_param TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.customer_param TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_param TO inventory_cus_write;
GRANT SELECT ON TABLE customer.customer_param TO "RA_Team";
GRANT ALL ON TABLE customer.customer_param TO thirdparty;
GRANT ALL ON TABLE customer.customer_param TO ngalt;
GRANT ALL ON TABLE customer.customer_param TO job_loyalty;


--
-- Name: SEQUENCE customer_param_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.customer_param_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.customer_param_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.customer_param_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.customer_param_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.customer_param_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.customer_param_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.customer_param_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.customer_param_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.customer_param_id_seq TO ngalt;
GRANT ALL ON SEQUENCE customer.customer_param_id_seq TO job_loyalty;


--
-- Name: TABLE customer_status; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.customer_status TO subscribercusread;
GRANT SELECT ON TABLE customer.customer_status TO customer_cus_read;
GRANT SELECT ON TABLE customer.customer_status TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_status TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_status TO customer_cus_write;
GRANT SELECT ON TABLE customer.customer_status TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_status TO sale_cus_write;
GRANT SELECT ON TABLE customer.customer_status TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_status TO portal_cus_write;
GRANT SELECT ON TABLE customer.customer_status TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_status TO dist_cus_write;
GRANT SELECT ON TABLE customer.customer_status TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_status TO evo_cus_write;
GRANT SELECT ON TABLE customer.customer_status TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_status TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.customer_status TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_status TO inventory_cus_write;
GRANT SELECT ON TABLE customer.customer_status TO "RA_Team";
GRANT ALL ON TABLE customer.customer_status TO thirdparty;
GRANT ALL ON TABLE customer.customer_status TO ngalt;
GRANT ALL ON TABLE customer.customer_status TO job_loyalty;


--
-- Name: TABLE customer_type; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.customer_type TO subscribercusread;
GRANT SELECT ON TABLE customer.customer_type TO customer_cus_read;
GRANT SELECT ON TABLE customer.customer_type TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_type TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_type TO customer_cus_write;
GRANT SELECT ON TABLE customer.customer_type TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_type TO sale_cus_write;
GRANT SELECT ON TABLE customer.customer_type TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_type TO portal_cus_write;
GRANT SELECT ON TABLE customer.customer_type TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_type TO dist_cus_write;
GRANT SELECT ON TABLE customer.customer_type TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_type TO evo_cus_write;
GRANT SELECT ON TABLE customer.customer_type TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_type TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.customer_type TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.customer_type TO inventory_cus_write;
GRANT SELECT ON TABLE customer.customer_type TO "RA_Team";
GRANT ALL ON TABLE customer.customer_type TO thirdparty;
GRANT ALL ON TABLE customer.customer_type TO ngalt;
GRANT ALL ON TABLE customer.customer_type TO job_loyalty;


--
-- Name: SEQUENCE customer_type_cust_type_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.customer_type_cust_type_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.customer_type_cust_type_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.customer_type_cust_type_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.customer_type_cust_type_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.customer_type_cust_type_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.customer_type_cust_type_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.customer_type_cust_type_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.customer_type_cust_type_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.customer_type_cust_type_id_seq TO ngalt;
GRANT ALL ON SEQUENCE customer.customer_type_cust_type_id_seq TO job_loyalty;


--
-- Name: TABLE distribution_resource; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.distribution_resource TO subscribercusread;
GRANT SELECT ON TABLE customer.distribution_resource TO customer_cus_read;
GRANT SELECT ON TABLE customer.distribution_resource TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.distribution_resource TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.distribution_resource TO customer_cus_write;
GRANT SELECT ON TABLE customer.distribution_resource TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.distribution_resource TO sale_cus_write;
GRANT SELECT ON TABLE customer.distribution_resource TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.distribution_resource TO portal_cus_write;
GRANT SELECT ON TABLE customer.distribution_resource TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.distribution_resource TO dist_cus_write;
GRANT SELECT ON TABLE customer.distribution_resource TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.distribution_resource TO evo_cus_write;
GRANT SELECT ON TABLE customer.distribution_resource TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.distribution_resource TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.distribution_resource TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.distribution_resource TO inventory_cus_write;
GRANT SELECT ON TABLE customer.distribution_resource TO "RA_Team";
GRANT ALL ON TABLE customer.distribution_resource TO thirdparty;
GRANT ALL ON TABLE customer.distribution_resource TO ngalt;


--
-- Name: SEQUENCE distribution_resource_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.distribution_resource_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.distribution_resource_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.distribution_resource_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.distribution_resource_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.distribution_resource_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.distribution_resource_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.distribution_resource_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.distribution_resource_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.distribution_resource_id_seq TO ngalt;


--
-- Name: TABLE document_type; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.document_type TO subscribercusread;
GRANT SELECT ON TABLE customer.document_type TO customer_cus_read;
GRANT SELECT ON TABLE customer.document_type TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.document_type TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.document_type TO customer_cus_write;
GRANT SELECT ON TABLE customer.document_type TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.document_type TO sale_cus_write;
GRANT SELECT ON TABLE customer.document_type TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.document_type TO portal_cus_write;
GRANT SELECT ON TABLE customer.document_type TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.document_type TO dist_cus_write;
GRANT SELECT ON TABLE customer.document_type TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.document_type TO evo_cus_write;
GRANT SELECT ON TABLE customer.document_type TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.document_type TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.document_type TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.document_type TO inventory_cus_write;
GRANT SELECT ON TABLE customer.document_type TO "RA_Team";
GRANT ALL ON TABLE customer.document_type TO thirdparty;
GRANT ALL ON TABLE customer.document_type TO ngalt;


--
-- Name: TABLE kyc_job; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.kyc_job TO subscribercusread;
GRANT SELECT ON TABLE customer.kyc_job TO customer_cus_read;
GRANT SELECT ON TABLE customer.kyc_job TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job TO customer_cus_write;
GRANT SELECT ON TABLE customer.kyc_job TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job TO sale_cus_write;
GRANT SELECT ON TABLE customer.kyc_job TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job TO portal_cus_write;
GRANT SELECT ON TABLE customer.kyc_job TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job TO dist_cus_write;
GRANT SELECT ON TABLE customer.kyc_job TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job TO evo_cus_write;
GRANT SELECT ON TABLE customer.kyc_job TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.kyc_job TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job TO inventory_cus_write;
GRANT SELECT ON TABLE customer.kyc_job TO "RA_Team";
GRANT ALL ON TABLE customer.kyc_job TO thirdparty;
GRANT ALL ON TABLE customer.kyc_job TO ngalt;


--
-- Name: SEQUENCE kyc_job_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.kyc_job_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.kyc_job_id_seq TO ngalt;


--
-- Name: TABLE kyc_job_log; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.kyc_job_log TO subscribercusread;
GRANT SELECT ON TABLE customer.kyc_job_log TO customer_cus_read;
GRANT SELECT ON TABLE customer.kyc_job_log TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job_log TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job_log TO customer_cus_write;
GRANT SELECT ON TABLE customer.kyc_job_log TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job_log TO sale_cus_write;
GRANT SELECT ON TABLE customer.kyc_job_log TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job_log TO portal_cus_write;
GRANT SELECT ON TABLE customer.kyc_job_log TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job_log TO dist_cus_write;
GRANT SELECT ON TABLE customer.kyc_job_log TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job_log TO evo_cus_write;
GRANT SELECT ON TABLE customer.kyc_job_log TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job_log TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.kyc_job_log TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.kyc_job_log TO inventory_cus_write;
GRANT SELECT ON TABLE customer.kyc_job_log TO "RA_Team";
GRANT ALL ON TABLE customer.kyc_job_log TO thirdparty;
GRANT ALL ON TABLE customer.kyc_job_log TO ngalt;


--
-- Name: SEQUENCE kyc_job_log_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.kyc_job_log_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_log_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_log_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_log_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_log_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_log_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_log_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.kyc_job_log_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.kyc_job_log_id_seq TO ngalt;


--
-- Name: TABLE log_transaction; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.log_transaction TO subscribercusread;
GRANT SELECT ON TABLE customer.log_transaction TO customer_cus_read;
GRANT SELECT ON TABLE customer.log_transaction TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.log_transaction TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.log_transaction TO customer_cus_write;
GRANT SELECT ON TABLE customer.log_transaction TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.log_transaction TO sale_cus_write;
GRANT SELECT ON TABLE customer.log_transaction TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.log_transaction TO portal_cus_write;
GRANT SELECT ON TABLE customer.log_transaction TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.log_transaction TO dist_cus_write;
GRANT SELECT ON TABLE customer.log_transaction TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.log_transaction TO evo_cus_write;
GRANT SELECT ON TABLE customer.log_transaction TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.log_transaction TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.log_transaction TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.log_transaction TO inventory_cus_write;
GRANT SELECT ON TABLE customer.log_transaction TO "RA_Team";
GRANT ALL ON TABLE customer.log_transaction TO thirdparty;
GRANT ALL ON TABLE customer.log_transaction TO ngalt;


--
-- Name: SEQUENCE log_transaction_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.log_transaction_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.log_transaction_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.log_transaction_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.log_transaction_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.log_transaction_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.log_transaction_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.log_transaction_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.log_transaction_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.log_transaction_id_seq TO ngalt;


--
-- Name: TABLE resources; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.resources TO subscribercusread;
GRANT SELECT ON TABLE customer.resources TO customer_cus_read;
GRANT SELECT ON TABLE customer.resources TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.resources TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.resources TO customer_cus_write;
GRANT SELECT ON TABLE customer.resources TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.resources TO sale_cus_write;
GRANT SELECT ON TABLE customer.resources TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.resources TO portal_cus_write;
GRANT SELECT ON TABLE customer.resources TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.resources TO dist_cus_write;
GRANT SELECT ON TABLE customer.resources TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.resources TO evo_cus_write;
GRANT SELECT ON TABLE customer.resources TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.resources TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.resources TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.resources TO inventory_cus_write;
GRANT SELECT ON TABLE customer.resources TO "RA_Team";
GRANT ALL ON TABLE customer.resources TO thirdparty;
GRANT ALL ON TABLE customer.resources TO ngalt;


--
-- Name: SEQUENCE manage_resource_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.manage_resource_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.manage_resource_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.manage_resource_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.manage_resource_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.manage_resource_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.manage_resource_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.manage_resource_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.manage_resource_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.manage_resource_id_seq TO ngalt;


--
-- Name: TABLE package_vcm_send; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON TABLE customer.package_vcm_send TO job_loyalty;
GRANT ALL ON TABLE customer.package_vcm_send TO thirdparty;


--
-- Name: SEQUENCE package_vcm_send_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.package_vcm_send_id_seq TO job_loyalty;
GRANT ALL ON SEQUENCE customer.package_vcm_send_id_seq TO thirdparty;


--
-- Name: TABLE permission; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.permission TO subscribercusread;
GRANT SELECT ON TABLE customer.permission TO customer_cus_read;
GRANT SELECT ON TABLE customer.permission TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.permission TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.permission TO customer_cus_write;
GRANT SELECT ON TABLE customer.permission TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.permission TO sale_cus_write;
GRANT SELECT ON TABLE customer.permission TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.permission TO portal_cus_write;
GRANT SELECT ON TABLE customer.permission TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.permission TO dist_cus_write;
GRANT SELECT ON TABLE customer.permission TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.permission TO evo_cus_write;
GRANT SELECT ON TABLE customer.permission TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.permission TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.permission TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.permission TO inventory_cus_write;
GRANT SELECT ON TABLE customer.permission TO "RA_Team";
GRANT ALL ON TABLE customer.permission TO thirdparty;
GRANT ALL ON TABLE customer.permission TO ngalt;


--
-- Name: SEQUENCE permission_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.permission_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.permission_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.permission_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.permission_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.permission_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.permission_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.permission_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.permission_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.permission_id_seq TO ngalt;


--
-- Name: SEQUENCE role_account_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.role_account_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE customer.role_account_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE customer.role_account_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE customer.role_account_id_seq TO portal_cus_write;
GRANT ALL ON SEQUENCE customer.role_account_id_seq TO dist_cus_write;
GRANT ALL ON SEQUENCE customer.role_account_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE customer.role_account_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE customer.role_account_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE customer.role_account_id_seq TO ngalt;


--
-- Name: TABLE role_account; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.role_account TO subscribercusread;
GRANT SELECT ON TABLE customer.role_account TO customer_cus_read;
GRANT SELECT ON TABLE customer.role_account TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_account TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_account TO customer_cus_write;
GRANT SELECT ON TABLE customer.role_account TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_account TO sale_cus_write;
GRANT SELECT ON TABLE customer.role_account TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_account TO portal_cus_write;
GRANT SELECT ON TABLE customer.role_account TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_account TO dist_cus_write;
GRANT SELECT ON TABLE customer.role_account TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_account TO evo_cus_write;
GRANT SELECT ON TABLE customer.role_account TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_account TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.role_account TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.role_account TO inventory_cus_write;
GRANT SELECT ON TABLE customer.role_account TO "RA_Team";
GRANT ALL ON TABLE customer.role_account TO thirdparty;
GRANT ALL ON TABLE customer.role_account TO ngalt;


--
-- Name: TABLE role_permission; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.role_permission TO subscribercusread;
GRANT SELECT ON TABLE customer.role_permission TO customer_cus_read;
GRANT SELECT ON TABLE customer.role_permission TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_permission TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_permission TO customer_cus_write;
GRANT SELECT ON TABLE customer.role_permission TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_permission TO sale_cus_write;
GRANT SELECT ON TABLE customer.role_permission TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_permission TO portal_cus_write;
GRANT SELECT ON TABLE customer.role_permission TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_permission TO dist_cus_write;
GRANT SELECT ON TABLE customer.role_permission TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_permission TO evo_cus_write;
GRANT SELECT ON TABLE customer.role_permission TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_permission TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.role_permission TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.role_permission TO inventory_cus_write;
GRANT SELECT ON TABLE customer.role_permission TO "RA_Team";
GRANT ALL ON TABLE customer.role_permission TO thirdparty;
GRANT ALL ON TABLE customer.role_permission TO ngalt;


--
-- Name: TABLE role_resource; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.role_resource TO subscribercusread;
GRANT SELECT ON TABLE customer.role_resource TO customer_cus_read;
GRANT SELECT ON TABLE customer.role_resource TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_resource TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_resource TO customer_cus_write;
GRANT SELECT ON TABLE customer.role_resource TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_resource TO sale_cus_write;
GRANT SELECT ON TABLE customer.role_resource TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_resource TO portal_cus_write;
GRANT SELECT ON TABLE customer.role_resource TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_resource TO dist_cus_write;
GRANT SELECT ON TABLE customer.role_resource TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_resource TO evo_cus_write;
GRANT SELECT ON TABLE customer.role_resource TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.role_resource TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.role_resource TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.role_resource TO inventory_cus_write;
GRANT SELECT ON TABLE customer.role_resource TO "RA_Team";
GRANT ALL ON TABLE customer.role_resource TO thirdparty;
GRANT ALL ON TABLE customer.role_resource TO ngalt;


--
-- Name: TABLE status_account_customer; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.status_account_customer TO subscribercusread;
GRANT SELECT ON TABLE customer.status_account_customer TO customer_cus_read;
GRANT SELECT ON TABLE customer.status_account_customer TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.status_account_customer TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.status_account_customer TO customer_cus_write;
GRANT SELECT ON TABLE customer.status_account_customer TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.status_account_customer TO sale_cus_write;
GRANT SELECT ON TABLE customer.status_account_customer TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.status_account_customer TO portal_cus_write;
GRANT SELECT ON TABLE customer.status_account_customer TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.status_account_customer TO dist_cus_write;
GRANT SELECT ON TABLE customer.status_account_customer TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.status_account_customer TO evo_cus_write;
GRANT SELECT ON TABLE customer.status_account_customer TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.status_account_customer TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.status_account_customer TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.status_account_customer TO inventory_cus_write;
GRANT SELECT ON TABLE customer.status_account_customer TO "RA_Team";
GRANT ALL ON TABLE customer.status_account_customer TO thirdparty;
GRANT ALL ON TABLE customer.status_account_customer TO ngalt;


--
-- Name: TABLE transaction_vcm_point; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON TABLE customer.transaction_vcm_point TO ngalt;
GRANT ALL ON TABLE customer.transaction_vcm_point TO job_loyalty;
GRANT ALL ON TABLE customer.transaction_vcm_point TO thirdparty;


--
-- Name: SEQUENCE transaction_vcm_point_id_seq; Type: ACL; Schema: customer; Owner: postgres
--

GRANT ALL ON SEQUENCE customer.transaction_vcm_point_id_seq TO ngalt;
GRANT ALL ON SEQUENCE customer.transaction_vcm_point_id_seq TO job_loyalty;
GRANT ALL ON SEQUENCE customer.transaction_vcm_point_id_seq TO thirdparty;


--
-- Name: TABLE transfer_money_config; Type: ACL; Schema: customer; Owner: postgres
--

GRANT SELECT ON TABLE customer.transfer_money_config TO subscribercusread;
GRANT SELECT ON TABLE customer.transfer_money_config TO customer_cus_read;
GRANT SELECT ON TABLE customer.transfer_money_config TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.transfer_money_config TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.transfer_money_config TO customer_cus_write;
GRANT SELECT ON TABLE customer.transfer_money_config TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.transfer_money_config TO sale_cus_write;
GRANT SELECT ON TABLE customer.transfer_money_config TO portal_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.transfer_money_config TO portal_cus_write;
GRANT SELECT ON TABLE customer.transfer_money_config TO dist_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.transfer_money_config TO dist_cus_write;
GRANT SELECT ON TABLE customer.transfer_money_config TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.transfer_money_config TO evo_cus_write;
GRANT SELECT ON TABLE customer.transfer_money_config TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE customer.transfer_money_config TO ewallet_cus_write;
GRANT SELECT ON TABLE customer.transfer_money_config TO inventory_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE customer.transfer_money_config TO inventory_cus_write;
GRANT SELECT ON TABLE customer.transfer_money_config TO "RA_Team";
GRANT ALL ON TABLE customer.transfer_money_config TO thirdparty;
GRANT ALL ON TABLE customer.transfer_money_config TO ngalt;


--
-- Name: TABLE exp_table; Type: ACL; Schema: gamification; Owner: postgres
--

GRANT SELECT ON TABLE gamification.exp_table TO "RA_Team";


--
-- Name: TABLE reward; Type: ACL; Schema: gamification; Owner: postgres
--

GRANT SELECT ON TABLE gamification.reward TO "RA_Team";


--
-- Name: TABLE task; Type: ACL; Schema: gamification; Owner: postgres
--

GRANT SELECT ON TABLE gamification.task TO "RA_Team";


--
-- Name: TABLE "user"; Type: ACL; Schema: gamification; Owner: postgres
--

GRANT SELECT ON TABLE gamification."user" TO "RA_Team";


--
-- Name: TABLE user_task; Type: ACL; Schema: gamification; Owner: postgres
--

GRANT SELECT ON TABLE gamification.user_task TO "RA_Team";


--
-- Name: TABLE log_detect_image; Type: ACL; Schema: log; Owner: postgres
--

GRANT SELECT ON TABLE log.log_detect_image TO "RA_Team";


--
-- Name: SEQUENCE log_detect_passport_id_seq; Type: ACL; Schema: log; Owner: postgres
--

GRANT ALL ON SEQUENCE log.log_detect_passport_id_seq TO portal_cus_write;


--
-- Name: TABLE callback_log; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON TABLE mnp.callback_log TO mnp_user;
GRANT ALL ON TABLE mnp.callback_log TO mnp;


--
-- Name: SEQUENCE callback_log_id_seq; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.callback_log_id_seq TO mnp_user;
GRANT ALL ON SEQUENCE mnp.callback_log_id_seq TO mnp;


--
-- Name: SEQUENCE cancel_request_info_id_seq; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.cancel_request_info_id_seq TO mnp_user;
GRANT ALL ON SEQUENCE mnp.cancel_request_info_id_seq TO mnp;


--
-- Name: TABLE cancel_request_info; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON TABLE mnp.cancel_request_info TO mnp_user;
GRANT ALL ON TABLE mnp.cancel_request_info TO mnp;


--
-- Name: SEQUENCE document_id_seq; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.document_id_seq TO mnp_user;
GRANT ALL ON SEQUENCE mnp.document_id_seq TO mnp;


--
-- Name: TABLE document; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON TABLE mnp.document TO mnp_user;
GRANT ALL ON TABLE mnp.document TO mnp;


--
-- Name: SEQUENCE mnp_call_log_id_seq; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.mnp_call_log_id_seq TO mnp_user;
GRANT ALL ON SEQUENCE mnp.mnp_call_log_id_seq TO mnp;


--
-- Name: TABLE mnp_call_log; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON TABLE mnp.mnp_call_log TO mnp_user;
GRANT ALL ON TABLE mnp.mnp_call_log TO mnp;


--
-- Name: TABLE option; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON TABLE mnp.option TO mnp;


--
-- Name: SEQUENCE option_id_seq; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.option_id_seq TO mnp_user;
GRANT ALL ON SEQUENCE mnp.option_id_seq TO mnp;


--
-- Name: SEQUENCE option_id_seq1; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.option_id_seq1 TO mnp;


--
-- Name: SEQUENCE option_value_id_seq; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.option_value_id_seq TO mnp_user;
GRANT ALL ON SEQUENCE mnp.option_value_id_seq TO mnp;


--
-- Name: TABLE option_value; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON TABLE mnp.option_value TO mnp_user;
GRANT ALL ON TABLE mnp.option_value TO mnp;


--
-- Name: SEQUENCE order_tmp_info_id_seq; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.order_tmp_info_id_seq TO mnp_user;
GRANT ALL ON SEQUENCE mnp.order_tmp_info_id_seq TO mnp;


--
-- Name: TABLE order_tmp_info; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON TABLE mnp.order_tmp_info TO mnp_user;
GRANT ALL ON TABLE mnp.order_tmp_info TO mnp;


--
-- Name: TABLE registry_mnp; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON TABLE mnp.registry_mnp TO mnp;


--
-- Name: SEQUENCE registry_mnp_id_seq; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.registry_mnp_id_seq TO mnp;


--
-- Name: SEQUENCE representative_info_id_seq; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.representative_info_id_seq TO mnp_user;
GRANT ALL ON SEQUENCE mnp.representative_info_id_seq TO mnp;


--
-- Name: TABLE representative_info; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON TABLE mnp.representative_info TO mnp_user;
GRANT ALL ON TABLE mnp.representative_info TO mnp;


--
-- Name: SEQUENCE request_mnp_id_seq; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.request_mnp_id_seq TO mnp_user;
GRANT ALL ON SEQUENCE mnp.request_mnp_id_seq TO mnp;


--
-- Name: TABLE request_mnp; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON TABLE mnp.request_mnp TO mnp_user;
GRANT ALL ON TABLE mnp.request_mnp TO mnp;


--
-- Name: SEQUENCE request_mnp_tracking_id_seq; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.request_mnp_tracking_id_seq TO mnp_user;
GRANT ALL ON SEQUENCE mnp.request_mnp_tracking_id_seq TO mnp;


--
-- Name: TABLE request_mnp_tracking; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON TABLE mnp.request_mnp_tracking TO mnp_user;
GRANT ALL ON TABLE mnp.request_mnp_tracking TO mnp;


--
-- Name: SEQUENCE sub_mnp_info_id_seq; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON SEQUENCE mnp.sub_mnp_info_id_seq TO mnp_user;
GRANT ALL ON SEQUENCE mnp.sub_mnp_info_id_seq TO mnp;


--
-- Name: TABLE sub_mnp_info; Type: ACL; Schema: mnp; Owner: postgres
--

GRANT ALL ON TABLE mnp.sub_mnp_info TO mnp_user;
GRANT ALL ON TABLE mnp.sub_mnp_info TO mnp;


--
-- Name: TABLE black_list; Type: ACL; Schema: otp; Owner: postgres
--

GRANT ALL ON TABLE otp.black_list TO otp_cus_write;
GRANT SELECT ON TABLE otp.black_list TO otp_cus_read;


--
-- Name: SEQUENCE black_list_id_seq; Type: ACL; Schema: otp; Owner: postgres
--

GRANT ALL ON SEQUENCE otp.black_list_id_seq TO otp_cus_write;


--
-- Name: TABLE check_otp_history; Type: ACL; Schema: otp; Owner: postgres
--

GRANT SELECT ON TABLE otp.check_otp_history TO otp_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE otp.check_otp_history TO otp_cus_write;


--
-- Name: SEQUENCE check_otp_history_id_seq; Type: ACL; Schema: otp; Owner: postgres
--

GRANT ALL ON SEQUENCE otp.check_otp_history_id_seq TO otp_cus_write;


--
-- Name: TABLE check_otp_mail_history; Type: ACL; Schema: otp; Owner: postgres
--

GRANT SELECT ON TABLE otp.check_otp_mail_history TO otp_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE otp.check_otp_mail_history TO otp_cus_write;


--
-- Name: SEQUENCE check_otp_mail_history_id_seq; Type: ACL; Schema: otp; Owner: postgres
--

GRANT ALL ON SEQUENCE otp.check_otp_mail_history_id_seq TO otp_cus_write;


--
-- Name: TABLE code_message; Type: ACL; Schema: otp; Owner: postgres
--

GRANT SELECT ON TABLE otp.code_message TO otp_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE otp.code_message TO otp_cus_write;
GRANT SELECT ON TABLE otp.code_message TO "RA_Team";


--
-- Name: TABLE log_transaction; Type: ACL; Schema: otp; Owner: postgres
--

GRANT SELECT ON TABLE otp.log_transaction TO otp_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE otp.log_transaction TO otp_cus_write;
GRANT SELECT ON TABLE otp.log_transaction TO "RA_Team";


--
-- Name: SEQUENCE log_transaction_id_seq; Type: ACL; Schema: otp; Owner: postgres
--

GRANT ALL ON SEQUENCE otp.log_transaction_id_seq TO otp_cus_write;


--
-- Name: TABLE option; Type: ACL; Schema: otp; Owner: postgres
--

GRANT SELECT ON TABLE otp.option TO otp_cus_read;
GRANT ALL ON TABLE otp.option TO otp_cus_write;


--
-- Name: SEQUENCE option_id_seq; Type: ACL; Schema: otp; Owner: postgres
--

GRANT ALL ON SEQUENCE otp.option_id_seq TO otp_cus_write;


--
-- Name: TABLE option_value; Type: ACL; Schema: otp; Owner: postgres
--

GRANT SELECT ON TABLE otp.option_value TO otp_cus_read;
GRANT ALL ON TABLE otp.option_value TO otp_cus_write;


--
-- Name: SEQUENCE option_value_id_seq; Type: ACL; Schema: otp; Owner: postgres
--

GRANT ALL ON SEQUENCE otp.option_value_id_seq TO otp_cus_write;


--
-- Name: TABLE otp; Type: ACL; Schema: otp; Owner: postgres
--

GRANT SELECT ON TABLE otp.otp TO otp_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE otp.otp TO otp_cus_write;
GRANT SELECT ON TABLE otp.otp TO "RA_Team";


--
-- Name: TABLE otp_code; Type: ACL; Schema: otp; Owner: postgres
--

GRANT SELECT ON TABLE otp.otp_code TO otp_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE otp.otp_code TO otp_cus_write;
GRANT SELECT ON TABLE otp.otp_code TO "RA_Team";


--
-- Name: TABLE otp_config; Type: ACL; Schema: otp; Owner: postgres
--

GRANT SELECT ON TABLE otp.otp_config TO otp_cus_read;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE otp.otp_config TO otp_cus_write;


--
-- Name: TABLE otp_email; Type: ACL; Schema: otp; Owner: postgres
--

GRANT SELECT ON TABLE otp.otp_email TO otp_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE otp.otp_email TO otp_cus_write;
GRANT SELECT ON TABLE otp.otp_email TO "RA_Team";


--
-- Name: SEQUENCE otp_email_id_seq; Type: ACL; Schema: otp; Owner: postgres
--

GRANT ALL ON SEQUENCE otp.otp_email_id_seq TO otp_cus_write;


--
-- Name: SEQUENCE otp_id_seq; Type: ACL; Schema: otp; Owner: postgres
--

GRANT ALL ON SEQUENCE otp.otp_id_seq TO otp_cus_write;


--
-- Name: TABLE abc; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.abc TO "RA_Team";


--
-- Name: TABLE ag_api_resource; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.ag_api_resource TO "RA_Team";


--
-- Name: TABLE custommerdfsdfsdf; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.custommerdfsdfsdf TO "RA_Team";


--
-- Name: TABLE retail_order_retail_order_tracking; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.retail_order_retail_order_tracking TO "RA_Team";


--
-- Name: TABLE account_sub; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.account_sub TO subscribercusread;
GRANT SELECT ON TABLE subscriber.account_sub TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.account_sub TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.account_sub TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.account_sub TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.account_sub TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.account_sub TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.account_sub TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.account_sub TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.account_sub TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.account_sub TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.account_sub TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.account_sub TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.account_sub TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.account_sub TO "RA_Team";
GRANT ALL ON TABLE subscriber.account_sub TO thirdparty;
GRANT SELECT ON TABLE subscriber.account_sub TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.account_sub TO ngalt;


--
-- Name: SEQUENCE account_sub_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.account_sub_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.account_sub_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.account_sub_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.account_sub_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.account_sub_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.account_sub_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.account_sub_id_seq TO ngalt;


--
-- Name: TABLE advance_money_config; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.advance_money_config TO subscribercusread;
GRANT SELECT ON TABLE subscriber.advance_money_config TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.advance_money_config TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.advance_money_config TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.advance_money_config TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.advance_money_config TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.advance_money_config TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.advance_money_config TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.advance_money_config TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.advance_money_config TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.advance_money_config TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.advance_money_config TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.advance_money_config TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.advance_money_config TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.advance_money_config TO "RA_Team";
GRANT ALL ON TABLE subscriber.advance_money_config TO thirdparty;
GRANT SELECT ON TABLE subscriber.advance_money_config TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.advance_money_config TO ngalt;


--
-- Name: SEQUENCE advance_money_config_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.advance_money_config_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.advance_money_config_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.advance_money_config_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.advance_money_config_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.advance_money_config_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.advance_money_config_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.advance_money_config_id_seq TO ngalt;


--
-- Name: TABLE call_log; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.call_log TO subscribercusread;
GRANT SELECT ON TABLE subscriber.call_log TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.call_log TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.call_log TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.call_log TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.call_log TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.call_log TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.call_log TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.call_log TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.call_log TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.call_log TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.call_log TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.call_log TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.call_log TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.call_log TO "RA_Team";
GRANT ALL ON TABLE subscriber.call_log TO thirdparty;
GRANT SELECT ON TABLE subscriber.call_log TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.call_log TO ngalt;


--
-- Name: SEQUENCE call_log_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.call_log_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.call_log_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.call_log_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.call_log_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.call_log_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.call_log_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.call_log_id_seq TO ngalt;


--
-- Name: TABLE cmp_service_log; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.cmp_service_log TO subscribercusread;
GRANT SELECT ON TABLE subscriber.cmp_service_log TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.cmp_service_log TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.cmp_service_log TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.cmp_service_log TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.cmp_service_log TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.cmp_service_log TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.cmp_service_log TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.cmp_service_log TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.cmp_service_log TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.cmp_service_log TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.cmp_service_log TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.cmp_service_log TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.cmp_service_log TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.cmp_service_log TO "RA_Team";
GRANT ALL ON TABLE subscriber.cmp_service_log TO thirdparty;
GRANT SELECT ON TABLE subscriber.cmp_service_log TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.cmp_service_log TO ngalt;


--
-- Name: SEQUENCE cmp_service_log_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.cmp_service_log_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.cmp_service_log_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.cmp_service_log_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.cmp_service_log_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.cmp_service_log_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.cmp_service_log_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.cmp_service_log_id_seq TO ngalt;


--
-- Name: TABLE commitment_cycle; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.commitment_cycle TO thirdparty;
GRANT ALL ON TABLE subscriber.commitment_cycle TO consumer;
GRANT SELECT ON TABLE subscriber.commitment_cycle TO subscriber_cus_read;
GRANT ALL ON TABLE subscriber.commitment_cycle TO ngalt;


--
-- Name: TABLE commitment_cycle_bak_20210427; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.commitment_cycle_bak_20210427 TO ngalt;
GRANT SELECT ON TABLE subscriber.commitment_cycle_bak_20210427 TO subscriber_cus_read;


--
-- Name: TABLE commitment_cycle_history; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.commitment_cycle_history TO thirdparty;
GRANT ALL ON TABLE subscriber.commitment_cycle_history TO ngalt;
GRANT SELECT ON TABLE subscriber.commitment_cycle_history TO subscriber_cus_read;


--
-- Name: SEQUENCE commitment_cycle_history_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.commitment_cycle_history_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.commitment_cycle_history_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.commitment_cycle_history_his_id_seq TO ngalt;


--
-- Name: SEQUENCE commitment_cycle_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.commitment_cycle_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.commitment_cycle_id_seq TO consumer;
GRANT ALL ON SEQUENCE subscriber.commitment_cycle_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.commitment_cycle_id_seq TO ngalt;


--
-- Name: TABLE config_cash_advance; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.config_cash_advance TO subscribercusread;
GRANT SELECT ON TABLE subscriber.config_cash_advance TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.config_cash_advance TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.config_cash_advance TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.config_cash_advance TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.config_cash_advance TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.config_cash_advance TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.config_cash_advance TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.config_cash_advance TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.config_cash_advance TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.config_cash_advance TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.config_cash_advance TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.config_cash_advance TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.config_cash_advance TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.config_cash_advance TO "RA_Team";
GRANT ALL ON TABLE subscriber.config_cash_advance TO thirdparty;
GRANT SELECT ON TABLE subscriber.config_cash_advance TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.config_cash_advance TO ngalt;


--
-- Name: TABLE config_time_cancel; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.config_time_cancel TO thirdparty;
GRANT SELECT ON TABLE subscriber.config_time_cancel TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.config_time_cancel TO ngalt;
GRANT SELECT ON TABLE subscriber.config_time_cancel TO subscriber_cus_read;


--
-- Name: SEQUENCE config_time_cancel_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.config_time_cancel_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.config_time_cancel_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.config_time_cancel_id_seq TO ngalt;


--
-- Name: TABLE customer; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.customer TO thirdparty;
GRANT SELECT ON TABLE subscriber.customer TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.customer TO ngalt;
GRANT SELECT ON TABLE subscriber.customer TO subscriber_cus_read;


--
-- Name: TABLE log_transaction; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.log_transaction TO subscribercusread;
GRANT SELECT ON TABLE subscriber.log_transaction TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.log_transaction TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.log_transaction TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.log_transaction TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.log_transaction TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.log_transaction TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.log_transaction TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.log_transaction TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.log_transaction TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.log_transaction TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.log_transaction TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.log_transaction TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.log_transaction TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.log_transaction TO "RA_Team";
GRANT ALL ON TABLE subscriber.log_transaction TO thirdparty;
GRANT SELECT ON TABLE subscriber.log_transaction TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.log_transaction TO ngalt;


--
-- Name: SEQUENCE log_transaction_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.log_transaction_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.log_transaction_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.log_transaction_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.log_transaction_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.log_transaction_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.log_transaction_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.log_transaction_id_seq TO ngalt;


--
-- Name: TABLE modify_resource_job; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.modify_resource_job TO subscribercusread;
GRANT SELECT ON TABLE subscriber.modify_resource_job TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.modify_resource_job TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.modify_resource_job TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.modify_resource_job TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.modify_resource_job TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.modify_resource_job TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.modify_resource_job TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.modify_resource_job TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.modify_resource_job TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.modify_resource_job TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.modify_resource_job TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.modify_resource_job TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.modify_resource_job TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.modify_resource_job TO "RA_Team";
GRANT ALL ON TABLE subscriber.modify_resource_job TO thirdparty;
GRANT SELECT ON TABLE subscriber.modify_resource_job TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.modify_resource_job TO ngalt;


--
-- Name: SEQUENCE modify_resource_job_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.modify_resource_job_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.modify_resource_job_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.modify_resource_job_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.modify_resource_job_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.modify_resource_job_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.modify_resource_job_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.modify_resource_job_id_seq TO ngalt;


--
-- Name: TABLE modify_resource_job_log; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.modify_resource_job_log TO thirdparty;
GRANT SELECT ON TABLE subscriber.modify_resource_job_log TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.modify_resource_job_log TO ngalt;
GRANT SELECT ON TABLE subscriber.modify_resource_job_log TO subscriber_cus_read;


--
-- Name: SEQUENCE modify_resource_job_log_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.modify_resource_job_log_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.modify_resource_job_log_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.modify_resource_job_log_id_seq TO ngalt;


--
-- Name: TABLE msisdn; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.msisdn TO thirdparty;
GRANT SELECT ON TABLE subscriber.msisdn TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.msisdn TO ngalt;
GRANT SELECT ON TABLE subscriber.msisdn TO subscriber_cus_read;


--
-- Name: TABLE option; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.option TO ngalt;
GRANT SELECT ON TABLE subscriber.option TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.option TO subscriber_cus_read;


--
-- Name: SEQUENCE option_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.option_id_seq TO ngalt;


--
-- Name: TABLE option_value; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.option_value TO ngalt;
GRANT SELECT ON TABLE subscriber.option_value TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.option_value TO subscriber_cus_read;


--
-- Name: SEQUENCE option_value_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.option_value_id_seq TO ngalt;


--
-- Name: TABLE recharge_online_order; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.recharge_online_order TO subscribercusread;
GRANT SELECT ON TABLE subscriber.recharge_online_order TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.recharge_online_order TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.recharge_online_order TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.recharge_online_order TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.recharge_online_order TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.recharge_online_order TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.recharge_online_order TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.recharge_online_order TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.recharge_online_order TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.recharge_online_order TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.recharge_online_order TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.recharge_online_order TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.recharge_online_order TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.recharge_online_order TO "RA_Team";
GRANT ALL ON TABLE subscriber.recharge_online_order TO thirdparty;
GRANT SELECT ON TABLE subscriber.recharge_online_order TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.recharge_online_order TO ngalt;


--
-- Name: SEQUENCE recharge_online_order_order_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.recharge_online_order_order_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.recharge_online_order_order_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.recharge_online_order_order_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.recharge_online_order_order_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.recharge_online_order_order_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.recharge_online_order_order_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.recharge_online_order_order_id_seq TO ngalt;


--
-- Name: SEQUENCE sub_action_action_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_action_action_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_action_action_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_action_action_id_seq TO ngalt;


--
-- Name: TABLE sub_action; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.sub_action TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_action TO ra_team WITH GRANT OPTION;
GRANT SELECT ON TABLE subscriber.sub_action TO subscriber_cus_read;
GRANT ALL ON TABLE subscriber.sub_action TO subscriber_cus_write;
GRANT ALL ON TABLE subscriber.sub_action TO ngalt;


--
-- Name: TABLE sub_activate_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_activate_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_activate_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_activate_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_activate_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_activate_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_activate_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_activate_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_activate_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_activate_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_activate_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_activate_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_activate_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_activate_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_activate_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_activate_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_activate_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_activate_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_activate_his TO ngalt;


--
-- Name: SEQUENCE sub_activate_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_activate_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_activate_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_activate_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_activate_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_activate_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_activate_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_activate_his_id_seq TO ngalt;


--
-- Name: TABLE sub_approve_status; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_approve_status TO subscriber_cus_read;
GRANT ALL ON TABLE subscriber.sub_approve_status TO subscriber_cus_write;
GRANT ALL ON TABLE subscriber.sub_approve_status TO ngalt;


--
-- Name: SEQUENCE sub_approve_status_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_approve_status_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_approve_status_id_seq TO ngalt;


--
-- Name: SEQUENCE sub_approve_status_id_seq1; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_approve_status_id_seq1 TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_approve_status_id_seq1 TO ngalt;


--
-- Name: TABLE sub_block_call_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_block_call_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_block_call_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_block_call_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_block_call_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_block_call_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_block_call_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_block_call_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_block_call_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_block_call_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_block_call_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_block_call_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_block_call_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_block_call_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_block_call_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_block_call_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_block_call_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_block_call_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_block_call_his TO ngalt;


--
-- Name: SEQUENCE sub_block_call_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_block_call_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_block_call_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_block_call_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_block_call_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_block_call_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_block_call_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_block_call_his_id_seq TO ngalt;


--
-- Name: TABLE sub_change_owner_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_change_owner_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_change_owner_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_change_owner_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_change_owner_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_change_owner_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_change_owner_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_change_owner_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_change_owner_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_change_owner_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_change_owner_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_change_owner_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_change_owner_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_change_owner_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_change_owner_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_change_owner_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_change_owner_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_change_owner_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_change_owner_his TO ngalt;


--
-- Name: SEQUENCE sub_change_owner_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_change_owner_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_change_owner_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_change_owner_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_change_owner_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_change_owner_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_change_owner_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_change_owner_his_id_seq TO ngalt;


--
-- Name: TABLE sub_change_sim_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_change_sim_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_change_sim_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_change_sim_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_change_sim_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_change_sim_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_change_sim_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_change_sim_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_change_sim_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_change_sim_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_change_sim_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_change_sim_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_change_sim_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_change_sim_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_change_sim_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_change_sim_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_change_sim_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_change_sim_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_change_sim_his TO ngalt;


--
-- Name: SEQUENCE sub_change_sim_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_change_sim_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_change_sim_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_change_sim_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_change_sim_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_change_sim_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_change_sim_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_change_sim_his_id_seq TO ngalt;


--
-- Name: TABLE sub_charge_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_charge_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_charge_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_charge_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_charge_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_charge_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_charge_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_charge_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_charge_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_charge_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_charge_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_charge_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_charge_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_charge_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_charge_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_charge_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_charge_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_charge_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_charge_his TO ngalt;


--
-- Name: SEQUENCE sub_charge_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_charge_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_charge_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_charge_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_charge_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_charge_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_charge_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_charge_his_id_seq TO ngalt;


--
-- Name: TABLE sub_contact_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_contact_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_contact_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_contact_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_contact_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_contact_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_contact_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_contact_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_contact_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_contact_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_contact_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_contact_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_contact_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_contact_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_contact_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_contact_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_contact_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_contact_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_contact_his TO ngalt;


--
-- Name: SEQUENCE sub_contact_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_contact_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_contact_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_contact_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_contact_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_contact_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_contact_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_contact_his_id_seq TO ngalt;


--
-- Name: TABLE sub_data_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_data_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_data_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_data_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_data_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_data_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_data_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_data_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_data_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_data_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_data_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_data_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_data_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_data_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_data_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_data_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_data_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_data_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_data_his TO ngalt;


--
-- Name: SEQUENCE sub_data_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_data_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_data_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_data_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_data_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_data_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_data_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_data_his_id_seq TO ngalt;


--
-- Name: TABLE sub_debt_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.sub_debt_his TO ngalt;
GRANT SELECT ON TABLE subscriber.sub_debt_his TO subscriber_cus_read;


--
-- Name: SEQUENCE sub_debt_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_debt_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_debt_his_id_seq TO ngalt;


--
-- Name: TABLE sub_mod_expire_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_mod_expire_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_mod_expire_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_mod_expire_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_expire_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_expire_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_mod_expire_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_mod_expire_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_expire_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_expire_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_mod_expire_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_expire_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_mod_expire_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_expire_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_mod_expire_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_mod_expire_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_mod_expire_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_mod_expire_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_mod_expire_his TO ngalt;


--
-- Name: SEQUENCE sub_mod_expire_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_mod_expire_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_expire_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_expire_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_expire_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_expire_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_expire_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_mod_expire_his_id_seq TO ngalt;


--
-- Name: TABLE sub_mod_pack_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_mod_pack_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_mod_pack_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_mod_pack_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_pack_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_pack_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_mod_pack_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_mod_pack_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_pack_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_pack_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_mod_pack_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_pack_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_mod_pack_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_pack_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_mod_pack_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_mod_pack_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_mod_pack_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_mod_pack_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_mod_pack_his TO ngalt;


--
-- Name: SEQUENCE sub_mod_pack_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_mod_pack_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_pack_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_pack_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_pack_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_pack_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_pack_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_mod_pack_his_id_seq TO ngalt;


--
-- Name: TABLE sub_mod_resource_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_mod_resource_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_mod_resource_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_mod_resource_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_resource_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_resource_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_mod_resource_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_mod_resource_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_resource_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_resource_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_mod_resource_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_resource_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_mod_resource_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_mod_resource_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_mod_resource_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_mod_resource_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_mod_resource_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_mod_resource_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_mod_resource_his TO ngalt;


--
-- Name: SEQUENCE sub_mod_resource_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_mod_resource_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_resource_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_resource_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_resource_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_resource_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_mod_resource_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_mod_resource_his_id_seq TO ngalt;


--
-- Name: TABLE sub_package; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_package TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_package TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_package TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_package TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_package TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_package TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_package TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_package TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_package TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_package TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_package TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_package TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_package TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_package TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_package TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_package TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_package TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_package TO ngalt;


--
-- Name: SEQUENCE sub_package_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_package_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_package_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_package_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_package_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_package_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_package_id_seq TO sale_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_package_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_package_id_seq TO ngalt;


--
-- Name: TABLE sub_package_offer; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_package_offer TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_package_offer TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_package_offer TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_package_offer TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_package_offer TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_package_offer TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_package_offer TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_package_offer TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_package_offer TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_package_offer TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_package_offer TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_package_offer TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_package_offer TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_package_offer TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_package_offer TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_package_offer TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_package_offer TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_package_offer TO ngalt;


--
-- Name: SEQUENCE sub_package_offer_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_package_offer_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_package_offer_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_package_offer_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_package_offer_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_package_offer_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_package_offer_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_package_offer_id_seq TO ngalt;


--
-- Name: TABLE sub_param; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_param TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_param TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_param TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_param TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_param TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_param TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_param TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_param TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_param TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_param TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_param TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_param TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_param TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_param TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_param TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_param TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_param TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_param TO ngalt;


--
-- Name: SEQUENCE sub_param_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_param_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_param_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_param_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_param_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_param_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_param_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_param_id_seq TO ngalt;


--
-- Name: TABLE sub_service; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_service TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_service TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_service TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_service TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_service TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_service TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_service TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_service TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_service TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_service TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_service TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_service TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_service TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_service TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_service TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_service TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_service TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_service TO ngalt;


--
-- Name: TABLE sub_service_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_service_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_service_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_service_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_service_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_service_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_service_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_service_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_service_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_service_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_service_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_service_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_service_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_service_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_service_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_service_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_service_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_service_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_service_his TO ngalt;


--
-- Name: SEQUENCE sub_service_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_service_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_service_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_service_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_service_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_service_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_service_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_service_his_id_seq TO ngalt;


--
-- Name: SEQUENCE sub_service_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_service_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_service_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_service_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_service_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_service_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_service_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_service_id_seq TO ngalt;


--
-- Name: TABLE sub_sms_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_sms_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_sms_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_sms_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_sms_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_sms_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_sms_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_sms_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_sms_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_sms_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_sms_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_sms_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_sms_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_sms_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_sms_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_sms_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_sms_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_sms_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_sms_his TO ngalt;


--
-- Name: SEQUENCE sub_sms_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_sms_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_sms_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_sms_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_sms_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_sms_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_sms_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_sms_his_id_seq TO ngalt;


--
-- Name: TABLE sub_state; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.sub_state TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_state TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_state TO subscriber_cus_write;
GRANT ALL ON TABLE subscriber.sub_state TO ngalt;
GRANT SELECT ON TABLE subscriber.sub_state TO subscriber_cus_read;


--
-- Name: SEQUENCE sub_state_action_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_state_action_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_state_action_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_state_action_id_seq TO ngalt;


--
-- Name: TABLE sub_state_action; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.sub_state_action TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_state_action TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_state_action TO subscriber_cus_write;
GRANT ALL ON TABLE subscriber.sub_state_action TO ngalt;
GRANT SELECT ON TABLE subscriber.sub_state_action TO subscriber_cus_read;


--
-- Name: SEQUENCE sub_state_config_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_state_config_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_state_config_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_state_config_id_seq TO ngalt;


--
-- Name: TABLE sub_state_config; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.sub_state_config TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_state_config TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_state_config TO subscriber_cus_write;
GRANT ALL ON TABLE subscriber.sub_state_config TO ngalt;
GRANT SELECT ON TABLE subscriber.sub_state_config TO subscriber_cus_read;


--
-- Name: TABLE sub_state_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.sub_state_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_state_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_state_his TO subscriber_cus_write;
GRANT ALL ON TABLE subscriber.sub_state_his TO ngalt;
GRANT SELECT ON TABLE subscriber.sub_state_his TO subscriber_cus_read;


--
-- Name: SEQUENCE sub_state_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_state_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_state_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_state_his_id_seq TO ngalt;


--
-- Name: SEQUENCE sub_state_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_state_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_state_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_state_id_seq TO ngalt;


--
-- Name: TABLE sub_trans_his; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.sub_trans_his TO subscribercusread;
GRANT SELECT ON TABLE subscriber.sub_trans_his TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.sub_trans_his TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_trans_his TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_trans_his TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.sub_trans_his TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.sub_trans_his TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_trans_his TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_trans_his TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.sub_trans_his TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_trans_his TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.sub_trans_his TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.sub_trans_his TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.sub_trans_his TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.sub_trans_his TO "RA_Team";
GRANT ALL ON TABLE subscriber.sub_trans_his TO thirdparty;
GRANT SELECT ON TABLE subscriber.sub_trans_his TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.sub_trans_his TO ngalt;


--
-- Name: SEQUENCE sub_trans_his_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.sub_trans_his_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_trans_his_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_trans_his_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_trans_his_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_trans_his_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.sub_trans_his_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.sub_trans_his_id_seq TO ngalt;


--
-- Name: TABLE subscriber; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.subscriber TO subscribercusread;
GRANT SELECT ON TABLE subscriber.subscriber TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.subscriber TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.subscriber TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.subscriber TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.subscriber TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.subscriber TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.subscriber TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.subscriber TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.subscriber TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.subscriber TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.subscriber TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.subscriber TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.subscriber TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.subscriber TO "RA_Team";
GRANT SELECT ON TABLE subscriber.subscriber TO job_push_sms;
GRANT ALL ON TABLE subscriber.subscriber TO thirdparty;
GRANT SELECT ON TABLE subscriber.subscriber TO ra_team WITH GRANT OPTION;
GRANT SELECT ON TABLE subscriber.subscriber TO job_freeingresource;
GRANT SELECT ON TABLE subscriber.subscriber TO consumer;
GRANT ALL ON TABLE subscriber.subscriber TO ngalt;
GRANT SELECT ON TABLE subscriber.subscriber TO job_create_shop_and_account;


--
-- Name: TABLE subscriber_config; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.subscriber_config TO subscribercusread;
GRANT SELECT ON TABLE subscriber.subscriber_config TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.subscriber_config TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.subscriber_config TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.subscriber_config TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.subscriber_config TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.subscriber_config TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.subscriber_config TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.subscriber_config TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.subscriber_config TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.subscriber_config TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.subscriber_config TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.subscriber_config TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.subscriber_config TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.subscriber_config TO "RA_Team";
GRANT ALL ON TABLE subscriber.subscriber_config TO thirdparty;
GRANT SELECT ON TABLE subscriber.subscriber_config TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.subscriber_config TO ngalt;


--
-- Name: TABLE subscriber_ocs; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON TABLE subscriber.subscriber_ocs TO ngalt;
GRANT SELECT ON TABLE subscriber.subscriber_ocs TO subscriber_cus_read;


--
-- Name: SEQUENCE subscriber_sub_id_seq; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT ALL ON SEQUENCE subscriber.subscriber_sub_id_seq TO subscriber_cus_write;
GRANT ALL ON SEQUENCE subscriber.subscriber_sub_id_seq TO customer_cus_write;
GRANT ALL ON SEQUENCE subscriber.subscriber_sub_id_seq TO inventory_cus_write;
GRANT ALL ON SEQUENCE subscriber.subscriber_sub_id_seq TO evo_cus_write;
GRANT ALL ON SEQUENCE subscriber.subscriber_sub_id_seq TO ewallet_cus_write;
GRANT ALL ON SEQUENCE subscriber.subscriber_sub_id_seq TO thirdparty;
GRANT ALL ON SEQUENCE subscriber.subscriber_sub_id_seq TO ngalt;


--
-- Name: TABLE transfer_money_config; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.transfer_money_config TO subscribercusread;
GRANT SELECT ON TABLE subscriber.transfer_money_config TO customer_cus_read;
GRANT SELECT ON TABLE subscriber.transfer_money_config TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.transfer_money_config TO subscriber_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.transfer_money_config TO customer_cus_write;
GRANT SELECT ON TABLE subscriber.transfer_money_config TO inventory_cus_read;
GRANT SELECT ON TABLE subscriber.transfer_money_config TO sale_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.transfer_money_config TO sale_cus_write;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.transfer_money_config TO inventory_cus_write;
GRANT SELECT ON TABLE subscriber.transfer_money_config TO evo_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.transfer_money_config TO evo_cus_write;
GRANT SELECT ON TABLE subscriber.transfer_money_config TO ewallet_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.transfer_money_config TO ewallet_cus_write;
GRANT SELECT ON TABLE subscriber.transfer_money_config TO portal_cus_read;
GRANT SELECT ON TABLE subscriber.transfer_money_config TO "RA_Team";
GRANT ALL ON TABLE subscriber.transfer_money_config TO thirdparty;
GRANT SELECT ON TABLE subscriber.transfer_money_config TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.transfer_money_config TO ngalt;


--
-- Name: TABLE transfer_money_value; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.transfer_money_value TO subscriber_cus_read;
GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE subscriber.transfer_money_value TO subscriber_cus_write;
GRANT ALL ON TABLE subscriber.transfer_money_value TO thirdparty;
GRANT SELECT ON TABLE subscriber.transfer_money_value TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.transfer_money_value TO ngalt;


--
-- Name: TABLE vip_and_test; Type: ACL; Schema: subscriber; Owner: postgres
--

GRANT SELECT ON TABLE subscriber.vip_and_test TO "RA_Team";
GRANT ALL ON TABLE subscriber.vip_and_test TO thirdparty;
GRANT SELECT ON TABLE subscriber.vip_and_test TO ra_team WITH GRANT OPTION;
GRANT ALL ON TABLE subscriber.vip_and_test TO ngalt;
GRANT SELECT ON TABLE subscriber.vip_and_test TO subscriber_cus_read;


--
-- PostgreSQL database dump complete
--

