-- Adminer 4.8.1 PostgreSQL 11.13 (Debian 11.13-0+deb10u1) dump


-- DROP TABLE IF EXISTS alerts;
-- DROP SEQUENCE IF EXISTS alerts_id_seq;
-- CREATE SEQUENCE alerts_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 3 CACHE 1;
CREATE SEQUENCE public.alerts_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.alerts_myid_seq OWNER TO postgres;

CREATE TABLE public.alerts (
    id integer DEFAULT nextval('alerts_myid_seq'::regclass) NOT NULL,
    server_id integer NOT NULL,
    address character varying NOT NULL,
    url character varying NOT NULL,
    last_send_at timestamp NOT NULL,
    last_send_state character varying NOT NULL,
    last_send_error character varying NOT NULL,
    CONSTRAINT alerts_pkey PRIMARY KEY ( id )
) WITH (oids = false);

ALTER TABLE public.alerts OWNER TO postgres;


-- DROP TABLE IF EXISTS  server_reports ;
-- DROP SEQUENCE IF EXISTS server_reports_id_seq;
-- CREATE SEQUENCE server_reports_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 196 CACHE 1;

CREATE SEQUENCE public.server_reports_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.server_reports_myid_seq OWNER TO postgres;

CREATE TABLE  public.server_reports  (
     id  integer DEFAULT nextval('server_reports_myid_seq'::regclass) NOT NULL,
     server_id  integer NOT NULL,
     last_status  character varying NOT NULL,
     last_error  character varying NOT NULL,
     created_at  timestamp NOT NULL,
    CONSTRAINT  server_reports_pkey  PRIMARY KEY ( id )
) WITH (oids = false);

ALTER TABLE public.server_reports OWNER TO postgres;


-- DROP TABLE IF EXISTS  servers ;
-- DROP SEQUENCE IF EXISTS servers_id_seq;
-- CREATE SEQUENCE servers_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 5 CACHE 1;

CREATE SEQUENCE public.servers_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.servers_myid_seq OWNER TO postgres;

CREATE TABLE  public.servers  (
     id  integer DEFAULT nextval('servers_myid_seq'::regclass) NOT NULL,
     user_id  integer DEFAULT '0' NOT NULL,
     ping  integer DEFAULT '0' NOT NULL,
     name  character varying NOT NULL,
     url  character varying NOT NULL,
     address  character varying NOT NULL,
     last_check  timestamp NOT NULL,
     details  character varying NOT NULL,
     status  character varying NOT NULL,
     last_log  character varying NOT NULL,
     last_err  character varying NOT NULL,
     created_at  timestamp NOT NULL,
    CONSTRAINT  servers_pkey  PRIMARY KEY ( id )
) WITH (oids = false);

ALTER TABLE public.servers OWNER TO postgres;


-- DROP TABLE IF EXISTS  users ;
-- DROP SEQUENCE IF EXISTS users_id_seq;
-- CREATE SEQUENCE users_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 4 CACHE 1;

CREATE SEQUENCE public.users_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.users_myid_seq OWNER TO postgres;

CREATE TABLE  public.users  (
     id  integer DEFAULT nextval('users_myid_seq'::regclass) NOT NULL,
     username  character varying NOT NULL,
     password  character varying NOT NULL,
    CONSTRAINT  users_pkey  PRIMARY KEY ( id ),
    CONSTRAINT  users_username  UNIQUE ( username )
) WITH (oids = false);

ALTER TABLE public.users OWNER TO postgres;

 ALTER TABLE   alerts  ADD CONSTRAINT fk_alerts_servers FOREIGN KEY (server_id) REFERENCES servers (id);
 ALTER TABLE  server_reports ADD CONSTRAINT fk_server_reports_servers FOREIGN KEY (server_id) REFERENCES servers (id);
 ALTER TABLE  servers ADD CONSTRAINT fk_servers_users FOREIGN KEY (user_id) REFERENCES users (id);

-- 2022-01-27 20:45:33.462587+03:30

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

CREATE SEQUENCE public.goadmin_menu_myid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE public.goadmin_menu_myid_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: goadmin_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.goadmin_menu (
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
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


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

CREATE TABLE public.goadmin_operation_log (
    id integer DEFAULT nextval('public.goadmin_operation_log_myid_seq'::regclass) NOT NULL,
    user_id integer NOT NULL,
    path character varying(255) NOT NULL,
    method character varying(10) NOT NULL,
    ip character varying(15) NOT NULL,
    input text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()

);


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

CREATE TABLE public.goadmin_site (
    id integer DEFAULT nextval('public.goadmin_site_myid_seq'::regclass) NOT NULL,
    key character varying(100) NOT NULL,
    value text NOT NULL,
    type integer DEFAULT 0,
    description character varying(3000),
    state integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.goadmin_site OWNER TO postgres;

--
-- Name: goadmin_permissions_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

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

CREATE TABLE public.goadmin_permissions (
    id integer DEFAULT nextval('public.goadmin_permissions_myid_seq'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    slug character varying(50) NOT NULL,
    http_method character varying(255),
    http_path text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.goadmin_permissions OWNER TO postgres;

--
-- Name: goadmin_role_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.goadmin_role_menu (
    role_id integer NOT NULL,
    menu_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()


);


ALTER TABLE public.goadmin_role_menu OWNER TO postgres;

--
-- Name: goadmin_role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.goadmin_role_permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
    

);


ALTER TABLE public.goadmin_role_permissions OWNER TO postgres;

--
-- Name: goadmin_role_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.goadmin_role_users (
    role_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
    


);


ALTER TABLE public.goadmin_role_users OWNER TO postgres;

--
-- Name: goadmin_roles_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

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

CREATE TABLE public.goadmin_roles (
    id integer DEFAULT nextval('public.goadmin_roles_myid_seq'::regclass) NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.goadmin_roles OWNER TO postgres;

--
-- Name: goadmin_session_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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

CREATE TABLE public.goadmin_session (
    id integer DEFAULT nextval('public.goadmin_session_myid_seq'::regclass) NOT NULL,
    sid character varying(50) NOT NULL,
    "values" character varying(3000) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.goadmin_session OWNER TO postgres;

--
-- Name: goadmin_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.goadmin_user_permissions (
    user_id integer NOT NULL,
    permission_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
    
);


ALTER TABLE public.goadmin_user_permissions OWNER TO postgres;

--
-- Name: goadmin_users_myid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

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

CREATE TABLE public.goadmin_users (
    id integer DEFAULT nextval('public.goadmin_users_myid_seq'::regclass) NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    avatar character varying(255),
    remember_token character varying(100),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.goadmin_users OWNER TO postgres;

--
-- Data for Name: goadmin_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--


INSERT INTO goadmin_menu (id, parent_id,type, "order", title, icon, uri, plugin_name, header, created_at, updated_at)
VALUES
	(1,0,1,2,'Admin','fa-tasks','','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(2,1,1,2,'Users','fa-users','/info/manager','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(3,1,1,3,'Roles','fa-user','/info/roles','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(4,1,1,4,'Permission','fa-ban','/info/permission','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(5,1,1,5,'Menu','fa-bars','/menu','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(6,1,1,6,'Operation log','fa-history','/info/op','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(7,0,1,1,'Dashboard','fa-bar-chart','/','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00');

--
-- Data for Name: goadmin_operation_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.goadmin_operation_log (id, user_id, path, method, ip, input, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: goadmin_site; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.goadmin_site (id, key, value, description, state, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: goadmin_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO goadmin_permissions (id, name, slug, http_method, http_path, created_at, updated_at)
VALUES
	(1,'All permission','*','','*','2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(2,'Dashboard','dashboard','GET,PUT,POST,DELETE','/','2019-09-10 00:00:00','2019-09-10 00:00:00');

--
-- Data for Name: goadmin_role_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO goadmin_role_menu (role_id, menu_id, created_at,updated_at)
VALUES
	(1,1,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(1,7,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(2,7,'2019-09-10 00:00:00','2019-09-10 00:00:00');

--
-- Data for Name: goadmin_role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO goadmin_role_permissions (role_id, permission_id, created_at, updated_at)
VALUES
	(1,1,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(1,2,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(2,2,'2019-09-10 00:00:00','2019-09-10 00:00:00');

--
-- Data for Name: goadmin_role_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO goadmin_role_users (role_id, user_id, created_at, updated_at)
VALUES
	(1,1,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(2,2,'2019-09-10 00:00:00','2019-09-10 00:00:00');


--
-- Data for Name: goadmin_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--


INSERT INTO goadmin_roles (id, name, slug, created_at, updated_at)
VALUES
	(1,'Administrator','administrator','2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(2,'Operator','operator','2019-09-10 00:00:00','2019-09-10 00:00:00');


--
-- Data for Name: goadmin_session; Type: TABLE DATA; Schema: public; Owner: postgres
--


--
-- Data for Name: goadmin_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--


INSERT INTO goadmin_user_permissions (user_id, permission_id, created_at, updated_at)
VALUES
	(1,1,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(2,2,'2019-09-10 00:00:00','2019-09-10 00:00:00');


--
-- Data for Name: goadmin_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO goadmin_users (id, username, password, name, avatar, remember_token, created_at, updated_at)
VALUES
	(1,'admin','$2a$10$U3F/NSaf2kaVbyXTBp7ppOn0jZFyRqXRnYXB.AMioCjXl3Ciaj4oy','admin','','tlNcBVK9AvfYH7WEnwB1RKvocJu8FfRy4um3DJtwdHuJy0dwFsLOgAc0xUfh','2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(2,'operator','$2a$10$rVqkOzHjN2MdlEprRflb1eGP0oZXuSrbJLOmJagFsCd81YZm0bsh.','Operator','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00');




 ALTER TABLE goadmin_operation_log ADD CONSTRAINT fk_goadmin_operation_log_goadmin_users FOREIGN KEY (user_id) REFERENCES goadmin_users (id);
 ALTER TABLE  goadmin_role_permissions ADD CONSTRAINT fk_goadmin_role_permissions_goadmin_roles FOREIGN KEY (role_id) REFERENCES goadmin_roles (id);
 ALTER TABLE  goadmin_role_permissions ADD CONSTRAINT fk_goadmin_role_permissions_goadmin_permissions FOREIGN KEY (permission_id) REFERENCES goadmin_permissions (id);
  ALTER TABLE  goadmin_role_menu ADD CONSTRAINT fk_goadmin_role_menu_goadmin_menu FOREIGN KEY (menu_id) REFERENCES goadmin_menu (id);
 ALTER TABLE  goadmin_role_menu ADD CONSTRAINT fk_goadmin_role_menu_goadmin_roles FOREIGN KEY (role_id) REFERENCES goadmin_roles (id);
 ALTER TABLE goadmin_user_permissions ADD CONSTRAINT fk_goadmin_user_permissions_goadmin_users FOREIGN KEY (user_id) REFERENCES goadmin_users (id);
 ALTER TABLE goadmin_user_permissions ADD CONSTRAINT fk_goadmin_user_permissions_goadmin_permissions FOREIGN KEY (permission_id) REFERENCES goadmin_permissions (id);
 ALTER TABLE goadmin_role_users ADD CONSTRAINT fk_goadmin_role_users_goadmin_roles FOREIGN KEY (role_id) REFERENCES goadmin_roles (id);
 ALTER TABLE goadmin_role_users ADD CONSTRAINT fk_goadmin_role_users_goadmin_users FOREIGN KEY (user_id) REFERENCES goadmin_users (id);

-- ALTER TABLE ConstraintDemoChild
-- ADD CONSTRAINT FK__ConstraintDe__ID
-- FOREIGN KEY (ID) REFERENCES ConstraintDemoParent(ID);
--
-- Name: goadmin_menu_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_menu_myid_seq', 7, true);


--
-- Name: goadmin_operation_log_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_operation_log_myid_seq', 1, true);


--
-- Name: goadmin_permissions_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_permissions_myid_seq', 2, true);


--
-- Name: goadmin_roles_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_roles_myid_seq', 2, true);


--
-- Name: goadmin_site_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_site_myid_seq', 1, true);


--
-- Name: goadmin_session_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_session_myid_seq', 1, true);


--
-- Name: goadmin_users_myid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.goadmin_users_myid_seq', 2, true);


--
-- Name: goadmin_menu goadmin_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goadmin_menu
    ADD CONSTRAINT goadmin_menu_pkey PRIMARY KEY (id);


--
-- Name: goadmin_operation_log goadmin_operation_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goadmin_operation_log
    ADD CONSTRAINT goadmin_operation_log_pkey PRIMARY KEY (id);


--
-- Name: goadmin_permissions goadmin_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goadmin_permissions
    ADD CONSTRAINT goadmin_permissions_pkey PRIMARY KEY (id);


--
-- Name: goadmin_roles goadmin_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goadmin_roles
    ADD CONSTRAINT goadmin_roles_pkey PRIMARY KEY (id);


--
-- Name: goadmin_site goadmin_site_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goadmin_site
    ADD CONSTRAINT goadmin_site_pkey PRIMARY KEY (id);


--
-- Name: goadmin_session goadmin_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goadmin_session
    ADD CONSTRAINT goadmin_session_pkey PRIMARY KEY (id);


--
-- Name: goadmin_users goadmin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goadmin_users
    ADD CONSTRAINT goadmin_users_pkey PRIMARY KEY (id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--
