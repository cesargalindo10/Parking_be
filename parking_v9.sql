--
-- PostgreSQL database dump
--

-- Dumped from database version 14.8 (Ubuntu 14.8-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 15.2 (Ubuntu 15.2-1.pgdg22.04+1)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_assignment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_assignment (
    item_name character varying(64) NOT NULL,
    user_id character varying(64) NOT NULL,
    created_at integer
);


ALTER TABLE public.auth_assignment OWNER TO postgres;

--
-- Name: auth_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_item (
    name character varying(64) NOT NULL,
    type smallint NOT NULL,
    description text,
    rule_name character varying(64),
    data bytea,
    created_at integer,
    updated_at integer
);


ALTER TABLE public.auth_item OWNER TO postgres;

--
-- Name: auth_item_child; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_item_child (
    parent character varying(64) NOT NULL,
    child character varying(64) NOT NULL
);


ALTER TABLE public.auth_item_child OWNER TO postgres;

--
-- Name: auth_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_rule (
    name character varying(64) NOT NULL,
    data bytea,
    created_at integer,
    updated_at integer
);


ALTER TABLE public.auth_rule OWNER TO postgres;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    id integer NOT NULL,
    nombre_completo character varying(50) NOT NULL,
    ci integer NOT NULL,
    email character varying(80) NOT NULL,
    placa character varying(10) NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    password_hash character varying NOT NULL,
    access_token character varying NOT NULL,
    telefono integer,
    cargo character varying(50),
    unidad character varying(20),
    rol character varying(15) DEFAULT 'cliente'::character varying
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cliente_id_seq OWNER TO postgres;

--
-- Name: cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.id;


--
-- Name: informacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.informacion (
    id integer NOT NULL,
    qr character varying(50) NOT NULL,
    convocatoria character varying(50),
    fecha_pub_conv date,
    fecha_inicio_reserva date,
    fecha_limite_reserva date,
    atencion character varying(100),
    foto character varying(50),
    mensaje_mora character varying(240),
    fecha_fin_reserva date
);


ALTER TABLE public.informacion OWNER TO postgres;

--
-- Name: informacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.informacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.informacion_id_seq OWNER TO postgres;

--
-- Name: informacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.informacion_id_seq OWNED BY public.informacion.id;


--
-- Name: migration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migration (
    version character varying(180) NOT NULL,
    apply_time integer
);


ALTER TABLE public.migration OWNER TO postgres;

--
-- Name: nueva_secuencia; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nueva_secuencia
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nueva_secuencia OWNER TO postgres;

--
-- Name: nueva_secuencia2; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nueva_secuencia2
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nueva_secuencia2 OWNER TO postgres;

--
-- Name: pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pago (
    id integer NOT NULL,
    fecha timestamp without time zone DEFAULT now(),
    nro_cuotas_pagadas smallint NOT NULL,
    reserva_id integer NOT NULL,
    total smallint NOT NULL,
    comprobante character varying(50),
    estado boolean NOT NULL,
    tipo_pago character varying(20) NOT NULL
);


ALTER TABLE public.pago OWNER TO postgres;

--
-- Name: pago_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pago_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pago_id_seq OWNER TO postgres;

--
-- Name: pago_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pago_id_seq OWNED BY public.pago.id;


--
-- Name: parqueo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parqueo (
    id integer NOT NULL,
    nombre character varying(80) NOT NULL,
    nro_plazas integer NOT NULL,
    plazas_disponibles smallint,
    plazas_ocupadas smallint,
    nro_filas smallint NOT NULL,
    nro_columnas smallint NOT NULL,
    descripcion character varying(80)
);


ALTER TABLE public.parqueo OWNER TO postgres;

--
-- Name: parqueo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parqueo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.parqueo_id_seq OWNER TO postgres;

--
-- Name: parqueo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parqueo_id_seq OWNED BY public.parqueo.id;


--
-- Name: plaza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plaza (
    id integer NOT NULL,
    estado character varying(20) NOT NULL,
    numero character varying(10) NOT NULL,
    parqueo_id integer NOT NULL,
    habilitado boolean DEFAULT false
);


ALTER TABLE public.plaza OWNER TO postgres;

--
-- Name: plaza_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.plaza_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plaza_id_seq OWNER TO postgres;

--
-- Name: plaza_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.plaza_id_seq OWNED BY public.plaza.id;


--
-- Name: registro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registro (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    fecha_ingreso timestamp without time zone,
    fecha_salida timestamp without time zone,
    cliente_id integer NOT NULL
);


ALTER TABLE public.registro OWNER TO postgres;

--
-- Name: registro_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.registro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registro_id_seq OWNER TO postgres;

--
-- Name: registro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.registro_id_seq OWNED BY public.registro.id;


--
-- Name: reserva; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reserva (
    id integer NOT NULL,
    estado character varying(25) DEFAULT false NOT NULL,
    fecha_inicio timestamp without time zone DEFAULT now() NOT NULL,
    fecha_fin timestamp without time zone NOT NULL,
    cliente_id integer NOT NULL,
    plaza_id integer NOT NULL,
    tarifa_id integer NOT NULL,
    cantidad smallint,
    couta boolean,
    finalizado boolean DEFAULT false NOT NULL
);


ALTER TABLE public.reserva OWNER TO postgres;

--
-- Name: reserva_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reserva_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reserva_id_seq OWNER TO postgres;

--
-- Name: reserva_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reserva_id_seq OWNED BY public.reserva.id;


--
-- Name: sugerencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sugerencia (
    id integer NOT NULL,
    cliente_id integer NOT NULL,
    mensaje character varying NOT NULL
);


ALTER TABLE public.sugerencia OWNER TO postgres;

--
-- Name: sugerencia_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sugerencia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sugerencia_id_seq OWNER TO postgres;

--
-- Name: sugerencia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sugerencia_id_seq OWNED BY public.sugerencia.id;


--
-- Name: tarifa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tarifa (
    id integer NOT NULL,
    nombre character varying(10) NOT NULL,
    costo integer NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    couta boolean
);


ALTER TABLE public.tarifa OWNER TO postgres;

--
-- Name: tarifa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tarifa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tarifa_id_seq OWNER TO postgres;

--
-- Name: tarifa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tarifa_id_seq OWNED BY public.tarifa.id;


--
-- Name: turno; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.turno (
    nombre character varying(20) NOT NULL,
    hora_inicio time without time zone NOT NULL,
    hora_fin time without time zone NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.turno OWNER TO postgres;

--
-- Name: turno_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.turno_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.turno_id_seq OWNER TO postgres;

--
-- Name: turno_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.turno_id_seq OWNED BY public.turno.id;


--
-- Name: turno_usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.turno_usuario (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    turno_id integer NOT NULL
);


ALTER TABLE public.turno_usuario OWNER TO postgres;

--
-- Name: turno_usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.turno_usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.turno_usuario_id_seq OWNER TO postgres;

--
-- Name: turno_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.turno_usuario_id_seq OWNED BY public.turno_usuario.id;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id integer DEFAULT nextval('public.nueva_secuencia2'::regclass) NOT NULL,
    nombre character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    rol character varying(20) NOT NULL,
    password_hash character varying NOT NULL,
    access_token character varying NOT NULL,
    estado boolean DEFAULT true NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_id_seq OWNER TO postgres;

--
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;


--
-- Name: cliente id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente ALTER COLUMN id SET DEFAULT nextval('public.cliente_id_seq'::regclass);


--
-- Name: informacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.informacion ALTER COLUMN id SET DEFAULT nextval('public.informacion_id_seq'::regclass);


--
-- Name: pago id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago ALTER COLUMN id SET DEFAULT nextval('public.pago_id_seq'::regclass);


--
-- Name: parqueo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parqueo ALTER COLUMN id SET DEFAULT nextval('public.parqueo_id_seq'::regclass);


--
-- Name: plaza id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plaza ALTER COLUMN id SET DEFAULT nextval('public.plaza_id_seq'::regclass);


--
-- Name: registro id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro ALTER COLUMN id SET DEFAULT nextval('public.registro_id_seq'::regclass);


--
-- Name: reserva id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reserva ALTER COLUMN id SET DEFAULT nextval('public.reserva_id_seq'::regclass);


--
-- Name: sugerencia id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sugerencia ALTER COLUMN id SET DEFAULT nextval('public.sugerencia_id_seq'::regclass);


--
-- Name: tarifa id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarifa ALTER COLUMN id SET DEFAULT nextval('public.tarifa_id_seq'::regclass);


--
-- Name: turno id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.turno ALTER COLUMN id SET DEFAULT nextval('public.turno_id_seq'::regclass);


--
-- Name: turno_usuario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.turno_usuario ALTER COLUMN id SET DEFAULT nextval('public.turno_usuario_id_seq'::regclass);


--
-- Data for Name: auth_assignment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_assignment (item_name, user_id, created_at) FROM stdin;
administrador	1001	1686336688
\.


--
-- Data for Name: auth_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_item (name, type, description, rule_name, data, created_at, updated_at) FROM stdin;
administrador	1	\N	\N	\N	\N	\N
operador	1	\N	\N	\N	\N	\N
guardia	1	\N	\N	\N	\N	\N
cliente	1	\N	\N	\N	\N	\N
\.


--
-- Data for Name: auth_item_child; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_item_child (parent, child) FROM stdin;
\.


--
-- Data for Name: auth_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_rule (name, data, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (id, nombre_completo, ci, email, placa, estado, password_hash, access_token, telefono, cargo, unidad, rol) FROM stdin;
\.


--
-- Data for Name: informacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.informacion (id, qr, convocatoria, fecha_pub_conv, fecha_inicio_reserva, fecha_limite_reserva, atencion, foto, mensaje_mora, fecha_fin_reserva) FROM stdin;
5	647a457f0a2ba.png	\N	2023-06-08	2023-07-01	2023-06-30	ds lunes a viernes d	\N	Debe pagar lo mas antes  s2	2023-12-31
\.


--
-- Data for Name: migration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migration (version, apply_time) FROM stdin;
m000000_000000_base	1685669672
m140506_102106_rbac_init	1685669674
m170907_052038_rbac_add_index_on_auth_assignment_user_id	1685669675
m180523_151638_rbac_updates_indexes_without_prefix	1685669675
m200409_110543_rbac_update_mssql_trigger	1685669675
\.


--
-- Data for Name: pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pago (id, fecha, nro_cuotas_pagadas, reserva_id, total, comprobante, estado, tipo_pago) FROM stdin;
\.


--
-- Data for Name: parqueo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parqueo (id, nombre, nro_plazas, plazas_disponibles, plazas_ocupadas, nro_filas, nro_columnas, descripcion) FROM stdin;
1	UMSS 2	100	100	0	10	10	PARQUEO UMSS
\.


--
-- Data for Name: plaza; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plaza (id, estado, numero, parqueo_id, habilitado) FROM stdin;
226	camino	0	1	f
227	camino	1	1	f
228	camino	2	1	f
229	camino	3	1	f
230	camino	4	1	f
231	camino	5	1	f
232	camino	6	1	f
233	camino	7	1	f
234	camino	8	1	f
235	camino	9	1	f
236	camino	10	1	f
237	camino	11	1	f
238	camino	12	1	f
239	camino	13	1	f
240	camino	14	1	f
241	camino	15	1	f
242	camino	16	1	f
243	camino	17	1	f
244	camino	18	1	f
245	camino	19	1	f
246	camino	20	1	f
247	camino	21	1	f
248	camino	22	1	f
249	camino	23	1	f
250	camino	24	1	f
251	camino	25	1	f
252	camino	26	1	f
253	camino	27	1	f
254	camino	28	1	f
255	camino	29	1	f
256	camino	30	1	f
257	camino	31	1	f
258	camino	32	1	f
259	camino	33	1	f
260	camino	34	1	f
261	camino	35	1	f
262	camino	36	1	f
263	camino	37	1	f
264	camino	38	1	f
265	camino	39	1	f
266	camino	40	1	f
267	camino	41	1	f
268	camino	42	1	f
269	camino	43	1	f
270	camino	44	1	f
271	camino	45	1	f
272	camino	46	1	f
273	camino	47	1	f
274	camino	48	1	f
275	camino	49	1	f
276	camino	50	1	f
277	camino	51	1	f
278	camino	52	1	f
279	camino	53	1	f
280	camino	54	1	f
281	camino	55	1	f
282	camino	56	1	f
283	camino	57	1	f
284	camino	58	1	f
285	camino	59	1	f
286	camino	60	1	f
287	camino	61	1	f
288	camino	62	1	f
289	camino	63	1	f
290	camino	64	1	f
291	camino	65	1	f
292	camino	66	1	f
293	camino	67	1	f
294	camino	68	1	f
295	camino	69	1	f
296	camino	70	1	f
297	camino	71	1	f
298	camino	72	1	f
299	camino	73	1	f
300	camino	74	1	f
301	camino	75	1	f
302	camino	76	1	f
303	camino	77	1	f
304	camino	78	1	f
305	camino	79	1	f
306	camino	80	1	f
307	camino	81	1	f
308	camino	82	1	f
309	camino	83	1	f
310	camino	84	1	f
311	camino	85	1	f
312	camino	86	1	f
313	camino	87	1	f
314	camino	88	1	f
315	camino	89	1	f
316	camino	90	1	f
317	camino	91	1	f
318	camino	92	1	f
319	camino	93	1	f
320	camino	94	1	f
321	camino	95	1	f
322	camino	96	1	f
323	camino	97	1	f
324	camino	98	1	f
325	camino	99	1	f
\.


--
-- Data for Name: registro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registro (id, usuario_id, fecha_ingreso, fecha_salida, cliente_id) FROM stdin;
\.


--
-- Data for Name: reserva; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reserva (id, estado, fecha_inicio, fecha_fin, cliente_id, plaza_id, tarifa_id, cantidad, couta, finalizado) FROM stdin;
\.


--
-- Data for Name: sugerencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sugerencia (id, cliente_id, mensaje) FROM stdin;
\.


--
-- Data for Name: tarifa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tarifa (id, nombre, costo, estado, couta) FROM stdin;
5	mes	10	f	f
1	dia	10	f	f
6	año	500	t	t
3	hora	2	t	f
\.


--
-- Data for Name: turno; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.turno (nombre, hora_inicio, hora_fin, id) FROM stdin;
\.


--
-- Data for Name: turno_usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.turno_usuario (id, usuario_id, turno_id) FROM stdin;
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id, nombre, email, rol, password_hash, access_token, estado) FROM stdin;
1001	admin	admin@gmail.com	administrador	$2y$13$WxQz1xZ8xQqH.W7yjfsJ5eM/dPLYeZluuEq5/094eLkm4eE/Zu7SO	V_AkJqzqhVCTr-_sur0HL0isddxBEPcd	t
\.


--
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_id_seq', 9, true);


--
-- Name: informacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.informacion_id_seq', 5, true);


--
-- Name: nueva_secuencia; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nueva_secuencia', 101, true);


--
-- Name: nueva_secuencia2; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nueva_secuencia2', 1001, true);


--
-- Name: pago_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pago_id_seq', 56, true);


--
-- Name: parqueo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parqueo_id_seq', 1, true);


--
-- Name: plaza_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plaza_id_seq', 325, true);


--
-- Name: registro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.registro_id_seq', 1, false);


--
-- Name: reserva_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reserva_id_seq', 57, true);


--
-- Name: sugerencia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sugerencia_id_seq', 7, true);


--
-- Name: tarifa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tarifa_id_seq', 13, true);


--
-- Name: turno_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.turno_id_seq', 1, false);


--
-- Name: turno_usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.turno_usuario_id_seq', 1, false);


--
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_seq', 4, true);


--
-- Name: auth_assignment auth_assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_assignment
    ADD CONSTRAINT auth_assignment_pkey PRIMARY KEY (item_name, user_id);


--
-- Name: auth_item_child auth_item_child_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_item_child
    ADD CONSTRAINT auth_item_child_pkey PRIMARY KEY (parent, child);


--
-- Name: auth_item auth_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_item
    ADD CONSTRAINT auth_item_pkey PRIMARY KEY (name);


--
-- Name: auth_rule auth_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_rule
    ADD CONSTRAINT auth_rule_pkey PRIMARY KEY (name);


--
-- Name: cliente cliente_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pk PRIMARY KEY (id);


--
-- Name: informacion informacion_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.informacion
    ADD CONSTRAINT informacion_pk PRIMARY KEY (id);


--
-- Name: migration migration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migration
    ADD CONSTRAINT migration_pkey PRIMARY KEY (version);


--
-- Name: pago pago_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_pk PRIMARY KEY (id);


--
-- Name: parqueo parqueo_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parqueo
    ADD CONSTRAINT parqueo_pk PRIMARY KEY (id);


--
-- Name: plaza plaza_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plaza
    ADD CONSTRAINT plaza_pk PRIMARY KEY (id);


--
-- Name: registro registro_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro
    ADD CONSTRAINT registro_pk PRIMARY KEY (id);


--
-- Name: reserva reserva_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT reserva_pk PRIMARY KEY (id);


--
-- Name: sugerencia sugerencia_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sugerencia
    ADD CONSTRAINT sugerencia_pk PRIMARY KEY (id);


--
-- Name: tarifa tarifa_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarifa
    ADD CONSTRAINT tarifa_pk PRIMARY KEY (id);


--
-- Name: turno turno_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.turno
    ADD CONSTRAINT turno_pk PRIMARY KEY (id);


--
-- Name: turno_usuario turno_usuario_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.turno_usuario
    ADD CONSTRAINT turno_usuario_pk PRIMARY KEY (id);


--
-- Name: usuario usuario_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pk PRIMARY KEY (id);


--
-- Name: idx-auth_assignment-user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "idx-auth_assignment-user_id" ON public.auth_assignment USING btree (user_id);


--
-- Name: idx-auth_item-type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "idx-auth_item-type" ON public.auth_item USING btree (type);


--
-- Name: auth_assignment auth_assignment_item_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_assignment
    ADD CONSTRAINT auth_assignment_item_name_fkey FOREIGN KEY (item_name) REFERENCES public.auth_item(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auth_item_child auth_item_child_child_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_item_child
    ADD CONSTRAINT auth_item_child_child_fkey FOREIGN KEY (child) REFERENCES public.auth_item(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auth_item_child auth_item_child_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_item_child
    ADD CONSTRAINT auth_item_child_parent_fkey FOREIGN KEY (parent) REFERENCES public.auth_item(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auth_item auth_item_rule_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_item
    ADD CONSTRAINT auth_item_rule_name_fkey FOREIGN KEY (rule_name) REFERENCES public.auth_rule(name) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reserva cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT cliente_fk FOREIGN KEY (cliente_id) REFERENCES public.cliente(id) ON DELETE CASCADE;


--
-- Name: pago pago_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_fk FOREIGN KEY (reserva_id) REFERENCES public.reserva(id) ON DELETE CASCADE;


--
-- Name: plaza plaza_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plaza
    ADD CONSTRAINT plaza_fk FOREIGN KEY (parqueo_id) REFERENCES public.parqueo(id) ON DELETE CASCADE;


--
-- Name: reserva plaza_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT plaza_fk FOREIGN KEY (plaza_id) REFERENCES public.plaza(id) ON DELETE CASCADE;


--
-- Name: registro registro_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro
    ADD CONSTRAINT registro_fk FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- Name: registro registro_fk_cliente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro
    ADD CONSTRAINT registro_fk_cliente FOREIGN KEY (cliente_id) REFERENCES public.cliente(id);


--
-- Name: sugerencia sugerencia_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sugerencia
    ADD CONSTRAINT sugerencia_fk FOREIGN KEY (cliente_id) REFERENCES public.cliente(id) ON DELETE CASCADE;


--
-- Name: reserva tarifa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT tarifa_fk FOREIGN KEY (tarifa_id) REFERENCES public.tarifa(id) ON DELETE CASCADE;


--
-- Name: turno_usuario turno_usuario_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.turno_usuario
    ADD CONSTRAINT turno_usuario_fk FOREIGN KEY (turno_id) REFERENCES public.turno(id);


--
-- Name: turno_usuario usuario_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.turno_usuario
    ADD CONSTRAINT usuario_fk FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

