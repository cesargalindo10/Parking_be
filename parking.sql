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
    fecha_salida timestamp without time zone
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
    id integer NOT NULL,
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
-- Name: usuario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);


--
-- Data for Name: auth_assignment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_assignment (item_name, user_id, created_at) FROM stdin;
administrador	3	1685669791
cliente	7	1685669858
cliente	8	1685671181
cliente	9	1685901944
cliente	1	\N
cliente	2	\N
cliente	4	\N
cliente	5	\N
cliente	6	\N
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
2	juanito	123456	gmial.@gmial.com	123df	t	$2y$13$236fWAe1KZ0rt3ACCG8IyumbMKGV28KzrqN64qhyrn.jjKUzFeZrO	idcjSvucjtylEVv4uXukIBf31VE4wHG5	65214141	jefe	deportiva	cliente
3	pedrito	2134564	pedrito@gmail.com	454dfc	t	$2y$13$KIIkqLD0fNoZPh/Hqr2GL.JrvtDiu6vDTWu7rnbMuEDZDnz7vy.o6	9AZO8RuadPX0ZVkjgxvowFKR1Z18He0Y	653212454	jefe	dpppa	cliente
4	Flavio 	12345	gmai	df1233	t	$2y$13$5Pr48UUE2uLrOONuHF4lgeSOudDMge7zv4lyEA.Vli0xSUBP8K8NS	EIwWcu6ZXfzN5oPT5w3AeBFDWfAsw_eA	45741214	docente	dcit	cliente
6	cliente nuevo	1234123414	cliente@gmail.com	323fDF	t	$2y$13$X6tkXkfWMb3BlLFAwPfvbOA3mw9fY66lSE6wQ3hncaogNvQ40X9Xu	Dfk0z2BnPTeOyDFThpwvA-a-Kbuq6DY_	780329023	admin	administrador	cliente
7	adriel	1223	adriel@gmail.com	234sdf	t	$2y$13$YalsV8onhQFrJSZlR8J/quMOC7QvXx6750XOJU1ymomAUfDG7iVVS	OcJz1145-KovlKmMOHExh6Km7x0X9sZq	45677	auliar	detic	cliente
8	elmer	1234575	elmer@gmail.com	1245ere	t	$2y$13$l.tA8Hivahf2nAH60sVYS.WwVXpr8RjmxZrVjaecyIUpwjCcCRWci	EO9gjb2cYab_tzxskhm8DWu5RtIoYs1j	65214512	administrador	dppa	cliente
9	rodrigo	5643213	rodrigo@gmail.com	e542345	t	$2y$13$uJA/TL2hRLv90jAYWDv7M..hBqHW8ZHyIq.jXiMrkh.qSVKSATUTq	atUsB3oWjQwbGay3hUmiPVEeeqSJECH7	57545412	docente	dppa	cliente
5	samuel	3214234	samuel@gmail.com	324jkj	t	$2y$13$C58OPzBqcSDH./5q8hPPEuk9Xc2oFzWiZQL8jKdaYGFzUl5KRp0Me	Q0IIWyBlNScUJV81y2r9PbdUN9yAk6BV	75454545	Administrador	DPA	cliente
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
42	2023-06-06 22:53:57.926723	1	46	2	\N	t	efectivo
43	2023-06-06 23:35:42.568739	1	47	2	\N	f	efectivo
44	2023-06-06 23:42:37.179387	1	48	2	\N	f	efectivo
45	2023-06-07 00:01:24.35953	1	49	2	\N	f	efectivo
\.


--
-- Data for Name: parqueo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parqueo (id, nombre, nro_plazas, plazas_disponibles, plazas_ocupadas, nro_filas, nro_columnas, descripcion) FROM stdin;
1	UMSS	100	1010	0	10	10	
\.


--
-- Data for Name: plaza; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plaza (id, estado, numero, parqueo_id, habilitado) FROM stdin;
126	disponible	0	1	t
127	camino	1	1	f
128	camino	2	1	f
129	camino	3	1	f
130	camino	4	1	f
131	camino	5	1	f
132	camino	6	1	f
133	camino	7	1	f
134	camino	8	1	f
135	camino	9	1	f
136	camino	10	1	f
137	camino	11	1	f
138	camino	12	1	f
139	camino	13	1	f
140	camino	14	1	f
141	camino	15	1	f
142	camino	16	1	f
143	camino	17	1	f
144	camino	18	1	f
145	camino	19	1	f
146	camino	20	1	f
147	camino	21	1	f
148	camino	22	1	f
149	camino	23	1	f
150	camino	24	1	f
151	camino	25	1	f
152	camino	26	1	f
153	camino	27	1	f
154	camino	28	1	f
155	camino	29	1	f
156	camino	30	1	f
157	camino	31	1	f
158	camino	32	1	f
159	camino	33	1	f
160	camino	34	1	f
161	camino	35	1	f
162	camino	36	1	f
163	camino	37	1	f
164	camino	38	1	f
165	camino	39	1	f
166	camino	40	1	f
167	camino	41	1	f
168	camino	42	1	f
169	camino	43	1	f
170	camino	44	1	f
171	camino	45	1	f
172	camino	46	1	f
173	camino	47	1	f
174	camino	48	1	f
175	camino	49	1	f
176	camino	50	1	f
177	camino	51	1	f
178	camino	52	1	f
179	camino	53	1	f
180	camino	54	1	f
181	camino	55	1	f
182	camino	56	1	f
183	camino	57	1	f
184	camino	58	1	f
185	camino	59	1	f
186	camino	60	1	f
187	camino	61	1	f
188	camino	62	1	f
189	camino	63	1	f
190	camino	64	1	f
191	camino	65	1	f
192	camino	66	1	f
193	camino	67	1	f
194	camino	68	1	f
195	camino	69	1	f
196	camino	70	1	f
197	camino	71	1	f
198	camino	72	1	f
199	camino	73	1	f
200	camino	74	1	f
201	camino	75	1	f
202	camino	76	1	f
203	camino	77	1	f
204	camino	78	1	f
205	camino	79	1	f
206	camino	80	1	f
207	camino	81	1	f
208	camino	82	1	f
209	camino	83	1	f
210	camino	84	1	f
211	camino	85	1	f
212	camino	86	1	f
213	camino	87	1	f
214	camino	88	1	f
215	camino	89	1	f
216	camino	90	1	f
217	camino	91	1	f
218	camino	92	1	f
219	camino	93	1	f
220	camino	94	1	f
221	camino	95	1	f
222	camino	96	1	f
223	camino	97	1	f
224	camino	98	1	f
225	camino	99	1	f
\.


--
-- Data for Name: registro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registro (id, usuario_id, fecha_ingreso, fecha_salida) FROM stdin;
\.


--
-- Data for Name: reserva; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reserva (id, estado, fecha_inicio, fecha_fin, cliente_id, plaza_id, tarifa_id, cantidad, couta, finalizado) FROM stdin;
46	pagado	2023-07-01 00:00:00	2023-06-06 23:22:57	8	126	3	1	f	t
47	pendiente	2023-07-01 00:00:00	2023-06-06 23:38:42	8	126	3	1	f	t
48	pendiente	2023-07-01 00:00:00	2023-06-06 23:45:42	8	126	3	1	f	t
49	pendiente	2023-07-01 00:00:00	2023-06-07 00:03:24	8	126	3	1	f	t
\.


--
-- Data for Name: sugerencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sugerencia (id, cliente_id, mensaje) FROM stdin;
6	2	sigo en pendiente, me pueden habilitar 
7	3	No hay validacion, mal.
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
3	cesar	cesar@gmail.com	administrador	$2y$13$nSp1IalEyC/RhVjH6vFPDOl0l4UfgU2bqdm8ZiuiElu/xpLHVzt4a	3jmuLFyk-RooJA0jMD5Fj9ZGEP4PlHCW	t
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
-- Name: pago_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pago_id_seq', 45, true);


--
-- Name: parqueo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parqueo_id_seq', 1, true);


--
-- Name: plaza_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plaza_id_seq', 225, true);


--
-- Name: registro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.registro_id_seq', 1, false);


--
-- Name: reserva_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reserva_id_seq', 49, true);


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

SELECT pg_catalog.setval('public.usuario_id_seq', 3, true);


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
-- Name: sugerencia sugerencia_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sugerencia
    ADD CONSTRAINT sugerencia_fk FOREIGN KEY (cliente_id) REFERENCES public.cliente(id);


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

