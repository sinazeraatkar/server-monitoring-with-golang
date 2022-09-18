

INSERT INTO goadmin_menu (id, parent_id,type, "order", title, icon, uri, plugin_name, header, created_at, updated_at)
VALUES
	(1,0,1,2,'Admin','fa-tasks','','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(2,1,1,2,'Users','fa-users','/info/manager','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(3,1,1,3,'Roles','fa-user','/info/roles','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(4,1,1,4,'Permission','fa-ban','/info/permission','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(5,1,1,5,'Menu','fa-bars','/menu','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(6,1,1,6,'Operation log','fa-history','/info/op','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(7,0,1,1,'Dashboard','fa-bar-chart','/','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
    (8,0,0,2,'server  info','fa-align-justify','/','',NULL,'2022-09-16 21:10:49.322311','2022-09-16 21:11:20'),
    (10,8,0,2,'server report','fa-book','/info/server_reports','',NULL,'2022-09-16 21:12:58.48298','2022-09-16 21:12:58.48298'),
    (11,8,0,2,'Alerts','fa-bell','/info/alerts','',NULL,'2022-09-16 21:13:43.886892','2022-09-16 21:13:43.886892'),
    (9,8,0,2,'servers','fa-server','/info/servers','',NULL,'2022-09-16 21:11:13.852438','2022-09-16 21:13:55');

--



INSERT INTO goadmin_roles (id, name, slug, created_at, updated_at)
VALUES
	(1,'Administrator','administrator','2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(2,'Operator','operator','2019-09-10 00:00:00','2019-09-10 00:00:00');

INSERT INTO goadmin_users (id, username, password, name, avatar, remember_token, created_at, updated_at)
VALUES
	(1,'admin','$2a$10$U3F/NSaf2kaVbyXTBp7ppOn0jZFyRqXRnYXB.AMioCjXl3Ciaj4oy','admin','','tlNcBVK9AvfYH7WEnwB1RKvocJu8FfRy4um3DJtwdHuJy0dwFsLOgAc0xUfh','2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(2,'operator','$2a$10$rVqkOzHjN2MdlEprRflb1eGP0oZXuSrbJLOmJagFsCd81YZm0bsh.','Operator','',NULL,'2019-09-10 00:00:00','2019-09-10 00:00:00');


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




INSERT INTO goadmin_user_permissions (user_id, permission_id, created_at, updated_at)
VALUES
	(1,1,'2019-09-10 00:00:00','2019-09-10 00:00:00'),
	(2,2,'2019-09-10 00:00:00','2019-09-10 00:00:00');

------------------------------------------------------------------
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



REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--
