-- Adminer 4.8.1 PostgreSQL 11.13 (Debian 11.13-0+deb10u1) dump
ALTER DATABASE postgres SET timezone TO 'Europe/Berlin';

CREATE SEQUENCE public.goadmin_users_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_users_myid_seq OWNER TO postgres;

--
-- Name: goadmin_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public.goadmin_users (
    id integer DEFAULT nextval('public.goadmin_users_myid_seq'::regclass) NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    avatar character varying(255),
    remember_token character varying(100),
    CONSTRAINT  goadmin_users_pkey  PRIMARY KEY ( id ),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.goadmin_users OWNER TO postgres;
-----------------------------------------------------------------------------

CREATE SEQUENCE public.goadmin_roles_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_roles_myid_seq OWNER TO postgres;

--
-- Name: goadmin_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public.goadmin_roles (
    id integer DEFAULT nextval('public.goadmin_roles_myid_seq'::regclass) NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT  goadmin_roles_pkey  PRIMARY KEY ( id )

);


ALTER TABLE public.goadmin_roles OWNER TO postgres;


-----------------------------------------------------------------------------------

CREATE SEQUENCE public.goadmin_permissions_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_permissions_myid_seq OWNER TO postgres;

--
-- Name: goadmin_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public.goadmin_permissions (
    id integer DEFAULT nextval('public.goadmin_permissions_myid_seq'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    slug character varying(50) NOT NULL,
    http_method character varying(255),
    http_path text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT  goadmin_permissions_pkey  PRIMARY KEY ( id )

);


ALTER TABLE public.goadmin_permissions OWNER TO postgres;
---------------------------------------------------------------------------------------------
CREATE SEQUENCE public.servers_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.servers_myid_seq OWNER TO postgres;

CREATE TABLE  IF NOT EXISTS public.servers  (
     id  integer DEFAULT nextval('servers_myid_seq'::regclass) NOT NULL,
     user_id  integer DEFAULT '1'  NULL,
     ping  integer DEFAULT '0' NOT NULL,
     name  character varying NOT NULL,
     url  character varying NOT NULL,
     address  character varying NOT NULL,
     last_check  timestamp  NULL,
     details  character varying(255)  NULL,
     status  character varying(255)  NULL,
     last_log  character varying  NULL,
     last_err  character varying NULL,
     created_at  timestamp  with time zone DEFAULT now()  ,
    CONSTRAINT  servers_pkey  PRIMARY KEY ( id ),
    CONSTRAINT fk_goadmin_users FOREIGN KEY (user_id) REFERENCES goadmin_users (id)
) WITH (oids = false);

ALTER TABLE public.servers OWNER TO postgres;
----------------------------------------------------------------------------
CREATE SEQUENCE public.alerts_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.alerts_myid_seq OWNER TO postgres;

CREATE TABLE IF NOT EXISTS public.alerts (
    id integer DEFAULT nextval('alerts_myid_seq'::regclass) NOT NULL,
    server_id integer NOT NULL,
    address character varying NOT NULL,
    url character varying NOT NULL,
    last_send_at timestamp with time zone DEFAULT now(),
    last_send_state character varying NULL,
    last_send_error character varying  NULL,
    CONSTRAINT alerts_pkey PRIMARY KEY ( id ) ,
    CONSTRAINT fk_servers FOREIGN KEY(server_id) REFERENCES servers(id)
) WITH (oids = false);



ALTER TABLE public.alerts OWNER TO postgres;

----------------------------------------------------------------------------------------------
CREATE SEQUENCE public.server_reports_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.server_reports_myid_seq OWNER TO postgres;

CREATE TABLE  IF NOT EXISTS public.server_reports  (
     id  integer DEFAULT nextval('server_reports_myid_seq'::regclass) NOT NULL,
     server_id  integer NOT NULL,
     last_status  character varying(50) NOT NULL,
     ping  integer DEFAULT '0'  NULL,
     last_error  character varying(3000) NULL,
     created_at  timestamp NULL,
    CONSTRAINT  server_reports_pkey  PRIMARY KEY ( id ),
    CONSTRAINT fk_servers FOREIGN KEY (server_id) REFERENCES servers (id)
) WITH (oids = false);

ALTER TABLE public.server_reports OWNER TO postgres;


------------------------------------------------------------------------------------------------


CREATE SEQUENCE public.goadmin_menu_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_menu_myid_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE IF NOT EXISTS public.goadmin_menu (
    id integer DEFAULT nextval('public.goadmin_menu_myid_seq'::regclass) NOT NULL,
    parent_id integer DEFAULT 0 NOT NULL,
    type integer DEFAULT 0,
    "order" integer DEFAULT 0 NOT NULL,
    title character varying(50) NOT NULL,
    header character varying(100),
    plugin_name character varying(100) NOT NULL,
    icon character varying(50) NOT NULL,
    uri character varying(3000) NOT NULL,
    uuid character varying(100),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT  goadmin_menu_pkey  PRIMARY KEY ( id )

)WITH (oids = false);


ALTER TABLE public.goadmin_menu OWNER TO postgres;

--
-- Name: goadmin_operation_log_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goadmin_operation_log_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_operation_log_myid_seq OWNER TO postgres;

--
-- Name: goadmin_operation_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public.goadmin_operation_log (
    id integer DEFAULT nextval('public.goadmin_operation_log_myid_seq'::regclass) NOT NULL,
    user_id integer NOT NULL,
    path character varying(255) NOT NULL,
    method character varying(10) NOT NULL,
    ip character varying(15) NOT NULL,
    input text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT  goadmin_operation_log_pkey  PRIMARY KEY ( id ),
    CONSTRAINT fk_goadmin_users FOREIGN KEY (user_id) REFERENCES goadmin_users (id)


)WITH (oids = false);


ALTER TABLE public.goadmin_operation_log OWNER TO postgres;

--
-- Name: goadmin_site_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goadmin_site_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_site_myid_seq OWNER TO postgres;

--
-- Name: goadmin_site; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public.goadmin_site (
    id integer DEFAULT nextval('public.goadmin_site_myid_seq'::regclass) NOT NULL,
    key character varying(100) NOT NULL,
    value text NOT NULL,
    type integer DEFAULT 0,
    description character varying(3000),
    state integer DEFAULT 0,
    CONSTRAINT  goadmin_site_pkey  PRIMARY KEY ( id ),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
)WITH (oids = false);


ALTER TABLE public.goadmin_site OWNER TO postgres;

--
-- Name: goadmin_permissions_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

--
-- Name: goadmin_role_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public.goadmin_role_menu (
    role_id integer NOT NULL,
    menu_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT fk_goadmin_roles FOREIGN KEY (role_id) REFERENCES goadmin_roles (id),
    CONSTRAINT fk_goadmin_menu FOREIGN KEY (menu_id) REFERENCES goadmin_menu (id)

)WITH (oids = false);


ALTER TABLE public.goadmin_role_menu OWNER TO postgres;

--
-- Name: goadmin_role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public.goadmin_role_permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT fk_goadmin_permissions FOREIGN KEY (permission_id) REFERENCES goadmin_permissions (id),
    CONSTRAINT fk_goadmin_roles FOREIGN KEY (role_id) REFERENCES goadmin_roles (id)

)WITH (oids = false);


ALTER TABLE public.goadmin_role_permissions OWNER TO postgres;

--
-- Name: goadmin_role_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public.goadmin_role_users (
    role_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT fk_goadmin_users FOREIGN KEY (user_id) REFERENCES goadmin_users (id),
    CONSTRAINT fk_goadmin_roles FOREIGN KEY (role_id) REFERENCES goadmin_roles (id)

)WITH (oids = false);


ALTER TABLE public.goadmin_role_users OWNER TO postgres;

--
-- Name: goadmin_roles_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.goadmin_session_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_session_myid_seq OWNER TO postgres;

--
-- Name: goadmin_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public.goadmin_session (
    id integer DEFAULT nextval('public.goadmin_session_myid_seq'::regclass) NOT NULL,
    sid character varying(50) NOT NULL,
    "values" character varying(3000) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
)WITH (oids = false);


ALTER TABLE public.goadmin_session OWNER TO postgres;

--
-- Name: goadmin_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE IF NOT EXISTS public.goadmin_user_permissions (
    user_id integer NOT NULL,
    permission_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT fk_goadmin_permissions FOREIGN KEY (permission_id) REFERENCES goadmin_permissions (id),
    CONSTRAINT fk_goadmin_users FOREIGN KEY (user_id) REFERENCES goadmin_users (id)
    
)WITH (oids = false);


ALTER TABLE public.goadmin_user_permissions OWNER TO postgres;

--
-- Name: goadmin_users_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--


--
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.14
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: goadmin_menu_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

--
-- Name: goadmin_menu; Type: TABLE; Schema: public; Owner: postgres
-- Data for Name: goadmin_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--