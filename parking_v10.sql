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
-- Name: convocatoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.convocatoria (
    convocatoria character varying(50) NOT NULL,
    fecha_inicio_pago date NOT NULL,
    fecha_limite_reserva date NOT NULL,
    fecha_inicio_reserva date NOT NULL,
    fecha_fin_reserva date NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.convocatoria OWNER TO postgres;

--
-- Name: convocatoria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.convocatoria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.convocatoria_id_seq OWNER TO postgres;

--
-- Name: convocatoria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.convocatoria_id_seq OWNED BY public.convocatoria.id;


--
-- Name: informacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.informacion (
    id integer NOT NULL,
    qr character varying(50) NOT NULL,
    atencion character varying(100) NOT NULL,
    foto character varying(50),
    mensaje_mora character varying(240) NOT NULL,
    telefono integer NOT NULL
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
-- Name: notificacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notificacion (
    id integer NOT NULL,
    mensaje character varying NOT NULL,
    cliente_id integer NOT NULL,
    fecha date DEFAULT now() NOT NULL
);


ALTER TABLE public.notificacion OWNER TO postgres;

--
-- Name: notificacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notificacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notificacion_id_seq OWNER TO postgres;

--
-- Name: notificacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notificacion_id_seq OWNED BY public.notificacion.id;


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
    tipo_pago character varying(20) NOT NULL,
    estado_plaza character varying(20)
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
    nro_plazas integer,
    plazas_disponibles smallint,
    plazas_ocupadas smallint,
    nro_filas smallint NOT NULL,
    nro_columnas smallint NOT NULL,
    descripcion character varying
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
    fecha_ingreso timestamp without time zone DEFAULT now(),
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
    id integer NOT NULL,
    estado boolean
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
-- Name: convocatoria id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.convocatoria ALTER COLUMN id SET DEFAULT nextval('public.convocatoria_id_seq'::regclass);


--
-- Name: informacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.informacion ALTER COLUMN id SET DEFAULT nextval('public.informacion_id_seq'::regclass);


--
-- Name: notificacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificacion ALTER COLUMN id SET DEFAULT nextval('public.notificacion_id_seq'::regclass);


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
cliente	10	1686345367
cliente	11	1686348329
cliente	12	1686350282
cliente	13	1686436430
guardia	1003	1686523819
operador	1005	1686523969
administrador	1002	1686524682
\.


--
-- Data for Name: auth_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_item (name, type, description, rule_name, data, created_at, updated_at) FROM stdin;
parqueo	2	Parqueo	\N	\N	\N	\N
informacion	2	Informacion	\N	\N	\N	\N
usuarios	2	Usuarios 	\N	\N	\N	\N
solicitud	2	Solicitudes	\N	\N	\N	\N
tarifas	2	Tarifas	\N	\N	\N	\N
reclamos	2	Reclamos	\N	\N	\N	\N
plazas	2	Plazas	\N	\N	\N	\N
customers	2	Customers	\N	\N	\N	\N
asignar	2	Asignar	\N	\N	\N	\N
reportes	2	Reportes	\N	\N	\N	\N
mora	2	Mora	\N	\N	\N	\N
roles	2	Roles	\N	\N	\N	\N
records	2	Records	\N	\N	\N	\N
cliente	1	Cliente	\N	\N	\N	\N
administrador	1	administrador	\N	\N	\N	\N
guardia	1	Guardia	\N	\N	1686523792	1686523792
operador	1	Operador	\N	\N	1686523948	1686523948
\.


--
-- Data for Name: auth_item_child; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_item_child (parent, child) FROM stdin;
administrador	parqueo
administrador	informacion
administrador	usuarios
administrador	solicitud
administrador	tarifas
administrador	reclamos
administrador	plazas
administrador	customers
administrador	asignar
administrador	reportes
administrador	mora
administrador	roles
administrador	records
operador	parqueo
operador	solicitud
operador	reclamos
operador	plazas
operador	customers
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
12	andres	6434	andres@gmail.com	646ew4r	t	$2y$13$KkQBb9l8KFa5Muxu6H6iXOeZK9Hf43ZumqmayuEJDqGc1WJAAZ9tG	WeqNeh11bDSyCvC0Vpcho48XRoCSJomK	75457121	estudiante	deportiva	cliente
13	Erick 3	5646	erick@gmail.com	54fd54	t	$2y$13$6zKYUqtWnpfDv8Znp/ieEeayFwHRMNNuzuJbkOVoRxhleQDjpbaQ6	2xg4HvcxINOJETzG-oKNrGmI2Kygwmht	754210341	abogado	odp	cliente
11	rodrigo	5646	rodrigocliente@gmail.com	521fddf	t	$2y$13$a.TLvo2h7LEl3lmWhXLu..q/UsoFeaXZFMY4XvRlshtzVaAlk73dy	vi3PZJL_xON4NzN2Gp9IQg6gfpZ9HlPS	745121	docente	dpa	cliente
10	elmer	312345	elmer@gmail.com	21d3as5f	t	$2y$13$a3P0sbn92FnOqkNE3X.VlODkAlHSp8/HzZVmL9EA5NsqyZU8hAJ/6	6O1ax_Z9QnDrtrAu87vkGEKsyyRa5MlI	15456464	admin	dppa	cliente
\.


--
-- Data for Name: convocatoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.convocatoria (convocatoria, fecha_inicio_pago, fecha_limite_reserva, fecha_inicio_reserva, fecha_fin_reserva, id) FROM stdin;
6484d9725d21c.pdf	2023-06-10	2023-06-10	2023-06-10	2023-06-14	10
6484d97936b86.pdf	2023-06-10	2023-06-10	2023-06-10	2023-06-16	11
6484d97e6496b.pdf	2023-06-10	2023-06-10	2023-06-10	2023-06-17	12
\.


--
-- Data for Name: informacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.informacion (id, qr, atencion, foto, mensaje_mora, telefono) FROM stdin;
6	6484c69f7322f.png	De lunes a viernes de 08:00 - 22:01	\N	Debe pagar lo mas antes	7545124
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
-- Data for Name: notificacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notificacion (id, mensaje, cliente_id, fecha) FROM stdin;
1	Debe pagar lo mas antes  s2	10	2023-06-10
2	Debe pagar lo mas antes  s2	10	2023-06-10
3	Debe pagar lo mas antes  s2	10	2023-06-10
4	Debe pagar lo mas antes  s2	10	2023-06-10
5	Debe pagar lo mas antes  s2	10	2023-06-10
\.


--
-- Data for Name: pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pago (id, fecha, nro_cuotas_pagadas, reserva_id, total, comprobante, estado, tipo_pago, estado_plaza) FROM stdin;
69	2023-06-11 19:12:43.650184	1	65	500	\N	t	efectivo	aprobado
70	2023-06-11 19:16:40.100033	2	66	84	\N	t	efectivo	aprobado
\.


--
-- Data for Name: parqueo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parqueo (id, nombre, nro_plazas, plazas_disponibles, plazas_ocupadas, nro_filas, nro_columnas, descripcion) FROM stdin;
1	UMSS 2	100	100	0	10	10	PARQUEO UMSS
2	UMSS 1	100	100	0	10	10	\N
3	UMSS 3	\N	\N	\N	5	3	Es un parqueo moderno enfocado en la atencion al cliente y la seguridad de los vehiculos.
4	UMSS 4	\N	\N	\N	5	4	Es un parqueo moderno enfocado en la atencion al cliente y la seguridad de los vehiculos.
5	umss 5	\N	\N	\N	10	10	Es un parqueo moderno enfocado en la atencion al cliente y la seguridad de los vehiculos. edit
6	UMSS6	\N	\N	\N	3	5	Es un parqueo moderno enfocado en la atencion al cliente y la seguridad de los vehiculos.
\.


--
-- Data for Name: plaza; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plaza (id, estado, numero, parqueo_id, habilitado) FROM stdin;
360	disponible	34	2	t
361	disponible	35	2	t
326	camino	0	2	f
327	camino	1	2	f
328	camino	2	2	f
329	camino	3	2	f
330	camino	4	2	f
331	camino	5	2	f
332	camino	6	2	f
333	camino	7	2	f
334	camino	8	2	f
335	camino	9	2	f
336	camino	10	2	f
337	camino	11	2	f
338	camino	12	2	f
339	camino	13	2	f
340	camino	14	2	f
341	camino	15	2	f
342	camino	16	2	f
343	camino	17	2	f
344	camino	18	2	f
345	camino	19	2	f
346	camino	20	2	f
347	camino	21	2	f
348	camino	22	2	f
349	camino	23	2	f
350	camino	24	2	f
351	camino	25	2	f
352	camino	26	2	f
353	camino	27	2	f
354	camino	28	2	f
355	camino	29	2	f
356	camino	30	2	f
226	camino	0	1	f
227	camino	1	1	f
228	camino	2	1	f
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
357	camino	31	2	f
358	camino	32	2	f
359	camino	33	2	f
363	camino	37	2	f
364	camino	38	2	f
365	camino	39	2	f
366	camino	40	2	f
367	camino	41	2	f
368	camino	42	2	f
369	camino	43	2	f
370	camino	44	2	f
371	camino	45	2	f
372	camino	46	2	f
373	camino	47	2	f
374	camino	48	2	f
375	camino	49	2	f
376	camino	50	2	f
377	camino	51	2	f
378	camino	52	2	f
379	camino	53	2	f
380	camino	54	2	f
381	camino	55	2	f
382	camino	56	2	f
383	camino	57	2	f
384	camino	58	2	f
385	camino	59	2	f
240	disponible	14	1	t
362	disponible	36	2	t
761	camino	0	6	f
386	camino	60	2	f
387	camino	61	2	f
388	camino	62	2	f
389	camino	63	2	f
390	camino	64	2	f
391	camino	65	2	f
392	camino	66	2	f
393	camino	67	2	f
394	camino	68	2	f
395	camino	69	2	f
396	camino	70	2	f
397	camino	71	2	f
398	camino	72	2	f
399	camino	73	2	f
400	camino	74	2	f
401	camino	75	2	f
402	camino	76	2	f
403	camino	77	2	f
404	camino	78	2	f
405	camino	79	2	f
406	camino	80	2	f
407	camino	81	2	f
408	camino	82	2	f
409	camino	83	2	f
410	camino	84	2	f
411	camino	85	2	f
412	camino	86	2	f
413	camino	87	2	f
414	camino	88	2	f
415	camino	89	2	f
416	camino	90	2	f
417	camino	91	2	f
418	camino	92	2	f
419	camino	93	2	f
420	camino	94	2	f
421	camino	95	2	f
422	camino	96	2	f
423	camino	97	2	f
424	camino	98	2	f
425	camino	99	2	f
323	disponible	97	1	t
325	disponible	99	1	t
324	disponible	98	1	t
426	camino	0	3	f
427	camino	1	3	f
428	camino	2	3	f
429	camino	3	3	f
430	camino	4	3	f
431	camino	5	3	f
432	camino	6	3	f
434	camino	8	3	f
435	camino	9	3	f
436	camino	10	3	f
437	camino	11	3	f
438	camino	12	3	f
439	camino	13	3	f
440	camino	14	3	f
441	camino	0	4	f
443	camino	2	4	f
444	camino	3	4	f
445	camino	4	4	f
446	camino	5	4	f
447	camino	6	4	f
448	camino	7	4	f
449	camino	8	4	f
450	camino	9	4	f
451	camino	10	4	f
452	camino	11	4	f
453	camino	12	4	f
454	camino	13	4	f
455	camino	14	4	f
456	camino	15	4	f
457	camino	16	4	f
458	camino	17	4	f
459	camino	18	4	f
460	camino	19	4	f
433	disponible	7	3	t
442	asignado	1	4	t
319	camino	93	1	f
320	camino	94	1	f
321	camino	95	1	f
322	camino	96	1	f
763	camino	2	6	f
764	camino	3	6	f
765	camino	4	6	f
766	camino	5	6	f
768	camino	7	6	f
769	camino	8	6	f
770	camino	9	6	f
771	camino	10	6	f
772	camino	11	6	f
773	camino	12	6	f
774	camino	13	6	f
775	camino	14	6	f
767	disponible	6	6	t
762	asignado	1	6	t
668	disponible	7	5	t
675	disponible	14	5	t
676	disponible	15	5	t
229	asignado	3	1	t
662	camino	1	5	f
664	camino	3	5	f
665	camino	4	5	f
666	camino	5	5	f
667	camino	6	5	f
669	camino	8	5	f
670	camino	9	5	f
671	camino	10	5	f
672	camino	11	5	f
673	camino	12	5	f
674	camino	13	5	f
677	camino	16	5	f
678	camino	17	5	f
679	camino	18	5	f
680	camino	19	5	f
681	camino	20	5	f
682	camino	21	5	f
683	camino	22	5	f
684	camino	23	5	f
685	camino	24	5	f
686	camino	25	5	f
687	camino	26	5	f
688	camino	27	5	f
661	disponible	0	5	t
663	disponible	2	5	t
689	camino	28	5	f
690	camino	29	5	f
691	camino	30	5	f
692	camino	31	5	f
693	camino	32	5	f
694	camino	33	5	f
695	camino	34	5	f
696	camino	35	5	f
697	camino	36	5	f
698	camino	37	5	f
699	camino	38	5	f
700	camino	39	5	f
701	camino	40	5	f
702	camino	41	5	f
703	camino	42	5	f
704	camino	43	5	f
705	camino	44	5	f
706	camino	45	5	f
707	camino	46	5	f
708	camino	47	5	f
709	camino	48	5	f
710	camino	49	5	f
711	camino	50	5	f
712	camino	51	5	f
713	camino	52	5	f
714	camino	53	5	f
715	camino	54	5	f
716	camino	55	5	f
717	camino	56	5	f
718	camino	57	5	f
719	camino	58	5	f
720	camino	59	5	f
721	camino	60	5	f
722	camino	61	5	f
723	camino	62	5	f
724	camino	63	5	f
725	camino	64	5	f
726	camino	65	5	f
727	camino	66	5	f
728	camino	67	5	f
729	camino	68	5	f
730	camino	69	5	f
731	camino	70	5	f
732	camino	71	5	f
733	camino	72	5	f
734	camino	73	5	f
735	camino	74	5	f
736	camino	75	5	f
737	camino	76	5	f
738	camino	77	5	f
739	camino	78	5	f
740	camino	79	5	f
741	camino	80	5	f
742	camino	81	5	f
743	camino	82	5	f
744	camino	83	5	f
745	camino	84	5	f
746	camino	85	5	f
747	camino	86	5	f
748	camino	87	5	f
749	camino	88	5	f
750	camino	89	5	f
751	camino	90	5	f
752	camino	91	5	f
753	camino	92	5	f
754	camino	93	5	f
755	camino	94	5	f
756	camino	95	5	f
757	camino	96	5	f
758	camino	97	5	f
759	camino	98	5	f
760	disponible	99	5	t
\.


--
-- Data for Name: registro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registro (id, usuario_id, fecha_ingreso, fecha_salida, cliente_id) FROM stdin;
6	1002	2023-06-11 11:11:17.427293	2023-06-11 11:12:23	11
7	1002	2023-06-11 11:42:38.43374	2023-06-11 11:45:23	13
8	1002	2023-06-11 11:49:42.503076	2023-06-11 11:58:57	11
10	1002	2023-06-11 14:05:32.294647	2023-06-11 14:06:36	10
9	1002	2023-06-11 11:59:04.695039	2023-06-11 14:06:55	11
\.


--
-- Data for Name: reserva; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reserva (id, estado, fecha_inicio, fecha_fin, cliente_id, plaza_id, tarifa_id, cantidad, couta, finalizado) FROM stdin;
65	pagado	2023-06-11 19:12:43.601692	2023-06-17 00:00:00	11	229	6	1	f	f
66	pendiente	2023-06-11 19:16:40.049989	2023-06-17 00:00:00	10	762	6	1	t	f
\.


--
-- Data for Name: sugerencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sugerencia (id, cliente_id, mensaje) FROM stdin;
8	10	mensaje de prueba
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

COPY public.turno (nombre, hora_inicio, hora_fin, id, estado) FROM stdin;
tarde2	01:00:00	02:20:00	5	f
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
1002	adminTis	admintis@gmailcom	administrador	$2y$13$FZFZnqAIXFqz0xCwlAQYE.focCdH6QLf5KBhI5iU7Pdohgrx0ZHtK	hNvNJOp_uI1Njo6lgrGLtD_5Zvgd0lSn	t
\.


--
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_id_seq', 16, true);


--
-- Name: convocatoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.convocatoria_id_seq', 14, true);


--
-- Name: informacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.informacion_id_seq', 6, true);


--
-- Name: notificacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notificacion_id_seq', 5, true);


--
-- Name: nueva_secuencia; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nueva_secuencia', 101, true);


--
-- Name: nueva_secuencia2; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nueva_secuencia2', 1005, true);


--
-- Name: pago_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pago_id_seq', 70, true);


--
-- Name: parqueo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parqueo_id_seq', 6, true);


--
-- Name: plaza_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plaza_id_seq', 775, true);


--
-- Name: registro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.registro_id_seq', 10, true);


--
-- Name: reserva_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reserva_id_seq', 66, true);


--
-- Name: sugerencia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sugerencia_id_seq', 8, true);


--
-- Name: tarifa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tarifa_id_seq', 13, true);


--
-- Name: turno_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.turno_id_seq', 5, true);


--
-- Name: turno_usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.turno_usuario_id_seq', 15, true);


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
-- Name: cliente cliente_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_un UNIQUE (email);


--
-- Name: convocatoria convocatoria_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.convocatoria
    ADD CONSTRAINT convocatoria_pk PRIMARY KEY (id);


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
-- Name: notificacion notificacion_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificacion
    ADD CONSTRAINT notificacion_pk PRIMARY KEY (id);


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
-- Name: notificacion notificacion_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificacion
    ADD CONSTRAINT notificacion_fk FOREIGN KEY (cliente_id) REFERENCES public.cliente(id);


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

