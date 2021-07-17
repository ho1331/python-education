--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2 (Debian 13.2-1.pgdg100+1)
-- Dumped by pg_dump version 13.2 (Debian 13.2-1.pgdg100+1)

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
-- Name: insert_adress(); Type: PROCEDURE; Schema: public; Owner: user
--

CREATE PROCEDURE public.insert_adress()
    LANGUAGE plpgsql
    AS $$
	declare
		counter int;
		c_region varchar;
		c_city varchar;
		c_street varchar;
		c_building int;
	begin
		counter := 1;
		while counter <= 2000 loop
			c_region := 'region'||counter;
			c_city := 'city'||counter;
			c_street := 'street'||counter;
			c_building := (random()*400)::int;

			INSERT INTO adress (region,city,street,building) 
                VALUES (c_region,c_city,c_street,c_building);

			counter := counter+1;
			commit;
		end loop;
	end;$$;


ALTER PROCEDURE public.insert_adress() OWNER TO "user";

--
-- Name: insert_branches(); Type: PROCEDURE; Schema: public; Owner: user
--

CREATE PROCEDURE public.insert_branches()
    LANGUAGE plpgsql
    AS $$
	declare
		counter int;
		c_branch_name varchar;
		c_branch_tel varchar;
		c_adress_id int;
	begin
		counter := 1;
		while counter <= 50 loop
			c_branch_name := 'b_name'||counter;
			c_branch_tel := '380'||(random()*1000000000)::int;

			select adress_id into c_adress_id 
				from adress order by random() limit 1;

			INSERT INTO branches (branch_name,branch_tel,adress_id) 
                VALUES (c_branch_name,c_branch_tel,c_adress_id);

			counter := counter+1;
			commit;
		end loop;
	end;$$;


ALTER PROCEDURE public.insert_branches() OWNER TO "user";

--
-- Name: insert_cars(); Type: PROCEDURE; Schema: public; Owner: user
--

CREATE PROCEDURE public.insert_cars()
    LANGUAGE plpgsql
    AS $$
	declare
		counter int;
		c_branch_id int;
		c_model_id int;
		c_cars_number varchar;
	begin
		counter := 1;
		while counter <= 7000 loop
			c_cars_number := 'car_number'||counter;

			select branch_id into c_branch_id 
				from branches order by random() limit 1;

			select model_id into c_model_id 
				from models order by random() limit 1;

			INSERT INTO cars (branch_id,model_id,cars_number) 
                VALUES (c_branch_id,c_model_id,c_cars_number);

			counter := counter+1;
			commit;
		end loop;
	end;$$;


ALTER PROCEDURE public.insert_cars() OWNER TO "user";

--
-- Name: insert_clients(); Type: PROCEDURE; Schema: public; Owner: user
--

CREATE PROCEDURE public.insert_clients()
    LANGUAGE plpgsql
    AS $$
	declare
		counter int;
		c_clients_name varchar;
		c_clients_tel varchar;
		c_adress_id int;
	begin
		counter := 1;
		while counter <= 9000 loop
			c_clients_name := 'name'||counter;
			c_clients_tel := '380'||(random()*1000000000)::int;

			select adress_id into c_adress_id 
				from adress order by random() limit 1;

			INSERT INTO clients (clients_name,clients_tel,adress_id) 
                VALUES (c_clients_name,c_clients_tel,c_adress_id);

			counter := counter+1;
			commit;
		end loop;
	end;$$;


ALTER PROCEDURE public.insert_clients() OWNER TO "user";

--
-- Name: insert_models(); Type: PROCEDURE; Schema: public; Owner: user
--

CREATE PROCEDURE public.insert_models()
    LANGUAGE plpgsql
    AS $$
	declare
		counter int;
		c_model varchar;
		c_price int;
	begin
		counter := 1;
		while counter <= 500 loop
			c_model := 'model'||counter;
			c_price := (random()*1000)::int;

			INSERT INTO models (model,price) 
                VALUES (c_model,c_price);

			counter := counter+1;
			commit;
		end loop;
	end;$$;


ALTER PROCEDURE public.insert_models() OWNER TO "user";

--
-- Name: insert_rent(); Type: PROCEDURE; Schema: public; Owner: user
--

CREATE PROCEDURE public.insert_rent()
    LANGUAGE plpgsql
    AS $$
	declare
		counter int;
		c_date_of_renting date;
		c_period_of_renting int;
		c_cars_id int;
		c_clients_id int;
	begin
		counter := 1;
		while counter <= 600 loop
			c_date_of_renting := '2021-06-19'::date + counter;
			c_period_of_renting := (random()*10)::int + 1;

			select cars_id into c_cars_id 
				from cars order by random() limit 1;

			select clients_id into c_clients_id 
				from clients order by random() limit 1;

			INSERT INTO rent (date_of_renting,period_of_renting,cars_id,clients_id) 
                VALUES (c_date_of_renting,c_period_of_renting,c_cars_id,c_clients_id);
                
			counter := counter+1;
			commit;
		end loop;
	end;$$;


ALTER PROCEDURE public.insert_rent() OWNER TO "user";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adress; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.adress (
    adress_id integer NOT NULL,
    region character varying(10) NOT NULL,
    city character varying(10) NOT NULL,
    street character varying(10) NOT NULL,
    building integer NOT NULL
);


ALTER TABLE public.adress OWNER TO "user";

--
-- Name: adress_adress_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.adress_adress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adress_adress_id_seq OWNER TO "user";

--
-- Name: adress_adress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.adress_adress_id_seq OWNED BY public.adress.adress_id;


--
-- Name: branches; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.branches (
    branch_id integer NOT NULL,
    branch_name character varying(10) NOT NULL,
    branch_tel character varying(20) NOT NULL,
    adress_id integer NOT NULL,
    CONSTRAINT branches_branch_tel_check CHECK ((((branch_tel)::text ~~ '380%'::text) OR ((branch_tel)::text ~~ '0%'::text)))
);


ALTER TABLE public.branches OWNER TO "user";

--
-- Name: branches_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.branches_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.branches_branch_id_seq OWNER TO "user";

--
-- Name: branches_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.branches_branch_id_seq OWNED BY public.branches.branch_id;


--
-- Name: cars; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.cars (
    cars_id integer NOT NULL,
    branch_id integer NOT NULL,
    model_id integer NOT NULL,
    cars_number character varying(20)
);


ALTER TABLE public.cars OWNER TO "user";

--
-- Name: cars_cars_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.cars_cars_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cars_cars_id_seq OWNER TO "user";

--
-- Name: cars_cars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.cars_cars_id_seq OWNED BY public.cars.cars_id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.clients (
    clients_id integer NOT NULL,
    clients_name character varying(50) NOT NULL,
    clients_tel character varying(20) NOT NULL,
    adress_id integer NOT NULL,
    CONSTRAINT clients_clients_tel_check CHECK ((((clients_tel)::text ~~ '380%'::text) OR ((clients_tel)::text ~~ '0%'::text)))
);


ALTER TABLE public.clients OWNER TO "user";

--
-- Name: clients_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.clients_clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clients_clients_id_seq OWNER TO "user";

--
-- Name: clients_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.clients_clients_id_seq OWNED BY public.clients.clients_id;


--
-- Name: models; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.models (
    model_id integer NOT NULL,
    model character varying(10) NOT NULL,
    price integer NOT NULL,
    CONSTRAINT models_price_check CHECK ((price > 0))
);


ALTER TABLE public.models OWNER TO "user";

--
-- Name: models_model_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.models_model_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.models_model_id_seq OWNER TO "user";

--
-- Name: models_model_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.models_model_id_seq OWNED BY public.models.model_id;


--
-- Name: rent; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.rent (
    order_id integer NOT NULL,
    date_of_renting date DEFAULT date((now() + '1 day'::interval)),
    period_of_renting integer DEFAULT 1,
    cars_id integer NOT NULL,
    clients_id integer NOT NULL
);


ALTER TABLE public.rent OWNER TO "user";

--
-- Name: rent_order_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.rent_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rent_order_id_seq OWNER TO "user";

--
-- Name: rent_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.rent_order_id_seq OWNED BY public.rent.order_id;


--
-- Name: adress adress_id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.adress ALTER COLUMN adress_id SET DEFAULT nextval('public.adress_adress_id_seq'::regclass);


--
-- Name: branches branch_id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.branches ALTER COLUMN branch_id SET DEFAULT nextval('public.branches_branch_id_seq'::regclass);


--
-- Name: cars cars_id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.cars ALTER COLUMN cars_id SET DEFAULT nextval('public.cars_cars_id_seq'::regclass);


--
-- Name: clients clients_id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.clients ALTER COLUMN clients_id SET DEFAULT nextval('public.clients_clients_id_seq'::regclass);


--
-- Name: models model_id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.models ALTER COLUMN model_id SET DEFAULT nextval('public.models_model_id_seq'::regclass);


--
-- Name: rent order_id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.rent ALTER COLUMN order_id SET DEFAULT nextval('public.rent_order_id_seq'::regclass);


--
-- Data for Name: adress; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.adress (adress_id, region, city, street, building) FROM stdin;
1	region1	city1	street1	260
2	region2	city2	street2	261
3	region3	city3	street3	67
4	region4	city4	street4	64
5	region5	city5	street5	113
6	region6	city6	street6	48
7	region7	city7	street7	312
8	region8	city8	street8	159
9	region9	city9	street9	75
10	region10	city10	street10	241
11	region11	city11	street11	268
12	region12	city12	street12	194
13	region13	city13	street13	94
14	region14	city14	street14	20
15	region15	city15	street15	366
16	region16	city16	street16	276
17	region17	city17	street17	84
18	region18	city18	street18	349
19	region19	city19	street19	185
20	region20	city20	street20	233
21	region21	city21	street21	137
22	region22	city22	street22	284
23	region23	city23	street23	293
24	region24	city24	street24	322
25	region25	city25	street25	358
26	region26	city26	street26	153
27	region27	city27	street27	195
28	region28	city28	street28	200
29	region29	city29	street29	338
30	region30	city30	street30	71
31	region31	city31	street31	209
32	region32	city32	street32	236
33	region33	city33	street33	156
34	region34	city34	street34	360
35	region35	city35	street35	208
36	region36	city36	street36	34
37	region37	city37	street37	25
38	region38	city38	street38	108
39	region39	city39	street39	136
40	region40	city40	street40	360
41	region41	city41	street41	398
42	region42	city42	street42	86
43	region43	city43	street43	54
44	region44	city44	street44	319
45	region45	city45	street45	104
46	region46	city46	street46	356
47	region47	city47	street47	333
48	region48	city48	street48	358
49	region49	city49	street49	90
50	region50	city50	street50	42
51	region51	city51	street51	144
52	region52	city52	street52	332
53	region53	city53	street53	133
54	region54	city54	street54	343
55	region55	city55	street55	371
56	region56	city56	street56	47
57	region57	city57	street57	154
58	region58	city58	street58	158
59	region59	city59	street59	223
60	region60	city60	street60	89
61	region61	city61	street61	336
62	region62	city62	street62	14
63	region63	city63	street63	171
64	region64	city64	street64	317
65	region65	city65	street65	181
66	region66	city66	street66	79
67	region67	city67	street67	97
68	region68	city68	street68	140
69	region69	city69	street69	392
70	region70	city70	street70	213
71	region71	city71	street71	54
72	region72	city72	street72	176
73	region73	city73	street73	119
74	region74	city74	street74	316
75	region75	city75	street75	369
76	region76	city76	street76	89
77	region77	city77	street77	290
78	region78	city78	street78	286
79	region79	city79	street79	239
80	region80	city80	street80	338
81	region81	city81	street81	219
82	region82	city82	street82	109
83	region83	city83	street83	263
84	region84	city84	street84	388
85	region85	city85	street85	206
86	region86	city86	street86	161
87	region87	city87	street87	291
88	region88	city88	street88	165
89	region89	city89	street89	271
90	region90	city90	street90	94
91	region91	city91	street91	39
92	region92	city92	street92	112
93	region93	city93	street93	210
94	region94	city94	street94	195
95	region95	city95	street95	189
96	region96	city96	street96	73
97	region97	city97	street97	91
98	region98	city98	street98	112
99	region99	city99	street99	357
100	region100	city100	street100	335
101	region101	city101	street101	328
102	region102	city102	street102	269
103	region103	city103	street103	235
104	region104	city104	street104	55
105	region105	city105	street105	159
106	region106	city106	street106	7
107	region107	city107	street107	380
108	region108	city108	street108	196
109	region109	city109	street109	143
110	region110	city110	street110	250
111	region111	city111	street111	370
112	region112	city112	street112	357
113	region113	city113	street113	282
114	region114	city114	street114	255
115	region115	city115	street115	313
116	region116	city116	street116	180
117	region117	city117	street117	61
118	region118	city118	street118	72
119	region119	city119	street119	50
120	region120	city120	street120	234
121	region121	city121	street121	272
122	region122	city122	street122	327
123	region123	city123	street123	112
124	region124	city124	street124	344
125	region125	city125	street125	272
126	region126	city126	street126	242
127	region127	city127	street127	235
128	region128	city128	street128	235
129	region129	city129	street129	80
130	region130	city130	street130	348
131	region131	city131	street131	233
132	region132	city132	street132	372
133	region133	city133	street133	387
134	region134	city134	street134	58
135	region135	city135	street135	213
136	region136	city136	street136	260
137	region137	city137	street137	147
138	region138	city138	street138	251
139	region139	city139	street139	164
140	region140	city140	street140	70
141	region141	city141	street141	240
142	region142	city142	street142	55
143	region143	city143	street143	228
144	region144	city144	street144	79
145	region145	city145	street145	181
146	region146	city146	street146	195
147	region147	city147	street147	36
148	region148	city148	street148	198
149	region149	city149	street149	178
150	region150	city150	street150	60
151	region151	city151	street151	275
152	region152	city152	street152	329
153	region153	city153	street153	374
154	region154	city154	street154	169
155	region155	city155	street155	290
156	region156	city156	street156	196
157	region157	city157	street157	239
158	region158	city158	street158	152
159	region159	city159	street159	296
160	region160	city160	street160	188
161	region161	city161	street161	92
162	region162	city162	street162	201
163	region163	city163	street163	194
164	region164	city164	street164	331
165	region165	city165	street165	292
166	region166	city166	street166	220
167	region167	city167	street167	231
168	region168	city168	street168	159
169	region169	city169	street169	129
170	region170	city170	street170	280
171	region171	city171	street171	275
172	region172	city172	street172	244
173	region173	city173	street173	347
174	region174	city174	street174	72
175	region175	city175	street175	259
176	region176	city176	street176	302
177	region177	city177	street177	47
178	region178	city178	street178	113
179	region179	city179	street179	190
180	region180	city180	street180	113
181	region181	city181	street181	88
182	region182	city182	street182	334
183	region183	city183	street183	228
184	region184	city184	street184	229
185	region185	city185	street185	14
186	region186	city186	street186	49
187	region187	city187	street187	48
188	region188	city188	street188	43
189	region189	city189	street189	285
190	region190	city190	street190	197
191	region191	city191	street191	183
192	region192	city192	street192	3
193	region193	city193	street193	19
194	region194	city194	street194	253
195	region195	city195	street195	287
196	region196	city196	street196	75
197	region197	city197	street197	194
198	region198	city198	street198	267
199	region199	city199	street199	364
200	region200	city200	street200	360
201	region201	city201	street201	27
202	region202	city202	street202	338
203	region203	city203	street203	317
204	region204	city204	street204	294
205	region205	city205	street205	274
206	region206	city206	street206	112
207	region207	city207	street207	196
208	region208	city208	street208	59
209	region209	city209	street209	152
210	region210	city210	street210	134
211	region211	city211	street211	256
212	region212	city212	street212	255
213	region213	city213	street213	246
214	region214	city214	street214	231
215	region215	city215	street215	95
216	region216	city216	street216	352
217	region217	city217	street217	243
218	region218	city218	street218	140
219	region219	city219	street219	234
220	region220	city220	street220	122
221	region221	city221	street221	160
222	region222	city222	street222	227
223	region223	city223	street223	70
224	region224	city224	street224	61
225	region225	city225	street225	191
226	region226	city226	street226	202
227	region227	city227	street227	39
228	region228	city228	street228	214
229	region229	city229	street229	29
230	region230	city230	street230	229
231	region231	city231	street231	21
232	region232	city232	street232	293
233	region233	city233	street233	228
234	region234	city234	street234	312
235	region235	city235	street235	316
236	region236	city236	street236	143
237	region237	city237	street237	102
238	region238	city238	street238	188
239	region239	city239	street239	239
240	region240	city240	street240	219
241	region241	city241	street241	26
242	region242	city242	street242	202
243	region243	city243	street243	196
244	region244	city244	street244	322
245	region245	city245	street245	137
246	region246	city246	street246	51
247	region247	city247	street247	150
248	region248	city248	street248	230
249	region249	city249	street249	165
250	region250	city250	street250	50
251	region251	city251	street251	120
252	region252	city252	street252	94
253	region253	city253	street253	171
254	region254	city254	street254	137
255	region255	city255	street255	357
256	region256	city256	street256	74
257	region257	city257	street257	353
258	region258	city258	street258	118
259	region259	city259	street259	117
260	region260	city260	street260	1
261	region261	city261	street261	1
262	region262	city262	street262	128
263	region263	city263	street263	22
264	region264	city264	street264	233
265	region265	city265	street265	319
266	region266	city266	street266	322
267	region267	city267	street267	299
268	region268	city268	street268	137
269	region269	city269	street269	371
270	region270	city270	street270	153
271	region271	city271	street271	58
272	region272	city272	street272	178
273	region273	city273	street273	145
274	region274	city274	street274	166
275	region275	city275	street275	54
276	region276	city276	street276	308
277	region277	city277	street277	380
278	region278	city278	street278	28
279	region279	city279	street279	193
280	region280	city280	street280	334
281	region281	city281	street281	13
282	region282	city282	street282	162
283	region283	city283	street283	352
284	region284	city284	street284	287
285	region285	city285	street285	226
286	region286	city286	street286	131
287	region287	city287	street287	258
288	region288	city288	street288	103
289	region289	city289	street289	137
290	region290	city290	street290	11
291	region291	city291	street291	333
292	region292	city292	street292	340
293	region293	city293	street293	373
294	region294	city294	street294	295
295	region295	city295	street295	250
296	region296	city296	street296	374
297	region297	city297	street297	153
298	region298	city298	street298	273
299	region299	city299	street299	270
300	region300	city300	street300	93
301	region301	city301	street301	32
302	region302	city302	street302	32
303	region303	city303	street303	217
304	region304	city304	street304	246
305	region305	city305	street305	29
306	region306	city306	street306	274
307	region307	city307	street307	20
308	region308	city308	street308	244
309	region309	city309	street309	254
310	region310	city310	street310	233
311	region311	city311	street311	268
312	region312	city312	street312	245
313	region313	city313	street313	263
314	region314	city314	street314	35
315	region315	city315	street315	6
316	region316	city316	street316	398
317	region317	city317	street317	344
318	region318	city318	street318	164
319	region319	city319	street319	124
320	region320	city320	street320	167
321	region321	city321	street321	12
322	region322	city322	street322	303
323	region323	city323	street323	202
324	region324	city324	street324	116
325	region325	city325	street325	373
326	region326	city326	street326	310
327	region327	city327	street327	280
328	region328	city328	street328	347
329	region329	city329	street329	266
330	region330	city330	street330	155
331	region331	city331	street331	383
332	region332	city332	street332	320
333	region333	city333	street333	365
334	region334	city334	street334	25
335	region335	city335	street335	231
336	region336	city336	street336	338
337	region337	city337	street337	107
338	region338	city338	street338	274
339	region339	city339	street339	338
340	region340	city340	street340	168
341	region341	city341	street341	39
342	region342	city342	street342	8
343	region343	city343	street343	57
344	region344	city344	street344	167
345	region345	city345	street345	191
346	region346	city346	street346	67
347	region347	city347	street347	338
348	region348	city348	street348	277
349	region349	city349	street349	31
350	region350	city350	street350	364
351	region351	city351	street351	79
352	region352	city352	street352	252
353	region353	city353	street353	134
354	region354	city354	street354	204
355	region355	city355	street355	258
356	region356	city356	street356	51
357	region357	city357	street357	17
358	region358	city358	street358	380
359	region359	city359	street359	388
360	region360	city360	street360	178
361	region361	city361	street361	220
362	region362	city362	street362	113
363	region363	city363	street363	332
364	region364	city364	street364	2
365	region365	city365	street365	255
366	region366	city366	street366	0
367	region367	city367	street367	251
368	region368	city368	street368	347
369	region369	city369	street369	392
370	region370	city370	street370	123
371	region371	city371	street371	65
372	region372	city372	street372	113
373	region373	city373	street373	366
374	region374	city374	street374	336
375	region375	city375	street375	346
376	region376	city376	street376	384
377	region377	city377	street377	64
378	region378	city378	street378	213
379	region379	city379	street379	240
380	region380	city380	street380	168
381	region381	city381	street381	312
382	region382	city382	street382	244
383	region383	city383	street383	396
384	region384	city384	street384	113
385	region385	city385	street385	79
386	region386	city386	street386	205
387	region387	city387	street387	309
388	region388	city388	street388	273
389	region389	city389	street389	241
390	region390	city390	street390	146
391	region391	city391	street391	330
392	region392	city392	street392	98
393	region393	city393	street393	293
394	region394	city394	street394	62
395	region395	city395	street395	122
396	region396	city396	street396	360
397	region397	city397	street397	241
398	region398	city398	street398	270
399	region399	city399	street399	166
400	region400	city400	street400	23
401	region401	city401	street401	126
402	region402	city402	street402	104
403	region403	city403	street403	90
404	region404	city404	street404	309
405	region405	city405	street405	386
406	region406	city406	street406	140
407	region407	city407	street407	375
408	region408	city408	street408	72
409	region409	city409	street409	377
410	region410	city410	street410	355
411	region411	city411	street411	1
412	region412	city412	street412	233
413	region413	city413	street413	238
414	region414	city414	street414	87
415	region415	city415	street415	190
416	region416	city416	street416	270
417	region417	city417	street417	67
418	region418	city418	street418	75
419	region419	city419	street419	60
420	region420	city420	street420	209
421	region421	city421	street421	351
422	region422	city422	street422	330
423	region423	city423	street423	107
424	region424	city424	street424	193
425	region425	city425	street425	307
426	region426	city426	street426	272
427	region427	city427	street427	60
428	region428	city428	street428	378
429	region429	city429	street429	323
430	region430	city430	street430	244
431	region431	city431	street431	345
432	region432	city432	street432	139
433	region433	city433	street433	232
434	region434	city434	street434	154
435	region435	city435	street435	193
436	region436	city436	street436	215
437	region437	city437	street437	149
438	region438	city438	street438	318
439	region439	city439	street439	58
440	region440	city440	street440	39
441	region441	city441	street441	319
442	region442	city442	street442	141
443	region443	city443	street443	363
444	region444	city444	street444	338
445	region445	city445	street445	49
446	region446	city446	street446	324
447	region447	city447	street447	243
448	region448	city448	street448	2
449	region449	city449	street449	276
450	region450	city450	street450	159
451	region451	city451	street451	271
452	region452	city452	street452	196
453	region453	city453	street453	188
454	region454	city454	street454	209
455	region455	city455	street455	96
456	region456	city456	street456	107
457	region457	city457	street457	195
458	region458	city458	street458	300
459	region459	city459	street459	135
460	region460	city460	street460	103
461	region461	city461	street461	136
462	region462	city462	street462	371
463	region463	city463	street463	192
464	region464	city464	street464	363
465	region465	city465	street465	339
466	region466	city466	street466	191
467	region467	city467	street467	365
468	region468	city468	street468	167
469	region469	city469	street469	200
470	region470	city470	street470	109
471	region471	city471	street471	87
472	region472	city472	street472	30
473	region473	city473	street473	86
474	region474	city474	street474	74
475	region475	city475	street475	282
476	region476	city476	street476	314
477	region477	city477	street477	4
478	region478	city478	street478	287
479	region479	city479	street479	153
480	region480	city480	street480	137
481	region481	city481	street481	40
482	region482	city482	street482	195
483	region483	city483	street483	275
484	region484	city484	street484	217
485	region485	city485	street485	0
486	region486	city486	street486	317
487	region487	city487	street487	364
488	region488	city488	street488	180
489	region489	city489	street489	102
490	region490	city490	street490	90
491	region491	city491	street491	207
492	region492	city492	street492	115
493	region493	city493	street493	83
494	region494	city494	street494	359
495	region495	city495	street495	340
496	region496	city496	street496	10
497	region497	city497	street497	207
498	region498	city498	street498	61
499	region499	city499	street499	175
500	region500	city500	street500	241
501	region501	city501	street501	188
502	region502	city502	street502	392
503	region503	city503	street503	100
504	region504	city504	street504	364
505	region505	city505	street505	33
506	region506	city506	street506	58
507	region507	city507	street507	390
508	region508	city508	street508	83
509	region509	city509	street509	275
510	region510	city510	street510	148
511	region511	city511	street511	10
512	region512	city512	street512	31
513	region513	city513	street513	344
514	region514	city514	street514	231
515	region515	city515	street515	53
516	region516	city516	street516	351
517	region517	city517	street517	239
518	region518	city518	street518	196
519	region519	city519	street519	160
520	region520	city520	street520	238
521	region521	city521	street521	236
522	region522	city522	street522	221
523	region523	city523	street523	393
524	region524	city524	street524	165
525	region525	city525	street525	41
526	region526	city526	street526	286
527	region527	city527	street527	260
528	region528	city528	street528	306
529	region529	city529	street529	137
530	region530	city530	street530	81
531	region531	city531	street531	388
532	region532	city532	street532	148
533	region533	city533	street533	289
534	region534	city534	street534	119
535	region535	city535	street535	341
536	region536	city536	street536	119
537	region537	city537	street537	60
538	region538	city538	street538	11
539	region539	city539	street539	359
540	region540	city540	street540	262
541	region541	city541	street541	104
542	region542	city542	street542	243
543	region543	city543	street543	399
544	region544	city544	street544	149
545	region545	city545	street545	201
546	region546	city546	street546	253
547	region547	city547	street547	245
548	region548	city548	street548	348
549	region549	city549	street549	261
550	region550	city550	street550	160
551	region551	city551	street551	175
552	region552	city552	street552	229
553	region553	city553	street553	244
554	region554	city554	street554	321
555	region555	city555	street555	258
556	region556	city556	street556	386
557	region557	city557	street557	221
558	region558	city558	street558	382
559	region559	city559	street559	306
560	region560	city560	street560	337
561	region561	city561	street561	169
562	region562	city562	street562	399
563	region563	city563	street563	238
564	region564	city564	street564	336
565	region565	city565	street565	43
566	region566	city566	street566	80
567	region567	city567	street567	185
568	region568	city568	street568	65
569	region569	city569	street569	243
570	region570	city570	street570	322
571	region571	city571	street571	366
572	region572	city572	street572	229
573	region573	city573	street573	27
574	region574	city574	street574	374
575	region575	city575	street575	132
576	region576	city576	street576	43
577	region577	city577	street577	324
578	region578	city578	street578	320
579	region579	city579	street579	331
580	region580	city580	street580	125
581	region581	city581	street581	149
582	region582	city582	street582	107
583	region583	city583	street583	191
584	region584	city584	street584	100
585	region585	city585	street585	341
586	region586	city586	street586	233
587	region587	city587	street587	205
588	region588	city588	street588	72
589	region589	city589	street589	1
590	region590	city590	street590	101
591	region591	city591	street591	380
592	region592	city592	street592	93
593	region593	city593	street593	273
594	region594	city594	street594	157
595	region595	city595	street595	149
596	region596	city596	street596	124
597	region597	city597	street597	3
598	region598	city598	street598	201
599	region599	city599	street599	145
600	region600	city600	street600	141
601	region601	city601	street601	96
602	region602	city602	street602	378
603	region603	city603	street603	58
604	region604	city604	street604	267
605	region605	city605	street605	157
606	region606	city606	street606	98
607	region607	city607	street607	299
608	region608	city608	street608	313
609	region609	city609	street609	279
610	region610	city610	street610	209
611	region611	city611	street611	345
612	region612	city612	street612	174
613	region613	city613	street613	244
614	region614	city614	street614	358
615	region615	city615	street615	294
616	region616	city616	street616	322
617	region617	city617	street617	367
618	region618	city618	street618	141
619	region619	city619	street619	66
620	region620	city620	street620	230
621	region621	city621	street621	115
622	region622	city622	street622	279
623	region623	city623	street623	229
624	region624	city624	street624	13
625	region625	city625	street625	124
626	region626	city626	street626	259
627	region627	city627	street627	109
628	region628	city628	street628	249
629	region629	city629	street629	6
630	region630	city630	street630	172
631	region631	city631	street631	353
632	region632	city632	street632	77
633	region633	city633	street633	283
634	region634	city634	street634	143
635	region635	city635	street635	24
636	region636	city636	street636	371
637	region637	city637	street637	337
638	region638	city638	street638	195
639	region639	city639	street639	53
640	region640	city640	street640	379
641	region641	city641	street641	138
642	region642	city642	street642	360
643	region643	city643	street643	359
644	region644	city644	street644	103
645	region645	city645	street645	190
646	region646	city646	street646	325
647	region647	city647	street647	275
648	region648	city648	street648	60
649	region649	city649	street649	191
650	region650	city650	street650	258
651	region651	city651	street651	298
652	region652	city652	street652	99
653	region653	city653	street653	13
654	region654	city654	street654	164
655	region655	city655	street655	364
656	region656	city656	street656	22
657	region657	city657	street657	269
658	region658	city658	street658	360
659	region659	city659	street659	300
660	region660	city660	street660	38
661	region661	city661	street661	246
662	region662	city662	street662	16
663	region663	city663	street663	120
664	region664	city664	street664	160
665	region665	city665	street665	158
666	region666	city666	street666	196
667	region667	city667	street667	362
668	region668	city668	street668	331
669	region669	city669	street669	352
670	region670	city670	street670	322
671	region671	city671	street671	321
672	region672	city672	street672	239
673	region673	city673	street673	11
674	region674	city674	street674	341
675	region675	city675	street675	303
676	region676	city676	street676	288
677	region677	city677	street677	103
678	region678	city678	street678	21
679	region679	city679	street679	196
680	region680	city680	street680	386
681	region681	city681	street681	47
682	region682	city682	street682	262
683	region683	city683	street683	381
684	region684	city684	street684	242
685	region685	city685	street685	182
686	region686	city686	street686	341
687	region687	city687	street687	207
688	region688	city688	street688	262
689	region689	city689	street689	85
690	region690	city690	street690	241
691	region691	city691	street691	169
692	region692	city692	street692	193
693	region693	city693	street693	171
694	region694	city694	street694	379
695	region695	city695	street695	371
696	region696	city696	street696	350
697	region697	city697	street697	153
698	region698	city698	street698	25
699	region699	city699	street699	151
700	region700	city700	street700	84
701	region701	city701	street701	8
702	region702	city702	street702	252
703	region703	city703	street703	38
704	region704	city704	street704	23
705	region705	city705	street705	74
706	region706	city706	street706	212
707	region707	city707	street707	345
708	region708	city708	street708	47
709	region709	city709	street709	38
710	region710	city710	street710	195
711	region711	city711	street711	342
712	region712	city712	street712	345
713	region713	city713	street713	217
714	region714	city714	street714	300
715	region715	city715	street715	209
716	region716	city716	street716	9
717	region717	city717	street717	30
718	region718	city718	street718	131
719	region719	city719	street719	66
720	region720	city720	street720	123
721	region721	city721	street721	320
722	region722	city722	street722	216
723	region723	city723	street723	159
724	region724	city724	street724	206
725	region725	city725	street725	190
726	region726	city726	street726	363
727	region727	city727	street727	355
728	region728	city728	street728	334
729	region729	city729	street729	399
730	region730	city730	street730	383
731	region731	city731	street731	24
732	region732	city732	street732	133
733	region733	city733	street733	74
734	region734	city734	street734	85
735	region735	city735	street735	307
736	region736	city736	street736	343
737	region737	city737	street737	79
738	region738	city738	street738	197
739	region739	city739	street739	23
740	region740	city740	street740	136
741	region741	city741	street741	383
742	region742	city742	street742	100
743	region743	city743	street743	349
744	region744	city744	street744	53
745	region745	city745	street745	243
746	region746	city746	street746	142
747	region747	city747	street747	293
748	region748	city748	street748	365
749	region749	city749	street749	334
750	region750	city750	street750	77
751	region751	city751	street751	336
752	region752	city752	street752	163
753	region753	city753	street753	31
754	region754	city754	street754	326
755	region755	city755	street755	292
756	region756	city756	street756	187
757	region757	city757	street757	392
758	region758	city758	street758	286
759	region759	city759	street759	37
760	region760	city760	street760	333
761	region761	city761	street761	190
762	region762	city762	street762	297
763	region763	city763	street763	42
764	region764	city764	street764	241
765	region765	city765	street765	287
766	region766	city766	street766	56
767	region767	city767	street767	292
768	region768	city768	street768	42
769	region769	city769	street769	163
770	region770	city770	street770	69
771	region771	city771	street771	321
772	region772	city772	street772	168
773	region773	city773	street773	162
774	region774	city774	street774	303
775	region775	city775	street775	97
776	region776	city776	street776	256
777	region777	city777	street777	292
778	region778	city778	street778	300
779	region779	city779	street779	161
780	region780	city780	street780	294
781	region781	city781	street781	58
782	region782	city782	street782	111
783	region783	city783	street783	124
784	region784	city784	street784	328
785	region785	city785	street785	104
786	region786	city786	street786	157
787	region787	city787	street787	197
788	region788	city788	street788	117
789	region789	city789	street789	87
790	region790	city790	street790	379
791	region791	city791	street791	359
792	region792	city792	street792	48
793	region793	city793	street793	82
794	region794	city794	street794	140
795	region795	city795	street795	272
796	region796	city796	street796	192
797	region797	city797	street797	225
798	region798	city798	street798	117
799	region799	city799	street799	229
800	region800	city800	street800	335
801	region801	city801	street801	336
802	region802	city802	street802	38
803	region803	city803	street803	106
804	region804	city804	street804	343
805	region805	city805	street805	251
806	region806	city806	street806	316
807	region807	city807	street807	197
808	region808	city808	street808	119
809	region809	city809	street809	43
810	region810	city810	street810	96
811	region811	city811	street811	359
812	region812	city812	street812	174
813	region813	city813	street813	124
814	region814	city814	street814	5
815	region815	city815	street815	305
816	region816	city816	street816	268
817	region817	city817	street817	365
818	region818	city818	street818	254
819	region819	city819	street819	398
820	region820	city820	street820	317
821	region821	city821	street821	348
822	region822	city822	street822	11
823	region823	city823	street823	386
824	region824	city824	street824	356
825	region825	city825	street825	36
826	region826	city826	street826	153
827	region827	city827	street827	262
828	region828	city828	street828	24
829	region829	city829	street829	41
830	region830	city830	street830	304
831	region831	city831	street831	174
832	region832	city832	street832	340
833	region833	city833	street833	65
834	region834	city834	street834	150
835	region835	city835	street835	313
836	region836	city836	street836	108
837	region837	city837	street837	112
838	region838	city838	street838	63
839	region839	city839	street839	242
840	region840	city840	street840	274
841	region841	city841	street841	129
842	region842	city842	street842	100
843	region843	city843	street843	255
844	region844	city844	street844	313
845	region845	city845	street845	360
846	region846	city846	street846	304
847	region847	city847	street847	1
848	region848	city848	street848	342
849	region849	city849	street849	86
850	region850	city850	street850	149
851	region851	city851	street851	244
852	region852	city852	street852	138
853	region853	city853	street853	182
854	region854	city854	street854	50
855	region855	city855	street855	317
856	region856	city856	street856	347
857	region857	city857	street857	195
858	region858	city858	street858	237
859	region859	city859	street859	22
860	region860	city860	street860	333
861	region861	city861	street861	57
862	region862	city862	street862	84
863	region863	city863	street863	263
864	region864	city864	street864	220
865	region865	city865	street865	142
866	region866	city866	street866	392
867	region867	city867	street867	77
868	region868	city868	street868	335
869	region869	city869	street869	236
870	region870	city870	street870	188
871	region871	city871	street871	238
872	region872	city872	street872	102
873	region873	city873	street873	307
874	region874	city874	street874	309
875	region875	city875	street875	243
876	region876	city876	street876	70
877	region877	city877	street877	198
878	region878	city878	street878	344
879	region879	city879	street879	287
880	region880	city880	street880	326
881	region881	city881	street881	68
882	region882	city882	street882	395
883	region883	city883	street883	299
884	region884	city884	street884	280
885	region885	city885	street885	104
886	region886	city886	street886	157
887	region887	city887	street887	189
888	region888	city888	street888	311
889	region889	city889	street889	106
890	region890	city890	street890	387
891	region891	city891	street891	305
892	region892	city892	street892	42
893	region893	city893	street893	233
894	region894	city894	street894	94
895	region895	city895	street895	315
896	region896	city896	street896	98
897	region897	city897	street897	247
898	region898	city898	street898	104
899	region899	city899	street899	221
900	region900	city900	street900	15
901	region901	city901	street901	107
902	region902	city902	street902	187
903	region903	city903	street903	213
904	region904	city904	street904	268
905	region905	city905	street905	173
906	region906	city906	street906	304
907	region907	city907	street907	152
908	region908	city908	street908	132
909	region909	city909	street909	152
910	region910	city910	street910	346
911	region911	city911	street911	125
912	region912	city912	street912	12
913	region913	city913	street913	126
914	region914	city914	street914	9
915	region915	city915	street915	180
916	region916	city916	street916	113
917	region917	city917	street917	129
918	region918	city918	street918	11
919	region919	city919	street919	39
920	region920	city920	street920	68
921	region921	city921	street921	173
922	region922	city922	street922	399
923	region923	city923	street923	388
924	region924	city924	street924	250
925	region925	city925	street925	90
926	region926	city926	street926	49
927	region927	city927	street927	149
928	region928	city928	street928	191
929	region929	city929	street929	394
930	region930	city930	street930	101
931	region931	city931	street931	299
932	region932	city932	street932	75
933	region933	city933	street933	269
934	region934	city934	street934	171
935	region935	city935	street935	201
936	region936	city936	street936	298
937	region937	city937	street937	212
938	region938	city938	street938	346
939	region939	city939	street939	50
940	region940	city940	street940	169
941	region941	city941	street941	245
942	region942	city942	street942	207
943	region943	city943	street943	326
944	region944	city944	street944	302
945	region945	city945	street945	154
946	region946	city946	street946	322
947	region947	city947	street947	46
948	region948	city948	street948	242
949	region949	city949	street949	377
950	region950	city950	street950	268
951	region951	city951	street951	160
952	region952	city952	street952	40
953	region953	city953	street953	359
954	region954	city954	street954	227
955	region955	city955	street955	357
956	region956	city956	street956	342
957	region957	city957	street957	100
958	region958	city958	street958	246
959	region959	city959	street959	33
960	region960	city960	street960	320
961	region961	city961	street961	68
962	region962	city962	street962	103
963	region963	city963	street963	182
964	region964	city964	street964	118
965	region965	city965	street965	321
966	region966	city966	street966	72
967	region967	city967	street967	4
968	region968	city968	street968	202
969	region969	city969	street969	193
970	region970	city970	street970	42
971	region971	city971	street971	58
972	region972	city972	street972	62
973	region973	city973	street973	9
974	region974	city974	street974	352
975	region975	city975	street975	131
976	region976	city976	street976	200
977	region977	city977	street977	185
978	region978	city978	street978	236
979	region979	city979	street979	338
980	region980	city980	street980	67
981	region981	city981	street981	97
982	region982	city982	street982	254
983	region983	city983	street983	19
984	region984	city984	street984	77
985	region985	city985	street985	317
986	region986	city986	street986	395
987	region987	city987	street987	90
988	region988	city988	street988	174
989	region989	city989	street989	342
990	region990	city990	street990	42
991	region991	city991	street991	260
992	region992	city992	street992	227
993	region993	city993	street993	56
994	region994	city994	street994	70
995	region995	city995	street995	3
996	region996	city996	street996	279
997	region997	city997	street997	216
998	region998	city998	street998	74
999	region999	city999	street999	126
1000	region1000	city1000	street1000	343
1001	region1001	city1001	street1001	296
1002	region1002	city1002	street1002	364
1003	region1003	city1003	street1003	157
1004	region1004	city1004	street1004	90
1005	region1005	city1005	street1005	247
1006	region1006	city1006	street1006	95
1007	region1007	city1007	street1007	232
1008	region1008	city1008	street1008	296
1009	region1009	city1009	street1009	33
1010	region1010	city1010	street1010	289
1011	region1011	city1011	street1011	376
1012	region1012	city1012	street1012	186
1013	region1013	city1013	street1013	96
1014	region1014	city1014	street1014	187
1015	region1015	city1015	street1015	60
1016	region1016	city1016	street1016	216
1017	region1017	city1017	street1017	368
1018	region1018	city1018	street1018	277
1019	region1019	city1019	street1019	349
1020	region1020	city1020	street1020	126
1021	region1021	city1021	street1021	222
1022	region1022	city1022	street1022	318
1023	region1023	city1023	street1023	49
1024	region1024	city1024	street1024	82
1025	region1025	city1025	street1025	357
1026	region1026	city1026	street1026	46
1027	region1027	city1027	street1027	249
1028	region1028	city1028	street1028	6
1029	region1029	city1029	street1029	276
1030	region1030	city1030	street1030	79
1031	region1031	city1031	street1031	94
1032	region1032	city1032	street1032	148
1033	region1033	city1033	street1033	382
1034	region1034	city1034	street1034	26
1035	region1035	city1035	street1035	207
1036	region1036	city1036	street1036	301
1037	region1037	city1037	street1037	359
1038	region1038	city1038	street1038	58
1039	region1039	city1039	street1039	2
1040	region1040	city1040	street1040	151
1041	region1041	city1041	street1041	333
1042	region1042	city1042	street1042	129
1043	region1043	city1043	street1043	397
1044	region1044	city1044	street1044	205
1045	region1045	city1045	street1045	390
1046	region1046	city1046	street1046	134
1047	region1047	city1047	street1047	184
1048	region1048	city1048	street1048	398
1049	region1049	city1049	street1049	313
1050	region1050	city1050	street1050	21
1051	region1051	city1051	street1051	164
1052	region1052	city1052	street1052	31
1053	region1053	city1053	street1053	252
1054	region1054	city1054	street1054	128
1055	region1055	city1055	street1055	370
1056	region1056	city1056	street1056	186
1057	region1057	city1057	street1057	394
1058	region1058	city1058	street1058	315
1059	region1059	city1059	street1059	208
1060	region1060	city1060	street1060	354
1061	region1061	city1061	street1061	122
1062	region1062	city1062	street1062	3
1063	region1063	city1063	street1063	341
1064	region1064	city1064	street1064	269
1065	region1065	city1065	street1065	2
1066	region1066	city1066	street1066	21
1067	region1067	city1067	street1067	354
1068	region1068	city1068	street1068	44
1069	region1069	city1069	street1069	230
1070	region1070	city1070	street1070	90
1071	region1071	city1071	street1071	370
1072	region1072	city1072	street1072	168
1073	region1073	city1073	street1073	362
1074	region1074	city1074	street1074	398
1075	region1075	city1075	street1075	58
1076	region1076	city1076	street1076	169
1077	region1077	city1077	street1077	66
1078	region1078	city1078	street1078	304
1079	region1079	city1079	street1079	298
1080	region1080	city1080	street1080	123
1081	region1081	city1081	street1081	286
1082	region1082	city1082	street1082	347
1083	region1083	city1083	street1083	324
1084	region1084	city1084	street1084	364
1085	region1085	city1085	street1085	103
1086	region1086	city1086	street1086	125
1087	region1087	city1087	street1087	102
1088	region1088	city1088	street1088	74
1089	region1089	city1089	street1089	99
1090	region1090	city1090	street1090	55
1091	region1091	city1091	street1091	161
1092	region1092	city1092	street1092	8
1093	region1093	city1093	street1093	322
1094	region1094	city1094	street1094	312
1095	region1095	city1095	street1095	279
1096	region1096	city1096	street1096	387
1097	region1097	city1097	street1097	145
1098	region1098	city1098	street1098	114
1099	region1099	city1099	street1099	50
1100	region1100	city1100	street1100	273
1101	region1101	city1101	street1101	88
1102	region1102	city1102	street1102	61
1103	region1103	city1103	street1103	109
1104	region1104	city1104	street1104	167
1105	region1105	city1105	street1105	54
1106	region1106	city1106	street1106	16
1107	region1107	city1107	street1107	378
1108	region1108	city1108	street1108	219
1109	region1109	city1109	street1109	356
1110	region1110	city1110	street1110	68
1111	region1111	city1111	street1111	350
1112	region1112	city1112	street1112	249
1113	region1113	city1113	street1113	248
1114	region1114	city1114	street1114	387
1115	region1115	city1115	street1115	372
1116	region1116	city1116	street1116	312
1117	region1117	city1117	street1117	308
1118	region1118	city1118	street1118	176
1119	region1119	city1119	street1119	113
1120	region1120	city1120	street1120	4
1121	region1121	city1121	street1121	105
1122	region1122	city1122	street1122	313
1123	region1123	city1123	street1123	339
1124	region1124	city1124	street1124	17
1125	region1125	city1125	street1125	144
1126	region1126	city1126	street1126	181
1127	region1127	city1127	street1127	341
1128	region1128	city1128	street1128	61
1129	region1129	city1129	street1129	122
1130	region1130	city1130	street1130	292
1131	region1131	city1131	street1131	271
1132	region1132	city1132	street1132	26
1133	region1133	city1133	street1133	116
1134	region1134	city1134	street1134	143
1135	region1135	city1135	street1135	154
1136	region1136	city1136	street1136	52
1137	region1137	city1137	street1137	2
1138	region1138	city1138	street1138	281
1139	region1139	city1139	street1139	143
1140	region1140	city1140	street1140	266
1141	region1141	city1141	street1141	331
1142	region1142	city1142	street1142	318
1143	region1143	city1143	street1143	34
1144	region1144	city1144	street1144	344
1145	region1145	city1145	street1145	316
1146	region1146	city1146	street1146	194
1147	region1147	city1147	street1147	93
1148	region1148	city1148	street1148	108
1149	region1149	city1149	street1149	244
1150	region1150	city1150	street1150	155
1151	region1151	city1151	street1151	267
1152	region1152	city1152	street1152	249
1153	region1153	city1153	street1153	11
1154	region1154	city1154	street1154	274
1155	region1155	city1155	street1155	14
1156	region1156	city1156	street1156	262
1157	region1157	city1157	street1157	32
1158	region1158	city1158	street1158	297
1159	region1159	city1159	street1159	200
1160	region1160	city1160	street1160	22
1161	region1161	city1161	street1161	196
1162	region1162	city1162	street1162	173
1163	region1163	city1163	street1163	335
1164	region1164	city1164	street1164	66
1165	region1165	city1165	street1165	39
1166	region1166	city1166	street1166	368
1167	region1167	city1167	street1167	152
1168	region1168	city1168	street1168	374
1169	region1169	city1169	street1169	53
1170	region1170	city1170	street1170	373
1171	region1171	city1171	street1171	149
1172	region1172	city1172	street1172	286
1173	region1173	city1173	street1173	201
1174	region1174	city1174	street1174	150
1175	region1175	city1175	street1175	375
1176	region1176	city1176	street1176	174
1177	region1177	city1177	street1177	135
1178	region1178	city1178	street1178	104
1179	region1179	city1179	street1179	113
1180	region1180	city1180	street1180	237
1181	region1181	city1181	street1181	168
1182	region1182	city1182	street1182	122
1183	region1183	city1183	street1183	358
1184	region1184	city1184	street1184	385
1185	region1185	city1185	street1185	150
1186	region1186	city1186	street1186	250
1187	region1187	city1187	street1187	155
1188	region1188	city1188	street1188	225
1189	region1189	city1189	street1189	191
1190	region1190	city1190	street1190	83
1191	region1191	city1191	street1191	168
1192	region1192	city1192	street1192	117
1193	region1193	city1193	street1193	142
1194	region1194	city1194	street1194	176
1195	region1195	city1195	street1195	321
1196	region1196	city1196	street1196	301
1197	region1197	city1197	street1197	69
1198	region1198	city1198	street1198	74
1199	region1199	city1199	street1199	232
1200	region1200	city1200	street1200	185
1201	region1201	city1201	street1201	280
1202	region1202	city1202	street1202	67
1203	region1203	city1203	street1203	311
1204	region1204	city1204	street1204	230
1205	region1205	city1205	street1205	37
1206	region1206	city1206	street1206	91
1207	region1207	city1207	street1207	187
1208	region1208	city1208	street1208	343
1209	region1209	city1209	street1209	284
1210	region1210	city1210	street1210	356
1211	region1211	city1211	street1211	194
1212	region1212	city1212	street1212	111
1213	region1213	city1213	street1213	320
1214	region1214	city1214	street1214	86
1215	region1215	city1215	street1215	370
1216	region1216	city1216	street1216	367
1217	region1217	city1217	street1217	231
1218	region1218	city1218	street1218	368
1219	region1219	city1219	street1219	233
1220	region1220	city1220	street1220	299
1221	region1221	city1221	street1221	287
1222	region1222	city1222	street1222	364
1223	region1223	city1223	street1223	369
1224	region1224	city1224	street1224	88
1225	region1225	city1225	street1225	353
1226	region1226	city1226	street1226	239
1227	region1227	city1227	street1227	95
1228	region1228	city1228	street1228	371
1229	region1229	city1229	street1229	212
1230	region1230	city1230	street1230	231
1231	region1231	city1231	street1231	204
1232	region1232	city1232	street1232	397
1233	region1233	city1233	street1233	163
1234	region1234	city1234	street1234	252
1235	region1235	city1235	street1235	213
1236	region1236	city1236	street1236	169
1237	region1237	city1237	street1237	101
1238	region1238	city1238	street1238	47
1239	region1239	city1239	street1239	12
1240	region1240	city1240	street1240	275
1241	region1241	city1241	street1241	328
1242	region1242	city1242	street1242	372
1243	region1243	city1243	street1243	232
1244	region1244	city1244	street1244	16
1245	region1245	city1245	street1245	91
1246	region1246	city1246	street1246	342
1247	region1247	city1247	street1247	267
1248	region1248	city1248	street1248	5
1249	region1249	city1249	street1249	285
1250	region1250	city1250	street1250	371
1251	region1251	city1251	street1251	171
1252	region1252	city1252	street1252	202
1253	region1253	city1253	street1253	61
1254	region1254	city1254	street1254	64
1255	region1255	city1255	street1255	288
1256	region1256	city1256	street1256	208
1257	region1257	city1257	street1257	84
1258	region1258	city1258	street1258	309
1259	region1259	city1259	street1259	329
1260	region1260	city1260	street1260	399
1261	region1261	city1261	street1261	149
1262	region1262	city1262	street1262	55
1263	region1263	city1263	street1263	383
1264	region1264	city1264	street1264	22
1265	region1265	city1265	street1265	138
1266	region1266	city1266	street1266	259
1267	region1267	city1267	street1267	115
1268	region1268	city1268	street1268	39
1269	region1269	city1269	street1269	194
1270	region1270	city1270	street1270	198
1271	region1271	city1271	street1271	133
1272	region1272	city1272	street1272	146
1273	region1273	city1273	street1273	102
1274	region1274	city1274	street1274	290
1275	region1275	city1275	street1275	156
1276	region1276	city1276	street1276	133
1277	region1277	city1277	street1277	253
1278	region1278	city1278	street1278	205
1279	region1279	city1279	street1279	304
1280	region1280	city1280	street1280	238
1281	region1281	city1281	street1281	91
1282	region1282	city1282	street1282	324
1283	region1283	city1283	street1283	50
1284	region1284	city1284	street1284	318
1285	region1285	city1285	street1285	261
1286	region1286	city1286	street1286	328
1287	region1287	city1287	street1287	99
1288	region1288	city1288	street1288	354
1289	region1289	city1289	street1289	230
1290	region1290	city1290	street1290	376
1291	region1291	city1291	street1291	132
1292	region1292	city1292	street1292	124
1293	region1293	city1293	street1293	266
1294	region1294	city1294	street1294	96
1295	region1295	city1295	street1295	247
1296	region1296	city1296	street1296	326
1297	region1297	city1297	street1297	151
1298	region1298	city1298	street1298	201
1299	region1299	city1299	street1299	210
1300	region1300	city1300	street1300	24
1301	region1301	city1301	street1301	216
1302	region1302	city1302	street1302	209
1303	region1303	city1303	street1303	63
1304	region1304	city1304	street1304	150
1305	region1305	city1305	street1305	41
1306	region1306	city1306	street1306	162
1307	region1307	city1307	street1307	129
1308	region1308	city1308	street1308	17
1309	region1309	city1309	street1309	57
1310	region1310	city1310	street1310	114
1311	region1311	city1311	street1311	68
1312	region1312	city1312	street1312	399
1313	region1313	city1313	street1313	92
1314	region1314	city1314	street1314	28
1315	region1315	city1315	street1315	173
1316	region1316	city1316	street1316	164
1317	region1317	city1317	street1317	80
1318	region1318	city1318	street1318	291
1319	region1319	city1319	street1319	369
1320	region1320	city1320	street1320	131
1321	region1321	city1321	street1321	52
1322	region1322	city1322	street1322	276
1323	region1323	city1323	street1323	270
1324	region1324	city1324	street1324	196
1325	region1325	city1325	street1325	63
1326	region1326	city1326	street1326	14
1327	region1327	city1327	street1327	307
1328	region1328	city1328	street1328	258
1329	region1329	city1329	street1329	194
1330	region1330	city1330	street1330	109
1331	region1331	city1331	street1331	332
1332	region1332	city1332	street1332	149
1333	region1333	city1333	street1333	141
1334	region1334	city1334	street1334	188
1335	region1335	city1335	street1335	112
1336	region1336	city1336	street1336	126
1337	region1337	city1337	street1337	342
1338	region1338	city1338	street1338	204
1339	region1339	city1339	street1339	52
1340	region1340	city1340	street1340	363
1341	region1341	city1341	street1341	189
1342	region1342	city1342	street1342	126
1343	region1343	city1343	street1343	45
1344	region1344	city1344	street1344	75
1345	region1345	city1345	street1345	6
1346	region1346	city1346	street1346	145
1347	region1347	city1347	street1347	68
1348	region1348	city1348	street1348	162
1349	region1349	city1349	street1349	116
1350	region1350	city1350	street1350	266
1351	region1351	city1351	street1351	335
1352	region1352	city1352	street1352	237
1353	region1353	city1353	street1353	32
1354	region1354	city1354	street1354	242
1355	region1355	city1355	street1355	200
1356	region1356	city1356	street1356	243
1357	region1357	city1357	street1357	116
1358	region1358	city1358	street1358	40
1359	region1359	city1359	street1359	218
1360	region1360	city1360	street1360	191
1361	region1361	city1361	street1361	228
1362	region1362	city1362	street1362	92
1363	region1363	city1363	street1363	315
1364	region1364	city1364	street1364	97
1365	region1365	city1365	street1365	3
1366	region1366	city1366	street1366	371
1367	region1367	city1367	street1367	32
1368	region1368	city1368	street1368	118
1369	region1369	city1369	street1369	370
1370	region1370	city1370	street1370	306
1371	region1371	city1371	street1371	168
1372	region1372	city1372	street1372	28
1373	region1373	city1373	street1373	196
1374	region1374	city1374	street1374	191
1375	region1375	city1375	street1375	315
1376	region1376	city1376	street1376	165
1377	region1377	city1377	street1377	114
1378	region1378	city1378	street1378	27
1379	region1379	city1379	street1379	251
1380	region1380	city1380	street1380	150
1381	region1381	city1381	street1381	240
1382	region1382	city1382	street1382	173
1383	region1383	city1383	street1383	162
1384	region1384	city1384	street1384	73
1385	region1385	city1385	street1385	276
1386	region1386	city1386	street1386	21
1387	region1387	city1387	street1387	299
1388	region1388	city1388	street1388	311
1389	region1389	city1389	street1389	212
1390	region1390	city1390	street1390	316
1391	region1391	city1391	street1391	111
1392	region1392	city1392	street1392	148
1393	region1393	city1393	street1393	100
1394	region1394	city1394	street1394	88
1395	region1395	city1395	street1395	7
1396	region1396	city1396	street1396	247
1397	region1397	city1397	street1397	105
1398	region1398	city1398	street1398	137
1399	region1399	city1399	street1399	133
1400	region1400	city1400	street1400	86
1401	region1401	city1401	street1401	102
1402	region1402	city1402	street1402	200
1403	region1403	city1403	street1403	166
1404	region1404	city1404	street1404	132
1405	region1405	city1405	street1405	173
1406	region1406	city1406	street1406	7
1407	region1407	city1407	street1407	169
1408	region1408	city1408	street1408	132
1409	region1409	city1409	street1409	252
1410	region1410	city1410	street1410	54
1411	region1411	city1411	street1411	139
1412	region1412	city1412	street1412	396
1413	region1413	city1413	street1413	183
1414	region1414	city1414	street1414	199
1415	region1415	city1415	street1415	177
1416	region1416	city1416	street1416	205
1417	region1417	city1417	street1417	250
1418	region1418	city1418	street1418	345
1419	region1419	city1419	street1419	293
1420	region1420	city1420	street1420	270
1421	region1421	city1421	street1421	238
1422	region1422	city1422	street1422	318
1423	region1423	city1423	street1423	147
1424	region1424	city1424	street1424	329
1425	region1425	city1425	street1425	48
1426	region1426	city1426	street1426	240
1427	region1427	city1427	street1427	333
1428	region1428	city1428	street1428	129
1429	region1429	city1429	street1429	28
1430	region1430	city1430	street1430	162
1431	region1431	city1431	street1431	281
1432	region1432	city1432	street1432	161
1433	region1433	city1433	street1433	209
1434	region1434	city1434	street1434	84
1435	region1435	city1435	street1435	190
1436	region1436	city1436	street1436	223
1437	region1437	city1437	street1437	114
1438	region1438	city1438	street1438	265
1439	region1439	city1439	street1439	57
1440	region1440	city1440	street1440	51
1441	region1441	city1441	street1441	281
1442	region1442	city1442	street1442	281
1443	region1443	city1443	street1443	313
1444	region1444	city1444	street1444	145
1445	region1445	city1445	street1445	235
1446	region1446	city1446	street1446	289
1447	region1447	city1447	street1447	77
1448	region1448	city1448	street1448	263
1449	region1449	city1449	street1449	57
1450	region1450	city1450	street1450	160
1451	region1451	city1451	street1451	93
1452	region1452	city1452	street1452	194
1453	region1453	city1453	street1453	43
1454	region1454	city1454	street1454	165
1455	region1455	city1455	street1455	107
1456	region1456	city1456	street1456	130
1457	region1457	city1457	street1457	394
1458	region1458	city1458	street1458	64
1459	region1459	city1459	street1459	6
1460	region1460	city1460	street1460	103
1461	region1461	city1461	street1461	268
1462	region1462	city1462	street1462	302
1463	region1463	city1463	street1463	172
1464	region1464	city1464	street1464	44
1465	region1465	city1465	street1465	178
1466	region1466	city1466	street1466	306
1467	region1467	city1467	street1467	348
1468	region1468	city1468	street1468	323
1469	region1469	city1469	street1469	326
1470	region1470	city1470	street1470	266
1471	region1471	city1471	street1471	65
1472	region1472	city1472	street1472	53
1473	region1473	city1473	street1473	249
1474	region1474	city1474	street1474	390
1475	region1475	city1475	street1475	134
1476	region1476	city1476	street1476	281
1477	region1477	city1477	street1477	254
1478	region1478	city1478	street1478	272
1479	region1479	city1479	street1479	314
1480	region1480	city1480	street1480	91
1481	region1481	city1481	street1481	254
1482	region1482	city1482	street1482	210
1483	region1483	city1483	street1483	28
1484	region1484	city1484	street1484	308
1485	region1485	city1485	street1485	63
1486	region1486	city1486	street1486	5
1487	region1487	city1487	street1487	398
1488	region1488	city1488	street1488	258
1489	region1489	city1489	street1489	224
1490	region1490	city1490	street1490	233
1491	region1491	city1491	street1491	97
1492	region1492	city1492	street1492	56
1493	region1493	city1493	street1493	278
1494	region1494	city1494	street1494	207
1495	region1495	city1495	street1495	278
1496	region1496	city1496	street1496	152
1497	region1497	city1497	street1497	272
1498	region1498	city1498	street1498	305
1499	region1499	city1499	street1499	121
1500	region1500	city1500	street1500	227
1501	region1501	city1501	street1501	312
1502	region1502	city1502	street1502	135
1503	region1503	city1503	street1503	306
1504	region1504	city1504	street1504	159
1505	region1505	city1505	street1505	47
1506	region1506	city1506	street1506	355
1507	region1507	city1507	street1507	110
1508	region1508	city1508	street1508	308
1509	region1509	city1509	street1509	400
1510	region1510	city1510	street1510	19
1511	region1511	city1511	street1511	261
1512	region1512	city1512	street1512	337
1513	region1513	city1513	street1513	7
1514	region1514	city1514	street1514	389
1515	region1515	city1515	street1515	281
1516	region1516	city1516	street1516	311
1517	region1517	city1517	street1517	102
1518	region1518	city1518	street1518	90
1519	region1519	city1519	street1519	298
1520	region1520	city1520	street1520	144
1521	region1521	city1521	street1521	62
1522	region1522	city1522	street1522	371
1523	region1523	city1523	street1523	254
1524	region1524	city1524	street1524	120
1525	region1525	city1525	street1525	328
1526	region1526	city1526	street1526	76
1527	region1527	city1527	street1527	79
1528	region1528	city1528	street1528	311
1529	region1529	city1529	street1529	330
1530	region1530	city1530	street1530	212
1531	region1531	city1531	street1531	275
1532	region1532	city1532	street1532	291
1533	region1533	city1533	street1533	315
1534	region1534	city1534	street1534	202
1535	region1535	city1535	street1535	255
1536	region1536	city1536	street1536	319
1537	region1537	city1537	street1537	342
1538	region1538	city1538	street1538	7
1539	region1539	city1539	street1539	15
1540	region1540	city1540	street1540	256
1541	region1541	city1541	street1541	168
1542	region1542	city1542	street1542	233
1543	region1543	city1543	street1543	149
1544	region1544	city1544	street1544	297
1545	region1545	city1545	street1545	187
1546	region1546	city1546	street1546	236
1547	region1547	city1547	street1547	128
1548	region1548	city1548	street1548	261
1549	region1549	city1549	street1549	87
1550	region1550	city1550	street1550	134
1551	region1551	city1551	street1551	12
1552	region1552	city1552	street1552	46
1553	region1553	city1553	street1553	328
1554	region1554	city1554	street1554	248
1555	region1555	city1555	street1555	366
1556	region1556	city1556	street1556	11
1557	region1557	city1557	street1557	177
1558	region1558	city1558	street1558	133
1559	region1559	city1559	street1559	157
1560	region1560	city1560	street1560	189
1561	region1561	city1561	street1561	9
1562	region1562	city1562	street1562	101
1563	region1563	city1563	street1563	279
1564	region1564	city1564	street1564	277
1565	region1565	city1565	street1565	121
1566	region1566	city1566	street1566	178
1567	region1567	city1567	street1567	397
1568	region1568	city1568	street1568	36
1569	region1569	city1569	street1569	217
1570	region1570	city1570	street1570	117
1571	region1571	city1571	street1571	159
1572	region1572	city1572	street1572	101
1573	region1573	city1573	street1573	350
1574	region1574	city1574	street1574	75
1575	region1575	city1575	street1575	182
1576	region1576	city1576	street1576	392
1577	region1577	city1577	street1577	400
1578	region1578	city1578	street1578	0
1579	region1579	city1579	street1579	377
1580	region1580	city1580	street1580	38
1581	region1581	city1581	street1581	180
1582	region1582	city1582	street1582	144
1583	region1583	city1583	street1583	371
1584	region1584	city1584	street1584	53
1585	region1585	city1585	street1585	189
1586	region1586	city1586	street1586	188
1587	region1587	city1587	street1587	291
1588	region1588	city1588	street1588	387
1589	region1589	city1589	street1589	362
1590	region1590	city1590	street1590	246
1591	region1591	city1591	street1591	383
1592	region1592	city1592	street1592	80
1593	region1593	city1593	street1593	255
1594	region1594	city1594	street1594	308
1595	region1595	city1595	street1595	213
1596	region1596	city1596	street1596	74
1597	region1597	city1597	street1597	136
1598	region1598	city1598	street1598	308
1599	region1599	city1599	street1599	8
1600	region1600	city1600	street1600	192
1601	region1601	city1601	street1601	81
1602	region1602	city1602	street1602	374
1603	region1603	city1603	street1603	9
1604	region1604	city1604	street1604	111
1605	region1605	city1605	street1605	100
1606	region1606	city1606	street1606	216
1607	region1607	city1607	street1607	230
1608	region1608	city1608	street1608	303
1609	region1609	city1609	street1609	161
1610	region1610	city1610	street1610	58
1611	region1611	city1611	street1611	10
1612	region1612	city1612	street1612	374
1613	region1613	city1613	street1613	61
1614	region1614	city1614	street1614	146
1615	region1615	city1615	street1615	346
1616	region1616	city1616	street1616	181
1617	region1617	city1617	street1617	199
1618	region1618	city1618	street1618	82
1619	region1619	city1619	street1619	221
1620	region1620	city1620	street1620	28
1621	region1621	city1621	street1621	297
1622	region1622	city1622	street1622	274
1623	region1623	city1623	street1623	366
1624	region1624	city1624	street1624	229
1625	region1625	city1625	street1625	228
1626	region1626	city1626	street1626	205
1627	region1627	city1627	street1627	190
1628	region1628	city1628	street1628	90
1629	region1629	city1629	street1629	120
1630	region1630	city1630	street1630	310
1631	region1631	city1631	street1631	60
1632	region1632	city1632	street1632	69
1633	region1633	city1633	street1633	84
1634	region1634	city1634	street1634	86
1635	region1635	city1635	street1635	365
1636	region1636	city1636	street1636	312
1637	region1637	city1637	street1637	117
1638	region1638	city1638	street1638	330
1639	region1639	city1639	street1639	299
1640	region1640	city1640	street1640	143
1641	region1641	city1641	street1641	8
1642	region1642	city1642	street1642	89
1643	region1643	city1643	street1643	22
1644	region1644	city1644	street1644	51
1645	region1645	city1645	street1645	366
1646	region1646	city1646	street1646	188
1647	region1647	city1647	street1647	190
1648	region1648	city1648	street1648	163
1649	region1649	city1649	street1649	122
1650	region1650	city1650	street1650	10
1651	region1651	city1651	street1651	315
1652	region1652	city1652	street1652	233
1653	region1653	city1653	street1653	190
1654	region1654	city1654	street1654	146
1655	region1655	city1655	street1655	392
1656	region1656	city1656	street1656	105
1657	region1657	city1657	street1657	252
1658	region1658	city1658	street1658	22
1659	region1659	city1659	street1659	272
1660	region1660	city1660	street1660	310
1661	region1661	city1661	street1661	185
1662	region1662	city1662	street1662	293
1663	region1663	city1663	street1663	255
1664	region1664	city1664	street1664	161
1665	region1665	city1665	street1665	207
1666	region1666	city1666	street1666	173
1667	region1667	city1667	street1667	80
1668	region1668	city1668	street1668	67
1669	region1669	city1669	street1669	147
1670	region1670	city1670	street1670	15
1671	region1671	city1671	street1671	375
1672	region1672	city1672	street1672	76
1673	region1673	city1673	street1673	349
1674	region1674	city1674	street1674	210
1675	region1675	city1675	street1675	268
1676	region1676	city1676	street1676	274
1677	region1677	city1677	street1677	97
1678	region1678	city1678	street1678	26
1679	region1679	city1679	street1679	14
1680	region1680	city1680	street1680	342
1681	region1681	city1681	street1681	152
1682	region1682	city1682	street1682	272
1683	region1683	city1683	street1683	164
1684	region1684	city1684	street1684	242
1685	region1685	city1685	street1685	170
1686	region1686	city1686	street1686	276
1687	region1687	city1687	street1687	226
1688	region1688	city1688	street1688	220
1689	region1689	city1689	street1689	213
1690	region1690	city1690	street1690	344
1691	region1691	city1691	street1691	291
1692	region1692	city1692	street1692	228
1693	region1693	city1693	street1693	263
1694	region1694	city1694	street1694	260
1695	region1695	city1695	street1695	384
1696	region1696	city1696	street1696	184
1697	region1697	city1697	street1697	255
1698	region1698	city1698	street1698	281
1699	region1699	city1699	street1699	342
1700	region1700	city1700	street1700	387
1701	region1701	city1701	street1701	187
1702	region1702	city1702	street1702	149
1703	region1703	city1703	street1703	247
1704	region1704	city1704	street1704	185
1705	region1705	city1705	street1705	254
1706	region1706	city1706	street1706	267
1707	region1707	city1707	street1707	309
1708	region1708	city1708	street1708	11
1709	region1709	city1709	street1709	195
1710	region1710	city1710	street1710	292
1711	region1711	city1711	street1711	381
1712	region1712	city1712	street1712	246
1713	region1713	city1713	street1713	119
1714	region1714	city1714	street1714	223
1715	region1715	city1715	street1715	329
1716	region1716	city1716	street1716	276
1717	region1717	city1717	street1717	34
1718	region1718	city1718	street1718	109
1719	region1719	city1719	street1719	0
1720	region1720	city1720	street1720	287
1721	region1721	city1721	street1721	394
1722	region1722	city1722	street1722	251
1723	region1723	city1723	street1723	170
1724	region1724	city1724	street1724	249
1725	region1725	city1725	street1725	232
1726	region1726	city1726	street1726	397
1727	region1727	city1727	street1727	209
1728	region1728	city1728	street1728	86
1729	region1729	city1729	street1729	328
1730	region1730	city1730	street1730	396
1731	region1731	city1731	street1731	299
1732	region1732	city1732	street1732	350
1733	region1733	city1733	street1733	18
1734	region1734	city1734	street1734	73
1735	region1735	city1735	street1735	304
1736	region1736	city1736	street1736	379
1737	region1737	city1737	street1737	381
1738	region1738	city1738	street1738	286
1739	region1739	city1739	street1739	58
1740	region1740	city1740	street1740	105
1741	region1741	city1741	street1741	270
1742	region1742	city1742	street1742	149
1743	region1743	city1743	street1743	331
1744	region1744	city1744	street1744	272
1745	region1745	city1745	street1745	82
1746	region1746	city1746	street1746	120
1747	region1747	city1747	street1747	113
1748	region1748	city1748	street1748	393
1749	region1749	city1749	street1749	201
1750	region1750	city1750	street1750	202
1751	region1751	city1751	street1751	177
1752	region1752	city1752	street1752	336
1753	region1753	city1753	street1753	143
1754	region1754	city1754	street1754	323
1755	region1755	city1755	street1755	145
1756	region1756	city1756	street1756	359
1757	region1757	city1757	street1757	108
1758	region1758	city1758	street1758	335
1759	region1759	city1759	street1759	81
1760	region1760	city1760	street1760	241
1761	region1761	city1761	street1761	388
1762	region1762	city1762	street1762	370
1763	region1763	city1763	street1763	237
1764	region1764	city1764	street1764	252
1765	region1765	city1765	street1765	38
1766	region1766	city1766	street1766	18
1767	region1767	city1767	street1767	313
1768	region1768	city1768	street1768	150
1769	region1769	city1769	street1769	247
1770	region1770	city1770	street1770	275
1771	region1771	city1771	street1771	28
1772	region1772	city1772	street1772	357
1773	region1773	city1773	street1773	304
1774	region1774	city1774	street1774	23
1775	region1775	city1775	street1775	230
1776	region1776	city1776	street1776	258
1777	region1777	city1777	street1777	114
1778	region1778	city1778	street1778	175
1779	region1779	city1779	street1779	193
1780	region1780	city1780	street1780	175
1781	region1781	city1781	street1781	86
1782	region1782	city1782	street1782	30
1783	region1783	city1783	street1783	387
1784	region1784	city1784	street1784	157
1785	region1785	city1785	street1785	195
1786	region1786	city1786	street1786	302
1787	region1787	city1787	street1787	291
1788	region1788	city1788	street1788	268
1789	region1789	city1789	street1789	101
1790	region1790	city1790	street1790	9
1791	region1791	city1791	street1791	74
1792	region1792	city1792	street1792	249
1793	region1793	city1793	street1793	307
1794	region1794	city1794	street1794	349
1795	region1795	city1795	street1795	117
1796	region1796	city1796	street1796	68
1797	region1797	city1797	street1797	22
1798	region1798	city1798	street1798	154
1799	region1799	city1799	street1799	368
1800	region1800	city1800	street1800	376
1801	region1801	city1801	street1801	34
1802	region1802	city1802	street1802	399
1803	region1803	city1803	street1803	183
1804	region1804	city1804	street1804	173
1805	region1805	city1805	street1805	313
1806	region1806	city1806	street1806	22
1807	region1807	city1807	street1807	51
1808	region1808	city1808	street1808	347
1809	region1809	city1809	street1809	272
1810	region1810	city1810	street1810	216
1811	region1811	city1811	street1811	301
1812	region1812	city1812	street1812	225
1813	region1813	city1813	street1813	84
1814	region1814	city1814	street1814	138
1815	region1815	city1815	street1815	141
1816	region1816	city1816	street1816	108
1817	region1817	city1817	street1817	12
1818	region1818	city1818	street1818	10
1819	region1819	city1819	street1819	347
1820	region1820	city1820	street1820	22
1821	region1821	city1821	street1821	337
1822	region1822	city1822	street1822	287
1823	region1823	city1823	street1823	254
1824	region1824	city1824	street1824	126
1825	region1825	city1825	street1825	217
1826	region1826	city1826	street1826	317
1827	region1827	city1827	street1827	52
1828	region1828	city1828	street1828	243
1829	region1829	city1829	street1829	381
1830	region1830	city1830	street1830	76
1831	region1831	city1831	street1831	217
1832	region1832	city1832	street1832	164
1833	region1833	city1833	street1833	334
1834	region1834	city1834	street1834	91
1835	region1835	city1835	street1835	392
1836	region1836	city1836	street1836	193
1837	region1837	city1837	street1837	175
1838	region1838	city1838	street1838	237
1839	region1839	city1839	street1839	70
1840	region1840	city1840	street1840	360
1841	region1841	city1841	street1841	166
1842	region1842	city1842	street1842	154
1843	region1843	city1843	street1843	162
1844	region1844	city1844	street1844	86
1845	region1845	city1845	street1845	170
1846	region1846	city1846	street1846	12
1847	region1847	city1847	street1847	25
1848	region1848	city1848	street1848	255
1849	region1849	city1849	street1849	381
1850	region1850	city1850	street1850	128
1851	region1851	city1851	street1851	45
1852	region1852	city1852	street1852	86
1853	region1853	city1853	street1853	41
1854	region1854	city1854	street1854	387
1855	region1855	city1855	street1855	269
1856	region1856	city1856	street1856	92
1857	region1857	city1857	street1857	137
1858	region1858	city1858	street1858	144
1859	region1859	city1859	street1859	142
1860	region1860	city1860	street1860	191
1861	region1861	city1861	street1861	153
1862	region1862	city1862	street1862	126
1863	region1863	city1863	street1863	372
1864	region1864	city1864	street1864	144
1865	region1865	city1865	street1865	33
1866	region1866	city1866	street1866	345
1867	region1867	city1867	street1867	278
1868	region1868	city1868	street1868	280
1869	region1869	city1869	street1869	222
1870	region1870	city1870	street1870	326
1871	region1871	city1871	street1871	207
1872	region1872	city1872	street1872	245
1873	region1873	city1873	street1873	300
1874	region1874	city1874	street1874	263
1875	region1875	city1875	street1875	273
1876	region1876	city1876	street1876	389
1877	region1877	city1877	street1877	111
1878	region1878	city1878	street1878	296
1879	region1879	city1879	street1879	367
1880	region1880	city1880	street1880	61
1881	region1881	city1881	street1881	244
1882	region1882	city1882	street1882	225
1883	region1883	city1883	street1883	137
1884	region1884	city1884	street1884	295
1885	region1885	city1885	street1885	385
1886	region1886	city1886	street1886	280
1887	region1887	city1887	street1887	66
1888	region1888	city1888	street1888	351
1889	region1889	city1889	street1889	293
1890	region1890	city1890	street1890	336
1891	region1891	city1891	street1891	263
1892	region1892	city1892	street1892	332
1893	region1893	city1893	street1893	293
1894	region1894	city1894	street1894	342
1895	region1895	city1895	street1895	386
1896	region1896	city1896	street1896	5
1897	region1897	city1897	street1897	139
1898	region1898	city1898	street1898	144
1899	region1899	city1899	street1899	277
1900	region1900	city1900	street1900	82
1901	region1901	city1901	street1901	391
1902	region1902	city1902	street1902	176
1903	region1903	city1903	street1903	172
1904	region1904	city1904	street1904	241
1905	region1905	city1905	street1905	221
1906	region1906	city1906	street1906	259
1907	region1907	city1907	street1907	344
1908	region1908	city1908	street1908	208
1909	region1909	city1909	street1909	299
1910	region1910	city1910	street1910	329
1911	region1911	city1911	street1911	381
1912	region1912	city1912	street1912	21
1913	region1913	city1913	street1913	361
1914	region1914	city1914	street1914	260
1915	region1915	city1915	street1915	328
1916	region1916	city1916	street1916	280
1917	region1917	city1917	street1917	3
1918	region1918	city1918	street1918	269
1919	region1919	city1919	street1919	338
1920	region1920	city1920	street1920	270
1921	region1921	city1921	street1921	329
1922	region1922	city1922	street1922	105
1923	region1923	city1923	street1923	2
1924	region1924	city1924	street1924	227
1925	region1925	city1925	street1925	82
1926	region1926	city1926	street1926	43
1927	region1927	city1927	street1927	111
1928	region1928	city1928	street1928	78
1929	region1929	city1929	street1929	140
1930	region1930	city1930	street1930	65
1931	region1931	city1931	street1931	93
1932	region1932	city1932	street1932	369
1933	region1933	city1933	street1933	153
1934	region1934	city1934	street1934	259
1935	region1935	city1935	street1935	257
1936	region1936	city1936	street1936	120
1937	region1937	city1937	street1937	44
1938	region1938	city1938	street1938	199
1939	region1939	city1939	street1939	383
1940	region1940	city1940	street1940	247
1941	region1941	city1941	street1941	187
1942	region1942	city1942	street1942	23
1943	region1943	city1943	street1943	389
1944	region1944	city1944	street1944	242
1945	region1945	city1945	street1945	21
1946	region1946	city1946	street1946	124
1947	region1947	city1947	street1947	307
1948	region1948	city1948	street1948	357
1949	region1949	city1949	street1949	164
1950	region1950	city1950	street1950	360
1951	region1951	city1951	street1951	97
1952	region1952	city1952	street1952	349
1953	region1953	city1953	street1953	5
1954	region1954	city1954	street1954	133
1955	region1955	city1955	street1955	147
1956	region1956	city1956	street1956	254
1957	region1957	city1957	street1957	58
1958	region1958	city1958	street1958	247
1959	region1959	city1959	street1959	135
1960	region1960	city1960	street1960	363
1961	region1961	city1961	street1961	310
1962	region1962	city1962	street1962	25
1963	region1963	city1963	street1963	356
1964	region1964	city1964	street1964	131
1965	region1965	city1965	street1965	184
1966	region1966	city1966	street1966	257
1967	region1967	city1967	street1967	138
1968	region1968	city1968	street1968	137
1969	region1969	city1969	street1969	368
1970	region1970	city1970	street1970	175
1971	region1971	city1971	street1971	238
1972	region1972	city1972	street1972	40
1973	region1973	city1973	street1973	147
1974	region1974	city1974	street1974	274
1975	region1975	city1975	street1975	120
1976	region1976	city1976	street1976	170
1977	region1977	city1977	street1977	189
1978	region1978	city1978	street1978	251
1979	region1979	city1979	street1979	82
1980	region1980	city1980	street1980	296
1981	region1981	city1981	street1981	217
1982	region1982	city1982	street1982	0
1983	region1983	city1983	street1983	370
1984	region1984	city1984	street1984	392
1985	region1985	city1985	street1985	387
1986	region1986	city1986	street1986	260
1987	region1987	city1987	street1987	326
1988	region1988	city1988	street1988	194
1989	region1989	city1989	street1989	43
1990	region1990	city1990	street1990	322
1991	region1991	city1991	street1991	392
1992	region1992	city1992	street1992	2
1993	region1993	city1993	street1993	148
1994	region1994	city1994	street1994	201
1995	region1995	city1995	street1995	81
1996	region1996	city1996	street1996	57
1997	region1997	city1997	street1997	25
1998	region1998	city1998	street1998	179
1999	region1999	city1999	street1999	319
2000	region2000	city2000	street2000	270
\.


--
-- Data for Name: branches; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.branches (branch_id, branch_name, branch_tel, adress_id) FROM stdin;
1	b_name1	380247817608	371
2	b_name2	380894876108	705
3	b_name3	380351113855	1986
4	b_name4	380624024157	1791
5	b_name5	380214595097	998
6	b_name6	380710271570	897
7	b_name7	380358173108	1401
8	b_name8	380963314336	303
9	b_name9	380336819587	1665
10	b_name10	380960387725	253
11	b_name11	38049735431	1352
12	b_name12	380912785610	1885
13	b_name13	380328598569	863
14	b_name14	380911050432	584
15	b_name15	380346674553	269
16	b_name16	380693246610	1486
17	b_name17	380657420664	345
18	b_name18	380194730530	1575
19	b_name19	380668787653	463
20	b_name20	38056184535	152
21	b_name21	380646135078	423
22	b_name22	380502311691	320
23	b_name23	380932585108	1065
24	b_name24	380524194599	194
25	b_name25	380720813083	1368
26	b_name26	38066731794	1624
27	b_name27	380313090679	1229
28	b_name28	38046938436	1823
29	b_name29	380148201713	1043
30	b_name30	38011077451	730
31	b_name31	38042601593	1495
32	b_name32	38090128787	1347
33	b_name33	380775032248	1295
34	b_name34	380439760655	1333
35	b_name35	380807691884	133
36	b_name36	380687660580	1868
37	b_name37	380103868100	14
38	b_name38	380420651672	501
39	b_name39	380195699766	120
40	b_name40	380674252967	720
41	b_name41	380290882432	1371
42	b_name42	380212116037	76
43	b_name43	380571997326	1134
44	b_name44	380534278175	1636
45	b_name45	380494984316	508
46	b_name46	380283563739	1090
47	b_name47	380193600052	543
48	b_name48	380111401544	153
49	b_name49	380250727505	501
50	b_name50	380741248076	324
\.


--
-- Data for Name: cars; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.cars (cars_id, branch_id, model_id, cars_number) FROM stdin;
1	1	230	car_number1
2	7	482	car_number2
3	48	61	car_number3
4	17	289	car_number4
5	44	215	car_number5
6	6	310	car_number6
7	1	253	car_number7
8	16	436	car_number8
9	46	212	car_number9
10	6	332	car_number10
11	5	328	car_number11
12	38	417	car_number12
13	19	177	car_number13
14	45	316	car_number14
15	10	129	car_number15
16	4	341	car_number16
17	33	258	car_number17
18	25	92	car_number18
19	20	86	car_number19
20	16	377	car_number20
21	38	492	car_number21
22	47	152	car_number22
23	24	174	car_number23
24	25	75	car_number24
25	30	342	car_number25
26	38	409	car_number26
27	47	409	car_number27
28	42	203	car_number28
29	5	193	car_number29
30	13	314	car_number30
31	8	18	car_number31
32	7	459	car_number32
33	2	112	car_number33
34	38	173	car_number34
35	3	76	car_number35
36	30	187	car_number36
37	14	481	car_number37
38	31	113	car_number38
39	19	52	car_number39
40	23	267	car_number40
41	30	428	car_number41
42	36	451	car_number42
43	1	139	car_number43
44	41	222	car_number44
45	13	287	car_number45
46	38	151	car_number46
47	19	277	car_number47
48	29	483	car_number48
49	22	404	car_number49
50	18	463	car_number50
51	25	333	car_number51
52	5	234	car_number52
53	30	215	car_number53
54	40	500	car_number54
55	24	172	car_number55
56	42	351	car_number56
57	3	493	car_number57
58	22	130	car_number58
59	24	360	car_number59
60	21	298	car_number60
61	31	183	car_number61
62	27	97	car_number62
63	2	43	car_number63
64	41	7	car_number64
65	32	210	car_number65
66	29	435	car_number66
67	15	500	car_number67
68	35	111	car_number68
69	43	221	car_number69
70	50	431	car_number70
71	45	118	car_number71
72	10	500	car_number72
73	49	266	car_number73
74	19	316	car_number74
75	40	473	car_number75
76	1	287	car_number76
77	44	341	car_number77
78	31	203	car_number78
79	39	364	car_number79
80	34	313	car_number80
81	35	395	car_number81
82	4	16	car_number82
83	30	397	car_number83
84	49	262	car_number84
85	44	96	car_number85
86	47	378	car_number86
87	18	193	car_number87
88	2	66	car_number88
89	7	322	car_number89
90	12	366	car_number90
91	14	284	car_number91
92	20	256	car_number92
93	29	169	car_number93
94	12	203	car_number94
95	6	55	car_number95
96	34	48	car_number96
97	3	352	car_number97
98	32	311	car_number98
99	33	246	car_number99
100	30	10	car_number100
101	11	325	car_number101
102	19	43	car_number102
103	11	416	car_number103
104	17	156	car_number104
105	32	208	car_number105
106	23	422	car_number106
107	11	241	car_number107
108	42	271	car_number108
109	23	144	car_number109
110	31	286	car_number110
111	18	490	car_number111
112	17	355	car_number112
113	5	44	car_number113
114	50	346	car_number114
115	17	3	car_number115
116	11	38	car_number116
117	23	77	car_number117
118	11	270	car_number118
119	19	264	car_number119
120	32	63	car_number120
121	37	15	car_number121
122	1	9	car_number122
123	40	320	car_number123
124	10	189	car_number124
125	48	379	car_number125
126	29	248	car_number126
127	14	43	car_number127
128	2	366	car_number128
129	32	299	car_number129
130	7	161	car_number130
131	15	264	car_number131
132	21	99	car_number132
133	8	433	car_number133
134	14	333	car_number134
135	3	302	car_number135
136	24	182	car_number136
137	19	182	car_number137
138	27	68	car_number138
139	37	115	car_number139
140	45	146	car_number140
141	37	312	car_number141
142	48	70	car_number142
143	10	26	car_number143
144	1	156	car_number144
145	11	49	car_number145
146	23	148	car_number146
147	9	317	car_number147
148	6	291	car_number148
149	18	51	car_number149
150	48	408	car_number150
151	28	452	car_number151
152	16	290	car_number152
153	22	160	car_number153
154	37	154	car_number154
155	15	23	car_number155
156	8	338	car_number156
157	34	96	car_number157
158	17	187	car_number158
159	13	42	car_number159
160	29	209	car_number160
161	7	322	car_number161
162	26	221	car_number162
163	45	281	car_number163
164	25	300	car_number164
165	10	207	car_number165
166	1	307	car_number166
167	47	38	car_number167
168	10	491	car_number168
169	2	130	car_number169
170	1	37	car_number170
171	24	422	car_number171
172	7	475	car_number172
173	27	383	car_number173
174	29	447	car_number174
175	1	207	car_number175
176	42	427	car_number176
177	39	134	car_number177
178	1	385	car_number178
179	30	205	car_number179
180	17	416	car_number180
181	43	340	car_number181
182	23	160	car_number182
183	40	188	car_number183
184	39	205	car_number184
185	5	198	car_number185
186	12	350	car_number186
187	11	100	car_number187
188	35	431	car_number188
189	18	309	car_number189
190	16	172	car_number190
191	9	112	car_number191
192	13	7	car_number192
193	20	110	car_number193
194	19	463	car_number194
195	31	455	car_number195
196	44	11	car_number196
197	50	163	car_number197
198	7	233	car_number198
199	32	178	car_number199
200	32	254	car_number200
201	39	201	car_number201
202	19	394	car_number202
203	16	97	car_number203
204	31	102	car_number204
205	30	204	car_number205
206	25	267	car_number206
207	49	398	car_number207
208	12	483	car_number208
209	29	380	car_number209
210	28	319	car_number210
211	18	332	car_number211
212	1	383	car_number212
213	3	123	car_number213
214	22	184	car_number214
215	33	91	car_number215
216	43	343	car_number216
217	9	224	car_number217
218	9	129	car_number218
219	41	109	car_number219
220	22	290	car_number220
221	45	406	car_number221
222	25	275	car_number222
223	19	427	car_number223
224	36	171	car_number224
225	18	379	car_number225
226	38	441	car_number226
227	22	366	car_number227
228	17	418	car_number228
229	46	87	car_number229
230	35	291	car_number230
231	24	271	car_number231
232	9	188	car_number232
233	26	466	car_number233
234	11	190	car_number234
235	41	284	car_number235
236	20	316	car_number236
237	14	105	car_number237
238	40	174	car_number238
239	8	461	car_number239
240	21	388	car_number240
241	15	201	car_number241
242	49	280	car_number242
243	21	13	car_number243
244	31	192	car_number244
245	11	52	car_number245
246	11	360	car_number246
247	3	132	car_number247
248	10	146	car_number248
249	50	29	car_number249
250	9	456	car_number250
251	38	308	car_number251
252	24	459	car_number252
253	21	166	car_number253
254	41	422	car_number254
255	50	416	car_number255
256	35	265	car_number256
257	5	205	car_number257
258	48	75	car_number258
259	20	6	car_number259
260	37	400	car_number260
261	37	126	car_number261
262	33	171	car_number262
263	11	112	car_number263
264	7	203	car_number264
265	47	279	car_number265
266	10	257	car_number266
267	13	54	car_number267
268	30	89	car_number268
269	37	334	car_number269
270	23	489	car_number270
271	6	438	car_number271
272	34	461	car_number272
273	47	27	car_number273
274	14	350	car_number274
275	19	441	car_number275
276	19	109	car_number276
277	22	277	car_number277
278	18	152	car_number278
279	43	497	car_number279
280	41	472	car_number280
281	12	178	car_number281
282	27	221	car_number282
283	9	498	car_number283
284	7	101	car_number284
285	10	347	car_number285
286	44	291	car_number286
287	49	416	car_number287
288	3	94	car_number288
289	49	424	car_number289
290	35	339	car_number290
291	40	57	car_number291
292	37	165	car_number292
293	5	463	car_number293
294	20	472	car_number294
295	10	3	car_number295
296	9	234	car_number296
297	22	383	car_number297
298	26	234	car_number298
299	11	205	car_number299
300	34	232	car_number300
301	8	465	car_number301
302	29	348	car_number302
303	4	110	car_number303
304	35	426	car_number304
305	43	335	car_number305
306	32	112	car_number306
307	41	155	car_number307
308	27	371	car_number308
309	39	479	car_number309
310	36	390	car_number310
311	44	13	car_number311
312	26	398	car_number312
313	24	437	car_number313
314	31	205	car_number314
315	28	262	car_number315
316	32	239	car_number316
317	44	187	car_number317
318	50	437	car_number318
319	27	356	car_number319
320	20	456	car_number320
321	22	246	car_number321
322	33	422	car_number322
323	21	298	car_number323
324	13	282	car_number324
325	4	175	car_number325
326	21	195	car_number326
327	13	114	car_number327
328	47	130	car_number328
329	20	422	car_number329
330	6	466	car_number330
331	33	74	car_number331
332	1	243	car_number332
333	7	195	car_number333
334	27	107	car_number334
335	9	48	car_number335
336	1	143	car_number336
337	40	462	car_number337
338	14	189	car_number338
339	20	269	car_number339
340	19	63	car_number340
341	28	450	car_number341
342	26	325	car_number342
343	22	480	car_number343
344	27	222	car_number344
345	16	441	car_number345
346	19	339	car_number346
347	3	374	car_number347
348	26	471	car_number348
349	42	176	car_number349
350	7	272	car_number350
351	27	198	car_number351
352	39	149	car_number352
353	31	89	car_number353
354	47	261	car_number354
355	36	488	car_number355
356	25	374	car_number356
357	45	488	car_number357
358	47	329	car_number358
359	38	417	car_number359
360	32	421	car_number360
361	37	368	car_number361
362	32	233	car_number362
363	35	446	car_number363
364	34	454	car_number364
365	36	268	car_number365
366	12	161	car_number366
367	13	379	car_number367
368	9	56	car_number368
369	5	363	car_number369
370	21	187	car_number370
371	32	165	car_number371
372	46	218	car_number372
373	19	348	car_number373
374	30	134	car_number374
375	1	42	car_number375
376	38	144	car_number376
377	14	352	car_number377
378	18	32	car_number378
379	44	166	car_number379
380	20	439	car_number380
381	7	62	car_number381
382	21	99	car_number382
383	35	443	car_number383
384	43	315	car_number384
385	7	348	car_number385
386	15	171	car_number386
387	48	337	car_number387
388	12	113	car_number388
389	11	211	car_number389
390	10	155	car_number390
391	8	304	car_number391
392	42	101	car_number392
393	2	315	car_number393
394	41	43	car_number394
395	23	42	car_number395
396	38	88	car_number396
397	39	5	car_number397
398	2	219	car_number398
399	31	243	car_number399
400	11	494	car_number400
401	44	31	car_number401
402	29	278	car_number402
403	24	446	car_number403
404	25	454	car_number404
405	33	377	car_number405
406	43	242	car_number406
407	36	481	car_number407
408	46	316	car_number408
409	16	323	car_number409
410	31	266	car_number410
411	1	179	car_number411
412	50	73	car_number412
413	28	45	car_number413
414	17	59	car_number414
415	48	272	car_number415
416	23	42	car_number416
417	38	323	car_number417
418	31	141	car_number418
419	36	166	car_number419
420	20	405	car_number420
421	46	369	car_number421
422	28	269	car_number422
423	28	121	car_number423
424	10	205	car_number424
425	44	375	car_number425
426	23	488	car_number426
427	1	96	car_number427
428	13	260	car_number428
429	31	151	car_number429
430	27	348	car_number430
431	22	447	car_number431
432	37	256	car_number432
433	45	437	car_number433
434	31	158	car_number434
435	34	130	car_number435
436	26	352	car_number436
437	35	457	car_number437
438	39	342	car_number438
439	22	367	car_number439
440	27	152	car_number440
441	19	409	car_number441
442	9	481	car_number442
443	31	82	car_number443
444	45	197	car_number444
445	49	276	car_number445
446	38	109	car_number446
447	43	336	car_number447
448	27	326	car_number448
449	7	136	car_number449
450	38	152	car_number450
451	15	220	car_number451
452	24	260	car_number452
453	17	296	car_number453
454	28	222	car_number454
455	5	155	car_number455
456	37	232	car_number456
457	21	484	car_number457
458	50	313	car_number458
459	13	204	car_number459
460	34	184	car_number460
461	42	399	car_number461
462	13	292	car_number462
463	42	498	car_number463
464	35	210	car_number464
465	11	207	car_number465
466	45	337	car_number466
467	38	250	car_number467
468	17	440	car_number468
469	25	321	car_number469
470	18	396	car_number470
471	19	314	car_number471
472	22	210	car_number472
473	13	224	car_number473
474	30	485	car_number474
475	47	493	car_number475
476	26	291	car_number476
477	5	73	car_number477
478	40	468	car_number478
479	12	46	car_number479
480	34	469	car_number480
481	33	340	car_number481
482	11	97	car_number482
483	12	488	car_number483
484	10	304	car_number484
485	50	392	car_number485
486	18	173	car_number486
487	7	171	car_number487
488	3	383	car_number488
489	40	214	car_number489
490	21	170	car_number490
491	45	481	car_number491
492	7	304	car_number492
493	8	26	car_number493
494	26	288	car_number494
495	3	95	car_number495
496	33	341	car_number496
497	41	118	car_number497
498	10	461	car_number498
499	28	491	car_number499
500	47	303	car_number500
501	18	460	car_number501
502	23	162	car_number502
503	20	9	car_number503
504	13	254	car_number504
505	34	22	car_number505
506	1	310	car_number506
507	44	201	car_number507
508	49	18	car_number508
509	10	289	car_number509
510	34	160	car_number510
511	50	480	car_number511
512	28	67	car_number512
513	32	397	car_number513
514	33	196	car_number514
515	11	288	car_number515
516	19	184	car_number516
517	5	163	car_number517
518	13	307	car_number518
519	34	262	car_number519
520	38	391	car_number520
521	32	287	car_number521
522	43	224	car_number522
523	15	196	car_number523
524	1	60	car_number524
525	6	331	car_number525
526	2	272	car_number526
527	18	462	car_number527
528	43	362	car_number528
529	7	277	car_number529
530	6	328	car_number530
531	49	168	car_number531
532	2	361	car_number532
533	31	311	car_number533
534	2	211	car_number534
535	46	216	car_number535
536	11	310	car_number536
537	18	393	car_number537
538	30	107	car_number538
539	31	320	car_number539
540	45	11	car_number540
541	13	48	car_number541
542	29	252	car_number542
543	11	447	car_number543
544	6	174	car_number544
545	27	417	car_number545
546	17	408	car_number546
547	19	494	car_number547
548	8	325	car_number548
549	44	268	car_number549
550	14	403	car_number550
551	46	304	car_number551
552	45	440	car_number552
553	5	257	car_number553
554	9	482	car_number554
555	30	120	car_number555
556	14	379	car_number556
557	5	128	car_number557
558	27	125	car_number558
559	7	428	car_number559
560	33	6	car_number560
561	38	172	car_number561
562	27	402	car_number562
563	2	202	car_number563
564	6	332	car_number564
565	7	392	car_number565
566	11	289	car_number566
567	39	338	car_number567
568	48	196	car_number568
569	22	302	car_number569
570	42	164	car_number570
571	45	272	car_number571
572	43	300	car_number572
573	46	79	car_number573
574	2	62	car_number574
575	22	477	car_number575
576	23	200	car_number576
577	3	150	car_number577
578	29	78	car_number578
579	39	253	car_number579
580	49	57	car_number580
581	14	271	car_number581
582	46	100	car_number582
583	38	356	car_number583
584	1	82	car_number584
585	1	273	car_number585
586	39	321	car_number586
587	29	262	car_number587
588	45	491	car_number588
589	48	64	car_number589
590	5	254	car_number590
591	22	325	car_number591
592	46	11	car_number592
593	38	330	car_number593
594	5	482	car_number594
595	20	343	car_number595
596	8	471	car_number596
597	2	273	car_number597
598	46	313	car_number598
599	40	9	car_number599
600	43	336	car_number600
601	38	23	car_number601
602	48	264	car_number602
603	25	472	car_number603
604	19	280	car_number604
605	50	468	car_number605
606	27	420	car_number606
607	42	115	car_number607
608	36	405	car_number608
609	8	47	car_number609
610	47	494	car_number610
611	37	109	car_number611
612	46	105	car_number612
613	6	401	car_number613
614	5	487	car_number614
615	8	226	car_number615
616	4	302	car_number616
617	39	269	car_number617
618	26	214	car_number618
619	42	92	car_number619
620	31	343	car_number620
621	18	117	car_number621
622	2	284	car_number622
623	4	352	car_number623
624	42	249	car_number624
625	1	158	car_number625
626	5	443	car_number626
627	39	315	car_number627
628	44	284	car_number628
629	17	318	car_number629
630	27	43	car_number630
631	36	226	car_number631
632	4	173	car_number632
633	45	208	car_number633
634	35	92	car_number634
635	19	171	car_number635
636	29	280	car_number636
637	39	197	car_number637
638	25	430	car_number638
639	16	109	car_number639
640	28	238	car_number640
641	12	279	car_number641
642	40	469	car_number642
643	10	413	car_number643
644	24	123	car_number644
645	46	263	car_number645
646	43	87	car_number646
647	48	404	car_number647
648	36	131	car_number648
649	43	93	car_number649
650	11	141	car_number650
651	3	400	car_number651
652	17	134	car_number652
653	43	471	car_number653
654	28	167	car_number654
655	39	9	car_number655
656	11	56	car_number656
657	37	75	car_number657
658	39	61	car_number658
659	40	50	car_number659
660	31	262	car_number660
661	11	163	car_number661
662	21	240	car_number662
663	15	494	car_number663
664	15	318	car_number664
665	16	432	car_number665
666	15	100	car_number666
667	30	105	car_number667
668	9	143	car_number668
669	29	187	car_number669
670	16	135	car_number670
671	9	500	car_number671
672	9	380	car_number672
673	20	73	car_number673
674	48	403	car_number674
675	2	369	car_number675
676	40	139	car_number676
677	24	391	car_number677
678	48	200	car_number678
679	21	427	car_number679
680	28	168	car_number680
681	44	387	car_number681
682	2	151	car_number682
683	30	303	car_number683
684	26	6	car_number684
685	48	377	car_number685
686	28	248	car_number686
687	10	483	car_number687
688	5	10	car_number688
689	4	317	car_number689
690	43	207	car_number690
691	23	253	car_number691
692	24	474	car_number692
693	7	239	car_number693
694	18	164	car_number694
695	14	305	car_number695
696	8	344	car_number696
697	19	409	car_number697
698	14	7	car_number698
699	5	215	car_number699
700	26	183	car_number700
701	21	457	car_number701
702	43	345	car_number702
703	31	343	car_number703
704	48	362	car_number704
705	49	28	car_number705
706	47	351	car_number706
707	45	238	car_number707
708	22	331	car_number708
709	32	112	car_number709
710	16	129	car_number710
711	32	252	car_number711
712	17	291	car_number712
713	50	349	car_number713
714	26	232	car_number714
715	12	259	car_number715
716	14	104	car_number716
717	39	23	car_number717
718	24	176	car_number718
719	18	308	car_number719
720	45	433	car_number720
721	31	25	car_number721
722	26	89	car_number722
723	20	58	car_number723
724	37	197	car_number724
725	50	159	car_number725
726	13	114	car_number726
727	24	470	car_number727
728	42	290	car_number728
729	5	461	car_number729
730	44	388	car_number730
731	50	349	car_number731
732	48	491	car_number732
733	32	390	car_number733
734	15	91	car_number734
735	22	447	car_number735
736	34	2	car_number736
737	38	213	car_number737
738	11	194	car_number738
739	11	321	car_number739
740	21	90	car_number740
741	40	317	car_number741
742	6	368	car_number742
743	35	268	car_number743
744	47	408	car_number744
745	45	350	car_number745
746	20	148	car_number746
747	3	51	car_number747
748	2	185	car_number748
749	6	285	car_number749
750	49	58	car_number750
751	26	344	car_number751
752	45	104	car_number752
753	28	94	car_number753
754	47	445	car_number754
755	39	219	car_number755
756	32	488	car_number756
757	30	107	car_number757
758	4	426	car_number758
759	36	341	car_number759
760	1	290	car_number760
761	25	391	car_number761
762	35	420	car_number762
763	18	269	car_number763
764	50	233	car_number764
765	10	16	car_number765
766	49	80	car_number766
767	32	52	car_number767
768	50	97	car_number768
769	12	289	car_number769
770	39	55	car_number770
771	17	363	car_number771
772	19	386	car_number772
773	2	244	car_number773
774	23	317	car_number774
775	21	436	car_number775
776	8	109	car_number776
777	38	319	car_number777
778	48	391	car_number778
779	30	66	car_number779
780	1	103	car_number780
781	27	255	car_number781
782	46	146	car_number782
783	10	235	car_number783
784	8	300	car_number784
785	43	404	car_number785
786	26	329	car_number786
787	48	450	car_number787
788	40	293	car_number788
789	25	424	car_number789
790	18	65	car_number790
791	37	74	car_number791
792	47	406	car_number792
793	8	42	car_number793
794	7	152	car_number794
795	20	105	car_number795
796	47	328	car_number796
797	38	91	car_number797
798	16	105	car_number798
799	24	196	car_number799
800	25	237	car_number800
801	2	253	car_number801
802	31	436	car_number802
803	14	496	car_number803
804	48	85	car_number804
805	29	426	car_number805
806	43	12	car_number806
807	20	395	car_number807
808	46	347	car_number808
809	45	348	car_number809
810	23	372	car_number810
811	17	444	car_number811
812	49	278	car_number812
813	22	81	car_number813
814	29	253	car_number814
815	45	444	car_number815
816	40	389	car_number816
817	41	455	car_number817
818	6	234	car_number818
819	39	407	car_number819
820	3	393	car_number820
821	8	334	car_number821
822	15	476	car_number822
823	25	194	car_number823
824	22	79	car_number824
825	26	146	car_number825
826	15	391	car_number826
827	13	202	car_number827
828	35	50	car_number828
829	46	100	car_number829
830	38	378	car_number830
831	26	304	car_number831
832	1	209	car_number832
833	11	496	car_number833
834	11	387	car_number834
835	38	296	car_number835
836	33	130	car_number836
837	32	423	car_number837
838	24	59	car_number838
839	26	383	car_number839
840	12	348	car_number840
841	41	180	car_number841
842	17	431	car_number842
843	11	461	car_number843
844	22	432	car_number844
845	34	364	car_number845
846	23	351	car_number846
847	18	202	car_number847
848	8	411	car_number848
849	1	383	car_number849
850	44	152	car_number850
851	1	260	car_number851
852	22	379	car_number852
853	27	392	car_number853
854	45	134	car_number854
855	2	74	car_number855
856	21	459	car_number856
857	43	99	car_number857
858	17	52	car_number858
859	49	358	car_number859
860	46	115	car_number860
861	2	300	car_number861
862	49	227	car_number862
863	28	331	car_number863
864	10	22	car_number864
865	9	213	car_number865
866	6	73	car_number866
867	24	184	car_number867
868	2	250	car_number868
869	48	340	car_number869
870	47	7	car_number870
871	16	129	car_number871
872	5	7	car_number872
873	37	147	car_number873
874	39	124	car_number874
875	40	146	car_number875
876	50	10	car_number876
877	35	30	car_number877
878	17	242	car_number878
879	37	498	car_number879
880	33	31	car_number880
881	25	464	car_number881
882	28	217	car_number882
883	49	414	car_number883
884	3	277	car_number884
885	28	143	car_number885
886	27	348	car_number886
887	48	215	car_number887
888	43	89	car_number888
889	3	198	car_number889
890	10	296	car_number890
891	44	434	car_number891
892	17	123	car_number892
893	16	181	car_number893
894	15	143	car_number894
895	19	369	car_number895
896	35	191	car_number896
897	36	287	car_number897
898	44	297	car_number898
899	47	117	car_number899
900	41	455	car_number900
901	19	149	car_number901
902	20	421	car_number902
903	1	420	car_number903
904	41	95	car_number904
905	36	62	car_number905
906	30	174	car_number906
907	48	205	car_number907
908	19	479	car_number908
909	12	273	car_number909
910	37	318	car_number910
911	29	180	car_number911
912	7	201	car_number912
913	39	140	car_number913
914	33	365	car_number914
915	4	358	car_number915
916	19	262	car_number916
917	26	341	car_number917
918	31	123	car_number918
919	2	172	car_number919
920	14	497	car_number920
921	7	430	car_number921
922	31	279	car_number922
923	34	141	car_number923
924	47	181	car_number924
925	45	323	car_number925
926	19	414	car_number926
927	43	199	car_number927
928	1	290	car_number928
929	47	227	car_number929
930	22	450	car_number930
931	46	347	car_number931
932	8	247	car_number932
933	2	339	car_number933
934	17	340	car_number934
935	49	154	car_number935
936	19	85	car_number936
937	32	23	car_number937
938	49	315	car_number938
939	1	191	car_number939
940	50	61	car_number940
941	14	243	car_number941
942	18	406	car_number942
943	34	26	car_number943
944	1	356	car_number944
945	3	214	car_number945
946	1	229	car_number946
947	15	330	car_number947
948	35	489	car_number948
949	13	58	car_number949
950	37	192	car_number950
951	10	330	car_number951
952	22	443	car_number952
953	25	209	car_number953
954	16	475	car_number954
955	28	55	car_number955
956	2	64	car_number956
957	15	181	car_number957
958	10	499	car_number958
959	18	282	car_number959
960	3	429	car_number960
961	47	113	car_number961
962	2	420	car_number962
963	43	103	car_number963
964	11	170	car_number964
965	30	157	car_number965
966	27	191	car_number966
967	21	482	car_number967
968	46	62	car_number968
969	45	135	car_number969
970	10	135	car_number970
971	13	254	car_number971
972	23	184	car_number972
973	37	61	car_number973
974	26	164	car_number974
975	26	134	car_number975
976	35	480	car_number976
977	46	64	car_number977
978	40	203	car_number978
979	43	113	car_number979
980	1	453	car_number980
981	39	31	car_number981
982	30	36	car_number982
983	2	161	car_number983
984	34	480	car_number984
985	6	350	car_number985
986	18	335	car_number986
987	41	384	car_number987
988	32	299	car_number988
989	40	11	car_number989
990	15	41	car_number990
991	18	453	car_number991
992	14	451	car_number992
993	6	195	car_number993
994	31	481	car_number994
995	47	317	car_number995
996	21	303	car_number996
997	5	157	car_number997
998	35	97	car_number998
999	31	243	car_number999
1000	29	325	car_number1000
1001	2	144	car_number1001
1002	14	474	car_number1002
1003	44	355	car_number1003
1004	40	82	car_number1004
1005	50	373	car_number1005
1006	32	404	car_number1006
1007	10	225	car_number1007
1008	14	72	car_number1008
1009	8	186	car_number1009
1010	49	167	car_number1010
1011	1	135	car_number1011
1012	45	426	car_number1012
1013	14	16	car_number1013
1014	6	191	car_number1014
1015	1	359	car_number1015
1016	39	319	car_number1016
1017	49	317	car_number1017
1018	25	434	car_number1018
1019	20	195	car_number1019
1020	24	331	car_number1020
1021	26	237	car_number1021
1022	47	200	car_number1022
1023	34	401	car_number1023
1024	33	64	car_number1024
1025	8	442	car_number1025
1026	22	271	car_number1026
1027	47	113	car_number1027
1028	50	157	car_number1028
1029	27	200	car_number1029
1030	7	477	car_number1030
1031	26	37	car_number1031
1032	41	279	car_number1032
1033	45	291	car_number1033
1034	32	156	car_number1034
1035	46	117	car_number1035
1036	31	157	car_number1036
1037	15	155	car_number1037
1038	1	375	car_number1038
1039	43	433	car_number1039
1040	8	446	car_number1040
1041	38	392	car_number1041
1042	18	404	car_number1042
1043	19	261	car_number1043
1044	25	454	car_number1044
1045	50	278	car_number1045
1046	23	357	car_number1046
1047	36	353	car_number1047
1048	23	34	car_number1048
1049	12	349	car_number1049
1050	4	457	car_number1050
1051	3	48	car_number1051
1052	34	325	car_number1052
1053	7	22	car_number1053
1054	22	176	car_number1054
1055	28	120	car_number1055
1056	31	302	car_number1056
1057	3	220	car_number1057
1058	6	454	car_number1058
1059	32	476	car_number1059
1060	23	94	car_number1060
1061	2	57	car_number1061
1062	50	378	car_number1062
1063	35	66	car_number1063
1064	20	40	car_number1064
1065	42	274	car_number1065
1066	25	216	car_number1066
1067	43	321	car_number1067
1068	45	428	car_number1068
1069	17	331	car_number1069
1070	41	263	car_number1070
1071	26	81	car_number1071
1072	36	177	car_number1072
1073	27	11	car_number1073
1074	18	155	car_number1074
1075	15	273	car_number1075
1076	27	237	car_number1076
1077	19	311	car_number1077
1078	12	119	car_number1078
1079	9	54	car_number1079
1080	24	255	car_number1080
1081	3	52	car_number1081
1082	32	241	car_number1082
1083	31	336	car_number1083
1084	4	321	car_number1084
1085	38	294	car_number1085
1086	41	337	car_number1086
1087	30	1	car_number1087
1088	11	466	car_number1088
1089	25	460	car_number1089
1090	43	87	car_number1090
1091	45	101	car_number1091
1092	36	473	car_number1092
1093	26	363	car_number1093
1094	4	433	car_number1094
1095	24	175	car_number1095
1096	23	318	car_number1096
1097	42	61	car_number1097
1098	18	182	car_number1098
1099	33	19	car_number1099
1100	10	411	car_number1100
1101	30	96	car_number1101
1102	17	299	car_number1102
1103	2	152	car_number1103
1104	19	426	car_number1104
1105	33	126	car_number1105
1106	2	433	car_number1106
1107	26	385	car_number1107
1108	12	287	car_number1108
1109	26	426	car_number1109
1110	2	400	car_number1110
1111	47	404	car_number1111
1112	25	6	car_number1112
1113	32	350	car_number1113
1114	31	74	car_number1114
1115	41	62	car_number1115
1116	4	38	car_number1116
1117	50	493	car_number1117
1118	43	159	car_number1118
1119	2	174	car_number1119
1120	26	472	car_number1120
1121	23	99	car_number1121
1122	20	273	car_number1122
1123	20	370	car_number1123
1124	1	343	car_number1124
1125	15	63	car_number1125
1126	5	161	car_number1126
1127	16	42	car_number1127
1128	12	208	car_number1128
1129	5	56	car_number1129
1130	19	460	car_number1130
1131	31	202	car_number1131
1132	27	410	car_number1132
1133	41	484	car_number1133
1134	4	444	car_number1134
1135	10	294	car_number1135
1136	46	276	car_number1136
1137	14	495	car_number1137
1138	28	500	car_number1138
1139	8	72	car_number1139
1140	35	349	car_number1140
1141	19	291	car_number1141
1142	24	489	car_number1142
1143	33	331	car_number1143
1144	20	348	car_number1144
1145	19	320	car_number1145
1146	41	468	car_number1146
1147	27	498	car_number1147
1148	37	479	car_number1148
1149	10	143	car_number1149
1150	47	362	car_number1150
1151	9	174	car_number1151
1152	5	395	car_number1152
1153	50	32	car_number1153
1154	19	350	car_number1154
1155	2	270	car_number1155
1156	32	284	car_number1156
1157	12	246	car_number1157
1158	3	135	car_number1158
1159	33	355	car_number1159
1160	24	439	car_number1160
1161	1	70	car_number1161
1162	3	172	car_number1162
1163	24	275	car_number1163
1164	48	255	car_number1164
1165	44	245	car_number1165
1166	45	319	car_number1166
1167	23	71	car_number1167
1168	43	23	car_number1168
1169	35	499	car_number1169
1170	20	421	car_number1170
1171	21	455	car_number1171
1172	5	208	car_number1172
1173	38	271	car_number1173
1174	22	138	car_number1174
1175	4	137	car_number1175
1176	11	443	car_number1176
1177	2	387	car_number1177
1178	23	134	car_number1178
1179	40	174	car_number1179
1180	49	21	car_number1180
1181	10	424	car_number1181
1182	23	144	car_number1182
1183	48	33	car_number1183
1184	47	185	car_number1184
1185	25	463	car_number1185
1186	10	368	car_number1186
1187	23	285	car_number1187
1188	31	401	car_number1188
1189	26	7	car_number1189
1190	30	59	car_number1190
1191	50	148	car_number1191
1192	23	144	car_number1192
1193	28	357	car_number1193
1194	24	132	car_number1194
1195	34	364	car_number1195
1196	30	306	car_number1196
1197	33	413	car_number1197
1198	37	377	car_number1198
1199	24	252	car_number1199
1200	6	142	car_number1200
1201	32	150	car_number1201
1202	37	276	car_number1202
1203	41	49	car_number1203
1204	25	333	car_number1204
1205	38	383	car_number1205
1206	2	193	car_number1206
1207	43	478	car_number1207
1208	6	487	car_number1208
1209	35	315	car_number1209
1210	33	304	car_number1210
1211	21	181	car_number1211
1212	46	122	car_number1212
1213	16	148	car_number1213
1214	3	204	car_number1214
1215	14	83	car_number1215
1216	38	157	car_number1216
1217	11	335	car_number1217
1218	14	170	car_number1218
1219	48	265	car_number1219
1220	50	387	car_number1220
1221	15	319	car_number1221
1222	11	308	car_number1222
1223	19	305	car_number1223
1224	9	458	car_number1224
1225	47	169	car_number1225
1226	25	193	car_number1226
1227	9	317	car_number1227
1228	13	306	car_number1228
1229	16	343	car_number1229
1230	49	61	car_number1230
1231	45	215	car_number1231
1232	39	272	car_number1232
1233	25	490	car_number1233
1234	17	55	car_number1234
1235	31	294	car_number1235
1236	37	368	car_number1236
1237	18	164	car_number1237
1238	25	279	car_number1238
1239	7	159	car_number1239
1240	37	323	car_number1240
1241	40	437	car_number1241
1242	43	60	car_number1242
1243	9	214	car_number1243
1244	19	330	car_number1244
1245	12	313	car_number1245
1246	15	272	car_number1246
1247	18	132	car_number1247
1248	5	184	car_number1248
1249	11	342	car_number1249
1250	20	316	car_number1250
1251	31	16	car_number1251
1252	1	259	car_number1252
1253	12	212	car_number1253
1254	24	214	car_number1254
1255	35	101	car_number1255
1256	33	350	car_number1256
1257	50	224	car_number1257
1258	32	335	car_number1258
1259	38	245	car_number1259
1260	29	247	car_number1260
1261	49	118	car_number1261
1262	31	445	car_number1262
1263	41	425	car_number1263
1264	45	89	car_number1264
1265	39	90	car_number1265
1266	19	425	car_number1266
1267	33	67	car_number1267
1268	23	437	car_number1268
1269	37	267	car_number1269
1270	48	302	car_number1270
1271	23	254	car_number1271
1272	20	237	car_number1272
1273	46	59	car_number1273
1274	38	79	car_number1274
1275	27	86	car_number1275
1276	24	163	car_number1276
1277	34	493	car_number1277
1278	40	124	car_number1278
1279	14	107	car_number1279
1280	43	71	car_number1280
1281	25	188	car_number1281
1282	12	394	car_number1282
1283	13	292	car_number1283
1284	23	191	car_number1284
1285	27	185	car_number1285
1286	46	331	car_number1286
1287	2	47	car_number1287
1288	26	251	car_number1288
1289	9	127	car_number1289
1290	25	89	car_number1290
1291	50	408	car_number1291
1292	38	38	car_number1292
1293	50	160	car_number1293
1294	32	408	car_number1294
1295	32	308	car_number1295
1296	50	397	car_number1296
1297	10	240	car_number1297
1298	2	394	car_number1298
1299	16	293	car_number1299
1300	5	423	car_number1300
1301	33	367	car_number1301
1302	31	388	car_number1302
1303	20	351	car_number1303
1304	17	208	car_number1304
1305	21	263	car_number1305
1306	21	356	car_number1306
1307	25	289	car_number1307
1308	14	415	car_number1308
1309	1	110	car_number1309
1310	18	372	car_number1310
1311	1	10	car_number1311
1312	50	235	car_number1312
1313	28	149	car_number1313
1314	30	202	car_number1314
1315	35	68	car_number1315
1316	48	77	car_number1316
1317	8	221	car_number1317
1318	16	478	car_number1318
1319	14	327	car_number1319
1320	30	249	car_number1320
1321	2	3	car_number1321
1322	38	265	car_number1322
1323	38	105	car_number1323
1324	5	220	car_number1324
1325	33	197	car_number1325
1326	48	222	car_number1326
1327	20	296	car_number1327
1328	49	242	car_number1328
1329	36	76	car_number1329
1330	10	293	car_number1330
1331	39	28	car_number1331
1332	41	106	car_number1332
1333	47	125	car_number1333
1334	7	149	car_number1334
1335	24	57	car_number1335
1336	16	94	car_number1336
1337	10	419	car_number1337
1338	27	404	car_number1338
1339	1	22	car_number1339
1340	35	250	car_number1340
1341	17	331	car_number1341
1342	11	229	car_number1342
1343	42	298	car_number1343
1344	35	318	car_number1344
1345	4	73	car_number1345
1346	12	352	car_number1346
1347	8	90	car_number1347
1348	37	212	car_number1348
1349	34	107	car_number1349
1350	48	27	car_number1350
1351	49	170	car_number1351
1352	12	78	car_number1352
1353	43	44	car_number1353
1354	2	104	car_number1354
1355	12	469	car_number1355
1356	8	250	car_number1356
1357	42	203	car_number1357
1358	32	410	car_number1358
1359	42	237	car_number1359
1360	2	73	car_number1360
1361	18	477	car_number1361
1362	18	57	car_number1362
1363	45	120	car_number1363
1364	40	156	car_number1364
1365	5	199	car_number1365
1366	27	328	car_number1366
1367	32	296	car_number1367
1368	5	297	car_number1368
1369	19	338	car_number1369
1370	36	284	car_number1370
1371	18	28	car_number1371
1372	14	14	car_number1372
1373	19	490	car_number1373
1374	43	356	car_number1374
1375	35	343	car_number1375
1376	26	386	car_number1376
1377	10	442	car_number1377
1378	20	299	car_number1378
1379	8	64	car_number1379
1380	10	316	car_number1380
1381	6	454	car_number1381
1382	5	336	car_number1382
1383	20	20	car_number1383
1384	45	174	car_number1384
1385	32	82	car_number1385
1386	49	268	car_number1386
1387	47	357	car_number1387
1388	27	108	car_number1388
1389	19	363	car_number1389
1390	22	155	car_number1390
1391	16	24	car_number1391
1392	19	483	car_number1392
1393	47	435	car_number1393
1394	17	407	car_number1394
1395	15	99	car_number1395
1396	19	113	car_number1396
1397	17	478	car_number1397
1398	32	306	car_number1398
1399	28	377	car_number1399
1400	22	305	car_number1400
1401	42	35	car_number1401
1402	43	461	car_number1402
1403	21	482	car_number1403
1404	6	301	car_number1404
1405	43	267	car_number1405
1406	31	207	car_number1406
1407	36	51	car_number1407
1408	22	357	car_number1408
1409	19	316	car_number1409
1410	36	213	car_number1410
1411	9	316	car_number1411
1412	44	486	car_number1412
1413	26	42	car_number1413
1414	17	67	car_number1414
1415	24	78	car_number1415
1416	48	34	car_number1416
1417	33	235	car_number1417
1418	40	478	car_number1418
1419	36	208	car_number1419
1420	24	109	car_number1420
1421	12	350	car_number1421
1422	36	235	car_number1422
1423	1	219	car_number1423
1424	22	211	car_number1424
1425	36	284	car_number1425
1426	8	246	car_number1426
1427	5	149	car_number1427
1428	24	362	car_number1428
1429	15	454	car_number1429
1430	5	475	car_number1430
1431	2	195	car_number1431
1432	16	72	car_number1432
1433	37	472	car_number1433
1434	36	228	car_number1434
1435	44	155	car_number1435
1436	45	332	car_number1436
1437	13	372	car_number1437
1438	37	472	car_number1438
1439	47	451	car_number1439
1440	22	359	car_number1440
1441	18	228	car_number1441
1442	25	409	car_number1442
1443	36	441	car_number1443
1444	1	269	car_number1444
1445	21	119	car_number1445
1446	24	256	car_number1446
1447	1	490	car_number1447
1448	45	485	car_number1448
1449	48	12	car_number1449
1450	21	229	car_number1450
1451	27	406	car_number1451
1452	46	214	car_number1452
1453	16	65	car_number1453
1454	33	342	car_number1454
1455	21	197	car_number1455
1456	25	30	car_number1456
1457	1	26	car_number1457
1458	2	59	car_number1458
1459	11	150	car_number1459
1460	1	112	car_number1460
1461	28	193	car_number1461
1462	48	479	car_number1462
1463	8	301	car_number1463
1464	22	180	car_number1464
1465	22	89	car_number1465
1466	35	101	car_number1466
1467	3	145	car_number1467
1468	33	87	car_number1468
1469	19	172	car_number1469
1470	40	93	car_number1470
1471	24	365	car_number1471
1472	2	325	car_number1472
1473	2	19	car_number1473
1474	46	370	car_number1474
1475	4	398	car_number1475
1476	7	35	car_number1476
1477	42	202	car_number1477
1478	31	35	car_number1478
1479	5	52	car_number1479
1480	18	433	car_number1480
1481	2	46	car_number1481
1482	18	10	car_number1482
1483	25	128	car_number1483
1484	26	473	car_number1484
1485	22	139	car_number1485
1486	44	346	car_number1486
1487	35	7	car_number1487
1488	18	266	car_number1488
1489	4	16	car_number1489
1490	37	362	car_number1490
1491	23	488	car_number1491
1492	13	163	car_number1492
1493	43	118	car_number1493
1494	1	158	car_number1494
1495	11	122	car_number1495
1496	37	458	car_number1496
1497	24	426	car_number1497
1498	21	102	car_number1498
1499	30	204	car_number1499
1500	22	279	car_number1500
1501	47	75	car_number1501
1502	32	449	car_number1502
1503	38	403	car_number1503
1504	18	463	car_number1504
1505	14	179	car_number1505
1506	18	75	car_number1506
1507	39	340	car_number1507
1508	31	36	car_number1508
1509	29	180	car_number1509
1510	14	65	car_number1510
1511	16	179	car_number1511
1512	24	86	car_number1512
1513	27	366	car_number1513
1514	24	117	car_number1514
1515	37	302	car_number1515
1516	49	32	car_number1516
1517	25	179	car_number1517
1518	42	227	car_number1518
1519	5	178	car_number1519
1520	18	161	car_number1520
1521	40	382	car_number1521
1522	7	420	car_number1522
1523	29	38	car_number1523
1524	47	138	car_number1524
1525	49	219	car_number1525
1526	5	315	car_number1526
1527	8	147	car_number1527
1528	19	79	car_number1528
1529	45	217	car_number1529
1530	38	63	car_number1530
1531	34	215	car_number1531
1532	32	182	car_number1532
1533	45	35	car_number1533
1534	14	67	car_number1534
1535	4	236	car_number1535
1536	38	215	car_number1536
1537	39	127	car_number1537
1538	38	71	car_number1538
1539	24	353	car_number1539
1540	41	268	car_number1540
1541	28	181	car_number1541
1542	49	80	car_number1542
1543	38	143	car_number1543
1544	18	190	car_number1544
1545	48	371	car_number1545
1546	48	401	car_number1546
1547	18	140	car_number1547
1548	9	238	car_number1548
1549	36	278	car_number1549
1550	47	374	car_number1550
1551	40	420	car_number1551
1552	9	355	car_number1552
1553	18	28	car_number1553
1554	33	19	car_number1554
1555	48	46	car_number1555
1556	41	426	car_number1556
1557	19	446	car_number1557
1558	34	137	car_number1558
1559	14	73	car_number1559
1560	10	203	car_number1560
1561	6	293	car_number1561
1562	50	421	car_number1562
1563	25	433	car_number1563
1564	7	53	car_number1564
1565	50	415	car_number1565
1566	16	322	car_number1566
1567	39	285	car_number1567
1568	30	256	car_number1568
1569	10	14	car_number1569
1570	37	115	car_number1570
1571	48	253	car_number1571
1572	31	475	car_number1572
1573	6	325	car_number1573
1574	36	371	car_number1574
1575	48	225	car_number1575
1576	15	298	car_number1576
1577	35	369	car_number1577
1578	33	170	car_number1578
1579	33	212	car_number1579
1580	7	374	car_number1580
1581	49	319	car_number1581
1582	8	165	car_number1582
1583	3	109	car_number1583
1584	6	215	car_number1584
1585	22	423	car_number1585
1586	37	318	car_number1586
1587	27	404	car_number1587
1588	4	440	car_number1588
1589	41	55	car_number1589
1590	15	261	car_number1590
1591	50	78	car_number1591
1592	35	308	car_number1592
1593	21	404	car_number1593
1594	25	168	car_number1594
1595	1	257	car_number1595
1596	32	138	car_number1596
1597	10	221	car_number1597
1598	1	30	car_number1598
1599	35	360	car_number1599
1600	33	205	car_number1600
1601	46	265	car_number1601
1602	8	326	car_number1602
1603	24	6	car_number1603
1604	46	464	car_number1604
1605	37	293	car_number1605
1606	2	81	car_number1606
1607	16	119	car_number1607
1608	15	79	car_number1608
1609	35	158	car_number1609
1610	33	149	car_number1610
1611	5	415	car_number1611
1612	46	331	car_number1612
1613	45	74	car_number1613
1614	1	345	car_number1614
1615	50	145	car_number1615
1616	12	55	car_number1616
1617	21	403	car_number1617
1618	31	143	car_number1618
1619	40	75	car_number1619
1620	22	234	car_number1620
1621	14	320	car_number1621
1622	8	203	car_number1622
1623	1	27	car_number1623
1624	14	353	car_number1624
1625	12	463	car_number1625
1626	38	395	car_number1626
1627	13	48	car_number1627
1628	26	337	car_number1628
1629	1	236	car_number1629
1630	8	482	car_number1630
1631	26	265	car_number1631
1632	37	153	car_number1632
1633	48	293	car_number1633
1634	36	239	car_number1634
1635	41	36	car_number1635
1636	16	58	car_number1636
1637	46	389	car_number1637
1638	27	16	car_number1638
1639	48	131	car_number1639
1640	20	453	car_number1640
1641	34	211	car_number1641
1642	21	157	car_number1642
1643	18	284	car_number1643
1644	50	269	car_number1644
1645	10	7	car_number1645
1646	15	495	car_number1646
1647	8	496	car_number1647
1648	12	180	car_number1648
1649	44	183	car_number1649
1650	29	334	car_number1650
1651	8	179	car_number1651
1652	16	382	car_number1652
1653	48	138	car_number1653
1654	44	403	car_number1654
1655	35	311	car_number1655
1656	22	230	car_number1656
1657	45	338	car_number1657
1658	1	224	car_number1658
1659	15	408	car_number1659
1660	49	189	car_number1660
1661	39	221	car_number1661
1662	34	17	car_number1662
1663	30	182	car_number1663
1664	42	268	car_number1664
1665	32	37	car_number1665
1666	48	461	car_number1666
1667	23	258	car_number1667
1668	39	207	car_number1668
1669	31	354	car_number1669
1670	44	287	car_number1670
1671	19	68	car_number1671
1672	50	187	car_number1672
1673	38	191	car_number1673
1674	31	217	car_number1674
1675	6	235	car_number1675
1676	6	488	car_number1676
1677	48	468	car_number1677
1678	41	440	car_number1678
1679	42	74	car_number1679
1680	7	211	car_number1680
1681	24	259	car_number1681
1682	16	52	car_number1682
1683	8	402	car_number1683
1684	50	19	car_number1684
1685	46	362	car_number1685
1686	45	463	car_number1686
1687	26	2	car_number1687
1688	10	199	car_number1688
1689	50	425	car_number1689
1690	13	471	car_number1690
1691	39	451	car_number1691
1692	6	369	car_number1692
1693	46	309	car_number1693
1694	45	394	car_number1694
1695	5	166	car_number1695
1696	25	211	car_number1696
1697	9	40	car_number1697
1698	33	495	car_number1698
1699	2	257	car_number1699
1700	9	284	car_number1700
1701	10	423	car_number1701
1702	17	193	car_number1702
1703	29	115	car_number1703
1704	6	227	car_number1704
1705	22	495	car_number1705
1706	17	154	car_number1706
1707	48	405	car_number1707
1708	29	58	car_number1708
1709	42	21	car_number1709
1710	41	346	car_number1710
1711	32	434	car_number1711
1712	9	396	car_number1712
1713	28	95	car_number1713
1714	43	332	car_number1714
1715	10	236	car_number1715
1716	7	21	car_number1716
1717	30	95	car_number1717
1718	2	16	car_number1718
1719	41	205	car_number1719
1720	40	189	car_number1720
1721	43	264	car_number1721
1722	38	8	car_number1722
1723	27	248	car_number1723
1724	6	197	car_number1724
1725	21	152	car_number1725
1726	49	335	car_number1726
1727	17	474	car_number1727
1728	11	441	car_number1728
1729	2	430	car_number1729
1730	42	78	car_number1730
1731	39	457	car_number1731
1732	25	10	car_number1732
1733	10	339	car_number1733
1734	44	339	car_number1734
1735	2	194	car_number1735
1736	31	81	car_number1736
1737	15	210	car_number1737
1738	36	98	car_number1738
1739	9	348	car_number1739
1740	11	116	car_number1740
1741	4	301	car_number1741
1742	22	16	car_number1742
1743	8	165	car_number1743
1744	33	374	car_number1744
1745	27	343	car_number1745
1746	5	295	car_number1746
1747	33	307	car_number1747
1748	10	407	car_number1748
1749	27	451	car_number1749
1750	46	471	car_number1750
1751	2	310	car_number1751
1752	41	103	car_number1752
1753	14	402	car_number1753
1754	43	229	car_number1754
1755	45	216	car_number1755
1756	31	169	car_number1756
1757	36	274	car_number1757
1758	44	52	car_number1758
1759	12	155	car_number1759
1760	38	357	car_number1760
1761	20	420	car_number1761
1762	40	306	car_number1762
1763	18	200	car_number1763
1764	32	203	car_number1764
1765	8	75	car_number1765
1766	32	35	car_number1766
1767	17	65	car_number1767
1768	25	20	car_number1768
1769	44	91	car_number1769
1770	18	299	car_number1770
1771	48	311	car_number1771
1772	29	404	car_number1772
1773	23	166	car_number1773
1774	42	10	car_number1774
1775	8	39	car_number1775
1776	32	490	car_number1776
1777	8	207	car_number1777
1778	13	201	car_number1778
1779	42	434	car_number1779
1780	22	425	car_number1780
1781	11	405	car_number1781
1782	15	470	car_number1782
1783	25	460	car_number1783
1784	7	95	car_number1784
1785	15	493	car_number1785
1786	25	134	car_number1786
1787	22	340	car_number1787
1788	39	257	car_number1788
1789	3	478	car_number1789
1790	48	415	car_number1790
1791	5	53	car_number1791
1792	35	263	car_number1792
1793	31	109	car_number1793
1794	37	12	car_number1794
1795	10	285	car_number1795
1796	10	373	car_number1796
1797	3	28	car_number1797
1798	26	222	car_number1798
1799	50	487	car_number1799
1800	9	143	car_number1800
1801	38	283	car_number1801
1802	20	356	car_number1802
1803	9	52	car_number1803
1804	41	336	car_number1804
1805	32	39	car_number1805
1806	36	450	car_number1806
1807	4	242	car_number1807
1808	6	76	car_number1808
1809	23	90	car_number1809
1810	13	237	car_number1810
1811	47	172	car_number1811
1812	43	356	car_number1812
1813	11	222	car_number1813
1814	2	274	car_number1814
1815	5	160	car_number1815
1816	12	204	car_number1816
1817	1	16	car_number1817
1818	45	119	car_number1818
1819	17	120	car_number1819
1820	1	346	car_number1820
1821	5	97	car_number1821
1822	45	242	car_number1822
1823	2	228	car_number1823
1824	33	463	car_number1824
1825	31	333	car_number1825
1826	20	252	car_number1826
1827	14	198	car_number1827
1828	37	18	car_number1828
1829	15	480	car_number1829
1830	36	234	car_number1830
1831	30	345	car_number1831
1832	6	6	car_number1832
1833	40	117	car_number1833
1834	15	295	car_number1834
1835	5	450	car_number1835
1836	43	260	car_number1836
1837	9	469	car_number1837
1838	43	24	car_number1838
1839	47	371	car_number1839
1840	38	469	car_number1840
1841	32	441	car_number1841
1842	40	327	car_number1842
1843	5	143	car_number1843
1844	48	310	car_number1844
1845	42	302	car_number1845
1846	21	315	car_number1846
1847	21	124	car_number1847
1848	49	367	car_number1848
1849	14	64	car_number1849
1850	38	73	car_number1850
1851	10	419	car_number1851
1852	9	104	car_number1852
1853	6	48	car_number1853
1854	11	148	car_number1854
1855	15	311	car_number1855
1856	8	436	car_number1856
1857	31	297	car_number1857
1858	35	62	car_number1858
1859	9	426	car_number1859
1860	34	62	car_number1860
1861	33	239	car_number1861
1862	5	254	car_number1862
1863	17	288	car_number1863
1864	32	322	car_number1864
1865	8	63	car_number1865
1866	31	2	car_number1866
1867	42	153	car_number1867
1868	13	294	car_number1868
1869	13	351	car_number1869
1870	32	291	car_number1870
1871	14	336	car_number1871
1872	17	119	car_number1872
1873	23	309	car_number1873
1874	22	87	car_number1874
1875	26	431	car_number1875
1876	8	189	car_number1876
1877	32	44	car_number1877
1878	22	367	car_number1878
1879	17	305	car_number1879
1880	33	87	car_number1880
1881	5	291	car_number1881
1882	31	318	car_number1882
1883	33	281	car_number1883
1884	34	368	car_number1884
1885	21	311	car_number1885
1886	31	494	car_number1886
1887	19	100	car_number1887
1888	20	423	car_number1888
1889	21	30	car_number1889
1890	10	214	car_number1890
1891	17	269	car_number1891
1892	22	445	car_number1892
1893	41	138	car_number1893
1894	26	467	car_number1894
1895	42	82	car_number1895
1896	13	117	car_number1896
1897	44	418	car_number1897
1898	29	352	car_number1898
1899	38	375	car_number1899
1900	20	119	car_number1900
1901	29	285	car_number1901
1902	11	316	car_number1902
1903	7	32	car_number1903
1904	37	213	car_number1904
1905	31	346	car_number1905
1906	10	374	car_number1906
1907	25	233	car_number1907
1908	29	167	car_number1908
1909	6	121	car_number1909
1910	39	164	car_number1910
1911	30	396	car_number1911
1912	30	301	car_number1912
1913	10	67	car_number1913
1914	12	360	car_number1914
1915	14	352	car_number1915
1916	2	117	car_number1916
1917	34	355	car_number1917
1918	48	159	car_number1918
1919	6	83	car_number1919
1920	48	384	car_number1920
1921	41	307	car_number1921
1922	30	101	car_number1922
1923	13	475	car_number1923
1924	9	397	car_number1924
1925	49	353	car_number1925
1926	8	413	car_number1926
1927	47	233	car_number1927
1928	8	323	car_number1928
1929	34	447	car_number1929
1930	19	216	car_number1930
1931	24	7	car_number1931
1932	15	301	car_number1932
1933	5	366	car_number1933
1934	34	260	car_number1934
1935	40	21	car_number1935
1936	49	150	car_number1936
1937	32	355	car_number1937
1938	50	351	car_number1938
1939	4	330	car_number1939
1940	14	337	car_number1940
1941	35	387	car_number1941
1942	50	371	car_number1942
1943	2	443	car_number1943
1944	20	169	car_number1944
1945	13	489	car_number1945
1946	43	399	car_number1946
1947	4	322	car_number1947
1948	2	108	car_number1948
1949	49	390	car_number1949
1950	19	3	car_number1950
1951	23	370	car_number1951
1952	31	295	car_number1952
1953	39	248	car_number1953
1954	3	189	car_number1954
1955	16	429	car_number1955
1956	44	494	car_number1956
1957	22	45	car_number1957
1958	12	295	car_number1958
1959	38	87	car_number1959
1960	19	500	car_number1960
1961	34	7	car_number1961
1962	40	70	car_number1962
1963	16	80	car_number1963
1964	22	433	car_number1964
1965	44	258	car_number1965
1966	50	283	car_number1966
1967	18	229	car_number1967
1968	46	226	car_number1968
1969	44	7	car_number1969
1970	26	89	car_number1970
1971	30	93	car_number1971
1972	20	460	car_number1972
1973	18	489	car_number1973
1974	45	416	car_number1974
1975	21	120	car_number1975
1976	19	165	car_number1976
1977	31	456	car_number1977
1978	15	113	car_number1978
1979	50	321	car_number1979
1980	20	123	car_number1980
1981	21	235	car_number1981
1982	35	123	car_number1982
1983	19	471	car_number1983
1984	46	112	car_number1984
1985	31	234	car_number1985
1986	47	255	car_number1986
1987	38	364	car_number1987
1988	5	364	car_number1988
1989	10	105	car_number1989
1990	9	85	car_number1990
1991	13	174	car_number1991
1992	2	21	car_number1992
1993	24	252	car_number1993
1994	48	68	car_number1994
1995	33	449	car_number1995
1996	23	161	car_number1996
1997	50	174	car_number1997
1998	36	216	car_number1998
1999	17	325	car_number1999
2000	24	382	car_number2000
2001	7	110	car_number2001
2002	8	175	car_number2002
2003	14	167	car_number2003
2004	7	122	car_number2004
2005	23	287	car_number2005
2006	9	479	car_number2006
2007	4	446	car_number2007
2008	45	158	car_number2008
2009	1	276	car_number2009
2010	31	44	car_number2010
2011	16	429	car_number2011
2012	6	127	car_number2012
2013	10	340	car_number2013
2014	4	445	car_number2014
2015	7	401	car_number2015
2016	46	107	car_number2016
2017	19	472	car_number2017
2018	18	229	car_number2018
2019	44	126	car_number2019
2020	9	349	car_number2020
2021	34	276	car_number2021
2022	3	403	car_number2022
2023	13	179	car_number2023
2024	18	159	car_number2024
2025	30	3	car_number2025
2026	21	94	car_number2026
2027	19	23	car_number2027
2028	30	355	car_number2028
2029	34	132	car_number2029
2030	29	227	car_number2030
2031	23	252	car_number2031
2032	43	348	car_number2032
2033	26	400	car_number2033
2034	39	128	car_number2034
2035	48	141	car_number2035
2036	50	17	car_number2036
2037	25	432	car_number2037
2038	9	69	car_number2038
2039	6	23	car_number2039
2040	13	358	car_number2040
2041	15	29	car_number2041
2042	40	155	car_number2042
2043	1	462	car_number2043
2044	41	4	car_number2044
2045	8	92	car_number2045
2046	10	429	car_number2046
2047	40	222	car_number2047
2048	15	299	car_number2048
2049	45	429	car_number2049
2050	1	51	car_number2050
2051	31	295	car_number2051
2052	47	401	car_number2052
2053	5	111	car_number2053
2054	14	401	car_number2054
2055	7	141	car_number2055
2056	7	471	car_number2056
2057	21	460	car_number2057
2058	32	128	car_number2058
2059	45	433	car_number2059
2060	6	310	car_number2060
2061	5	494	car_number2061
2062	45	305	car_number2062
2063	7	47	car_number2063
2064	23	193	car_number2064
2065	42	68	car_number2065
2066	43	231	car_number2066
2067	19	422	car_number2067
2068	31	48	car_number2068
2069	23	132	car_number2069
2070	1	342	car_number2070
2071	24	479	car_number2071
2072	2	49	car_number2072
2073	27	280	car_number2073
2074	43	452	car_number2074
2075	14	245	car_number2075
2076	34	344	car_number2076
2077	49	296	car_number2077
2078	4	495	car_number2078
2079	32	36	car_number2079
2080	48	289	car_number2080
2081	44	158	car_number2081
2082	9	377	car_number2082
2083	42	125	car_number2083
2084	6	229	car_number2084
2085	49	230	car_number2085
2086	16	246	car_number2086
2087	4	171	car_number2087
2088	5	347	car_number2088
2089	38	183	car_number2089
2090	37	380	car_number2090
2091	39	426	car_number2091
2092	20	486	car_number2092
2093	36	201	car_number2093
2094	35	212	car_number2094
2095	16	343	car_number2095
2096	2	380	car_number2096
2097	37	441	car_number2097
2098	8	206	car_number2098
2099	2	285	car_number2099
2100	42	96	car_number2100
2101	38	446	car_number2101
2102	11	450	car_number2102
2103	26	176	car_number2103
2104	12	184	car_number2104
2105	43	371	car_number2105
2106	18	321	car_number2106
2107	19	443	car_number2107
2108	1	205	car_number2108
2109	6	145	car_number2109
2110	15	206	car_number2110
2111	2	98	car_number2111
2112	34	50	car_number2112
2113	32	73	car_number2113
2114	48	17	car_number2114
2115	32	82	car_number2115
2116	19	152	car_number2116
2117	15	407	car_number2117
2118	23	197	car_number2118
2119	1	373	car_number2119
2120	48	51	car_number2120
2121	11	353	car_number2121
2122	27	128	car_number2122
2123	22	439	car_number2123
2124	12	436	car_number2124
2125	46	291	car_number2125
2126	43	68	car_number2126
2127	20	251	car_number2127
2128	28	372	car_number2128
2129	50	199	car_number2129
2130	47	78	car_number2130
2131	9	364	car_number2131
2132	34	174	car_number2132
2133	1	104	car_number2133
2134	22	421	car_number2134
2135	13	194	car_number2135
2136	6	416	car_number2136
2137	44	495	car_number2137
2138	37	124	car_number2138
2139	20	194	car_number2139
2140	3	492	car_number2140
2141	14	262	car_number2141
2142	9	332	car_number2142
2143	12	310	car_number2143
2144	2	475	car_number2144
2145	12	199	car_number2145
2146	48	238	car_number2146
2147	41	136	car_number2147
2148	23	475	car_number2148
2149	46	22	car_number2149
2150	3	443	car_number2150
2151	11	217	car_number2151
2152	12	340	car_number2152
2153	34	1	car_number2153
2154	4	462	car_number2154
2155	39	430	car_number2155
2156	1	116	car_number2156
2157	20	45	car_number2157
2158	50	412	car_number2158
2159	21	484	car_number2159
2160	14	491	car_number2160
2161	4	134	car_number2161
2162	42	39	car_number2162
2163	44	155	car_number2163
2164	44	371	car_number2164
2165	18	262	car_number2165
2166	10	202	car_number2166
2167	31	417	car_number2167
2168	35	499	car_number2168
2169	27	68	car_number2169
2170	16	86	car_number2170
2171	5	132	car_number2171
2172	47	441	car_number2172
2173	7	359	car_number2173
2174	49	274	car_number2174
2175	35	256	car_number2175
2176	34	381	car_number2176
2177	23	331	car_number2177
2178	14	356	car_number2178
2179	35	314	car_number2179
2180	41	147	car_number2180
2181	24	372	car_number2181
2182	1	91	car_number2182
2183	4	178	car_number2183
2184	9	30	car_number2184
2185	2	426	car_number2185
2186	12	465	car_number2186
2187	21	249	car_number2187
2188	44	252	car_number2188
2189	44	266	car_number2189
2190	38	346	car_number2190
2191	47	434	car_number2191
2192	29	469	car_number2192
2193	47	32	car_number2193
2194	1	310	car_number2194
2195	46	430	car_number2195
2196	36	292	car_number2196
2197	4	29	car_number2197
2198	47	69	car_number2198
2199	3	125	car_number2199
2200	27	50	car_number2200
2201	4	99	car_number2201
2202	3	337	car_number2202
2203	38	289	car_number2203
2204	18	75	car_number2204
2205	26	468	car_number2205
2206	34	269	car_number2206
2207	25	219	car_number2207
2208	8	137	car_number2208
2209	9	317	car_number2209
2210	13	89	car_number2210
2211	42	8	car_number2211
2212	26	368	car_number2212
2213	8	459	car_number2213
2214	6	281	car_number2214
2215	32	2	car_number2215
2216	17	227	car_number2216
2217	23	45	car_number2217
2218	13	245	car_number2218
2219	34	412	car_number2219
2220	11	97	car_number2220
2221	11	155	car_number2221
2222	32	97	car_number2222
2223	9	5	car_number2223
2224	9	234	car_number2224
2225	6	160	car_number2225
2226	9	387	car_number2226
2227	42	481	car_number2227
2228	40	237	car_number2228
2229	3	45	car_number2229
2230	42	403	car_number2230
2231	19	49	car_number2231
2232	10	315	car_number2232
2233	3	245	car_number2233
2234	18	66	car_number2234
2235	36	428	car_number2235
2236	29	273	car_number2236
2237	5	296	car_number2237
2238	2	26	car_number2238
2239	10	448	car_number2239
2240	26	383	car_number2240
2241	7	192	car_number2241
2242	6	356	car_number2242
2243	38	382	car_number2243
2244	4	119	car_number2244
2245	1	36	car_number2245
2246	30	188	car_number2246
2247	4	138	car_number2247
2248	20	262	car_number2248
2249	30	244	car_number2249
2250	7	414	car_number2250
2251	28	270	car_number2251
2252	48	316	car_number2252
2253	33	181	car_number2253
2254	32	156	car_number2254
2255	8	477	car_number2255
2256	22	492	car_number2256
2257	41	280	car_number2257
2258	9	40	car_number2258
2259	31	248	car_number2259
2260	31	454	car_number2260
2261	3	493	car_number2261
2262	50	268	car_number2262
2263	27	100	car_number2263
2264	32	320	car_number2264
2265	22	445	car_number2265
2266	6	286	car_number2266
2267	6	163	car_number2267
2268	37	157	car_number2268
2269	49	359	car_number2269
2270	37	267	car_number2270
2271	32	85	car_number2271
2272	34	279	car_number2272
2273	45	430	car_number2273
2274	1	292	car_number2274
2275	1	126	car_number2275
2276	26	403	car_number2276
2277	29	9	car_number2277
2278	26	199	car_number2278
2279	31	170	car_number2279
2280	15	310	car_number2280
2281	5	266	car_number2281
2282	12	259	car_number2282
2283	12	393	car_number2283
2284	47	9	car_number2284
2285	6	230	car_number2285
2286	2	258	car_number2286
2287	33	354	car_number2287
2288	32	256	car_number2288
2289	23	125	car_number2289
2290	27	262	car_number2290
2291	46	250	car_number2291
2292	13	269	car_number2292
2293	37	493	car_number2293
2294	33	114	car_number2294
2295	29	460	car_number2295
2296	30	242	car_number2296
2297	49	90	car_number2297
2298	19	46	car_number2298
2299	41	474	car_number2299
2300	5	374	car_number2300
2301	39	3	car_number2301
2302	32	243	car_number2302
2303	43	264	car_number2303
2304	5	223	car_number2304
2305	44	69	car_number2305
2306	4	406	car_number2306
2307	32	234	car_number2307
2308	9	12	car_number2308
2309	15	110	car_number2309
2310	50	30	car_number2310
2311	19	358	car_number2311
2312	20	393	car_number2312
2313	33	348	car_number2313
2314	48	31	car_number2314
2315	30	123	car_number2315
2316	48	168	car_number2316
2317	37	180	car_number2317
2318	41	15	car_number2318
2319	18	401	car_number2319
2320	42	230	car_number2320
2321	18	415	car_number2321
2322	28	497	car_number2322
2323	18	252	car_number2323
2324	31	52	car_number2324
2325	34	66	car_number2325
2326	11	266	car_number2326
2327	16	417	car_number2327
2328	14	376	car_number2328
2329	29	483	car_number2329
2330	34	36	car_number2330
2331	4	115	car_number2331
2332	49	27	car_number2332
2333	32	291	car_number2333
2334	7	313	car_number2334
2335	34	242	car_number2335
2336	36	133	car_number2336
2337	33	64	car_number2337
2338	36	443	car_number2338
2339	43	337	car_number2339
2340	46	347	car_number2340
2341	33	376	car_number2341
2342	17	301	car_number2342
2343	12	144	car_number2343
2344	27	168	car_number2344
2345	2	437	car_number2345
2346	49	145	car_number2346
2347	14	498	car_number2347
2348	16	235	car_number2348
2349	7	111	car_number2349
2350	8	159	car_number2350
2351	37	82	car_number2351
2352	21	433	car_number2352
2353	35	119	car_number2353
2354	28	432	car_number2354
2355	46	389	car_number2355
2356	24	277	car_number2356
2357	7	216	car_number2357
2358	19	59	car_number2358
2359	2	384	car_number2359
2360	40	468	car_number2360
2361	47	44	car_number2361
2362	45	4	car_number2362
2363	16	3	car_number2363
2364	25	199	car_number2364
2365	15	64	car_number2365
2366	26	109	car_number2366
2367	36	267	car_number2367
2368	29	65	car_number2368
2369	32	236	car_number2369
2370	9	254	car_number2370
2371	29	120	car_number2371
2372	26	140	car_number2372
2373	33	48	car_number2373
2374	30	348	car_number2374
2375	10	423	car_number2375
2376	30	277	car_number2376
2377	36	197	car_number2377
2378	42	257	car_number2378
2379	9	77	car_number2379
2380	29	373	car_number2380
2381	17	305	car_number2381
2382	30	448	car_number2382
2383	48	83	car_number2383
2384	26	452	car_number2384
2385	9	86	car_number2385
2386	28	76	car_number2386
2387	2	102	car_number2387
2388	38	226	car_number2388
2389	47	191	car_number2389
2390	29	121	car_number2390
2391	32	421	car_number2391
2392	8	371	car_number2392
2393	10	380	car_number2393
2394	46	74	car_number2394
2395	31	446	car_number2395
2396	50	227	car_number2396
2397	18	481	car_number2397
2398	13	385	car_number2398
2399	46	15	car_number2399
2400	23	193	car_number2400
2401	9	141	car_number2401
2402	37	212	car_number2402
2403	43	7	car_number2403
2404	50	79	car_number2404
2405	9	275	car_number2405
2406	40	46	car_number2406
2407	10	417	car_number2407
2408	22	338	car_number2408
2409	25	462	car_number2409
2410	31	491	car_number2410
2411	20	200	car_number2411
2412	14	227	car_number2412
2413	36	334	car_number2413
2414	26	22	car_number2414
2415	12	216	car_number2415
2416	27	294	car_number2416
2417	14	400	car_number2417
2418	6	178	car_number2418
2419	26	171	car_number2419
2420	11	92	car_number2420
2421	50	336	car_number2421
2422	17	49	car_number2422
2423	6	436	car_number2423
2424	5	81	car_number2424
2425	7	232	car_number2425
2426	20	96	car_number2426
2427	15	345	car_number2427
2428	14	349	car_number2428
2429	23	75	car_number2429
2430	2	427	car_number2430
2431	30	271	car_number2431
2432	35	202	car_number2432
2433	44	349	car_number2433
2434	41	392	car_number2434
2435	47	488	car_number2435
2436	7	452	car_number2436
2437	12	344	car_number2437
2438	19	105	car_number2438
2439	40	417	car_number2439
2440	33	398	car_number2440
2441	44	177	car_number2441
2442	47	258	car_number2442
2443	39	115	car_number2443
2444	21	494	car_number2444
2445	34	226	car_number2445
2446	50	142	car_number2446
2447	20	394	car_number2447
2448	21	241	car_number2448
2449	30	439	car_number2449
2450	26	467	car_number2450
2451	19	28	car_number2451
2452	33	491	car_number2452
2453	6	222	car_number2453
2454	40	451	car_number2454
2455	34	332	car_number2455
2456	27	302	car_number2456
2457	23	194	car_number2457
2458	9	403	car_number2458
2459	7	388	car_number2459
2460	47	58	car_number2460
2461	7	268	car_number2461
2462	30	246	car_number2462
2463	23	155	car_number2463
2464	9	463	car_number2464
2465	8	34	car_number2465
2466	11	67	car_number2466
2467	15	209	car_number2467
2468	36	363	car_number2468
2469	22	366	car_number2469
2470	24	163	car_number2470
2471	35	106	car_number2471
2472	17	79	car_number2472
2473	15	469	car_number2473
2474	24	486	car_number2474
2475	43	476	car_number2475
2476	12	27	car_number2476
2477	27	407	car_number2477
2478	38	386	car_number2478
2479	44	369	car_number2479
2480	29	226	car_number2480
2481	7	305	car_number2481
2482	37	400	car_number2482
2483	46	126	car_number2483
2484	28	242	car_number2484
2485	40	332	car_number2485
2486	13	195	car_number2486
2487	36	203	car_number2487
2488	25	7	car_number2488
2489	37	294	car_number2489
2490	9	217	car_number2490
2491	32	198	car_number2491
2492	10	266	car_number2492
2493	27	57	car_number2493
2494	20	276	car_number2494
2495	31	472	car_number2495
2496	36	279	car_number2496
2497	22	30	car_number2497
2498	31	352	car_number2498
2499	9	124	car_number2499
2500	20	22	car_number2500
2501	30	278	car_number2501
2502	7	24	car_number2502
2503	6	51	car_number2503
2504	11	435	car_number2504
2505	13	475	car_number2505
2506	15	376	car_number2506
2507	46	189	car_number2507
2508	16	20	car_number2508
2509	19	311	car_number2509
2510	2	461	car_number2510
2511	26	271	car_number2511
2512	3	337	car_number2512
2513	37	162	car_number2513
2514	18	7	car_number2514
2515	25	301	car_number2515
2516	27	85	car_number2516
2517	32	281	car_number2517
2518	23	325	car_number2518
2519	18	140	car_number2519
2520	14	29	car_number2520
2521	11	66	car_number2521
2522	36	120	car_number2522
2523	9	7	car_number2523
2524	15	266	car_number2524
2525	2	259	car_number2525
2526	33	272	car_number2526
2527	35	356	car_number2527
2528	47	497	car_number2528
2529	45	496	car_number2529
2530	6	417	car_number2530
2531	30	111	car_number2531
2532	6	438	car_number2532
2533	49	85	car_number2533
2534	39	78	car_number2534
2535	29	161	car_number2535
2536	1	363	car_number2536
2537	31	408	car_number2537
2538	12	270	car_number2538
2539	22	32	car_number2539
2540	19	334	car_number2540
2541	1	299	car_number2541
2542	32	88	car_number2542
2543	36	38	car_number2543
2544	1	412	car_number2544
2545	44	376	car_number2545
2546	1	93	car_number2546
2547	22	183	car_number2547
2548	49	266	car_number2548
2549	17	255	car_number2549
2550	30	260	car_number2550
2551	18	338	car_number2551
2552	7	156	car_number2552
2553	25	377	car_number2553
2554	25	335	car_number2554
2555	6	370	car_number2555
2556	11	72	car_number2556
2557	16	102	car_number2557
2558	15	282	car_number2558
2559	1	130	car_number2559
2560	4	156	car_number2560
2561	45	278	car_number2561
2562	10	18	car_number2562
2563	46	123	car_number2563
2564	50	192	car_number2564
2565	14	27	car_number2565
2566	27	342	car_number2566
2567	27	80	car_number2567
2568	33	231	car_number2568
2569	35	109	car_number2569
2570	1	376	car_number2570
2571	10	288	car_number2571
2572	1	53	car_number2572
2573	26	459	car_number2573
2574	4	180	car_number2574
2575	33	135	car_number2575
2576	24	332	car_number2576
2577	33	267	car_number2577
2578	29	167	car_number2578
2579	8	212	car_number2579
2580	25	101	car_number2580
2581	26	233	car_number2581
2582	5	21	car_number2582
2583	16	176	car_number2583
2584	48	415	car_number2584
2585	10	271	car_number2585
2586	39	185	car_number2586
2587	33	340	car_number2587
2588	43	302	car_number2588
2589	19	232	car_number2589
2590	16	482	car_number2590
2591	9	333	car_number2591
2592	24	382	car_number2592
2593	44	128	car_number2593
2594	26	266	car_number2594
2595	29	215	car_number2595
2596	45	416	car_number2596
2597	41	203	car_number2597
2598	13	181	car_number2598
2599	35	34	car_number2599
2600	47	378	car_number2600
2601	28	47	car_number2601
2602	50	189	car_number2602
2603	43	299	car_number2603
2604	8	367	car_number2604
2605	35	158	car_number2605
2606	33	309	car_number2606
2607	29	227	car_number2607
2608	6	136	car_number2608
2609	25	165	car_number2609
2610	3	343	car_number2610
2611	3	258	car_number2611
2612	7	271	car_number2612
2613	30	213	car_number2613
2614	43	15	car_number2614
2615	49	159	car_number2615
2616	10	3	car_number2616
2617	15	102	car_number2617
2618	39	439	car_number2618
2619	36	385	car_number2619
2620	35	217	car_number2620
2621	37	472	car_number2621
2622	4	276	car_number2622
2623	5	90	car_number2623
2624	12	242	car_number2624
2625	31	114	car_number2625
2626	32	193	car_number2626
2627	32	172	car_number2627
2628	46	406	car_number2628
2629	30	480	car_number2629
2630	24	159	car_number2630
2631	36	153	car_number2631
2632	22	121	car_number2632
2633	21	338	car_number2633
2634	39	250	car_number2634
2635	44	82	car_number2635
2636	40	110	car_number2636
2637	6	141	car_number2637
2638	37	72	car_number2638
2639	26	420	car_number2639
2640	21	248	car_number2640
2641	21	498	car_number2641
2642	12	435	car_number2642
2643	14	25	car_number2643
2644	17	401	car_number2644
2645	35	469	car_number2645
2646	15	182	car_number2646
2647	16	159	car_number2647
2648	24	147	car_number2648
2649	1	48	car_number2649
2650	15	228	car_number2650
2651	2	71	car_number2651
2652	3	271	car_number2652
2653	26	391	car_number2653
2654	34	295	car_number2654
2655	32	484	car_number2655
2656	31	121	car_number2656
2657	47	328	car_number2657
2658	10	76	car_number2658
2659	30	45	car_number2659
2660	40	235	car_number2660
2661	35	65	car_number2661
2662	42	325	car_number2662
2663	5	199	car_number2663
2664	23	338	car_number2664
2665	5	216	car_number2665
2666	42	435	car_number2666
2667	44	374	car_number2667
2668	40	122	car_number2668
2669	17	293	car_number2669
2670	40	102	car_number2670
2671	10	229	car_number2671
2672	3	360	car_number2672
2673	41	438	car_number2673
2674	3	85	car_number2674
2675	38	396	car_number2675
2676	11	265	car_number2676
2677	42	99	car_number2677
2678	28	290	car_number2678
2679	15	200	car_number2679
2680	47	430	car_number2680
2681	9	230	car_number2681
2682	22	285	car_number2682
2683	26	333	car_number2683
2684	28	303	car_number2684
2685	27	381	car_number2685
2686	33	452	car_number2686
2687	8	413	car_number2687
2688	33	245	car_number2688
2689	4	355	car_number2689
2690	48	203	car_number2690
2691	49	430	car_number2691
2692	19	317	car_number2692
2693	11	305	car_number2693
2694	48	129	car_number2694
2695	2	368	car_number2695
2696	42	170	car_number2696
2697	2	108	car_number2697
2698	12	177	car_number2698
2699	4	432	car_number2699
2700	35	351	car_number2700
2701	34	439	car_number2701
2702	42	453	car_number2702
2703	16	143	car_number2703
2704	22	476	car_number2704
2705	46	318	car_number2705
2706	9	485	car_number2706
2707	16	222	car_number2707
2708	27	358	car_number2708
2709	5	47	car_number2709
2710	13	47	car_number2710
2711	21	235	car_number2711
2712	23	364	car_number2712
2713	27	208	car_number2713
2714	6	367	car_number2714
2715	35	195	car_number2715
2716	6	211	car_number2716
2717	50	174	car_number2717
2718	5	167	car_number2718
2719	15	161	car_number2719
2720	15	449	car_number2720
2721	27	11	car_number2721
2722	17	164	car_number2722
2723	46	61	car_number2723
2724	48	403	car_number2724
2725	16	314	car_number2725
2726	9	275	car_number2726
2727	46	309	car_number2727
2728	16	223	car_number2728
2729	45	354	car_number2729
2730	14	221	car_number2730
2731	6	400	car_number2731
2732	10	271	car_number2732
2733	37	472	car_number2733
2734	47	394	car_number2734
2735	32	66	car_number2735
2736	37	391	car_number2736
2737	8	43	car_number2737
2738	21	415	car_number2738
2739	8	167	car_number2739
2740	23	125	car_number2740
2741	13	114	car_number2741
2742	26	382	car_number2742
2743	22	7	car_number2743
2744	4	113	car_number2744
2745	49	35	car_number2745
2746	3	138	car_number2746
2747	10	369	car_number2747
2748	48	128	car_number2748
2749	25	92	car_number2749
2750	6	464	car_number2750
2751	12	386	car_number2751
2752	9	92	car_number2752
2753	33	467	car_number2753
2754	24	209	car_number2754
2755	9	179	car_number2755
2756	23	342	car_number2756
2757	23	153	car_number2757
2758	43	280	car_number2758
2759	41	109	car_number2759
2760	44	190	car_number2760
2761	5	240	car_number2761
2762	48	220	car_number2762
2763	5	8	car_number2763
2764	9	236	car_number2764
2765	35	405	car_number2765
2766	5	45	car_number2766
2767	7	179	car_number2767
2768	35	85	car_number2768
2769	15	492	car_number2769
2770	40	433	car_number2770
2771	17	317	car_number2771
2772	47	66	car_number2772
2773	38	24	car_number2773
2774	5	378	car_number2774
2775	46	351	car_number2775
2776	39	354	car_number2776
2777	35	16	car_number2777
2778	10	243	car_number2778
2779	33	191	car_number2779
2780	39	3	car_number2780
2781	34	273	car_number2781
2782	47	444	car_number2782
2783	4	66	car_number2783
2784	35	341	car_number2784
2785	3	406	car_number2785
2786	6	187	car_number2786
2787	35	196	car_number2787
2788	50	70	car_number2788
2789	31	175	car_number2789
2790	16	298	car_number2790
2791	37	305	car_number2791
2792	50	362	car_number2792
2793	32	129	car_number2793
2794	18	480	car_number2794
2795	44	473	car_number2795
2796	18	73	car_number2796
2797	18	311	car_number2797
2798	40	22	car_number2798
2799	13	9	car_number2799
2800	20	359	car_number2800
2801	22	288	car_number2801
2802	36	344	car_number2802
2803	39	169	car_number2803
2804	42	495	car_number2804
2805	10	99	car_number2805
2806	24	398	car_number2806
2807	25	171	car_number2807
2808	44	324	car_number2808
2809	9	99	car_number2809
2810	43	239	car_number2810
2811	30	306	car_number2811
2812	8	497	car_number2812
2813	39	172	car_number2813
2814	21	1	car_number2814
2815	9	390	car_number2815
2816	9	188	car_number2816
2817	13	361	car_number2817
2818	3	53	car_number2818
2819	23	396	car_number2819
2820	32	269	car_number2820
2821	17	414	car_number2821
2822	9	140	car_number2822
2823	28	1	car_number2823
2824	25	31	car_number2824
2825	20	457	car_number2825
2826	14	378	car_number2826
2827	33	180	car_number2827
2828	38	283	car_number2828
2829	44	4	car_number2829
2830	49	312	car_number2830
2831	44	421	car_number2831
2832	19	108	car_number2832
2833	5	494	car_number2833
2834	5	338	car_number2834
2835	9	257	car_number2835
2836	33	487	car_number2836
2837	14	352	car_number2837
2838	47	129	car_number2838
2839	9	89	car_number2839
2840	46	433	car_number2840
2841	8	168	car_number2841
2842	19	348	car_number2842
2843	44	408	car_number2843
2844	36	290	car_number2844
2845	2	353	car_number2845
2846	18	479	car_number2846
2847	38	499	car_number2847
2848	42	469	car_number2848
2849	17	472	car_number2849
2850	48	33	car_number2850
2851	48	103	car_number2851
2852	22	130	car_number2852
2853	38	448	car_number2853
2854	35	224	car_number2854
2855	38	230	car_number2855
2856	26	192	car_number2856
2857	11	364	car_number2857
2858	4	478	car_number2858
2859	40	430	car_number2859
2860	16	255	car_number2860
2861	43	260	car_number2861
2862	26	173	car_number2862
2863	28	182	car_number2863
2864	12	220	car_number2864
2865	19	249	car_number2865
2866	6	159	car_number2866
2867	9	411	car_number2867
2868	21	44	car_number2868
2869	9	405	car_number2869
2870	4	422	car_number2870
2871	31	97	car_number2871
2872	18	147	car_number2872
2873	15	71	car_number2873
2874	30	193	car_number2874
2875	41	152	car_number2875
2876	31	322	car_number2876
2877	20	87	car_number2877
2878	43	494	car_number2878
2879	7	187	car_number2879
2880	26	187	car_number2880
2881	9	369	car_number2881
2882	5	280	car_number2882
2883	5	307	car_number2883
2884	23	262	car_number2884
2885	5	261	car_number2885
2886	30	450	car_number2886
2887	23	468	car_number2887
2888	7	232	car_number2888
2889	17	126	car_number2889
2890	31	223	car_number2890
2891	30	440	car_number2891
2892	25	254	car_number2892
2893	19	25	car_number2893
2894	4	251	car_number2894
2895	9	39	car_number2895
2896	35	203	car_number2896
2897	27	347	car_number2897
2898	22	376	car_number2898
2899	26	414	car_number2899
2900	15	68	car_number2900
2901	44	434	car_number2901
2902	24	395	car_number2902
2903	3	424	car_number2903
2904	26	155	car_number2904
2905	23	86	car_number2905
2906	44	376	car_number2906
2907	39	399	car_number2907
2908	12	386	car_number2908
2909	8	432	car_number2909
2910	46	4	car_number2910
2911	18	475	car_number2911
2912	32	456	car_number2912
2913	48	414	car_number2913
2914	41	445	car_number2914
2915	36	168	car_number2915
2916	26	459	car_number2916
2917	27	386	car_number2917
2918	7	10	car_number2918
2919	36	308	car_number2919
2920	18	182	car_number2920
2921	50	23	car_number2921
2922	44	36	car_number2922
2923	25	485	car_number2923
2924	8	222	car_number2924
2925	48	231	car_number2925
2926	33	4	car_number2926
2927	27	122	car_number2927
2928	14	328	car_number2928
2929	24	152	car_number2929
2930	43	414	car_number2930
2931	26	58	car_number2931
2932	20	172	car_number2932
2933	45	109	car_number2933
2934	42	71	car_number2934
2935	49	163	car_number2935
2936	41	47	car_number2936
2937	11	266	car_number2937
2938	41	232	car_number2938
2939	8	306	car_number2939
2940	40	133	car_number2940
2941	5	238	car_number2941
2942	23	57	car_number2942
2943	46	71	car_number2943
2944	11	308	car_number2944
2945	44	407	car_number2945
2946	46	109	car_number2946
2947	8	369	car_number2947
2948	9	121	car_number2948
2949	14	357	car_number2949
2950	38	71	car_number2950
2951	28	493	car_number2951
2952	29	416	car_number2952
2953	47	205	car_number2953
2954	16	277	car_number2954
2955	47	2	car_number2955
2956	49	304	car_number2956
2957	1	56	car_number2957
2958	15	301	car_number2958
2959	49	154	car_number2959
2960	49	108	car_number2960
2961	8	16	car_number2961
2962	21	472	car_number2962
2963	40	222	car_number2963
2964	38	384	car_number2964
2965	47	431	car_number2965
2966	44	269	car_number2966
2967	38	169	car_number2967
2968	23	377	car_number2968
2969	8	51	car_number2969
2970	50	281	car_number2970
2971	42	192	car_number2971
2972	12	37	car_number2972
2973	32	124	car_number2973
2974	39	285	car_number2974
2975	25	302	car_number2975
2976	21	21	car_number2976
2977	13	184	car_number2977
2978	11	411	car_number2978
2979	23	284	car_number2979
2980	35	382	car_number2980
2981	3	165	car_number2981
2982	10	454	car_number2982
2983	49	232	car_number2983
2984	25	234	car_number2984
2985	45	162	car_number2985
2986	20	88	car_number2986
2987	15	362	car_number2987
2988	21	431	car_number2988
2989	40	127	car_number2989
2990	15	238	car_number2990
2991	16	482	car_number2991
2992	19	483	car_number2992
2993	34	210	car_number2993
2994	27	384	car_number2994
2995	39	248	car_number2995
2996	14	333	car_number2996
2997	47	316	car_number2997
2998	22	497	car_number2998
2999	7	73	car_number2999
3000	9	363	car_number3000
3001	5	90	car_number3001
3002	3	168	car_number3002
3003	22	116	car_number3003
3004	16	277	car_number3004
3005	25	285	car_number3005
3006	25	263	car_number3006
3007	12	343	car_number3007
3008	11	451	car_number3008
3009	8	262	car_number3009
3010	22	76	car_number3010
3011	15	354	car_number3011
3012	12	340	car_number3012
3013	22	161	car_number3013
3014	22	483	car_number3014
3015	39	211	car_number3015
3016	14	227	car_number3016
3017	4	372	car_number3017
3018	24	260	car_number3018
3019	8	269	car_number3019
3020	4	30	car_number3020
3021	6	338	car_number3021
3022	34	456	car_number3022
3023	42	340	car_number3023
3024	20	440	car_number3024
3025	26	420	car_number3025
3026	49	62	car_number3026
3027	23	174	car_number3027
3028	47	274	car_number3028
3029	27	98	car_number3029
3030	35	130	car_number3030
3031	44	151	car_number3031
3032	46	245	car_number3032
3033	6	368	car_number3033
3034	26	13	car_number3034
3035	8	378	car_number3035
3036	44	105	car_number3036
3037	3	451	car_number3037
3038	30	38	car_number3038
3039	45	378	car_number3039
3040	27	298	car_number3040
3041	21	297	car_number3041
3042	42	213	car_number3042
3043	19	109	car_number3043
3044	35	48	car_number3044
3045	22	427	car_number3045
3046	41	354	car_number3046
3047	8	389	car_number3047
3048	27	79	car_number3048
3049	21	91	car_number3049
3050	26	189	car_number3050
3051	9	146	car_number3051
3052	22	69	car_number3052
3053	27	45	car_number3053
3054	5	157	car_number3054
3055	6	274	car_number3055
3056	24	129	car_number3056
3057	30	136	car_number3057
3058	22	196	car_number3058
3059	9	391	car_number3059
3060	9	253	car_number3060
3061	37	494	car_number3061
3062	38	25	car_number3062
3063	45	36	car_number3063
3064	11	60	car_number3064
3065	10	229	car_number3065
3066	14	34	car_number3066
3067	31	32	car_number3067
3068	2	179	car_number3068
3069	17	205	car_number3069
3070	30	282	car_number3070
3071	26	301	car_number3071
3072	48	480	car_number3072
3073	20	229	car_number3073
3074	2	169	car_number3074
3075	6	285	car_number3075
3076	17	164	car_number3076
3077	17	499	car_number3077
3078	33	254	car_number3078
3079	29	3	car_number3079
3080	6	212	car_number3080
3081	3	195	car_number3081
3082	20	328	car_number3082
3083	39	455	car_number3083
3084	22	361	car_number3084
3085	16	431	car_number3085
3086	45	227	car_number3086
3087	9	261	car_number3087
3088	17	132	car_number3088
3089	44	118	car_number3089
3090	37	445	car_number3090
3091	49	156	car_number3091
3092	42	332	car_number3092
3093	43	451	car_number3093
3094	24	153	car_number3094
3095	16	297	car_number3095
3096	27	325	car_number3096
3097	8	302	car_number3097
3098	17	165	car_number3098
3099	8	455	car_number3099
3100	48	96	car_number3100
3101	47	350	car_number3101
3102	48	432	car_number3102
3103	22	244	car_number3103
3104	41	3	car_number3104
3105	49	195	car_number3105
3106	19	345	car_number3106
3107	26	183	car_number3107
3108	48	336	car_number3108
3109	48	272	car_number3109
3110	41	108	car_number3110
3111	8	36	car_number3111
3112	23	37	car_number3112
3113	35	494	car_number3113
3114	43	37	car_number3114
3115	3	245	car_number3115
3116	13	321	car_number3116
3117	3	13	car_number3117
3118	29	498	car_number3118
3119	6	413	car_number3119
3120	42	189	car_number3120
3121	24	188	car_number3121
3122	13	336	car_number3122
3123	25	473	car_number3123
3124	29	475	car_number3124
3125	44	421	car_number3125
3126	40	124	car_number3126
3127	48	418	car_number3127
3128	47	60	car_number3128
3129	14	449	car_number3129
3130	5	436	car_number3130
3131	44	12	car_number3131
3132	23	60	car_number3132
3133	40	395	car_number3133
3134	26	80	car_number3134
3135	40	141	car_number3135
3136	11	181	car_number3136
3137	25	140	car_number3137
3138	1	373	car_number3138
3139	45	107	car_number3139
3140	25	271	car_number3140
3141	44	230	car_number3141
3142	3	105	car_number3142
3143	33	112	car_number3143
3144	2	422	car_number3144
3145	30	340	car_number3145
3146	5	71	car_number3146
3147	27	319	car_number3147
3148	26	423	car_number3148
3149	32	176	car_number3149
3150	13	245	car_number3150
3151	12	87	car_number3151
3152	8	122	car_number3152
3153	13	283	car_number3153
3154	16	170	car_number3154
3155	31	331	car_number3155
3156	35	323	car_number3156
3157	16	449	car_number3157
3158	44	296	car_number3158
3159	36	78	car_number3159
3160	20	16	car_number3160
3161	17	44	car_number3161
3162	28	170	car_number3162
3163	18	493	car_number3163
3164	43	69	car_number3164
3165	17	202	car_number3165
3166	47	357	car_number3166
3167	34	395	car_number3167
3168	39	253	car_number3168
3169	50	84	car_number3169
3170	29	149	car_number3170
3171	35	375	car_number3171
3172	10	480	car_number3172
3173	35	12	car_number3173
3174	6	387	car_number3174
3175	5	69	car_number3175
3176	33	246	car_number3176
3177	10	56	car_number3177
3178	24	23	car_number3178
3179	48	499	car_number3179
3180	36	328	car_number3180
3181	12	197	car_number3181
3182	37	359	car_number3182
3183	36	316	car_number3183
3184	18	376	car_number3184
3185	22	461	car_number3185
3186	45	157	car_number3186
3187	38	17	car_number3187
3188	13	197	car_number3188
3189	25	138	car_number3189
3190	42	478	car_number3190
3191	10	266	car_number3191
3192	37	500	car_number3192
3193	11	166	car_number3193
3194	1	234	car_number3194
3195	1	10	car_number3195
3196	45	295	car_number3196
3197	41	465	car_number3197
3198	22	100	car_number3198
3199	43	361	car_number3199
3200	3	287	car_number3200
3201	47	357	car_number3201
3202	21	145	car_number3202
3203	11	306	car_number3203
3204	49	116	car_number3204
3205	5	181	car_number3205
3206	38	53	car_number3206
3207	27	154	car_number3207
3208	7	165	car_number3208
3209	46	284	car_number3209
3210	39	303	car_number3210
3211	11	203	car_number3211
3212	16	15	car_number3212
3213	26	70	car_number3213
3214	25	236	car_number3214
3215	30	191	car_number3215
3216	43	134	car_number3216
3217	18	252	car_number3217
3218	38	112	car_number3218
3219	35	339	car_number3219
3220	39	276	car_number3220
3221	41	369	car_number3221
3222	45	441	car_number3222
3223	46	58	car_number3223
3224	48	153	car_number3224
3225	49	405	car_number3225
3226	44	310	car_number3226
3227	24	80	car_number3227
3228	21	378	car_number3228
3229	12	221	car_number3229
3230	4	177	car_number3230
3231	24	83	car_number3231
3232	14	179	car_number3232
3233	3	374	car_number3233
3234	50	98	car_number3234
3235	19	69	car_number3235
3236	12	440	car_number3236
3237	50	64	car_number3237
3238	10	23	car_number3238
3239	36	216	car_number3239
3240	9	16	car_number3240
3241	7	182	car_number3241
3242	11	203	car_number3242
3243	1	351	car_number3243
3244	18	348	car_number3244
3245	25	303	car_number3245
3246	5	431	car_number3246
3247	39	478	car_number3247
3248	24	206	car_number3248
3249	11	490	car_number3249
3250	20	90	car_number3250
3251	23	56	car_number3251
3252	5	483	car_number3252
3253	18	56	car_number3253
3254	40	441	car_number3254
3255	30	96	car_number3255
3256	14	128	car_number3256
3257	36	334	car_number3257
3258	5	82	car_number3258
3259	36	234	car_number3259
3260	37	228	car_number3260
3261	14	429	car_number3261
3262	49	233	car_number3262
3263	12	75	car_number3263
3264	19	372	car_number3264
3265	20	91	car_number3265
3266	45	339	car_number3266
3267	24	249	car_number3267
3268	12	169	car_number3268
3269	6	87	car_number3269
3270	33	307	car_number3270
3271	4	141	car_number3271
3272	26	370	car_number3272
3273	29	419	car_number3273
3274	6	495	car_number3274
3275	7	290	car_number3275
3276	9	310	car_number3276
3277	19	350	car_number3277
3278	45	60	car_number3278
3279	17	448	car_number3279
3280	42	372	car_number3280
3281	11	382	car_number3281
3282	47	149	car_number3282
3283	34	52	car_number3283
3284	29	376	car_number3284
3285	8	364	car_number3285
3286	50	155	car_number3286
3287	34	155	car_number3287
3288	33	333	car_number3288
3289	41	235	car_number3289
3290	26	458	car_number3290
3291	36	45	car_number3291
3292	48	375	car_number3292
3293	29	46	car_number3293
3294	12	302	car_number3294
3295	17	324	car_number3295
3296	21	408	car_number3296
3297	5	395	car_number3297
3298	20	204	car_number3298
3299	32	209	car_number3299
3300	18	109	car_number3300
3301	44	24	car_number3301
3302	31	423	car_number3302
3303	21	497	car_number3303
3304	45	449	car_number3304
3305	22	157	car_number3305
3306	39	29	car_number3306
3307	6	324	car_number3307
3308	9	34	car_number3308
3309	36	95	car_number3309
3310	19	167	car_number3310
3311	6	280	car_number3311
3312	7	56	car_number3312
3313	35	71	car_number3313
3314	47	60	car_number3314
3315	45	143	car_number3315
3316	18	257	car_number3316
3317	22	245	car_number3317
3318	13	52	car_number3318
3319	50	340	car_number3319
3320	29	307	car_number3320
3321	6	457	car_number3321
3322	44	41	car_number3322
3323	24	125	car_number3323
3324	1	98	car_number3324
3325	20	474	car_number3325
3326	22	243	car_number3326
3327	9	255	car_number3327
3328	39	250	car_number3328
3329	36	381	car_number3329
3330	22	473	car_number3330
3331	47	421	car_number3331
3332	32	331	car_number3332
3333	4	198	car_number3333
3334	49	21	car_number3334
3335	14	353	car_number3335
3336	21	263	car_number3336
3337	45	446	car_number3337
3338	30	130	car_number3338
3339	2	120	car_number3339
3340	38	340	car_number3340
3341	12	262	car_number3341
3342	4	492	car_number3342
3343	9	9	car_number3343
3344	8	136	car_number3344
3345	7	7	car_number3345
3346	30	149	car_number3346
3347	48	94	car_number3347
3348	2	290	car_number3348
3349	4	93	car_number3349
3350	16	85	car_number3350
3351	46	64	car_number3351
3352	19	407	car_number3352
3353	24	24	car_number3353
3354	9	441	car_number3354
3355	28	31	car_number3355
3356	33	63	car_number3356
3357	9	261	car_number3357
3358	2	151	car_number3358
3359	24	377	car_number3359
3360	18	149	car_number3360
3361	45	60	car_number3361
3362	33	376	car_number3362
3363	50	483	car_number3363
3364	16	371	car_number3364
3365	27	445	car_number3365
3366	38	177	car_number3366
3367	9	360	car_number3367
3368	37	34	car_number3368
3369	35	94	car_number3369
3370	18	157	car_number3370
3371	11	37	car_number3371
3372	12	185	car_number3372
3373	22	145	car_number3373
3374	46	181	car_number3374
3375	29	240	car_number3375
3376	2	2	car_number3376
3377	33	350	car_number3377
3378	14	28	car_number3378
3379	38	100	car_number3379
3380	34	312	car_number3380
3381	20	197	car_number3381
3382	37	482	car_number3382
3383	24	155	car_number3383
3384	32	444	car_number3384
3385	40	421	car_number3385
3386	3	46	car_number3386
3387	28	98	car_number3387
3388	30	481	car_number3388
3389	25	499	car_number3389
3390	17	25	car_number3390
3391	8	73	car_number3391
3392	37	5	car_number3392
3393	4	151	car_number3393
3394	8	467	car_number3394
3395	14	129	car_number3395
3396	6	428	car_number3396
3397	39	430	car_number3397
3398	32	352	car_number3398
3399	49	287	car_number3399
3400	49	409	car_number3400
3401	34	325	car_number3401
3402	37	274	car_number3402
3403	35	450	car_number3403
3404	2	456	car_number3404
3405	8	400	car_number3405
3406	19	498	car_number3406
3407	5	438	car_number3407
3408	47	65	car_number3408
3409	32	278	car_number3409
3410	15	108	car_number3410
3411	14	107	car_number3411
3412	20	187	car_number3412
3413	4	286	car_number3413
3414	24	96	car_number3414
3415	22	117	car_number3415
3416	46	35	car_number3416
3417	18	271	car_number3417
3418	4	173	car_number3418
3419	21	362	car_number3419
3420	30	75	car_number3420
3421	2	433	car_number3421
3422	2	491	car_number3422
3423	1	179	car_number3423
3424	33	179	car_number3424
3425	8	29	car_number3425
3426	13	453	car_number3426
3427	32	478	car_number3427
3428	40	184	car_number3428
3429	41	269	car_number3429
3430	10	300	car_number3430
3431	9	265	car_number3431
3432	5	240	car_number3432
3433	16	352	car_number3433
3434	46	108	car_number3434
3435	11	362	car_number3435
3436	19	48	car_number3436
3437	10	75	car_number3437
3438	29	331	car_number3438
3439	25	116	car_number3439
3440	45	230	car_number3440
3441	44	302	car_number3441
3442	6	128	car_number3442
3443	11	111	car_number3443
3444	13	375	car_number3444
3445	26	479	car_number3445
3446	33	78	car_number3446
3447	28	407	car_number3447
3448	30	3	car_number3448
3449	30	274	car_number3449
3450	41	199	car_number3450
3451	48	241	car_number3451
3452	1	10	car_number3452
3453	24	193	car_number3453
3454	31	312	car_number3454
3455	34	100	car_number3455
3456	39	419	car_number3456
3457	45	370	car_number3457
3458	10	465	car_number3458
3459	42	156	car_number3459
3460	8	463	car_number3460
3461	21	248	car_number3461
3462	18	425	car_number3462
3463	22	212	car_number3463
3464	5	16	car_number3464
3465	17	272	car_number3465
3466	1	205	car_number3466
3467	15	285	car_number3467
3468	11	164	car_number3468
3469	14	448	car_number3469
3470	37	194	car_number3470
3471	34	350	car_number3471
3472	34	375	car_number3472
3473	38	314	car_number3473
3474	6	398	car_number3474
3475	6	211	car_number3475
3476	35	314	car_number3476
3477	34	395	car_number3477
3478	33	343	car_number3478
3479	46	351	car_number3479
3480	2	236	car_number3480
3481	50	320	car_number3481
3482	26	149	car_number3482
3483	38	34	car_number3483
3484	2	349	car_number3484
3485	12	160	car_number3485
3486	8	337	car_number3486
3487	32	314	car_number3487
3488	43	302	car_number3488
3489	4	28	car_number3489
3490	2	55	car_number3490
3491	45	302	car_number3491
3492	6	185	car_number3492
3493	2	176	car_number3493
3494	36	118	car_number3494
3495	44	454	car_number3495
3496	24	195	car_number3496
3497	2	182	car_number3497
3498	15	381	car_number3498
3499	48	99	car_number3499
3500	16	255	car_number3500
3501	23	183	car_number3501
3502	20	396	car_number3502
3503	28	412	car_number3503
3504	40	92	car_number3504
3505	34	406	car_number3505
3506	3	84	car_number3506
3507	29	473	car_number3507
3508	2	252	car_number3508
3509	17	271	car_number3509
3510	9	400	car_number3510
3511	20	437	car_number3511
3512	29	394	car_number3512
3513	16	148	car_number3513
3514	37	61	car_number3514
3515	25	468	car_number3515
3516	6	59	car_number3516
3517	3	12	car_number3517
3518	32	171	car_number3518
3519	23	66	car_number3519
3520	45	317	car_number3520
3521	28	6	car_number3521
3522	20	323	car_number3522
3523	38	485	car_number3523
3524	13	94	car_number3524
3525	50	52	car_number3525
3526	21	386	car_number3526
3527	3	243	car_number3527
3528	2	333	car_number3528
3529	8	472	car_number3529
3530	24	128	car_number3530
3531	2	384	car_number3531
3532	6	66	car_number3532
3533	1	426	car_number3533
3534	1	52	car_number3534
3535	19	253	car_number3535
3536	10	388	car_number3536
3537	39	272	car_number3537
3538	38	176	car_number3538
3539	15	317	car_number3539
3540	45	67	car_number3540
3541	20	235	car_number3541
3542	22	213	car_number3542
3543	50	471	car_number3543
3544	39	219	car_number3544
3545	10	350	car_number3545
3546	16	411	car_number3546
3547	49	238	car_number3547
3548	26	310	car_number3548
3549	37	378	car_number3549
3550	24	188	car_number3550
3551	22	192	car_number3551
3552	9	193	car_number3552
3553	30	499	car_number3553
3554	8	246	car_number3554
3555	50	120	car_number3555
3556	42	266	car_number3556
3557	30	360	car_number3557
3558	11	160	car_number3558
3559	32	304	car_number3559
3560	12	391	car_number3560
3561	50	238	car_number3561
3562	40	67	car_number3562
3563	34	388	car_number3563
3564	47	213	car_number3564
3565	22	433	car_number3565
3566	15	234	car_number3566
3567	47	353	car_number3567
3568	39	398	car_number3568
3569	27	484	car_number3569
3570	1	498	car_number3570
3571	18	357	car_number3571
3572	23	394	car_number3572
3573	37	172	car_number3573
3574	50	174	car_number3574
3575	17	69	car_number3575
3576	13	305	car_number3576
3577	37	295	car_number3577
3578	46	294	car_number3578
3579	1	418	car_number3579
3580	49	84	car_number3580
3581	48	252	car_number3581
3582	42	466	car_number3582
3583	21	465	car_number3583
3584	32	475	car_number3584
3585	29	143	car_number3585
3586	20	416	car_number3586
3587	20	459	car_number3587
3588	37	452	car_number3588
3589	17	268	car_number3589
3590	28	46	car_number3590
3591	27	225	car_number3591
3592	7	211	car_number3592
3593	31	251	car_number3593
3594	50	151	car_number3594
3595	11	22	car_number3595
3596	3	286	car_number3596
3597	2	463	car_number3597
3598	15	411	car_number3598
3599	6	342	car_number3599
3600	27	332	car_number3600
3601	49	436	car_number3601
3602	50	97	car_number3602
3603	8	428	car_number3603
3604	1	154	car_number3604
3605	45	289	car_number3605
3606	14	166	car_number3606
3607	7	239	car_number3607
3608	3	176	car_number3608
3609	37	145	car_number3609
3610	16	491	car_number3610
3611	29	470	car_number3611
3612	39	26	car_number3612
3613	5	333	car_number3613
3614	3	337	car_number3614
3615	33	396	car_number3615
3616	16	70	car_number3616
3617	2	174	car_number3617
3618	19	65	car_number3618
3619	43	379	car_number3619
3620	18	444	car_number3620
3621	1	428	car_number3621
3622	17	53	car_number3622
3623	38	188	car_number3623
3624	2	410	car_number3624
3625	20	88	car_number3625
3626	45	264	car_number3626
3627	44	165	car_number3627
3628	16	24	car_number3628
3629	43	254	car_number3629
3630	27	380	car_number3630
3631	12	25	car_number3631
3632	31	55	car_number3632
3633	19	138	car_number3633
3634	7	289	car_number3634
3635	40	476	car_number3635
3636	9	454	car_number3636
3637	6	430	car_number3637
3638	29	291	car_number3638
3639	47	398	car_number3639
3640	30	294	car_number3640
3641	11	363	car_number3641
3642	42	62	car_number3642
3643	37	183	car_number3643
3644	35	482	car_number3644
3645	13	325	car_number3645
3646	32	19	car_number3646
3647	24	233	car_number3647
3648	37	107	car_number3648
3649	18	423	car_number3649
3650	10	248	car_number3650
3651	41	354	car_number3651
3652	1	300	car_number3652
3653	47	398	car_number3653
3654	48	43	car_number3654
3655	41	416	car_number3655
3656	32	316	car_number3656
3657	45	48	car_number3657
3658	43	36	car_number3658
3659	1	148	car_number3659
3660	44	200	car_number3660
3661	29	225	car_number3661
3662	30	353	car_number3662
3663	43	178	car_number3663
3664	33	64	car_number3664
3665	39	466	car_number3665
3666	2	465	car_number3666
3667	17	139	car_number3667
3668	49	83	car_number3668
3669	21	184	car_number3669
3670	12	15	car_number3670
3671	36	428	car_number3671
3672	28	129	car_number3672
3673	11	307	car_number3673
3674	38	112	car_number3674
3675	8	139	car_number3675
3676	28	234	car_number3676
3677	1	350	car_number3677
3678	49	146	car_number3678
3679	43	259	car_number3679
3680	20	139	car_number3680
3681	26	132	car_number3681
3682	12	208	car_number3682
3683	4	392	car_number3683
3684	4	361	car_number3684
3685	2	8	car_number3685
3686	6	116	car_number3686
3687	38	100	car_number3687
3688	13	396	car_number3688
3689	39	319	car_number3689
3690	47	365	car_number3690
3691	18	431	car_number3691
3692	11	4	car_number3692
3693	2	45	car_number3693
3694	28	122	car_number3694
3695	20	253	car_number3695
3696	6	402	car_number3696
3697	13	492	car_number3697
3698	26	265	car_number3698
3699	42	399	car_number3699
3700	41	437	car_number3700
3701	25	383	car_number3701
3702	9	374	car_number3702
3703	41	315	car_number3703
3704	17	194	car_number3704
3705	3	19	car_number3705
3706	11	437	car_number3706
3707	45	409	car_number3707
3708	42	288	car_number3708
3709	2	215	car_number3709
3710	39	84	car_number3710
3711	33	267	car_number3711
3712	26	224	car_number3712
3713	39	123	car_number3713
3714	45	460	car_number3714
3715	4	358	car_number3715
3716	23	89	car_number3716
3717	24	217	car_number3717
3718	27	44	car_number3718
3719	36	149	car_number3719
3720	19	330	car_number3720
3721	15	321	car_number3721
3722	5	147	car_number3722
3723	18	255	car_number3723
3724	12	20	car_number3724
3725	9	205	car_number3725
3726	15	5	car_number3726
3727	4	103	car_number3727
3728	45	444	car_number3728
3729	5	18	car_number3729
3730	23	199	car_number3730
3731	23	244	car_number3731
3732	19	402	car_number3732
3733	50	367	car_number3733
3734	29	448	car_number3734
3735	38	62	car_number3735
3736	32	364	car_number3736
3737	27	133	car_number3737
3738	30	357	car_number3738
3739	2	306	car_number3739
3740	25	224	car_number3740
3741	20	411	car_number3741
3742	46	320	car_number3742
3743	39	103	car_number3743
3744	23	43	car_number3744
3745	23	268	car_number3745
3746	11	223	car_number3746
3747	15	159	car_number3747
3748	8	319	car_number3748
3749	44	277	car_number3749
3750	32	400	car_number3750
3751	19	439	car_number3751
3752	22	485	car_number3752
3753	25	416	car_number3753
3754	30	353	car_number3754
3755	21	79	car_number3755
3756	41	473	car_number3756
3757	16	79	car_number3757
3758	19	466	car_number3758
3759	38	102	car_number3759
3760	30	271	car_number3760
3761	11	425	car_number3761
3762	18	453	car_number3762
3763	3	176	car_number3763
3764	25	24	car_number3764
3765	44	94	car_number3765
3766	13	351	car_number3766
3767	17	75	car_number3767
3768	26	197	car_number3768
3769	34	177	car_number3769
3770	11	49	car_number3770
3771	16	460	car_number3771
3772	28	94	car_number3772
3773	25	96	car_number3773
3774	27	229	car_number3774
3775	6	483	car_number3775
3776	33	26	car_number3776
3777	15	41	car_number3777
3778	15	16	car_number3778
3779	19	26	car_number3779
3780	25	236	car_number3780
3781	33	35	car_number3781
3782	41	306	car_number3782
3783	36	282	car_number3783
3784	23	252	car_number3784
3785	32	366	car_number3785
3786	50	250	car_number3786
3787	29	90	car_number3787
3788	22	300	car_number3788
3789	19	108	car_number3789
3790	12	143	car_number3790
3791	7	215	car_number3791
3792	17	500	car_number3792
3793	26	89	car_number3793
3794	29	42	car_number3794
3795	46	131	car_number3795
3796	29	443	car_number3796
3797	26	117	car_number3797
3798	38	93	car_number3798
3799	22	215	car_number3799
3800	25	448	car_number3800
3801	3	34	car_number3801
3802	34	128	car_number3802
3803	47	439	car_number3803
3804	48	464	car_number3804
3805	18	242	car_number3805
3806	33	377	car_number3806
3807	38	101	car_number3807
3808	16	419	car_number3808
3809	1	8	car_number3809
3810	42	7	car_number3810
3811	10	22	car_number3811
3812	47	355	car_number3812
3813	36	84	car_number3813
3814	13	172	car_number3814
3815	10	54	car_number3815
3816	47	98	car_number3816
3817	8	51	car_number3817
3818	23	250	car_number3818
3819	29	166	car_number3819
3820	10	433	car_number3820
3821	10	317	car_number3821
3822	15	78	car_number3822
3823	1	266	car_number3823
3824	15	403	car_number3824
3825	45	262	car_number3825
3826	41	263	car_number3826
3827	22	413	car_number3827
3828	26	32	car_number3828
3829	13	446	car_number3829
3830	32	47	car_number3830
3831	30	8	car_number3831
3832	4	62	car_number3832
3833	1	435	car_number3833
3834	32	25	car_number3834
3835	31	252	car_number3835
3836	30	249	car_number3836
3837	28	428	car_number3837
3838	49	10	car_number3838
3839	1	383	car_number3839
3840	47	466	car_number3840
3841	11	440	car_number3841
3842	16	353	car_number3842
3843	46	82	car_number3843
3844	20	394	car_number3844
3845	23	473	car_number3845
3846	48	343	car_number3846
3847	16	446	car_number3847
3848	46	232	car_number3848
3849	43	258	car_number3849
3850	4	370	car_number3850
3851	37	90	car_number3851
3852	22	141	car_number3852
3853	49	109	car_number3853
3854	44	42	car_number3854
3855	50	277	car_number3855
3856	20	227	car_number3856
3857	32	162	car_number3857
3858	45	58	car_number3858
3859	24	151	car_number3859
3860	1	201	car_number3860
3861	31	118	car_number3861
3862	41	55	car_number3862
3863	1	71	car_number3863
3864	7	125	car_number3864
3865	7	385	car_number3865
3866	48	240	car_number3866
3867	15	272	car_number3867
3868	50	231	car_number3868
3869	19	144	car_number3869
3870	5	188	car_number3870
3871	28	82	car_number3871
3872	45	490	car_number3872
3873	48	360	car_number3873
3874	47	84	car_number3874
3875	15	251	car_number3875
3876	40	256	car_number3876
3877	6	163	car_number3877
3878	41	332	car_number3878
3879	39	4	car_number3879
3880	49	160	car_number3880
3881	36	239	car_number3881
3882	27	375	car_number3882
3883	40	433	car_number3883
3884	23	286	car_number3884
3885	12	456	car_number3885
3886	1	82	car_number3886
3887	42	376	car_number3887
3888	44	75	car_number3888
3889	2	84	car_number3889
3890	3	489	car_number3890
3891	37	458	car_number3891
3892	20	432	car_number3892
3893	49	358	car_number3893
3894	48	42	car_number3894
3895	21	490	car_number3895
3896	2	402	car_number3896
3897	39	148	car_number3897
3898	9	483	car_number3898
3899	48	440	car_number3899
3900	17	405	car_number3900
3901	12	391	car_number3901
3902	16	225	car_number3902
3903	39	438	car_number3903
3904	27	137	car_number3904
3905	30	136	car_number3905
3906	28	77	car_number3906
3907	17	435	car_number3907
3908	48	490	car_number3908
3909	50	150	car_number3909
3910	34	139	car_number3910
3911	23	488	car_number3911
3912	19	460	car_number3912
3913	40	15	car_number3913
3914	44	81	car_number3914
3915	22	259	car_number3915
3916	22	311	car_number3916
3917	24	431	car_number3917
3918	47	281	car_number3918
3919	37	408	car_number3919
3920	25	332	car_number3920
3921	49	257	car_number3921
3922	25	207	car_number3922
3923	28	398	car_number3923
3924	48	137	car_number3924
3925	44	294	car_number3925
3926	39	376	car_number3926
3927	43	22	car_number3927
3928	24	496	car_number3928
3929	13	102	car_number3929
3930	34	32	car_number3930
3931	29	385	car_number3931
3932	50	286	car_number3932
3933	21	455	car_number3933
3934	12	56	car_number3934
3935	27	266	car_number3935
3936	28	383	car_number3936
3937	8	125	car_number3937
3938	13	220	car_number3938
3939	32	426	car_number3939
3940	4	290	car_number3940
3941	12	41	car_number3941
3942	1	420	car_number3942
3943	16	331	car_number3943
3944	46	282	car_number3944
3945	37	30	car_number3945
3946	23	443	car_number3946
3947	13	8	car_number3947
3948	36	339	car_number3948
3949	19	320	car_number3949
3950	33	211	car_number3950
3951	17	44	car_number3951
3952	49	193	car_number3952
3953	29	318	car_number3953
3954	3	401	car_number3954
3955	13	383	car_number3955
3956	20	399	car_number3956
3957	30	313	car_number3957
3958	39	57	car_number3958
3959	32	484	car_number3959
3960	35	243	car_number3960
3961	8	198	car_number3961
3962	34	121	car_number3962
3963	42	194	car_number3963
3964	40	494	car_number3964
3965	6	153	car_number3965
3966	5	102	car_number3966
3967	2	293	car_number3967
3968	39	478	car_number3968
3969	11	255	car_number3969
3970	31	291	car_number3970
3971	30	74	car_number3971
3972	10	245	car_number3972
3973	29	263	car_number3973
3974	8	58	car_number3974
3975	28	149	car_number3975
3976	42	207	car_number3976
3977	21	486	car_number3977
3978	30	248	car_number3978
3979	14	227	car_number3979
3980	10	186	car_number3980
3981	42	96	car_number3981
3982	15	403	car_number3982
3983	28	43	car_number3983
3984	28	240	car_number3984
3985	33	434	car_number3985
3986	26	176	car_number3986
3987	42	482	car_number3987
3988	47	144	car_number3988
3989	19	305	car_number3989
3990	17	209	car_number3990
3991	48	488	car_number3991
3992	19	493	car_number3992
3993	50	83	car_number3993
3994	32	308	car_number3994
3995	30	492	car_number3995
3996	25	118	car_number3996
3997	4	363	car_number3997
3998	31	416	car_number3998
3999	23	54	car_number3999
4000	17	340	car_number4000
4001	24	424	car_number4001
4002	2	307	car_number4002
4003	43	421	car_number4003
4004	5	277	car_number4004
4005	1	500	car_number4005
4006	29	330	car_number4006
4007	30	176	car_number4007
4008	36	16	car_number4008
4009	41	272	car_number4009
4010	22	359	car_number4010
4011	3	275	car_number4011
4012	1	126	car_number4012
4013	20	402	car_number4013
4014	7	478	car_number4014
4015	47	41	car_number4015
4016	29	267	car_number4016
4017	9	469	car_number4017
4018	34	396	car_number4018
4019	7	373	car_number4019
4020	1	167	car_number4020
4021	6	312	car_number4021
4022	27	340	car_number4022
4023	43	184	car_number4023
4024	36	440	car_number4024
4025	2	11	car_number4025
4026	26	166	car_number4026
4027	8	342	car_number4027
4028	49	241	car_number4028
4029	2	235	car_number4029
4030	13	136	car_number4030
4031	32	58	car_number4031
4032	26	176	car_number4032
4033	25	396	car_number4033
4034	40	13	car_number4034
4035	17	230	car_number4035
4036	21	385	car_number4036
4037	44	20	car_number4037
4038	44	347	car_number4038
4039	26	22	car_number4039
4040	36	122	car_number4040
4041	46	353	car_number4041
4042	47	57	car_number4042
4043	22	53	car_number4043
4044	45	120	car_number4044
4045	21	408	car_number4045
4046	38	226	car_number4046
4047	46	18	car_number4047
4048	10	437	car_number4048
4049	41	19	car_number4049
4050	9	440	car_number4050
4051	17	442	car_number4051
4052	14	389	car_number4052
4053	3	19	car_number4053
4054	6	317	car_number4054
4055	20	164	car_number4055
4056	1	289	car_number4056
4057	41	64	car_number4057
4058	9	377	car_number4058
4059	34	95	car_number4059
4060	15	387	car_number4060
4061	31	85	car_number4061
4062	38	86	car_number4062
4063	46	372	car_number4063
4064	33	70	car_number4064
4065	31	187	car_number4065
4066	4	408	car_number4066
4067	11	444	car_number4067
4068	34	394	car_number4068
4069	27	272	car_number4069
4070	46	269	car_number4070
4071	2	320	car_number4071
4072	2	111	car_number4072
4073	45	245	car_number4073
4074	8	392	car_number4074
4075	44	121	car_number4075
4076	27	272	car_number4076
4077	36	424	car_number4077
4078	19	333	car_number4078
4079	36	463	car_number4079
4080	12	290	car_number4080
4081	37	464	car_number4081
4082	18	310	car_number4082
4083	32	429	car_number4083
4084	33	410	car_number4084
4085	26	175	car_number4085
4086	14	4	car_number4086
4087	22	16	car_number4087
4088	17	149	car_number4088
4089	31	441	car_number4089
4090	49	376	car_number4090
4091	12	119	car_number4091
4092	41	407	car_number4092
4093	23	371	car_number4093
4094	12	16	car_number4094
4095	15	50	car_number4095
4096	46	60	car_number4096
4097	11	344	car_number4097
4098	5	475	car_number4098
4099	3	73	car_number4099
4100	35	480	car_number4100
4101	23	28	car_number4101
4102	37	98	car_number4102
4103	29	219	car_number4103
4104	24	126	car_number4104
4105	13	442	car_number4105
4106	25	41	car_number4106
4107	14	180	car_number4107
4108	19	50	car_number4108
4109	39	8	car_number4109
4110	39	365	car_number4110
4111	44	203	car_number4111
4112	23	247	car_number4112
4113	19	458	car_number4113
4114	26	67	car_number4114
4115	6	436	car_number4115
4116	18	95	car_number4116
4117	22	213	car_number4117
4118	39	274	car_number4118
4119	8	131	car_number4119
4120	15	394	car_number4120
4121	30	416	car_number4121
4122	45	348	car_number4122
4123	7	435	car_number4123
4124	20	149	car_number4124
4125	30	435	car_number4125
4126	26	78	car_number4126
4127	48	490	car_number4127
4128	37	414	car_number4128
4129	31	15	car_number4129
4130	1	242	car_number4130
4131	3	50	car_number4131
4132	46	374	car_number4132
4133	44	92	car_number4133
4134	45	66	car_number4134
4135	27	234	car_number4135
4136	13	16	car_number4136
4137	20	108	car_number4137
4138	20	80	car_number4138
4139	9	39	car_number4139
4140	26	386	car_number4140
4141	48	466	car_number4141
4142	37	171	car_number4142
4143	36	153	car_number4143
4144	11	39	car_number4144
4145	41	41	car_number4145
4146	35	394	car_number4146
4147	20	207	car_number4147
4148	18	185	car_number4148
4149	12	178	car_number4149
4150	3	112	car_number4150
4151	16	194	car_number4151
4152	36	448	car_number4152
4153	39	448	car_number4153
4154	50	346	car_number4154
4155	21	489	car_number4155
4156	16	372	car_number4156
4157	40	229	car_number4157
4158	11	430	car_number4158
4159	19	378	car_number4159
4160	22	318	car_number4160
4161	42	108	car_number4161
4162	29	119	car_number4162
4163	6	465	car_number4163
4164	15	167	car_number4164
4165	13	314	car_number4165
4166	36	4	car_number4166
4167	46	142	car_number4167
4168	24	234	car_number4168
4169	6	157	car_number4169
4170	22	275	car_number4170
4171	11	5	car_number4171
4172	39	189	car_number4172
4173	36	168	car_number4173
4174	29	206	car_number4174
4175	31	324	car_number4175
4176	18	142	car_number4176
4177	24	402	car_number4177
4178	30	455	car_number4178
4179	30	10	car_number4179
4180	46	451	car_number4180
4181	28	326	car_number4181
4182	14	70	car_number4182
4183	9	230	car_number4183
4184	4	415	car_number4184
4185	21	420	car_number4185
4186	11	123	car_number4186
4187	40	440	car_number4187
4188	32	422	car_number4188
4189	39	323	car_number4189
4190	10	178	car_number4190
4191	49	117	car_number4191
4192	31	72	car_number4192
4193	47	370	car_number4193
4194	31	34	car_number4194
4195	30	41	car_number4195
4196	25	465	car_number4196
4197	10	303	car_number4197
4198	11	498	car_number4198
4199	13	5	car_number4199
4200	16	401	car_number4200
4201	36	493	car_number4201
4202	49	215	car_number4202
4203	19	129	car_number4203
4204	34	120	car_number4204
4205	13	101	car_number4205
4206	12	409	car_number4206
4207	27	53	car_number4207
4208	4	32	car_number4208
4209	25	18	car_number4209
4210	11	3	car_number4210
4211	23	443	car_number4211
4212	21	275	car_number4212
4213	37	447	car_number4213
4214	4	370	car_number4214
4215	34	101	car_number4215
4216	40	416	car_number4216
4217	8	499	car_number4217
4218	11	442	car_number4218
4219	33	20	car_number4219
4220	28	119	car_number4220
4221	1	329	car_number4221
4222	43	224	car_number4222
4223	19	312	car_number4223
4224	32	240	car_number4224
4225	45	204	car_number4225
4226	9	188	car_number4226
4227	12	461	car_number4227
4228	3	62	car_number4228
4229	14	423	car_number4229
4230	7	403	car_number4230
4231	29	75	car_number4231
4232	22	161	car_number4232
4233	38	434	car_number4233
4234	26	161	car_number4234
4235	50	496	car_number4235
4236	1	4	car_number4236
4237	45	438	car_number4237
4238	7	390	car_number4238
4239	4	196	car_number4239
4240	26	340	car_number4240
4241	28	166	car_number4241
4242	31	132	car_number4242
4243	9	450	car_number4243
4244	49	121	car_number4244
4245	47	445	car_number4245
4246	18	44	car_number4246
4247	40	49	car_number4247
4248	1	219	car_number4248
4249	4	319	car_number4249
4250	37	491	car_number4250
4251	38	3	car_number4251
4252	44	186	car_number4252
4253	24	198	car_number4253
4254	23	113	car_number4254
4255	12	286	car_number4255
4256	38	165	car_number4256
4257	17	87	car_number4257
4258	5	107	car_number4258
4259	27	238	car_number4259
4260	29	293	car_number4260
4261	10	42	car_number4261
4262	24	118	car_number4262
4263	18	488	car_number4263
4264	9	125	car_number4264
4265	15	256	car_number4265
4266	30	430	car_number4266
4267	37	137	car_number4267
4268	48	193	car_number4268
4269	26	257	car_number4269
4270	29	141	car_number4270
4271	43	225	car_number4271
4272	41	11	car_number4272
4273	19	417	car_number4273
4274	26	217	car_number4274
4275	9	432	car_number4275
4276	38	157	car_number4276
4277	28	192	car_number4277
4278	20	340	car_number4278
4279	11	65	car_number4279
4280	39	5	car_number4280
4281	37	261	car_number4281
4282	14	257	car_number4282
4283	20	447	car_number4283
4284	23	496	car_number4284
4285	13	234	car_number4285
4286	32	362	car_number4286
4287	46	349	car_number4287
4288	42	470	car_number4288
4289	25	406	car_number4289
4290	27	470	car_number4290
4291	5	295	car_number4291
4292	43	325	car_number4292
4293	4	223	car_number4293
4294	36	308	car_number4294
4295	27	57	car_number4295
4296	3	497	car_number4296
4297	22	185	car_number4297
4298	12	221	car_number4298
4299	34	205	car_number4299
4300	13	306	car_number4300
4301	4	372	car_number4301
4302	14	185	car_number4302
4303	38	265	car_number4303
4304	39	28	car_number4304
4305	24	121	car_number4305
4306	14	204	car_number4306
4307	27	226	car_number4307
4308	50	65	car_number4308
4309	48	227	car_number4309
4310	26	465	car_number4310
4311	38	164	car_number4311
4312	30	29	car_number4312
4313	45	234	car_number4313
4314	10	495	car_number4314
4315	30	315	car_number4315
4316	1	69	car_number4316
4317	50	435	car_number4317
4318	22	473	car_number4318
4319	38	117	car_number4319
4320	3	213	car_number4320
4321	45	474	car_number4321
4322	30	72	car_number4322
4323	14	220	car_number4323
4324	44	337	car_number4324
4325	17	359	car_number4325
4326	41	198	car_number4326
4327	2	358	car_number4327
4328	43	486	car_number4328
4329	19	249	car_number4329
4330	7	424	car_number4330
4331	2	300	car_number4331
4332	38	254	car_number4332
4333	43	444	car_number4333
4334	47	269	car_number4334
4335	47	82	car_number4335
4336	9	82	car_number4336
4337	18	332	car_number4337
4338	4	30	car_number4338
4339	36	437	car_number4339
4340	14	288	car_number4340
4341	19	364	car_number4341
4342	38	431	car_number4342
4343	25	208	car_number4343
4344	11	281	car_number4344
4345	2	392	car_number4345
4346	37	475	car_number4346
4347	41	37	car_number4347
4348	33	132	car_number4348
4349	33	35	car_number4349
4350	14	373	car_number4350
4351	17	149	car_number4351
4352	35	213	car_number4352
4353	27	259	car_number4353
4354	1	356	car_number4354
4355	29	140	car_number4355
4356	34	338	car_number4356
4357	26	429	car_number4357
4358	49	346	car_number4358
4359	41	35	car_number4359
4360	39	278	car_number4360
4361	25	13	car_number4361
4362	21	326	car_number4362
4363	13	249	car_number4363
4364	40	458	car_number4364
4365	42	271	car_number4365
4366	20	461	car_number4366
4367	40	406	car_number4367
4368	25	327	car_number4368
4369	9	213	car_number4369
4370	30	126	car_number4370
4371	34	460	car_number4371
4372	41	413	car_number4372
4373	20	360	car_number4373
4374	37	38	car_number4374
4375	45	303	car_number4375
4376	16	96	car_number4376
4377	26	24	car_number4377
4378	8	430	car_number4378
4379	43	383	car_number4379
4380	37	13	car_number4380
4381	39	378	car_number4381
4382	33	81	car_number4382
4383	30	47	car_number4383
4384	36	150	car_number4384
4385	36	342	car_number4385
4386	12	237	car_number4386
4387	40	463	car_number4387
4388	14	135	car_number4388
4389	28	475	car_number4389
4390	25	25	car_number4390
4391	10	14	car_number4391
4392	38	276	car_number4392
4393	3	313	car_number4393
4394	29	425	car_number4394
4395	30	124	car_number4395
4396	26	340	car_number4396
4397	15	23	car_number4397
4398	42	173	car_number4398
4399	45	255	car_number4399
4400	17	439	car_number4400
4401	39	359	car_number4401
4402	43	422	car_number4402
4403	25	121	car_number4403
4404	31	316	car_number4404
4405	2	1	car_number4405
4406	12	5	car_number4406
4407	45	279	car_number4407
4408	3	488	car_number4408
4409	8	226	car_number4409
4410	30	414	car_number4410
4411	16	97	car_number4411
4412	25	412	car_number4412
4413	34	32	car_number4413
4414	12	386	car_number4414
4415	39	87	car_number4415
4416	10	2	car_number4416
4417	3	114	car_number4417
4418	8	438	car_number4418
4419	1	226	car_number4419
4420	25	297	car_number4420
4421	29	262	car_number4421
4422	31	239	car_number4422
4423	48	197	car_number4423
4424	6	103	car_number4424
4425	6	228	car_number4425
4426	28	329	car_number4426
4427	43	155	car_number4427
4428	45	295	car_number4428
4429	34	493	car_number4429
4430	9	264	car_number4430
4431	47	94	car_number4431
4432	31	64	car_number4432
4433	36	23	car_number4433
4434	32	148	car_number4434
4435	31	60	car_number4435
4436	37	470	car_number4436
4437	6	100	car_number4437
4438	20	464	car_number4438
4439	36	19	car_number4439
4440	18	13	car_number4440
4441	40	380	car_number4441
4442	29	304	car_number4442
4443	10	343	car_number4443
4444	19	407	car_number4444
4445	13	310	car_number4445
4446	17	13	car_number4446
4447	50	372	car_number4447
4448	17	294	car_number4448
4449	33	35	car_number4449
4450	11	398	car_number4450
4451	28	310	car_number4451
4452	35	272	car_number4452
4453	45	238	car_number4453
4454	32	347	car_number4454
4455	12	126	car_number4455
4456	18	219	car_number4456
4457	9	283	car_number4457
4458	28	355	car_number4458
4459	8	195	car_number4459
4460	42	330	car_number4460
4461	4	284	car_number4461
4462	29	43	car_number4462
4463	9	432	car_number4463
4464	22	384	car_number4464
4465	9	127	car_number4465
4466	20	83	car_number4466
4467	10	13	car_number4467
4468	39	179	car_number4468
4469	27	390	car_number4469
4470	1	473	car_number4470
4471	24	473	car_number4471
4472	6	454	car_number4472
4473	21	339	car_number4473
4474	6	104	car_number4474
4475	7	320	car_number4475
4476	31	58	car_number4476
4477	39	491	car_number4477
4478	32	32	car_number4478
4479	7	349	car_number4479
4480	39	374	car_number4480
4481	28	300	car_number4481
4482	18	95	car_number4482
4483	50	355	car_number4483
4484	21	236	car_number4484
4485	39	299	car_number4485
4486	46	176	car_number4486
4487	36	19	car_number4487
4488	8	338	car_number4488
4489	17	217	car_number4489
4490	11	453	car_number4490
4491	37	175	car_number4491
4492	19	61	car_number4492
4493	43	447	car_number4493
4494	38	457	car_number4494
4495	22	171	car_number4495
4496	29	266	car_number4496
4497	4	129	car_number4497
4498	36	313	car_number4498
4499	33	94	car_number4499
4500	47	230	car_number4500
4501	21	77	car_number4501
4502	41	269	car_number4502
4503	28	360	car_number4503
4504	31	453	car_number4504
4505	48	256	car_number4505
4506	8	401	car_number4506
4507	19	113	car_number4507
4508	38	272	car_number4508
4509	11	100	car_number4509
4510	27	356	car_number4510
4511	47	83	car_number4511
4512	14	191	car_number4512
4513	15	436	car_number4513
4514	5	464	car_number4514
4515	4	287	car_number4515
4516	20	436	car_number4516
4517	46	235	car_number4517
4518	40	452	car_number4518
4519	14	270	car_number4519
4520	40	439	car_number4520
4521	46	374	car_number4521
4522	27	245	car_number4522
4523	3	364	car_number4523
4524	43	272	car_number4524
4525	35	10	car_number4525
4526	40	296	car_number4526
4527	36	87	car_number4527
4528	24	223	car_number4528
4529	15	370	car_number4529
4530	35	148	car_number4530
4531	29	366	car_number4531
4532	11	437	car_number4532
4533	40	388	car_number4533
4534	41	60	car_number4534
4535	32	23	car_number4535
4536	6	450	car_number4536
4537	1	136	car_number4537
4538	3	443	car_number4538
4539	7	281	car_number4539
4540	38	149	car_number4540
4541	6	271	car_number4541
4542	29	162	car_number4542
4543	21	131	car_number4543
4544	11	5	car_number4544
4545	1	405	car_number4545
4546	8	132	car_number4546
4547	25	420	car_number4547
4548	49	128	car_number4548
4549	32	255	car_number4549
4550	16	345	car_number4550
4551	49	16	car_number4551
4552	47	383	car_number4552
4553	35	392	car_number4553
4554	47	411	car_number4554
4555	12	134	car_number4555
4556	32	62	car_number4556
4557	34	406	car_number4557
4558	33	246	car_number4558
4559	14	104	car_number4559
4560	23	115	car_number4560
4561	23	343	car_number4561
4562	45	160	car_number4562
4563	23	295	car_number4563
4564	20	265	car_number4564
4565	9	220	car_number4565
4566	14	177	car_number4566
4567	43	342	car_number4567
4568	25	491	car_number4568
4569	44	215	car_number4569
4570	10	388	car_number4570
4571	41	27	car_number4571
4572	13	448	car_number4572
4573	28	397	car_number4573
4574	50	53	car_number4574
4575	18	170	car_number4575
4576	17	413	car_number4576
4577	22	142	car_number4577
4578	29	147	car_number4578
4579	29	142	car_number4579
4580	2	365	car_number4580
4581	7	407	car_number4581
4582	10	487	car_number4582
4583	38	410	car_number4583
4584	37	312	car_number4584
4585	25	468	car_number4585
4586	43	352	car_number4586
4587	20	409	car_number4587
4588	34	358	car_number4588
4589	12	178	car_number4589
4590	19	88	car_number4590
4591	43	301	car_number4591
4592	44	475	car_number4592
4593	24	175	car_number4593
4594	17	372	car_number4594
4595	16	333	car_number4595
4596	35	301	car_number4596
4597	50	237	car_number4597
4598	13	341	car_number4598
4599	10	189	car_number4599
4600	32	1	car_number4600
4601	28	28	car_number4601
4602	11	440	car_number4602
4603	49	432	car_number4603
4604	1	458	car_number4604
4605	28	430	car_number4605
4606	20	152	car_number4606
4607	16	430	car_number4607
4608	38	332	car_number4608
4609	13	5	car_number4609
4610	49	223	car_number4610
4611	30	375	car_number4611
4612	44	499	car_number4612
4613	48	376	car_number4613
4614	1	223	car_number4614
4615	43	221	car_number4615
4616	26	13	car_number4616
4617	34	14	car_number4617
4618	28	217	car_number4618
4619	9	238	car_number4619
4620	29	359	car_number4620
4621	13	252	car_number4621
4622	27	59	car_number4622
4623	9	251	car_number4623
4624	25	77	car_number4624
4625	37	422	car_number4625
4626	43	186	car_number4626
4627	13	474	car_number4627
4628	44	54	car_number4628
4629	43	90	car_number4629
4630	29	122	car_number4630
4631	23	184	car_number4631
4632	48	309	car_number4632
4633	36	324	car_number4633
4634	8	431	car_number4634
4635	35	313	car_number4635
4636	4	124	car_number4636
4637	27	309	car_number4637
4638	23	315	car_number4638
4639	40	271	car_number4639
4640	38	466	car_number4640
4641	49	77	car_number4641
4642	47	82	car_number4642
4643	41	244	car_number4643
4644	25	244	car_number4644
4645	37	490	car_number4645
4646	11	261	car_number4646
4647	2	435	car_number4647
4648	43	375	car_number4648
4649	16	237	car_number4649
4650	27	195	car_number4650
4651	19	196	car_number4651
4652	4	94	car_number4652
4653	11	441	car_number4653
4654	40	383	car_number4654
4655	20	491	car_number4655
4656	19	153	car_number4656
4657	34	420	car_number4657
4658	26	433	car_number4658
4659	23	192	car_number4659
4660	32	439	car_number4660
4661	12	149	car_number4661
4662	48	408	car_number4662
4663	32	334	car_number4663
4664	24	170	car_number4664
4665	13	456	car_number4665
4666	32	19	car_number4666
4667	16	317	car_number4667
4668	21	42	car_number4668
4669	35	319	car_number4669
4670	29	421	car_number4670
4671	3	421	car_number4671
4672	5	366	car_number4672
4673	36	267	car_number4673
4674	11	249	car_number4674
4675	22	220	car_number4675
4676	21	206	car_number4676
4677	3	260	car_number4677
4678	17	484	car_number4678
4679	42	385	car_number4679
4680	33	151	car_number4680
4681	20	412	car_number4681
4682	9	272	car_number4682
4683	35	441	car_number4683
4684	25	449	car_number4684
4685	32	240	car_number4685
4686	1	268	car_number4686
4687	32	408	car_number4687
4688	1	323	car_number4688
4689	49	319	car_number4689
4690	33	400	car_number4690
4691	9	252	car_number4691
4692	22	465	car_number4692
4693	30	445	car_number4693
4694	27	232	car_number4694
4695	43	381	car_number4695
4696	15	322	car_number4696
4697	23	467	car_number4697
4698	1	169	car_number4698
4699	30	115	car_number4699
4700	46	162	car_number4700
4701	12	101	car_number4701
4702	40	36	car_number4702
4703	2	188	car_number4703
4704	41	407	car_number4704
4705	50	265	car_number4705
4706	28	365	car_number4706
4707	6	464	car_number4707
4708	12	127	car_number4708
4709	27	297	car_number4709
4710	14	384	car_number4710
4711	2	93	car_number4711
4712	20	116	car_number4712
4713	35	186	car_number4713
4714	50	224	car_number4714
4715	10	427	car_number4715
4716	23	400	car_number4716
4717	7	479	car_number4717
4718	39	365	car_number4718
4719	5	158	car_number4719
4720	28	257	car_number4720
4721	43	356	car_number4721
4722	48	463	car_number4722
4723	14	429	car_number4723
4724	46	396	car_number4724
4725	6	403	car_number4725
4726	33	291	car_number4726
4727	49	292	car_number4727
4728	14	251	car_number4728
4729	32	478	car_number4729
4730	18	107	car_number4730
4731	40	459	car_number4731
4732	1	177	car_number4732
4733	16	43	car_number4733
4734	48	444	car_number4734
4735	5	479	car_number4735
4736	35	367	car_number4736
4737	3	156	car_number4737
4738	29	168	car_number4738
4739	38	178	car_number4739
4740	27	119	car_number4740
4741	30	366	car_number4741
4742	34	365	car_number4742
4743	7	334	car_number4743
4744	50	70	car_number4744
4745	47	11	car_number4745
4746	24	439	car_number4746
4747	33	209	car_number4747
4748	23	204	car_number4748
4749	8	443	car_number4749
4750	35	302	car_number4750
4751	48	398	car_number4751
4752	44	480	car_number4752
4753	18	328	car_number4753
4754	30	455	car_number4754
4755	12	452	car_number4755
4756	47	385	car_number4756
4757	45	499	car_number4757
4758	31	277	car_number4758
4759	10	477	car_number4759
4760	32	235	car_number4760
4761	49	351	car_number4761
4762	26	115	car_number4762
4763	46	183	car_number4763
4764	41	86	car_number4764
4765	42	141	car_number4765
4766	30	217	car_number4766
4767	47	330	car_number4767
4768	22	220	car_number4768
4769	23	436	car_number4769
4770	39	14	car_number4770
4771	35	67	car_number4771
4772	4	466	car_number4772
4773	21	447	car_number4773
4774	13	451	car_number4774
4775	5	467	car_number4775
4776	19	443	car_number4776
4777	22	386	car_number4777
4778	48	368	car_number4778
4779	17	459	car_number4779
4780	6	314	car_number4780
4781	7	85	car_number4781
4782	29	418	car_number4782
4783	28	329	car_number4783
4784	29	252	car_number4784
4785	26	345	car_number4785
4786	38	484	car_number4786
4787	33	480	car_number4787
4788	23	38	car_number4788
4789	16	202	car_number4789
4790	11	406	car_number4790
4791	11	57	car_number4791
4792	2	192	car_number4792
4793	8	166	car_number4793
4794	11	294	car_number4794
4795	22	12	car_number4795
4796	9	395	car_number4796
4797	49	336	car_number4797
4798	26	60	car_number4798
4799	42	451	car_number4799
4800	21	220	car_number4800
4801	31	35	car_number4801
4802	7	465	car_number4802
4803	9	319	car_number4803
4804	20	466	car_number4804
4805	45	425	car_number4805
4806	33	297	car_number4806
4807	38	23	car_number4807
4808	46	438	car_number4808
4809	49	65	car_number4809
4810	40	366	car_number4810
4811	34	29	car_number4811
4812	47	476	car_number4812
4813	1	439	car_number4813
4814	11	58	car_number4814
4815	37	252	car_number4815
4816	34	429	car_number4816
4817	1	220	car_number4817
4818	47	423	car_number4818
4819	25	178	car_number4819
4820	23	498	car_number4820
4821	15	89	car_number4821
4822	20	35	car_number4822
4823	44	201	car_number4823
4824	12	99	car_number4824
4825	14	145	car_number4825
4826	1	148	car_number4826
4827	5	298	car_number4827
4828	42	274	car_number4828
4829	49	447	car_number4829
4830	46	266	car_number4830
4831	31	116	car_number4831
4832	9	214	car_number4832
4833	29	179	car_number4833
4834	43	77	car_number4834
4835	48	214	car_number4835
4836	21	138	car_number4836
4837	46	19	car_number4837
4838	10	391	car_number4838
4839	18	487	car_number4839
4840	36	297	car_number4840
4841	30	40	car_number4841
4842	4	458	car_number4842
4843	49	160	car_number4843
4844	11	213	car_number4844
4845	33	454	car_number4845
4846	30	436	car_number4846
4847	22	75	car_number4847
4848	6	435	car_number4848
4849	21	13	car_number4849
4850	46	377	car_number4850
4851	17	281	car_number4851
4852	43	279	car_number4852
4853	15	142	car_number4853
4854	28	178	car_number4854
4855	15	314	car_number4855
4856	43	338	car_number4856
4857	49	96	car_number4857
4858	43	466	car_number4858
4859	12	132	car_number4859
4860	44	335	car_number4860
4861	22	155	car_number4861
4862	48	404	car_number4862
4863	21	31	car_number4863
4864	31	4	car_number4864
4865	16	191	car_number4865
4866	25	307	car_number4866
4867	16	323	car_number4867
4868	15	230	car_number4868
4869	16	59	car_number4869
4870	19	429	car_number4870
4871	33	43	car_number4871
4872	11	170	car_number4872
4873	35	83	car_number4873
4874	42	422	car_number4874
4875	36	317	car_number4875
4876	50	260	car_number4876
4877	7	468	car_number4877
4878	20	52	car_number4878
4879	39	404	car_number4879
4880	50	189	car_number4880
4881	27	259	car_number4881
4882	15	419	car_number4882
4883	43	42	car_number4883
4884	31	235	car_number4884
4885	50	469	car_number4885
4886	5	412	car_number4886
4887	24	26	car_number4887
4888	46	59	car_number4888
4889	28	423	car_number4889
4890	45	16	car_number4890
4891	2	176	car_number4891
4892	19	172	car_number4892
4893	10	184	car_number4893
4894	31	22	car_number4894
4895	30	26	car_number4895
4896	16	305	car_number4896
4897	26	75	car_number4897
4898	34	224	car_number4898
4899	27	276	car_number4899
4900	23	489	car_number4900
4901	35	113	car_number4901
4902	4	35	car_number4902
4903	3	344	car_number4903
4904	47	313	car_number4904
4905	12	12	car_number4905
4906	50	253	car_number4906
4907	48	21	car_number4907
4908	10	21	car_number4908
4909	36	225	car_number4909
4910	5	433	car_number4910
4911	49	55	car_number4911
4912	18	99	car_number4912
4913	43	306	car_number4913
4914	28	385	car_number4914
4915	23	198	car_number4915
4916	50	240	car_number4916
4917	10	412	car_number4917
4918	39	239	car_number4918
4919	50	73	car_number4919
4920	43	262	car_number4920
4921	45	302	car_number4921
4922	33	478	car_number4922
4923	3	287	car_number4923
4924	2	497	car_number4924
4925	7	288	car_number4925
4926	8	238	car_number4926
4927	47	371	car_number4927
4928	15	281	car_number4928
4929	9	363	car_number4929
4930	43	475	car_number4930
4931	9	249	car_number4931
4932	41	382	car_number4932
4933	31	170	car_number4933
4934	28	200	car_number4934
4935	49	50	car_number4935
4936	22	401	car_number4936
4937	25	166	car_number4937
4938	43	427	car_number4938
4939	3	84	car_number4939
4940	28	338	car_number4940
4941	38	346	car_number4941
4942	36	404	car_number4942
4943	24	149	car_number4943
4944	21	55	car_number4944
4945	43	228	car_number4945
4946	5	421	car_number4946
4947	19	204	car_number4947
4948	48	51	car_number4948
4949	28	342	car_number4949
4950	40	378	car_number4950
4951	40	43	car_number4951
4952	49	99	car_number4952
4953	43	129	car_number4953
4954	6	407	car_number4954
4955	22	498	car_number4955
4956	28	224	car_number4956
4957	45	38	car_number4957
4958	34	81	car_number4958
4959	34	53	car_number4959
4960	42	5	car_number4960
4961	45	89	car_number4961
4962	11	336	car_number4962
4963	12	129	car_number4963
4964	19	81	car_number4964
4965	44	189	car_number4965
4966	48	412	car_number4966
4967	30	61	car_number4967
4968	19	273	car_number4968
4969	3	71	car_number4969
4970	9	379	car_number4970
4971	48	183	car_number4971
4972	33	295	car_number4972
4973	26	340	car_number4973
4974	8	47	car_number4974
4975	2	253	car_number4975
4976	47	366	car_number4976
4977	44	82	car_number4977
4978	33	4	car_number4978
4979	40	481	car_number4979
4980	5	199	car_number4980
4981	34	200	car_number4981
4982	13	375	car_number4982
4983	25	155	car_number4983
4984	4	342	car_number4984
4985	50	81	car_number4985
4986	35	125	car_number4986
4987	46	145	car_number4987
4988	44	49	car_number4988
4989	40	7	car_number4989
4990	5	172	car_number4990
4991	7	208	car_number4991
4992	11	418	car_number4992
4993	49	82	car_number4993
4994	12	471	car_number4994
4995	1	389	car_number4995
4996	24	230	car_number4996
4997	4	74	car_number4997
4998	15	320	car_number4998
4999	8	49	car_number4999
5000	20	263	car_number5000
5001	25	128	car_number5001
5002	38	428	car_number5002
5003	22	425	car_number5003
5004	2	150	car_number5004
5005	35	56	car_number5005
5006	15	383	car_number5006
5007	41	157	car_number5007
5008	35	282	car_number5008
5009	47	438	car_number5009
5010	45	91	car_number5010
5011	10	111	car_number5011
5012	28	98	car_number5012
5013	19	137	car_number5013
5014	13	417	car_number5014
5015	1	370	car_number5015
5016	18	65	car_number5016
5017	39	324	car_number5017
5018	23	472	car_number5018
5019	43	338	car_number5019
5020	32	316	car_number5020
5021	14	50	car_number5021
5022	3	179	car_number5022
5023	11	433	car_number5023
5024	26	49	car_number5024
5025	4	414	car_number5025
5026	48	190	car_number5026
5027	41	184	car_number5027
5028	5	157	car_number5028
5029	21	102	car_number5029
5030	24	35	car_number5030
5031	50	340	car_number5031
5032	33	56	car_number5032
5033	12	318	car_number5033
5034	21	277	car_number5034
5035	40	129	car_number5035
5036	12	341	car_number5036
5037	47	348	car_number5037
5038	25	227	car_number5038
5039	17	126	car_number5039
5040	34	393	car_number5040
5041	47	465	car_number5041
5042	13	383	car_number5042
5043	4	319	car_number5043
5044	39	416	car_number5044
5045	8	144	car_number5045
5046	2	169	car_number5046
5047	42	446	car_number5047
5048	37	371	car_number5048
5049	46	235	car_number5049
5050	42	353	car_number5050
5051	33	161	car_number5051
5052	44	10	car_number5052
5053	33	334	car_number5053
5054	27	441	car_number5054
5055	45	109	car_number5055
5056	44	298	car_number5056
5057	45	247	car_number5057
5058	1	113	car_number5058
5059	10	212	car_number5059
5060	32	189	car_number5060
5061	21	173	car_number5061
5062	35	229	car_number5062
5063	27	295	car_number5063
5064	15	57	car_number5064
5065	44	87	car_number5065
5066	3	496	car_number5066
5067	16	133	car_number5067
5068	28	346	car_number5068
5069	21	418	car_number5069
5070	49	483	car_number5070
5071	12	56	car_number5071
5072	24	167	car_number5072
5073	29	58	car_number5073
5074	27	153	car_number5074
5075	45	127	car_number5075
5076	8	437	car_number5076
5077	14	64	car_number5077
5078	30	395	car_number5078
5079	50	460	car_number5079
5080	9	357	car_number5080
5081	27	164	car_number5081
5082	35	30	car_number5082
5083	33	273	car_number5083
5084	9	314	car_number5084
5085	22	427	car_number5085
5086	47	147	car_number5086
5087	3	288	car_number5087
5088	26	144	car_number5088
5089	22	273	car_number5089
5090	18	360	car_number5090
5091	42	265	car_number5091
5092	9	137	car_number5092
5093	35	174	car_number5093
5094	6	413	car_number5094
5095	28	276	car_number5095
5096	4	381	car_number5096
5097	33	34	car_number5097
5098	14	451	car_number5098
5099	19	415	car_number5099
5100	49	236	car_number5100
5101	9	53	car_number5101
5102	26	432	car_number5102
5103	26	126	car_number5103
5104	47	38	car_number5104
5105	28	403	car_number5105
5106	16	382	car_number5106
5107	29	423	car_number5107
5108	31	436	car_number5108
5109	20	364	car_number5109
5110	31	60	car_number5110
5111	36	125	car_number5111
5112	19	216	car_number5112
5113	17	95	car_number5113
5114	1	190	car_number5114
5115	11	356	car_number5115
5116	47	117	car_number5116
5117	41	444	car_number5117
5118	21	127	car_number5118
5119	11	374	car_number5119
5120	9	224	car_number5120
5121	29	251	car_number5121
5122	35	66	car_number5122
5123	12	69	car_number5123
5124	17	234	car_number5124
5125	32	121	car_number5125
5126	1	164	car_number5126
5127	41	296	car_number5127
5128	5	467	car_number5128
5129	19	436	car_number5129
5130	17	188	car_number5130
5131	18	200	car_number5131
5132	47	82	car_number5132
5133	44	299	car_number5133
5134	22	78	car_number5134
5135	5	199	car_number5135
5136	25	352	car_number5136
5137	35	238	car_number5137
5138	45	6	car_number5138
5139	46	500	car_number5139
5140	19	166	car_number5140
5141	1	72	car_number5141
5142	6	211	car_number5142
5143	40	25	car_number5143
5144	9	74	car_number5144
5145	44	59	car_number5145
5146	6	428	car_number5146
5147	29	11	car_number5147
5148	11	196	car_number5148
5149	36	339	car_number5149
5150	28	202	car_number5150
5151	38	440	car_number5151
5152	30	297	car_number5152
5153	13	434	car_number5153
5154	48	284	car_number5154
5155	29	204	car_number5155
5156	49	485	car_number5156
5157	39	12	car_number5157
5158	1	62	car_number5158
5159	11	162	car_number5159
5160	25	55	car_number5160
5161	23	71	car_number5161
5162	21	275	car_number5162
5163	8	329	car_number5163
5164	34	497	car_number5164
5165	46	291	car_number5165
5166	50	328	car_number5166
5167	10	222	car_number5167
5168	30	282	car_number5168
5169	37	90	car_number5169
5170	49	459	car_number5170
5171	36	486	car_number5171
5172	35	287	car_number5172
5173	17	196	car_number5173
5174	38	109	car_number5174
5175	17	80	car_number5175
5176	11	350	car_number5176
5177	3	481	car_number5177
5178	37	186	car_number5178
5179	38	288	car_number5179
5180	26	103	car_number5180
5181	20	435	car_number5181
5182	26	378	car_number5182
5183	44	483	car_number5183
5184	1	203	car_number5184
5185	36	438	car_number5185
5186	39	436	car_number5186
5187	50	332	car_number5187
5188	15	387	car_number5188
5189	44	247	car_number5189
5190	30	58	car_number5190
5191	11	209	car_number5191
5192	33	460	car_number5192
5193	26	473	car_number5193
5194	27	96	car_number5194
5195	12	257	car_number5195
5196	49	311	car_number5196
5197	6	154	car_number5197
5198	11	349	car_number5198
5199	29	381	car_number5199
5200	3	449	car_number5200
5201	20	135	car_number5201
5202	11	15	car_number5202
5203	45	315	car_number5203
5204	7	257	car_number5204
5205	41	369	car_number5205
5206	13	459	car_number5206
5207	40	4	car_number5207
5208	31	127	car_number5208
5209	40	430	car_number5209
5210	7	150	car_number5210
5211	1	312	car_number5211
5212	20	10	car_number5212
5213	33	80	car_number5213
5214	32	463	car_number5214
5215	39	212	car_number5215
5216	14	292	car_number5216
5217	7	406	car_number5217
5218	21	104	car_number5218
5219	6	489	car_number5219
5220	25	422	car_number5220
5221	35	207	car_number5221
5222	16	204	car_number5222
5223	8	341	car_number5223
5224	42	66	car_number5224
5225	24	191	car_number5225
5226	22	126	car_number5226
5227	16	456	car_number5227
5228	43	57	car_number5228
5229	37	428	car_number5229
5230	15	482	car_number5230
5231	31	328	car_number5231
5232	40	195	car_number5232
5233	26	303	car_number5233
5234	28	3	car_number5234
5235	49	479	car_number5235
5236	24	88	car_number5236
5237	13	200	car_number5237
5238	36	102	car_number5238
5239	24	66	car_number5239
5240	45	169	car_number5240
5241	3	265	car_number5241
5242	31	393	car_number5242
5243	36	404	car_number5243
5244	32	173	car_number5244
5245	43	300	car_number5245
5246	12	394	car_number5246
5247	45	63	car_number5247
5248	50	99	car_number5248
5249	16	82	car_number5249
5250	42	485	car_number5250
5251	1	305	car_number5251
5252	41	14	car_number5252
5253	34	123	car_number5253
5254	45	446	car_number5254
5255	13	444	car_number5255
5256	34	88	car_number5256
5257	22	195	car_number5257
5258	41	436	car_number5258
5259	38	180	car_number5259
5260	39	55	car_number5260
5261	43	209	car_number5261
5262	24	483	car_number5262
5263	29	66	car_number5263
5264	49	396	car_number5264
5265	28	321	car_number5265
5266	44	261	car_number5266
5267	24	295	car_number5267
5268	24	154	car_number5268
5269	7	383	car_number5269
5270	6	494	car_number5270
5271	34	161	car_number5271
5272	28	436	car_number5272
5273	33	199	car_number5273
5274	16	425	car_number5274
5275	9	184	car_number5275
5276	16	255	car_number5276
5277	15	495	car_number5277
5278	35	158	car_number5278
5279	41	350	car_number5279
5280	6	18	car_number5280
5281	36	427	car_number5281
5282	5	467	car_number5282
5283	23	27	car_number5283
5284	39	312	car_number5284
5285	15	32	car_number5285
5286	11	26	car_number5286
5287	24	73	car_number5287
5288	41	148	car_number5288
5289	30	394	car_number5289
5290	26	427	car_number5290
5291	36	249	car_number5291
5292	41	260	car_number5292
5293	28	120	car_number5293
5294	30	429	car_number5294
5295	21	91	car_number5295
5296	39	459	car_number5296
5297	21	164	car_number5297
5298	12	17	car_number5298
5299	22	125	car_number5299
5300	48	307	car_number5300
5301	37	303	car_number5301
5302	5	120	car_number5302
5303	31	275	car_number5303
5304	3	477	car_number5304
5305	8	494	car_number5305
5306	9	372	car_number5306
5307	31	12	car_number5307
5308	10	356	car_number5308
5309	37	48	car_number5309
5310	22	90	car_number5310
5311	9	364	car_number5311
5312	25	165	car_number5312
5313	27	306	car_number5313
5314	40	285	car_number5314
5315	32	72	car_number5315
5316	21	363	car_number5316
5317	26	283	car_number5317
5318	31	475	car_number5318
5319	6	149	car_number5319
5320	25	227	car_number5320
5321	9	209	car_number5321
5322	26	373	car_number5322
5323	37	434	car_number5323
5324	37	233	car_number5324
5325	32	345	car_number5325
5326	27	276	car_number5326
5327	25	106	car_number5327
5328	26	173	car_number5328
5329	1	196	car_number5329
5330	46	104	car_number5330
5331	38	203	car_number5331
5332	40	171	car_number5332
5333	5	435	car_number5333
5334	20	278	car_number5334
5335	42	200	car_number5335
5336	40	162	car_number5336
5337	26	187	car_number5337
5338	39	66	car_number5338
5339	35	395	car_number5339
5340	24	481	car_number5340
5341	43	271	car_number5341
5342	6	314	car_number5342
5343	42	426	car_number5343
5344	21	272	car_number5344
5345	27	269	car_number5345
5346	50	274	car_number5346
5347	20	291	car_number5347
5348	4	390	car_number5348
5349	7	240	car_number5349
5350	15	317	car_number5350
5351	6	124	car_number5351
5352	11	350	car_number5352
5353	35	296	car_number5353
5354	21	76	car_number5354
5355	7	171	car_number5355
5356	42	271	car_number5356
5357	8	50	car_number5357
5358	13	134	car_number5358
5359	15	242	car_number5359
5360	35	233	car_number5360
5361	9	33	car_number5361
5362	40	209	car_number5362
5363	44	326	car_number5363
5364	24	463	car_number5364
5365	1	149	car_number5365
5366	13	366	car_number5366
5367	25	1	car_number5367
5368	45	203	car_number5368
5369	34	435	car_number5369
5370	16	287	car_number5370
5371	8	210	car_number5371
5372	44	112	car_number5372
5373	43	305	car_number5373
5374	14	249	car_number5374
5375	4	338	car_number5375
5376	37	38	car_number5376
5377	25	397	car_number5377
5378	43	13	car_number5378
5379	34	166	car_number5379
5380	19	322	car_number5380
5381	41	497	car_number5381
5382	24	423	car_number5382
5383	27	249	car_number5383
5384	8	139	car_number5384
5385	19	142	car_number5385
5386	9	79	car_number5386
5387	50	131	car_number5387
5388	20	268	car_number5388
5389	9	467	car_number5389
5390	3	305	car_number5390
5391	41	489	car_number5391
5392	28	467	car_number5392
5393	19	490	car_number5393
5394	13	127	car_number5394
5395	49	118	car_number5395
5396	23	75	car_number5396
5397	41	115	car_number5397
5398	6	463	car_number5398
5399	38	459	car_number5399
5400	17	154	car_number5400
5401	36	362	car_number5401
5402	33	427	car_number5402
5403	25	475	car_number5403
5404	20	421	car_number5404
5405	6	255	car_number5405
5406	39	177	car_number5406
5407	46	481	car_number5407
5408	23	324	car_number5408
5409	23	325	car_number5409
5410	20	64	car_number5410
5411	35	47	car_number5411
5412	24	446	car_number5412
5413	48	274	car_number5413
5414	44	35	car_number5414
5415	15	210	car_number5415
5416	21	479	car_number5416
5417	26	426	car_number5417
5418	40	21	car_number5418
5419	37	175	car_number5419
5420	41	440	car_number5420
5421	26	213	car_number5421
5422	50	87	car_number5422
5423	9	145	car_number5423
5424	4	236	car_number5424
5425	22	484	car_number5425
5426	27	432	car_number5426
5427	12	449	car_number5427
5428	3	275	car_number5428
5429	34	372	car_number5429
5430	26	89	car_number5430
5431	34	235	car_number5431
5432	32	209	car_number5432
5433	19	492	car_number5433
5434	37	445	car_number5434
5435	32	419	car_number5435
5436	25	205	car_number5436
5437	41	351	car_number5437
5438	29	499	car_number5438
5439	11	421	car_number5439
5440	11	123	car_number5440
5441	44	307	car_number5441
5442	23	496	car_number5442
5443	45	222	car_number5443
5444	20	304	car_number5444
5445	27	313	car_number5445
5446	21	327	car_number5446
5447	26	441	car_number5447
5448	42	483	car_number5448
5449	10	99	car_number5449
5450	7	306	car_number5450
5451	43	111	car_number5451
5452	11	383	car_number5452
5453	9	236	car_number5453
5454	22	380	car_number5454
5455	9	311	car_number5455
5456	29	301	car_number5456
5457	34	142	car_number5457
5458	34	484	car_number5458
5459	26	480	car_number5459
5460	39	483	car_number5460
5461	43	97	car_number5461
5462	21	92	car_number5462
5463	42	180	car_number5463
5464	49	52	car_number5464
5465	13	372	car_number5465
5466	32	137	car_number5466
5467	10	269	car_number5467
5468	31	332	car_number5468
5469	35	177	car_number5469
5470	14	138	car_number5470
5471	44	66	car_number5471
5472	43	433	car_number5472
5473	23	439	car_number5473
5474	48	313	car_number5474
5475	40	327	car_number5475
5476	46	383	car_number5476
5477	38	176	car_number5477
5478	29	170	car_number5478
5479	7	57	car_number5479
5480	4	299	car_number5480
5481	46	227	car_number5481
5482	14	327	car_number5482
5483	37	167	car_number5483
5484	2	381	car_number5484
5485	41	291	car_number5485
5486	32	204	car_number5486
5487	24	72	car_number5487
5488	20	403	car_number5488
5489	44	243	car_number5489
5490	34	275	car_number5490
5491	3	494	car_number5491
5492	42	152	car_number5492
5493	32	259	car_number5493
5494	7	161	car_number5494
5495	19	314	car_number5495
5496	33	487	car_number5496
5497	31	286	car_number5497
5498	19	24	car_number5498
5499	30	319	car_number5499
5500	13	40	car_number5500
5501	41	46	car_number5501
5502	41	145	car_number5502
5503	1	69	car_number5503
5504	44	163	car_number5504
5505	6	290	car_number5505
5506	44	440	car_number5506
5507	21	413	car_number5507
5508	38	345	car_number5508
5509	41	397	car_number5509
5510	16	461	car_number5510
5511	36	241	car_number5511
5512	29	395	car_number5512
5513	6	125	car_number5513
5514	7	246	car_number5514
5515	31	16	car_number5515
5516	21	81	car_number5516
5517	38	323	car_number5517
5518	12	301	car_number5518
5519	47	172	car_number5519
5520	27	432	car_number5520
5521	23	211	car_number5521
5522	26	115	car_number5522
5523	1	278	car_number5523
5524	28	228	car_number5524
5525	11	70	car_number5525
5526	10	286	car_number5526
5527	31	97	car_number5527
5528	19	481	car_number5528
5529	8	269	car_number5529
5530	29	262	car_number5530
5531	38	104	car_number5531
5532	32	55	car_number5532
5533	3	240	car_number5533
5534	39	405	car_number5534
5535	6	139	car_number5535
5536	29	23	car_number5536
5537	29	80	car_number5537
5538	23	335	car_number5538
5539	20	322	car_number5539
5540	49	116	car_number5540
5541	6	315	car_number5541
5542	32	213	car_number5542
5543	26	305	car_number5543
5544	35	232	car_number5544
5545	17	132	car_number5545
5546	39	49	car_number5546
5547	7	352	car_number5547
5548	43	317	car_number5548
5549	3	351	car_number5549
5550	3	426	car_number5550
5551	5	23	car_number5551
5552	7	268	car_number5552
5553	32	111	car_number5553
5554	33	108	car_number5554
5555	4	405	car_number5555
5556	24	214	car_number5556
5557	33	320	car_number5557
5558	13	166	car_number5558
5559	47	500	car_number5559
5560	24	178	car_number5560
5561	20	276	car_number5561
5562	8	93	car_number5562
5563	46	212	car_number5563
5564	4	71	car_number5564
5565	27	360	car_number5565
5566	38	356	car_number5566
5567	21	27	car_number5567
5568	43	222	car_number5568
5569	50	80	car_number5569
5570	28	178	car_number5570
5571	43	318	car_number5571
5572	23	403	car_number5572
5573	23	421	car_number5573
5574	1	326	car_number5574
5575	12	489	car_number5575
5576	12	181	car_number5576
5577	50	137	car_number5577
5578	35	219	car_number5578
5579	23	381	car_number5579
5580	8	38	car_number5580
5581	27	270	car_number5581
5582	4	233	car_number5582
5583	24	353	car_number5583
5584	26	89	car_number5584
5585	49	382	car_number5585
5586	23	218	car_number5586
5587	29	107	car_number5587
5588	6	455	car_number5588
5589	16	164	car_number5589
5590	36	262	car_number5590
5591	37	21	car_number5591
5592	6	350	car_number5592
5593	10	393	car_number5593
5594	5	101	car_number5594
5595	49	167	car_number5595
5596	9	110	car_number5596
5597	30	234	car_number5597
5598	48	259	car_number5598
5599	38	340	car_number5599
5600	13	280	car_number5600
5601	8	66	car_number5601
5602	28	25	car_number5602
5603	21	51	car_number5603
5604	30	464	car_number5604
5605	16	9	car_number5605
5606	35	294	car_number5606
5607	35	221	car_number5607
5608	39	488	car_number5608
5609	35	86	car_number5609
5610	11	23	car_number5610
5611	11	472	car_number5611
5612	45	372	car_number5612
5613	32	483	car_number5613
5614	24	70	car_number5614
5615	31	423	car_number5615
5616	6	59	car_number5616
5617	33	305	car_number5617
5618	32	404	car_number5618
5619	19	389	car_number5619
5620	31	254	car_number5620
5621	20	321	car_number5621
5622	43	219	car_number5622
5623	30	152	car_number5623
5624	11	83	car_number5624
5625	12	134	car_number5625
5626	50	108	car_number5626
5627	26	359	car_number5627
5628	7	153	car_number5628
5629	47	464	car_number5629
5630	37	41	car_number5630
5631	16	431	car_number5631
5632	7	146	car_number5632
5633	47	68	car_number5633
5634	24	124	car_number5634
5635	9	304	car_number5635
5636	25	60	car_number5636
5637	39	342	car_number5637
5638	10	343	car_number5638
5639	40	328	car_number5639
5640	20	78	car_number5640
5641	35	371	car_number5641
5642	41	101	car_number5642
5643	15	393	car_number5643
5644	47	17	car_number5644
5645	27	246	car_number5645
5646	26	272	car_number5646
5647	33	449	car_number5647
5648	36	438	car_number5648
5649	30	263	car_number5649
5650	8	134	car_number5650
5651	28	329	car_number5651
5652	21	247	car_number5652
5653	12	328	car_number5653
5654	47	185	car_number5654
5655	21	13	car_number5655
5656	36	460	car_number5656
5657	44	285	car_number5657
5658	16	97	car_number5658
5659	18	229	car_number5659
5660	29	156	car_number5660
5661	29	353	car_number5661
5662	29	281	car_number5662
5663	6	492	car_number5663
5664	10	261	car_number5664
5665	32	159	car_number5665
5666	26	306	car_number5666
5667	11	47	car_number5667
5668	37	29	car_number5668
5669	25	59	car_number5669
5670	16	12	car_number5670
5671	17	279	car_number5671
5672	46	267	car_number5672
5673	15	50	car_number5673
5674	34	66	car_number5674
5675	25	446	car_number5675
5676	35	248	car_number5676
5677	41	117	car_number5677
5678	12	437	car_number5678
5679	49	247	car_number5679
5680	48	270	car_number5680
5681	1	453	car_number5681
5682	27	85	car_number5682
5683	33	79	car_number5683
5684	25	218	car_number5684
5685	11	48	car_number5685
5686	32	90	car_number5686
5687	13	28	car_number5687
5688	5	403	car_number5688
5689	28	128	car_number5689
5690	17	66	car_number5690
5691	35	319	car_number5691
5692	34	411	car_number5692
5693	7	449	car_number5693
5694	7	402	car_number5694
5695	27	108	car_number5695
5696	29	313	car_number5696
5697	32	172	car_number5697
5698	34	86	car_number5698
5699	20	321	car_number5699
5700	27	281	car_number5700
5701	40	106	car_number5701
5702	40	300	car_number5702
5703	32	355	car_number5703
5704	19	166	car_number5704
5705	4	377	car_number5705
5706	14	9	car_number5706
5707	36	70	car_number5707
5708	36	159	car_number5708
5709	6	339	car_number5709
5710	49	192	car_number5710
5711	8	79	car_number5711
5712	23	132	car_number5712
5713	10	17	car_number5713
5714	23	243	car_number5714
5715	20	137	car_number5715
5716	1	70	car_number5716
5717	4	134	car_number5717
5718	16	96	car_number5718
5719	21	360	car_number5719
5720	15	434	car_number5720
5721	34	320	car_number5721
5722	12	293	car_number5722
5723	1	89	car_number5723
5724	37	464	car_number5724
5725	13	437	car_number5725
5726	21	220	car_number5726
5727	48	141	car_number5727
5728	12	292	car_number5728
5729	21	134	car_number5729
5730	22	42	car_number5730
5731	1	31	car_number5731
5732	6	65	car_number5732
5733	20	42	car_number5733
5734	37	257	car_number5734
5735	32	169	car_number5735
5736	43	276	car_number5736
5737	38	397	car_number5737
5738	16	78	car_number5738
5739	17	36	car_number5739
5740	22	71	car_number5740
5741	36	340	car_number5741
5742	48	214	car_number5742
5743	4	116	car_number5743
5744	46	446	car_number5744
5745	29	358	car_number5745
5746	26	411	car_number5746
5747	11	97	car_number5747
5748	35	275	car_number5748
5749	2	14	car_number5749
5750	37	260	car_number5750
5751	38	448	car_number5751
5752	43	183	car_number5752
5753	47	459	car_number5753
5754	12	225	car_number5754
5755	5	308	car_number5755
5756	6	265	car_number5756
5757	7	394	car_number5757
5758	31	55	car_number5758
5759	15	90	car_number5759
5760	14	290	car_number5760
5761	31	228	car_number5761
5762	22	365	car_number5762
5763	16	393	car_number5763
5764	32	152	car_number5764
5765	41	96	car_number5765
5766	30	476	car_number5766
5767	15	241	car_number5767
5768	27	492	car_number5768
5769	31	230	car_number5769
5770	17	481	car_number5770
5771	19	286	car_number5771
5772	50	28	car_number5772
5773	4	475	car_number5773
5774	43	303	car_number5774
5775	28	261	car_number5775
5776	48	131	car_number5776
5777	27	8	car_number5777
5778	3	220	car_number5778
5779	19	375	car_number5779
5780	6	471	car_number5780
5781	47	318	car_number5781
5782	49	93	car_number5782
5783	35	20	car_number5783
5784	4	132	car_number5784
5785	13	432	car_number5785
5786	33	386	car_number5786
5787	5	102	car_number5787
5788	28	142	car_number5788
5789	33	425	car_number5789
5790	20	125	car_number5790
5791	1	284	car_number5791
5792	47	464	car_number5792
5793	2	383	car_number5793
5794	38	77	car_number5794
5795	16	168	car_number5795
5796	16	357	car_number5796
5797	41	241	car_number5797
5798	44	182	car_number5798
5799	45	279	car_number5799
5800	34	408	car_number5800
5801	31	395	car_number5801
5802	37	365	car_number5802
5803	39	327	car_number5803
5804	11	150	car_number5804
5805	31	355	car_number5805
5806	45	223	car_number5806
5807	5	274	car_number5807
5808	11	422	car_number5808
5809	28	476	car_number5809
5810	35	208	car_number5810
5811	33	380	car_number5811
5812	39	59	car_number5812
5813	50	397	car_number5813
5814	36	128	car_number5814
5815	40	391	car_number5815
5816	43	352	car_number5816
5817	50	7	car_number5817
5818	41	143	car_number5818
5819	7	52	car_number5819
5820	49	361	car_number5820
5821	18	424	car_number5821
5822	3	82	car_number5822
5823	18	398	car_number5823
5824	24	475	car_number5824
5825	49	420	car_number5825
5826	21	362	car_number5826
5827	36	9	car_number5827
5828	34	57	car_number5828
5829	34	447	car_number5829
5830	5	242	car_number5830
5831	46	159	car_number5831
5832	22	351	car_number5832
5833	12	265	car_number5833
5834	5	97	car_number5834
5835	7	77	car_number5835
5836	23	124	car_number5836
5837	33	483	car_number5837
5838	22	137	car_number5838
5839	30	481	car_number5839
5840	23	202	car_number5840
5841	10	268	car_number5841
5842	33	386	car_number5842
5843	24	137	car_number5843
5844	2	373	car_number5844
5845	37	361	car_number5845
5846	37	19	car_number5846
5847	5	226	car_number5847
5848	24	57	car_number5848
5849	20	387	car_number5849
5850	25	432	car_number5850
5851	13	24	car_number5851
5852	5	290	car_number5852
5853	7	132	car_number5853
5854	25	121	car_number5854
5855	8	133	car_number5855
5856	13	17	car_number5856
5857	26	78	car_number5857
5858	48	434	car_number5858
5859	37	422	car_number5859
5860	49	188	car_number5860
5861	6	411	car_number5861
5862	46	164	car_number5862
5863	15	347	car_number5863
5864	3	47	car_number5864
5865	50	301	car_number5865
5866	22	426	car_number5866
5867	28	85	car_number5867
5868	23	158	car_number5868
5869	16	225	car_number5869
5870	41	63	car_number5870
5871	10	443	car_number5871
5872	46	499	car_number5872
5873	5	6	car_number5873
5874	13	398	car_number5874
5875	21	238	car_number5875
5876	33	384	car_number5876
5877	2	401	car_number5877
5878	19	43	car_number5878
5879	12	297	car_number5879
5880	37	493	car_number5880
5881	40	76	car_number5881
5882	38	204	car_number5882
5883	1	219	car_number5883
5884	14	202	car_number5884
5885	13	267	car_number5885
5886	7	72	car_number5886
5887	20	58	car_number5887
5888	5	336	car_number5888
5889	26	224	car_number5889
5890	46	363	car_number5890
5891	37	16	car_number5891
5892	40	244	car_number5892
5893	20	266	car_number5893
5894	38	278	car_number5894
5895	19	171	car_number5895
5896	9	1	car_number5896
5897	14	48	car_number5897
5898	30	95	car_number5898
5899	16	415	car_number5899
5900	28	115	car_number5900
5901	1	193	car_number5901
5902	39	451	car_number5902
5903	22	192	car_number5903
5904	48	479	car_number5904
5905	23	300	car_number5905
5906	38	115	car_number5906
5907	34	477	car_number5907
5908	12	317	car_number5908
5909	1	284	car_number5909
5910	24	281	car_number5910
5911	43	137	car_number5911
5912	24	218	car_number5912
5913	4	217	car_number5913
5914	15	451	car_number5914
5915	29	28	car_number5915
5916	15	324	car_number5916
5917	35	72	car_number5917
5918	37	31	car_number5918
5919	49	173	car_number5919
5920	6	357	car_number5920
5921	25	179	car_number5921
5922	17	372	car_number5922
5923	18	67	car_number5923
5924	5	427	car_number5924
5925	25	320	car_number5925
5926	24	476	car_number5926
5927	27	67	car_number5927
5928	1	401	car_number5928
5929	28	9	car_number5929
5930	35	463	car_number5930
5931	48	203	car_number5931
5932	10	273	car_number5932
5933	4	470	car_number5933
5934	20	297	car_number5934
5935	6	469	car_number5935
5936	19	268	car_number5936
5937	22	153	car_number5937
5938	22	395	car_number5938
5939	30	243	car_number5939
5940	3	495	car_number5940
5941	10	395	car_number5941
5942	35	234	car_number5942
5943	28	415	car_number5943
5944	43	46	car_number5944
5945	8	375	car_number5945
5946	10	66	car_number5946
5947	40	309	car_number5947
5948	49	426	car_number5948
5949	8	467	car_number5949
5950	21	117	car_number5950
5951	11	304	car_number5951
5952	25	341	car_number5952
5953	43	408	car_number5953
5954	4	289	car_number5954
5955	8	463	car_number5955
5956	49	260	car_number5956
5957	29	119	car_number5957
5958	31	335	car_number5958
5959	42	459	car_number5959
5960	39	476	car_number5960
5961	16	102	car_number5961
5962	23	228	car_number5962
5963	24	211	car_number5963
5964	3	274	car_number5964
5965	10	292	car_number5965
5966	21	424	car_number5966
5967	23	430	car_number5967
5968	12	194	car_number5968
5969	34	210	car_number5969
5970	13	25	car_number5970
5971	12	214	car_number5971
5972	42	42	car_number5972
5973	25	63	car_number5973
5974	34	399	car_number5974
5975	20	402	car_number5975
5976	5	408	car_number5976
5977	50	116	car_number5977
5978	27	227	car_number5978
5979	39	146	car_number5979
5980	45	71	car_number5980
5981	18	328	car_number5981
5982	44	230	car_number5982
5983	16	187	car_number5983
5984	17	455	car_number5984
5985	16	265	car_number5985
5986	47	174	car_number5986
5987	26	304	car_number5987
5988	15	221	car_number5988
5989	2	326	car_number5989
5990	1	203	car_number5990
5991	8	212	car_number5991
5992	1	473	car_number5992
5993	7	397	car_number5993
5994	46	55	car_number5994
5995	8	394	car_number5995
5996	24	424	car_number5996
5997	44	381	car_number5997
5998	34	405	car_number5998
5999	45	74	car_number5999
6000	5	55	car_number6000
6001	16	326	car_number6001
6002	25	453	car_number6002
6003	22	404	car_number6003
6004	32	282	car_number6004
6005	36	457	car_number6005
6006	12	253	car_number6006
6007	48	229	car_number6007
6008	25	322	car_number6008
6009	38	158	car_number6009
6010	15	304	car_number6010
6011	14	53	car_number6011
6012	2	150	car_number6012
6013	17	315	car_number6013
6014	42	403	car_number6014
6015	33	395	car_number6015
6016	46	466	car_number6016
6017	45	490	car_number6017
6018	5	453	car_number6018
6019	50	376	car_number6019
6020	13	178	car_number6020
6021	33	88	car_number6021
6022	9	215	car_number6022
6023	33	474	car_number6023
6024	47	153	car_number6024
6025	37	29	car_number6025
6026	24	158	car_number6026
6027	23	241	car_number6027
6028	46	288	car_number6028
6029	22	299	car_number6029
6030	31	114	car_number6030
6031	32	5	car_number6031
6032	31	161	car_number6032
6033	48	158	car_number6033
6034	23	435	car_number6034
6035	40	27	car_number6035
6036	34	273	car_number6036
6037	41	158	car_number6037
6038	2	137	car_number6038
6039	43	144	car_number6039
6040	2	498	car_number6040
6041	9	62	car_number6041
6042	13	42	car_number6042
6043	24	486	car_number6043
6044	11	22	car_number6044
6045	2	358	car_number6045
6046	21	241	car_number6046
6047	23	266	car_number6047
6048	43	39	car_number6048
6049	22	339	car_number6049
6050	13	426	car_number6050
6051	41	28	car_number6051
6052	5	500	car_number6052
6053	13	379	car_number6053
6054	7	193	car_number6054
6055	42	238	car_number6055
6056	7	341	car_number6056
6057	8	162	car_number6057
6058	44	65	car_number6058
6059	4	440	car_number6059
6060	42	207	car_number6060
6061	49	230	car_number6061
6062	19	335	car_number6062
6063	31	417	car_number6063
6064	16	33	car_number6064
6065	21	429	car_number6065
6066	1	272	car_number6066
6067	24	316	car_number6067
6068	19	229	car_number6068
6069	30	158	car_number6069
6070	49	410	car_number6070
6071	43	447	car_number6071
6072	9	122	car_number6072
6073	40	50	car_number6073
6074	47	314	car_number6074
6075	19	204	car_number6075
6076	18	456	car_number6076
6077	45	91	car_number6077
6078	21	142	car_number6078
6079	33	316	car_number6079
6080	21	385	car_number6080
6081	12	333	car_number6081
6082	14	168	car_number6082
6083	37	429	car_number6083
6084	49	482	car_number6084
6085	24	337	car_number6085
6086	30	18	car_number6086
6087	39	376	car_number6087
6088	9	281	car_number6088
6089	29	155	car_number6089
6090	34	71	car_number6090
6091	42	50	car_number6091
6092	29	330	car_number6092
6093	14	406	car_number6093
6094	47	424	car_number6094
6095	15	189	car_number6095
6096	5	287	car_number6096
6097	41	68	car_number6097
6098	4	329	car_number6098
6099	26	99	car_number6099
6100	46	92	car_number6100
6101	33	86	car_number6101
6102	23	87	car_number6102
6103	42	40	car_number6103
6104	39	364	car_number6104
6105	2	294	car_number6105
6106	2	292	car_number6106
6107	38	456	car_number6107
6108	42	182	car_number6108
6109	50	374	car_number6109
6110	35	261	car_number6110
6111	43	374	car_number6111
6112	22	310	car_number6112
6113	20	78	car_number6113
6114	28	237	car_number6114
6115	47	416	car_number6115
6116	20	246	car_number6116
6117	27	83	car_number6117
6118	22	324	car_number6118
6119	23	389	car_number6119
6120	26	185	car_number6120
6121	41	285	car_number6121
6122	9	258	car_number6122
6123	27	217	car_number6123
6124	43	251	car_number6124
6125	26	176	car_number6125
6126	42	166	car_number6126
6127	47	88	car_number6127
6128	7	450	car_number6128
6129	6	76	car_number6129
6130	41	336	car_number6130
6131	31	131	car_number6131
6132	15	221	car_number6132
6133	6	293	car_number6133
6134	24	16	car_number6134
6135	41	136	car_number6135
6136	16	32	car_number6136
6137	32	423	car_number6137
6138	38	343	car_number6138
6139	15	37	car_number6139
6140	48	299	car_number6140
6141	36	282	car_number6141
6142	15	10	car_number6142
6143	31	490	car_number6143
6144	22	439	car_number6144
6145	38	309	car_number6145
6146	12	172	car_number6146
6147	27	391	car_number6147
6148	31	158	car_number6148
6149	7	101	car_number6149
6150	23	416	car_number6150
6151	33	420	car_number6151
6152	17	203	car_number6152
6153	19	350	car_number6153
6154	20	128	car_number6154
6155	13	211	car_number6155
6156	20	174	car_number6156
6157	46	389	car_number6157
6158	16	283	car_number6158
6159	3	62	car_number6159
6160	41	183	car_number6160
6161	2	227	car_number6161
6162	14	219	car_number6162
6163	37	497	car_number6163
6164	10	70	car_number6164
6165	36	130	car_number6165
6166	33	367	car_number6166
6167	13	133	car_number6167
6168	23	294	car_number6168
6169	49	316	car_number6169
6170	2	183	car_number6170
6171	10	450	car_number6171
6172	31	234	car_number6172
6173	35	257	car_number6173
6174	32	175	car_number6174
6175	29	126	car_number6175
6176	29	278	car_number6176
6177	17	63	car_number6177
6178	1	437	car_number6178
6179	50	6	car_number6179
6180	20	167	car_number6180
6181	48	326	car_number6181
6182	46	105	car_number6182
6183	4	351	car_number6183
6184	6	439	car_number6184
6185	10	68	car_number6185
6186	5	118	car_number6186
6187	18	163	car_number6187
6188	32	224	car_number6188
6189	9	419	car_number6189
6190	42	53	car_number6190
6191	22	420	car_number6191
6192	38	422	car_number6192
6193	22	491	car_number6193
6194	34	449	car_number6194
6195	17	490	car_number6195
6196	19	186	car_number6196
6197	13	29	car_number6197
6198	32	344	car_number6198
6199	10	223	car_number6199
6200	35	476	car_number6200
6201	20	434	car_number6201
6202	11	328	car_number6202
6203	14	242	car_number6203
6204	24	72	car_number6204
6205	38	27	car_number6205
6206	10	27	car_number6206
6207	22	158	car_number6207
6208	43	315	car_number6208
6209	47	227	car_number6209
6210	2	500	car_number6210
6211	33	462	car_number6211
6212	10	309	car_number6212
6213	12	412	car_number6213
6214	37	153	car_number6214
6215	42	325	car_number6215
6216	22	344	car_number6216
6217	32	237	car_number6217
6218	31	420	car_number6218
6219	47	476	car_number6219
6220	34	382	car_number6220
6221	10	475	car_number6221
6222	17	281	car_number6222
6223	2	253	car_number6223
6224	16	341	car_number6224
6225	9	47	car_number6225
6226	10	486	car_number6226
6227	26	262	car_number6227
6228	33	471	car_number6228
6229	44	261	car_number6229
6230	2	91	car_number6230
6231	27	311	car_number6231
6232	9	323	car_number6232
6233	1	12	car_number6233
6234	11	14	car_number6234
6235	4	284	car_number6235
6236	39	162	car_number6236
6237	38	490	car_number6237
6238	11	332	car_number6238
6239	23	102	car_number6239
6240	13	92	car_number6240
6241	22	173	car_number6241
6242	38	481	car_number6242
6243	37	339	car_number6243
6244	29	324	car_number6244
6245	5	339	car_number6245
6246	12	202	car_number6246
6247	35	8	car_number6247
6248	49	311	car_number6248
6249	3	72	car_number6249
6250	22	52	car_number6250
6251	13	196	car_number6251
6252	38	395	car_number6252
6253	18	149	car_number6253
6254	8	8	car_number6254
6255	37	399	car_number6255
6256	43	76	car_number6256
6257	24	401	car_number6257
6258	26	478	car_number6258
6259	20	278	car_number6259
6260	32	273	car_number6260
6261	50	193	car_number6261
6262	24	37	car_number6262
6263	42	139	car_number6263
6264	45	351	car_number6264
6265	38	199	car_number6265
6266	1	428	car_number6266
6267	44	258	car_number6267
6268	21	145	car_number6268
6269	24	339	car_number6269
6270	36	215	car_number6270
6271	9	397	car_number6271
6272	36	32	car_number6272
6273	14	477	car_number6273
6274	46	199	car_number6274
6275	1	231	car_number6275
6276	50	442	car_number6276
6277	20	350	car_number6277
6278	6	29	car_number6278
6279	19	72	car_number6279
6280	2	438	car_number6280
6281	49	184	car_number6281
6282	41	105	car_number6282
6283	37	457	car_number6283
6284	44	266	car_number6284
6285	42	181	car_number6285
6286	37	320	car_number6286
6287	9	149	car_number6287
6288	7	111	car_number6288
6289	14	132	car_number6289
6290	16	117	car_number6290
6291	8	385	car_number6291
6292	29	264	car_number6292
6293	24	328	car_number6293
6294	22	268	car_number6294
6295	8	194	car_number6295
6296	23	415	car_number6296
6297	46	134	car_number6297
6298	6	342	car_number6298
6299	41	341	car_number6299
6300	45	368	car_number6300
6301	40	473	car_number6301
6302	3	363	car_number6302
6303	5	144	car_number6303
6304	29	489	car_number6304
6305	30	195	car_number6305
6306	24	33	car_number6306
6307	13	71	car_number6307
6308	20	202	car_number6308
6309	30	123	car_number6309
6310	10	331	car_number6310
6311	22	357	car_number6311
6312	10	497	car_number6312
6313	20	199	car_number6313
6314	43	430	car_number6314
6315	47	51	car_number6315
6316	2	332	car_number6316
6317	5	330	car_number6317
6318	13	153	car_number6318
6319	21	257	car_number6319
6320	27	163	car_number6320
6321	12	281	car_number6321
6322	25	297	car_number6322
6323	19	161	car_number6323
6324	4	339	car_number6324
6325	32	103	car_number6325
6326	35	193	car_number6326
6327	13	402	car_number6327
6328	35	112	car_number6328
6329	33	41	car_number6329
6330	43	432	car_number6330
6331	5	443	car_number6331
6332	22	432	car_number6332
6333	48	247	car_number6333
6334	34	167	car_number6334
6335	9	134	car_number6335
6336	32	16	car_number6336
6337	39	466	car_number6337
6338	47	274	car_number6338
6339	12	376	car_number6339
6340	14	391	car_number6340
6341	46	21	car_number6341
6342	6	181	car_number6342
6343	45	103	car_number6343
6344	12	272	car_number6344
6345	29	42	car_number6345
6346	25	38	car_number6346
6347	13	386	car_number6347
6348	1	126	car_number6348
6349	39	328	car_number6349
6350	26	308	car_number6350
6351	1	474	car_number6351
6352	42	318	car_number6352
6353	8	388	car_number6353
6354	11	194	car_number6354
6355	24	371	car_number6355
6356	13	17	car_number6356
6357	19	49	car_number6357
6358	49	228	car_number6358
6359	14	119	car_number6359
6360	13	68	car_number6360
6361	34	450	car_number6361
6362	20	290	car_number6362
6363	32	418	car_number6363
6364	23	474	car_number6364
6365	8	284	car_number6365
6366	26	288	car_number6366
6367	5	58	car_number6367
6368	46	471	car_number6368
6369	18	481	car_number6369
6370	22	448	car_number6370
6371	2	159	car_number6371
6372	4	120	car_number6372
6373	41	17	car_number6373
6374	40	282	car_number6374
6375	20	130	car_number6375
6376	34	65	car_number6376
6377	18	375	car_number6377
6378	41	244	car_number6378
6379	49	342	car_number6379
6380	33	158	car_number6380
6381	46	30	car_number6381
6382	21	475	car_number6382
6383	38	280	car_number6383
6384	31	250	car_number6384
6385	16	419	car_number6385
6386	41	204	car_number6386
6387	22	226	car_number6387
6388	23	393	car_number6388
6389	32	478	car_number6389
6390	30	486	car_number6390
6391	49	237	car_number6391
6392	27	116	car_number6392
6393	20	260	car_number6393
6394	20	15	car_number6394
6395	41	226	car_number6395
6396	10	221	car_number6396
6397	14	29	car_number6397
6398	44	37	car_number6398
6399	44	304	car_number6399
6400	43	485	car_number6400
6401	1	411	car_number6401
6402	29	280	car_number6402
6403	10	73	car_number6403
6404	22	182	car_number6404
6405	28	115	car_number6405
6406	23	256	car_number6406
6407	43	467	car_number6407
6408	49	199	car_number6408
6409	46	147	car_number6409
6410	16	69	car_number6410
6411	31	392	car_number6411
6412	17	375	car_number6412
6413	42	343	car_number6413
6414	21	254	car_number6414
6415	42	309	car_number6415
6416	38	306	car_number6416
6417	29	434	car_number6417
6418	22	359	car_number6418
6419	39	133	car_number6419
6420	26	472	car_number6420
6421	15	425	car_number6421
6422	12	125	car_number6422
6423	4	397	car_number6423
6424	37	462	car_number6424
6425	12	390	car_number6425
6426	5	76	car_number6426
6427	9	294	car_number6427
6428	43	445	car_number6428
6429	32	246	car_number6429
6430	11	442	car_number6430
6431	50	132	car_number6431
6432	39	278	car_number6432
6433	1	86	car_number6433
6434	44	48	car_number6434
6435	30	34	car_number6435
6436	47	339	car_number6436
6437	3	115	car_number6437
6438	36	428	car_number6438
6439	35	480	car_number6439
6440	21	277	car_number6440
6441	13	474	car_number6441
6442	38	424	car_number6442
6443	14	86	car_number6443
6444	20	368	car_number6444
6445	26	395	car_number6445
6446	22	286	car_number6446
6447	46	384	car_number6447
6448	28	361	car_number6448
6449	50	269	car_number6449
6450	35	166	car_number6450
6451	40	428	car_number6451
6452	17	132	car_number6452
6453	41	459	car_number6453
6454	45	348	car_number6454
6455	10	302	car_number6455
6456	32	101	car_number6456
6457	29	150	car_number6457
6458	36	39	car_number6458
6459	41	440	car_number6459
6460	2	401	car_number6460
6461	30	131	car_number6461
6462	16	211	car_number6462
6463	20	118	car_number6463
6464	24	341	car_number6464
6465	15	137	car_number6465
6466	46	149	car_number6466
6467	19	291	car_number6467
6468	29	125	car_number6468
6469	3	305	car_number6469
6470	45	300	car_number6470
6471	48	317	car_number6471
6472	3	84	car_number6472
6473	14	421	car_number6473
6474	5	466	car_number6474
6475	11	239	car_number6475
6476	11	422	car_number6476
6477	44	214	car_number6477
6478	6	407	car_number6478
6479	13	8	car_number6479
6480	25	499	car_number6480
6481	20	423	car_number6481
6482	30	359	car_number6482
6483	22	207	car_number6483
6484	35	94	car_number6484
6485	49	216	car_number6485
6486	11	67	car_number6486
6487	49	191	car_number6487
6488	4	66	car_number6488
6489	3	497	car_number6489
6490	13	152	car_number6490
6491	14	64	car_number6491
6492	4	175	car_number6492
6493	50	32	car_number6493
6494	14	289	car_number6494
6495	48	279	car_number6495
6496	18	314	car_number6496
6497	24	268	car_number6497
6498	45	154	car_number6498
6499	24	86	car_number6499
6500	32	413	car_number6500
6501	28	229	car_number6501
6502	46	295	car_number6502
6503	47	240	car_number6503
6504	10	321	car_number6504
6505	27	277	car_number6505
6506	11	481	car_number6506
6507	42	327	car_number6507
6508	24	490	car_number6508
6509	44	436	car_number6509
6510	32	443	car_number6510
6511	30	274	car_number6511
6512	8	382	car_number6512
6513	43	323	car_number6513
6514	8	475	car_number6514
6515	24	204	car_number6515
6516	49	300	car_number6516
6517	43	441	car_number6517
6518	17	76	car_number6518
6519	3	315	car_number6519
6520	24	80	car_number6520
6521	45	200	car_number6521
6522	14	479	car_number6522
6523	1	432	car_number6523
6524	44	66	car_number6524
6525	46	210	car_number6525
6526	14	146	car_number6526
6527	50	36	car_number6527
6528	3	375	car_number6528
6529	48	247	car_number6529
6530	27	201	car_number6530
6531	23	248	car_number6531
6532	44	469	car_number6532
6533	4	247	car_number6533
6534	8	136	car_number6534
6535	38	221	car_number6535
6536	11	139	car_number6536
6537	1	192	car_number6537
6538	20	88	car_number6538
6539	37	290	car_number6539
6540	45	417	car_number6540
6541	35	342	car_number6541
6542	14	382	car_number6542
6543	34	90	car_number6543
6544	27	494	car_number6544
6545	29	298	car_number6545
6546	4	125	car_number6546
6547	1	89	car_number6547
6548	15	298	car_number6548
6549	37	283	car_number6549
6550	35	171	car_number6550
6551	10	96	car_number6551
6552	45	300	car_number6552
6553	30	162	car_number6553
6554	21	309	car_number6554
6555	48	465	car_number6555
6556	39	92	car_number6556
6557	28	259	car_number6557
6558	26	149	car_number6558
6559	27	153	car_number6559
6560	18	38	car_number6560
6561	11	104	car_number6561
6562	44	41	car_number6562
6563	41	154	car_number6563
6564	42	438	car_number6564
6565	30	147	car_number6565
6566	47	376	car_number6566
6567	48	231	car_number6567
6568	13	241	car_number6568
6569	5	99	car_number6569
6570	41	232	car_number6570
6571	19	219	car_number6571
6572	43	434	car_number6572
6573	49	375	car_number6573
6574	3	315	car_number6574
6575	33	356	car_number6575
6576	27	282	car_number6576
6577	25	232	car_number6577
6578	9	389	car_number6578
6579	45	341	car_number6579
6580	5	42	car_number6580
6581	33	83	car_number6581
6582	41	130	car_number6582
6583	50	162	car_number6583
6584	40	446	car_number6584
6585	15	231	car_number6585
6586	4	450	car_number6586
6587	3	375	car_number6587
6588	37	86	car_number6588
6589	28	478	car_number6589
6590	15	298	car_number6590
6591	19	21	car_number6591
6592	3	127	car_number6592
6593	15	47	car_number6593
6594	19	234	car_number6594
6595	28	323	car_number6595
6596	9	155	car_number6596
6597	29	369	car_number6597
6598	28	9	car_number6598
6599	4	434	car_number6599
6600	19	254	car_number6600
6601	46	245	car_number6601
6602	16	291	car_number6602
6603	35	287	car_number6603
6604	2	451	car_number6604
6605	36	70	car_number6605
6606	13	315	car_number6606
6607	15	281	car_number6607
6608	18	343	car_number6608
6609	2	318	car_number6609
6610	42	282	car_number6610
6611	7	347	car_number6611
6612	19	158	car_number6612
6613	25	204	car_number6613
6614	6	442	car_number6614
6615	50	253	car_number6615
6616	12	375	car_number6616
6617	47	240	car_number6617
6618	29	10	car_number6618
6619	47	119	car_number6619
6620	24	202	car_number6620
6621	5	151	car_number6621
6622	32	464	car_number6622
6623	4	48	car_number6623
6624	5	344	car_number6624
6625	9	162	car_number6625
6626	19	142	car_number6626
6627	36	201	car_number6627
6628	10	456	car_number6628
6629	18	97	car_number6629
6630	40	235	car_number6630
6631	18	193	car_number6631
6632	43	153	car_number6632
6633	32	338	car_number6633
6634	7	166	car_number6634
6635	27	459	car_number6635
6636	14	336	car_number6636
6637	50	126	car_number6637
6638	49	156	car_number6638
6639	24	401	car_number6639
6640	46	8	car_number6640
6641	32	310	car_number6641
6642	30	139	car_number6642
6643	26	94	car_number6643
6644	5	404	car_number6644
6645	9	76	car_number6645
6646	1	243	car_number6646
6647	47	123	car_number6647
6648	17	399	car_number6648
6649	26	411	car_number6649
6650	32	163	car_number6650
6651	42	304	car_number6651
6652	46	126	car_number6652
6653	34	447	car_number6653
6654	22	372	car_number6654
6655	28	280	car_number6655
6656	39	472	car_number6656
6657	18	433	car_number6657
6658	37	398	car_number6658
6659	33	84	car_number6659
6660	32	303	car_number6660
6661	37	460	car_number6661
6662	15	60	car_number6662
6663	39	339	car_number6663
6664	50	385	car_number6664
6665	11	226	car_number6665
6666	50	107	car_number6666
6667	47	387	car_number6667
6668	36	421	car_number6668
6669	50	85	car_number6669
6670	9	371	car_number6670
6671	6	220	car_number6671
6672	44	60	car_number6672
6673	7	389	car_number6673
6674	28	165	car_number6674
6675	46	456	car_number6675
6676	4	80	car_number6676
6677	37	475	car_number6677
6678	47	395	car_number6678
6679	1	201	car_number6679
6680	17	246	car_number6680
6681	23	15	car_number6681
6682	19	61	car_number6682
6683	32	359	car_number6683
6684	43	429	car_number6684
6685	46	496	car_number6685
6686	9	209	car_number6686
6687	8	441	car_number6687
6688	14	458	car_number6688
6689	24	278	car_number6689
6690	11	143	car_number6690
6691	37	242	car_number6691
6692	16	219	car_number6692
6693	1	54	car_number6693
6694	28	393	car_number6694
6695	14	482	car_number6695
6696	3	350	car_number6696
6697	45	290	car_number6697
6698	22	455	car_number6698
6699	29	138	car_number6699
6700	17	285	car_number6700
6701	47	109	car_number6701
6702	32	413	car_number6702
6703	29	105	car_number6703
6704	34	166	car_number6704
6705	7	302	car_number6705
6706	1	391	car_number6706
6707	28	216	car_number6707
6708	15	180	car_number6708
6709	24	145	car_number6709
6710	27	478	car_number6710
6711	3	34	car_number6711
6712	16	19	car_number6712
6713	19	282	car_number6713
6714	21	6	car_number6714
6715	24	35	car_number6715
6716	35	231	car_number6716
6717	35	197	car_number6717
6718	6	452	car_number6718
6719	16	173	car_number6719
6720	14	240	car_number6720
6721	27	204	car_number6721
6722	20	92	car_number6722
6723	34	182	car_number6723
6724	10	393	car_number6724
6725	25	489	car_number6725
6726	16	112	car_number6726
6727	19	432	car_number6727
6728	45	387	car_number6728
6729	7	359	car_number6729
6730	22	426	car_number6730
6731	20	231	car_number6731
6732	28	346	car_number6732
6733	18	413	car_number6733
6734	19	197	car_number6734
6735	2	243	car_number6735
6736	13	97	car_number6736
6737	20	438	car_number6737
6738	17	208	car_number6738
6739	36	326	car_number6739
6740	33	13	car_number6740
6741	48	381	car_number6741
6742	27	336	car_number6742
6743	29	340	car_number6743
6744	29	489	car_number6744
6745	32	487	car_number6745
6746	1	307	car_number6746
6747	47	498	car_number6747
6748	7	136	car_number6748
6749	39	64	car_number6749
6750	6	265	car_number6750
6751	45	179	car_number6751
6752	37	336	car_number6752
6753	40	191	car_number6753
6754	10	166	car_number6754
6755	39	188	car_number6755
6756	32	30	car_number6756
6757	29	159	car_number6757
6758	6	427	car_number6758
6759	42	97	car_number6759
6760	31	282	car_number6760
6761	33	48	car_number6761
6762	47	200	car_number6762
6763	19	479	car_number6763
6764	10	364	car_number6764
6765	8	50	car_number6765
6766	43	51	car_number6766
6767	37	390	car_number6767
6768	7	143	car_number6768
6769	27	364	car_number6769
6770	46	87	car_number6770
6771	50	247	car_number6771
6772	38	268	car_number6772
6773	47	342	car_number6773
6774	49	439	car_number6774
6775	16	462	car_number6775
6776	45	325	car_number6776
6777	27	391	car_number6777
6778	3	359	car_number6778
6779	25	31	car_number6779
6780	26	279	car_number6780
6781	39	59	car_number6781
6782	50	279	car_number6782
6783	29	370	car_number6783
6784	38	127	car_number6784
6785	17	148	car_number6785
6786	5	493	car_number6786
6787	41	173	car_number6787
6788	3	317	car_number6788
6789	44	341	car_number6789
6790	32	312	car_number6790
6791	26	300	car_number6791
6792	33	78	car_number6792
6793	10	219	car_number6793
6794	2	276	car_number6794
6795	4	435	car_number6795
6796	29	489	car_number6796
6797	46	331	car_number6797
6798	30	285	car_number6798
6799	36	155	car_number6799
6800	22	432	car_number6800
6801	27	402	car_number6801
6802	9	428	car_number6802
6803	8	210	car_number6803
6804	20	18	car_number6804
6805	9	35	car_number6805
6806	31	403	car_number6806
6807	16	296	car_number6807
6808	48	64	car_number6808
6809	28	281	car_number6809
6810	35	163	car_number6810
6811	50	296	car_number6811
6812	27	463	car_number6812
6813	19	300	car_number6813
6814	43	223	car_number6814
6815	13	331	car_number6815
6816	37	175	car_number6816
6817	43	294	car_number6817
6818	7	460	car_number6818
6819	21	243	car_number6819
6820	36	422	car_number6820
6821	43	483	car_number6821
6822	48	169	car_number6822
6823	11	174	car_number6823
6824	17	400	car_number6824
6825	15	65	car_number6825
6826	46	138	car_number6826
6827	25	90	car_number6827
6828	26	484	car_number6828
6829	23	170	car_number6829
6830	20	296	car_number6830
6831	33	76	car_number6831
6832	8	350	car_number6832
6833	4	313	car_number6833
6834	31	366	car_number6834
6835	5	399	car_number6835
6836	45	486	car_number6836
6837	33	274	car_number6837
6838	43	252	car_number6838
6839	34	416	car_number6839
6840	11	32	car_number6840
6841	48	164	car_number6841
6842	6	243	car_number6842
6843	14	177	car_number6843
6844	29	62	car_number6844
6845	3	283	car_number6845
6846	19	196	car_number6846
6847	22	444	car_number6847
6848	44	498	car_number6848
6849	8	397	car_number6849
6850	50	276	car_number6850
6851	32	348	car_number6851
6852	18	23	car_number6852
6853	38	41	car_number6853
6854	31	430	car_number6854
6855	18	134	car_number6855
6856	5	193	car_number6856
6857	32	194	car_number6857
6858	32	36	car_number6858
6859	36	163	car_number6859
6860	15	285	car_number6860
6861	49	167	car_number6861
6862	15	488	car_number6862
6863	45	427	car_number6863
6864	19	188	car_number6864
6865	25	56	car_number6865
6866	1	46	car_number6866
6867	41	211	car_number6867
6868	23	500	car_number6868
6869	6	284	car_number6869
6870	41	300	car_number6870
6871	7	73	car_number6871
6872	42	494	car_number6872
6873	42	145	car_number6873
6874	16	103	car_number6874
6875	16	418	car_number6875
6876	31	102	car_number6876
6877	47	383	car_number6877
6878	41	428	car_number6878
6879	43	444	car_number6879
6880	20	37	car_number6880
6881	2	402	car_number6881
6882	31	453	car_number6882
6883	44	247	car_number6883
6884	38	189	car_number6884
6885	50	47	car_number6885
6886	18	291	car_number6886
6887	14	250	car_number6887
6888	8	369	car_number6888
6889	32	68	car_number6889
6890	11	95	car_number6890
6891	30	390	car_number6891
6892	37	435	car_number6892
6893	19	214	car_number6893
6894	1	203	car_number6894
6895	14	178	car_number6895
6896	14	422	car_number6896
6897	48	289	car_number6897
6898	19	182	car_number6898
6899	3	359	car_number6899
6900	19	333	car_number6900
6901	19	321	car_number6901
6902	14	387	car_number6902
6903	14	479	car_number6903
6904	18	319	car_number6904
6905	41	483	car_number6905
6906	22	436	car_number6906
6907	3	431	car_number6907
6908	46	485	car_number6908
6909	38	112	car_number6909
6910	37	130	car_number6910
6911	49	372	car_number6911
6912	23	435	car_number6912
6913	6	175	car_number6913
6914	31	308	car_number6914
6915	12	263	car_number6915
6916	34	400	car_number6916
6917	3	348	car_number6917
6918	7	392	car_number6918
6919	38	90	car_number6919
6920	36	360	car_number6920
6921	44	282	car_number6921
6922	48	137	car_number6922
6923	33	81	car_number6923
6924	43	350	car_number6924
6925	14	9	car_number6925
6926	42	481	car_number6926
6927	36	60	car_number6927
6928	42	496	car_number6928
6929	27	483	car_number6929
6930	24	486	car_number6930
6931	39	227	car_number6931
6932	40	407	car_number6932
6933	7	337	car_number6933
6934	40	85	car_number6934
6935	18	202	car_number6935
6936	3	123	car_number6936
6937	1	227	car_number6937
6938	47	113	car_number6938
6939	5	248	car_number6939
6940	8	121	car_number6940
6941	11	485	car_number6941
6942	14	195	car_number6942
6943	22	158	car_number6943
6944	45	489	car_number6944
6945	4	353	car_number6945
6946	15	339	car_number6946
6947	32	458	car_number6947
6948	47	443	car_number6948
6949	46	396	car_number6949
6950	8	101	car_number6950
6951	20	300	car_number6951
6952	22	46	car_number6952
6953	34	413	car_number6953
6954	14	189	car_number6954
6955	23	236	car_number6955
6956	29	272	car_number6956
6957	4	323	car_number6957
6958	16	209	car_number6958
6959	1	71	car_number6959
6960	41	87	car_number6960
6961	5	84	car_number6961
6962	19	482	car_number6962
6963	46	289	car_number6963
6964	5	224	car_number6964
6965	40	257	car_number6965
6966	17	305	car_number6966
6967	39	175	car_number6967
6968	17	98	car_number6968
6969	32	101	car_number6969
6970	48	488	car_number6970
6971	32	135	car_number6971
6972	48	329	car_number6972
6973	34	321	car_number6973
6974	3	242	car_number6974
6975	31	338	car_number6975
6976	40	90	car_number6976
6977	30	51	car_number6977
6978	48	131	car_number6978
6979	5	312	car_number6979
6980	2	494	car_number6980
6981	11	361	car_number6981
6982	43	288	car_number6982
6983	37	192	car_number6983
6984	47	113	car_number6984
6985	48	274	car_number6985
6986	9	492	car_number6986
6987	19	493	car_number6987
6988	27	418	car_number6988
6989	5	266	car_number6989
6990	25	370	car_number6990
6991	25	151	car_number6991
6992	50	417	car_number6992
6993	42	279	car_number6993
6994	30	500	car_number6994
6995	28	59	car_number6995
6996	14	155	car_number6996
6997	5	241	car_number6997
6998	26	106	car_number6998
6999	28	498	car_number6999
7000	6	322	car_number7000
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.clients (clients_id, clients_name, clients_tel, adress_id) FROM stdin;
1	name1	380199990585	275
2	name2	380925696802	794
3	name3	380702214592	357
4	name4	380351667281	419
5	name5	380203056461	1074
6	name6	380785222758	919
7	name7	380512890651	520
8	name8	380307780540	1926
9	name9	380338686854	1414
10	name10	380688122277	1330
11	name11	380537996743	754
12	name12	380988187573	867
13	name13	38062865491	1189
14	name14	38086888836	619
15	name15	380540553453	1513
16	name16	380626294551	1238
17	name17	380192244445	1487
18	name18	380783400710	618
19	name19	380533473815	1396
20	name20	380295238022	27
21	name21	380873400186	746
22	name22	380952137023	271
23	name23	380419112423	381
24	name24	380207563705	1454
25	name25	380936953489	1513
26	name26	380367424508	1960
27	name27	380417879563	1418
28	name28	380428388736	1150
29	name29	380331438711	197
30	name30	380940896354	1792
31	name31	380359279142	561
32	name32	380794067454	77
33	name33	380183618371	1130
34	name34	380169412678	380
35	name35	38021190267	1619
36	name36	380774383772	168
37	name37	380500997978	916
38	name38	380465506864	37
39	name39	380884582131	1935
40	name40	380727249736	248
41	name41	380307080134	1418
42	name42	380198428671	1654
43	name43	380336169383	769
44	name44	380772557905	1630
45	name45	380784507678	1447
46	name46	380923623788	256
47	name47	380556444512	1194
48	name48	380486097396	1152
49	name49	380765409632	65
50	name50	380984715925	456
51	name51	38021354010	607
52	name52	380993307725	1698
53	name53	380137332432	87
54	name54	380900561651	1175
55	name55	380809530258	1493
56	name56	380362243764	1932
57	name57	380678089064	1068
58	name58	380619675564	687
59	name59	380220990233	469
60	name60	380569716906	1774
61	name61	380760291722	1842
62	name62	380457344118	757
63	name63	380695729400	176
64	name64	380686544891	1873
65	name65	380808476081	1638
66	name66	380902256030	856
67	name67	380680463513	1560
68	name68	380317693339	661
69	name69	380396428832	43
70	name70	380267795775	673
71	name71	38078316610	1845
72	name72	38089458776	1302
73	name73	380253071211	738
74	name74	380599719741	637
75	name75	380769559311	703
76	name76	38025483582	1713
77	name77	38031131556	1774
78	name78	380271332349	820
79	name79	380592231652	1758
80	name80	380751190708	1402
81	name81	380578585921	1014
82	name82	380187197165	1814
83	name83	380190928213	1862
84	name84	380445187926	1991
85	name85	380248809052	543
86	name86	380567676170	499
87	name87	380492094238	100
88	name88	380477450688	263
89	name89	380867535197	85
90	name90	380443134036	1347
91	name91	380847418900	832
92	name92	380476907192	183
93	name93	380734680723	1504
94	name94	380495543982	306
95	name95	380346479918	1767
96	name96	380722801661	1005
97	name97	380134055071	429
98	name98	380946682722	1194
99	name99	380569481336	1835
100	name100	380900410161	1057
101	name101	380426834609	1192
102	name102	380209424555	1752
103	name103	380405147665	1842
104	name104	380375960166	4
105	name105	380853872102	1027
106	name106	380848284104	1548
107	name107	380162631652	73
108	name108	380779718361	1262
109	name109	380621564324	254
110	name110	380596883824	1245
111	name111	380365323889	267
112	name112	380220043759	469
113	name113	380915828383	1503
114	name114	380266131586	1907
115	name115	380525009219	1203
116	name116	380342762779	709
117	name117	380914095127	1729
118	name118	38063405620	1853
119	name119	380193811694	532
120	name120	380485642426	85
121	name121	380147092188	1384
122	name122	380298904237	1223
123	name123	380406345511	1788
124	name124	380721274819	1446
125	name125	380217161286	1314
126	name126	380552596370	1615
127	name127	380623608221	728
128	name128	380825723981	662
129	name129	380690160956	346
130	name130	380939101301	619
131	name131	380732203386	1024
132	name132	380425331691	793
133	name133	380241498466	1730
134	name134	380166652424	698
135	name135	380936877019	1692
136	name136	380358766283	536
137	name137	380916989862	1458
138	name138	380121505697	158
139	name139	380301134504	1985
140	name140	380822484207	1294
141	name141	380745166409	1742
142	name142	380905309031	29
143	name143	380670536408	956
144	name144	380150141901	1055
145	name145	380254055792	1749
146	name146	380747749383	118
147	name147	38077441631	636
148	name148	380193152771	1688
149	name149	380562718759	298
150	name150	380351060252	905
151	name151	380936388911	861
152	name152	380631663677	1118
153	name153	380261893097	1813
154	name154	380790648816	88
155	name155	380248521676	980
156	name156	380141985170	544
157	name157	380910588450	812
158	name158	380594259434	1263
159	name159	380134630838	166
160	name160	380995332439	541
161	name161	380563614058	966
162	name162	380500924023	1967
163	name163	380693304349	1079
164	name164	380259127579	124
165	name165	380731658604	1281
166	name166	380313780179	553
167	name167	380957745218	214
168	name168	380539710948	1022
169	name169	380749153586	36
170	name170	380314110121	221
171	name171	380517090387	567
172	name172	380945868012	1811
173	name173	380889840498	295
174	name174	380707238053	349
175	name175	380731195298	745
176	name176	380295980960	704
177	name177	380195454189	1830
178	name178	380286915442	669
179	name179	380848132377	727
180	name180	380245869255	1242
181	name181	380854581675	425
182	name182	380899343584	2000
183	name183	380317999927	650
184	name184	38015623089	615
185	name185	380837533866	851
186	name186	380779975722	679
187	name187	380162590250	459
188	name188	380356216142	32
189	name189	380125578873	429
190	name190	380547777430	1703
191	name191	38026186164	425
192	name192	380762792003	177
193	name193	380301356092	1984
194	name194	380647899131	1405
195	name195	3807032588	1977
196	name196	380231759835	970
197	name197	38039571984	44
198	name198	380613048884	508
199	name199	380201278553	1660
200	name200	380921842247	318
201	name201	380466647662	36
202	name202	380397692226	367
203	name203	380121443947	1671
204	name204	380341749580	428
205	name205	380773946823	700
206	name206	380662119223	1734
207	name207	380460398538	440
208	name208	380404092861	6
209	name209	380466286697	1770
210	name210	380633102243	854
211	name211	380630737481	475
212	name212	380189500250	173
213	name213	380315976065	380
214	name214	380635141708	1626
215	name215	380830211581	550
216	name216	380217801705	456
217	name217	380348609703	331
218	name218	380615106415	1370
219	name219	380169061165	1210
220	name220	380663851753	1190
221	name221	380901879245	627
222	name222	380720490335	1653
223	name223	380387873572	1107
224	name224	380351453282	1931
225	name225	380129963105	529
226	name226	380937724376	1876
227	name227	380528725039	1677
228	name228	380655434244	970
229	name229	380946484302	1531
230	name230	380855319796	1755
231	name231	380372292235	1251
232	name232	380112846606	812
233	name233	380747051270	914
234	name234	380143524949	1608
235	name235	380684365919	1684
236	name236	380641260853	906
237	name237	380782124695	1790
238	name238	380397219376	1975
239	name239	380132433235	862
240	name240	380665102524	14
241	name241	380482109584	1669
242	name242	380584644004	1019
243	name243	380833005078	216
244	name244	380117927476	1431
245	name245	380604507684	1866
246	name246	380697093843	763
247	name247	380710064811	1850
248	name248	380505592662	1495
249	name249	380778657702	981
250	name250	380972825331	641
251	name251	380411943504	902
252	name252	380846706988	1691
253	name253	380883640941	759
254	name254	380644224712	1398
255	name255	380316248774	1878
256	name256	38044925035	1999
257	name257	380991564665	1463
258	name258	380855941797	1438
259	name259	380908978355	435
260	name260	380863083035	1272
261	name261	380139506207	885
262	name262	380751535552	393
263	name263	380454049819	1241
264	name264	380260504109	1985
265	name265	380522384138	1292
266	name266	380708649401	1251
267	name267	380663213322	1746
268	name268	38098776388	885
269	name269	380405020284	263
270	name270	3802405337	37
271	name271	380964349109	1026
272	name272	380622815987	642
273	name273	380979394580	1150
274	name274	380431272090	1206
275	name275	380769774682	1614
276	name276	380266074648	230
277	name277	380902925195	1725
278	name278	380489944148	1907
279	name279	380827312204	745
280	name280	380122472137	1712
281	name281	380471505723	252
282	name282	380813710591	618
283	name283	380648033840	1412
284	name284	380362283909	1353
285	name285	380448600934	1392
286	name286	380845465836	668
287	name287	380138975431	1404
288	name288	380262177930	646
289	name289	380896169303	884
290	name290	380940113745	1802
291	name291	380810476290	238
292	name292	380766378794	564
293	name293	380857395774	72
294	name294	380574962595	1200
295	name295	380300578875	83
296	name296	380320175073	1996
297	name297	380113658541	62
298	name298	380585246207	1278
299	name299	380878145923	276
300	name300	380420435089	330
301	name301	380182920654	976
302	name302	380700706670	648
303	name303	380107688229	844
304	name304	38040339801	1902
305	name305	380213557439	1811
306	name306	380384931656	925
307	name307	380928632702	740
308	name308	38015187015	1639
309	name309	380941855763	957
310	name310	380539674773	44
311	name311	380106811798	1748
312	name312	380159001543	790
313	name313	380674027519	464
314	name314	380950645971	430
315	name315	380833860806	1123
316	name316	380432059006	1477
317	name317	380591168952	1185
318	name318	38041311057	189
319	name319	380299133017	1480
320	name320	380839679556	753
321	name321	38090396202	1693
322	name322	380142280155	1260
323	name323	380347473353	213
324	name324	380933279633	1984
325	name325	380415247221	1197
326	name326	380854214859	1512
327	name327	38014142915	1385
328	name328	380154317871	37
329	name329	380306837555	696
330	name330	380413288094	1558
331	name331	380335398934	808
332	name332	380737193183	1151
333	name333	380653294047	1619
334	name334	380194659670	1554
335	name335	380550371000	541
336	name336	380223231658	1849
337	name337	380223392754	1236
338	name338	380498879551	1082
339	name339	380708224216	565
340	name340	380667642155	527
341	name341	380151446904	1459
342	name342	380649420169	361
343	name343	380986077122	1571
344	name344	380505860979	716
345	name345	380270304114	1586
346	name346	380730614107	1227
347	name347	380310285935	26
348	name348	380524301800	230
349	name349	38059420883	1770
350	name350	380261204425	863
351	name351	380399680928	700
352	name352	38020560681	93
353	name353	380542613132	555
354	name354	380929697076	861
355	name355	380247934690	1446
356	name356	380685105602	674
357	name357	380108085885	625
358	name358	380617058701	429
359	name359	380607869566	1650
360	name360	380964038004	1158
361	name361	380870199556	343
362	name362	380156473725	1944
363	name363	380898211974	941
364	name364	380222408449	1162
365	name365	380802236415	58
366	name366	380188432604	1656
367	name367	380428738399	1171
368	name368	380299682278	1617
369	name369	380661915025	1333
370	name370	380575063467	1259
371	name371	380129220979	1740
372	name372	380491292010	168
373	name373	380441914579	429
374	name374	380856162643	992
375	name375	380407983506	31
376	name376	380388913926	343
377	name377	380207191426	490
378	name378	380329770964	1390
379	name379	38084760733	586
380	name380	380731424697	456
381	name381	380245998438	398
382	name382	380394452553	370
383	name383	380908078845	69
384	name384	380650812761	517
385	name385	380244480647	446
386	name386	380623856445	1605
387	name387	380238332234	1518
388	name388	380713146359	1125
389	name389	380993369437	319
390	name390	380684999080	275
391	name391	380453534995	485
392	name392	380552668419	604
393	name393	38013108976	698
394	name394	380141442793	1832
395	name395	380305414270	971
396	name396	380853955696	466
397	name397	380519824202	401
398	name398	380585732213	317
399	name399	380249750464	943
400	name400	380957728545	1399
401	name401	380693605966	612
402	name402	380559782340	924
403	name403	38017945697	1442
404	name404	380533336181	999
405	name405	380112997540	1456
406	name406	380688209166	1839
407	name407	380848630621	615
408	name408	380986303195	1988
409	name409	380111294149	1064
410	name410	380161801545	1141
411	name411	380711240011	1324
412	name412	380541864094	1817
413	name413	380332915056	173
414	name414	380663521740	421
415	name415	38021063344	956
416	name416	38082516703	1859
417	name417	380828902518	983
418	name418	380477787110	895
419	name419	380151097096	985
420	name420	380714800085	85
421	name421	38052395359	1940
422	name422	380518646993	329
423	name423	38014504578	1447
424	name424	380921381088	550
425	name425	380286193301	1620
426	name426	380460272353	1503
427	name427	38037666113	553
428	name428	380820873495	762
429	name429	380559373382	863
430	name430	380863491448	238
431	name431	380523341026	1687
432	name432	380139497889	663
433	name433	380458068078	1584
434	name434	380927628001	86
435	name435	380162652545	1851
436	name436	380703726469	141
437	name437	380392317924	1601
438	name438	380223449427	742
439	name439	380880361282	1492
440	name440	380627578122	1898
441	name441	380597345877	484
442	name442	380899556855	209
443	name443	380267751467	1304
444	name444	380506492727	1068
445	name445	380190268063	603
446	name446	380523116341	755
447	name447	380189580758	1761
448	name448	380284102870	1357
449	name449	3804382425	912
450	name450	380991637109	1530
451	name451	380254728203	1120
452	name452	380549243648	1367
453	name453	380230614657	393
454	name454	380113868149	395
455	name455	380363829829	1928
456	name456	380696829824	1015
457	name457	380422926326	1067
458	name458	380236254414	1742
459	name459	380531356565	273
460	name460	38074542151	108
461	name461	380500604736	114
462	name462	380121338470	1530
463	name463	380304928696	354
464	name464	380192483923	1341
465	name465	380600084456	1324
466	name466	380553708077	1916
467	name467	380942463930	1597
468	name468	380628102664	1133
469	name469	380102648104	1900
470	name470	380448395144	81
471	name471	380769936496	310
472	name472	38074853018	579
473	name473	380767995479	1846
474	name474	380609972115	1173
475	name475	380931621513	514
476	name476	380299563280	588
477	name477	380528857080	1351
478	name478	380485038382	1082
479	name479	380803876287	962
480	name480	380657642346	1123
481	name481	380305786897	62
482	name482	380966537194	1825
483	name483	380306557199	1710
484	name484	380412634020	1970
485	name485	380856851839	630
486	name486	380448712911	1988
487	name487	380987501573	629
488	name488	380890824361	118
489	name489	380622617655	1979
490	name490	380252954775	781
491	name491	380240157409	279
492	name492	380524392938	1657
493	name493	380216715389	1251
494	name494	380306846889	706
495	name495	380148084105	1920
496	name496	380977853328	1607
497	name497	380366084859	1253
498	name498	380574150136	969
499	name499	380928963513	1202
500	name500	380770259589	328
501	name501	380958083776	1943
502	name502	380418000617	564
503	name503	380611866759	1050
504	name504	380385996865	839
505	name505	380404999732	1429
506	name506	380502266224	1669
507	name507	380652357358	648
508	name508	380674183235	206
509	name509	380806708682	96
510	name510	380368828432	283
511	name511	380538739363	1677
512	name512	38063169441	517
513	name513	380661514499	159
514	name514	380796745604	827
515	name515	380828169578	862
516	name516	380532840947	1308
517	name517	380941431133	415
518	name518	380981127468	1106
519	name519	380372859369	1796
520	name520	380492035665	1280
521	name521	380774808454	630
522	name522	380446553111	1033
523	name523	38044233362	1039
524	name524	380378148575	1359
525	name525	380345356594	733
526	name526	380116567263	133
527	name527	380967353386	501
528	name528	380435783986	490
529	name529	380767018021	1391
530	name530	380734887097	1162
531	name531	380960445474	1558
532	name532	380324145387	1804
533	name533	380989123314	1671
534	name534	380716264533	423
535	name535	380496899610	1684
536	name536	380859854263	538
537	name537	380351822193	323
538	name538	380789422472	1715
539	name539	380422185337	1233
540	name540	380812320978	975
541	name541	380389507307	878
542	name542	380478187723	1399
543	name543	380858905257	281
544	name544	380550035456	864
545	name545	380277071276	498
546	name546	380500074094	459
547	name547	380103482084	647
548	name548	380883710856	41
549	name549	380853208954	1354
550	name550	380697446273	1331
551	name551	380882157181	1637
552	name552	380389732519	1481
553	name553	380125073452	509
554	name554	380761464318	1805
555	name555	380507108521	432
556	name556	380126594951	1807
557	name557	380263517761	413
558	name558	38072839840	1587
559	name559	380311237915	642
560	name560	380107834366	857
561	name561	380307630217	54
562	name562	380728723870	925
563	name563	380188820030	794
564	name564	380375391066	1457
565	name565	380596653360	1352
566	name566	380717613030	805
567	name567	380215663424	719
568	name568	380563497627	791
569	name569	380587638326	1824
570	name570	380162950502	1829
571	name571	380644245490	1010
572	name572	380569343151	282
573	name573	380464932409	1152
574	name574	380203181518	1948
575	name575	380184612942	1859
576	name576	380295293687	1035
577	name577	380335052438	1550
578	name578	380986595209	1803
579	name579	380399476351	516
580	name580	380418862032	580
581	name581	380875512630	191
582	name582	380211665722	332
583	name583	380411285307	1191
584	name584	380129549334	1165
585	name585	380882229195	1353
586	name586	380869241091	397
587	name587	380480189075	1840
588	name588	380672884110	489
589	name589	38066316745	134
590	name590	380276388551	1315
591	name591	380545330291	1082
592	name592	380116344157	1589
593	name593	380782150077	842
594	name594	38020685264	1661
595	name595	380599175203	425
596	name596	380832371288	1586
597	name597	380734840670	5
598	name598	380149063996	1111
599	name599	380997467463	1293
600	name600	380941510637	151
601	name601	380492746883	611
602	name602	380380929524	1892
603	name603	38098442392	1349
604	name604	380113083254	516
605	name605	380210901875	182
606	name606	380548223727	593
607	name607	380217319205	780
608	name608	380249115688	40
609	name609	38011530301	1589
610	name610	38065630808	72
611	name611	380909588795	1079
612	name612	380325011024	1981
613	name613	380140985373	1568
614	name614	380415499086	852
615	name615	380333648550	654
616	name616	3801285229	943
617	name617	380266948545	1519
618	name618	380250757771	891
619	name619	380554942258	861
620	name620	380106368475	1640
621	name621	38049696375	1970
622	name622	380334696256	973
623	name623	380445606578	663
624	name624	380100866155	1498
625	name625	380636379650	919
626	name626	380661645134	979
627	name627	380501994840	341
628	name628	380626796408	1164
629	name629	380722930212	1870
630	name630	380453172630	1165
631	name631	380784258176	1480
632	name632	3807302930	132
633	name633	380805387526	1190
634	name634	380469332779	1472
635	name635	3804952236	513
636	name636	380457441503	917
637	name637	380717721675	648
638	name638	38085842783	1689
639	name639	380925569009	1584
640	name640	380987238782	1946
641	name641	380308848476	1060
642	name642	380691021843	867
643	name643	380919756756	1269
644	name644	380794830319	1418
645	name645	380445337493	1047
646	name646	380179212693	343
647	name647	380229200642	366
648	name648	380958734351	1883
649	name649	380501781435	1436
650	name650	380141675425	949
651	name651	380862731553	721
652	name652	380620966329	999
653	name653	380197027240	1820
654	name654	380966161237	1283
655	name655	380701874790	1950
656	name656	380611629399	567
657	name657	380396191722	512
658	name658	380590236783	1827
659	name659	380498032874	1638
660	name660	380683835771	1666
661	name661	380185949511	510
662	name662	380451758246	1566
663	name663	380539731747	1424
664	name664	380616456053	700
665	name665	380769964706	549
666	name666	38036633248	1879
667	name667	380685386159	1871
668	name668	380390515929	275
669	name669	380164141775	1656
670	name670	380836228754	295
671	name671	380691022100	857
672	name672	380270444816	1142
673	name673	380204822311	1755
674	name674	380944679379	37
675	name675	380697120893	284
676	name676	380819337252	1458
677	name677	380440003876	621
678	name678	380603243357	1616
679	name679	380898634917	1466
680	name680	380871547444	74
681	name681	380242581867	1567
682	name682	380841188191	1223
683	name683	380722308148	1235
684	name684	38078058541	1796
685	name685	380169616722	1069
686	name686	380780034943	30
687	name687	380831379625	1531
688	name688	380460033551	420
689	name689	380662433373	1257
690	name690	380923044610	879
691	name691	380415843848	1893
692	name692	380161772247	327
693	name693	380624319243	325
694	name694	380810412332	1850
695	name695	38093602893	1195
696	name696	380322100658	122
697	name697	380976677792	1889
698	name698	380201690620	970
699	name699	380321609826	973
700	name700	380297264735	736
701	name701	380747318292	1594
702	name702	380572561718	1042
703	name703	380114635876	1163
704	name704	380811070178	1580
705	name705	380618345576	1773
706	name706	380258416875	1778
707	name707	380601383825	1710
708	name708	380499814176	345
709	name709	380703707702	216
710	name710	380320597067	717
711	name711	380162731239	856
712	name712	380609124677	1487
713	name713	380951341169	1386
714	name714	380884050861	1699
715	name715	380634958641	1153
716	name716	380713916546	39
717	name717	380301124278	1247
718	name718	380732140983	786
719	name719	3802563453	1328
720	name720	380526174534	131
721	name721	380172235799	1040
722	name722	380733077013	1979
723	name723	380721969681	892
724	name724	380461188024	163
725	name725	380112370082	1741
726	name726	380803787855	1223
727	name727	38021029914	1560
728	name728	380312324946	460
729	name729	380392557445	882
730	name730	380634919501	1688
731	name731	380312219257	274
732	name732	380376699896	1116
733	name733	380866681906	109
734	name734	38052121378	1446
735	name735	380983004490	1739
736	name736	380746547048	508
737	name737	380691403408	1168
738	name738	380374063706	1072
739	name739	380918825023	583
740	name740	380379259877	1795
741	name741	380192930413	708
742	name742	380350028908	1075
743	name743	380946859168	128
744	name744	380456539713	1730
745	name745	380710427493	1236
746	name746	380575887720	548
747	name747	380127308995	847
748	name748	380491661575	305
749	name749	38095882973	165
750	name750	380756375373	80
751	name751	380268983552	1135
752	name752	380523401417	1398
753	name753	380426730373	971
754	name754	380816520537	1214
755	name755	380903782683	1904
756	name756	380503681651	935
757	name757	380625765797	1010
758	name758	380881669819	1521
759	name759	38057195992	281
760	name760	380929614370	602
761	name761	38083908247	1574
762	name762	380212738878	1305
763	name763	380726672909	601
764	name764	380753612016	546
765	name765	38061712516	93
766	name766	380673177934	1639
767	name767	380894854217	1468
768	name768	380319975915	337
769	name769	380887491494	707
770	name770	380541859938	1607
771	name771	380918971954	1652
772	name772	380293372237	550
773	name773	380571287940	841
774	name774	3804252	1230
775	name775	380150637393	1296
776	name776	380362495029	1175
777	name777	380978231568	468
778	name778	380391782636	1065
779	name779	380941784742	728
780	name780	380597755129	18
781	name781	380731127267	1076
782	name782	38071988026	1429
783	name783	380713385597	1291
784	name784	380219904549	1404
785	name785	380385170959	856
786	name786	380947775278	1255
787	name787	380324984826	476
788	name788	380780116325	1559
789	name789	380497832595	1787
790	name790	380535827070	1437
791	name791	380547046737	1710
792	name792	380272322579	337
793	name793	380130157575	385
794	name794	380785302833	1900
795	name795	380357080006	660
796	name796	380984826428	764
797	name797	380203620146	1197
798	name798	38057664198	82
799	name799	38047695062	1846
800	name800	380267729335	1303
801	name801	380406441515	311
802	name802	380457132356	111
803	name803	380633927474	869
804	name804	380241062155	947
805	name805	380917813166	118
806	name806	380323441184	1407
807	name807	380802749399	14
808	name808	380519308493	55
809	name809	380786218704	1365
810	name810	380738150394	888
811	name811	38074727442	631
812	name812	380583020713	1582
813	name813	38063127040	1751
814	name814	380666645497	622
815	name815	3801933390	867
816	name816	380617334941	714
817	name817	380725462477	1106
818	name818	380122771528	1922
819	name819	38053763258	1834
820	name820	380668399438	1092
821	name821	380504794719	80
822	name822	380967645353	1414
823	name823	380430183991	1618
824	name824	380378173615	1987
825	name825	380229110732	1206
826	name826	380557512503	813
827	name827	380867645116	686
828	name828	380459990552	404
829	name829	380440932109	1693
830	name830	38059628969	1826
831	name831	380684628624	304
832	name832	380414086937	852
833	name833	380415652836	1615
834	name834	380435251737	508
835	name835	380860353468	788
836	name836	380774498710	704
837	name837	380314144654	33
838	name838	380623234188	1779
839	name839	380915394	1897
840	name840	380774931185	1627
841	name841	380877387039	211
842	name842	380577889289	1907
843	name843	380162167382	1458
844	name844	380648196812	1565
845	name845	380637227886	275
846	name846	380455274982	253
847	name847	380848594854	1182
848	name848	380586454908	1593
849	name849	380171095719	1038
850	name850	380290567681	348
851	name851	380163602076	13
852	name852	380520793360	1029
853	name853	38079916291	1012
854	name854	38056541621	482
855	name855	380260915871	1471
856	name856	380489795360	1552
857	name857	380493612321	2
858	name858	380583309297	301
859	name859	380541768985	1053
860	name860	380196892494	1447
861	name861	380398986408	1133
862	name862	380699471647	1721
863	name863	380701312206	508
864	name864	380972901688	551
865	name865	380597730442	631
866	name866	380324871379	428
867	name867	380884110744	1343
868	name868	380408685579	867
869	name869	380810621612	50
870	name870	380508559074	62
871	name871	380137020481	1091
872	name872	380376996466	1101
873	name873	380286132047	1462
874	name874	380418814959	908
875	name875	380713252536	1659
876	name876	380574021116	284
877	name877	380201797636	1091
878	name878	380614689556	1986
879	name879	380889684262	139
880	name880	380459819947	1115
881	name881	380384488411	598
882	name882	38073229380	43
883	name883	3806750335	71
884	name884	38020757488	1227
885	name885	380156549413	312
886	name886	380129159589	1089
887	name887	380763463072	697
888	name888	380902284238	235
889	name889	380939613873	1563
890	name890	380873249355	491
891	name891	380126805617	1960
892	name892	380531310901	1414
893	name893	380133331402	577
894	name894	380523958107	972
895	name895	380913079176	1980
896	name896	38056297400	1323
897	name897	380514529128	683
898	name898	380659446870	561
899	name899	380427555176	1214
900	name900	380550568698	1082
901	name901	380271285118	527
902	name902	3801959162	57
903	name903	380907399083	1358
904	name904	380548900304	1552
905	name905	380859517287	262
906	name906	380165375476	1312
907	name907	380691333768	1238
908	name908	380795846007	1981
909	name909	380226079149	866
910	name910	380593994668	1109
911	name911	380468560730	969
912	name912	38081491873	1371
913	name913	380926732531	153
914	name914	380973989917	1435
915	name915	380960346326	930
916	name916	380309321532	933
917	name917	380140088505	194
918	name918	38029346539	1883
919	name919	380422321415	1814
920	name920	380892801154	122
921	name921	380165647724	399
922	name922	380615359266	812
923	name923	380276475600	998
924	name924	380201396068	661
925	name925	380337031706	488
926	name926	380892017813	152
927	name927	380482215580	1637
928	name928	380890397488	130
929	name929	380287603943	1707
930	name930	380547037119	1892
931	name931	380319490098	1034
932	name932	380447675185	1236
933	name933	380597785587	195
934	name934	380197212714	1396
935	name935	380608275618	276
936	name936	380397912845	1662
937	name937	380219951404	578
938	name938	380333647681	730
939	name939	380942706288	1723
940	name940	380122785279	1303
941	name941	380921949341	110
942	name942	380300775891	578
943	name943	380830482948	895
944	name944	380813783207	485
945	name945	380783747867	1725
946	name946	380573691887	781
947	name947	380145198085	1694
948	name948	380380990056	1819
949	name949	380508830907	1772
950	name950	380988911383	1801
951	name951	380607780645	793
952	name952	380232198699	378
953	name953	380723707141	693
954	name954	3809273022	226
955	name955	38090935691	1358
956	name956	380326582285	515
957	name957	380301880356	1348
958	name958	380686322189	1267
959	name959	3805393000	1886
960	name960	380238084986	237
961	name961	38095066873	189
962	name962	380798386630	223
963	name963	380387774942	1178
964	name964	380656283501	1288
965	name965	380832196494	1699
966	name966	380967981615	1269
967	name967	380216361421	1774
968	name968	380655321236	1869
969	name969	380669271381	248
970	name970	380129614777	1752
971	name971	380973007356	1052
972	name972	380601392120	902
973	name973	380269584467	1066
974	name974	380963067908	166
975	name975	380227620170	9
976	name976	3801032806	251
977	name977	380958841839	1807
978	name978	380215510084	75
979	name979	380617220165	1113
980	name980	380249178272	1540
981	name981	380543743723	568
982	name982	380799163964	800
983	name983	380736599480	887
984	name984	380778679594	668
985	name985	380681532701	933
986	name986	380213650242	177
987	name987	380254504643	787
988	name988	380781031446	1113
989	name989	380133517214	463
990	name990	380950644240	1907
991	name991	380761257669	1420
992	name992	380528793799	1160
993	name993	380984849786	1173
994	name994	380793289027	1210
995	name995	38074590135	1493
996	name996	380529124870	259
997	name997	380638734344	1255
998	name998	380227241305	1415
999	name999	380754607917	1236
1000	name1000	380748603693	1999
1001	name1001	380534232044	954
1002	name1002	380890725159	594
1003	name1003	380571270238	814
1004	name1004	38023868343	1412
1005	name1005	380547031661	1139
1006	name1006	380167104762	19
1007	name1007	380434219447	1064
1008	name1008	380390412753	887
1009	name1009	380631675559	1179
1010	name1010	380677955653	1670
1011	name1011	380531526653	140
1012	name1012	380381179081	1805
1013	name1013	380687136915	1511
1014	name1014	380783235613	486
1015	name1015	380967836909	94
1016	name1016	380653486384	1330
1017	name1017	380876304916	1458
1018	name1018	380906875625	1156
1019	name1019	380271045286	285
1020	name1020	380461607901	231
1021	name1021	380720453627	1339
1022	name1022	380952999421	1050
1023	name1023	380618175831	421
1024	name1024	380195331219	773
1025	name1025	380504373616	851
1026	name1026	380585231828	337
1027	name1027	380274358240	1143
1028	name1028	380222615939	1324
1029	name1029	380664384895	1982
1030	name1030	380237491960	379
1031	name1031	380443116048	990
1032	name1032	380705634832	131
1033	name1033	380453401811	525
1034	name1034	380390732512	1757
1035	name1035	380781634410	1376
1036	name1036	380580804860	616
1037	name1037	380863686710	572
1038	name1038	380570851347	488
1039	name1039	380171929117	706
1040	name1040	3809766488	1325
1041	name1041	380383636147	570
1042	name1042	380336161494	782
1043	name1043	380779180435	1472
1044	name1044	380902661359	1411
1045	name1045	38030242651	225
1046	name1046	38069180959	1555
1047	name1047	380933839744	685
1048	name1048	380498622393	934
1049	name1049	380359743110	1539
1050	name1050	380961039670	1520
1051	name1051	380297002856	1063
1052	name1052	380950384556	232
1053	name1053	380957003335	1875
1054	name1054	380174567752	1772
1055	name1055	380102135350	1529
1056	name1056	380717731680	626
1057	name1057	380646623808	1810
1058	name1058	380744322473	1491
1059	name1059	380894321349	1313
1060	name1060	380723622700	1207
1061	name1061	380278435623	1847
1062	name1062	380471750924	1012
1063	name1063	380135201944	1809
1064	name1064	380390922231	537
1065	name1065	380105464695	437
1066	name1066	380507817139	1768
1067	name1067	380722712015	248
1068	name1068	380158453412	938
1069	name1069	380197678095	939
1070	name1070	380793316155	1482
1071	name1071	380945278539	1525
1072	name1072	3802478194	356
1073	name1073	380989615293	1107
1074	name1074	380311448906	1076
1075	name1075	380596598719	355
1076	name1076	38071699504	1971
1077	name1077	380429700898	1679
1078	name1078	380663860982	1090
1079	name1079	3806386415	1224
1080	name1080	380316603914	50
1081	name1081	380534610547	433
1082	name1082	380729200634	29
1083	name1083	38072099577	1781
1084	name1084	38071680233	471
1085	name1085	380720119627	197
1086	name1086	380724397193	264
1087	name1087	380124803575	1723
1088	name1088	380874141772	927
1089	name1089	380612632004	220
1090	name1090	380438495597	104
1091	name1091	380637774723	388
1092	name1092	380395755655	507
1093	name1093	380190914448	1600
1094	name1094	380525326392	1463
1095	name1095	380538618847	381
1096	name1096	380573874260	1833
1097	name1097	380878928556	1281
1098	name1098	380755988554	1286
1099	name1099	380754610565	243
1100	name1100	380780529550	1898
1101	name1101	380437157269	1104
1102	name1102	380979645265	1038
1103	name1103	380787314080	1943
1104	name1104	380919373431	1932
1105	name1105	380276194075	882
1106	name1106	380109175492	657
1107	name1107	380647614795	1945
1108	name1108	380522334223	1172
1109	name1109	380752951273	273
1110	name1110	380827607323	30
1111	name1111	380597987020	106
1112	name1112	380392243661	572
1113	name1113	380482625809	1862
1114	name1114	380445927750	1489
1115	name1115	380447685491	1208
1116	name1116	380843628269	1502
1117	name1117	380100138754	1380
1118	name1118	380679888257	249
1119	name1119	380871741451	233
1120	name1120	380698736498	1477
1121	name1121	380890363984	289
1122	name1122	380253001558	1260
1123	name1123	380509956690	864
1124	name1124	380545196228	1864
1125	name1125	380449934705	1614
1126	name1126	380578372338	901
1127	name1127	380721935287	613
1128	name1128	380329099151	692
1129	name1129	380983239602	447
1130	name1130	380179769322	757
1131	name1131	380493611900	1576
1132	name1132	380694546861	941
1133	name1133	380925495193	516
1134	name1134	380541997595	958
1135	name1135	380415391350	1197
1136	name1136	380967651021	739
1137	name1137	380546234022	690
1138	name1138	380244864307	922
1139	name1139	38078196060	1392
1140	name1140	380777664577	1554
1141	name1141	380752531130	1843
1142	name1142	380249667837	824
1143	name1143	380998339626	1543
1144	name1144	380796465462	692
1145	name1145	380983780420	360
1146	name1146	380241125683	1905
1147	name1147	38012745536	574
1148	name1148	380324276369	1482
1149	name1149	380385429585	1326
1150	name1150	380853059886	698
1151	name1151	380350773877	977
1152	name1152	380646666784	1579
1153	name1153	380150013853	1720
1154	name1154	380248176210	952
1155	name1155	380546594782	904
1156	name1156	380506054435	1530
1157	name1157	380317946359	35
1158	name1158	380909224702	1406
1159	name1159	380406069505	1829
1160	name1160	380268735317	120
1161	name1161	380501303143	1770
1162	name1162	380112160141	1210
1163	name1163	380174507390	25
1164	name1164	380602682446	754
1165	name1165	38010385119	219
1166	name1166	380576201389	1640
1167	name1167	380297123690	794
1168	name1168	380716846186	453
1169	name1169	38069874427	400
1170	name1170	380358614260	1204
1171	name1171	38043818282	877
1172	name1172	380532471265	375
1173	name1173	38069279916	1680
1174	name1174	380524433403	1679
1175	name1175	380245942816	1797
1176	name1176	380972150211	1006
1177	name1177	380727062725	1294
1178	name1178	380267140250	1608
1179	name1179	380317562877	1550
1180	name1180	380852217713	1080
1181	name1181	380300949512	1684
1182	name1182	380482596564	1057
1183	name1183	380100516319	1934
1184	name1184	380466038239	298
1185	name1185	380455704484	623
1186	name1186	380755491928	1875
1187	name1187	380265108129	1285
1188	name1188	380745257799	1909
1189	name1189	380526893482	1083
1190	name1190	380958518814	212
1191	name1191	380540980124	728
1192	name1192	380106812931	254
1193	name1193	380883410591	146
1194	name1194	380295886184	518
1195	name1195	380860589391	1816
1196	name1196	380537173651	1499
1197	name1197	38096851622	1354
1198	name1198	380454191963	1460
1199	name1199	380126486909	95
1200	name1200	380761824926	1817
1201	name1201	380141935914	1579
1202	name1202	380317791764	433
1203	name1203	380209496117	1954
1204	name1204	380205371175	374
1205	name1205	380864449757	1478
1206	name1206	380428445979	1222
1207	name1207	380534864486	1541
1208	name1208	380902013063	58
1209	name1209	380212588015	1717
1210	name1210	380439145377	1788
1211	name1211	380195038488	1642
1212	name1212	380181753307	1585
1213	name1213	380706612	299
1214	name1214	380351676690	734
1215	name1215	380559057673	356
1216	name1216	380276921168	980
1217	name1217	380293594205	531
1218	name1218	380411889888	1036
1219	name1219	380338466106	1422
1220	name1220	380486971515	314
1221	name1221	380412277970	1222
1222	name1222	380444088086	1892
1223	name1223	380667513078	643
1224	name1224	38055646740	1823
1225	name1225	380382572711	485
1226	name1226	380867924685	323
1227	name1227	3801298951	1777
1228	name1228	380880246043	262
1229	name1229	380704165884	878
1230	name1230	38092230703	932
1231	name1231	380210080268	872
1232	name1232	380842809661	1070
1233	name1233	380205730250	732
1234	name1234	380808003635	229
1235	name1235	380722469876	1241
1236	name1236	380260503166	1085
1237	name1237	380580722311	540
1238	name1238	380498187907	1780
1239	name1239	380656666898	256
1240	name1240	380358511878	1243
1241	name1241	380845134907	1964
1242	name1242	380288811317	714
1243	name1243	380679666979	1824
1244	name1244	38012585587	1575
1245	name1245	380314128057	164
1246	name1246	380831582194	1907
1247	name1247	380592799376	119
1248	name1248	380357391825	35
1249	name1249	380916389740	1709
1250	name1250	380932393586	1285
1251	name1251	380991703220	1522
1252	name1252	380356549869	1765
1253	name1253	380426129515	133
1254	name1254	38026643933	1929
1255	name1255	380564404779	711
1256	name1256	380554260145	849
1257	name1257	380931259128	1352
1258	name1258	380707313781	959
1259	name1259	380837529762	342
1260	name1260	38028572639	1931
1261	name1261	38026667227	1650
1262	name1262	380394905303	948
1263	name1263	380263543718	1440
1264	name1264	380922436111	1527
1265	name1265	380543276413	1310
1266	name1266	380912351245	1318
1267	name1267	380157548548	1749
1268	name1268	380798745112	396
1269	name1269	380332131860	1239
1270	name1270	380408652474	1809
1271	name1271	380977487975	707
1272	name1272	380735786926	645
1273	name1273	380719087969	1790
1274	name1274	380431254109	827
1275	name1275	38024168678	497
1276	name1276	380414043273	157
1277	name1277	380746334764	965
1278	name1278	380351089410	1812
1279	name1279	380685450765	912
1280	name1280	380136604929	578
1281	name1281	380504265396	767
1282	name1282	380121003617	1368
1283	name1283	380621090253	649
1284	name1284	380544018899	132
1285	name1285	380528881825	521
1286	name1286	38026236963	844
1287	name1287	380680441550	479
1288	name1288	380828840518	955
1289	name1289	380959544073	1546
1290	name1290	380646242592	1748
1291	name1291	380154588371	1065
1292	name1292	380202264389	20
1293	name1293	380498490895	187
1294	name1294	380374911264	102
1295	name1295	380118131385	971
1296	name1296	380719841432	1682
1297	name1297	38031922900	411
1298	name1298	380178965920	1702
1299	name1299	380935109061	1149
1300	name1300	380918462197	111
1301	name1301	380422894656	1793
1302	name1302	380652695715	1815
1303	name1303	380450278852	775
1304	name1304	380963631825	1255
1305	name1305	380594786597	343
1306	name1306	380145266292	370
1307	name1307	380313777961	955
1308	name1308	380643837472	1440
1309	name1309	380732322314	1238
1310	name1310	380791641192	451
1311	name1311	380287180688	76
1312	name1312	380894897420	1983
1313	name1313	380642188506	381
1314	name1314	380619873702	480
1315	name1315	380135961658	732
1316	name1316	380987090315	1769
1317	name1317	380960155096	389
1318	name1318	380689499402	1971
1319	name1319	380851775288	1718
1320	name1320	380785225777	831
1321	name1321	380654658389	943
1322	name1322	38044422567	269
1323	name1323	380882810629	1884
1324	name1324	380898391896	125
1325	name1325	380862202091	1539
1326	name1326	380448614637	949
1327	name1327	380837441307	1934
1328	name1328	380201783601	71
1329	name1329	380467376300	897
1330	name1330	380676825592	1271
1331	name1331	380711751802	1007
1332	name1332	380345786450	1928
1333	name1333	380495144520	676
1334	name1334	38021169471	947
1335	name1335	380162197675	1884
1336	name1336	3803495748	136
1337	name1337	380566280143	545
1338	name1338	380566828869	1771
1339	name1339	380178187831	1530
1340	name1340	380861349031	35
1341	name1341	380645048102	490
1342	name1342	380308300284	173
1343	name1343	380823925372	163
1344	name1344	380670923471	809
1345	name1345	380613651114	1149
1346	name1346	380896767959	1567
1347	name1347	380523199201	1486
1348	name1348	38073706665	1593
1349	name1349	380888444732	717
1350	name1350	380507668782	1784
1351	name1351	380804395399	1824
1352	name1352	380733422208	455
1353	name1353	380161947779	1975
1354	name1354	380226740066	1905
1355	name1355	38045834397	446
1356	name1356	380489038401	1615
1357	name1357	380241336255	1361
1358	name1358	380407396014	1154
1359	name1359	380744301423	1872
1360	name1360	380530792052	338
1361	name1361	380953136101	591
1362	name1362	380539852698	1189
1363	name1363	380243612387	1173
1364	name1364	380834427539	103
1365	name1365	380805574680	1879
1366	name1366	380383835694	443
1367	name1367	380917159648	34
1368	name1368	380426516862	5
1369	name1369	380920489289	1785
1370	name1370	380995904520	706
1371	name1371	380101150750	728
1372	name1372	380235447142	17
1373	name1373	38057424747	88
1374	name1374	38076483940	1805
1375	name1375	380866852523	774
1376	name1376	380875820748	777
1377	name1377	38010807919	471
1378	name1378	380970799431	442
1379	name1379	380134371850	1478
1380	name1380	380364117748	1737
1381	name1381	380439716315	1004
1382	name1382	38085392867	1240
1383	name1383	380941756961	662
1384	name1384	380444153533	1552
1385	name1385	380227237313	452
1386	name1386	380284190202	1316
1387	name1387	380556528507	109
1388	name1388	380463884011	542
1389	name1389	380716845602	577
1390	name1390	380564775777	807
1391	name1391	380857811803	1669
1392	name1392	380970349559	1953
1393	name1393	380856335758	926
1394	name1394	380499293331	785
1395	name1395	380222329673	1774
1396	name1396	380835014812	1619
1397	name1397	380130985877	224
1398	name1398	380271062008	1384
1399	name1399	380353543334	1895
1400	name1400	380573587028	1340
1401	name1401	380687773679	1001
1402	name1402	380816512062	171
1403	name1403	380827735715	894
1404	name1404	380946839195	1156
1405	name1405	380758219754	683
1406	name1406	380464479793	701
1407	name1407	380961981700	824
1408	name1408	380114407915	566
1409	name1409	380161020462	700
1410	name1410	380376449861	1685
1411	name1411	380195531921	1549
1412	name1412	380832488283	504
1413	name1413	380604906827	761
1414	name1414	38060315838	412
1415	name1415	380917565156	100
1416	name1416	38037441242	1542
1417	name1417	380780602176	5
1418	name1418	380738091927	1814
1419	name1419	380360577958	251
1420	name1420	380817321174	1157
1421	name1421	380907451903	717
1422	name1422	380579320590	546
1423	name1423	380240543141	808
1424	name1424	380247105370	375
1425	name1425	380829990007	1494
1426	name1426	380904377641	138
1427	name1427	380583670033	518
1428	name1428	380933970588	480
1429	name1429	380802740701	66
1430	name1430	380756298509	247
1431	name1431	38097053202	1172
1432	name1432	380797447752	271
1433	name1433	380383905791	353
1434	name1434	380530082165	1961
1435	name1435	380369241595	1105
1436	name1436	380584951880	109
1437	name1437	38021861417	432
1438	name1438	380131742972	1680
1439	name1439	380619960915	8
1440	name1440	380713413402	1962
1441	name1441	380869807566	873
1442	name1442	380865870719	684
1443	name1443	38039667470	1300
1444	name1444	380128036823	55
1445	name1445	380526332118	1340
1446	name1446	380573445725	315
1447	name1447	380493715942	1642
1448	name1448	380203216153	14
1449	name1449	380961544672	1815
1450	name1450	380567584369	693
1451	name1451	380427725379	255
1452	name1452	38080101411	802
1453	name1453	38053905515	1440
1454	name1454	380453331140	1391
1455	name1455	380755891486	67
1456	name1456	380870119594	741
1457	name1457	380401648431	599
1458	name1458	380731261484	1254
1459	name1459	380788807866	1831
1460	name1460	380561914698	1718
1461	name1461	380370124195	615
1462	name1462	380139335828	489
1463	name1463	380448738426	660
1464	name1464	380286817376	378
1465	name1465	380443451066	1605
1466	name1466	380402094313	841
1467	name1467	380105766704	32
1468	name1468	380439343543	1920
1469	name1469	380632150981	1075
1470	name1470	380552974473	1074
1471	name1471	380965999502	290
1472	name1472	380456735407	626
1473	name1473	380980202025	314
1474	name1474	380349465474	1713
1475	name1475	380561810934	1398
1476	name1476	380355705924	577
1477	name1477	380663000632	1131
1478	name1478	380790303084	432
1479	name1479	380183392973	612
1480	name1480	380253961245	1630
1481	name1481	38085577475	868
1482	name1482	380100404423	682
1483	name1483	38090668730	1267
1484	name1484	380495513293	1451
1485	name1485	380107150671	373
1486	name1486	380207311137	1161
1487	name1487	380735589234	261
1488	name1488	380907138835	94
1489	name1489	380628455270	331
1490	name1490	38080249325	383
1491	name1491	380578262371	1606
1492	name1492	380471600273	881
1493	name1493	380392610695	526
1494	name1494	380930344433	1243
1495	name1495	380108167936	1324
1496	name1496	380972549530	210
1497	name1497	380844554287	929
1498	name1498	380221995019	825
1499	name1499	380486434636	78
1500	name1500	380185647787	1241
1501	name1501	380159881049	980
1502	name1502	380467980780	1274
1503	name1503	380549957225	112
1504	name1504	38027733160	742
1505	name1505	380248513544	235
1506	name1506	380574753121	1244
1507	name1507	380396804025	388
1508	name1508	380876363556	789
1509	name1509	380334833371	1828
1510	name1510	380972850936	169
1511	name1511	380179320777	647
1512	name1512	380509385724	1064
1513	name1513	38052213131	1229
1514	name1514	380266945584	544
1515	name1515	380231615256	1732
1516	name1516	380840091671	1001
1517	name1517	380320397009	1874
1518	name1518	380730217555	792
1519	name1519	38057372359	40
1520	name1520	380717903077	220
1521	name1521	380318615491	378
1522	name1522	380661298384	589
1523	name1523	380698490559	1132
1524	name1524	380485380790	1011
1525	name1525	380861036926	46
1526	name1526	380634695190	519
1527	name1527	380431761714	915
1528	name1528	38015822826	1707
1529	name1529	380425132202	850
1530	name1530	380676397286	840
1531	name1531	380827276341	673
1532	name1532	380466048328	1550
1533	name1533	380994360238	976
1534	name1534	380757314730	872
1535	name1535	380816589640	396
1536	name1536	380658549431	1460
1537	name1537	38036497928	6
1538	name1538	38043512959	1153
1539	name1539	380319718872	1972
1540	name1540	380626535775	1211
1541	name1541	380145790122	1173
1542	name1542	380602205943	1428
1543	name1543	38067174178	1881
1544	name1544	380513130346	120
1545	name1545	380694359810	1518
1546	name1546	380717598039	1399
1547	name1547	380816491697	510
1548	name1548	380388858150	1487
1549	name1549	380845097355	1569
1550	name1550	380305492125	494
1551	name1551	380132803901	1013
1552	name1552	380144483818	79
1553	name1553	380319267097	1027
1554	name1554	380767804042	1692
1555	name1555	380101136525	507
1556	name1556	38012208362	556
1557	name1557	380747681351	1465
1558	name1558	380838561166	1118
1559	name1559	380726278344	822
1560	name1560	380378361809	122
1561	name1561	380390472403	1511
1562	name1562	380835561320	1127
1563	name1563	380706768458	1930
1564	name1564	380864285097	1005
1565	name1565	380628844092	1355
1566	name1566	380243697635	1051
1567	name1567	380735949707	1372
1568	name1568	380486464293	304
1569	name1569	380319932521	281
1570	name1570	380667210610	269
1571	name1571	380368935416	804
1572	name1572	380457670634	1840
1573	name1573	380785901923	693
1574	name1574	38052130839	188
1575	name1575	380824143971	71
1576	name1576	380581503992	1767
1577	name1577	380569123309	795
1578	name1578	380303370006	690
1579	name1579	380276810737	1219
1580	name1580	380525092824	140
1581	name1581	380830831757	528
1582	name1582	380312874082	554
1583	name1583	380305253703	1074
1584	name1584	380658653454	24
1585	name1585	380370759697	1372
1586	name1586	380238666486	373
1587	name1587	380114936964	1712
1588	name1588	380834163275	632
1589	name1589	380185249766	1898
1590	name1590	38095300686	1577
1591	name1591	38077458813	1137
1592	name1592	380974689151	636
1593	name1593	380512238454	1886
1594	name1594	380253156492	2000
1595	name1595	380459027897	434
1596	name1596	380775191594	1917
1597	name1597	380699872235	58
1598	name1598	380919222650	571
1599	name1599	38093945649	406
1600	name1600	380117280125	1010
1601	name1601	380513597898	231
1602	name1602	380660705304	1967
1603	name1603	380191875047	1719
1604	name1604	380994933351	948
1605	name1605	380712209787	1856
1606	name1606	380313308118	1946
1607	name1607	380602658844	1714
1608	name1608	380184251487	1377
1609	name1609	380690015302	1725
1610	name1610	380419790316	1565
1611	name1611	380239193715	796
1612	name1612	380494637250	1400
1613	name1613	380529097769	1811
1614	name1614	380605994155	611
1615	name1615	380158034399	610
1616	name1616	380966285916	1709
1617	name1617	38027339315	863
1618	name1618	380908638614	777
1619	name1619	38090282938	175
1620	name1620	380662514783	1540
1621	name1621	380774767142	782
1622	name1622	380112621641	696
1623	name1623	380213826554	1858
1624	name1624	380906409099	1547
1625	name1625	380518881266	1244
1626	name1626	380179304556	1767
1627	name1627	380264662662	795
1628	name1628	380668763489	615
1629	name1629	380280511783	1796
1630	name1630	38098339392	93
1631	name1631	380943055067	1597
1632	name1632	380895737880	321
1633	name1633	380612665800	357
1634	name1634	380174238392	1976
1635	name1635	380113390503	243
1636	name1636	380515532726	141
1637	name1637	380208609669	614
1638	name1638	380268394959	1899
1639	name1639	380799263554	601
1640	name1640	380657352676	1441
1641	name1641	380700567843	1561
1642	name1642	380714092256	572
1643	name1643	380102549575	1878
1644	name1644	380804728678	1816
1645	name1645	380901006983	1621
1646	name1646	38065749818	1016
1647	name1647	380232693645	819
1648	name1648	380568788554	567
1649	name1649	380144239458	801
1650	name1650	38046955181	922
1651	name1651	38016437894	770
1652	name1652	380963313147	1974
1653	name1653	380522375726	174
1654	name1654	380740527044	1590
1655	name1655	380905643752	1053
1656	name1656	380278522174	1521
1657	name1657	380177456724	1107
1658	name1658	380386904105	1345
1659	name1659	380339278940	1547
1660	name1660	380248758481	934
1661	name1661	380927507000	1437
1662	name1662	380996619812	1643
1663	name1663	380713195298	523
1664	name1664	380382964590	159
1665	name1665	380150493330	1988
1666	name1666	380163703134	153
1667	name1667	380426812007	1674
1668	name1668	380346578806	107
1669	name1669	380324603692	1153
1670	name1670	38017859410	1538
1671	name1671	380908653348	1575
1672	name1672	380747852740	1414
1673	name1673	380989354120	683
1674	name1674	380655678655	313
1675	name1675	380962910074	1882
1676	name1676	380767365530	458
1677	name1677	380228887813	552
1678	name1678	380829461776	1643
1679	name1679	380657462613	698
1680	name1680	380781565270	579
1681	name1681	380431178431	126
1682	name1682	380284243203	1632
1683	name1683	380611411931	1671
1684	name1684	380552512928	951
1685	name1685	380905039381	269
1686	name1686	380260041839	1165
1687	name1687	380399023888	707
1688	name1688	38097771115	165
1689	name1689	380566849567	1487
1690	name1690	380111236288	1154
1691	name1691	380719644422	1097
1692	name1692	3805827398	774
1693	name1693	380982335209	76
1694	name1694	380235305308	1039
1695	name1695	380482750029	871
1696	name1696	380540952123	1254
1697	name1697	380472823384	782
1698	name1698	380999195715	737
1699	name1699	380407649664	1047
1700	name1700	380282471799	1545
1701	name1701	380192957611	1201
1702	name1702	380756597822	359
1703	name1703	380662864640	1017
1704	name1704	380490723778	1313
1705	name1705	380246415453	647
1706	name1706	380469868223	1636
1707	name1707	380385921237	1428
1708	name1708	380687204126	859
1709	name1709	380231794528	830
1710	name1710	380695811715	261
1711	name1711	380185860718	452
1712	name1712	380709510906	302
1713	name1713	380572262898	648
1714	name1714	380527713605	1411
1715	name1715	380384492320	173
1716	name1716	380460627527	508
1717	name1717	380565154187	957
1718	name1718	380472720952	1672
1719	name1719	380385200538	743
1720	name1720	380753018080	44
1721	name1721	38042403511	1418
1722	name1722	380602851772	835
1723	name1723	380147507890	1535
1724	name1724	380665176548	287
1725	name1725	380626168945	810
1726	name1726	380771635101	1174
1727	name1727	380909752154	619
1728	name1728	380124067202	1051
1729	name1729	380828391348	1239
1730	name1730	380311847526	1253
1731	name1731	380549952101	1880
1732	name1732	380521822245	1808
1733	name1733	380226264540	1317
1734	name1734	380701333527	666
1735	name1735	380955621934	54
1736	name1736	380917757618	1266
1737	name1737	380961094547	40
1738	name1738	380934923137	908
1739	name1739	380526991060	1671
1740	name1740	380193986666	1200
1741	name1741	380184922534	826
1742	name1742	380205561295	293
1743	name1743	380145456615	728
1744	name1744	380679536876	370
1745	name1745	380412297699	1501
1746	name1746	380364634123	277
1747	name1747	380171430267	1073
1748	name1748	380566914974	531
1749	name1749	380134065284	705
1750	name1750	38090938604	1778
1751	name1751	3804952425	1525
1752	name1752	380577653090	1012
1753	name1753	380391957627	1634
1754	name1754	380793738955	1386
1755	name1755	380551075046	1698
1756	name1756	38028761328	807
1757	name1757	380188744368	1975
1758	name1758	380754955850	999
1759	name1759	380323222891	1975
1760	name1760	380777592654	1990
1761	name1761	380775938032	484
1762	name1762	380578938686	1656
1763	name1763	380525321360	705
1764	name1764	380623902427	1078
1765	name1765	380692414920	124
1766	name1766	380568796770	1463
1767	name1767	38051840995	1619
1768	name1768	38098489898	185
1769	name1769	380361274997	780
1770	name1770	380542357880	1440
1771	name1771	38099093468	897
1772	name1772	380219500456	1260
1773	name1773	380542929909	584
1774	name1774	380898052391	1195
1775	name1775	380796785424	1074
1776	name1776	380630128052	1815
1777	name1777	380709501914	1343
1778	name1778	380454083455	687
1779	name1779	380642283936	832
1780	name1780	380503094972	295
1781	name1781	380684489967	1245
1782	name1782	380928958862	1891
1783	name1783	380388184716	92
1784	name1784	380994033729	1726
1785	name1785	380683288970	1766
1786	name1786	380576773427	1238
1787	name1787	380624140589	1808
1788	name1788	380712011075	764
1789	name1789	380211135921	1393
1790	name1790	380808612522	1651
1791	name1791	380474667141	322
1792	name1792	380343299928	1819
1793	name1793	380407628866	856
1794	name1794	380947292819	1032
1795	name1795	380364584042	1928
1796	name1796	380984629040	46
1797	name1797	380168972739	1558
1798	name1798	380104685894	1177
1799	name1799	380582288276	590
1800	name1800	38013155384	342
1801	name1801	380294027037	1198
1802	name1802	380520529331	235
1803	name1803	380688228518	389
1804	name1804	380119068389	1985
1805	name1805	380567165186	678
1806	name1806	380243488591	531
1807	name1807	380602422227	621
1808	name1808	380957930897	1053
1809	name1809	380954631178	1450
1810	name1810	380406986658	750
1811	name1811	380281917712	367
1812	name1812	380326597187	1526
1813	name1813	380311847036	282
1814	name1814	380394787450	1622
1815	name1815	380228666568	1626
1816	name1816	380739956089	1279
1817	name1817	380302961453	1033
1818	name1818	380198448686	1307
1819	name1819	3802876546	585
1820	name1820	380275085167	439
1821	name1821	380762437235	273
1822	name1822	380237620512	297
1823	name1823	380449725097	266
1824	name1824	380872052851	135
1825	name1825	380888879330	869
1826	name1826	380794953079	1500
1827	name1827	380362118698	1047
1828	name1828	380332077105	1653
1829	name1829	380376458002	1033
1830	name1830	380163409769	1698
1831	name1831	380823396592	1954
1832	name1832	380757674545	189
1833	name1833	380547659542	263
1834	name1834	380221508097	72
1835	name1835	380916538855	362
1836	name1836	380437570670	493
1837	name1837	380456801385	1596
1838	name1838	380750997939	930
1839	name1839	380906211797	769
1840	name1840	380321372854	675
1841	name1841	380756506244	1088
1842	name1842	380654431801	1551
1843	name1843	380343157722	1930
1844	name1844	380463340789	1623
1845	name1845	380344492384	1590
1846	name1846	380782804804	1837
1847	name1847	380893924933	1753
1848	name1848	380677156969	884
1849	name1849	380686580978	434
1850	name1850	380264888101	1661
1851	name1851	380540276856	205
1852	name1852	380248660383	1415
1853	name1853	380510348290	184
1854	name1854	380662119010	1365
1855	name1855	380239980108	226
1856	name1856	380843442638	1141
1857	name1857	380814586652	1925
1858	name1858	380531139427	1659
1859	name1859	380202839471	442
1860	name1860	380741525139	924
1861	name1861	380890535456	413
1862	name1862	380838611474	890
1863	name1863	380762237042	618
1864	name1864	380580671372	90
1865	name1865	380115178283	792
1866	name1866	380371231109	865
1867	name1867	380953082415	188
1868	name1868	380819997797	1857
1869	name1869	380483876297	245
1870	name1870	380752476928	1898
1871	name1871	380522654586	1682
1872	name1872	380901312975	395
1873	name1873	380293947798	842
1874	name1874	380804267866	124
1875	name1875	380272603600	655
1876	name1876	380420045241	1174
1877	name1877	380682860851	1161
1878	name1878	380867180379	1655
1879	name1879	380570294600	1738
1880	name1880	380681847322	1649
1881	name1881	380240456807	187
1882	name1882	380861138120	1850
1883	name1883	380178258194	1733
1884	name1884	380554249497	1851
1885	name1885	38045668821	746
1886	name1886	380576605622	1503
1887	name1887	380474922791	1963
1888	name1888	38092454151	1453
1889	name1889	380881767745	1149
1890	name1890	380134487152	1313
1891	name1891	380811835990	1725
1892	name1892	380670031565	1348
1893	name1893	380233109556	1439
1894	name1894	380144473226	1226
1895	name1895	380446647183	728
1896	name1896	380252522451	1216
1897	name1897	380899150422	1968
1898	name1898	380682935451	1493
1899	name1899	380872261384	1676
1900	name1900	380566534790	685
1901	name1901	380632239017	439
1902	name1902	380362215744	331
1903	name1903	380736448963	1309
1904	name1904	380618723811	1173
1905	name1905	380334117525	1610
1906	name1906	380985983897	1721
1907	name1907	380109096506	1556
1908	name1908	380766072344	570
1909	name1909	380767514314	715
1910	name1910	380296068204	499
1911	name1911	380943124500	691
1912	name1912	380117276949	963
1913	name1913	380954669195	5
1914	name1914	380283742739	1487
1915	name1915	380917417056	1617
1916	name1916	380819051143	362
1917	name1917	380960697979	1300
1918	name1918	380334952241	144
1919	name1919	380814071388	612
1920	name1920	380943163413	1876
1921	name1921	380378603392	1685
1922	name1922	380929566652	312
1923	name1923	380426669513	747
1924	name1924	380510542382	641
1925	name1925	380842325689	161
1926	name1926	380747802569	1328
1927	name1927	380120515453	471
1928	name1928	380266437289	838
1929	name1929	380357975275	129
1930	name1930	380333873457	1595
1931	name1931	380359907400	803
1932	name1932	380332176667	691
1933	name1933	380240402728	1717
1934	name1934	380112304764	1800
1935	name1935	380212189701	1915
1936	name1936	380809404545	1142
1937	name1937	380317265420	343
1938	name1938	380683869400	1169
1939	name1939	380354843393	1557
1940	name1940	380884799526	51
1941	name1941	380676096036	326
1942	name1942	380286583690	30
1943	name1943	380912140251	1907
1944	name1944	380388330452	1724
1945	name1945	380207543263	517
1946	name1946	380886599210	1006
1947	name1947	380384443086	998
1948	name1948	38085330907	1948
1949	name1949	380181540237	1077
1950	name1950	38061202161	689
1951	name1951	380499248384	1712
1952	name1952	38049466361	1448
1953	name1953	380989888693	1719
1954	name1954	380101684455	43
1955	name1955	380392325318	1942
1956	name1956	380165530080	1490
1957	name1957	380421477641	643
1958	name1958	380250899797	457
1959	name1959	380644221850	1674
1960	name1960	380371569881	1661
1961	name1961	380593561301	514
1962	name1962	380805309040	1090
1963	name1963	380267023009	1980
1964	name1964	380470875175	849
1965	name1965	380148303733	1689
1966	name1966	380763822295	248
1967	name1967	380314222708	714
1968	name1968	380855725373	1235
1969	name1969	3807883356	91
1970	name1970	380558455995	1183
1971	name1971	380819197526	1594
1972	name1972	380994524381	1317
1973	name1973	380849191259	433
1974	name1974	380120561688	406
1975	name1975	380841962957	634
1976	name1976	38078154428	1866
1977	name1977	380261529128	155
1978	name1978	380540095008	317
1979	name1979	380497188658	399
1980	name1980	380414333689	1370
1981	name1981	38054317548	777
1982	name1982	380986148451	3
1983	name1983	380567013360	214
1984	name1984	380442838861	95
1985	name1985	380418889749	1164
1986	name1986	380449965497	1876
1987	name1987	380178821348	1934
1988	name1988	380140163808	1051
1989	name1989	380166821321	936
1990	name1990	380525206642	65
1991	name1991	380700234849	571
1992	name1992	380938161536	1721
1993	name1993	380380409366	713
1994	name1994	380585795288	1168
1995	name1995	380511179370	1931
1996	name1996	380524216766	1319
1997	name1997	380847966739	1293
1998	name1998	380793803570	813
1999	name1999	380336656019	171
2000	name2000	380275403145	1710
2001	name2001	380212264898	1384
2002	name2002	380756240314	938
2003	name2003	380935095246	1510
2004	name2004	380938900464	450
2005	name2005	380945094051	578
2006	name2006	380941095792	657
2007	name2007	380847784259	1159
2008	name2008	380166815915	1445
2009	name2009	380950488276	893
2010	name2010	380203526040	357
2011	name2011	380727394706	1029
2012	name2012	380884727304	1889
2013	name2013	380685287756	1956
2014	name2014	380709693570	1230
2015	name2015	380221252114	1183
2016	name2016	380287127969	154
2017	name2017	380325606602	680
2018	name2018	380878716646	39
2019	name2019	380121473099	145
2020	name2020	380655010786	223
2021	name2021	380374294733	1757
2022	name2022	380595736203	983
2023	name2023	380283864579	726
2024	name2024	380654714947	1631
2025	name2025	380636102236	946
2026	name2026	380237733295	657
2027	name2027	380825570211	638
2028	name2028	380354631829	914
2029	name2029	380138076388	1499
2030	name2030	38057990994	1315
2031	name2031	380143527033	1787
2032	name2032	380767308247	714
2033	name2033	38062471365	1909
2034	name2034	380207688155	1793
2035	name2035	38048148993	361
2036	name2036	380246904329	1419
2037	name2037	380323480403	1880
2038	name2038	380349858901	1265
2039	name2039	380616197631	1478
2040	name2040	380831992091	1374
2041	name2041	38058386192	149
2042	name2042	380110796112	1561
2043	name2043	380461072801	916
2044	name2044	380485577333	922
2045	name2045	38034869250	1846
2046	name2046	380888990241	953
2047	name2047	380865922014	282
2048	name2048	380840374432	1666
2049	name2049	38081442428	165
2050	name2050	380127071478	77
2051	name2051	380383814768	1114
2052	name2052	380278268975	1308
2053	name2053	380925144190	508
2054	name2054	380576284126	284
2055	name2055	380979172248	1359
2056	name2056	38057199516	671
2057	name2057	380833200334	1713
2058	name2058	380327212255	401
2059	name2059	380855722031	960
2060	name2060	380423135166	799
2061	name2061	380782455045	1298
2062	name2062	380129365635	1852
2063	name2063	380719125991	1693
2064	name2064	380714302734	1576
2065	name2065	380366704146	1639
2066	name2066	380413519879	259
2067	name2067	380178396568	1647
2068	name2068	380962333820	1940
2069	name2069	380657987573	178
2070	name2070	380305205020	795
2071	name2071	380261185932	1960
2072	name2072	380331691224	1501
2073	name2073	380889391237	399
2074	name2074	38069397638	1084
2075	name2075	380956543486	834
2076	name2076	380403853229	775
2077	name2077	380265571876	1914
2078	name2078	380852363566	1706
2079	name2079	380297953613	314
2080	name2080	380123666460	1993
2081	name2081	380840278970	953
2082	name2082	380236916302	1684
2083	name2083	380643176642	1474
2084	name2084	380577530989	1348
2085	name2085	380150456793	257
2086	name2086	380155421040	1034
2087	name2087	380520035815	29
2088	name2088	380390287922	331
2089	name2089	380852543739	1784
2090	name2090	380717130794	822
2091	name2091	380103860559	934
2092	name2092	380711597720	1216
2093	name2093	380672446827	1422
2094	name2094	380812459971	1767
2095	name2095	380128475723	1099
2096	name2096	380643109717	775
2097	name2097	380526083265	896
2098	name2098	380219277062	161
2099	name2099	380754706654	1919
2100	name2100	380742837615	1960
2101	name2101	380177699682	677
2102	name2102	380821052318	1387
2103	name2103	380715265201	1977
2104	name2104	380469004863	1875
2105	name2105	380529379773	1773
2106	name2106	380372673605	918
2107	name2107	380400130853	1978
2108	name2108	380206465672	1509
2109	name2109	380843834093	410
2110	name2110	380639014395	353
2111	name2111	380560308511	461
2112	name2112	380797024725	1427
2113	name2113	380425958236	743
2114	name2114	380259097436	732
2115	name2115	380998918742	273
2116	name2116	380291079264	901
2117	name2117	380574599146	980
2118	name2118	380133266234	50
2119	name2119	380136371913	378
2120	name2120	380300623947	829
2121	name2121	380777960441	238
2122	name2122	380723599562	1752
2123	name2123	380220933458	917
2124	name2124	380789549555	1799
2125	name2125	380993207887	608
2126	name2126	380333451883	299
2127	name2127	380387967626	137
2128	name2128	380141213997	1828
2129	name2129	380517832195	345
2130	name2130	38078170394	1200
2131	name2131	380821840583	1046
2132	name2132	380728476014	1654
2133	name2133	38037539561	1779
2134	name2134	380966547440	738
2135	name2135	380155784710	374
2136	name2136	380138891290	650
2137	name2137	380298847542	1378
2138	name2138	380825360785	1400
2139	name2139	380559513372	562
2140	name2140	380416835168	1984
2141	name2141	380895766383	644
2142	name2142	380964503951	1217
2143	name2143	380955193464	1683
2144	name2144	380742318628	1263
2145	name2145	380536170430	423
2146	name2146	380697909731	500
2147	name2147	380603320714	1603
2148	name2148	380518712476	1026
2149	name2149	38037562328	1438
2150	name2150	380509042594	1268
2151	name2151	380185514025	81
2152	name2152	380862121548	696
2153	name2153	380132380840	1627
2154	name2154	380635625070	946
2155	name2155	380146289278	1707
2156	name2156	380525514085	568
2157	name2157	380893902949	569
2158	name2158	380706039898	1725
2159	name2159	380746153906	1792
2160	name2160	380730793951	183
2161	name2161	380444868921	1502
2162	name2162	380302208833	842
2163	name2163	380220170353	365
2164	name2164	380679812981	32
2165	name2165	380317566842	85
2166	name2166	380666511055	1709
2167	name2167	380966383261	1853
2168	name2168	380456990216	219
2169	name2169	380897227290	1783
2170	name2170	380382414200	300
2171	name2171	380534730975	1023
2172	name2172	380985991906	1984
2173	name2173	380316800907	1171
2174	name2174	380612019691	801
2175	name2175	380717430747	295
2176	name2176	380853213804	262
2177	name2177	380762748149	1464
2178	name2178	380193866350	1766
2179	name2179	380515127975	79
2180	name2180	380432103200	1736
2181	name2181	380696213115	1065
2182	name2182	380619412778	474
2183	name2183	380568746909	1857
2184	name2184	380433295176	1418
2185	name2185	38055358499	1873
2186	name2186	38098074778	1308
2187	name2187	380595012663	1109
2188	name2188	380942873551	546
2189	name2189	380161808088	1882
2190	name2190	380773099685	250
2191	name2191	380874696061	325
2192	name2192	380199684663	792
2193	name2193	380151803258	576
2194	name2194	380801610001	180
2195	name2195	380238052896	503
2196	name2196	380885539434	747
2197	name2197	380151182312	165
2198	name2198	380802664669	464
2199	name2199	380733601732	1802
2200	name2200	380970468727	1748
2201	name2201	380738612649	878
2202	name2202	380901112832	1317
2203	name2203	380106848382	119
2204	name2204	380158206861	491
2205	name2205	380135247413	692
2206	name2206	380749422429	918
2207	name2207	380847984766	458
2208	name2208	380532150885	412
2209	name2209	380928366815	1242
2210	name2210	380944749787	1441
2211	name2211	380275754103	1315
2212	name2212	3804686833	1331
2213	name2213	380404451450	1441
2214	name2214	380827596652	227
2215	name2215	380432997266	994
2216	name2216	380846621354	1560
2217	name2217	380921997149	662
2218	name2218	380857923432	1041
2219	name2219	380392915806	1034
2220	name2220	380720265749	1766
2221	name2221	380400319767	752
2222	name2222	380424121798	704
2223	name2223	380469469619	709
2224	name2224	380889372315	1459
2225	name2225	380407340411	1305
2226	name2226	380812491835	645
2227	name2227	380236860595	1740
2228	name2228	380339627790	745
2229	name2229	380482238501	1063
2230	name2230	380115638681	1182
2231	name2231	380778651882	1311
2232	name2232	380450898485	1769
2233	name2233	380978888258	1961
2234	name2234	380506446586	440
2235	name2235	380184274685	721
2236	name2236	380231154147	158
2237	name2237	380629755399	544
2238	name2238	380672074709	1942
2239	name2239	380607644916	1210
2240	name2240	380394355509	1628
2241	name2241	380239651370	458
2242	name2242	380364944149	1052
2243	name2243	380708139477	1738
2244	name2244	380261081757	152
2245	name2245	380972274162	557
2246	name2246	380263269973	821
2247	name2247	380657680671	1788
2248	name2248	380429931492	1028
2249	name2249	380903283934	1097
2250	name2250	380373780650	1406
2251	name2251	380159186153	754
2252	name2252	380836512012	240
2253	name2253	380210870117	1700
2254	name2254	380488430671	1381
2255	name2255	380761825121	1826
2256	name2256	380440019816	563
2257	name2257	380153090794	1782
2258	name2258	380112845492	1713
2259	name2259	380748668052	1192
2260	name2260	380688017749	1403
2261	name2261	380951056531	1619
2262	name2262	380407761686	1494
2263	name2263	380724341392	1132
2264	name2264	380769164170	1052
2265	name2265	380734266145	302
2266	name2266	38069784507	1224
2267	name2267	380846739173	460
2268	name2268	380710604621	1558
2269	name2269	380700682513	890
2270	name2270	380471450416	1679
2271	name2271	380170864696	343
2272	name2272	380678879577	1657
2273	name2273	380756689214	183
2274	name2274	380483048678	1234
2275	name2275	380438266176	990
2276	name2276	380546040755	1438
2277	name2277	380803744942	413
2278	name2278	380113244315	189
2279	name2279	380626704740	563
2280	name2280	380359835965	1811
2281	name2281	380967828919	284
2282	name2282	380788699767	496
2283	name2283	380836690358	163
2284	name2284	380860076433	1360
2285	name2285	380878748473	1881
2286	name2286	380804184861	686
2287	name2287	380440005363	1266
2288	name2288	380492523688	1520
2289	name2289	380318786089	1829
2290	name2290	380226789494	137
2291	name2291	380546595107	1205
2292	name2292	380444833343	1772
2293	name2293	380409349213	1949
2294	name2294	380546631034	1177
2295	name2295	380597155173	795
2296	name2296	380352403182	852
2297	name2297	380991228351	1110
2298	name2298	380300824237	119
2299	name2299	380486923419	1858
2300	name2300	380359650736	1220
2301	name2301	380995369221	234
2302	name2302	380129525652	1524
2303	name2303	380939757069	1906
2304	name2304	380866673769	1682
2305	name2305	380678949394	1413
2306	name2306	380577772526	1509
2307	name2307	380639329118	762
2308	name2308	380312933677	1293
2309	name2309	380413870556	1526
2310	name2310	380962928256	1428
2311	name2311	380785628562	1963
2312	name2312	380847179434	1317
2313	name2313	380825010842	1817
2314	name2314	380766267913	727
2315	name2315	380569934492	1999
2316	name2316	380383056351	1137
2317	name2317	38062829155	35
2318	name2318	380963158543	111
2319	name2319	380480718879	969
2320	name2320	380847602205	1555
2321	name2321	380703901567	1404
2322	name2322	380117105129	90
2323	name2323	380187806103	94
2324	name2324	380978131220	1897
2325	name2325	380564050390	656
2326	name2326	380769464639	1688
2327	name2327	380964492906	1389
2328	name2328	380722976584	1583
2329	name2329	380707875807	1275
2330	name2330	380952822733	1676
2331	name2331	380549749601	513
2332	name2332	380642462642	1365
2333	name2333	380287319707	654
2334	name2334	380538950851	841
2335	name2335	38018246073	1885
2336	name2336	3805691296	221
2337	name2337	380947608043	557
2338	name2338	380552110783	272
2339	name2339	380498563449	1468
2340	name2340	380931761356	1860
2341	name2341	380324383321	839
2342	name2342	380688569809	461
2343	name2343	380483978363	1044
2344	name2344	380654527417	1789
2345	name2345	380309529110	284
2346	name2346	380689977360	1187
2347	name2347	380430680491	458
2348	name2348	38099704070	1391
2349	name2349	380989205500	508
2350	name2350	380231304253	139
2351	name2351	380390869676	1253
2352	name2352	380581914772	1558
2353	name2353	380425684646	1697
2354	name2354	380866053106	1541
2355	name2355	380529165403	1869
2356	name2356	380765180191	23
2357	name2357	380250050532	1024
2358	name2358	380788234031	782
2359	name2359	380607062847	1088
2360	name2360	380619471304	5
2361	name2361	380606683464	726
2362	name2362	380641108227	1398
2363	name2363	380369325093	1222
2364	name2364	38062575547	1868
2365	name2365	380609289034	1682
2366	name2366	380949004152	201
2367	name2367	380346374682	1608
2368	name2368	380243022916	1004
2369	name2369	380664280070	128
2370	name2370	380545801750	1942
2371	name2371	380906728195	225
2372	name2372	38016700776	1196
2373	name2373	380838429826	1466
2374	name2374	380400280098	501
2375	name2375	380602719439	767
2376	name2376	380445684110	819
2377	name2377	380707362059	1853
2378	name2378	380725878105	1873
2379	name2379	380491218868	1825
2380	name2380	38029479847	1831
2381	name2381	380648730151	1738
2382	name2382	380145096885	1156
2383	name2383	380359443223	1768
2384	name2384	380621212562	1844
2385	name2385	380433589711	449
2386	name2386	380844471450	889
2387	name2387	380715549164	33
2388	name2388	380417272015	1374
2389	name2389	380831838587	580
2390	name2390	380195578666	553
2391	name2391	380226431872	1921
2392	name2392	380199733578	1444
2393	name2393	380158661664	1114
2394	name2394	380774873439	1724
2395	name2395	380603543284	971
2396	name2396	380895708312	501
2397	name2397	380640276553	1046
2398	name2398	380337326012	718
2399	name2399	380994768919	1684
2400	name2400	38064063191	1664
2401	name2401	380826157099	1543
2402	name2402	380286065463	1720
2403	name2403	380870246143	708
2404	name2404	380773181485	1249
2405	name2405	380194165898	391
2406	name2406	380935838299	1427
2407	name2407	380466884323	538
2408	name2408	380467241464	967
2409	name2409	380523131448	333
2410	name2410	380248511706	342
2411	name2411	380745297664	1044
2412	name2412	380384636114	307
2413	name2413	380498461584	1836
2414	name2414	380283658932	276
2415	name2415	380819548686	1333
2416	name2416	380270520403	1507
2417	name2417	380590119174	1227
2418	name2418	380869154655	813
2419	name2419	380140813344	240
2420	name2420	380974063446	20
2421	name2421	380234050071	1221
2422	name2422	380671501480	66
2423	name2423	380687731779	1576
2424	name2424	380825933650	1109
2425	name2425	380258923773	1178
2426	name2426	380102250040	357
2427	name2427	380766340667	1571
2428	name2428	380817113310	1064
2429	name2429	380846425562	434
2430	name2430	380207435083	444
2431	name2431	380119258216	413
2432	name2432	380738707995	953
2433	name2433	380877551661	297
2434	name2434	380676623475	133
2435	name2435	380145999994	1160
2436	name2436	380864493263	446
2437	name2437	380597257830	976
2438	name2438	380405277813	57
2439	name2439	380543357213	1892
2440	name2440	38062159503	1488
2441	name2441	380188873217	759
2442	name2442	380130126377	545
2443	name2443	380376707652	519
2444	name2444	380582332958	1040
2445	name2445	380167016893	1789
2446	name2446	380716666980	531
2447	name2447	380920617414	1736
2448	name2448	380201349908	1924
2449	name2449	380818070793	1311
2450	name2450	380848514084	1022
2451	name2451	380881417981	910
2452	name2452	380967449519	525
2453	name2453	380100921416	850
2454	name2454	380490845698	854
2455	name2455	380297521834	789
2456	name2456	380931661718	1847
2457	name2457	38093660057	1207
2458	name2458	380368664368	384
2459	name2459	380357610164	134
2460	name2460	380923457526	1028
2461	name2461	380875829213	616
2462	name2462	380312025325	1513
2463	name2463	38075652023	1332
2464	name2464	380474583280	1744
2465	name2465	380577847630	1671
2466	name2466	380124999873	495
2467	name2467	380598784749	1905
2468	name2468	380297925037	1453
2469	name2469	380632289843	1933
2470	name2470	380286253703	163
2471	name2471	380423814644	1667
2472	name2472	380515377898	1942
2473	name2473	380214214488	337
2474	name2474	380393173318	873
2475	name2475	380875523799	939
2476	name2476	380901284853	1970
2477	name2477	380663830825	1276
2478	name2478	380628039456	1043
2479	name2479	380410757679	1803
2480	name2480	380395943867	744
2481	name2481	380814191230	688
2482	name2482	380416519621	567
2483	name2483	380102707701	1965
2484	name2484	380754968094	1159
2485	name2485	380584650566	162
2486	name2486	380831552892	1965
2487	name2487	380616807572	197
2488	name2488	380471055131	393
2489	name2489	380698517805	1250
2490	name2490	380588474386	1678
2491	name2491	38090770707	1446
2492	name2492	380649234915	267
2493	name2493	380707242666	950
2494	name2494	380802044378	1526
2495	name2495	380194672675	65
2496	name2496	380777305078	1277
2497	name2497	380685856912	133
2498	name2498	380108103558	945
2499	name2499	380781416353	1274
2500	name2500	380830435048	918
2501	name2501	380553077814	540
2502	name2502	380570191373	1407
2503	name2503	380592822413	669
2504	name2504	380731458790	1579
2505	name2505	380277956813	1418
2506	name2506	380726084309	463
2507	name2507	380502002962	797
2508	name2508	380282938634	215
2509	name2509	380592321061	802
2510	name2510	380615405619	1833
2511	name2511	380429265654	1233
2512	name2512	380548551872	363
2513	name2513	380829235872	170
2514	name2514	38054922566	1358
2515	name2515	380937848492	1152
2516	name2516	380622735647	1368
2517	name2517	380262663823	685
2518	name2518	380383702283	165
2519	name2519	380309215844	378
2520	name2520	380449956837	1910
2521	name2521	380708387709	906
2522	name2522	380429887897	828
2523	name2523	380717993069	1329
2524	name2524	38077710000	699
2525	name2525	38052701507	118
2526	name2526	380301553179	1625
2527	name2527	380717044499	327
2528	name2528	380517770767	1225
2529	name2529	380960582391	931
2530	name2530	380476091772	686
2531	name2531	380237496589	156
2532	name2532	380393852265	1040
2533	name2533	380951889243	571
2534	name2534	380459216500	596
2535	name2535	380481088750	1080
2536	name2536	380244260858	1689
2537	name2537	380761065681	255
2538	name2538	380362330544	556
2539	name2539	380598137848	1307
2540	name2540	380777182727	1190
2541	name2541	380866959751	503
2542	name2542	380165355802	1494
2543	name2543	380709292660	1597
2544	name2544	380423737212	1974
2545	name2545	38014434893	1197
2546	name2546	380203759793	894
2547	name2547	380339420718	1819
2548	name2548	380157914309	510
2549	name2549	380683788941	1920
2550	name2550	380759331299	212
2551	name2551	380524326118	609
2552	name2552	38039105082	140
2553	name2553	380798596490	1682
2554	name2554	380213162009	734
2555	name2555	380953081945	546
2556	name2556	380146392729	326
2557	name2557	380514046397	1517
2558	name2558	380408366835	1291
2559	name2559	380388739177	61
2560	name2560	380206481576	1313
2561	name2561	380978387108	1463
2562	name2562	380994514869	364
2563	name2563	38026834221	723
2564	name2564	38039609055	1667
2565	name2565	380307569475	1702
2566	name2566	380113866219	218
2567	name2567	380303873747	1104
2568	name2568	38058644648	1921
2569	name2569	380221066266	526
2570	name2570	380822762720	1181
2571	name2571	380246867222	1641
2572	name2572	380132587628	1465
2573	name2573	380434251297	596
2574	name2574	380804472913	1494
2575	name2575	380690668642	677
2576	name2576	380671714998	1706
2577	name2577	380834365567	646
2578	name2578	380860139144	1319
2579	name2579	380403668388	1561
2580	name2580	380390710159	1393
2581	name2581	38043334473	202
2582	name2582	380203037386	1162
2583	name2583	380316158025	26
2584	name2584	380769354352	1608
2585	name2585	380317505778	1175
2586	name2586	38022083843	690
2587	name2587	380992014279	870
2588	name2588	380247044579	570
2589	name2589	380993353984	379
2590	name2590	380120476738	952
2591	name2591	380216377355	72
2592	name2592	380974896349	590
2593	name2593	380266569711	1036
2594	name2594	380624742342	1562
2595	name2595	380973522383	1456
2596	name2596	380903005094	90
2597	name2597	380912574171	1080
2598	name2598	380951581548	1742
2599	name2599	380184555025	659
2600	name2600	380824209139	1649
2601	name2601	380307845431	174
2602	name2602	38021232375	318
2603	name2603	380778942353	1191
2604	name2604	38031177633	1419
2605	name2605	380497616383	1911
2606	name2606	380426145173	1583
2607	name2607	38042881915	1754
2608	name2608	380600721557	975
2609	name2609	38046230834	1399
2610	name2610	380165306084	783
2611	name2611	380667404675	1325
2612	name2612	380205902763	1853
2613	name2613	380487075367	1559
2614	name2614	380103361059	748
2615	name2615	380596815161	9
2616	name2616	380308927577	1879
2617	name2617	380610517233	1931
2618	name2618	380428732502	1699
2619	name2619	380131133846	1755
2620	name2620	380720215908	166
2621	name2621	380857274062	197
2622	name2622	380688253936	511
2623	name2623	380882786509	1052
2624	name2624	380763816551	1987
2625	name2625	380253346137	145
2626	name2626	38042670101	224
2627	name2627	380136672225	383
2628	name2628	380687002537	303
2629	name2629	380678908026	885
2630	name2630	380995981076	1513
2631	name2631	38063349666	1740
2632	name2632	380841059571	58
2633	name2633	380620859981	1239
2634	name2634	380233494479	904
2635	name2635	380627449730	1337
2636	name2636	380467733811	1295
2637	name2637	380746182264	251
2638	name2638	380293160111	1207
2639	name2639	38098215142	1269
2640	name2640	380406415060	1370
2641	name2641	380745544114	522
2642	name2642	380479991597	552
2643	name2643	380877573679	1791
2644	name2644	380523905968	555
2645	name2645	380544144809	1506
2646	name2646	380804950211	43
2647	name2647	380125285134	1341
2648	name2648	380322699572	1994
2649	name2649	380535483927	928
2650	name2650	380331522279	647
2651	name2651	380983002084	1747
2652	name2652	380744314557	910
2653	name2653	380355272978	48
2654	name2654	380392433752	1184
2655	name2655	380322715052	1602
2656	name2656	380218802532	838
2657	name2657	380534237554	1567
2658	name2658	380895708995	461
2659	name2659	3803802805	40
2660	name2660	380165552431	1590
2661	name2661	380322969744	1853
2662	name2662	380776915891	1707
2663	name2663	380891192378	504
2664	name2664	380397606512	1277
2665	name2665	3807751161	1054
2666	name2666	380429391265	1084
2667	name2667	38029990008	1862
2668	name2668	380773628240	1209
2669	name2669	38087479293	1424
2670	name2670	380216079811	620
2671	name2671	380695037575	1880
2672	name2672	380358307410	1702
2673	name2673	380978220373	1251
2674	name2674	380448041341	1981
2675	name2675	380733468449	815
2676	name2676	380751359940	799
2677	name2677	380188832324	1043
2678	name2678	380221505672	1073
2679	name2679	38031395860	479
2680	name2680	380913511739	1629
2681	name2681	380669527970	193
2682	name2682	380406527122	1514
2683	name2683	380789905169	1731
2684	name2684	380119205707	1190
2685	name2685	380791783288	523
2686	name2686	380747881654	230
2687	name2687	380958702696	1823
2688	name2688	380792621031	196
2689	name2689	380954864553	647
2690	name2690	380298054589	616
2691	name2691	380906887230	25
2692	name2692	380206452386	945
2693	name2693	380429303255	455
2694	name2694	380281305764	1051
2695	name2695	380608769927	656
2696	name2696	380940396183	245
2697	name2697	380804365414	1830
2698	name2698	380468317323	1055
2699	name2699	38078513218	1643
2700	name2700	380785189480	1395
2701	name2701	380384043709	64
2702	name2702	380407397404	751
2703	name2703	380931253541	1288
2704	name2704	380443227375	1355
2705	name2705	380419073432	976
2706	name2706	380548326043	1974
2707	name2707	380101605250	310
2708	name2708	3801254457	177
2709	name2709	38031288117	302
2710	name2710	380749508010	1124
2711	name2711	380374928120	615
2712	name2712	380145518012	1713
2713	name2713	380707264384	349
2714	name2714	380672086347	884
2715	name2715	380335017349	1892
2716	name2716	380444342981	1680
2717	name2717	380952259672	698
2718	name2718	380633140372	788
2719	name2719	38097107066	643
2720	name2720	380554723941	1046
2721	name2721	38010147582	862
2722	name2722	38064238187	318
2723	name2723	380161055051	1963
2724	name2724	380813735483	1372
2725	name2725	380893255187	419
2726	name2726	380454756577	1271
2727	name2727	380410711803	1018
2728	name2728	380575972030	1950
2729	name2729	380516181375	1003
2730	name2730	380657965934	228
2731	name2731	380616810221	697
2732	name2732	380656599304	434
2733	name2733	380693926667	1418
2734	name2734	380511474813	1561
2735	name2735	380327907177	957
2736	name2736	380965814975	1073
2737	name2737	380616719541	1340
2738	name2738	380634933157	575
2739	name2739	380203254079	494
2740	name2740	380582583449	1907
2741	name2741	380137133669	1126
2742	name2742	380982725594	56
2743	name2743	380239884350	1691
2744	name2744	380149562055	1787
2745	name2745	380550431234	376
2746	name2746	380666691598	971
2747	name2747	380951220525	1332
2748	name2748	380191430796	1736
2749	name2749	380283141084	1231
2750	name2750	380845758269	1530
2751	name2751	380984286557	1979
2752	name2752	380207758318	541
2753	name2753	38059913641	390
2754	name2754	380180959113	1359
2755	name2755	380425950903	557
2756	name2756	380689590447	171
2757	name2757	380242538587	617
2758	name2758	380753959009	1357
2759	name2759	380794937152	1974
2760	name2760	380404767545	329
2761	name2761	380441143130	1666
2762	name2762	380176356662	268
2763	name2763	380485660413	1251
2764	name2764	380817320677	1978
2765	name2765	380515109526	482
2766	name2766	380310261745	923
2767	name2767	380902943417	787
2768	name2768	380606047114	1709
2769	name2769	380304887184	892
2770	name2770	380965639756	313
2771	name2771	380274625433	1433
2772	name2772	380259530789	661
2773	name2773	380975978586	1687
2774	name2774	380727503894	759
2775	name2775	380863913694	1568
2776	name2776	380310585707	1515
2777	name2777	380588926002	889
2778	name2778	380740155066	1863
2779	name2779	380127580076	343
2780	name2780	380171617970	1572
2781	name2781	380325719164	1223
2782	name2782	380583398960	1637
2783	name2783	38022939450	1690
2784	name2784	380811107636	1756
2785	name2785	380860909216	1246
2786	name2786	38017198231	1383
2787	name2787	380789749398	506
2788	name2788	380815813060	230
2789	name2789	380337702894	1472
2790	name2790	380249868465	1078
2791	name2791	380897157943	36
2792	name2792	380187030343	1698
2793	name2793	380733899717	1576
2794	name2794	380857144189	1081
2795	name2795	380615635680	1315
2796	name2796	380574056980	1143
2797	name2797	380533825373	1987
2798	name2798	380604795939	1119
2799	name2799	380655125227	1244
2800	name2800	380433794468	400
2801	name2801	380280133148	1368
2802	name2802	380218666687	1246
2803	name2803	380199713326	568
2804	name2804	380780187335	461
2805	name2805	380998843692	388
2806	name2806	380818836046	999
2807	name2807	380302893304	276
2808	name2808	38037068685	1004
2809	name2809	380673248216	1232
2810	name2810	380958058945	1795
2811	name2811	380213476946	813
2812	name2812	380897222571	17
2813	name2813	380903912899	1753
2814	name2814	380350732181	978
2815	name2815	380648599272	685
2816	name2816	380711464304	1180
2817	name2817	380915219475	317
2818	name2818	380772612722	1391
2819	name2819	38075826271	188
2820	name2820	380554788829	1361
2821	name2821	380951510152	762
2822	name2822	380781666258	1108
2823	name2823	380610538395	1986
2824	name2824	380840777475	195
2825	name2825	380411450872	1790
2826	name2826	380838208400	675
2827	name2827	380467560602	1982
2828	name2828	380857242495	1909
2829	name2829	380376786818	163
2830	name2830	380772484658	1416
2831	name2831	380958107094	1192
2832	name2832	380380409616	230
2833	name2833	380345964839	102
2834	name2834	380997713973	1469
2835	name2835	380615794559	447
2836	name2836	380174799220	1623
2837	name2837	380344490375	1763
2838	name2838	380237214649	623
2839	name2839	380130665886	1958
2840	name2840	380612499523	1971
2841	name2841	380278348325	191
2842	name2842	380119486150	790
2843	name2843	380720395967	1001
2844	name2844	380337988024	1576
2845	name2845	380565949526	1695
2846	name2846	380792105905	389
2847	name2847	380366286402	1058
2848	name2848	380180433421	1227
2849	name2849	380135093700	1857
2850	name2850	380664212109	762
2851	name2851	380872085769	1201
2852	name2852	380770006898	1580
2853	name2853	380727217492	42
2854	name2854	380661502041	113
2855	name2855	380990510652	430
2856	name2856	380271782011	1493
2857	name2857	380800199038	191
2858	name2858	380573525729	756
2859	name2859	380320628911	411
2860	name2860	380612064130	824
2861	name2861	380867320017	1558
2862	name2862	380500167430	1534
2863	name2863	380364664761	45
2864	name2864	380667346428	608
2865	name2865	380823368841	1839
2866	name2866	380325277458	1186
2867	name2867	380991584235	312
2868	name2868	380323547393	1725
2869	name2869	380174656182	1277
2870	name2870	38026264830	374
2871	name2871	380673933499	422
2872	name2872	380628877778	757
2873	name2873	380358882828	1350
2874	name2874	380388032278	1708
2875	name2875	380721370445	1308
2876	name2876	380571870464	1561
2877	name2877	380779951692	307
2878	name2878	380949999717	463
2879	name2879	380447315942	317
2880	name2880	380259167785	1956
2881	name2881	380324176983	265
2882	name2882	380351315535	863
2883	name2883	380782944292	1918
2884	name2884	380466105220	344
2885	name2885	38015765842	1482
2886	name2886	380430017490	1501
2887	name2887	380444746702	1642
2888	name2888	38035590854	1043
2889	name2889	380924407615	775
2890	name2890	380708321739	105
2891	name2891	380908176192	483
2892	name2892	380334014396	1380
2893	name2893	380285404960	1169
2894	name2894	380192960049	258
2895	name2895	380321081213	272
2896	name2896	380691810698	541
2897	name2897	380127745737	682
2898	name2898	380624246713	1524
2899	name2899	380178047528	252
2900	name2900	380293858411	723
2901	name2901	380138196669	1664
2902	name2902	380511158545	1208
2903	name2903	380282307608	294
2904	name2904	380502247470	871
2905	name2905	380395875650	1648
2906	name2906	38036098819	1010
2907	name2907	380848082985	54
2908	name2908	380830357339	1227
2909	name2909	380383430865	268
2910	name2910	380449259429	982
2911	name2911	380786261820	807
2912	name2912	380310034157	1728
2913	name2913	380975148162	1974
2914	name2914	38098790285	1589
2915	name2915	380403970292	1132
2916	name2916	380448446965	597
2917	name2917	38091874905	1082
2918	name2918	380162651232	964
2919	name2919	380208286558	1862
2920	name2920	380331573816	1557
2921	name2921	380336065459	84
2922	name2922	380317504965	1274
2923	name2923	380901108842	107
2924	name2924	380248975640	522
2925	name2925	380131622006	1539
2926	name2926	380558879814	679
2927	name2927	380291688912	252
2928	name2928	380869442030	893
2929	name2929	380912251168	499
2930	name2930	380687784181	1799
2931	name2931	380931867701	1618
2932	name2932	380947246478	1478
2933	name2933	380464133490	828
2934	name2934	380317810139	594
2935	name2935	380133515376	1464
2936	name2936	380570261783	1887
2937	name2937	380134785767	248
2938	name2938	380802467622	883
2939	name2939	380385622576	172
2940	name2940	380438317261	1547
2941	name2941	380786686989	1578
2942	name2942	380107112950	203
2943	name2943	380418077154	96
2944	name2944	380775310767	303
2945	name2945	380883764011	1374
2946	name2946	380178571563	1939
2947	name2947	380519180409	823
2948	name2948	380502228195	779
2949	name2949	380249044375	459
2950	name2950	380826725031	225
2951	name2951	380603822674	1993
2952	name2952	380829003941	1345
2953	name2953	380886157637	285
2954	name2954	3807381998	1483
2955	name2955	380738989274	1298
2956	name2956	380637835519	1964
2957	name2957	380895004662	294
2958	name2958	380869252024	27
2959	name2959	380793568287	1222
2960	name2960	380934026971	379
2961	name2961	380277543149	1634
2962	name2962	380137485583	1540
2963	name2963	380911570371	475
2964	name2964	380315686740	1956
2965	name2965	380183608747	1447
2966	name2966	380692853150	1436
2967	name2967	38073762219	215
2968	name2968	380271779012	899
2969	name2969	380514981086	336
2970	name2970	380363156607	278
2971	name2971	380964897918	640
2972	name2972	380148381116	1361
2973	name2973	380430114392	223
2974	name2974	380468967407	1370
2975	name2975	380195370867	1505
2976	name2976	380642916077	1766
2977	name2977	38079309680	951
2978	name2978	3809463517	969
2979	name2979	38020991867	1984
2980	name2980	380591116774	1684
2981	name2981	380273461412	1
2982	name2982	380189311214	1102
2983	name2983	380587140625	1511
2984	name2984	380825169075	842
2985	name2985	380937342427	482
2986	name2986	380380653826	275
2987	name2987	380308777370	1128
2988	name2988	380805633731	1725
2989	name2989	380324798617	383
2990	name2990	380394897724	364
2991	name2991	380841402466	634
2992	name2992	380194243399	1637
2993	name2993	380547935637	1198
2994	name2994	380869821563	1734
2995	name2995	380646304029	247
2996	name2996	380247519822	1359
2997	name2997	380980745587	620
2998	name2998	380624398370	1471
2999	name2999	380993250601	1523
3000	name3000	380908489761	1823
3001	name3001	380290618573	3
3002	name3002	380415556727	1215
3003	name3003	380352707001	271
3004	name3004	380369854409	1656
3005	name3005	380995413946	377
3006	name3006	380769987510	423
3007	name3007	380125840543	1594
3008	name3008	380119168787	1485
3009	name3009	380571455383	1957
3010	name3010	380535221515	155
3011	name3011	38052831117	1920
3012	name3012	380575422535	1671
3013	name3013	380796814359	1287
3014	name3014	380775881360	416
3015	name3015	38077716028	652
3016	name3016	380235514688	1007
3017	name3017	380518034574	1691
3018	name3018	380364693421	1612
3019	name3019	380971228188	654
3020	name3020	380195239995	245
3021	name3021	380706127029	874
3022	name3022	380518102696	296
3023	name3023	380302488268	753
3024	name3024	380247436151	1113
3025	name3025	380113958341	1255
3026	name3026	380990860595	1596
3027	name3027	380977276807	306
3028	name3028	380822887620	1674
3029	name3029	380172415043	1329
3030	name3030	380263573145	410
3031	name3031	380236855086	1309
3032	name3032	380488575386	1962
3033	name3033	380842930624	712
3034	name3034	380875850182	1318
3035	name3035	380839462940	1684
3036	name3036	380792160876	308
3037	name3037	380870711476	1356
3038	name3038	380822455176	12
3039	name3039	380869861539	636
3040	name3040	3808579097	1122
3041	name3041	380413519339	1929
3042	name3042	380340915670	1442
3043	name3043	380874398726	1246
3044	name3044	380949798698	1562
3045	name3045	38028012714	704
3046	name3046	380379736226	941
3047	name3047	380574467716	956
3048	name3048	380915817950	1912
3049	name3049	380917894786	1041
3050	name3050	380903104576	1745
3051	name3051	380434945915	1062
3052	name3052	380145563274	650
3053	name3053	380639562052	19
3054	name3054	38020367707	1522
3055	name3055	380661903432	1539
3056	name3056	380650423918	1968
3057	name3057	380841322787	827
3058	name3058	380739273124	1941
3059	name3059	380471849495	316
3060	name3060	38038700342	1281
3061	name3061	380316909134	423
3062	name3062	380146841937	1401
3063	name3063	380549953632	463
3064	name3064	380152397698	634
3065	name3065	380683917697	918
3066	name3066	380689709879	771
3067	name3067	380724576050	1829
3068	name3068	380902817332	576
3069	name3069	380369582414	38
3070	name3070	380328910393	1267
3071	name3071	380898232350	1923
3072	name3072	380300671217	466
3073	name3073	380582136962	832
3074	name3074	3807575615	105
3075	name3075	380949590524	1103
3076	name3076	380100474533	1281
3077	name3077	380363813352	707
3078	name3078	380622216931	1642
3079	name3079	380556667162	1140
3080	name3080	380816393049	70
3081	name3081	380224725489	775
3082	name3082	380510561994	54
3083	name3083	380978094078	1163
3084	name3084	380794292259	1875
3085	name3085	380824602626	1235
3086	name3086	38045939999	1347
3087	name3087	380697830109	87
3088	name3088	38047337370	1422
3089	name3089	380546294635	1700
3090	name3090	380897616977	1013
3091	name3091	380310284811	882
3092	name3092	380263134801	1544
3093	name3093	380951520208	1785
3094	name3094	380719108131	1113
3095	name3095	38059415146	719
3096	name3096	380680219906	1472
3097	name3097	380151447188	352
3098	name3098	380756280151	933
3099	name3099	380399492177	1474
3100	name3100	380899939775	146
3101	name3101	380203982713	907
3102	name3102	380121073345	589
3103	name3103	380810076218	1905
3104	name3104	380463837126	34
3105	name3105	380173336298	1989
3106	name3106	380205116527	1430
3107	name3107	380757074994	390
3108	name3108	380582019280	50
3109	name3109	380378352994	267
3110	name3110	38063697386	169
3111	name3111	380170004155	376
3112	name3112	380468327765	627
3113	name3113	380302772831	1204
3114	name3114	380190932624	1491
3115	name3115	380517761991	1929
3116	name3116	380625167097	1423
3117	name3117	380347058504	295
3118	name3118	380241126038	1167
3119	name3119	380567034597	1079
3120	name3120	380254488547	600
3121	name3121	38037472241	1308
3122	name3122	380191904004	925
3123	name3123	380145152914	1108
3124	name3124	380959663954	76
3125	name3125	380959026538	1150
3126	name3126	380657597085	1547
3127	name3127	380789743277	122
3128	name3128	380581958817	95
3129	name3129	380795758559	1434
3130	name3130	380465438714	1223
3131	name3131	380528387281	49
3132	name3132	380499280741	1573
3133	name3133	380711086001	167
3134	name3134	380824547777	278
3135	name3135	380310898992	812
3136	name3136	380946221583	1273
3137	name3137	380415019718	20
3138	name3138	38023546409	403
3139	name3139	380823526916	1821
3140	name3140	380913637312	1341
3141	name3141	380691586929	1896
3142	name3142	380365357977	1390
3143	name3143	380697808718	268
3144	name3144	380301751292	1016
3145	name3145	380712434931	1364
3146	name3146	380218678253	391
3147	name3147	38026987464	287
3148	name3148	380159782364	759
3149	name3149	380970340540	1345
3150	name3150	380569385502	948
3151	name3151	380800503326	1478
3152	name3152	380802271491	48
3153	name3153	380223971472	512
3154	name3154	380179447986	1886
3155	name3155	380433393175	886
3156	name3156	380180617693	1554
3157	name3157	38063084170	571
3158	name3158	380496520446	1564
3159	name3159	380214376469	1027
3160	name3160	380268968283	922
3161	name3161	380957374711	1505
3162	name3162	380348339881	1051
3163	name3163	380826518264	1729
3164	name3164	380135797909	1465
3165	name3165	380334026988	890
3166	name3166	380449305614	1904
3167	name3167	380350803242	1780
3168	name3168	380383638383	1392
3169	name3169	380995851852	690
3170	name3170	38042454605	922
3171	name3171	380479517257	1626
3172	name3172	380394994549	1473
3173	name3173	380216633981	1465
3174	name3174	3801740497	341
3175	name3175	380317429289	564
3176	name3176	380296133313	256
3177	name3177	38071376380	683
3178	name3178	380283539338	488
3179	name3179	380799435760	635
3180	name3180	380293921302	775
3181	name3181	380930657219	1571
3182	name3182	380302206532	143
3183	name3183	380709235094	1590
3184	name3184	380434094130	899
3185	name3185	380790016773	1433
3186	name3186	380124993779	384
3187	name3187	380741032195	1386
3188	name3188	380330274887	888
3189	name3189	380952525016	1698
3190	name3190	38052521699	1652
3191	name3191	380342144258	372
3192	name3192	380807853894	1742
3193	name3193	38036419615	583
3194	name3194	380341239027	427
3195	name3195	380936230049	438
3196	name3196	38059753950	1372
3197	name3197	380856551131	622
3198	name3198	380405952833	315
3199	name3199	380922858618	132
3200	name3200	38014517874	54
3201	name3201	380210553785	539
3202	name3202	380638781584	140
3203	name3203	380838059316	17
3204	name3204	380441576131	1312
3205	name3205	380286027737	1069
3206	name3206	38024084328	321
3207	name3207	380641767140	742
3208	name3208	380462614317	235
3209	name3209	380357048996	1771
3210	name3210	380498500098	1243
3211	name3211	38061734797	325
3212	name3212	380778421289	1693
3213	name3213	380736117442	444
3214	name3214	380685762221	188
3215	name3215	380700189557	1602
3216	name3216	38062341417	163
3217	name3217	380935938477	1866
3218	name3218	380365127719	1326
3219	name3219	380520558070	1265
3220	name3220	380697486672	440
3221	name3221	380534561202	62
3222	name3222	380150902977	417
3223	name3223	380838879821	1902
3224	name3224	380756318932	617
3225	name3225	380953342186	15
3226	name3226	380162598301	1550
3227	name3227	380900618913	1603
3228	name3228	380827347634	806
3229	name3229	380891570533	1101
3230	name3230	380447776580	1764
3231	name3231	38021628464	380
3232	name3232	380801885708	1857
3233	name3233	380421603492	848
3234	name3234	38032869962	1985
3235	name3235	380495811116	1131
3236	name3236	380939575327	674
3237	name3237	380156874010	707
3238	name3238	380374443868	474
3239	name3239	380545967053	236
3240	name3240	380658367174	741
3241	name3241	380650618826	421
3242	name3242	380771034854	981
3243	name3243	380433466604	282
3244	name3244	380344570576	475
3245	name3245	380469739559	1185
3246	name3246	380783348359	1906
3247	name3247	3802391961	254
3248	name3248	380681369709	706
3249	name3249	380685576373	1802
3250	name3250	380660969271	712
3251	name3251	380860950910	1111
3252	name3252	380257830993	166
3253	name3253	380816895660	946
3254	name3254	380152633118	1868
3255	name3255	380684188774	791
3256	name3256	380581041564	118
3257	name3257	380301046414	1621
3258	name3258	380303473588	1348
3259	name3259	380734852063	1108
3260	name3260	380685876184	1411
3261	name3261	380123626110	1290
3262	name3262	38038573538	1891
3263	name3263	380261852676	1475
3264	name3264	380762372858	1224
3265	name3265	380337342527	471
3266	name3266	380572796778	855
3267	name3267	380456934047	80
3268	name3268	380120313706	888
3269	name3269	380394914565	97
3270	name3270	380250587219	44
3271	name3271	380779264241	1274
3272	name3272	380232989960	1976
3273	name3273	380822299395	1272
3274	name3274	38037635609	776
3275	name3275	380734815026	1163
3276	name3276	380974036257	225
3277	name3277	38096366651	1877
3278	name3278	380993602429	454
3279	name3279	380303194131	1004
3280	name3280	380737532407	1704
3281	name3281	380260089518	935
3282	name3282	38039143928	1277
3283	name3283	380710369607	1684
3284	name3284	380245298394	161
3285	name3285	380918738980	1638
3286	name3286	380782136970	320
3287	name3287	380863374225	699
3288	name3288	380157583289	1055
3289	name3289	380688427735	1174
3290	name3290	380131182724	714
3291	name3291	380595143470	789
3292	name3292	380353428876	1629
3293	name3293	380805255994	31
3294	name3294	380646259552	1616
3295	name3295	380657286816	1704
3296	name3296	3802256872	1471
3297	name3297	380606488968	443
3298	name3298	380756987016	65
3299	name3299	380779607757	1308
3300	name3300	380454192547	125
3301	name3301	380637497088	1982
3302	name3302	38021676116	548
3303	name3303	380861987528	1190
3304	name3304	3806930024	1745
3305	name3305	380658091209	1274
3306	name3306	380861620895	907
3307	name3307	380641869679	1549
3308	name3308	380813323504	88
3309	name3309	380273488063	1916
3310	name3310	380744503851	832
3311	name3311	380794691706	1060
3312	name3312	380456236838	1910
3313	name3313	38018172304	1574
3314	name3314	380621037363	402
3315	name3315	38071494853	781
3316	name3316	380993509062	66
3317	name3317	380710732498	1457
3318	name3318	380755865949	321
3319	name3319	380594518066	1288
3320	name3320	380852328639	102
3321	name3321	380775315665	1433
3322	name3322	380606254955	224
3323	name3323	38045385948	126
3324	name3324	380693111895	56
3325	name3325	3807270190	946
3326	name3326	380462260489	956
3327	name3327	38059697472	1580
3328	name3328	380960534388	754
3329	name3329	380229056600	870
3330	name3330	380495108388	1817
3331	name3331	380445201297	17
3332	name3332	38064175514	1857
3333	name3333	380235451404	265
3334	name3334	380194727108	472
3335	name3335	380767718765	707
3336	name3336	38081939314	422
3337	name3337	380927927510	297
3338	name3338	380894225853	241
3339	name3339	380689586157	1567
3340	name3340	380232766043	1451
3341	name3341	380165967192	1473
3342	name3342	380863155473	143
3343	name3343	380130297627	44
3344	name3344	380626032389	1036
3345	name3345	380462676770	397
3346	name3346	380940330829	801
3347	name3347	380669528404	1197
3348	name3348	380546461111	475
3349	name3349	380583777648	1203
3350	name3350	380711649845	1978
3351	name3351	380590718527	807
3352	name3352	380686456120	1655
3353	name3353	380498822670	729
3354	name3354	380112661655	1862
3355	name3355	380921439483	623
3356	name3356	380781804440	1321
3357	name3357	380122931490	734
3358	name3358	38046684365	226
3359	name3359	380758013870	341
3360	name3360	380359024891	821
3361	name3361	380283680356	1011
3362	name3362	380107247352	436
3363	name3363	380950100511	535
3364	name3364	380158802562	415
3365	name3365	380273871952	1371
3366	name3366	380931853990	1240
3367	name3367	380890608509	107
3368	name3368	380983560947	1749
3369	name3369	380895226272	1656
3370	name3370	380698973577	1775
3371	name3371	380122402484	558
3372	name3372	380530047882	852
3373	name3373	380764675512	641
3374	name3374	380121346320	863
3375	name3375	380791471869	1171
3376	name3376	380339729894	1738
3377	name3377	380813641167	232
3378	name3378	380248817810	1235
3379	name3379	380592848603	108
3380	name3380	380538810132	503
3381	name3381	380846771554	1880
3382	name3382	380938829878	1152
3383	name3383	380857483973	581
3384	name3384	38081940417	1722
3385	name3385	380991099298	1771
3386	name3386	380901328283	1364
3387	name3387	380293075814	1713
3388	name3388	380873446074	623
3389	name3389	380126042626	224
3390	name3390	380399274711	1940
3391	name3391	380737635735	1707
3392	name3392	380359505723	1278
3393	name3393	380471348011	1036
3394	name3394	380561366391	1389
3395	name3395	380120191681	145
3396	name3396	380984735112	1057
3397	name3397	380471806505	1590
3398	name3398	380618291484	806
3399	name3399	380797847946	650
3400	name3400	380635647035	219
3401	name3401	380767848461	1096
3402	name3402	380439327699	871
3403	name3403	38092511820	208
3404	name3404	380778256290	127
3405	name3405	380209032865	1621
3406	name3406	380456895583	1789
3407	name3407	380364607435	1238
3408	name3408	380192552268	778
3409	name3409	380647724776	1170
3410	name3410	380310501919	1198
3411	name3411	380406322143	190
3412	name3412	380845679977	757
3413	name3413	380253248879	171
3414	name3414	380409173007	581
3415	name3415	380525282953	1773
3416	name3416	380689585835	1106
3417	name3417	380688495554	945
3418	name3418	380646927602	45
3419	name3419	38023579262	1404
3420	name3420	380756855330	103
3421	name3421	38082939680	285
3422	name3422	380956145191	256
3423	name3423	38099897402	341
3424	name3424	380427878342	1435
3425	name3425	380975538115	1732
3426	name3426	380449042538	715
3427	name3427	380648001416	1646
3428	name3428	380798832459	216
3429	name3429	380460851138	727
3430	name3430	380981200173	815
3431	name3431	380267297063	1191
3432	name3432	380666907752	1545
3433	name3433	380590462527	879
3434	name3434	380929626226	763
3435	name3435	380705791417	1694
3436	name3436	380318466027	682
3437	name3437	380613453988	1241
3438	name3438	380370777868	1059
3439	name3439	380228072583	224
3440	name3440	380437316391	796
3441	name3441	380104048966	118
3442	name3442	380183976051	1252
3443	name3443	380237272088	919
3444	name3444	380502004804	188
3445	name3445	380156929915	1893
3446	name3446	380608567484	129
3447	name3447	380217250500	294
3448	name3448	380799090998	404
3449	name3449	380132128527	1831
3450	name3450	380617954138	405
3451	name3451	380427003811	498
3452	name3452	3808079562	1228
3453	name3453	380418391743	1483
3454	name3454	38012295474	1095
3455	name3455	380141688178	537
3456	name3456	380405365833	6
3457	name3457	380138764186	127
3458	name3458	380199487150	402
3459	name3459	380852492800	138
3460	name3460	380359759446	1259
3461	name3461	380942651450	421
3462	name3462	380259252681	104
3463	name3463	380110269074	347
3464	name3464	380549491660	1385
3465	name3465	38078315166	472
3466	name3466	380549296631	1056
3467	name3467	380415387825	1268
3468	name3468	380396854819	708
3469	name3469	380897701302	1560
3470	name3470	38029685	253
3471	name3471	380149409321	1921
3472	name3472	380596646243	1384
3473	name3473	380156444514	1786
3474	name3474	380493082784	1464
3475	name3475	380334102138	241
3476	name3476	380391402366	1043
3477	name3477	380796174937	1768
3478	name3478	380669499661	1426
3479	name3479	380452050677	919
3480	name3480	380831144799	1217
3481	name3481	380959856266	1144
3482	name3482	380960079893	1668
3483	name3483	380523086439	1183
3484	name3484	380637276052	1447
3485	name3485	380435406821	248
3486	name3486	38069908351	1459
3487	name3487	380595228954	859
3488	name3488	380286741668	665
3489	name3489	380455525149	789
3490	name3490	38031846935	368
3491	name3491	380161517779	832
3492	name3492	380439125372	392
3493	name3493	380225310036	758
3494	name3494	380923001103	1189
3495	name3495	380279471093	901
3496	name3496	38069597280	1843
3497	name3497	380892408315	275
3498	name3498	380520352188	961
3499	name3499	380262958345	1999
3500	name3500	380446350092	299
3501	name3501	380121143940	1342
3502	name3502	380366437198	671
3503	name3503	380292688138	1855
3504	name3504	38032217290	1783
3505	name3505	380452105166	884
3506	name3506	380685856025	1110
3507	name3507	380597577146	599
3508	name3508	380204578553	1113
3509	name3509	380207344791	105
3510	name3510	380304312048	1155
3511	name3511	380581895379	1541
3512	name3512	380411553593	1600
3513	name3513	380589657909	85
3514	name3514	380592791311	751
3515	name3515	380389816696	154
3516	name3516	380630124362	1956
3517	name3517	380588943997	1838
3518	name3518	380612428105	1833
3519	name3519	380528005063	1494
3520	name3520	380205589715	1788
3521	name3521	380381662027	744
3522	name3522	380145786226	587
3523	name3523	380816925808	1225
3524	name3524	380852154164	1709
3525	name3525	380638700207	48
3526	name3526	380446025690	972
3527	name3527	380762101058	419
3528	name3528	380630115914	747
3529	name3529	380856082407	939
3530	name3530	38048169561	1646
3531	name3531	380467568733	33
3532	name3532	380512806944	1190
3533	name3533	380820923034	1101
3534	name3534	380301005215	647
3535	name3535	380136018990	81
3536	name3536	380971032117	1918
3537	name3537	380216647453	854
3538	name3538	380781743914	1074
3539	name3539	380584759891	1678
3540	name3540	380167263182	883
3541	name3541	380267067743	407
3542	name3542	38039242619	1354
3543	name3543	380765719380	985
3544	name3544	380527399648	903
3545	name3545	38094420061	328
3546	name3546	380219307486	411
3547	name3547	380113662535	498
3548	name3548	380883769937	938
3549	name3549	38013531834	835
3550	name3550	380804420129	143
3551	name3551	380402855395	1683
3552	name3552	380126595499	896
3553	name3553	380460120877	801
3554	name3554	380650350510	553
3555	name3555	380302328740	1189
3556	name3556	380507885791	1082
3557	name3557	380328685959	1079
3558	name3558	380626864778	1374
3559	name3559	380758100902	440
3560	name3560	380885305719	1225
3561	name3561	380613005871	1080
3562	name3562	380825547643	758
3563	name3563	380862247159	593
3564	name3564	380325717378	1795
3565	name3565	380854023245	1542
3566	name3566	380544207431	153
3567	name3567	380799218542	1862
3568	name3568	380488727314	1401
3569	name3569	380725576757	16
3570	name3570	380107112976	719
3571	name3571	380485604087	1084
3572	name3572	38037677040	232
3573	name3573	380363412576	613
3574	name3574	380249245369	1456
3575	name3575	380477511631	1704
3576	name3576	380265230840	481
3577	name3577	380768129414	1147
3578	name3578	380949779630	894
3579	name3579	380837452394	104
3580	name3580	38037298956	805
3581	name3581	380804793037	1679
3582	name3582	380617211797	108
3583	name3583	380798217758	1026
3584	name3584	380744868708	1790
3585	name3585	380263121982	252
3586	name3586	380731111198	372
3587	name3587	380993521971	70
3588	name3588	380978908929	96
3589	name3589	380930248197	811
3590	name3590	380961725972	1334
3591	name3591	380643565984	1363
3592	name3592	380207497027	1723
3593	name3593	380226570887	985
3594	name3594	380400047640	44
3595	name3595	380678194409	1017
3596	name3596	380513450780	1940
3597	name3597	380243250549	664
3598	name3598	380522017929	186
3599	name3599	380281633646	221
3600	name3600	380949911611	1444
3601	name3601	380842159622	1921
3602	name3602	380519033516	1683
3603	name3603	380572203660	1339
3604	name3604	380873530172	1144
3605	name3605	380195967934	858
3606	name3606	380493592119	991
3607	name3607	38049802813	575
3608	name3608	380631281599	1080
3609	name3609	380883471634	65
3610	name3610	38037771781	1608
3611	name3611	380405913521	518
3612	name3612	380696744443	246
3613	name3613	380554875362	468
3614	name3614	380880314582	1221
3615	name3615	380288530487	829
3616	name3616	38092296957	1387
3617	name3617	380650735287	1702
3618	name3618	380555591653	133
3619	name3619	380531561833	1508
3620	name3620	38090624879	1960
3621	name3621	380619517201	1059
3622	name3622	380567978575	379
3623	name3623	380219310753	1459
3624	name3624	380485828918	594
3625	name3625	380220695386	911
3626	name3626	380904614414	1417
3627	name3627	380176650343	1080
3628	name3628	380463025646	1196
3629	name3629	380527116269	504
3630	name3630	380297723915	1760
3631	name3631	380110121086	1987
3632	name3632	380405535259	51
3633	name3633	380121702320	1889
3634	name3634	380617346275	385
3635	name3635	380620698258	1956
3636	name3636	38068551425	797
3637	name3637	380204827915	1742
3638	name3638	380652255576	703
3639	name3639	380752309129	68
3640	name3640	380953725111	625
3641	name3641	380140836480	1951
3642	name3642	380230022770	470
3643	name3643	380108866561	674
3644	name3644	380554623612	1492
3645	name3645	380641788769	1374
3646	name3646	380758627426	727
3647	name3647	380984790307	1873
3648	name3648	380350930798	1570
3649	name3649	380845862096	1345
3650	name3650	380416974466	883
3651	name3651	380418499233	863
3652	name3652	38030042732	865
3653	name3653	38044711353	1629
3654	name3654	380158427272	1865
3655	name3655	380744590682	534
3656	name3656	380757017043	1052
3657	name3657	380562031299	514
3658	name3658	380651479069	741
3659	name3659	380628416594	873
3660	name3660	380324412561	333
3661	name3661	380113627357	1118
3662	name3662	380199519719	1380
3663	name3663	380897183556	1049
3664	name3664	380447290673	549
3665	name3665	380982235667	1288
3666	name3666	380445010326	601
3667	name3667	380805835021	1717
3668	name3668	380158549238	1186
3669	name3669	380128483924	502
3670	name3670	380363073634	899
3671	name3671	380905732361	1643
3672	name3672	380366956761	1513
3673	name3673	380308729183	1708
3674	name3674	380229489431	904
3675	name3675	38022076379	600
3676	name3676	380904006476	1475
3677	name3677	380772648838	1002
3678	name3678	380155421356	1534
3679	name3679	380235266444	439
3680	name3680	380373399974	434
3681	name3681	380825623004	908
3682	name3682	380616089981	1604
3683	name3683	380335769550	1583
3684	name3684	380474105784	1825
3685	name3685	380635982102	451
3686	name3686	380566367060	1462
3687	name3687	380255980433	1643
3688	name3688	380168152696	1815
3689	name3689	38083579066	196
3690	name3690	38089342787	7
3691	name3691	380141035531	1231
3692	name3692	380659368429	1420
3693	name3693	380137982932	455
3694	name3694	380623882036	1960
3695	name3695	380309261904	1772
3696	name3696	38019044307	1441
3697	name3697	380441606085	998
3698	name3698	380176732226	184
3699	name3699	380568186602	15
3700	name3700	380897003682	991
3701	name3701	380190622762	802
3702	name3702	380259694939	30
3703	name3703	380530716161	14
3704	name3704	380877908832	1996
3705	name3705	380555588077	1082
3706	name3706	380771671068	249
3707	name3707	380445759145	1307
3708	name3708	38047115699	1930
3709	name3709	380280826418	1020
3710	name3710	380541105359	1142
3711	name3711	380986370987	818
3712	name3712	380410360938	1821
3713	name3713	380529152087	1552
3714	name3714	380581686070	506
3715	name3715	380685238774	1146
3716	name3716	380237549204	827
3717	name3717	380794165187	1082
3718	name3718	380321419429	2
3719	name3719	380671408288	171
3720	name3720	380771533135	218
3721	name3721	380849708381	884
3722	name3722	380623841917	1147
3723	name3723	380833625459	771
3724	name3724	380234801949	1384
3725	name3725	380324177055	1407
3726	name3726	380514726422	1931
3727	name3727	380945183612	620
3728	name3728	380685299797	564
3729	name3729	380920972918	269
3730	name3730	380295876418	482
3731	name3731	380954025428	1793
3732	name3732	380100189752	1822
3733	name3733	380415830973	541
3734	name3734	380510305685	1761
3735	name3735	38031958604	1604
3736	name3736	380514396452	859
3737	name3737	380973008471	179
3738	name3738	380814215161	128
3739	name3739	380940745664	1546
3740	name3740	38098457699	1215
3741	name3741	380677003544	230
3742	name3742	380707773496	830
3743	name3743	380303685497	1080
3744	name3744	380544975603	1308
3745	name3745	380381797348	1009
3746	name3746	380728979158	122
3747	name3747	380852905902	1828
3748	name3748	380940288948	136
3749	name3749	380458438108	533
3750	name3750	380776149797	1428
3751	name3751	380179346816	966
3752	name3752	380651523157	1686
3753	name3753	380962585199	256
3754	name3754	380801294314	410
3755	name3755	380859372076	886
3756	name3756	380460670347	1504
3757	name3757	380350507770	1476
3758	name3758	38018345036	1695
3759	name3759	380624767537	543
3760	name3760	380856692339	272
3761	name3761	380614711994	233
3762	name3762	380759656880	1509
3763	name3763	380927854224	18
3764	name3764	380761831907	347
3765	name3765	380574205444	301
3766	name3766	380157137682	397
3767	name3767	380417480989	2
3768	name3768	38055494789	375
3769	name3769	380790372776	145
3770	name3770	380339804336	1953
3771	name3771	380462300952	922
3772	name3772	380682485000	136
3773	name3773	380954135588	675
3774	name3774	380949533273	856
3775	name3775	380553143871	728
3776	name3776	380334421358	219
3777	name3777	380635727398	1949
3778	name3778	380556486500	859
3779	name3779	380695261577	1719
3780	name3780	380194341927	1894
3781	name3781	380552883847	1013
3782	name3782	380283466188	272
3783	name3783	380413159803	30
3784	name3784	380883447918	793
3785	name3785	380310004986	906
3786	name3786	380355726926	1921
3787	name3787	380775676174	1985
3788	name3788	380972407349	62
3789	name3789	380218992383	1156
3790	name3790	380814125636	1498
3791	name3791	380587584894	274
3792	name3792	380472514330	783
3793	name3793	380926725446	966
3794	name3794	380652610023	1081
3795	name3795	380157592776	479
3796	name3796	380937289863	505
3797	name3797	380254870244	389
3798	name3798	380756757653	896
3799	name3799	380553052881	1569
3800	name3800	380843947505	1695
3801	name3801	380780886886	1185
3802	name3802	380272324573	1903
3803	name3803	38091600070	1536
3804	name3804	38025789841	399
3805	name3805	380146319673	142
3806	name3806	380168615259	56
3807	name3807	380742371453	1606
3808	name3808	380158432326	1582
3809	name3809	38026944401	1039
3810	name3810	380481139704	1975
3811	name3811	380748302984	1173
3812	name3812	380810277422	1341
3813	name3813	380811960837	583
3814	name3814	380924799167	1968
3815	name3815	380910605423	1269
3816	name3816	380824517004	254
3817	name3817	380754632218	1312
3818	name3818	380619184633	135
3819	name3819	380761957603	1822
3820	name3820	380857882415	507
3821	name3821	380128688996	90
3822	name3822	380621051820	909
3823	name3823	380101876494	1203
3824	name3824	380640272247	1233
3825	name3825	380473157767	982
3826	name3826	380828348847	1645
3827	name3827	380772420951	1185
3828	name3828	380897275634	1667
3829	name3829	380568399725	565
3830	name3830	380821137797	578
3831	name3831	380951773417	1693
3832	name3832	380180606444	1746
3833	name3833	380359022801	82
3834	name3834	3806314672	1627
3835	name3835	380864860203	459
3836	name3836	380943829024	548
3837	name3837	380641569329	1255
3838	name3838	380407263959	1490
3839	name3839	380522180393	1912
3840	name3840	380774871875	787
3841	name3841	380248703262	1856
3842	name3842	380911679509	1931
3843	name3843	380659204989	987
3844	name3844	380523199750	108
3845	name3845	380484879185	104
3846	name3846	380289063017	513
3847	name3847	380358495660	1816
3848	name3848	380236779758	140
3849	name3849	380264646139	1279
3850	name3850	380795320332	80
3851	name3851	380185115467	1856
3852	name3852	38028891216	112
3853	name3853	380352924292	726
3854	name3854	380379984527	828
3855	name3855	380983626232	593
3856	name3856	380732274786	1080
3857	name3857	380151518133	560
3858	name3858	38039598337	472
3859	name3859	380593277964	696
3860	name3860	38051101818	93
3861	name3861	380978147866	240
3862	name3862	380559507593	805
3863	name3863	380598808850	747
3864	name3864	380800902588	1750
3865	name3865	380869367507	655
3866	name3866	38049696963	1453
3867	name3867	380200128990	1280
3868	name3868	380222180018	1427
3869	name3869	380748495397	1856
3870	name3870	380305409927	1685
3871	name3871	380348221262	375
3872	name3872	380582336375	1771
3873	name3873	380741337067	84
3874	name3874	38060331808	1798
3875	name3875	380340647534	1318
3876	name3876	380738262179	724
3877	name3877	380418883140	396
3878	name3878	380802398176	1185
3879	name3879	380122511987	1893
3880	name3880	380742111846	1904
3881	name3881	380485792758	1473
3882	name3882	380596266277	810
3883	name3883	38012644582	223
3884	name3884	380237177361	413
3885	name3885	380620427565	312
3886	name3886	380611724772	1560
3887	name3887	380525790818	577
3888	name3888	380439252245	428
3889	name3889	380776208960	481
3890	name3890	38056512113	1123
3891	name3891	380336017895	633
3892	name3892	380139461145	543
3893	name3893	380760483867	664
3894	name3894	380420986855	1487
3895	name3895	380311286350	268
3896	name3896	380933348247	1010
3897	name3897	380566878101	206
3898	name3898	380279789272	1976
3899	name3899	380421729104	1680
3900	name3900	380892328316	198
3901	name3901	38016893195	647
3902	name3902	380984123141	250
3903	name3903	380302790909	552
3904	name3904	38089790210	555
3905	name3905	380298488770	232
3906	name3906	380992764926	328
3907	name3907	380347799280	780
3908	name3908	380795712097	1167
3909	name3909	38021439816	856
3910	name3910	380108694914	759
3911	name3911	380562177284	1669
3912	name3912	380109233087	755
3913	name3913	380254843103	365
3914	name3914	380742786669	1435
3915	name3915	380573408186	1270
3916	name3916	380234985376	1601
3917	name3917	380500371005	628
3918	name3918	380450857649	312
3919	name3919	380337685769	1423
3920	name3920	380281007159	157
3921	name3921	380780460727	1898
3922	name3922	380273270333	1993
3923	name3923	380287221459	845
3924	name3924	380196737264	1035
3925	name3925	380593933998	144
3926	name3926	380938000044	1093
3927	name3927	380133344053	143
3928	name3928	380440070511	289
3929	name3929	380788543167	1739
3930	name3930	380312598131	182
3931	name3931	380882359080	807
3932	name3932	380901986037	975
3933	name3933	380812235920	206
3934	name3934	380854847618	1557
3935	name3935	38076796577	318
3936	name3936	38093232037	207
3937	name3937	380989749136	1037
3938	name3938	380416328142	519
3939	name3939	380977957498	1324
3940	name3940	380255467424	574
3941	name3941	380601334161	1007
3942	name3942	380898269	1641
3943	name3943	380630984016	42
3944	name3944	380872756517	917
3945	name3945	380554457723	386
3946	name3946	380827711488	1219
3947	name3947	380166066884	200
3948	name3948	380580144934	640
3949	name3949	380291316233	912
3950	name3950	380855377566	1152
3951	name3951	380594527642	1282
3952	name3952	38074096184	963
3953	name3953	380484673031	406
3954	name3954	380302958844	1030
3955	name3955	380952664018	725
3956	name3956	380782846785	1550
3957	name3957	380777229692	1603
3958	name3958	380370471819	48
3959	name3959	380266337359	813
3960	name3960	380539375947	205
3961	name3961	380816450405	954
3962	name3962	380485393243	1684
3963	name3963	380182850399	1132
3964	name3964	380679941776	1995
3965	name3965	380644074310	1209
3966	name3966	380854417286	1660
3967	name3967	380611876260	1655
3968	name3968	38059392296	551
3969	name3969	380899700927	961
3970	name3970	380706571467	703
3971	name3971	380592844212	517
3972	name3972	380701224283	832
3973	name3973	380588670181	861
3974	name3974	380403094223	682
3975	name3975	380261678654	132
3976	name3976	380784268717	68
3977	name3977	380409457439	1090
3978	name3978	38042651588	751
3979	name3979	38015163864	568
3980	name3980	380585686332	1002
3981	name3981	380914067079	750
3982	name3982	380492094750	1099
3983	name3983	380197132523	1996
3984	name3984	380856543235	1837
3985	name3985	380431161910	591
3986	name3986	38060729577	40
3987	name3987	380178439856	1091
3988	name3988	380984612569	10
3989	name3989	380576261892	886
3990	name3990	380650803846	729
3991	name3991	38034201479	695
3992	name3992	380610346541	735
3993	name3993	380932260510	224
3994	name3994	380952563195	17
3995	name3995	380989580817	925
3996	name3996	38095441714	54
3997	name3997	380748342549	554
3998	name3998	380605853101	1711
3999	name3999	380902675317	1
4000	name4000	380216461970	1281
4001	name4001	380183369343	20
4002	name4002	380672046669	803
4003	name4003	380663558591	28
4004	name4004	380564095911	1308
4005	name4005	380133778404	846
4006	name4006	380903377141	1192
4007	name4007	38036702352	1212
4008	name4008	380595441383	1409
4009	name4009	380224500348	726
4010	name4010	380267995028	84
4011	name4011	38074866344	181
4012	name4012	380913987219	1131
4013	name4013	380308428621	847
4014	name4014	380797822979	17
4015	name4015	380341770760	655
4016	name4016	380769583865	1642
4017	name4017	380285313401	579
4018	name4018	380835242206	33
4019	name4019	380244742691	103
4020	name4020	380686668272	826
4021	name4021	380199941647	1807
4022	name4022	380129632855	1049
4023	name4023	380383970238	253
4024	name4024	380579466905	1348
4025	name4025	380163087292	84
4026	name4026	380394752418	1248
4027	name4027	380949543943	1943
4028	name4028	380312101964	153
4029	name4029	380423570429	553
4030	name4030	3804941418	369
4031	name4031	380459279332	1584
4032	name4032	380851852594	613
4033	name4033	380938078715	955
4034	name4034	380557389549	1645
4035	name4035	38038185595	118
4036	name4036	380465782827	348
4037	name4037	380585029609	514
4038	name4038	380337498445	559
4039	name4039	380643787867	1889
4040	name4040	380673174149	1980
4041	name4041	38063165070	906
4042	name4042	38026184665	892
4043	name4043	380180363281	853
4044	name4044	380315450577	90
4045	name4045	380833872466	548
4046	name4046	380716348587	826
4047	name4047	380177951	645
4048	name4048	380396440906	1990
4049	name4049	380803143358	215
4050	name4050	380848387039	71
4051	name4051	380432302443	705
4052	name4052	380611894133	1932
4053	name4053	380904966955	1159
4054	name4054	380622369946	1061
4055	name4055	380421451121	716
4056	name4056	380389282714	1920
4057	name4057	380218784059	287
4058	name4058	380841279403	1608
4059	name4059	380203075069	1642
4060	name4060	38036352183	446
4061	name4061	380621001753	682
4062	name4062	380732593607	850
4063	name4063	380929803228	1414
4064	name4064	380316987515	897
4065	name4065	380391715436	1668
4066	name4066	380784683463	148
4067	name4067	380932060862	611
4068	name4068	380581274249	1650
4069	name4069	380345554792	503
4070	name4070	380923296552	1833
4071	name4071	380616712736	1888
4072	name4072	380946768659	722
4073	name4073	380368440259	1605
4074	name4074	380798276991	784
4075	name4075	38046919325	86
4076	name4076	38011713948	815
4077	name4077	380174108282	1509
4078	name4078	380611180702	764
4079	name4079	380809722181	1547
4080	name4080	38058131348	1607
4081	name4081	380365263516	1125
4082	name4082	380803289175	181
4083	name4083	380561478257	1235
4084	name4084	380631384014	925
4085	name4085	380729495862	936
4086	name4086	380256521147	957
4087	name4087	380482056573	722
4088	name4088	38049090409	1498
4089	name4089	380120636245	1937
4090	name4090	380105836164	1135
4091	name4091	380994233255	1543
4092	name4092	380660410418	1697
4093	name4093	380288619000	767
4094	name4094	380192986928	1446
4095	name4095	380383136624	1468
4096	name4096	380239124403	1683
4097	name4097	380907397160	36
4098	name4098	380933104102	1852
4099	name4099	380140691855	602
4100	name4100	380521080759	1014
4101	name4101	380608871384	43
4102	name4102	380445908051	1905
4103	name4103	380861208700	146
4104	name4104	380687133888	732
4105	name4105	380624620344	1527
4106	name4106	380203782218	635
4107	name4107	380616585024	669
4108	name4108	380223389911	1918
4109	name4109	380245561581	541
4110	name4110	380854082741	203
4111	name4111	380873727508	687
4112	name4112	380566304479	728
4113	name4113	380577253804	523
4114	name4114	380920593902	1072
4115	name4115	3804007761	223
4116	name4116	380843943695	1374
4117	name4117	380355725808	1276
4118	name4118	380619789218	1423
4119	name4119	380236791547	1341
4120	name4120	380767658145	1885
4121	name4121	38021460279	1757
4122	name4122	380335468948	28
4123	name4123	380878839652	1548
4124	name4124	380799789212	228
4125	name4125	380969074226	271
4126	name4126	380377486642	367
4127	name4127	380751845449	1615
4128	name4128	380440209009	569
4129	name4129	380304548234	407
4130	name4130	380456845513	1646
4131	name4131	380975335254	1707
4132	name4132	380232998221	440
4133	name4133	380473415729	679
4134	name4134	380993760139	679
4135	name4135	380466027373	1443
4136	name4136	380618022718	1684
4137	name4137	380460607539	1684
4138	name4138	380543785619	863
4139	name4139	380252563281	50
4140	name4140	380342337813	1679
4141	name4141	380609757755	1238
4142	name4142	380589385155	464
4143	name4143	380971953698	1996
4144	name4144	380933111266	659
4145	name4145	380436440910	1122
4146	name4146	380963033348	1117
4147	name4147	380667412595	145
4148	name4148	380925120414	1921
4149	name4149	380601379218	614
4150	name4150	380708956709	288
4151	name4151	380333397302	935
4152	name4152	380667977984	397
4153	name4153	380717108721	598
4154	name4154	380172840199	1127
4155	name4155	38030172087	1479
4156	name4156	380725332961	550
4157	name4157	380151526228	822
4158	name4158	380154349388	1482
4159	name4159	380935229803	488
4160	name4160	38062760176	1708
4161	name4161	380996381391	1944
4162	name4162	380641327380	505
4163	name4163	380421230594	569
4164	name4164	380423402942	945
4165	name4165	380935981800	1731
4166	name4166	380745344296	123
4167	name4167	380299162172	217
4168	name4168	380859299754	1308
4169	name4169	380694620093	32
4170	name4170	380207350115	1716
4171	name4171	380281232054	1427
4172	name4172	380248466748	1660
4173	name4173	380889612357	1920
4174	name4174	380174079424	1191
4175	name4175	380681232213	1115
4176	name4176	380538104993	1718
4177	name4177	380565083099	695
4178	name4178	380748274380	1531
4179	name4179	380452060168	283
4180	name4180	380245763653	1399
4181	name4181	38040095354	383
4182	name4182	380179550267	1751
4183	name4183	38072651455	1384
4184	name4184	380584049346	983
4185	name4185	380349381633	1836
4186	name4186	38031771774	877
4187	name4187	380142315892	1009
4188	name4188	380189786512	1638
4189	name4189	380877383948	482
4190	name4190	380484207797	576
4191	name4191	38062538070	741
4192	name4192	380402786096	927
4193	name4193	380443785690	1312
4194	name4194	380297683543	439
4195	name4195	38018490165	810
4196	name4196	380998078092	1075
4197	name4197	380264066169	583
4198	name4198	380306771225	124
4199	name4199	380889226488	111
4200	name4200	380202240404	1311
4201	name4201	380820306789	1642
4202	name4202	380441200111	815
4203	name4203	380381823318	343
4204	name4204	380271069781	213
4205	name4205	380689627634	65
4206	name4206	380793693299	1358
4207	name4207	380906258447	185
4208	name4208	380252173141	756
4209	name4209	3809961269	677
4210	name4210	380650047758	1397
4211	name4211	380680881683	1802
4212	name4212	380260117188	606
4213	name4213	380250728406	769
4214	name4214	380396286195	1111
4215	name4215	380619824276	394
4216	name4216	380439693704	1296
4217	name4217	380800344210	746
4218	name4218	380986069401	741
4219	name4219	380431170983	361
4220	name4220	380148895020	1631
4221	name4221	38099956135	980
4222	name4222	38061336364	1032
4223	name4223	380416337275	203
4224	name4224	380949731826	1485
4225	name4225	380425620703	1362
4226	name4226	380695531777	570
4227	name4227	380965645150	877
4228	name4228	38022571373	1985
4229	name4229	380247119229	1603
4230	name4230	380100107027	793
4231	name4231	38091988109	1307
4232	name4232	380216861195	1192
4233	name4233	380434267701	241
4234	name4234	380982686589	451
4235	name4235	380323758264	1414
4236	name4236	380294689432	1463
4237	name4237	380519995313	1367
4238	name4238	380753947296	161
4239	name4239	380320540211	1784
4240	name4240	38018500527	1788
4241	name4241	380108376276	1560
4242	name4242	380587558529	347
4243	name4243	3801746401	1793
4244	name4244	380663442372	1211
4245	name4245	380195551839	285
4246	name4246	380784297251	1505
4247	name4247	380251291241	1453
4248	name4248	380709400533	1932
4249	name4249	380278050652	1775
4250	name4250	380771628396	925
4251	name4251	380233115192	676
4252	name4252	380877035052	1215
4253	name4253	380298007251	1393
4254	name4254	380880698566	914
4255	name4255	380516039699	140
4256	name4256	380133458041	1194
4257	name4257	380625416956	483
4258	name4258	380234024819	714
4259	name4259	380945848016	909
4260	name4260	380702083925	1863
4261	name4261	380826702668	1978
4262	name4262	380302490637	347
4263	name4263	38042059894	666
4264	name4264	380691281349	905
4265	name4265	380104981190	1901
4266	name4266	38056033438	1136
4267	name4267	380551638758	168
4268	name4268	380509514401	1783
4269	name4269	380224605629	67
4270	name4270	380948192445	1289
4271	name4271	380217502471	718
4272	name4272	380390563689	1316
4273	name4273	380920552491	1667
4274	name4274	3803177684	397
4275	name4275	380262492158	948
4276	name4276	380819172679	614
4277	name4277	380227368989	72
4278	name4278	380981140714	163
4279	name4279	380136301824	815
4280	name4280	380461204506	1343
4281	name4281	380593674297	576
4282	name4282	380401820622	834
4283	name4283	380701323845	1666
4284	name4284	380977376935	1838
4285	name4285	380843219627	967
4286	name4286	380230775229	1435
4287	name4287	380861585740	1871
4288	name4288	380278251047	219
4289	name4289	38034482619	791
4290	name4290	380351182637	1849
4291	name4291	380175731163	960
4292	name4292	380880890504	1663
4293	name4293	380605553183	857
4294	name4294	380836032501	246
4295	name4295	380889746701	234
4296	name4296	380903115601	618
4297	name4297	380183137161	347
4298	name4298	380231865050	60
4299	name4299	380117895043	350
4300	name4300	380306307548	1947
4301	name4301	380412962614	1378
4302	name4302	380629277	758
4303	name4303	380271748334	603
4304	name4304	380527156518	1054
4305	name4305	380728447616	998
4306	name4306	380328415056	1451
4307	name4307	380858612138	478
4308	name4308	380955599496	262
4309	name4309	380225529910	836
4310	name4310	380289587685	370
4311	name4311	380153904556	1345
4312	name4312	380481593942	384
4313	name4313	380630043993	1942
4314	name4314	380896162706	1105
4315	name4315	38099745592	999
4316	name4316	380786578369	1598
4317	name4317	380621561876	671
4318	name4318	380612174151	1176
4319	name4319	380837283022	1831
4320	name4320	380263864040	1302
4321	name4321	380671416444	157
4322	name4322	380171505964	1488
4323	name4323	380176921810	637
4324	name4324	380561290890	1176
4325	name4325	380735552455	1613
4326	name4326	380908494514	1092
4327	name4327	380823048553	124
4328	name4328	380222898277	1563
4329	name4329	38053376564	1825
4330	name4330	380650015153	310
4331	name4331	380463089698	1981
4332	name4332	380815865121	1951
4333	name4333	380396005626	222
4334	name4334	380585308073	1535
4335	name4335	380710476282	97
4336	name4336	380144447142	1673
4337	name4337	380100968749	1863
4338	name4338	380438173467	1066
4339	name4339	38053597882	1751
4340	name4340	380632089163	247
4341	name4341	380360854468	1412
4342	name4342	380931193644	805
4343	name4343	380245028314	565
4344	name4344	380982450503	453
4345	name4345	380501586726	845
4346	name4346	380622265501	960
4347	name4347	380194734489	1466
4348	name4348	380674009271	1567
4349	name4349	380408563550	1881
4350	name4350	38082020971	165
4351	name4351	380275801759	395
4352	name4352	380393589618	1444
4353	name4353	380118026955	1079
4354	name4354	380391871067	66
4355	name4355	380770213139	1544
4356	name4356	380942092554	53
4357	name4357	380684603372	880
4358	name4358	380604751194	1273
4359	name4359	380874820070	1593
4360	name4360	380549538614	120
4361	name4361	380327437143	1391
4362	name4362	380105616899	1579
4363	name4363	380543877840	1637
4364	name4364	380593007235	1377
4365	name4365	380125837135	1888
4366	name4366	380420910357	1992
4367	name4367	380395053663	1016
4368	name4368	380925066066	145
4369	name4369	38025594701	1787
4370	name4370	380593284135	1280
4371	name4371	380771938563	257
4372	name4372	380974831264	639
4373	name4373	380989461685	431
4374	name4374	380600650258	385
4375	name4375	380799719875	1043
4376	name4376	380390020140	1120
4377	name4377	380905676501	1881
4378	name4378	380751064793	769
4379	name4379	380244338329	974
4380	name4380	380735507885	199
4381	name4381	380498496043	33
4382	name4382	380524131283	459
4383	name4383	380182326364	1460
4384	name4384	380969363537	266
4385	name4385	380371657888	146
4386	name4386	380905705772	1167
4387	name4387	380792391692	446
4388	name4388	380476624578	748
4389	name4389	380382412493	488
4390	name4390	38029032122	1318
4391	name4391	38015086137	1097
4392	name4392	38077807327	417
4393	name4393	380478705441	500
4394	name4394	380498474204	1827
4395	name4395	380808623578	871
4396	name4396	380945099601	867
4397	name4397	380639356754	1956
4398	name4398	380441311638	1542
4399	name4399	380312746423	1213
4400	name4400	380884225552	155
4401	name4401	380606404556	1116
4402	name4402	380371323318	1071
4403	name4403	380364776499	1434
4404	name4404	380182118168	1305
4405	name4405	380175505340	1628
4406	name4406	380820918439	652
4407	name4407	380579537714	1588
4408	name4408	380715915294	1229
4409	name4409	380165389463	882
4410	name4410	380325333274	1227
4411	name4411	38085243217	681
4412	name4412	380381668131	248
4413	name4413	38087459758	1096
4414	name4414	380344964012	497
4415	name4415	380118863314	703
4416	name4416	38073899724	469
4417	name4417	380513919879	1635
4418	name4418	380665446747	156
4419	name4419	38035721008	640
4420	name4420	380450282816	1244
4421	name4421	380245178774	715
4422	name4422	380497945615	1522
4423	name4423	38028513830	1970
4424	name4424	380897854441	1535
4425	name4425	380418175051	381
4426	name4426	380145714336	1855
4427	name4427	380520672724	1704
4428	name4428	380405106500	761
4429	name4429	380505801523	853
4430	name4430	380641925409	668
4431	name4431	380978605094	202
4432	name4432	380192870254	385
4433	name4433	380828512488	1127
4434	name4434	38085710219	1062
4435	name4435	380848218924	1117
4436	name4436	380799155820	828
4437	name4437	380342815809	117
4438	name4438	380599142646	22
4439	name4439	380675102053	422
4440	name4440	38010148338	1807
4441	name4441	380463665277	1978
4442	name4442	380441473748	172
4443	name4443	380817374404	782
4444	name4444	380320658214	1619
4445	name4445	380910377507	786
4446	name4446	38095356028	1335
4447	name4447	380748705256	909
4448	name4448	38059856533	1565
4449	name4449	380695828407	912
4450	name4450	380283278017	127
4451	name4451	380910081517	361
4452	name4452	380577606315	1150
4453	name4453	380579188538	813
4454	name4454	380284283665	1079
4455	name4455	380677040592	1004
4456	name4456	380926758355	1207
4457	name4457	380511811118	808
4458	name4458	380457721750	1825
4459	name4459	380929281740	1517
4460	name4460	380849175020	1851
4461	name4461	380778192443	1778
4462	name4462	380101828386	1749
4463	name4463	380247507030	151
4464	name4464	380957859107	910
4465	name4465	380888908825	1236
4466	name4466	380193086134	1141
4467	name4467	380114306004	184
4468	name4468	380262405782	1914
4469	name4469	380555448165	977
4470	name4470	380883346447	1632
4471	name4471	380998801159	1298
4472	name4472	380396196279	1634
4473	name4473	380768874755	572
4474	name4474	38044593592	1724
4475	name4475	380586153369	1399
4476	name4476	380435570470	1094
4477	name4477	380631894174	1131
4478	name4478	380518038017	1717
4479	name4479	38041051373	472
4480	name4480	380246034260	758
4481	name4481	380939347977	649
4482	name4482	380870150748	1554
4483	name4483	380327766687	122
4484	name4484	380118884975	1280
4485	name4485	380863316692	838
4486	name4486	380411608117	36
4487	name4487	380647658651	62
4488	name4488	380672106170	1916
4489	name4489	380539321089	95
4490	name4490	380477353178	1451
4491	name4491	380788202949	761
4492	name4492	380758750527	1646
4493	name4493	380948687259	251
4494	name4494	380681667005	1429
4495	name4495	38036354896	1529
4496	name4496	380459178457	245
4497	name4497	380593707363	829
4498	name4498	380188974852	1555
4499	name4499	380614635102	1800
4500	name4500	380213458525	1352
4501	name4501	380927136520	446
4502	name4502	380319909321	352
4503	name4503	380812653893	1000
4504	name4504	380188096703	505
4505	name4505	380951793732	1162
4506	name4506	380836860478	1684
4507	name4507	380962411143	234
4508	name4508	38056302478	267
4509	name4509	380491182622	87
4510	name4510	380520931601	315
4511	name4511	380635783993	1165
4512	name4512	380320603898	828
4513	name4513	380255342567	1797
4514	name4514	380613084268	269
4515	name4515	380310935409	1807
4516	name4516	38016298471	1061
4517	name4517	380410434203	1838
4518	name4518	380999618100	1492
4519	name4519	380785355700	1364
4520	name4520	380327605255	1321
4521	name4521	38094331720	225
4522	name4522	380782433968	960
4523	name4523	380721925989	289
4524	name4524	380127223396	926
4525	name4525	380407839490	1631
4526	name4526	380897345166	1481
4527	name4527	380456431399	766
4528	name4528	380344186446	1329
4529	name4529	380321798930	962
4530	name4530	380491724309	1659
4531	name4531	38016641300	1234
4532	name4532	38082437968	1663
4533	name4533	380659654624	123
4534	name4534	380811824720	1414
4535	name4535	380791328509	1334
4536	name4536	380589574971	1282
4537	name4537	380593983196	971
4538	name4538	380799139327	721
4539	name4539	380419957895	1991
4540	name4540	380125969405	96
4541	name4541	380700655852	357
4542	name4542	380576227706	788
4543	name4543	380868401450	1000
4544	name4544	380951367151	807
4545	name4545	380577932312	9
4546	name4546	380590748341	1864
4547	name4547	380821720647	1597
4548	name4548	380549586417	1322
4549	name4549	380907721816	391
4550	name4550	380660298711	1139
4551	name4551	380111211819	892
4552	name4552	380700726076	309
4553	name4553	380925972323	483
4554	name4554	380251535668	872
4555	name4555	380939575516	127
4556	name4556	380511106991	11
4557	name4557	380907763718	199
4558	name4558	380469493226	896
4559	name4559	380855910278	960
4560	name4560	380278888652	1799
4561	name4561	38054911205	1616
4562	name4562	380814729482	1953
4563	name4563	380332534165	1724
4564	name4564	380440937272	468
4565	name4565	380210082709	296
4566	name4566	380377739368	860
4567	name4567	380120317704	1995
4568	name4568	380475202670	522
4569	name4569	380987575659	622
4570	name4570	380825910525	1784
4571	name4571	380410808757	1202
4572	name4572	380761847618	949
4573	name4573	38098585407	351
4574	name4574	38045246180	1645
4575	name4575	380955107198	1982
4576	name4576	380103047687	586
4577	name4577	38015256446	1746
4578	name4578	380327326699	205
4579	name4579	380314994324	1335
4580	name4580	38011249778	1592
4581	name4581	380335890024	603
4582	name4582	380444850946	1205
4583	name4583	380125652644	776
4584	name4584	380472376265	1809
4585	name4585	380721864269	1924
4586	name4586	380193034869	1813
4587	name4587	380796465160	1351
4588	name4588	380725746892	1596
4589	name4589	380529207118	1942
4590	name4590	38048718243	1433
4591	name4591	380272523541	163
4592	name4592	380556244967	169
4593	name4593	380974074775	131
4594	name4594	380526936547	1045
4595	name4595	38020890765	1546
4596	name4596	380624485877	971
4597	name4597	38086980585	569
4598	name4598	380811773825	324
4599	name4599	380129269915	756
4600	name4600	380753587307	817
4601	name4601	380826467790	78
4602	name4602	380973469388	387
4603	name4603	380538065910	1304
4604	name4604	380710849530	718
4605	name4605	380555626038	1308
4606	name4606	380929076667	1511
4607	name4607	380838055170	655
4608	name4608	380561613658	343
4609	name4609	380916642490	1968
4610	name4610	380584661809	1760
4611	name4611	380513788471	1732
4612	name4612	380901283543	1852
4613	name4613	380767305290	1922
4614	name4614	380841402879	468
4615	name4615	380896858800	565
4616	name4616	380288605941	564
4617	name4617	380832516742	776
4618	name4618	380337453289	1696
4619	name4619	380703307732	1287
4620	name4620	380685561374	1100
4621	name4621	380652527239	164
4622	name4622	380616635472	1586
4623	name4623	380796384948	414
4624	name4624	380161507736	93
4625	name4625	380122495453	724
4626	name4626	380501628272	821
4627	name4627	380560904939	1444
4628	name4628	380124547796	804
4629	name4629	380775466987	215
4630	name4630	380644124292	1922
4631	name4631	380960476867	5
4632	name4632	380812593257	1532
4633	name4633	38088919288	356
4634	name4634	380821406870	1696
4635	name4635	380326456908	1510
4636	name4636	380199529709	1304
4637	name4637	380635246604	1701
4638	name4638	380545000719	1713
4639	name4639	380190751388	1690
4640	name4640	380165631449	1709
4641	name4641	380256181692	1138
4642	name4642	380892680905	849
4643	name4643	380907372613	1480
4644	name4644	380141440636	1357
4645	name4645	380543022517	1552
4646	name4646	380323502097	1935
4647	name4647	380434331565	869
4648	name4648	380184344284	1800
4649	name4649	380437128738	1525
4650	name4650	380193079111	132
4651	name4651	380883081677	428
4652	name4652	380888813133	1402
4653	name4653	380432576042	1638
4654	name4654	38062681108	508
4655	name4655	380342969750	803
4656	name4656	380794591141	661
4657	name4657	380634832847	1741
4658	name4658	380953490674	1310
4659	name4659	380999292812	775
4660	name4660	380250051156	1233
4661	name4661	380291205166	1896
4662	name4662	380902445662	1592
4663	name4663	380772517377	368
4664	name4664	380546593962	1108
4665	name4665	380611558011	1610
4666	name4666	380447371532	1908
4667	name4667	38090529262	1247
4668	name4668	380678622227	1492
4669	name4669	3808067236	1730
4670	name4670	380628695170	1693
4671	name4671	38083611828	1924
4672	name4672	380244650696	640
4673	name4673	380832710719	1044
4674	name4674	380318103260	430
4675	name4675	380471987418	206
4676	name4676	380809027083	1108
4677	name4677	380328723770	1653
4678	name4678	380949389383	77
4679	name4679	380847614803	720
4680	name4680	380839167359	1776
4681	name4681	380650797322	1178
4682	name4682	380264869575	1643
4683	name4683	380475553779	1888
4684	name4684	38046912271	1617
4685	name4685	380277490179	650
4686	name4686	380436706280	1285
4687	name4687	380336250676	1285
4688	name4688	380349471835	860
4689	name4689	38032885165	1166
4690	name4690	380763960914	1
4691	name4691	380969854565	1382
4692	name4692	380558448988	1593
4693	name4693	380863294742	1914
4694	name4694	380174015836	180
4695	name4695	380979057396	324
4696	name4696	380465755375	1532
4697	name4697	380854791351	134
4698	name4698	380515112751	225
4699	name4699	380400501269	147
4700	name4700	380962109268	382
4701	name4701	380120102742	139
4702	name4702	380362216756	247
4703	name4703	380809676530	1464
4704	name4704	380764620540	455
4705	name4705	380786199590	1925
4706	name4706	380971428712	73
4707	name4707	380114234584	1722
4708	name4708	380890228429	1924
4709	name4709	380549563245	371
4710	name4710	380512053640	543
4711	name4711	380790173129	1155
4712	name4712	380165097183	917
4713	name4713	38073132122	651
4714	name4714	380636634810	720
4715	name4715	380489458117	1716
4716	name4716	380358250516	85
4717	name4717	380831387530	428
4718	name4718	380377352294	625
4719	name4719	380801990166	1101
4720	name4720	380350620827	1912
4721	name4721	38087680287	398
4722	name4722	380794856451	149
4723	name4723	380685692450	549
4724	name4724	380556311267	1773
4725	name4725	380246069792	1547
4726	name4726	380468681270	138
4727	name4727	38022806313	1861
4728	name4728	380387350660	542
4729	name4729	380359623864	374
4730	name4730	380975805180	1015
4731	name4731	380645769092	598
4732	name4732	380260820978	369
4733	name4733	380614912268	908
4734	name4734	380827767979	174
4735	name4735	380370479956	933
4736	name4736	380680337143	1498
4737	name4737	380930545874	1291
4738	name4738	380752207440	1716
4739	name4739	380337122985	661
4740	name4740	380552967405	415
4741	name4741	380703918491	844
4742	name4742	380740068082	1393
4743	name4743	380688426342	925
4744	name4744	380726432054	1286
4745	name4745	380278276089	57
4746	name4746	380416502926	1577
4747	name4747	380102331270	1519
4748	name4748	380926566707	540
4749	name4749	380960969981	1256
4750	name4750	380216207131	237
4751	name4751	380371188859	1790
4752	name4752	380846466618	1970
4753	name4753	380747973078	1890
4754	name4754	380690285440	1158
4755	name4755	380404085062	802
4756	name4756	380169448206	1415
4757	name4757	380159803204	1370
4758	name4758	380382583790	766
4759	name4759	380184629500	1090
4760	name4760	380209106140	475
4761	name4761	380395881145	1400
4762	name4762	380882654471	80
4763	name4763	380196070088	1635
4764	name4764	380610566570	645
4765	name4765	3809655202	975
4766	name4766	380387244232	1534
4767	name4767	380122077607	589
4768	name4768	380994922439	20
4769	name4769	380402775121	785
4770	name4770	380832590991	1102
4771	name4771	380628771064	981
4772	name4772	380439292840	174
4773	name4773	38056047878	1910
4774	name4774	38049207659	532
4775	name4775	380255940089	1088
4776	name4776	380491608118	1821
4777	name4777	380746332494	800
4778	name4778	380545666350	1254
4779	name4779	380808003772	761
4780	name4780	380823843522	656
4781	name4781	380246032464	844
4782	name4782	380257743186	1272
4783	name4783	380693690332	1497
4784	name4784	380259889582	282
4785	name4785	380635148949	1785
4786	name4786	380666838386	826
4787	name4787	380864017851	59
4788	name4788	380482564795	1954
4789	name4789	380360317265	1056
4790	name4790	38062668643	508
4791	name4791	380927817115	451
4792	name4792	380264578491	1375
4793	name4793	380301839955	306
4794	name4794	380818784225	1515
4795	name4795	380660302394	529
4796	name4796	380194796679	1914
4797	name4797	380125053336	98
4798	name4798	380487562162	1959
4799	name4799	38081228881	656
4800	name4800	38026334153	1142
4801	name4801	380128647559	1835
4802	name4802	380379164549	1316
4803	name4803	38073765473	475
4804	name4804	380477299831	99
4805	name4805	380207654323	1408
4806	name4806	380344847742	1565
4807	name4807	380792772798	508
4808	name4808	380417092192	360
4809	name4809	380736198180	1101
4810	name4810	380470409417	1249
4811	name4811	380911747816	190
4812	name4812	380297735451	1690
4813	name4813	380473878235	1670
4814	name4814	380735036267	812
4815	name4815	380761942081	1610
4816	name4816	380695747606	1982
4817	name4817	380604533676	701
4818	name4818	380792061039	1563
4819	name4819	380196369894	730
4820	name4820	380248446591	1662
4821	name4821	380837500511	618
4822	name4822	380471973806	1665
4823	name4823	380277509146	1047
4824	name4824	380760563190	737
4825	name4825	38015264596	1821
4826	name4826	380438404215	749
4827	name4827	380743000750	727
4828	name4828	38061796962	1789
4829	name4829	380769259274	1972
4830	name4830	380391769297	1640
4831	name4831	380391736184	1078
4832	name4832	380380907056	829
4833	name4833	380604671028	883
4834	name4834	38013060468	944
4835	name4835	380687175965	1446
4836	name4836	380712581157	1395
4837	name4837	38048355255	40
4838	name4838	380375144053	658
4839	name4839	380769978845	1115
4840	name4840	380363305839	820
4841	name4841	380599803068	1708
4842	name4842	380177417202	464
4843	name4843	380873081210	1343
4844	name4844	380623528031	1838
4845	name4845	380637640407	1545
4846	name4846	380941265834	405
4847	name4847	380644912762	311
4848	name4848	380205432971	1099
4849	name4849	380873109462	1744
4850	name4850	380251208548	889
4851	name4851	380806756908	1637
4852	name4852	380666676762	1501
4853	name4853	380642730820	1603
4854	name4854	380455700542	340
4855	name4855	380735276714	247
4856	name4856	380796534215	1719
4857	name4857	380295849543	1886
4858	name4858	380621259845	1626
4859	name4859	380198468584	1074
4860	name4860	380736412953	1263
4861	name4861	380175631088	1549
4862	name4862	380335934907	1733
4863	name4863	380450940291	1205
4864	name4864	380133925472	544
4865	name4865	380496520170	994
4866	name4866	380508353044	1167
4867	name4867	380971226542	884
4868	name4868	380659209946	409
4869	name4869	380585058841	685
4870	name4870	380134993849	1810
4871	name4871	380199267982	717
4872	name4872	380842580689	873
4873	name4873	38037755905	827
4874	name4874	38092365614	799
4875	name4875	380996227585	33
4876	name4876	380100628322	399
4877	name4877	380938509738	1927
4878	name4878	38036996499	1111
4879	name4879	380132165675	203
4880	name4880	380508460490	543
4881	name4881	380213637250	172
4882	name4882	380102280862	1075
4883	name4883	380731030525	452
4884	name4884	380931884375	989
4885	name4885	380845204763	1190
4886	name4886	380108065207	1749
4887	name4887	380228859621	785
4888	name4888	380466114991	1353
4889	name4889	380139068316	101
4890	name4890	380740362863	418
4891	name4891	380382566339	1861
4892	name4892	380226306168	557
4893	name4893	380694413227	116
4894	name4894	380611822129	732
4895	name4895	380196371962	1620
4896	name4896	380717227046	1739
4897	name4897	380553861873	1297
4898	name4898	380228734540	1462
4899	name4899	380194622842	1688
4900	name4900	380670253591	1774
4901	name4901	380150246450	816
4902	name4902	380820778349	360
4903	name4903	380287821009	610
4904	name4904	38099145009	1701
4905	name4905	380796396268	559
4906	name4906	380341792731	133
4907	name4907	380968232843	1157
4908	name4908	380693586634	252
4909	name4909	380291868659	417
4910	name4910	38033240766	79
4911	name4911	380788088502	439
4912	name4912	380671086888	648
4913	name4913	380715185292	1453
4914	name4914	38019339378	1670
4915	name4915	380963433801	979
4916	name4916	38051523939	975
4917	name4917	380117173192	1531
4918	name4918	380939932307	1216
4919	name4919	380597060146	837
4920	name4920	380540580584	15
4921	name4921	380881428612	1728
4922	name4922	380543003321	1057
4923	name4923	380902156056	1190
4924	name4924	380922741459	1518
4925	name4925	380238323676	467
4926	name4926	38075341332	1287
4927	name4927	38052559796	1120
4928	name4928	38013837744	1675
4929	name4929	380341586955	132
4930	name4930	380802472462	155
4931	name4931	380894535782	1260
4932	name4932	380827818915	128
4933	name4933	380489161382	292
4934	name4934	380835886421	873
4935	name4935	380878261698	1774
4936	name4936	38021141529	585
4937	name4937	380306252813	1849
4938	name4938	380878251386	1670
4939	name4939	380744737868	1363
4940	name4940	380817649508	247
4941	name4941	380837331560	833
4942	name4942	380450303026	276
4943	name4943	380916279289	1978
4944	name4944	380241961440	961
4945	name4945	380610063959	1188
4946	name4946	380524104841	1993
4947	name4947	380257412989	1555
4948	name4948	380433186195	1902
4949	name4949	380448083093	589
4950	name4950	380347228804	178
4951	name4951	380109793097	487
4952	name4952	380234391154	540
4953	name4953	380497133674	1949
4954	name4954	380145042795	160
4955	name4955	380862202201	1440
4956	name4956	380895905612	1796
4957	name4957	380982047364	5
4958	name4958	380580784740	1700
4959	name4959	38037994349	345
4960	name4960	380159638123	606
4961	name4961	380287448107	1434
4962	name4962	380535648085	467
4963	name4963	380101241456	1978
4964	name4964	380852628587	246
4965	name4965	380225903830	129
4966	name4966	380347019510	845
4967	name4967	380173784967	946
4968	name4968	380384676512	1520
4969	name4969	380761907781	1766
4970	name4970	380968743010	1542
4971	name4971	380283407481	157
4972	name4972	380768843943	729
4973	name4973	380952691325	1954
4974	name4974	380152404802	463
4975	name4975	380934088690	341
4976	name4976	380344807857	530
4977	name4977	380667166808	1281
4978	name4978	380205836499	1903
4979	name4979	380899085556	484
4980	name4980	380741440158	163
4981	name4981	380487625676	226
4982	name4982	380880139671	1470
4983	name4983	380523292109	915
4984	name4984	380552756647	1921
4985	name4985	380586149927	1074
4986	name4986	380638488841	18
4987	name4987	380210528748	1416
4988	name4988	38084757208	979
4989	name4989	380815635821	460
4990	name4990	380840842299	605
4991	name4991	380532248490	1279
4992	name4992	380552060830	1476
4993	name4993	380546104080	721
4994	name4994	38063676227	1141
4995	name4995	380785417269	1030
4996	name4996	380533128790	368
4997	name4997	380208432110	1984
4998	name4998	380891277822	542
4999	name4999	380248441304	969
5000	name5000	380929900074	1224
5001	name5001	380143267749	1284
5002	name5002	380546432714	1024
5003	name5003	380625015641	1379
5004	name5004	380298592876	284
5005	name5005	380271772108	1844
5006	name5006	380858091240	1270
5007	name5007	380657318445	1868
5008	name5008	380228137418	1902
5009	name5009	380651717894	1063
5010	name5010	380429492498	1999
5011	name5011	380953364448	1767
5012	name5012	380524206407	94
5013	name5013	38017690725	540
5014	name5014	380813084703	1909
5015	name5015	380170472190	76
5016	name5016	380721232747	1860
5017	name5017	380553680849	1745
5018	name5018	380812350712	565
5019	name5019	380680232507	1298
5020	name5020	380881407721	1947
5021	name5021	38051813089	121
5022	name5022	380212398794	1504
5023	name5023	380203254017	119
5024	name5024	380565819371	758
5025	name5025	380179570126	559
5026	name5026	380741106274	1145
5027	name5027	38028094339	1618
5028	name5028	380174128134	1264
5029	name5029	380232470121	586
5030	name5030	380534027753	1422
5031	name5031	380842577441	1302
5032	name5032	380769117764	1714
5033	name5033	380678240629	1362
5034	name5034	380925645632	1790
5035	name5035	380822186902	369
5036	name5036	380832861907	366
5037	name5037	380206188374	932
5038	name5038	380826418861	337
5039	name5039	380995076122	1417
5040	name5040	380771993355	937
5041	name5041	380351425340	242
5042	name5042	38032171535	140
5043	name5043	380482738611	151
5044	name5044	380108661627	787
5045	name5045	38053227191	1426
5046	name5046	380515476570	1248
5047	name5047	380586448526	397
5048	name5048	380197348068	882
5049	name5049	380481047101	1737
5050	name5050	380486776319	1036
5051	name5051	380829752705	145
5052	name5052	380610033875	1914
5053	name5053	380887187876	430
5054	name5054	380908112225	1993
5055	name5055	380594734514	1149
5056	name5056	380475668115	1021
5057	name5057	380154074687	1438
5058	name5058	380269704461	1632
5059	name5059	380413266131	321
5060	name5060	380564967827	1981
5061	name5061	380644321078	1001
5062	name5062	38077550572	972
5063	name5063	380943433277	297
5064	name5064	380626933377	1035
5065	name5065	380246818922	731
5066	name5066	380380144507	1788
5067	name5067	380215794122	1226
5068	name5068	380835837282	1063
5069	name5069	380471010180	1310
5070	name5070	380218924544	377
5071	name5071	380554786102	911
5072	name5072	380451726491	1212
5073	name5073	380669041142	831
5074	name5074	380507835759	692
5075	name5075	380238709755	1280
5076	name5076	380266674398	360
5077	name5077	38072010038	737
5078	name5078	380123260123	731
5079	name5079	380169211524	750
5080	name5080	380764262606	1938
5081	name5081	380187972900	903
5082	name5082	380960470444	74
5083	name5083	380680596815	44
5084	name5084	380400321244	877
5085	name5085	380117371968	474
5086	name5086	380133773417	1757
5087	name5087	380873794467	1458
5088	name5088	38086193557	238
5089	name5089	380653322336	548
5090	name5090	38064817388	1895
5091	name5091	380143153356	1922
5092	name5092	380967223084	414
5093	name5093	380322587469	1481
5094	name5094	380820472355	1025
5095	name5095	380650895052	484
5096	name5096	380412423031	162
5097	name5097	380226569222	477
5098	name5098	38084688527	1266
5099	name5099	380559012411	504
5100	name5100	380818135120	1679
5101	name5101	380114334706	1974
5102	name5102	380637375780	77
5103	name5103	380657356814	353
5104	name5104	380258802119	538
5105	name5105	380281327244	1332
5106	name5106	380180314919	56
5107	name5107	380325885375	1669
5108	name5108	380149772240	922
5109	name5109	380873313341	1432
5110	name5110	38011232957	677
5111	name5111	380375458114	831
5112	name5112	380206457434	706
5113	name5113	380986278653	1794
5114	name5114	38071394205	1991
5115	name5115	380452722638	1611
5116	name5116	380955439109	1837
5117	name5117	380606004886	945
5118	name5118	380651446896	1701
5119	name5119	380238664620	1190
5120	name5120	380568636825	1118
5121	name5121	380208162963	934
5122	name5122	380860016802	369
5123	name5123	380376125110	346
5124	name5124	380621935797	859
5125	name5125	380538797290	633
5126	name5126	380367975163	984
5127	name5127	380828404772	1329
5128	name5128	380623340491	1654
5129	name5129	380279527964	848
5130	name5130	380919873414	777
5131	name5131	380489029342	301
5132	name5132	380489541889	1517
5133	name5133	380550764039	1566
5134	name5134	380337302161	1441
5135	name5135	380262504221	855
5136	name5136	38078638142	1418
5137	name5137	380364427845	661
5138	name5138	380864591766	1465
5139	name5139	380338728018	176
5140	name5140	380993639898	1220
5141	name5141	380565489627	455
5142	name5142	380566147207	1041
5143	name5143	380951579295	996
5144	name5144	38067455649	56
5145	name5145	380624979826	796
5146	name5146	380370745766	1055
5147	name5147	380897576632	1441
5148	name5148	380714546561	1708
5149	name5149	3807684793	1684
5150	name5150	380268393007	82
5151	name5151	380486603591	1081
5152	name5152	3804747442	573
5153	name5153	380142667218	1680
5154	name5154	38050025622	1295
5155	name5155	380287276267	1786
5156	name5156	380276378454	570
5157	name5157	380196936503	1204
5158	name5158	380992789474	620
5159	name5159	38039025881	291
5160	name5160	38082353737	828
5161	name5161	380580503429	1749
5162	name5162	380640252765	1982
5163	name5163	380846411403	499
5164	name5164	380556286139	44
5165	name5165	38098789208	1395
5166	name5166	380617308125	727
5167	name5167	380304231560	555
5168	name5168	38025474457	1359
5169	name5169	380885647966	108
5170	name5170	380516368705	1694
5171	name5171	380470960796	218
5172	name5172	38092148889	1505
5173	name5173	380182455478	1961
5174	name5174	380760592615	1756
5175	name5175	380699803937	365
5176	name5176	380989574570	26
5177	name5177	380926792075	365
5178	name5178	380910222299	609
5179	name5179	380728788491	1493
5180	name5180	380909829850	219
5181	name5181	380244805654	710
5182	name5182	380751771279	459
5183	name5183	380241955730	325
5184	name5184	380137668337	916
5185	name5185	380836608197	1218
5186	name5186	380271925212	1176
5187	name5187	380351661123	1707
5188	name5188	380230349299	358
5189	name5189	380951887764	1224
5190	name5190	38046967867	1760
5191	name5191	380266665187	1472
5192	name5192	380505312789	1770
5193	name5193	380986783994	548
5194	name5194	380905740636	519
5195	name5195	380342126702	1242
5196	name5196	380662841475	1590
5197	name5197	380522080466	1453
5198	name5198	380884166949	1925
5199	name5199	380936465324	1360
5200	name5200	380234273586	1751
5201	name5201	380961638265	1809
5202	name5202	380369915690	1382
5203	name5203	38097629160	538
5204	name5204	380540918291	279
5205	name5205	380429083368	110
5206	name5206	38027660830	512
5207	name5207	380279498830	1180
5208	name5208	380135709186	1628
5209	name5209	380616042625	194
5210	name5210	380142563203	1305
5211	name5211	380650521977	334
5212	name5212	38018070996	63
5213	name5213	380238300642	682
5214	name5214	380669125052	1735
5215	name5215	380344365234	1743
5216	name5216	380829852098	1567
5217	name5217	380304349385	674
5218	name5218	380724643908	1333
5219	name5219	380350183287	1939
5220	name5220	380401998750	246
5221	name5221	380706775394	99
5222	name5222	380924439952	692
5223	name5223	380922451033	1247
5224	name5224	380401548778	1556
5225	name5225	380649252635	255
5226	name5226	380676295380	1503
5227	name5227	38072223925	1023
5228	name5228	380978260792	68
5229	name5229	38074683822	472
5230	name5230	380893695998	864
5231	name5231	380188847502	1525
5232	name5232	380609652565	69
5233	name5233	380782986100	1012
5234	name5234	38064199382	697
5235	name5235	380329818916	1544
5236	name5236	380250406780	1335
5237	name5237	38055499766	730
5238	name5238	380936390968	1431
5239	name5239	380543624978	831
5240	name5240	380193146852	944
5241	name5241	380837987893	1023
5242	name5242	380435374561	673
5243	name5243	380483481999	832
5244	name5244	380106747637	1684
5245	name5245	380392291800	1945
5246	name5246	380654647336	1650
5247	name5247	380897146503	1280
5248	name5248	380728008492	1382
5249	name5249	380590138843	802
5250	name5250	380726726792	67
5251	name5251	380598141825	21
5252	name5252	380913187069	726
5253	name5253	380989216596	404
5254	name5254	38074348552	1781
5255	name5255	380636267725	1183
5256	name5256	380806204269	1930
5257	name5257	380564907679	631
5258	name5258	380469884738	1509
5259	name5259	380380167537	825
5260	name5260	380927041747	758
5261	name5261	380550123827	1197
5262	name5262	380667413213	214
5263	name5263	380532684060	541
5264	name5264	38031846078	717
5265	name5265	380605212846	1095
5266	name5266	380257293542	1667
5267	name5267	38042030487	1729
5268	name5268	380728535930	656
5269	name5269	380360289477	1072
5270	name5270	380167996418	1653
5271	name5271	380910350153	1424
5272	name5272	380459413237	1437
5273	name5273	380869537364	1049
5274	name5274	380698234854	1898
5275	name5275	380888577943	872
5276	name5276	380574664133	1785
5277	name5277	380332645945	679
5278	name5278	380601227938	658
5279	name5279	380475810757	1531
5280	name5280	380635083214	383
5281	name5281	380479809649	1111
5282	name5282	38012386719	1150
5283	name5283	380896433652	487
5284	name5284	380694373272	1866
5285	name5285	380706478926	153
5286	name5286	380565167135	1504
5287	name5287	380333446201	197
5288	name5288	380344594834	1196
5289	name5289	380570789806	711
5290	name5290	380983732173	441
5291	name5291	380566829240	1672
5292	name5292	380564523493	1915
5293	name5293	380834412605	1802
5294	name5294	380584974859	437
5295	name5295	380857049685	211
5296	name5296	380519700839	114
5297	name5297	380306177456	1749
5298	name5298	380229070688	1213
5299	name5299	380872209439	399
5300	name5300	380132844743	1510
5301	name5301	380322606241	1424
5302	name5302	380292872896	1356
5303	name5303	380269817692	1700
5304	name5304	380510149519	347
5305	name5305	380521383725	1804
5306	name5306	380623081925	1353
5307	name5307	380188243253	1263
5308	name5308	380787113922	979
5309	name5309	380399436827	112
5310	name5310	380278281831	1341
5311	name5311	380996748893	106
5312	name5312	38089267907	1305
5313	name5313	38028886586	1654
5314	name5314	380265836591	1920
5315	name5315	380705412175	542
5316	name5316	380609035299	402
5317	name5317	380779544018	330
5318	name5318	380699598495	753
5319	name5319	38096610958	500
5320	name5320	380128601872	1055
5321	name5321	380279315300	46
5322	name5322	380578844462	1238
5323	name5323	380948135677	1609
5324	name5324	38096814654	839
5325	name5325	380462965136	976
5326	name5326	380152394516	1484
5327	name5327	380355048764	1272
5328	name5328	380850701229	452
5329	name5329	3809886277	1337
5330	name5330	380972174988	704
5331	name5331	380694433242	1565
5332	name5332	38092175449	12
5333	name5333	380863189577	379
5334	name5334	380848387757	624
5335	name5335	380926071545	1031
5336	name5336	380949020836	1243
5337	name5337	380731539234	982
5338	name5338	38037881192	1688
5339	name5339	380785411261	218
5340	name5340	380105573121	74
5341	name5341	380393313540	294
5342	name5342	380875358766	361
5343	name5343	380746070599	48
5344	name5344	380650041414	918
5345	name5345	380407099082	181
5346	name5346	380393902885	1335
5347	name5347	38041402182	1540
5348	name5348	380597621428	284
5349	name5349	380156077549	1218
5350	name5350	380180254683	1174
5351	name5351	380312683225	23
5352	name5352	380985096683	520
5353	name5353	380455015551	798
5354	name5354	380127820530	1835
5355	name5355	380760372387	141
5356	name5356	38045252554	371
5357	name5357	380681420791	460
5358	name5358	380946043329	208
5359	name5359	380820232626	391
5360	name5360	380138026183	832
5361	name5361	380276709116	1569
5362	name5362	380271276418	1760
5363	name5363	38064254293	1517
5364	name5364	380797890542	1173
5365	name5365	380734287877	504
5366	name5366	380217450545	1536
5367	name5367	38074137576	408
5368	name5368	380739655982	766
5369	name5369	380850278352	416
5370	name5370	380873575112	699
5371	name5371	380680147265	498
5372	name5372	380811925383	1218
5373	name5373	38075775179	720
5374	name5374	380971534149	172
5375	name5375	38068599714	10
5376	name5376	380391242291	609
5377	name5377	380559300401	1944
5378	name5378	38036920424	1052
5379	name5379	380595870991	758
5380	name5380	380341032943	1205
5381	name5381	380702305466	1359
5382	name5382	380326118190	192
5383	name5383	380605040386	1497
5384	name5384	380516395791	1628
5385	name5385	380332682809	1547
5386	name5386	380725941540	96
5387	name5387	380413144012	1165
5388	name5388	380555393697	762
5389	name5389	380510371115	1129
5390	name5390	380232431493	1541
5391	name5391	380853173023	39
5392	name5392	380864637318	400
5393	name5393	380360001553	376
5394	name5394	380270606158	950
5395	name5395	380136699176	1725
5396	name5396	380864621074	1798
5397	name5397	380538487756	1587
5398	name5398	380807864805	1070
5399	name5399	380312261110	32
5400	name5400	380619618352	427
5401	name5401	380116486618	467
5402	name5402	380244313888	74
5403	name5403	380583936861	1886
5404	name5404	380427217996	1732
5405	name5405	380923351745	1359
5406	name5406	380430581157	375
5407	name5407	380217025841	1220
5408	name5408	380101172566	1112
5409	name5409	380182793078	261
5410	name5410	380817908407	1582
5411	name5411	380577255839	753
5412	name5412	380943638048	497
5413	name5413	380473796448	1851
5414	name5414	380839784380	1759
5415	name5415	38050831656	1680
5416	name5416	380492747513	171
5417	name5417	380376922183	23
5418	name5418	380765542231	1466
5419	name5419	380589990748	1520
5420	name5420	380350535496	826
5421	name5421	380313993857	1851
5422	name5422	380763771008	1214
5423	name5423	380478191871	78
5424	name5424	380874398326	1995
5425	name5425	38029133504	10
5426	name5426	38029773243	1542
5427	name5427	380556924189	588
5428	name5428	380460546193	173
5429	name5429	380376449643	1525
5430	name5430	38032461138	672
5431	name5431	380689300730	1169
5432	name5432	38096408142	525
5433	name5433	380825415774	1681
5434	name5434	380140967440	193
5435	name5435	380131630524	703
5436	name5436	380924949238	1611
5437	name5437	380635691308	496
5438	name5438	380721924107	315
5439	name5439	380861212205	270
5440	name5440	380689732751	1571
5441	name5441	380521060616	1370
5442	name5442	380830027680	1306
5443	name5443	380775447522	1820
5444	name5444	380135817034	1946
5445	name5445	380865150637	1527
5446	name5446	380625485167	1054
5447	name5447	380183450001	272
5448	name5448	38076849784	1147
5449	name5449	380983109897	749
5450	name5450	380873663505	1393
5451	name5451	380696661054	1283
5452	name5452	380829769247	1723
5453	name5453	380372593257	590
5454	name5454	380249319663	713
5455	name5455	380670247235	1629
5456	name5456	380820225601	1515
5457	name5457	380458924038	1535
5458	name5458	380567862463	487
5459	name5459	380823527103	609
5460	name5460	380207203938	738
5461	name5461	380623549632	819
5462	name5462	380590011507	1246
5463	name5463	380787278331	446
5464	name5464	380525495796	495
5465	name5465	380687845148	1857
5466	name5466	380237918614	1431
5467	name5467	380691044435	161
5468	name5468	380338886984	115
5469	name5469	380897553412	1916
5470	name5470	380167373074	1895
5471	name5471	380757659767	1893
5472	name5472	380302588097	1241
5473	name5473	380473905417	1419
5474	name5474	380862319265	1666
5475	name5475	380348930294	1605
5476	name5476	380496038696	1503
5477	name5477	380138594602	1832
5478	name5478	380157893951	1916
5479	name5479	380280160319	451
5480	name5480	380380399231	1588
5481	name5481	380619757785	66
5482	name5482	380212986266	1061
5483	name5483	380157040604	380
5484	name5484	380810564363	1750
5485	name5485	380959046579	1631
5486	name5486	3802506288	1594
5487	name5487	380291975563	1785
5488	name5488	380569270132	1467
5489	name5489	380685482442	1252
5490	name5490	380895813516	55
5491	name5491	380624515188	745
5492	name5492	380348833274	258
5493	name5493	380335427572	1272
5494	name5494	380546924794	721
5495	name5495	380339085415	1815
5496	name5496	380770386701	931
5497	name5497	380880649274	1130
5498	name5498	380313137642	376
5499	name5499	380270217565	839
5500	name5500	380265418554	704
5501	name5501	380894708735	1695
5502	name5502	380613639762	78
5503	name5503	38079127585	1413
5504	name5504	380642366109	1906
5505	name5505	380523992977	1113
5506	name5506	380863724134	1583
5507	name5507	380834578002	1245
5508	name5508	380192467995	254
5509	name5509	380831482559	1241
5510	name5510	380901711798	432
5511	name5511	380434883853	1851
5512	name5512	380852671489	941
5513	name5513	380912284052	393
5514	name5514	380646046506	673
5515	name5515	38056737497	1343
5516	name5516	380415883850	1237
5517	name5517	380419156892	118
5518	name5518	380263837242	205
5519	name5519	380940890174	492
5520	name5520	38065130630	1906
5521	name5521	380128455530	861
5522	name5522	380537081403	1238
5523	name5523	380645929470	954
5524	name5524	380691247390	1025
5525	name5525	380782441417	1310
5526	name5526	380719723606	1800
5527	name5527	380881345641	104
5528	name5528	380944717136	263
5529	name5529	380288771774	221
5530	name5530	380781537862	687
5531	name5531	38022325000	1605
5532	name5532	380760431822	1948
5533	name5533	38083744995	1776
5534	name5534	38030634625	1199
5535	name5535	380904409425	361
5536	name5536	380996885303	560
5537	name5537	380979802324	1731
5538	name5538	380145384235	1827
5539	name5539	380880106486	1525
5540	name5540	380744104981	1618
5541	name5541	380542703847	534
5542	name5542	380282034871	1880
5543	name5543	380916138875	1861
5544	name5544	3801132780	154
5545	name5545	380168190269	1100
5546	name5546	380262731645	744
5547	name5547	380634323705	554
5548	name5548	380605831035	704
5549	name5549	380755912103	1631
5550	name5550	380699584162	1692
5551	name5551	380206735997	511
5552	name5552	380147097916	576
5553	name5553	380679681215	1152
5554	name5554	38036578087	124
5555	name5555	380353125260	531
5556	name5556	380810238235	688
5557	name5557	380613027818	1787
5558	name5558	380858302333	1419
5559	name5559	380942433622	1341
5560	name5560	380736381471	1161
5561	name5561	380438605482	634
5562	name5562	380841612672	156
5563	name5563	380848247526	1108
5564	name5564	380130727563	1169
5565	name5565	380715779110	826
5566	name5566	380535545231	1199
5567	name5567	380368266623	1137
5568	name5568	380474415216	57
5569	name5569	38034982708	942
5570	name5570	380821224766	907
5571	name5571	380199182217	519
5572	name5572	380301454951	239
5573	name5573	380597996644	1909
5574	name5574	380705503113	1797
5575	name5575	380310137605	1077
5576	name5576	380944082733	700
5577	name5577	380843644627	1978
5578	name5578	380771058118	581
5579	name5579	380120232784	1156
5580	name5580	380853827546	631
5581	name5581	380217650244	655
5582	name5582	380576252954	73
5583	name5583	380839000552	619
5584	name5584	380826430558	798
5585	name5585	380858248319	1956
5586	name5586	380957895384	381
5587	name5587	380244708913	857
5588	name5588	38029512311	299
5589	name5589	380145968974	157
5590	name5590	380129966455	461
5591	name5591	380265649977	1390
5592	name5592	380813690609	967
5593	name5593	380622778822	1871
5594	name5594	380735353753	1491
5595	name5595	380596797458	1950
5596	name5596	380119963063	1723
5597	name5597	380614075607	714
5598	name5598	380342695885	1914
5599	name5599	380971517194	486
5600	name5600	380945967665	840
5601	name5601	380144116538	1219
5602	name5602	380986817700	230
5603	name5603	380249187190	1678
5604	name5604	380946729871	1606
5605	name5605	38094167941	1077
5606	name5606	380132230179	649
5607	name5607	380949039386	1803
5608	name5608	380295328452	1903
5609	name5609	380451471439	520
5610	name5610	380251230211	1567
5611	name5611	380423313825	1255
5612	name5612	380467322540	1159
5613	name5613	380390131000	1998
5614	name5614	380110834038	300
5615	name5615	380324581191	816
5616	name5616	380519661751	125
5617	name5617	380531962636	358
5618	name5618	380868809118	1539
5619	name5619	38079130849	1143
5620	name5620	380668157715	535
5621	name5621	380291565722	384
5622	name5622	380404253094	303
5623	name5623	380567552628	1814
5624	name5624	380813561690	1012
5625	name5625	380716348435	289
5626	name5626	380621450521	1223
5627	name5627	380362600717	427
5628	name5628	380989126970	1210
5629	name5629	380705571278	623
5630	name5630	380139188496	16
5631	name5631	380551281197	1948
5632	name5632	380194619259	927
5633	name5633	380214888574	1754
5634	name5634	380136526565	487
5635	name5635	380131640067	1173
5636	name5636	380513581041	1359
5637	name5637	380822219759	581
5638	name5638	380698514614	756
5639	name5639	380124360105	456
5640	name5640	380880889846	1795
5641	name5641	380410546894	220
5642	name5642	380772980155	82
5643	name5643	380165041663	1944
5644	name5644	38053033179	1450
5645	name5645	380292513497	699
5646	name5646	380496833845	496
5647	name5647	380375608582	1596
5648	name5648	380738937457	945
5649	name5649	380705219252	612
5650	name5650	380815064524	640
5651	name5651	380573934822	82
5652	name5652	38057642425	1835
5653	name5653	380601716886	462
5654	name5654	380838532829	1118
5655	name5655	380331444349	1933
5656	name5656	380411739033	915
5657	name5657	380184398056	970
5658	name5658	380561770851	1240
5659	name5659	380381635163	283
5660	name5660	380991545395	1985
5661	name5661	380806306090	1809
5662	name5662	380386324699	1259
5663	name5663	380411382343	1350
5664	name5664	380771865156	1842
5665	name5665	380116661366	1424
5666	name5666	380318932462	609
5667	name5667	380215273571	1064
5668	name5668	380426363007	769
5669	name5669	380569381623	1366
5670	name5670	380890332290	689
5671	name5671	380585537871	377
5672	name5672	380787736195	954
5673	name5673	380336601056	1890
5674	name5674	380376189455	1454
5675	name5675	380561383330	601
5676	name5676	380626716364	247
5677	name5677	380977240332	1228
5678	name5678	380106087554	1629
5679	name5679	380827426444	1141
5680	name5680	380739385785	1319
5681	name5681	380873281105	620
5682	name5682	380782442893	868
5683	name5683	38077663434	208
5684	name5684	380828343850	1955
5685	name5685	380948904873	1746
5686	name5686	380264392744	719
5687	name5687	380136016565	1733
5688	name5688	380975046335	102
5689	name5689	380781043642	22
5690	name5690	380121123029	559
5691	name5691	38024425175	1901
5692	name5692	380742419271	1369
5693	name5693	380160760341	1474
5694	name5694	38046809221	1244
5695	name5695	380112905857	1365
5696	name5696	38061004078	1268
5697	name5697	3805456944	695
5698	name5698	380530541346	1182
5699	name5699	380981768127	601
5700	name5700	38058928732	1963
5701	name5701	380300049282	797
5702	name5702	380767610083	1697
5703	name5703	380823654938	489
5704	name5704	380244553976	943
5705	name5705	380274426117	904
5706	name5706	380914791484	343
5707	name5707	380652320758	701
5708	name5708	380867471709	1402
5709	name5709	380133827858	585
5710	name5710	380366353095	1292
5711	name5711	380446727537	138
5712	name5712	380623517629	339
5713	name5713	380442963798	887
5714	name5714	380647109474	1107
5715	name5715	380714419906	1056
5716	name5716	380965609611	751
5717	name5717	380334087515	1601
5718	name5718	380874800741	1623
5719	name5719	38019149400	1562
5720	name5720	380295670119	873
5721	name5721	380439844746	79
5722	name5722	38080298975	363
5723	name5723	380386892479	1368
5724	name5724	380982892950	119
5725	name5725	380235098071	1017
5726	name5726	380237734503	1537
5727	name5727	380424912593	1694
5728	name5728	38047554561	924
5729	name5729	380965344755	493
5730	name5730	380847772552	1169
5731	name5731	380594141755	81
5732	name5732	380112956011	297
5733	name5733	380715629679	1455
5734	name5734	380739280808	1771
5735	name5735	380640315876	341
5736	name5736	380834545932	1080
5737	name5737	380371490898	176
5738	name5738	380263955322	806
5739	name5739	380379029738	269
5740	name5740	38016575769	222
5741	name5741	380196562715	1007
5742	name5742	380814686386	318
5743	name5743	380149845897	251
5744	name5744	380402658552	219
5745	name5745	380719726670	414
5746	name5746	380114242628	699
5747	name5747	380501086092	1609
5748	name5748	380135349590	1350
5749	name5749	380323496170	148
5750	name5750	380712051092	377
5751	name5751	380376867978	1982
5752	name5752	380907474431	209
5753	name5753	380855622147	284
5754	name5754	380762398698	1334
5755	name5755	380978863231	142
5756	name5756	380238654062	1933
5757	name5757	380264316717	229
5758	name5758	380309346565	1954
5759	name5759	380935309388	14
5760	name5760	380296702477	1060
5761	name5761	380466235854	34
5762	name5762	380797228564	642
5763	name5763	380687796212	694
5764	name5764	380515805133	1638
5765	name5765	380693292171	921
5766	name5766	380389119398	881
5767	name5767	380501681998	844
5768	name5768	380540261397	425
5769	name5769	380492961604	1953
5770	name5770	380390550837	84
5771	name5771	3808715123	466
5772	name5772	380920847523	393
5773	name5773	380456104616	854
5774	name5774	380826597831	1133
5775	name5775	380131205319	290
5776	name5776	380515411919	67
5777	name5777	380961170105	382
5778	name5778	380144944224	1163
5779	name5779	380937196750	374
5780	name5780	380779159216	1030
5781	name5781	380614340064	360
5782	name5782	380456491250	1152
5783	name5783	380897454968	299
5784	name5784	380484346785	1101
5785	name5785	380257681724	478
5786	name5786	380472436013	312
5787	name5787	38010231346	170
5788	name5788	380873064616	1959
5789	name5789	38053303026	344
5790	name5790	380849592129	1119
5791	name5791	380821875682	1874
5792	name5792	380637779783	1340
5793	name5793	380138083345	936
5794	name5794	380464246049	174
5795	name5795	380884219386	1926
5796	name5796	380337907802	1638
5797	name5797	380103626001	1306
5798	name5798	380852360338	1184
5799	name5799	380177662032	1410
5800	name5800	380120457868	68
5801	name5801	380278128823	1902
5802	name5802	380786895031	425
5803	name5803	380407102283	1410
5804	name5804	380720545099	692
5805	name5805	380674995379	62
5806	name5806	380520990063	1889
5807	name5807	380401924098	1377
5808	name5808	380303153284	313
5809	name5809	380996939097	1857
5810	name5810	380371431290	1033
5811	name5811	380567470059	194
5812	name5812	380478974008	1338
5813	name5813	380229416887	1885
5814	name5814	38016029903	1016
5815	name5815	38030719388	1166
5816	name5816	380820575366	1585
5817	name5817	380874444586	1464
5818	name5818	380550225502	1280
5819	name5819	380774778075	565
5820	name5820	38034823353	502
5821	name5821	380531795208	733
5822	name5822	380114446989	1069
5823	name5823	380283446373	457
5824	name5824	38055774537	486
5825	name5825	380361489067	262
5826	name5826	380839728123	129
5827	name5827	380527343937	937
5828	name5828	380229687301	165
5829	name5829	380507204019	352
5830	name5830	380243096345	1610
5831	name5831	380166259046	790
5832	name5832	380318993824	1196
5833	name5833	380138240779	375
5834	name5834	380767779622	597
5835	name5835	380658584810	4
5836	name5836	380681793753	900
5837	name5837	380707074209	1682
5838	name5838	380340876939	370
5839	name5839	380238576014	1293
5840	name5840	380942556024	1422
5841	name5841	380915033067	325
5842	name5842	380508916	1329
5843	name5843	38016994384	1742
5844	name5844	38091255367	1007
5845	name5845	380840629640	1594
5846	name5846	380416426278	523
5847	name5847	380492421649	1591
5848	name5848	380893257469	883
5849	name5849	380589483448	464
5850	name5850	380536550730	1687
5851	name5851	380631647839	1497
5852	name5852	380159351	1010
5853	name5853	380563251346	207
5854	name5854	380384025626	1139
5855	name5855	380131250928	1485
5856	name5856	380289872157	596
5857	name5857	380174716538	1871
5858	name5858	380905257886	1158
5859	name5859	380142562190	901
5860	name5860	380878009909	806
5861	name5861	380230052651	914
5862	name5862	380632458299	912
5863	name5863	380403073619	1091
5864	name5864	380405752805	1124
5865	name5865	380695742833	1582
5866	name5866	380130779884	1706
5867	name5867	380534028474	627
5868	name5868	380673545098	1754
5869	name5869	380620799233	1521
5870	name5870	380809883782	1579
5871	name5871	38042107566	1258
5872	name5872	380335148223	1065
5873	name5873	380314521924	1430
5874	name5874	380705324403	1786
5875	name5875	380999071296	1336
5876	name5876	380150707615	1100
5877	name5877	380721409732	1167
5878	name5878	380492360705	1198
5879	name5879	380303854857	1178
5880	name5880	380506739204	833
5881	name5881	380288965257	1573
5882	name5882	380952613704	1994
5883	name5883	38084480310	363
5884	name5884	380409556878	920
5885	name5885	380507624057	1940
5886	name5886	380744472078	775
5887	name5887	38040408751	233
5888	name5888	380639027928	883
5889	name5889	380997110139	622
5890	name5890	380956493190	1241
5891	name5891	380118397280	1665
5892	name5892	380982167563	781
5893	name5893	380318028123	1422
5894	name5894	38077576428	1272
5895	name5895	380755963270	1295
5896	name5896	380549598726	1938
5897	name5897	380164923237	826
5898	name5898	380679844736	787
5899	name5899	380306231429	864
5900	name5900	380789067582	1581
5901	name5901	380826475283	1651
5902	name5902	380964528876	683
5903	name5903	380106911461	1918
5904	name5904	380453900810	1951
5905	name5905	380624668383	896
5906	name5906	3805402662	310
5907	name5907	380795714840	1805
5908	name5908	38043526286	1700
5909	name5909	380828046320	1293
5910	name5910	380879286418	363
5911	name5911	380866582360	1785
5912	name5912	38019086438	1879
5913	name5913	380400500069	1906
5914	name5914	380192765587	50
5915	name5915	380458198736	1892
5916	name5916	380899011495	1967
5917	name5917	38038041396	361
5918	name5918	380795632062	687
5919	name5919	380961580787	1437
5920	name5920	380474570765	256
5921	name5921	380668920559	638
5922	name5922	380664842668	398
5923	name5923	380110830540	306
5924	name5924	380249391779	1978
5925	name5925	380870098926	755
5926	name5926	380201322736	1095
5927	name5927	380804858127	155
5928	name5928	380523362457	787
5929	name5929	380173965134	1809
5930	name5930	380112168078	805
5931	name5931	380413040665	135
5932	name5932	380611968218	1727
5933	name5933	380707387927	864
5934	name5934	380962286213	1350
5935	name5935	380800056349	331
5936	name5936	380646846938	528
5937	name5937	380990456528	781
5938	name5938	380634962866	474
5939	name5939	380710807049	844
5940	name5940	380450177669	537
5941	name5941	380509921912	660
5942	name5942	380806062611	528
5943	name5943	380572331547	617
5944	name5944	380650586995	241
5945	name5945	380123396177	1892
5946	name5946	38030518663	1112
5947	name5947	380673454524	1705
5948	name5948	380625817410	649
5949	name5949	380711394015	99
5950	name5950	380784506342	978
5951	name5951	380192777387	1397
5952	name5952	380959838221	918
5953	name5953	380307536479	1358
5954	name5954	380377423007	1463
5955	name5955	380670285146	621
5956	name5956	380909898818	535
5957	name5957	380250534543	1633
5958	name5958	380822834687	1459
5959	name5959	380406732854	613
5960	name5960	380240859637	423
5961	name5961	380528404811	1871
5962	name5962	380768341379	1000
5963	name5963	380468124713	1467
5964	name5964	380626745561	525
5965	name5965	380254843755	115
5966	name5966	380365429483	1356
5967	name5967	380650672810	275
5968	name5968	380397732624	65
5969	name5969	380224526625	491
5970	name5970	380399516350	808
5971	name5971	380995909717	1446
5972	name5972	380557709598	1678
5973	name5973	380348654208	740
5974	name5974	380188368748	886
5975	name5975	380448043900	1232
5976	name5976	380874284104	1281
5977	name5977	380850321488	1643
5978	name5978	380237839548	263
5979	name5979	380618728072	507
5980	name5980	380188886083	213
5981	name5981	380792828576	1420
5982	name5982	380664485347	655
5983	name5983	380611322420	382
5984	name5984	380476842747	237
5985	name5985	380480122516	471
5986	name5986	380155297478	1887
5987	name5987	380591266013	1562
5988	name5988	380251466097	1
5989	name5989	380680000415	904
5990	name5990	380138820134	1029
5991	name5991	380545734822	1008
5992	name5992	380625939757	145
5993	name5993	380415996200	1245
5994	name5994	380745787517	222
5995	name5995	380119402606	1932
5996	name5996	380273873937	1452
5997	name5997	380207116911	1653
5998	name5998	380600657320	1581
5999	name5999	380849495590	125
6000	name6000	38043698630	1015
6001	name6001	380325516188	166
6002	name6002	38020745760	6
6003	name6003	380748732411	564
6004	name6004	380541593492	557
6005	name6005	380626144196	1441
6006	name6006	380522900120	1892
6007	name6007	380336081286	442
6008	name6008	380388541092	234
6009	name6009	380280371148	1375
6010	name6010	380817723653	1873
6011	name6011	380620085846	106
6012	name6012	380443596075	1592
6013	name6013	380834147401	1925
6014	name6014	380580365039	1830
6015	name6015	380565973630	1437
6016	name6016	380259969202	1872
6017	name6017	380192663412	1675
6018	name6018	38049995705	1842
6019	name6019	380484655929	1511
6020	name6020	380673539859	681
6021	name6021	380705559166	624
6022	name6022	380955643503	527
6023	name6023	380968468535	1373
6024	name6024	380313566470	1534
6025	name6025	380552981633	861
6026	name6026	380875475865	1071
6027	name6027	380255129078	1196
6028	name6028	380149418920	1058
6029	name6029	380192301878	918
6030	name6030	38094499798	1573
6031	name6031	380658562088	1590
6032	name6032	380949993602	1667
6033	name6033	38062807293	1866
6034	name6034	380469665458	1344
6035	name6035	380284256743	154
6036	name6036	380817097648	1537
6037	name6037	380921530500	1306
6038	name6038	38082344647	123
6039	name6039	380109588514	1362
6040	name6040	380171637335	451
6041	name6041	380723541421	1280
6042	name6042	380350050896	1388
6043	name6043	380508593711	736
6044	name6044	380711174157	844
6045	name6045	380506114388	1508
6046	name6046	380279144037	797
6047	name6047	380929199253	379
6048	name6048	380736703612	1519
6049	name6049	380195414468	1138
6050	name6050	380118314696	1021
6051	name6051	38072667958	827
6052	name6052	380760874090	1402
6053	name6053	38049578068	1712
6054	name6054	380472193226	544
6055	name6055	380104436304	891
6056	name6056	380682929173	736
6057	name6057	380771768837	466
6058	name6058	38061918629	389
6059	name6059	38057636019	226
6060	name6060	380849184065	1685
6061	name6061	380375072505	1255
6062	name6062	380584506170	76
6063	name6063	380231067090	830
6064	name6064	380641718451	1970
6065	name6065	380127680144	1220
6066	name6066	380288063165	353
6067	name6067	380478516885	488
6068	name6068	380560191780	1709
6069	name6069	380337049974	518
6070	name6070	380911140939	927
6071	name6071	380423012127	1679
6072	name6072	380118395456	365
6073	name6073	38096609816	225
6074	name6074	380950722668	1315
6075	name6075	380785386511	1775
6076	name6076	380882607659	1851
6077	name6077	380184667165	1563
6078	name6078	380946601981	992
6079	name6079	380809610874	1418
6080	name6080	38075393182	1016
6081	name6081	380104758241	830
6082	name6082	380675401114	1062
6083	name6083	380706454073	1742
6084	name6084	380876700681	1559
6085	name6085	380337542767	311
6086	name6086	380113530418	1821
6087	name6087	380771635168	1939
6088	name6088	380722585826	1194
6089	name6089	380550014195	1026
6090	name6090	380486448436	1583
6091	name6091	380404730184	1607
6092	name6092	380957388880	831
6093	name6093	380107347300	167
6094	name6094	380106213868	528
6095	name6095	380341373758	1502
6096	name6096	380392601988	324
6097	name6097	380350872884	882
6098	name6098	380398222870	1361
6099	name6099	380585036338	374
6100	name6100	380997982811	1990
6101	name6101	380852804548	1306
6102	name6102	380122017602	1431
6103	name6103	380497775456	1931
6104	name6104	380758839769	52
6105	name6105	380110421463	1948
6106	name6106	380344080043	1357
6107	name6107	380384393901	677
6108	name6108	380917088078	1933
6109	name6109	380791035498	1830
6110	name6110	380969659154	734
6111	name6111	380424552540	549
6112	name6112	380440037553	910
6113	name6113	380841467480	1138
6114	name6114	380286114807	1858
6115	name6115	380606370056	996
6116	name6116	380775430847	1180
6117	name6117	380204777251	1001
6118	name6118	380915318812	375
6119	name6119	380167310072	885
6120	name6120	380227637023	792
6121	name6121	380981112241	974
6122	name6122	380173777172	1952
6123	name6123	380118747148	206
6124	name6124	380679878060	1113
6125	name6125	38082860954	1196
6126	name6126	380155898742	1903
6127	name6127	380525180866	794
6128	name6128	380770807812	619
6129	name6129	380486547662	367
6130	name6130	380900928971	1226
6131	name6131	38023920949	1853
6132	name6132	380968681914	482
6133	name6133	380310434324	1584
6134	name6134	380993313791	737
6135	name6135	380443109915	1305
6136	name6136	380558885978	1435
6137	name6137	380148581738	1476
6138	name6138	380548603241	1540
6139	name6139	380532722423	1601
6140	name6140	380234985927	553
6141	name6141	380385765951	1283
6142	name6142	380124517348	1319
6143	name6143	380632846124	960
6144	name6144	380452111313	366
6145	name6145	380885374314	1210
6146	name6146	380994673579	1360
6147	name6147	380324896635	1939
6148	name6148	380734887792	498
6149	name6149	380282070073	84
6150	name6150	380959035941	999
6151	name6151	380643863287	27
6152	name6152	380828931314	221
6153	name6153	380686091416	1888
6154	name6154	380421836072	398
6155	name6155	380563261505	681
6156	name6156	380621861965	1032
6157	name6157	380495642129	465
6158	name6158	380529106561	1637
6159	name6159	380129846285	1695
6160	name6160	380641772441	1579
6161	name6161	38062662949	472
6162	name6162	380361751684	741
6163	name6163	380643608177	246
6164	name6164	380251102803	1297
6165	name6165	380525696920	1505
6166	name6166	380367081024	1728
6167	name6167	380612042550	402
6168	name6168	380303062124	400
6169	name6169	380337555145	1637
6170	name6170	380675892343	32
6171	name6171	380208693841	432
6172	name6172	380505356840	1264
6173	name6173	38016652793	1351
6174	name6174	380690581990	391
6175	name6175	380627692929	1201
6176	name6176	380359417757	894
6177	name6177	380846445693	702
6178	name6178	380292579218	1757
6179	name6179	380932216882	1369
6180	name6180	380708070625	866
6181	name6181	380560206817	706
6182	name6182	380357965567	1856
6183	name6183	380769920087	1318
6184	name6184	380354301780	1091
6185	name6185	380166916066	827
6186	name6186	380594897052	1142
6187	name6187	38087453329	1213
6188	name6188	380210188343	1247
6189	name6189	380702397493	1351
6190	name6190	380334965747	1115
6191	name6191	380774866719	574
6192	name6192	380128074700	758
6193	name6193	380797752099	995
6194	name6194	38085613689	465
6195	name6195	380955272614	967
6196	name6196	380163691275	1193
6197	name6197	38029953070	309
6198	name6198	380847966229	1844
6199	name6199	380492539843	1853
6200	name6200	38059260783	586
6201	name6201	380308170439	46
6202	name6202	380342929252	869
6203	name6203	380697539716	741
6204	name6204	380327978929	304
6205	name6205	380320575157	795
6206	name6206	380990165502	722
6207	name6207	380289731558	819
6208	name6208	380411973898	1588
6209	name6209	380852265078	978
6210	name6210	380324824769	638
6211	name6211	380424449850	1945
6212	name6212	380994449527	546
6213	name6213	380633408825	976
6214	name6214	380293971365	667
6215	name6215	380176550671	1130
6216	name6216	38021833853	1297
6217	name6217	380101194699	921
6218	name6218	380779975305	1838
6219	name6219	380818130880	966
6220	name6220	380260145317	402
6221	name6221	380888801997	124
6222	name6222	380686281379	422
6223	name6223	380722513694	1424
6224	name6224	38026336351	1426
6225	name6225	38084108163	704
6226	name6226	380879638029	1780
6227	name6227	380839887750	640
6228	name6228	380933085999	768
6229	name6229	380940558465	413
6230	name6230	380302876059	1592
6231	name6231	380633807753	1856
6232	name6232	380225522511	828
6233	name6233	380148532003	552
6234	name6234	380197620908	338
6235	name6235	380744752242	1003
6236	name6236	380309921382	1287
6237	name6237	380379240449	1198
6238	name6238	380853971928	1754
6239	name6239	380700252018	587
6240	name6240	380944926722	103
6241	name6241	380251920380	1259
6242	name6242	380834383064	435
6243	name6243	380854540470	739
6244	name6244	380930792167	1080
6245	name6245	380321678162	1342
6246	name6246	380605051854	348
6247	name6247	380688648334	68
6248	name6248	380965164391	758
6249	name6249	38078294483	320
6250	name6250	380806513133	110
6251	name6251	380299409553	195
6252	name6252	380186795605	346
6253	name6253	380239695412	509
6254	name6254	380565410432	1782
6255	name6255	380658625792	1478
6256	name6256	380181153985	601
6257	name6257	38037374958	67
6258	name6258	380804277265	1856
6259	name6259	380227943990	706
6260	name6260	380332210558	756
6261	name6261	380460161849	238
6262	name6262	380161422446	1015
6263	name6263	380107748021	1016
6264	name6264	380158850546	1508
6265	name6265	38048337479	1808
6266	name6266	38057623745	362
6267	name6267	380807091318	163
6268	name6268	38036644319	810
6269	name6269	380328834004	1932
6270	name6270	380512362797	1763
6271	name6271	380314566086	678
6272	name6272	380668500703	1787
6273	name6273	380136298148	417
6274	name6274	380344976491	895
6275	name6275	380685805690	847
6276	name6276	380101521365	1207
6277	name6277	380172048841	1586
6278	name6278	380423676578	1688
6279	name6279	380241463900	1041
6280	name6280	380590811995	642
6281	name6281	380276861998	1374
6282	name6282	380129345034	691
6283	name6283	380480047088	1490
6284	name6284	380360842006	921
6285	name6285	380113185115	134
6286	name6286	380365918272	315
6287	name6287	380383557139	632
6288	name6288	380316062150	1335
6289	name6289	380612544378	1762
6290	name6290	380412723873	1073
6291	name6291	380251822926	742
6292	name6292	38087896740	720
6293	name6293	380504909371	1149
6294	name6294	38017149403	416
6295	name6295	3805570717	1855
6296	name6296	380886056750	786
6297	name6297	380134601638	1483
6298	name6298	380162449414	651
6299	name6299	380901247887	516
6300	name6300	380437629897	1150
6301	name6301	380223574994	446
6302	name6302	380412404249	275
6303	name6303	380295533921	1132
6304	name6304	380664976561	1015
6305	name6305	380174784013	656
6306	name6306	38082128026	730
6307	name6307	380868136871	641
6308	name6308	380568604011	159
6309	name6309	380338744290	1408
6310	name6310	380365903539	1475
6311	name6311	38082296384	842
6312	name6312	380267538588	1323
6313	name6313	380583750241	1524
6314	name6314	38074944047	670
6315	name6315	380548435022	846
6316	name6316	380109024123	39
6317	name6317	380718655116	1827
6318	name6318	380610016400	1936
6319	name6319	380913282137	1437
6320	name6320	380821527739	381
6321	name6321	380286359959	1845
6322	name6322	380978601895	1815
6323	name6323	380370827849	76
6324	name6324	380558039079	419
6325	name6325	380961555171	1687
6326	name6326	38029541090	982
6327	name6327	380469563037	1850
6328	name6328	380396638808	300
6329	name6329	380998786514	240
6330	name6330	38038851736	1733
6331	name6331	380550163511	1776
6332	name6332	38046544662	5
6333	name6333	380653178589	1650
6334	name6334	380460695395	1093
6335	name6335	380507246919	219
6336	name6336	380592701272	284
6337	name6337	380268369370	1719
6338	name6338	380132493503	1731
6339	name6339	380136858428	118
6340	name6340	380620971232	1126
6341	name6341	380342241076	1821
6342	name6342	380771277876	168
6343	name6343	380757339924	549
6344	name6344	380847742230	994
6345	name6345	380654351876	1321
6346	name6346	380950949333	1306
6347	name6347	380115246399	316
6348	name6348	380859046345	1609
6349	name6349	380798681345	797
6350	name6350	380341781447	867
6351	name6351	380490656458	1489
6352	name6352	380999975624	854
6353	name6353	380806126694	279
6354	name6354	380211939839	1559
6355	name6355	380968870519	1381
6356	name6356	380178280647	923
6357	name6357	38073478233	1084
6358	name6358	380626811111	1424
6359	name6359	380760014353	859
6360	name6360	38017688677	1536
6361	name6361	380415337776	1474
6362	name6362	380479494920	1437
6363	name6363	380327006201	988
6364	name6364	380655933152	113
6365	name6365	380614224365	821
6366	name6366	380191977946	112
6367	name6367	380668866832	48
6368	name6368	380597129326	758
6369	name6369	380519164325	1141
6370	name6370	380341475142	1441
6371	name6371	38034242721	107
6372	name6372	380543469805	581
6373	name6373	380207238874	1821
6374	name6374	380493511799	1349
6375	name6375	380383686954	403
6376	name6376	380520881199	519
6377	name6377	380414338736	1060
6378	name6378	380518975014	1284
6379	name6379	380243739719	1675
6380	name6380	380929037072	1698
6381	name6381	380814853187	1693
6382	name6382	380696155418	1965
6383	name6383	3806834273	349
6384	name6384	380267845542	1593
6385	name6385	380504927096	742
6386	name6386	380963424830	1747
6387	name6387	380924814182	1133
6388	name6388	380178230093	97
6389	name6389	380455605479	4
6390	name6390	3809473077	1121
6391	name6391	380857297514	144
6392	name6392	380370832282	215
6393	name6393	380751627359	588
6394	name6394	380134903027	988
6395	name6395	380496802497	1342
6396	name6396	380866442751	1294
6397	name6397	380135430957	993
6398	name6398	380363527074	1170
6399	name6399	380168621124	733
6400	name6400	380428895238	686
6401	name6401	38016316878	468
6402	name6402	380449116324	1047
6403	name6403	380153681201	34
6404	name6404	380905344824	874
6405	name6405	380479536688	1573
6406	name6406	380741945772	360
6407	name6407	380706487624	336
6408	name6408	380498929303	1030
6409	name6409	380502807573	1007
6410	name6410	380330700264	1442
6411	name6411	380827719146	1697
6412	name6412	380461539198	1606
6413	name6413	380137501258	1011
6414	name6414	380143727185	294
6415	name6415	380332841742	1482
6416	name6416	380814680227	1609
6417	name6417	380683243516	355
6418	name6418	380416938013	1611
6419	name6419	380655472842	250
6420	name6420	38067209935	2000
6421	name6421	380238241113	480
6422	name6422	380954692411	1618
6423	name6423	38099106392	106
6424	name6424	380411200462	436
6425	name6425	380569302335	465
6426	name6426	380218690677	279
6427	name6427	380255725803	422
6428	name6428	38030579792	969
6429	name6429	380156836975	1790
6430	name6430	380475323538	1824
6431	name6431	38037954586	92
6432	name6432	380268917310	1099
6433	name6433	380938338369	13
6434	name6434	380964277618	839
6435	name6435	380106511800	746
6436	name6436	380868253616	1069
6437	name6437	380621815321	1470
6438	name6438	380473790940	1162
6439	name6439	380441265476	443
6440	name6440	38033862461	615
6441	name6441	380156832065	257
6442	name6442	380427240645	1199
6443	name6443	380817150965	136
6444	name6444	3802031837	1079
6445	name6445	380739331447	1295
6446	name6446	380911295231	1873
6447	name6447	38061306750	972
6448	name6448	380219244798	292
6449	name6449	380556986702	935
6450	name6450	380270371198	441
6451	name6451	380131266770	792
6452	name6452	380389536103	1534
6453	name6453	380839802218	1143
6454	name6454	380421419402	232
6455	name6455	380352849681	1050
6456	name6456	38048431169	1116
6457	name6457	380917040048	46
6458	name6458	380826075019	142
6459	name6459	38068040959	126
6460	name6460	38090996914	1017
6461	name6461	380162888156	1264
6462	name6462	380716007045	1991
6463	name6463	380585837192	1630
6464	name6464	380760532635	1663
6465	name6465	380471835162	470
6466	name6466	380277094053	876
6467	name6467	380711502573	652
6468	name6468	38013810910	1471
6469	name6469	380288326098	1559
6470	name6470	380837152816	1035
6471	name6471	380401389370	952
6472	name6472	380267176521	653
6473	name6473	38037421064	1755
6474	name6474	380901800694	1992
6475	name6475	380791436282	698
6476	name6476	380221983299	320
6477	name6477	380892965195	743
6478	name6478	38078211647	249
6479	name6479	380158344894	1616
6480	name6480	380522677392	1851
6481	name6481	380271930618	989
6482	name6482	380404724765	654
6483	name6483	380364534279	751
6484	name6484	380249328726	587
6485	name6485	380868460602	42
6486	name6486	380456303517	1978
6487	name6487	380223200948	97
6488	name6488	380849702915	660
6489	name6489	380814709484	1545
6490	name6490	380365668940	938
6491	name6491	380600705077	397
6492	name6492	380813311660	186
6493	name6493	38069430776	1699
6494	name6494	380834610879	1267
6495	name6495	380193228219	1462
6496	name6496	380748663365	1285
6497	name6497	38046646586	699
6498	name6498	380509713644	1519
6499	name6499	380906991593	135
6500	name6500	380190665246	984
6501	name6501	380978485834	410
6502	name6502	380164836206	39
6503	name6503	380910701654	717
6504	name6504	380411436334	1963
6505	name6505	380496883097	123
6506	name6506	380825607762	1772
6507	name6507	380380339984	389
6508	name6508	380286435325	1597
6509	name6509	380372386024	107
6510	name6510	380848507374	1931
6511	name6511	38025601715	531
6512	name6512	380258671048	793
6513	name6513	380484553508	14
6514	name6514	380541486810	880
6515	name6515	380870499738	1806
6516	name6516	380104854175	946
6517	name6517	380652690892	1564
6518	name6518	380900388951	1996
6519	name6519	380794804929	342
6520	name6520	380324799470	1915
6521	name6521	380428938901	821
6522	name6522	380604555526	594
6523	name6523	380755624620	1404
6524	name6524	380913456334	1565
6525	name6525	380864611304	575
6526	name6526	380438077761	572
6527	name6527	380767696599	76
6528	name6528	380226014212	1023
6529	name6529	380387389126	1928
6530	name6530	380605317171	946
6531	name6531	380885683094	1438
6532	name6532	380881106651	467
6533	name6533	380569378055	1233
6534	name6534	38018931399	1614
6535	name6535	3801302590	862
6536	name6536	380763856075	199
6537	name6537	380787597123	1129
6538	name6538	38037127103	797
6539	name6539	38032575941	81
6540	name6540	380366118558	815
6541	name6541	380658292331	349
6542	name6542	380498798696	1646
6543	name6543	380472451191	852
6544	name6544	380940686845	1533
6545	name6545	3809285208	749
6546	name6546	380388293550	1945
6547	name6547	380600897841	68
6548	name6548	380332398356	127
6549	name6549	380900724882	1786
6550	name6550	380396591441	1749
6551	name6551	380410140080	285
6552	name6552	380293205807	1137
6553	name6553	380440089706	706
6554	name6554	380826643782	228
6555	name6555	380299568731	700
6556	name6556	380579559104	8
6557	name6557	380503682317	915
6558	name6558	380214556975	1853
6559	name6559	380358197535	925
6560	name6560	380986301214	806
6561	name6561	380881406862	1999
6562	name6562	380155419201	293
6563	name6563	380952099859	1136
6564	name6564	380587205544	1023
6565	name6565	380227160472	1547
6566	name6566	380786181591	1777
6567	name6567	380896491028	407
6568	name6568	38051910813	10
6569	name6569	380712189528	353
6570	name6570	380294558208	598
6571	name6571	380632048465	1416
6572	name6572	380794099279	181
6573	name6573	380647356409	1581
6574	name6574	380501974985	69
6575	name6575	38098350468	1813
6576	name6576	380506198282	1247
6577	name6577	38032160711	230
6578	name6578	380772870972	1934
6579	name6579	380850254124	572
6580	name6580	38059671248	1320
6581	name6581	380988912128	156
6582	name6582	380197956315	1609
6583	name6583	380982537376	893
6584	name6584	380833235300	726
6585	name6585	380100636582	1653
6586	name6586	380604305585	615
6587	name6587	380591738813	252
6588	name6588	380888356354	951
6589	name6589	380557714651	603
6590	name6590	380582482732	170
6591	name6591	380430005365	1851
6592	name6592	380484511743	1314
6593	name6593	380763128156	222
6594	name6594	380465450364	1141
6595	name6595	380602691867	1859
6596	name6596	380736482911	1942
6597	name6597	380197378696	515
6598	name6598	380324131571	1814
6599	name6599	380278861328	640
6600	name6600	380610979340	979
6601	name6601	380215117386	1135
6602	name6602	380291612398	379
6603	name6603	380461750009	119
6604	name6604	380366957379	771
6605	name6605	380365389739	707
6606	name6606	380326667698	965
6607	name6607	380585350849	670
6608	name6608	380217966917	1945
6609	name6609	380390879986	1172
6610	name6610	380265257731	192
6611	name6611	380634821731	815
6612	name6612	380768742695	1577
6613	name6613	380378986792	1617
6614	name6614	380276697805	1904
6615	name6615	380344355358	814
6616	name6616	380313188173	382
6617	name6617	380484953863	518
6618	name6618	380683293906	30
6619	name6619	380908994359	318
6620	name6620	380616136291	1834
6621	name6621	380116215812	1094
6622	name6622	380265433792	958
6623	name6623	380299802667	480
6624	name6624	380404195763	918
6625	name6625	380614828594	1653
6626	name6626	380358620879	401
6627	name6627	380328601185	1513
6628	name6628	380607111715	1904
6629	name6629	380974186214	1394
6630	name6630	380158057653	1227
6631	name6631	380843556537	1910
6632	name6632	380894018238	261
6633	name6633	380415657949	1333
6634	name6634	38036571658	778
6635	name6635	38015315126	331
6636	name6636	380290495590	1614
6637	name6637	380184414520	284
6638	name6638	380412500618	1870
6639	name6639	380400765029	303
6640	name6640	380522349249	314
6641	name6641	380421274034	757
6642	name6642	380788309304	191
6643	name6643	38044174437	1101
6644	name6644	380168509448	872
6645	name6645	380664240740	1685
6646	name6646	380234019601	616
6647	name6647	380130311431	748
6648	name6648	3804541197	1917
6649	name6649	380430508164	436
6650	name6650	380480942268	885
6651	name6651	380868735036	460
6652	name6652	380944213795	1157
6653	name6653	380443654637	1805
6654	name6654	380292774335	802
6655	name6655	380230925624	68
6656	name6656	380431788342	1416
6657	name6657	380683800176	999
6658	name6658	380218065329	213
6659	name6659	380641083108	616
6660	name6660	380772649567	744
6661	name6661	380348470607	415
6662	name6662	380728678854	46
6663	name6663	380636677809	1770
6664	name6664	380813267201	37
6665	name6665	380582304412	1991
6666	name6666	38094628726	965
6667	name6667	380156230675	1083
6668	name6668	380269979967	1354
6669	name6669	38043641452	1288
6670	name6670	380821121346	1516
6671	name6671	380409990584	600
6672	name6672	380364634855	666
6673	name6673	380870177210	1945
6674	name6674	380716483386	1194
6675	name6675	38065455907	1162
6676	name6676	380836693455	1100
6677	name6677	380744602886	837
6678	name6678	380510716657	1699
6679	name6679	380695969418	821
6680	name6680	380777168634	1573
6681	name6681	380670457255	1654
6682	name6682	380697645460	1093
6683	name6683	380449439007	801
6684	name6684	380558936523	797
6685	name6685	380889892198	475
6686	name6686	380926076073	1122
6687	name6687	380688765636	698
6688	name6688	380737963412	1620
6689	name6689	380515926752	924
6690	name6690	380767268687	600
6691	name6691	380819583555	1988
6692	name6692	380566302638	1130
6693	name6693	380834886023	805
6694	name6694	380190649328	455
6695	name6695	380678850081	291
6696	name6696	380413985609	1555
6697	name6697	380548567905	928
6698	name6698	380193508432	130
6699	name6699	380124702273	1483
6700	name6700	380244911609	336
6701	name6701	380174353769	1505
6702	name6702	38063014053	1580
6703	name6703	380899489702	1522
6704	name6704	380461415773	1912
6705	name6705	380374705785	1159
6706	name6706	380962906545	193
6707	name6707	380380285222	1013
6708	name6708	380131371402	433
6709	name6709	380630624789	1968
6710	name6710	380398558247	1288
6711	name6711	380571383353	55
6712	name6712	380376594438	1857
6713	name6713	380657655191	585
6714	name6714	380541621498	1390
6715	name6715	380108857519	922
6716	name6716	380646222265	1793
6717	name6717	380554518963	977
6718	name6718	38011321628	1722
6719	name6719	380256327179	1014
6720	name6720	380666018776	771
6721	name6721	380405665715	1649
6722	name6722	38088773589	551
6723	name6723	380882472710	1469
6724	name6724	38064720826	1022
6725	name6725	380977791893	673
6726	name6726	380261832049	1347
6727	name6727	380373943998	1973
6728	name6728	380380220352	29
6729	name6729	38070185750	992
6730	name6730	380692370286	847
6731	name6731	380892177003	1182
6732	name6732	380268329645	1682
6733	name6733	380828697523	6
6734	name6734	380600093464	735
6735	name6735	380509925175	1886
6736	name6736	38029987137	1638
6737	name6737	3807942759	1051
6738	name6738	380554722120	1697
6739	name6739	380634318642	1624
6740	name6740	380872035503	365
6741	name6741	380376372498	382
6742	name6742	380352452276	1039
6743	name6743	380949897533	1660
6744	name6744	380783275701	1539
6745	name6745	380580063686	1745
6746	name6746	38066954843	1796
6747	name6747	380499865730	1967
6748	name6748	380280627543	1600
6749	name6749	380205098201	1763
6750	name6750	380256889146	1073
6751	name6751	380709941919	981
6752	name6752	380127292370	256
6753	name6753	380162435939	517
6754	name6754	380381168864	1080
6755	name6755	380280434912	1041
6756	name6756	38091324174	271
6757	name6757	38036097907	804
6758	name6758	380623353739	1258
6759	name6759	380202954084	1597
6760	name6760	380872604899	997
6761	name6761	380623735959	1621
6762	name6762	380413992311	669
6763	name6763	380363522367	1505
6764	name6764	38030645459	1611
6765	name6765	380512378117	1882
6766	name6766	380524080112	289
6767	name6767	380579452631	1273
6768	name6768	380474779063	905
6769	name6769	380391028926	721
6770	name6770	380196719371	497
6771	name6771	380679467624	296
6772	name6772	380290185545	1786
6773	name6773	380641224648	452
6774	name6774	380103390831	362
6775	name6775	380712102816	1803
6776	name6776	380153917350	1253
6777	name6777	38067569741	971
6778	name6778	380124920859	673
6779	name6779	380283969786	1192
6780	name6780	380708947472	1828
6781	name6781	380949315645	1725
6782	name6782	380937318166	1789
6783	name6783	380755139070	905
6784	name6784	380203609773	564
6785	name6785	380693411969	1233
6786	name6786	380954359305	1255
6787	name6787	380812514802	345
6788	name6788	380739160533	1259
6789	name6789	380547015231	830
6790	name6790	380370441053	1097
6791	name6791	380203033168	1375
6792	name6792	380198189621	596
6793	name6793	380146657993	1300
6794	name6794	380340236140	969
6795	name6795	380926861490	1344
6796	name6796	380528008167	693
6797	name6797	380221263089	447
6798	name6798	380910656823	243
6799	name6799	380397169025	93
6800	name6800	380530819782	203
6801	name6801	380871660190	1666
6802	name6802	380323243881	699
6803	name6803	380288773090	1305
6804	name6804	380749452175	1193
6805	name6805	380380576805	634
6806	name6806	38072176992	884
6807	name6807	380484949169	1467
6808	name6808	380844818094	267
6809	name6809	38090209522	1978
6810	name6810	380428591526	1122
6811	name6811	380542470158	1402
6812	name6812	38028346855	1467
6813	name6813	380161035395	15
6814	name6814	380522856740	212
6815	name6815	380922672007	1455
6816	name6816	380456762966	1133
6817	name6817	380902724459	637
6818	name6818	380963116696	981
6819	name6819	380264819714	219
6820	name6820	380913294480	577
6821	name6821	380268713981	1753
6822	name6822	38014038010	1957
6823	name6823	380731683056	676
6824	name6824	380812303364	830
6825	name6825	380218679755	1032
6826	name6826	380670793345	1345
6827	name6827	380851064581	125
6828	name6828	380375201349	1054
6829	name6829	380181891144	1491
6830	name6830	380349406469	1036
6831	name6831	380866717370	531
6832	name6832	380364230027	1217
6833	name6833	380268991129	1434
6834	name6834	380138389204	1244
6835	name6835	380843935945	1785
6836	name6836	380735251441	1374
6837	name6837	380165452062	297
6838	name6838	380583932887	966
6839	name6839	380236014469	1432
6840	name6840	38017247622	1777
6841	name6841	380547798486	641
6842	name6842	380230722406	418
6843	name6843	380285281216	111
6844	name6844	380759022540	388
6845	name6845	380160262081	611
6846	name6846	380734789804	1232
6847	name6847	380124701130	1152
6848	name6848	380445020341	280
6849	name6849	380407066863	1680
6850	name6850	380378912087	1468
6851	name6851	380271878317	1467
6852	name6852	380392727484	1465
6853	name6853	3801886939	1682
6854	name6854	380533204672	179
6855	name6855	38016101457	1919
6856	name6856	380152446273	1564
6857	name6857	380184650849	1559
6858	name6858	380745213030	1543
6859	name6859	38030896629	1060
6860	name6860	380263071025	657
6861	name6861	380595887436	425
6862	name6862	380149530954	1709
6863	name6863	38080047727	46
6864	name6864	380129748666	906
6865	name6865	380684944808	508
6866	name6866	380144469769	56
6867	name6867	380495503845	150
6868	name6868	380613970586	1249
6869	name6869	380631017887	1259
6870	name6870	380383388996	648
6871	name6871	380902929551	1367
6872	name6872	380324855050	1771
6873	name6873	38050967759	1905
6874	name6874	380114920856	1281
6875	name6875	380557407060	259
6876	name6876	380811397028	145
6877	name6877	380147009268	549
6878	name6878	380526548795	1014
6879	name6879	380371132971	1643
6880	name6880	380946667962	32
6881	name6881	380567708373	1413
6882	name6882	380700029322	647
6883	name6883	380900655506	1161
6884	name6884	380911849322	432
6885	name6885	380790219530	256
6886	name6886	380978297080	1458
6887	name6887	380987685156	1338
6888	name6888	380804213859	1223
6889	name6889	380718782079	1117
6890	name6890	380328210667	1306
6891	name6891	380579821368	1244
6892	name6892	38060484885	1969
6893	name6893	380888285105	1781
6894	name6894	380721351463	686
6895	name6895	380301334440	1489
6896	name6896	380485289585	1301
6897	name6897	380881928845	359
6898	name6898	380658775026	618
6899	name6899	380295714213	809
6900	name6900	380661685087	179
6901	name6901	380554009213	1624
6902	name6902	380950954714	756
6903	name6903	380557959505	1959
6904	name6904	380183108617	610
6905	name6905	380393606760	1560
6906	name6906	380400095485	622
6907	name6907	380643073605	1643
6908	name6908	380347843318	1765
6909	name6909	380889074114	1593
6910	name6910	380490602520	1513
6911	name6911	380146115557	198
6912	name6912	380390582075	1698
6913	name6913	380338913111	317
6914	name6914	380899959810	1158
6915	name6915	380457223549	1614
6916	name6916	380761420744	514
6917	name6917	380999766036	800
6918	name6918	380124928431	769
6919	name6919	380901689435	1877
6920	name6920	380499252327	1081
6921	name6921	380330291200	1727
6922	name6922	380758258184	581
6923	name6923	380770461472	355
6924	name6924	38060822766	988
6925	name6925	380959753057	487
6926	name6926	380633589957	1084
6927	name6927	380861049622	1935
6928	name6928	380563529828	1541
6929	name6929	380726957724	1811
6930	name6930	380818604851	1333
6931	name6931	380803993506	1731
6932	name6932	380862406946	544
6933	name6933	38059057791	1439
6934	name6934	380119570150	1916
6935	name6935	380607741226	1160
6936	name6936	380120766637	1973
6937	name6937	380216712081	646
6938	name6938	380658186875	646
6939	name6939	380867516903	151
6940	name6940	38038941017	1043
6941	name6941	380663718281	1154
6942	name6942	380191129277	278
6943	name6943	380944690022	1491
6944	name6944	380993832866	1483
6945	name6945	380432765565	1536
6946	name6946	380114078554	1118
6947	name6947	38016089475	128
6948	name6948	380409087389	1981
6949	name6949	380777232072	1219
6950	name6950	380678711514	207
6951	name6951	380242043753	744
6952	name6952	380445245145	443
6953	name6953	380310454923	1757
6954	name6954	380459455306	72
6955	name6955	380822715020	538
6956	name6956	380872998383	1770
6957	name6957	380942729998	1377
6958	name6958	380846431912	1434
6959	name6959	380460192894	1441
6960	name6960	380900528978	1525
6961	name6961	380202181360	719
6962	name6962	380574586192	1672
6963	name6963	380665112738	1313
6964	name6964	380975864231	1765
6965	name6965	380453927780	1457
6966	name6966	380492339192	269
6967	name6967	380528177213	612
6968	name6968	380713379688	571
6969	name6969	380363642614	1790
6970	name6970	380845179538	1639
6971	name6971	380496427731	1671
6972	name6972	380214263691	1815
6973	name6973	380953255091	616
6974	name6974	380922470222	280
6975	name6975	380469598468	1392
6976	name6976	380106319472	1062
6977	name6977	380300402283	404
6978	name6978	380564601424	1679
6979	name6979	380172178720	1439
6980	name6980	380639424952	737
6981	name6981	380387163304	845
6982	name6982	380530782387	833
6983	name6983	380411323663	557
6984	name6984	380487930868	1561
6985	name6985	380621067164	306
6986	name6986	380316682136	77
6987	name6987	38039528193	1603
6988	name6988	380457012305	1641
6989	name6989	380961464717	1066
6990	name6990	380620370319	377
6991	name6991	380384677365	1819
6992	name6992	380821379791	1197
6993	name6993	380481819916	1026
6994	name6994	380172270972	1772
6995	name6995	380659999239	1632
6996	name6996	380374811869	810
6997	name6997	380193657596	336
6998	name6998	380160943804	1289
6999	name6999	380634485620	891
7000	name7000	380598824069	482
7001	name7001	380426780926	1870
7002	name7002	380545395130	1057
7003	name7003	380233052415	1187
7004	name7004	380407697469	802
7005	name7005	380394542935	1789
7006	name7006	380393363988	779
7007	name7007	380988248075	107
7008	name7008	380262436242	361
7009	name7009	380429649806	1801
7010	name7010	380223823684	824
7011	name7011	380515475016	1000
7012	name7012	380713515600	300
7013	name7013	380928040420	657
7014	name7014	380564105314	789
7015	name7015	380705878991	225
7016	name7016	380605152209	1144
7017	name7017	380224303546	1487
7018	name7018	380414032999	346
7019	name7019	380790324233	978
7020	name7020	380804036184	1099
7021	name7021	380395962622	1245
7022	name7022	380600830924	900
7023	name7023	380129871878	1572
7024	name7024	380782890085	63
7025	name7025	380575504863	1492
7026	name7026	380622015240	33
7027	name7027	380729204681	18
7028	name7028	380151873683	1199
7029	name7029	380473608005	460
7030	name7030	380224839592	1884
7031	name7031	380386406551	1519
7032	name7032	38074866487	282
7033	name7033	380985600885	1855
7034	name7034	380829066918	958
7035	name7035	380812949915	904
7036	name7036	380797290897	1601
7037	name7037	380482384929	627
7038	name7038	380836962559	1088
7039	name7039	380349831464	1394
7040	name7040	380439770244	1146
7041	name7041	380459068864	622
7042	name7042	380715639766	1562
7043	name7043	380328316539	27
7044	name7044	38048055637	949
7045	name7045	380927280353	1305
7046	name7046	380510558943	436
7047	name7047	38076118257	1590
7048	name7048	380232936360	1130
7049	name7049	380353992156	906
7050	name7050	380636531530	1541
7051	name7051	380842088648	929
7052	name7052	380761028235	1141
7053	name7053	380149838517	1916
7054	name7054	380578578723	1912
7055	name7055	380935299487	679
7056	name7056	380173295869	899
7057	name7057	38038026298	1078
7058	name7058	380657139570	955
7059	name7059	380469029339	1285
7060	name7060	380995915687	1124
7061	name7061	380951416470	1580
7062	name7062	380611232604	603
7063	name7063	380728564610	356
7064	name7064	380778760014	1488
7065	name7065	38036141543	1092
7066	name7066	380223195486	1059
7067	name7067	380196405150	909
7068	name7068	38039636040	973
7069	name7069	380526834828	650
7070	name7070	38046628381	1362
7071	name7071	380162603309	198
7072	name7072	38024830026	1775
7073	name7073	380608404812	802
7074	name7074	380955344297	528
7075	name7075	3805348295	559
7076	name7076	380913994422	465
7077	name7077	380315143747	969
7078	name7078	380358803737	1302
7079	name7079	380171949349	240
7080	name7080	380923606569	976
7081	name7081	380228290539	1001
7082	name7082	380635127006	1024
7083	name7083	380538110666	1970
7084	name7084	380499879962	557
7085	name7085	380422075643	1089
7086	name7086	380425905708	1242
7087	name7087	380729492197	1282
7088	name7088	38069005733	1606
7089	name7089	380245486505	809
7090	name7090	380680370709	1398
7091	name7091	380600302612	1016
7092	name7092	380337950626	1267
7093	name7093	38097857750	1488
7094	name7094	380695837389	1598
7095	name7095	380965987701	1215
7096	name7096	380948871277	1649
7097	name7097	380111887256	1464
7098	name7098	380295685704	1273
7099	name7099	380858498584	167
7100	name7100	380998780838	1867
7101	name7101	380364409176	589
7102	name7102	380837512738	1795
7103	name7103	380631313196	60
7104	name7104	380985805627	1932
7105	name7105	380925444319	1493
7106	name7106	38027714373	584
7107	name7107	380696130767	664
7108	name7108	380654704533	1123
7109	name7109	380277548681	1213
7110	name7110	380812930658	707
7111	name7111	380173376450	218
7112	name7112	380835924956	1128
7113	name7113	380703768956	1303
7114	name7114	380654971940	1210
7115	name7115	380324380940	546
7116	name7116	380131094139	283
7117	name7117	380482690953	906
7118	name7118	380708599859	1587
7119	name7119	380985001953	170
7120	name7120	380448376480	1355
7121	name7121	380737859774	214
7122	name7122	380198564483	347
7123	name7123	380909819791	1645
7124	name7124	380266573764	1533
7125	name7125	380676610738	1920
7126	name7126	380224416307	1186
7127	name7127	380674782077	365
7128	name7128	380768338911	1941
7129	name7129	380596054063	1089
7130	name7130	380352764936	363
7131	name7131	380676832049	1235
7132	name7132	380869672705	881
7133	name7133	380323205722	1530
7134	name7134	380433915369	663
7135	name7135	380554794734	1462
7136	name7136	380752359836	1116
7137	name7137	380849278309	910
7138	name7138	380803373086	1877
7139	name7139	380670404808	1414
7140	name7140	380923683183	1340
7141	name7141	380487790641	108
7142	name7142	380301891098	1914
7143	name7143	380906253207	1099
7144	name7144	380557266592	284
7145	name7145	380370899884	1980
7146	name7146	380726980916	1198
7147	name7147	380123645506	205
7148	name7148	380961994038	388
7149	name7149	380952306654	339
7150	name7150	380473695389	909
7151	name7151	380983567873	1473
7152	name7152	380362520010	1281
7153	name7153	380127958462	787
7154	name7154	380245709944	1782
7155	name7155	380164435075	874
7156	name7156	380712929930	1737
7157	name7157	380852931566	631
7158	name7158	38035100077	1280
7159	name7159	380147963636	10
7160	name7160	380290763249	234
7161	name7161	380725282316	1586
7162	name7162	380749682509	403
7163	name7163	380916910832	1548
7164	name7164	380196133389	1937
7165	name7165	380941928073	331
7166	name7166	380282425336	1396
7167	name7167	380983710921	171
7168	name7168	380302450700	69
7169	name7169	380589971152	1224
7170	name7170	380793434297	1203
7171	name7171	380906012779	1190
7172	name7172	380441784887	699
7173	name7173	380217168738	279
7174	name7174	38039708062	1570
7175	name7175	380743192158	1495
7176	name7176	380757824814	465
7177	name7177	380590953766	109
7178	name7178	380722670678	1525
7179	name7179	38057115984	808
7180	name7180	380899463906	584
7181	name7181	38085627981	1491
7182	name7182	380713004240	951
7183	name7183	380991439733	1303
7184	name7184	380563141459	281
7185	name7185	38076805309	915
7186	name7186	380294214769	1297
7187	name7187	380497810837	1192
7188	name7188	380405211806	783
7189	name7189	380431232941	344
7190	name7190	38081489594	1706
7191	name7191	380876445473	1033
7192	name7192	380447927278	509
7193	name7193	380784735553	1954
7194	name7194	380314690418	504
7195	name7195	380815182001	1965
7196	name7196	380283365071	1379
7197	name7197	380942816604	225
7198	name7198	380790843143	1251
7199	name7199	38038455749	1854
7200	name7200	380956185286	253
7201	name7201	380824636099	1184
7202	name7202	380742428664	1004
7203	name7203	380399475947	1309
7204	name7204	380773985378	74
7205	name7205	380824518178	1467
7206	name7206	380636468594	1543
7207	name7207	380789630403	1492
7208	name7208	380176847803	638
7209	name7209	380974301018	346
7210	name7210	380772281468	1791
7211	name7211	38013836033	390
7212	name7212	380497220695	1277
7213	name7213	380558827238	41
7214	name7214	3802428822	1056
7215	name7215	380844857709	1916
7216	name7216	38087408578	763
7217	name7217	380835412000	127
7218	name7218	380154471913	1440
7219	name7219	380769823147	273
7220	name7220	38092689466	1533
7221	name7221	380721569750	342
7222	name7222	380256538977	1200
7223	name7223	380565181678	1007
7224	name7224	380639548828	1084
7225	name7225	380994605627	195
7226	name7226	380386305297	1704
7227	name7227	380259728986	1199
7228	name7228	380504987717	1996
7229	name7229	380958485617	1024
7230	name7230	380492884107	1811
7231	name7231	380387212071	613
7232	name7232	380376704691	162
7233	name7233	380209916974	665
7234	name7234	380459510914	368
7235	name7235	380699228124	1364
7236	name7236	380625676772	11
7237	name7237	380124648987	1704
7238	name7238	380760097467	1187
7239	name7239	380855051534	786
7240	name7240	380440906405	1672
7241	name7241	380800120276	1855
7242	name7242	380546179611	905
7243	name7243	380567704061	1297
7244	name7244	380147617041	1684
7245	name7245	380260834077	388
7246	name7246	380817056014	360
7247	name7247	380445688358	1609
7248	name7248	380299852372	1740
7249	name7249	380852963984	1089
7250	name7250	380362707511	1016
7251	name7251	380398623533	913
7252	name7252	380539271173	1434
7253	name7253	380535030898	1757
7254	name7254	380517219881	422
7255	name7255	380184467385	546
7256	name7256	380405064028	1243
7257	name7257	380588024083	691
7258	name7258	380963851625	1914
7259	name7259	38068622409	1451
7260	name7260	3804607688	1931
7261	name7261	380512666748	1331
7262	name7262	380138662977	997
7263	name7263	380884165707	193
7264	name7264	380278100298	1754
7265	name7265	380210876115	721
7266	name7266	380387948373	636
7267	name7267	380161505562	1851
7268	name7268	380158493987	892
7269	name7269	380135690976	108
7270	name7270	380348912108	108
7271	name7271	380709363802	695
7272	name7272	380214193201	1559
7273	name7273	380877512899	1160
7274	name7274	380899541357	984
7275	name7275	380742152175	1271
7276	name7276	380917975489	876
7277	name7277	380588532033	1327
7278	name7278	38022032400	58
7279	name7279	380667216855	1477
7280	name7280	380891298983	288
7281	name7281	380951411534	1037
7282	name7282	380557110021	1737
7283	name7283	380165357005	328
7284	name7284	380786595415	747
7285	name7285	380808037411	1930
7286	name7286	380809967052	1912
7287	name7287	380556395068	687
7288	name7288	380677441993	1712
7289	name7289	380580379785	1253
7290	name7290	380471286192	111
7291	name7291	380365927164	1244
7292	name7292	380291917586	1581
7293	name7293	380754858625	1300
7294	name7294	380210959801	411
7295	name7295	380867875811	888
7296	name7296	380340361292	606
7297	name7297	380746288559	1332
7298	name7298	380412890738	1296
7299	name7299	380428893092	576
7300	name7300	380825672405	1711
7301	name7301	380705344968	1144
7302	name7302	380874958782	448
7303	name7303	380124434542	799
7304	name7304	380180852831	1563
7305	name7305	380348023723	1845
7306	name7306	380380317966	1123
7307	name7307	380122481390	1536
7308	name7308	380531453977	111
7309	name7309	380745861305	1138
7310	name7310	38039220773	51
7311	name7311	380170095482	379
7312	name7312	380334832826	1516
7313	name7313	380566467064	739
7314	name7314	380342240635	211
7315	name7315	380491536316	170
7316	name7316	380186654196	1080
7317	name7317	380355546773	768
7318	name7318	380296905133	255
7319	name7319	380976467094	162
7320	name7320	380119030781	409
7321	name7321	380730042790	1604
7322	name7322	380634303815	126
7323	name7323	380555365749	1229
7324	name7324	380233327365	1859
7325	name7325	380448882777	1656
7326	name7326	380367267047	763
7327	name7327	380619801477	1248
7328	name7328	380831353414	473
7329	name7329	380150342489	1714
7330	name7330	380407421103	1513
7331	name7331	380631526521	524
7332	name7332	380226936788	135
7333	name7333	380516040262	1304
7334	name7334	380158130023	1792
7335	name7335	380200780851	1718
7336	name7336	380359343567	1717
7337	name7337	380929568061	1722
7338	name7338	380100482048	1171
7339	name7339	380815853079	85
7340	name7340	380992442560	1784
7341	name7341	380546827791	1710
7342	name7342	380189637870	874
7343	name7343	380628448363	1712
7344	name7344	380298790972	786
7345	name7345	380555008693	394
7346	name7346	380141724919	1488
7347	name7347	380689072486	757
7348	name7348	380703947582	1338
7349	name7349	380253163531	1300
7350	name7350	380382856721	873
7351	name7351	380370364519	981
7352	name7352	38039434582	201
7353	name7353	380190494480	1725
7354	name7354	380970724293	33
7355	name7355	380391637841	629
7356	name7356	380937126677	288
7357	name7357	380715345793	1680
7358	name7358	380307617973	1372
7359	name7359	380482984605	1075
7360	name7360	380435828973	46
7361	name7361	380950745913	1343
7362	name7362	38016888235	1353
7363	name7363	380810951271	546
7364	name7364	380482921450	330
7365	name7365	380968998359	1407
7366	name7366	380231063319	92
7367	name7367	380479416509	763
7368	name7368	380248830133	367
7369	name7369	380101764957	140
7370	name7370	380470555150	928
7371	name7371	380758936684	634
7372	name7372	380356491390	1021
7373	name7373	380222418371	821
7374	name7374	380711673371	294
7375	name7375	380866132450	877
7376	name7376	380516788784	1127
7377	name7377	38068890058	1813
7378	name7378	380539225721	1297
7379	name7379	380682961564	1247
7380	name7380	380987169485	1167
7381	name7381	380348156133	1472
7382	name7382	38043131674	1334
7383	name7383	380485872139	1457
7384	name7384	380395422174	553
7385	name7385	380353863935	685
7386	name7386	380394160628	203
7387	name7387	380649396134	131
7388	name7388	38033178481	250
7389	name7389	38028007728	621
7390	name7390	380568196242	116
7391	name7391	380140889007	459
7392	name7392	380791468108	794
7393	name7393	380963239613	893
7394	name7394	380181520098	1809
7395	name7395	38066637275	1453
7396	name7396	380629121666	599
7397	name7397	380447202932	1166
7398	name7398	380754821039	146
7399	name7399	380338855151	1789
7400	name7400	380307607780	1363
7401	name7401	380732676685	813
7402	name7402	380297416593	538
7403	name7403	380873213667	1897
7404	name7404	380144769945	1557
7405	name7405	380731422442	242
7406	name7406	380955090142	1513
7407	name7407	380403154758	1897
7408	name7408	380614776801	1259
7409	name7409	380995156381	1151
7410	name7410	380607697317	823
7411	name7411	380706627649	902
7412	name7412	380710424710	1976
7413	name7413	380399380028	1483
7414	name7414	380952097668	573
7415	name7415	380619959787	338
7416	name7416	380372866611	1947
7417	name7417	380385870562	1088
7418	name7418	380430968484	177
7419	name7419	380889878410	1517
7420	name7420	380847143893	1832
7421	name7421	380964056763	503
7422	name7422	380740726797	711
7423	name7423	380556395773	1323
7424	name7424	380231951293	1899
7425	name7425	380202516330	2000
7426	name7426	380897318631	1617
7427	name7427	380925150116	1951
7428	name7428	380529376342	502
7429	name7429	380457276042	1207
7430	name7430	380485351615	1041
7431	name7431	380177269693	1319
7432	name7432	380263557606	750
7433	name7433	380646954502	712
7434	name7434	380745393559	12
7435	name7435	380567937716	1344
7436	name7436	380903057508	1533
7437	name7437	38075159695	1385
7438	name7438	380250805731	728
7439	name7439	380912245855	1673
7440	name7440	380395128874	407
7441	name7441	380462666781	1527
7442	name7442	380726920813	1739
7443	name7443	380469922158	1388
7444	name7444	380683977243	947
7445	name7445	380346107011	888
7446	name7446	380912532002	1217
7447	name7447	380381019881	565
7448	name7448	38050716177	1148
7449	name7449	380952172971	867
7450	name7450	380550476898	327
7451	name7451	380825195876	183
7452	name7452	380969238295	843
7453	name7453	380208290111	1885
7454	name7454	380617647975	1190
7455	name7455	38070954883	1428
7456	name7456	380237063100	148
7457	name7457	380109546202	724
7458	name7458	380715235771	1577
7459	name7459	380431978422	1901
7460	name7460	380808881927	681
7461	name7461	380150260616	416
7462	name7462	380290731979	256
7463	name7463	380879808009	1107
7464	name7464	380756633129	1905
7465	name7465	380635390653	1549
7466	name7466	380660632434	177
7467	name7467	38090751202	788
7468	name7468	380405264893	112
7469	name7469	380116114156	316
7470	name7470	380956455108	1723
7471	name7471	38085589595	1673
7472	name7472	38077761551	1051
7473	name7473	380915122841	278
7474	name7474	380389320798	325
7475	name7475	380299779341	1422
7476	name7476	380234529791	89
7477	name7477	380205760818	1292
7478	name7478	38085754657	1169
7479	name7479	380986261227	1307
7480	name7480	380646996580	259
7481	name7481	380636124102	1318
7482	name7482	380108500249	641
7483	name7483	380780277743	1355
7484	name7484	380717518679	403
7485	name7485	380311201180	326
7486	name7486	380763064878	355
7487	name7487	380163893062	229
7488	name7488	38089827210	1458
7489	name7489	380595308459	1849
7490	name7490	380478630729	1493
7491	name7491	380466017506	1102
7492	name7492	380306737587	618
7493	name7493	380721309160	426
7494	name7494	380219191237	1408
7495	name7495	38071064846	760
7496	name7496	380813378110	1050
7497	name7497	380405876619	1444
7498	name7498	380758751391	1105
7499	name7499	380225957881	1917
7500	name7500	3801487427	902
7501	name7501	380400474464	1846
7502	name7502	380177734661	1648
7503	name7503	380411709105	847
7504	name7504	380998284708	2000
7505	name7505	380250503419	149
7506	name7506	380494063237	1111
7507	name7507	380753528048	1669
7508	name7508	380355034578	1691
7509	name7509	380100558972	946
7510	name7510	380522542600	984
7511	name7511	380594259063	1980
7512	name7512	380846844402	708
7513	name7513	380547932602	1691
7514	name7514	380404131463	134
7515	name7515	380752472052	1398
7516	name7516	380995702262	1118
7517	name7517	380700972975	1058
7518	name7518	3809483994	466
7519	name7519	380371877898	728
7520	name7520	380240672669	240
7521	name7521	380400929356	106
7522	name7522	380799008517	747
7523	name7523	380776709263	940
7524	name7524	380548021612	960
7525	name7525	380188278738	1715
7526	name7526	380117915606	1119
7527	name7527	380652710008	158
7528	name7528	380653475624	1761
7529	name7529	380975767619	19
7530	name7530	380175774227	439
7531	name7531	380840451850	249
7532	name7532	380610589175	1680
7533	name7533	380484580408	1180
7534	name7534	380665527445	6
7535	name7535	380362509022	1469
7536	name7536	380263183438	1809
7537	name7537	380526905715	782
7538	name7538	380629434629	445
7539	name7539	380204859753	1033
7540	name7540	380124035379	835
7541	name7541	380913060878	104
7542	name7542	380494825344	1286
7543	name7543	380172661360	960
7544	name7544	380712571793	495
7545	name7545	380625230453	770
7546	name7546	380349816482	1558
7547	name7547	380568802758	188
7548	name7548	38045516329	310
7549	name7549	380449377761	320
7550	name7550	380380329064	161
7551	name7551	380868538200	553
7552	name7552	380878631401	4
7553	name7553	380274226367	1221
7554	name7554	380770039721	1096
7555	name7555	380243838309	742
7556	name7556	380735399087	391
7557	name7557	38049232184	1583
7558	name7558	380302634596	1915
7559	name7559	380126272773	682
7560	name7560	380328328384	321
7561	name7561	3805653366	966
7562	name7562	380882345457	693
7563	name7563	380777302755	1136
7564	name7564	380857318421	395
7565	name7565	380265275704	150
7566	name7566	380388809667	214
7567	name7567	380490473980	206
7568	name7568	380862031185	735
7569	name7569	380734792587	1399
7570	name7570	380843502406	501
7571	name7571	380902452812	311
7572	name7572	380894540817	1559
7573	name7573	38070622171	515
7574	name7574	380128161751	555
7575	name7575	380401051373	1864
7576	name7576	380675762421	1323
7577	name7577	380125046846	1502
7578	name7578	380254709976	1072
7579	name7579	380640883059	1447
7580	name7580	380593579344	232
7581	name7581	380291582968	786
7582	name7582	380938238200	327
7583	name7583	380204240610	1289
7584	name7584	380209566964	1056
7585	name7585	380462658622	1182
7586	name7586	380419861528	1177
7587	name7587	380859984373	936
7588	name7588	380760260806	543
7589	name7589	380318845581	754
7590	name7590	380777988436	838
7591	name7591	380201082569	1856
7592	name7592	380691670310	251
7593	name7593	380574535065	1759
7594	name7594	380461226645	1623
7595	name7595	380596997242	1442
7596	name7596	380853954397	1474
7597	name7597	380814167036	1085
7598	name7598	380283338437	610
7599	name7599	380936023345	1343
7600	name7600	380736734127	1109
7601	name7601	380135646111	27
7602	name7602	380403056578	1876
7603	name7603	3801252989	333
7604	name7604	380752428901	567
7605	name7605	380958755308	879
7606	name7606	380834998090	247
7607	name7607	380108966434	1939
7608	name7608	380111398665	788
7609	name7609	380807188314	604
7610	name7610	380221312303	1295
7611	name7611	380817484977	844
7612	name7612	380892813300	163
7613	name7613	380399863352	1221
7614	name7614	38059142258	1571
7615	name7615	380706022463	735
7616	name7616	380941434564	1604
7617	name7617	38022683598	334
7618	name7618	380401659999	1660
7619	name7619	380935630943	318
7620	name7620	380733393441	219
7621	name7621	380443721974	985
7622	name7622	380508676762	1763
7623	name7623	380187365898	1462
7624	name7624	380202209357	1140
7625	name7625	380896408665	1990
7626	name7626	380748073997	276
7627	name7627	380666336664	512
7628	name7628	380126485257	1140
7629	name7629	380215789333	678
7630	name7630	380676120761	443
7631	name7631	380845022202	140
7632	name7632	380307806812	1699
7633	name7633	380667027398	682
7634	name7634	38040832639	361
7635	name7635	38066410218	1981
7636	name7636	380744382817	478
7637	name7637	380463396418	175
7638	name7638	38048707346	1377
7639	name7639	380749073008	854
7640	name7640	380994020069	1279
7641	name7641	380309025101	1960
7642	name7642	380655387725	1474
7643	name7643	380834765185	804
7644	name7644	380158387322	1486
7645	name7645	380411219401	1205
7646	name7646	380632124454	942
7647	name7647	38037680903	993
7648	name7648	380476572314	1866
7649	name7649	380445520056	810
7650	name7650	380422533598	1955
7651	name7651	38026930156	1382
7652	name7652	380535180955	1137
7653	name7653	380596611347	1911
7654	name7654	380241388545	1019
7655	name7655	380674499508	1069
7656	name7656	38058301579	1510
7657	name7657	380478254366	1964
7658	name7658	380835497196	998
7659	name7659	38094991036	772
7660	name7660	380185317313	370
7661	name7661	380909677307	176
7662	name7662	380885663782	1767
7663	name7663	380196448589	1542
7664	name7664	380957679043	671
7665	name7665	380914042659	462
7666	name7666	380191015717	394
7667	name7667	380549871625	1927
7668	name7668	380375357972	1083
7669	name7669	380142078394	1771
7670	name7670	380758409772	806
7671	name7671	380405497985	1350
7672	name7672	380135913034	623
7673	name7673	380211683795	924
7674	name7674	380389163867	735
7675	name7675	380864147090	855
7676	name7676	380898192525	600
7677	name7677	380208901993	353
7678	name7678	380685061234	396
7679	name7679	380420018237	1969
7680	name7680	380311023741	179
7681	name7681	38099317236	1596
7682	name7682	380910637966	902
7683	name7683	38086123941	853
7684	name7684	380885337267	194
7685	name7685	380849536840	47
7686	name7686	380377513274	771
7687	name7687	380994419822	753
7688	name7688	380164656461	1832
7689	name7689	380219432362	1800
7690	name7690	380940399490	1699
7691	name7691	38019709240	81
7692	name7692	380240515505	627
7693	name7693	38036343232	1360
7694	name7694	380498006279	1092
7695	name7695	380540216988	344
7696	name7696	380971034013	883
7697	name7697	380147215519	119
7698	name7698	380713025971	1956
7699	name7699	380739630792	789
7700	name7700	380875580279	1374
7701	name7701	380524010241	1324
7702	name7702	380344574701	1751
7703	name7703	380837316235	337
7704	name7704	380507331767	486
7705	name7705	380297646201	193
7706	name7706	380917812436	1912
7707	name7707	380657859164	363
7708	name7708	380637848111	900
7709	name7709	380957843308	286
7710	name7710	380936044392	421
7711	name7711	38011243554	1355
7712	name7712	380140891547	1664
7713	name7713	380987730289	1729
7714	name7714	380420611944	1478
7715	name7715	380334621413	156
7716	name7716	380432170174	216
7717	name7717	380725827221	1956
7718	name7718	380396633388	1776
7719	name7719	380970188606	997
7720	name7720	380431073482	1392
7721	name7721	380952484852	673
7722	name7722	380634599033	1062
7723	name7723	380736185480	637
7724	name7724	380561575136	67
7725	name7725	380287160980	1835
7726	name7726	380818531405	1633
7727	name7727	380145158059	1789
7728	name7728	380432177687	1460
7729	name7729	380926765580	1716
7730	name7730	380603585245	876
7731	name7731	380681633274	625
7732	name7732	380737075705	815
7733	name7733	38039062670	502
7734	name7734	380215403597	49
7735	name7735	38057194401	1937
7736	name7736	380138750479	1340
7737	name7737	380499754473	1536
7738	name7738	380249211178	373
7739	name7739	380792129520	277
7740	name7740	380540238727	94
7741	name7741	380893993981	1224
7742	name7742	380770584443	851
7743	name7743	380947530580	814
7744	name7744	380175722622	823
7745	name7745	380324901972	1637
7746	name7746	380277284852	262
7747	name7747	380358732512	97
7748	name7748	380361376508	1110
7749	name7749	380631055606	1234
7750	name7750	380330797956	1517
7751	name7751	380449714893	656
7752	name7752	380903209944	1383
7753	name7753	380925344287	393
7754	name7754	380938731467	1977
7755	name7755	380178581987	1184
7756	name7756	380981724850	1260
7757	name7757	380758156302	1402
7758	name7758	380999560689	870
7759	name7759	38057154623	206
7760	name7760	380579439441	687
7761	name7761	380773293238	634
7762	name7762	380197064965	1099
7763	name7763	380574338372	666
7764	name7764	38019731058	164
7765	name7765	38075659946	1667
7766	name7766	380743994366	843
7767	name7767	380945190954	1963
7768	name7768	380105146829	386
7769	name7769	38041622486	1976
7770	name7770	380866987094	1759
7771	name7771	380508036745	1120
7772	name7772	380419583067	1225
7773	name7773	380367566513	1190
7774	name7774	380144595238	554
7775	name7775	380543731793	1885
7776	name7776	380158924298	667
7777	name7777	380426850585	453
7778	name7778	380957665012	891
7779	name7779	380928057901	1329
7780	name7780	38024368563	579
7781	name7781	380662884433	1941
7782	name7782	380789577609	1695
7783	name7783	380124633163	1429
7784	name7784	380225380041	1242
7785	name7785	380724947872	112
7786	name7786	380779433767	981
7787	name7787	380246707976	568
7788	name7788	38046760855	845
7789	name7789	380307703364	1853
7790	name7790	380343729273	43
7791	name7791	380567433905	1262
7792	name7792	380116603943	1822
7793	name7793	380404870745	1827
7794	name7794	380354115293	1963
7795	name7795	380135937145	1149
7796	name7796	380926886028	76
7797	name7797	380667577981	367
7798	name7798	3806286912	557
7799	name7799	380397712486	848
7800	name7800	38092316626	489
7801	name7801	380269453463	53
7802	name7802	380306840901	1007
7803	name7803	380650016980	359
7804	name7804	380650033727	1887
7805	name7805	380640184929	720
7806	name7806	380913159834	1582
7807	name7807	380154248784	953
7808	name7808	380595211863	433
7809	name7809	380419264161	1252
7810	name7810	380711209525	1837
7811	name7811	38036535103	250
7812	name7812	38086131749	632
7813	name7813	380299816676	1467
7814	name7814	38035900723	1203
7815	name7815	380134337761	1182
7816	name7816	380935385183	691
7817	name7817	380142258321	23
7818	name7818	380309809323	1452
7819	name7819	380480854845	523
7820	name7820	380308412408	739
7821	name7821	380918127528	1812
7822	name7822	380283142409	1150
7823	name7823	380591016014	36
7824	name7824	380981374291	815
7825	name7825	38040539525	1152
7826	name7826	380138575525	433
7827	name7827	380444226679	479
7828	name7828	380150456478	1092
7829	name7829	380309648682	1459
7830	name7830	380819789941	156
7831	name7831	380511626262	236
7832	name7832	38045219773	322
7833	name7833	380675263857	1936
7834	name7834	380846152748	149
7835	name7835	380202027249	497
7836	name7836	380468808306	1304
7837	name7837	380935940688	390
7838	name7838	38085077614	226
7839	name7839	380194058867	141
7840	name7840	380685087321	1991
7841	name7841	380261700906	1227
7842	name7842	380918375294	1662
7843	name7843	380666140897	639
7844	name7844	380692613517	207
7845	name7845	380468853321	1648
7846	name7846	380612670851	1005
7847	name7847	380955173571	1240
7848	name7848	38091375565	625
7849	name7849	380478690855	943
7850	name7850	380593174280	925
7851	name7851	380584287639	395
7852	name7852	380262238540	1831
7853	name7853	380561214386	16
7854	name7854	380534313203	145
7855	name7855	380455318683	58
7856	name7856	38070866395	632
7857	name7857	380270213737	106
7858	name7858	380482665742	893
7859	name7859	380749140607	1659
7860	name7860	380485588988	1137
7861	name7861	380402370546	400
7862	name7862	380583089021	1753
7863	name7863	380303529018	214
7864	name7864	380398357466	1240
7865	name7865	380611513473	1263
7866	name7866	380806869176	1132
7867	name7867	380921365040	704
7868	name7868	380173851762	969
7869	name7869	380246354835	1479
7870	name7870	380503192658	1854
7871	name7871	380819897940	1011
7872	name7872	380466349397	1476
7873	name7873	380588195888	1772
7874	name7874	380687451303	867
7875	name7875	380773249960	84
7876	name7876	380157643524	603
7877	name7877	380492057087	257
7878	name7878	38020165401	789
7879	name7879	38074782943	599
7880	name7880	380730742994	1536
7881	name7881	380793946457	428
7882	name7882	380150085129	1731
7883	name7883	380293392747	474
7884	name7884	380430056035	99
7885	name7885	38067625043	1657
7886	name7886	380928881611	421
7887	name7887	380598918256	855
7888	name7888	380424134613	1732
7889	name7889	380990990093	1788
7890	name7890	380340459709	759
7891	name7891	380757935874	1133
7892	name7892	380214846642	1486
7893	name7893	380825425504	337
7894	name7894	380416135885	783
7895	name7895	380464172012	1270
7896	name7896	380388180638	1601
7897	name7897	380197141845	523
7898	name7898	380971671331	278
7899	name7899	380570144136	478
7900	name7900	380716030013	880
7901	name7901	380389246418	1749
7902	name7902	380450503356	1052
7903	name7903	380771599598	930
7904	name7904	380662634804	1170
7905	name7905	380864273975	231
7906	name7906	380189672139	1488
7907	name7907	380997649760	1685
7908	name7908	380669385042	1008
7909	name7909	380412022394	759
7910	name7910	380944215572	796
7911	name7911	380951608865	1698
7912	name7912	380661044957	1518
7913	name7913	380595251373	920
7914	name7914	380868647539	526
7915	name7915	38095481863	1279
7916	name7916	38086898661	890
7917	name7917	380500217650	934
7918	name7918	380420114680	1272
7919	name7919	380680466920	1694
7920	name7920	380361728638	116
7921	name7921	380909863916	1303
7922	name7922	380829639029	1855
7923	name7923	380893035755	729
7924	name7924	380761926073	1595
7925	name7925	380140102018	707
7926	name7926	380101318992	1066
7927	name7927	380648042318	744
7928	name7928	380947529663	1211
7929	name7929	380915010868	1120
7930	name7930	380613424428	74
7931	name7931	380244426690	1697
7932	name7932	380185854793	87
7933	name7933	380821507138	1010
7934	name7934	380682053286	757
7935	name7935	380873590496	1853
7936	name7936	380738990745	827
7937	name7937	380360369027	193
7938	name7938	380232612768	1048
7939	name7939	380594211697	1603
7940	name7940	380516317635	1293
7941	name7941	380196251583	745
7942	name7942	380535167534	43
7943	name7943	380759554387	564
7944	name7944	38082959947	99
7945	name7945	380468002862	984
7946	name7946	380778106449	915
7947	name7947	380294252187	1891
7948	name7948	380132507644	260
7949	name7949	380531275188	1416
7950	name7950	380765188044	895
7951	name7951	380597766196	482
7952	name7952	38082281626	678
7953	name7953	380112851462	1443
7954	name7954	380861528541	233
7955	name7955	38022529122	929
7956	name7956	380114905749	1695
7957	name7957	380920624430	404
7958	name7958	380325315331	475
7959	name7959	380798100379	598
7960	name7960	380682105295	361
7961	name7961	380400753670	456
7962	name7962	380637908465	741
7963	name7963	380301011563	186
7964	name7964	380694739754	949
7965	name7965	380705782263	1999
7966	name7966	380382603325	143
7967	name7967	380696541953	768
7968	name7968	380664478679	1159
7969	name7969	380441649335	426
7970	name7970	380571864563	210
7971	name7971	38087218496	1702
7972	name7972	380332751063	1389
7973	name7973	380320437391	333
7974	name7974	380237624857	644
7975	name7975	380417798295	812
7976	name7976	380545274032	54
7977	name7977	380147821201	879
7978	name7978	380185717404	1135
7979	name7979	380922902882	678
7980	name7980	380607353399	1625
7981	name7981	380323639501	802
7982	name7982	380383248666	830
7983	name7983	380916996672	1207
7984	name7984	380216129589	232
7985	name7985	380200518479	31
7986	name7986	380759412968	979
7987	name7987	380163325965	1800
7988	name7988	380519025519	1878
7989	name7989	380714388551	1919
7990	name7990	380721723476	1395
7991	name7991	3805673805	423
7992	name7992	380428970870	205
7993	name7993	380923029739	1367
7994	name7994	380339830182	1144
7995	name7995	380381878898	1561
7996	name7996	380150787820	873
7997	name7997	380731057783	382
7998	name7998	380550085021	893
7999	name7999	380879177823	414
8000	name8000	380881809329	558
8001	name8001	380674249309	510
8002	name8002	380460992576	221
8003	name8003	380147347851	925
8004	name8004	380863870460	640
8005	name8005	380230651668	1923
8006	name8006	380670972198	50
8007	name8007	380405767034	334
8008	name8008	380731898679	174
8009	name8009	380534007937	1223
8010	name8010	380676899145	1872
8011	name8011	3804907779	924
8012	name8012	380353188509	40
8013	name8013	380415751577	47
8014	name8014	380889258836	488
8015	name8015	380212103991	347
8016	name8016	380835962026	480
8017	name8017	380489915024	1427
8018	name8018	380365134822	204
8019	name8019	380656969155	1314
8020	name8020	380938997401	1374
8021	name8021	380131103512	1388
8022	name8022	380214477897	410
8023	name8023	380405507420	1828
8024	name8024	380897085755	1590
8025	name8025	38055186303	1505
8026	name8026	380272116279	1236
8027	name8027	38036290953	477
8028	name8028	380429109791	948
8029	name8029	380187153820	1420
8030	name8030	380304835215	824
8031	name8031	380610238600	1489
8032	name8032	380984008939	1493
8033	name8033	380247907417	1538
8034	name8034	380939774066	1565
8035	name8035	380191312315	891
8036	name8036	380750312739	226
8037	name8037	380184440350	53
8038	name8038	38060680228	768
8039	name8039	380863262883	697
8040	name8040	380580919826	540
8041	name8041	380144410386	173
8042	name8042	380478667444	360
8043	name8043	380662444333	901
8044	name8044	380318131955	548
8045	name8045	380110598085	227
8046	name8046	380803621412	1395
8047	name8047	380814341089	129
8048	name8048	380424503804	519
8049	name8049	380782916525	1515
8050	name8050	380133973553	619
8051	name8051	380318102464	934
8052	name8052	380790847624	1916
8053	name8053	380560839857	1398
8054	name8054	380162044512	1745
8055	name8055	380605969564	720
8056	name8056	380889870040	1563
8057	name8057	38038325955	573
8058	name8058	380728487874	287
8059	name8059	380440549177	1117
8060	name8060	380436674194	269
8061	name8061	380793124284	949
8062	name8062	380624611908	566
8063	name8063	380770601779	1745
8064	name8064	380598116787	544
8065	name8065	380215010378	1508
8066	name8066	380360718272	1284
8067	name8067	380204155447	561
8068	name8068	380832274267	304
8069	name8069	380970824675	1876
8070	name8070	380720391816	555
8071	name8071	380475748379	1160
8072	name8072	380235678203	997
8073	name8073	380511692386	1955
8074	name8074	380686350196	1989
8075	name8075	380572478823	1996
8076	name8076	3806284589	1157
8077	name8077	380868564156	780
8078	name8078	380937586316	957
8079	name8079	380471966676	1279
8080	name8080	380299228302	1406
8081	name8081	380200971099	966
8082	name8082	380717805947	495
8083	name8083	38055594834	641
8084	name8084	380443289919	1565
8085	name8085	38020983890	1848
8086	name8086	380802397499	310
8087	name8087	380154414639	545
8088	name8088	380609800490	1485
8089	name8089	380335780531	1153
8090	name8090	380339316220	1752
8091	name8091	380715407548	1717
8092	name8092	380571688392	1105
8093	name8093	380779562786	1087
8094	name8094	3805391376	610
8095	name8095	380235558472	1252
8096	name8096	380975913944	1488
8097	name8097	38046043598	910
8098	name8098	380653867440	1056
8099	name8099	380284204199	1082
8100	name8100	380473149776	1178
8101	name8101	3809208662	1869
8102	name8102	38084789460	1176
8103	name8103	380644786988	1280
8104	name8104	380327880907	1323
8105	name8105	38021011301	1568
8106	name8106	380853583751	1890
8107	name8107	380270507816	1980
8108	name8108	380571875868	170
8109	name8109	380204192416	1480
8110	name8110	380954438274	1928
8111	name8111	380420099979	33
8112	name8112	380994101785	1280
8113	name8113	380586253115	943
8114	name8114	380536547780	671
8115	name8115	380466320890	787
8116	name8116	380988630060	1933
8117	name8117	380632098272	1876
8118	name8118	380498777346	491
8119	name8119	380537701908	1096
8120	name8120	380545037738	543
8121	name8121	380878991234	119
8122	name8122	380280759664	1138
8123	name8123	380341142145	1288
8124	name8124	38077510930	144
8125	name8125	380724814788	749
8126	name8126	380547946547	1864
8127	name8127	380837246266	19
8128	name8128	380791683283	525
8129	name8129	3801447860	311
8130	name8130	380829879100	730
8131	name8131	380410677563	1183
8132	name8132	380402702528	1807
8133	name8133	380327192824	330
8134	name8134	380793243967	705
8135	name8135	380443640034	1552
8136	name8136	38092744223	270
8137	name8137	380689101272	1304
8138	name8138	380445590507	506
8139	name8139	380801955863	487
8140	name8140	38057941830	1424
8141	name8141	380586848270	1874
8142	name8142	380606465818	112
8143	name8143	380360731723	1639
8144	name8144	38098359049	347
8145	name8145	380969223005	1906
8146	name8146	380837876713	791
8147	name8147	380901597712	968
8148	name8148	380783201654	1906
8149	name8149	380222688863	798
8150	name8150	380286230164	1543
8151	name8151	380217870546	1048
8152	name8152	380438084737	1847
8153	name8153	380504795017	317
8154	name8154	380597181864	833
8155	name8155	380170276982	1144
8156	name8156	380791095145	598
8157	name8157	380645096020	1889
8158	name8158	380970206615	1443
8159	name8159	380487238333	1494
8160	name8160	380647000738	1823
8161	name8161	380819882265	586
8162	name8162	380221389586	1561
8163	name8163	380933951461	284
8164	name8164	380579765736	1410
8165	name8165	380917294143	1534
8166	name8166	380324244389	633
8167	name8167	380858019867	330
8168	name8168	380816167695	959
8169	name8169	380384762715	362
8170	name8170	380655737746	552
8171	name8171	380221229460	837
8172	name8172	380279534323	200
8173	name8173	380845291435	1853
8174	name8174	380147711521	1916
8175	name8175	380852891369	1118
8176	name8176	38052310296	860
8177	name8177	380602593335	766
8178	name8178	380745236450	697
8179	name8179	380506277851	1195
8180	name8180	380257333184	970
8181	name8181	380562877820	712
8182	name8182	380218928240	1250
8183	name8183	380202970937	356
8184	name8184	380836476454	715
8185	name8185	38084117203	828
8186	name8186	380136851248	1930
8187	name8187	380537966088	258
8188	name8188	380785964017	1419
8189	name8189	380838517132	447
8190	name8190	38045397909	1678
8191	name8191	380959288796	1731
8192	name8192	380782557818	652
8193	name8193	380222893420	406
8194	name8194	380962658818	1996
8195	name8195	380288479889	812
8196	name8196	380574475227	1806
8197	name8197	380972572288	1353
8198	name8198	380680609201	614
8199	name8199	380811999292	699
8200	name8200	380113939448	649
8201	name8201	380990758082	597
8202	name8202	38085377723	1945
8203	name8203	380438427252	1925
8204	name8204	380851461483	58
8205	name8205	380576153722	1017
8206	name8206	380422503500	874
8207	name8207	380612970603	1637
8208	name8208	380400179277	324
8209	name8209	38061701114	1494
8210	name8210	380794122133	342
8211	name8211	380730498596	490
8212	name8212	380494846300	311
8213	name8213	380726982943	470
8214	name8214	38018271843	1964
8215	name8215	380653052223	61
8216	name8216	380725500817	687
8217	name8217	380842070366	200
8218	name8218	380600921730	1231
8219	name8219	380970031836	413
8220	name8220	380409716271	215
8221	name8221	380983014607	798
8222	name8222	380965966015	97
8223	name8223	380832234336	1334
8224	name8224	380497015361	838
8225	name8225	380735990878	737
8226	name8226	380207496322	570
8227	name8227	380428372309	434
8228	name8228	380970033357	125
8229	name8229	380501162089	17
8230	name8230	380625478732	1366
8231	name8231	380479077239	169
8232	name8232	380542972764	710
8233	name8233	3807113851	770
8234	name8234	380786969000	563
8235	name8235	380913706486	364
8236	name8236	380860559465	932
8237	name8237	38056323072	1043
8238	name8238	380129768152	1503
8239	name8239	380225203067	1089
8240	name8240	380999972673	1882
8241	name8241	380911286362	897
8242	name8242	380456646991	517
8243	name8243	380814087492	1921
8244	name8244	38082085357	575
8245	name8245	38085003270	776
8246	name8246	380521772285	899
8247	name8247	38021306104	1024
8248	name8248	380742950915	1034
8249	name8249	380369459457	1818
8250	name8250	380205694671	266
8251	name8251	380988659523	1088
8252	name8252	380216063733	1324
8253	name8253	380988187913	51
8254	name8254	380133279144	1342
8255	name8255	38093052055	583
8256	name8256	380772888548	1091
8257	name8257	380326128827	1545
8258	name8258	380585468510	110
8259	name8259	380485627292	1271
8260	name8260	380284004178	1288
8261	name8261	380819712253	347
8262	name8262	380969088849	1156
8263	name8263	380378400688	1778
8264	name8264	38044573901	1413
8265	name8265	38095828790	645
8266	name8266	380170479041	140
8267	name8267	380699305717	1701
8268	name8268	380682495418	491
8269	name8269	380159233838	1857
8270	name8270	380763124154	81
8271	name8271	380762300350	1792
8272	name8272	380690380729	1475
8273	name8273	380438676920	394
8274	name8274	380154390248	901
8275	name8275	380743624109	728
8276	name8276	380726478207	1486
8277	name8277	380423010923	302
8278	name8278	380432716222	450
8279	name8279	380230366885	1897
8280	name8280	380475908443	762
8281	name8281	380825693182	1106
8282	name8282	380458162093	687
8283	name8283	380515748202	1402
8284	name8284	380291399934	1707
8285	name8285	380101042918	1230
8286	name8286	380873112749	1183
8287	name8287	380900073588	1474
8288	name8288	380609463160	566
8289	name8289	380355594031	1558
8290	name8290	380396387200	1226
8291	name8291	380151022410	784
8292	name8292	380909139855	80
8293	name8293	380425730340	319
8294	name8294	380406325889	1103
8295	name8295	380756142845	895
8296	name8296	380719741165	1541
8297	name8297	38066988450	1207
8298	name8298	380273068041	115
8299	name8299	380329223764	1188
8300	name8300	380443101714	531
8301	name8301	380775063314	1190
8302	name8302	380726757704	1811
8303	name8303	380816244223	497
8304	name8304	380914709141	673
8305	name8305	380953379520	1087
8306	name8306	380259526263	1288
8307	name8307	380182158056	1985
8308	name8308	380144628246	370
8309	name8309	380692449204	181
8310	name8310	380870611214	938
8311	name8311	380383767777	1528
8312	name8312	380339558399	304
8313	name8313	380833101628	1819
8314	name8314	380544831140	1556
8315	name8315	380373917760	1247
8316	name8316	380475899958	642
8317	name8317	380765641543	92
8318	name8318	380576915396	1118
8319	name8319	3806355462	318
8320	name8320	380562743091	598
8321	name8321	380352300018	1512
8322	name8322	38043079397	358
8323	name8323	380277660378	694
8324	name8324	380573738333	366
8325	name8325	380748833980	1452
8326	name8326	380405062838	607
8327	name8327	380752037563	1931
8328	name8328	380436495233	573
8329	name8329	380806285921	767
8330	name8330	380892054021	705
8331	name8331	38056554915	1034
8332	name8332	380624241430	1733
8333	name8333	380234834526	1285
8334	name8334	380127079018	1784
8335	name8335	380439235125	55
8336	name8336	380801842188	414
8337	name8337	380153077095	1443
8338	name8338	380584234940	887
8339	name8339	380871583254	674
8340	name8340	380719937694	1025
8341	name8341	380888336939	499
8342	name8342	380222412532	1578
8343	name8343	380512553443	835
8344	name8344	380538035035	142
8345	name8345	380562660137	1857
8346	name8346	380833829794	1727
8347	name8347	380385172249	1063
8348	name8348	380979151555	882
8349	name8349	380736657674	1378
8350	name8350	380768855885	1610
8351	name8351	380343205711	30
8352	name8352	380992429104	1725
8353	name8353	38096487517	166
8354	name8354	380202438314	370
8355	name8355	380207171448	1097
8356	name8356	380821532247	637
8357	name8357	380280908347	851
8358	name8358	380645276765	566
8359	name8359	380851070015	1328
8360	name8360	380769240728	1150
8361	name8361	380643948833	1252
8362	name8362	38081159165	977
8363	name8363	380938480382	322
8364	name8364	380314205073	222
8365	name8365	380238425259	1863
8366	name8366	380740160069	1188
8367	name8367	380494796898	865
8368	name8368	380204237120	326
8369	name8369	38056032348	1798
8370	name8370	380858393373	842
8371	name8371	3807668447	603
8372	name8372	380429762146	1516
8373	name8373	380556379076	428
8374	name8374	380794531214	746
8375	name8375	380857048800	1203
8376	name8376	380607299048	338
8377	name8377	380511119440	417
8378	name8378	380990293834	1314
8379	name8379	380567219466	1058
8380	name8380	380890317485	1677
8381	name8381	380946839317	906
8382	name8382	380598651615	76
8383	name8383	380263866734	604
8384	name8384	380515928842	1730
8385	name8385	380523831155	508
8386	name8386	380234755651	1290
8387	name8387	380318572052	324
8388	name8388	38011109097	1715
8389	name8389	380585169873	1793
8390	name8390	380508947502	1100
8391	name8391	380120323623	786
8392	name8392	380770159037	992
8393	name8393	380665072609	466
8394	name8394	380510037403	1394
8395	name8395	380268916003	1959
8396	name8396	380602638558	1622
8397	name8397	380786483343	401
8398	name8398	380654953588	525
8399	name8399	380919037775	1609
8400	name8400	380192949790	510
8401	name8401	380999897560	1672
8402	name8402	380695548748	1176
8403	name8403	38087743976	840
8404	name8404	380542096358	1735
8405	name8405	380428983530	1453
8406	name8406	380765623371	822
8407	name8407	380183784064	967
8408	name8408	38040046032	620
8409	name8409	380469542028	1724
8410	name8410	380205035055	166
8411	name8411	380927446782	1096
8412	name8412	38082829127	1387
8413	name8413	380628377010	1841
8414	name8414	380260178206	1601
8415	name8415	380947354407	1053
8416	name8416	380169398091	1022
8417	name8417	380944952388	27
8418	name8418	380331335116	1348
8419	name8419	380299779692	1310
8420	name8420	380334862656	1141
8421	name8421	380684136228	1474
8422	name8422	380120737577	830
8423	name8423	380730983225	66
8424	name8424	38072632385	1382
8425	name8425	380461359965	51
8426	name8426	380187083255	205
8427	name8427	380858816203	1009
8428	name8428	380620002442	1353
8429	name8429	380616248185	1190
8430	name8430	38092293302	1337
8431	name8431	380392067617	777
8432	name8432	380509691543	1577
8433	name8433	380206930662	1231
8434	name8434	380547172490	818
8435	name8435	380731044791	1314
8436	name8436	380581791288	1960
8437	name8437	380690184278	782
8438	name8438	380940160741	976
8439	name8439	380637576055	1286
8440	name8440	380492646175	1407
8441	name8441	380183244780	1572
8442	name8442	38036490722	297
8443	name8443	380354553224	296
8444	name8444	38013611331	1550
8445	name8445	380188178475	991
8446	name8446	380835860369	389
8447	name8447	380462453447	1784
8448	name8448	380775813286	1700
8449	name8449	38081338696	1104
8450	name8450	380900387206	1812
8451	name8451	380641784085	440
8452	name8452	380357475641	323
8453	name8453	380326502533	1244
8454	name8454	380439453396	627
8455	name8455	380265494505	1494
8456	name8456	380826699158	129
8457	name8457	380824266663	879
8458	name8458	38045521914	795
8459	name8459	380664134194	1192
8460	name8460	380721562395	1718
8461	name8461	380641278554	827
8462	name8462	380899675433	445
8463	name8463	380919571398	860
8464	name8464	380475917343	1478
8465	name8465	380415617541	216
8466	name8466	380145195671	1176
8467	name8467	380971709722	1755
8468	name8468	38066302391	956
8469	name8469	380369470704	1202
8470	name8470	380802782503	1547
8471	name8471	380628765738	1518
8472	name8472	38074115204	1386
8473	name8473	380203147841	35
8474	name8474	380365954291	1596
8475	name8475	380107837804	1957
8476	name8476	380916838522	1740
8477	name8477	380337049533	70
8478	name8478	38066844020	200
8479	name8479	380991869019	1485
8480	name8480	38020075270	810
8481	name8481	380417669019	783
8482	name8482	380691205227	999
8483	name8483	380855474553	9
8484	name8484	380573933627	869
8485	name8485	380632923836	1946
8486	name8486	380900287671	12
8487	name8487	380309879663	1944
8488	name8488	380966540474	803
8489	name8489	380879553514	678
8490	name8490	380892780588	462
8491	name8491	380261438432	169
8492	name8492	380315910934	1328
8493	name8493	380895086611	445
8494	name8494	380221821438	172
8495	name8495	380824538940	359
8496	name8496	380858945166	1773
8497	name8497	38078700613	1641
8498	name8498	380932825654	1594
8499	name8499	380524436998	238
8500	name8500	380510969153	1355
8501	name8501	380364523198	919
8502	name8502	380373428327	1957
8503	name8503	380255612029	18
8504	name8504	380217116584	1320
8505	name8505	380428529751	522
8506	name8506	380966087367	1856
8507	name8507	380404144100	989
8508	name8508	380892222053	1453
8509	name8509	380972781259	1199
8510	name8510	380548949657	1947
8511	name8511	380716534599	1178
8512	name8512	380731144307	1106
8513	name8513	380370545449	337
8514	name8514	380156622573	1283
8515	name8515	380911123671	892
8516	name8516	380487070212	1408
8517	name8517	380620703828	1376
8518	name8518	380107843106	1988
8519	name8519	380831209340	921
8520	name8520	380309998007	1117
8521	name8521	380163244628	1290
8522	name8522	380223141084	1310
8523	name8523	380671185323	361
8524	name8524	380838020399	1295
8525	name8525	380478678196	1034
8526	name8526	380847022007	1085
8527	name8527	380649150904	729
8528	name8528	380195106631	722
8529	name8529	380627613631	1759
8530	name8530	380983643993	1874
8531	name8531	380522796009	1107
8532	name8532	380203825889	1824
8533	name8533	380592854996	596
8534	name8534	380363252684	1997
8535	name8535	380761841837	732
8536	name8536	380630994965	1336
8537	name8537	380841188818	1027
8538	name8538	380182712921	1668
8539	name8539	380602461083	1297
8540	name8540	380387828808	828
8541	name8541	380317143390	220
8542	name8542	380854406971	648
8543	name8543	380860076090	1603
8544	name8544	380871206342	289
8545	name8545	380773631169	1369
8546	name8546	380553751249	394
8547	name8547	380400527152	1880
8548	name8548	380704643437	1909
8549	name8549	380107389818	1454
8550	name8550	38079937327	855
8551	name8551	380840230791	712
8552	name8552	380990123057	1899
8553	name8553	380138991918	725
8554	name8554	380393673649	1189
8555	name8555	38028648177	1551
8556	name8556	380366827183	1663
8557	name8557	38011999358	1540
8558	name8558	380729262302	1614
8559	name8559	380466821020	409
8560	name8560	38069928882	281
8561	name8561	380303322755	1963
8562	name8562	380908985588	1940
8563	name8563	380230195329	436
8564	name8564	380249943781	1009
8565	name8565	380772360284	1191
8566	name8566	380131320399	270
8567	name8567	380529356370	388
8568	name8568	380836840878	1323
8569	name8569	380931010744	1143
8570	name8570	380229889748	1208
8571	name8571	380486180201	803
8572	name8572	380577431058	319
8573	name8573	380806783984	856
8574	name8574	38079370721	20
8575	name8575	380393432174	640
8576	name8576	380731870507	745
8577	name8577	380179194640	420
8578	name8578	380283001649	1464
8579	name8579	380921799996	1774
8580	name8580	380555943447	1231
8581	name8581	380493273951	1157
8582	name8582	380542189064	1896
8583	name8583	380839152312	473
8584	name8584	380718756874	308
8585	name8585	380656845849	1522
8586	name8586	380663452057	491
8587	name8587	380602502411	492
8588	name8588	380387347209	1133
8589	name8589	38089289140	310
8590	name8590	380186128457	1835
8591	name8591	380104394579	1717
8592	name8592	380855347731	1572
8593	name8593	38053573859	429
8594	name8594	380253599084	788
8595	name8595	380223506980	471
8596	name8596	380385304168	1267
8597	name8597	380330768536	1015
8598	name8598	380942083463	643
8599	name8599	380106093678	839
8600	name8600	380784586685	989
8601	name8601	380312942510	411
8602	name8602	380598268184	1314
8603	name8603	380143008708	597
8604	name8604	380132387561	669
8605	name8605	380238035327	1932
8606	name8606	380317217852	1105
8607	name8607	380899630932	1709
8608	name8608	380837397883	535
8609	name8609	380476060046	742
8610	name8610	380965383579	424
8611	name8611	380186828878	858
8612	name8612	380727931411	327
8613	name8613	380922800679	93
8614	name8614	380773385581	417
8615	name8615	380554583908	1268
8616	name8616	380382142229	655
8617	name8617	380853432444	1071
8618	name8618	380596049945	999
8619	name8619	380661067008	718
8620	name8620	380197322658	1364
8621	name8621	380238338612	1612
8622	name8622	380272495319	45
8623	name8623	380774503166	445
8624	name8624	380403952032	1084
8625	name8625	380996546104	1924
8626	name8626	380879588517	1581
8627	name8627	380549346953	1309
8628	name8628	38060203089	1674
8629	name8629	380944005111	235
8630	name8630	38023639085	915
8631	name8631	380769047455	513
8632	name8632	38052133773	1533
8633	name8633	38035372494	1819
8634	name8634	38076727066	691
8635	name8635	380942539241	441
8636	name8636	380888055918	1584
8637	name8637	380665626094	19
8638	name8638	380557625861	1852
8639	name8639	38098722701	1604
8640	name8640	38054961511	1012
8641	name8641	380323963975	442
8642	name8642	380758088533	570
8643	name8643	380351380794	1626
8644	name8644	380420909687	1879
8645	name8645	380324880483	549
8646	name8646	380501631359	137
8647	name8647	380455634223	1660
8648	name8648	380468566239	986
8649	name8649	380993536533	1945
8650	name8650	380325318404	689
8651	name8651	380686202222	312
8652	name8652	380458399952	671
8653	name8653	380883656155	1659
8654	name8654	380829995442	1144
8655	name8655	380618075647	1694
8656	name8656	380200259325	60
8657	name8657	380950911746	777
8658	name8658	380838636220	1128
8659	name8659	380353011972	1221
8660	name8660	380292187073	1247
8661	name8661	380203458105	634
8662	name8662	380926769002	834
8663	name8663	380122442086	175
8664	name8664	380126511003	666
8665	name8665	38079916851	1341
8666	name8666	380887291946	1094
8667	name8667	380111475656	558
8668	name8668	380904736176	567
8669	name8669	380555299752	511
8670	name8670	380511432421	1700
8671	name8671	380532869186	293
8672	name8672	380411937650	953
8673	name8673	380904318366	1841
8674	name8674	380408353220	1637
8675	name8675	38067867952	851
8676	name8676	380523723234	1840
8677	name8677	380832109844	706
8678	name8678	380351278029	1718
8679	name8679	380557163710	1163
8680	name8680	380828034433	1043
8681	name8681	380753091254	1325
8682	name8682	380184444815	1440
8683	name8683	380434863527	404
8684	name8684	380391838977	594
8685	name8685	380813538990	1950
8686	name8686	380712269332	52
8687	name8687	380657005406	1630
8688	name8688	380469022716	1763
8689	name8689	380532302203	1856
8690	name8690	380232506971	1541
8691	name8691	380480072513	350
8692	name8692	380788520180	1152
8693	name8693	380912151437	213
8694	name8694	380684760033	592
8695	name8695	380231063949	908
8696	name8696	380267064408	325
8697	name8697	380552612143	189
8698	name8698	380433334556	1724
8699	name8699	380406515103	286
8700	name8700	380423145680	1780
8701	name8701	380690339225	945
8702	name8702	380861276244	651
8703	name8703	380911588821	715
8704	name8704	380120228286	1599
8705	name8705	380487379697	865
8706	name8706	380545604337	1110
8707	name8707	380760768915	1070
8708	name8708	380308492285	1092
8709	name8709	38078897459	1892
8710	name8710	380340635551	1307
8711	name8711	3808194056	763
8712	name8712	380263976084	1194
8713	name8713	380443573809	1501
8714	name8714	380198292937	563
8715	name8715	380348311831	1154
8716	name8716	380118753563	276
8717	name8717	380651050967	1002
8718	name8718	380685996942	1572
8719	name8719	380656973831	162
8720	name8720	380740569012	1039
8721	name8721	380316180369	773
8722	name8722	380561833393	1117
8723	name8723	380550622074	1363
8724	name8724	380838182293	1767
8725	name8725	380509824203	1619
8726	name8726	380274005887	137
8727	name8727	380788748958	1823
8728	name8728	380450678139	1215
8729	name8729	38066514211	1857
8730	name8730	380161053518	1176
8731	name8731	380384886356	225
8732	name8732	380214425178	408
8733	name8733	380331997798	1286
8734	name8734	380438019207	1191
8735	name8735	380617158381	579
8736	name8736	380307614895	744
8737	name8737	380315824421	1688
8738	name8738	380711884595	837
8739	name8739	380624705992	11
8740	name8740	380144876258	1896
8741	name8741	380878496720	991
8742	name8742	380930464646	1628
8743	name8743	380965473855	838
8744	name8744	380456980771	1980
8745	name8745	380677807463	394
8746	name8746	380939024244	201
8747	name8747	380808979923	1690
8748	name8748	380644883216	1473
8749	name8749	380828906595	42
8750	name8750	380507710413	1164
8751	name8751	380400430050	1490
8752	name8752	380373168109	1488
8753	name8753	380567119181	196
8754	name8754	38063182605	631
8755	name8755	3806182687	1813
8756	name8756	380473398656	196
8757	name8757	380126916268	1992
8758	name8758	380875390219	118
8759	name8759	380822026370	274
8760	name8760	380899026663	1327
8761	name8761	380815703306	1852
8762	name8762	38034236306	1545
8763	name8763	380772544398	1809
8764	name8764	380824676177	284
8765	name8765	380133836274	1745
8766	name8766	380822949716	58
8767	name8767	380870170844	1991
8768	name8768	380956143448	1132
8769	name8769	380304730657	1070
8770	name8770	380630559997	205
8771	name8771	380845178883	1727
8772	name8772	380733868924	272
8773	name8773	380778944426	1522
8774	name8774	380123250480	1223
8775	name8775	380252200534	849
8776	name8776	380720566208	1799
8777	name8777	380977169795	1697
8778	name8778	380245000517	235
8779	name8779	380744995184	1010
8780	name8780	380989896091	1499
8781	name8781	380568261325	1062
8782	name8782	380676388070	580
8783	name8783	380869726918	673
8784	name8784	380532433622	1526
8785	name8785	38034486428	216
8786	name8786	380534404122	712
8787	name8787	380629266693	525
8788	name8788	380400700671	1017
8789	name8789	380767460111	1476
8790	name8790	380436450938	604
8791	name8791	380428918824	752
8792	name8792	380687858208	467
8793	name8793	380840695463	791
8794	name8794	380122302464	1369
8795	name8795	380430021246	1331
8796	name8796	380214029540	369
8797	name8797	380309966385	1923
8798	name8798	380875767328	1067
8799	name8799	38055249501	922
8800	name8800	380547540677	803
8801	name8801	38057966133	302
8802	name8802	380213308359	1453
8803	name8803	380541954570	100
8804	name8804	380361124822	425
8805	name8805	380997905761	252
8806	name8806	380113257594	1950
8807	name8807	380301898524	1531
8808	name8808	38088977316	721
8809	name8809	380820207204	512
8810	name8810	380302967676	251
8811	name8811	38082358538	1624
8812	name8812	380961223226	898
8813	name8813	380361408086	1229
8814	name8814	380361829670	451
8815	name8815	380840413253	655
8816	name8816	380127754774	83
8817	name8817	380314535819	1963
8818	name8818	380148259008	1028
8819	name8819	38035594752	1579
8820	name8820	380201517931	460
8821	name8821	380120878923	1737
8822	name8822	38034325761	639
8823	name8823	38052898649	1496
8824	name8824	380938309465	621
8825	name8825	380985260130	467
8826	name8826	380801628063	1132
8827	name8827	380415933034	175
8828	name8828	380290245346	1086
8829	name8829	380557200450	553
8830	name8830	380688348619	1356
8831	name8831	380706918318	83
8832	name8832	380915661579	247
8833	name8833	380700982371	1621
8834	name8834	380805389088	1428
8835	name8835	380935113461	1832
8836	name8836	380669816925	894
8837	name8837	380236425508	382
8838	name8838	380987366084	289
8839	name8839	380887453687	1790
8840	name8840	380237016539	257
8841	name8841	380632655656	1576
8842	name8842	380593520873	1992
8843	name8843	380544779660	800
8844	name8844	38072424015	1898
8845	name8845	380458380063	683
8846	name8846	3808812888	329
8847	name8847	380384682320	1971
8848	name8848	380205759526	391
8849	name8849	380278904300	23
8850	name8850	380754330270	264
8851	name8851	380638970115	338
8852	name8852	380302301519	866
8853	name8853	380502690950	1734
8854	name8854	380539479023	360
8855	name8855	380792000407	637
8856	name8856	38090251530	1968
8857	name8857	38044644045	1206
8858	name8858	38070151418	1834
8859	name8859	380648143340	1444
8860	name8860	380836843990	1898
8861	name8861	380231107283	1519
8862	name8862	380464294303	58
8863	name8863	380655628546	1250
8864	name8864	380805968179	790
8865	name8865	38030015127	1269
8866	name8866	380169194208	1178
8867	name8867	380233751781	130
8868	name8868	380453025559	1987
8869	name8869	380871585526	741
8870	name8870	380976689037	1995
8871	name8871	380135303986	1424
8872	name8872	380731905426	449
8873	name8873	380218867691	611
8874	name8874	380199850825	1963
8875	name8875	380301168429	605
8876	name8876	380106082942	431
8877	name8877	380857459737	6
8878	name8878	380117031067	1191
8879	name8879	380784976573	1489
8880	name8880	380300808968	158
8881	name8881	38069515612	863
8882	name8882	380169214516	790
8883	name8883	380588809143	781
8884	name8884	380214178543	1223
8885	name8885	380424120092	1447
8886	name8886	38080209731	884
8887	name8887	380243089695	1326
8888	name8888	380757667104	626
8889	name8889	380605201361	1095
8890	name8890	380475260049	404
8891	name8891	380662582771	1635
8892	name8892	380335768536	1390
8893	name8893	380275974349	1693
8894	name8894	380824257601	1939
8895	name8895	380833941586	281
8896	name8896	380642039537	1576
8897	name8897	380477691083	92
8898	name8898	380706080635	844
8899	name8899	380747340215	1044
8900	name8900	380965658564	1698
8901	name8901	38028068467	565
8902	name8902	380758971206	1970
8903	name8903	380324786412	1011
8904	name8904	380117177445	939
8905	name8905	380134645670	1602
8906	name8906	380979771408	896
8907	name8907	380960782636	1919
8908	name8908	380821237555	899
8909	name8909	380299594161	1241
8910	name8910	380696812213	436
8911	name8911	380357748636	1024
8912	name8912	380242522950	1241
8913	name8913	380159890111	1014
8914	name8914	380954994851	274
8915	name8915	380180328069	1207
8916	name8916	380542137930	1506
8917	name8917	380290612745	1112
8918	name8918	380807940871	504
8919	name8919	380381288192	586
8920	name8920	380666058943	1962
8921	name8921	38075430023	1199
8922	name8922	380154958893	286
8923	name8923	380969724788	1980
8924	name8924	380184578325	1887
8925	name8925	380408676176	1737
8926	name8926	38037053860	600
8927	name8927	380242868094	1067
8928	name8928	380999113013	711
8929	name8929	380395040784	532
8930	name8930	380416483700	955
8931	name8931	380719738801	1854
8932	name8932	380255902713	1000
8933	name8933	38028627748	957
8934	name8934	380311768951	1994
8935	name8935	380972640157	561
8936	name8936	380328602058	878
8937	name8937	380501481281	1407
8938	name8938	380101028489	1250
8939	name8939	380416031933	342
8940	name8940	380305337697	1754
8941	name8941	380766716499	57
8942	name8942	380900619233	204
8943	name8943	380687378541	1356
8944	name8944	380920336964	892
8945	name8945	380982860829	962
8946	name8946	380185995026	1278
8947	name8947	380237386020	1557
8948	name8948	380263747467	1247
8949	name8949	380729260901	1288
8950	name8950	380463289967	303
8951	name8951	380974554956	1736
8952	name8952	380171889548	1597
8953	name8953	380408414398	875
8954	name8954	380492319770	1639
8955	name8955	380508717790	842
8956	name8956	380808173822	1725
8957	name8957	38056449008	356
8958	name8958	380676551426	1896
8959	name8959	380578363351	1458
8960	name8960	380284656769	1532
8961	name8961	380149917829	714
8962	name8962	38098311927	842
8963	name8963	380385868072	1471
8964	name8964	38016206379	1992
8965	name8965	380723463769	1005
8966	name8966	380816411411	1341
8967	name8967	380702666036	1576
8968	name8968	380942140045	1453
8969	name8969	380762201288	1360
8970	name8970	380439890017	1702
8971	name8971	38032938046	1104
8972	name8972	380470735984	1530
8973	name8973	380983973807	1929
8974	name8974	380330331437	1242
8975	name8975	380770247216	1221
8976	name8976	380505090286	1339
8977	name8977	380624695791	1678
8978	name8978	380703814845	486
8979	name8979	380967984284	990
8980	name8980	380777402090	100
8981	name8981	38045131491	1808
8982	name8982	380242920885	334
8983	name8983	38033423980	1902
8984	name8984	380864052118	1833
8985	name8985	38015674151	152
8986	name8986	380883212094	1742
8987	name8987	380699173440	1145
8988	name8988	380165052726	1653
8989	name8989	380548571719	449
8990	name8990	380204343755	282
8991	name8991	38017978865	1094
8992	name8992	380125973538	882
8993	name8993	380541824309	1753
8994	name8994	380283623058	270
8995	name8995	380751036450	111
8996	name8996	380453793448	804
8997	name8997	380198506388	1194
8998	name8998	380112742942	1803
8999	name8999	380400542164	473
9000	name9000	380753930075	32
\.


--
-- Data for Name: models; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.models (model_id, model, price) FROM stdin;
1	model1	972
2	model2	562
3	model3	474
4	model4	431
5	model5	354
6	model6	251
7	model7	200
8	model8	144
9	model9	228
10	model10	712
11	model11	533
12	model12	378
13	model13	725
14	model14	52
15	model15	553
16	model16	170
17	model17	301
18	model18	650
19	model19	506
20	model20	338
21	model21	260
22	model22	665
23	model23	870
24	model24	492
25	model25	903
26	model26	240
27	model27	329
28	model28	448
29	model29	713
30	model30	407
31	model31	973
32	model32	880
33	model33	977
34	model34	615
35	model35	974
36	model36	322
37	model37	513
38	model38	799
39	model39	520
40	model40	953
41	model41	601
42	model42	8
43	model43	383
44	model44	416
45	model45	662
46	model46	355
47	model47	276
48	model48	173
49	model49	492
50	model50	862
51	model51	34
52	model52	762
53	model53	542
54	model54	64
55	model55	417
56	model56	935
57	model57	449
58	model58	913
59	model59	199
60	model60	705
61	model61	53
62	model62	866
63	model63	792
64	model64	271
65	model65	88
66	model66	304
67	model67	395
68	model68	877
69	model69	360
70	model70	886
71	model71	3
72	model72	508
73	model73	246
74	model74	742
75	model75	208
76	model76	877
77	model77	14
78	model78	683
79	model79	911
80	model80	167
81	model81	527
82	model82	902
83	model83	676
84	model84	42
85	model85	108
86	model86	109
87	model87	629
88	model88	482
89	model89	548
90	model90	12
91	model91	681
92	model92	234
93	model93	690
94	model94	599
95	model95	403
96	model96	195
97	model97	579
98	model98	623
99	model99	325
100	model100	812
101	model101	618
102	model102	929
103	model103	796
104	model104	693
105	model105	448
106	model106	30
107	model107	135
108	model108	807
109	model109	644
110	model110	483
111	model111	459
112	model112	146
113	model113	754
114	model114	751
115	model115	8
116	model116	848
117	model117	569
118	model118	100
119	model119	397
120	model120	997
121	model121	690
122	model122	735
123	model123	243
124	model124	589
125	model125	961
126	model126	412
127	model127	47
128	model128	92
129	model129	11
130	model130	702
131	model131	630
132	model132	209
133	model133	35
134	model134	395
135	model135	653
136	model136	752
137	model137	983
138	model138	113
139	model139	569
140	model140	63
141	model141	19
142	model142	526
143	model143	435
144	model144	283
145	model145	469
146	model146	803
147	model147	396
148	model148	714
149	model149	512
150	model150	568
151	model151	742
152	model152	809
153	model153	662
154	model154	238
155	model155	622
156	model156	383
157	model157	97
158	model158	468
159	model159	976
160	model160	791
161	model161	357
162	model162	674
163	model163	576
164	model164	330
165	model165	730
166	model166	305
167	model167	329
168	model168	277
169	model169	62
170	model170	247
171	model171	52
172	model172	779
173	model173	273
174	model174	522
175	model175	507
176	model176	776
177	model177	718
178	model178	175
179	model179	876
180	model180	804
181	model181	808
182	model182	891
183	model183	479
184	model184	578
185	model185	235
186	model186	786
187	model187	996
188	model188	17
189	model189	306
190	model190	815
191	model191	947
192	model192	533
193	model193	611
194	model194	61
195	model195	585
196	model196	975
197	model197	587
198	model198	592
199	model199	663
200	model200	571
201	model201	891
202	model202	739
203	model203	874
204	model204	3
205	model205	430
206	model206	191
207	model207	961
208	model208	692
209	model209	827
210	model210	795
211	model211	903
212	model212	495
213	model213	196
214	model214	992
215	model215	843
216	model216	763
217	model217	698
218	model218	292
219	model219	162
220	model220	852
221	model221	265
222	model222	625
223	model223	772
224	model224	248
225	model225	362
226	model226	181
227	model227	111
228	model228	899
229	model229	166
230	model230	766
231	model231	853
232	model232	863
233	model233	309
234	model234	618
235	model235	938
236	model236	17
237	model237	284
238	model238	288
239	model239	473
240	model240	284
241	model241	154
242	model242	751
243	model243	490
244	model244	245
245	model245	666
246	model246	626
247	model247	544
248	model248	218
249	model249	748
250	model250	755
251	model251	218
252	model252	298
253	model253	517
254	model254	630
255	model255	444
256	model256	557
257	model257	845
258	model258	74
259	model259	154
260	model260	770
261	model261	668
262	model262	436
263	model263	425
264	model264	890
265	model265	42
266	model266	459
267	model267	385
268	model268	823
269	model269	447
270	model270	86
271	model271	707
272	model272	315
273	model273	558
274	model274	418
275	model275	211
276	model276	273
277	model277	118
278	model278	736
279	model279	767
280	model280	388
281	model281	217
282	model282	93
283	model283	240
284	model284	329
285	model285	282
286	model286	279
287	model287	329
288	model288	22
289	model289	960
290	model290	445
291	model291	895
292	model292	187
293	model293	420
294	model294	145
295	model295	390
296	model296	345
297	model297	42
298	model298	850
299	model299	459
300	model300	316
301	model301	47
302	model302	821
303	model303	219
304	model304	852
305	model305	97
306	model306	849
307	model307	600
308	model308	535
309	model309	806
310	model310	406
311	model311	616
312	model312	629
313	model313	154
314	model314	863
315	model315	482
316	model316	929
317	model317	181
318	model318	91
319	model319	912
320	model320	126
321	model321	770
322	model322	132
323	model323	965
324	model324	242
325	model325	405
326	model326	45
327	model327	95
328	model328	689
329	model329	429
330	model330	999
331	model331	144
332	model332	621
333	model333	595
334	model334	585
335	model335	188
336	model336	61
337	model337	448
338	model338	934
339	model339	415
340	model340	498
341	model341	74
342	model342	884
343	model343	496
344	model344	131
345	model345	750
346	model346	386
347	model347	556
348	model348	956
349	model349	363
350	model350	718
351	model351	628
352	model352	498
353	model353	968
354	model354	588
355	model355	839
356	model356	136
357	model357	321
358	model358	906
359	model359	263
360	model360	815
361	model361	528
362	model362	990
363	model363	39
364	model364	115
365	model365	506
366	model366	182
367	model367	455
368	model368	485
369	model369	545
370	model370	838
371	model371	286
372	model372	225
373	model373	867
374	model374	195
375	model375	935
376	model376	965
377	model377	617
378	model378	760
379	model379	136
380	model380	942
381	model381	547
382	model382	220
383	model383	245
384	model384	873
385	model385	815
386	model386	886
387	model387	866
388	model388	346
389	model389	680
390	model390	954
391	model391	726
392	model392	94
393	model393	507
394	model394	184
395	model395	997
396	model396	622
397	model397	785
398	model398	444
399	model399	381
400	model400	312
401	model401	946
402	model402	196
403	model403	246
404	model404	248
405	model405	538
406	model406	829
407	model407	356
408	model408	734
409	model409	907
410	model410	268
411	model411	657
412	model412	306
413	model413	477
414	model414	39
415	model415	318
416	model416	291
417	model417	53
418	model418	739
419	model419	418
420	model420	842
421	model421	440
422	model422	36
423	model423	350
424	model424	265
425	model425	113
426	model426	263
427	model427	13
428	model428	282
429	model429	370
430	model430	493
431	model431	28
432	model432	128
433	model433	418
434	model434	587
435	model435	634
436	model436	750
437	model437	432
438	model438	19
439	model439	277
440	model440	343
441	model441	784
442	model442	683
443	model443	514
444	model444	505
445	model445	276
446	model446	185
447	model447	213
448	model448	34
449	model449	291
450	model450	50
451	model451	677
452	model452	852
453	model453	667
454	model454	632
455	model455	649
456	model456	706
457	model457	999
458	model458	413
459	model459	868
460	model460	596
461	model461	632
462	model462	474
463	model463	141
464	model464	665
465	model465	244
466	model466	773
467	model467	880
468	model468	547
469	model469	758
470	model470	93
471	model471	464
472	model472	380
473	model473	740
474	model474	964
475	model475	278
476	model476	603
477	model477	226
478	model478	129
479	model479	191
480	model480	799
481	model481	364
482	model482	467
483	model483	543
484	model484	684
485	model485	745
486	model486	178
487	model487	595
488	model488	550
489	model489	156
490	model490	165
491	model491	25
492	model492	151
493	model493	548
494	model494	233
495	model495	465
496	model496	29
497	model497	759
498	model498	207
499	model499	670
500	model500	368
\.


--
-- Data for Name: rent; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.rent (order_id, date_of_renting, period_of_renting, cars_id, clients_id) FROM stdin;
1	2021-06-20	10	3654	4803
2	2021-06-21	1	227	4122
3	2021-06-22	8	87	6524
4	2021-06-23	5	954	6487
5	2021-06-24	7	5977	7451
6	2021-06-25	8	6020	1239
7	2021-06-26	2	3324	2758
8	2021-06-27	2	2825	1685
9	2021-06-28	1	3359	3153
10	2021-06-29	3	6821	4558
11	2021-06-30	10	843	2719
12	2021-07-01	10	5429	2609
13	2021-07-02	2	6370	2632
14	2021-07-03	5	1723	6064
15	2021-07-04	3	4755	3041
16	2021-07-05	9	6948	4948
17	2021-07-06	8	4002	4843
18	2021-07-07	2	2217	3390
19	2021-07-08	5	126	4752
20	2021-07-09	7	1123	5295
21	2021-07-10	6	1757	6874
22	2021-07-11	5	2513	5979
23	2021-07-12	10	6030	1083
24	2021-07-13	8	975	228
25	2021-07-14	6	4292	7444
26	2021-07-15	8	3425	5029
27	2021-07-16	4	3817	3365
28	2021-07-17	4	122	277
29	2021-07-18	5	5294	798
30	2021-07-19	5	1995	6104
31	2021-07-20	6	4356	7639
32	2021-07-21	9	4775	90
33	2021-07-22	6	2981	3488
34	2021-07-23	2	3474	8850
35	2021-07-24	1	360	8555
36	2021-07-25	1	5948	6522
37	2021-07-26	2	342	2374
38	2021-07-27	4	4916	3534
39	2021-07-28	4	3815	4378
40	2021-07-29	2	220	3970
41	2021-07-30	11	2303	5131
42	2021-07-31	10	3043	4131
43	2021-08-01	7	4329	1125
44	2021-08-02	3	704	1215
45	2021-08-03	5	2651	5208
46	2021-08-04	3	1702	4599
47	2021-08-05	8	4817	2199
48	2021-08-06	3	6796	3516
49	2021-08-07	1	6368	7199
50	2021-08-08	4	2549	8090
51	2021-08-09	7	4672	4414
52	2021-08-10	11	2376	1439
53	2021-08-11	1	1143	2609
54	2021-08-12	10	672	1036
55	2021-08-13	2	3226	3322
56	2021-08-14	5	6683	252
57	2021-08-15	5	1134	1586
58	2021-08-16	4	2535	4215
59	2021-08-17	9	102	4356
60	2021-08-18	5	285	1958
61	2021-08-19	7	6582	3418
62	2021-08-20	8	1642	3380
63	2021-08-21	4	1765	5082
64	2021-08-22	10	3777	829
65	2021-08-23	2	3181	8092
66	2021-08-24	5	5699	2883
67	2021-08-25	10	2736	5175
68	2021-08-26	2	6721	8082
69	2021-08-27	5	5898	2394
70	2021-08-28	11	5506	90
71	2021-08-29	10	1060	6957
72	2021-08-30	2	2950	329
73	2021-08-31	8	5501	1717
74	2021-09-01	10	4716	1310
75	2021-09-02	1	5297	8482
76	2021-09-03	2	714	1863
77	2021-09-04	6	5476	4161
78	2021-09-05	7	3911	4264
79	2021-09-06	2	3611	6725
80	2021-09-07	10	1937	1944
81	2021-09-08	6	6757	8121
82	2021-09-09	5	3166	6408
83	2021-09-10	2	3020	7605
84	2021-09-11	10	3529	531
85	2021-09-12	7	2582	8092
86	2021-09-13	3	250	6084
87	2021-09-14	4	5621	8491
88	2021-09-15	8	4986	5718
89	2021-09-16	4	215	6283
90	2021-09-17	9	6515	218
91	2021-09-18	6	226	3971
92	2021-09-19	4	2732	8508
93	2021-09-20	3	401	7212
94	2021-09-21	1	4286	3761
95	2021-09-22	8	3015	8976
96	2021-09-23	6	5901	3903
97	2021-09-24	2	2532	7420
98	2021-09-25	9	4824	1286
99	2021-09-26	10	1687	6415
100	2021-09-27	8	484	2608
101	2021-09-28	5	6834	839
102	2021-09-29	5	4236	796
103	2021-09-30	4	1114	860
104	2021-10-01	3	4742	1667
105	2021-10-02	6	1810	1545
106	2021-10-03	6	4360	6326
107	2021-10-04	3	6878	5219
108	2021-10-05	8	6728	1713
109	2021-10-06	10	4431	1712
110	2021-10-07	7	1563	3469
111	2021-10-08	8	3817	6721
112	2021-10-09	8	3058	5441
113	2021-10-10	10	2945	3670
114	2021-10-11	8	3016	714
115	2021-10-12	1	363	7258
116	2021-10-13	4	2352	8334
117	2021-10-14	9	1687	8363
118	2021-10-15	4	139	1825
119	2021-10-16	11	2482	416
120	2021-10-17	9	2080	878
121	2021-10-18	3	1939	783
122	2021-10-19	2	3226	143
123	2021-10-20	1	2311	2212
124	2021-10-21	10	4000	3412
125	2021-10-22	1	3874	1293
126	2021-10-23	8	5649	3867
127	2021-10-24	4	4170	5748
128	2021-10-25	4	496	31
129	2021-10-26	5	6821	360
130	2021-10-27	2	919	7405
131	2021-10-28	6	2087	597
132	2021-10-29	8	2114	7542
133	2021-10-30	7	672	5751
134	2021-10-31	6	4128	5351
135	2021-11-01	3	6379	1751
136	2021-11-02	3	6293	6615
137	2021-11-03	2	97	2542
138	2021-11-04	11	6950	2108
139	2021-11-05	11	4568	8234
140	2021-11-06	5	1613	8165
141	2021-11-07	4	6370	4584
142	2021-11-08	7	2871	3383
143	2021-11-09	2	2323	742
144	2021-11-10	10	1979	6546
145	2021-11-11	9	4933	1054
146	2021-11-12	3	553	5784
147	2021-11-13	8	4195	5671
148	2021-11-14	6	3897	4265
149	2021-11-15	5	6182	1320
150	2021-11-16	11	5349	2820
151	2021-11-17	7	5882	4003
152	2021-11-18	4	6024	6750
153	2021-11-19	6	3144	8631
154	2021-11-20	9	1296	745
155	2021-11-21	9	2406	663
156	2021-11-22	9	5751	7920
157	2021-11-23	10	6828	7979
158	2021-11-24	7	5443	6711
159	2021-11-25	11	1925	6424
160	2021-11-26	8	3511	8977
161	2021-11-27	8	4486	989
162	2021-11-28	9	2330	6238
163	2021-11-29	9	703	4687
164	2021-11-30	4	4568	8517
165	2021-12-01	7	1373	845
166	2021-12-02	7	1053	7360
167	2021-12-03	9	1513	8238
168	2021-12-04	7	2595	4126
169	2021-12-05	10	2918	6042
170	2021-12-06	4	2953	605
171	2021-12-07	7	163	5063
172	2021-12-08	6	2678	6568
173	2021-12-09	6	467	6617
174	2021-12-10	1	166	8042
175	2021-12-11	2	566	5499
176	2021-12-12	8	192	128
177	2021-12-13	7	2361	959
178	2021-12-14	7	3285	5542
179	2021-12-15	2	2823	5293
180	2021-12-16	6	6420	4558
181	2021-12-17	5	1587	5071
182	2021-12-18	8	5200	7741
183	2021-12-19	9	2411	4953
184	2021-12-20	8	2517	2590
185	2021-12-21	10	3934	1249
186	2021-12-22	5	2330	2369
187	2021-12-23	5	2556	5023
188	2021-12-24	2	99	5038
189	2021-12-25	1	6838	3567
190	2021-12-26	3	6658	1384
191	2021-12-27	4	3247	3830
192	2021-12-28	11	3655	1162
193	2021-12-29	5	912	151
194	2021-12-30	10	5570	4113
195	2021-12-31	3	3778	3512
196	2022-01-01	8	4145	802
197	2022-01-02	1	3590	305
198	2022-01-03	8	3325	3222
199	2022-01-04	1	4521	3393
200	2022-01-05	10	5433	905
201	2022-01-06	5	4781	3725
202	2022-01-07	7	1654	5719
203	2022-01-08	2	3655	4676
204	2022-01-09	10	2561	1815
205	2022-01-10	4	4700	5912
206	2022-01-11	7	2651	1387
207	2022-01-12	4	1606	5028
208	2022-01-13	4	5833	3874
209	2022-01-14	8	6220	4643
210	2022-01-15	3	949	3170
211	2022-01-16	3	3395	1331
212	2022-01-17	2	2656	4887
213	2022-01-18	10	1687	5088
214	2022-01-19	5	740	5439
215	2022-01-20	4	4018	2603
216	2022-01-21	6	3797	379
217	2022-01-22	8	6632	6983
218	2022-01-23	3	5966	3578
219	2022-01-24	9	5299	3865
220	2022-01-25	2	5545	5390
221	2022-01-26	8	5302	2138
222	2022-01-27	7	4947	3180
223	2022-01-28	3	5885	6919
224	2022-01-29	6	2119	5883
225	2022-01-30	9	1756	3804
226	2022-01-31	4	4076	3765
227	2022-02-01	3	3054	3493
228	2022-02-02	6	5965	2411
229	2022-02-03	8	4719	3294
230	2022-02-04	11	6776	3099
231	2022-02-05	1	4503	6557
232	2022-02-06	4	5102	5528
233	2022-02-07	9	5719	1939
234	2022-02-08	4	300	2957
235	2022-02-09	4	2116	728
236	2022-02-10	10	4771	1410
237	2022-02-11	6	459	4219
238	2022-02-12	6	6002	7505
239	2022-02-13	5	5186	3721
240	2022-02-14	7	4357	6102
241	2022-02-15	6	5087	2958
242	2022-02-16	7	3756	5719
243	2022-02-17	2	3378	7560
244	2022-02-18	6	912	8465
245	2022-02-19	5	3007	6718
246	2022-02-20	10	3485	3117
247	2022-02-21	1	1096	4754
248	2022-02-22	5	2780	1337
249	2022-02-23	3	2940	4976
250	2022-02-24	4	2635	2030
251	2022-02-25	11	4085	4009
252	2022-02-26	7	2732	6955
253	2022-02-27	8	6796	8885
254	2022-02-28	4	5437	301
255	2022-03-01	9	3964	3612
256	2022-03-02	10	3262	7094
257	2022-03-03	8	948	5868
258	2022-03-04	7	5615	8729
259	2022-03-05	6	1550	3500
260	2022-03-06	10	6553	8716
261	2022-03-07	9	6634	1506
262	2022-03-08	1	4652	3520
263	2022-03-09	4	2509	4339
264	2022-03-10	8	909	7026
265	2022-03-11	7	3507	4186
266	2022-03-12	7	4184	1944
267	2022-03-13	11	1942	306
268	2022-03-14	10	4168	289
269	2022-03-15	2	6353	7671
270	2022-03-16	7	1092	1034
271	2022-03-17	2	1264	6277
272	2022-03-18	8	974	3596
273	2022-03-19	9	5319	7129
274	2022-03-20	5	6269	2883
275	2022-03-21	7	76	2771
276	2022-03-22	6	1311	4535
277	2022-03-23	2	1499	5857
278	2022-03-24	5	608	4392
279	2022-03-25	10	563	2715
280	2022-03-26	2	3157	4346
281	2022-03-27	3	1418	6768
282	2022-03-28	4	5213	5808
283	2022-03-29	2	5025	64
284	2022-03-30	2	4993	7528
285	2022-03-31	7	462	3215
286	2022-04-01	3	3452	482
287	2022-04-02	5	680	1762
288	2022-04-03	6	4723	8176
289	2022-04-04	6	5748	8671
290	2022-04-05	3	3227	1503
291	2022-04-06	10	4097	2116
292	2022-04-07	5	6753	630
293	2022-04-08	3	8	4985
294	2022-04-09	7	1315	2886
295	2022-04-10	3	6483	2184
296	2022-04-11	5	495	5652
297	2022-04-12	5	2829	1163
298	2022-04-13	10	5912	2208
299	2022-04-14	9	5143	3680
300	2022-04-15	4	33	2490
301	2022-04-16	11	4776	701
302	2022-04-17	11	3857	7770
303	2022-04-18	9	5098	276
304	2022-04-19	2	3838	7617
305	2022-04-20	6	2815	3321
306	2022-04-21	8	19	8689
307	2022-04-22	9	1285	5495
308	2022-04-23	10	47	5238
309	2022-04-24	5	1733	2779
310	2022-04-25	10	6468	2881
311	2022-04-26	5	5669	1756
312	2022-04-27	10	5394	7903
313	2022-04-28	10	4324	5732
314	2022-04-29	3	3388	1215
315	2022-04-30	5	4842	8961
316	2022-05-01	2	2813	5794
317	2022-05-02	4	5493	7000
318	2022-05-03	2	3181	7404
319	2022-05-04	5	6985	1269
320	2022-05-05	3	3948	6375
321	2022-05-06	8	293	4933
322	2022-05-07	8	466	478
323	2022-05-08	2	1014	4253
324	2022-05-09	9	383	1250
325	2022-05-10	10	1967	5735
326	2022-05-11	8	2688	6895
327	2022-05-12	7	318	1537
328	2022-05-13	3	2264	7385
329	2022-05-14	4	4994	362
330	2022-05-15	9	5527	3416
331	2022-05-16	7	4548	3582
332	2022-05-17	6	1707	1902
333	2022-05-18	11	4491	7610
334	2022-05-19	3	5309	4614
335	2022-05-20	1	3692	2751
336	2022-05-21	2	549	8731
337	2022-05-22	10	1172	4873
338	2022-05-23	8	4733	1344
339	2022-05-24	4	5493	2172
340	2022-05-25	8	859	6426
341	2022-05-26	11	1203	3137
342	2022-05-27	8	1904	8226
343	2022-05-28	2	5365	1036
344	2022-05-29	5	325	676
345	2022-05-30	8	869	179
346	2022-05-31	8	1780	8461
347	2022-06-01	7	6753	6785
348	2022-06-02	8	150	3639
349	2022-06-03	4	6546	1508
350	2022-06-04	8	2083	7408
351	2022-06-05	8	5320	5391
352	2022-06-06	7	3417	1401
353	2022-06-07	10	4180	5416
354	2022-06-08	3	3764	2163
355	2022-06-09	10	1704	1754
356	2022-06-10	9	1722	8182
357	2022-06-11	11	3211	2275
358	2022-06-12	10	5635	4685
359	2022-06-13	6	5388	7140
360	2022-06-14	11	693	1873
361	2022-06-15	10	6640	1666
362	2022-06-16	5	1066	8201
363	2022-06-17	8	2220	6927
364	2022-06-18	9	3098	5511
365	2022-06-19	4	549	6870
366	2022-06-20	2	3931	7971
367	2022-06-21	7	3378	4959
368	2022-06-22	5	1641	6285
369	2022-06-23	7	6800	3403
370	2022-06-24	6	6798	8191
371	2022-06-25	7	6423	533
372	2022-06-26	3	6385	7555
373	2022-06-27	3	5418	135
374	2022-06-28	10	3172	8376
375	2022-06-29	3	1167	6988
376	2022-06-30	1	6115	3915
377	2022-07-01	6	3186	6344
378	2022-07-02	6	5912	6877
379	2022-07-03	3	4545	7031
380	2022-07-04	2	2722	4148
381	2022-07-05	3	1467	8504
382	2022-07-06	5	1478	109
383	2022-07-07	3	1201	8022
384	2022-07-08	2	1614	507
385	2022-07-09	10	3581	7951
386	2022-07-10	9	4402	3477
387	2022-07-11	9	2423	2078
388	2022-07-12	4	2191	3437
389	2022-07-13	7	6082	6884
390	2022-07-14	7	3642	8193
391	2022-07-15	9	5075	5706
392	2022-07-16	6	4265	5276
393	2022-07-17	10	3251	479
394	2022-07-18	5	30	3312
395	2022-07-19	4	4740	7397
396	2022-07-20	4	4439	461
397	2022-07-21	9	4582	7861
398	2022-07-22	1	4584	7687
399	2022-07-23	5	1824	1323
400	2022-07-24	7	6480	7760
401	2022-07-25	10	4395	2550
402	2022-07-26	3	928	4928
403	2022-07-27	10	1072	1269
404	2022-07-28	3	196	6685
405	2022-07-29	8	6973	6757
406	2022-07-30	9	2499	8815
407	2022-07-31	9	3205	6676
408	2022-08-01	7	1093	2013
409	2022-08-02	11	1787	4971
410	2022-08-03	8	4782	4637
411	2022-08-04	7	4295	2194
412	2022-08-05	8	2502	7669
413	2022-08-06	8	462	8469
414	2022-08-07	3	2380	3988
415	2022-08-08	3	6819	8623
416	2022-08-09	10	2544	7775
417	2022-08-10	9	1464	1745
418	2022-08-11	3	4762	2144
419	2022-08-12	1	5075	739
420	2022-08-13	7	5991	7510
421	2022-08-14	10	2614	276
422	2022-08-15	8	1084	1614
423	2022-08-16	7	2885	3058
424	2022-08-17	1	742	1718
425	2022-08-18	9	6698	6476
426	2022-08-19	10	612	3229
427	2022-08-20	9	6285	3928
428	2022-08-21	4	881	1040
429	2022-08-22	6	2346	8091
430	2022-08-23	3	4494	5325
431	2022-08-24	3	1989	5310
432	2022-08-25	3	5783	1541
433	2022-08-26	7	6863	4444
434	2022-08-27	8	143	5617
435	2022-08-28	2	1965	6667
436	2022-08-29	8	448	1336
437	2022-08-30	9	6641	7571
438	2022-08-31	10	2226	1706
439	2022-09-01	10	4609	6683
440	2022-09-02	5	2728	6068
441	2022-09-03	3	3919	610
442	2022-09-04	10	2285	491
443	2022-09-05	9	6632	1784
444	2022-09-06	8	2172	6469
445	2022-09-07	2	5844	6682
446	2022-09-08	6	2912	7514
447	2022-09-09	7	5647	5350
448	2022-09-10	9	1056	6272
449	2022-09-11	7	4637	8506
450	2022-09-12	2	4498	8561
451	2022-09-13	2	5536	4676
452	2022-09-14	7	6067	1090
453	2022-09-15	7	2345	5646
454	2022-09-16	2	660	5210
455	2022-09-17	9	5362	5591
456	2022-09-18	9	965	5461
457	2022-09-19	1	1089	7540
458	2022-09-20	2	6942	7996
459	2022-09-21	2	3418	756
460	2022-09-22	5	3059	2819
461	2022-09-23	9	78	142
462	2022-09-24	11	5037	8566
463	2022-09-25	2	949	406
464	2022-09-26	3	196	7753
465	2022-09-27	5	4124	6969
466	2022-09-28	4	3937	969
467	2022-09-29	11	6561	6762
468	2022-09-30	9	4979	1372
469	2022-10-01	3	411	6089
470	2022-10-02	5	6465	3226
471	2022-10-03	8	1022	6351
472	2022-10-04	1	881	416
473	2022-10-05	3	4521	1381
474	2022-10-06	1	4779	7387
475	2022-10-07	3	5878	1858
476	2022-10-08	5	2257	3478
477	2022-10-09	1	1545	1962
478	2022-10-10	10	929	1389
479	2022-10-11	2	3077	5795
480	2022-10-12	5	6837	3088
481	2022-10-13	2	3163	784
482	2022-10-14	4	980	734
483	2022-10-15	4	5790	8143
484	2022-10-16	10	970	2401
485	2022-10-17	10	3971	7564
486	2022-10-18	7	6371	6703
487	2022-10-19	6	2329	8597
488	2022-10-20	5	6819	6632
489	2022-10-21	9	2563	4184
490	2022-10-22	5	1852	8261
491	2022-10-23	11	4151	7967
492	2022-10-24	5	5792	8543
493	2022-10-25	9	2975	7030
494	2022-10-26	1	6858	4613
495	2022-10-27	6	5061	8027
496	2022-10-28	10	2251	6888
497	2022-10-29	8	1746	319
498	2022-10-30	7	4941	1263
499	2022-10-31	10	300	8027
500	2022-11-01	10	604	6783
501	2022-11-02	4	1	3151
502	2022-11-03	10	3661	1993
503	2022-11-04	1	4035	957
504	2022-11-05	9	3365	4664
505	2022-11-06	2	1967	4239
506	2022-11-07	5	4761	5702
507	2022-11-08	9	1947	7767
508	2022-11-09	5	5471	3290
509	2022-11-10	9	2096	8286
510	2022-11-11	3	1140	3875
511	2022-11-12	11	3985	2683
512	2022-11-13	9	5629	1846
513	2022-11-14	5	613	244
514	2022-11-15	7	3624	8625
515	2022-11-16	1	883	4790
516	2022-11-17	4	2152	1740
517	2022-11-18	8	134	8809
518	2022-11-19	8	2099	1929
519	2022-11-20	5	4058	5085
520	2022-11-21	4	4928	8043
521	2022-11-22	7	6859	4913
522	2022-11-23	9	1481	2747
523	2022-11-24	7	1307	975
524	2022-11-25	3	1075	6489
525	2022-11-26	10	3918	24
526	2022-11-27	6	5167	8880
527	2022-11-28	1	291	5354
528	2022-11-29	7	5120	3728
529	2022-11-30	8	4359	2730
530	2022-12-01	9	1495	8872
531	2022-12-02	1	254	2028
532	2022-12-03	10	430	4060
533	2022-12-04	7	678	6885
534	2022-12-05	3	49	594
535	2022-12-06	6	3034	4466
536	2022-12-07	9	6412	7191
537	2022-12-08	2	6214	8515
538	2022-12-09	3	1285	4896
539	2022-12-10	4	5394	414
540	2022-12-11	10	2782	3639
541	2022-12-12	8	4425	3901
542	2022-12-13	3	4997	2544
543	2022-12-14	9	5319	5474
544	2022-12-15	2	466	4605
545	2022-12-16	10	4564	6192
546	2022-12-17	10	2664	5699
547	2022-12-18	8	3737	2837
548	2022-12-19	8	3907	4728
549	2022-12-20	2	239	1438
550	2022-12-21	6	3348	3207
551	2022-12-22	10	6469	2034
552	2022-12-23	11	386	8820
553	2022-12-24	11	910	7250
554	2022-12-25	10	3910	6232
555	2022-12-26	7	4250	8709
556	2022-12-27	6	304	1140
557	2022-12-28	9	3635	4335
558	2022-12-29	10	5411	7643
559	2022-12-30	4	3613	2688
560	2022-12-31	9	4613	3616
561	2023-01-01	5	1269	8798
562	2023-01-02	3	5485	8710
563	2023-01-03	2	2899	1862
564	2023-01-04	4	840	5818
565	2023-01-05	4	2234	672
566	2023-01-06	2	6308	7061
567	2023-01-07	3	1254	4623
568	2023-01-08	10	3007	7324
569	2023-01-09	9	6350	3496
570	2023-01-10	11	3660	4755
571	2023-01-11	10	3449	6236
572	2023-01-12	6	4563	3883
573	2023-01-13	10	3186	6453
574	2023-01-14	7	1550	3059
575	2023-01-15	4	3839	2772
576	2023-01-16	2	4032	5894
577	2023-01-17	11	568	3237
578	2023-01-18	7	250	6111
579	2023-01-19	1	951	7304
580	2023-01-20	4	2249	5920
581	2023-01-21	7	1284	3341
582	2023-01-22	7	3216	2762
583	2023-01-23	1	2171	7915
584	2023-01-24	3	1755	6941
585	2023-01-25	7	6793	8499
586	2023-01-26	3	3658	1344
587	2023-01-27	10	2104	449
588	2023-01-28	6	1424	7489
589	2023-01-29	2	2024	5975
590	2023-01-30	3	6355	8790
591	2023-01-31	3	237	3635
592	2023-02-01	8	5428	4320
593	2023-02-02	8	6772	1476
594	2023-02-03	9	3949	8123
595	2023-02-04	3	5476	1622
596	2023-02-05	6	6809	2307
597	2023-02-06	5	4332	7892
598	2023-02-07	7	3505	6083
599	2023-02-08	7	1877	2620
600	2023-02-09	2	6546	3844
\.


--
-- Name: adress_adress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.adress_adress_id_seq', 2000, true);


--
-- Name: branches_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.branches_branch_id_seq', 50, true);


--
-- Name: cars_cars_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.cars_cars_id_seq', 7000, true);


--
-- Name: clients_clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.clients_clients_id_seq', 9000, true);


--
-- Name: models_model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.models_model_id_seq', 500, true);


--
-- Name: rent_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.rent_order_id_seq', 600, true);


--
-- Name: adress adress_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.adress
    ADD CONSTRAINT adress_pkey PRIMARY KEY (adress_id);


--
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (branch_id);


--
-- Name: cars cars_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (cars_id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (clients_id);


--
-- Name: models models_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_pkey PRIMARY KEY (model_id);


--
-- Name: rent rent_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.rent
    ADD CONSTRAINT rent_pkey PRIMARY KEY (order_id);


--
-- Name: branches branches_adress_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_adress_id_fkey FOREIGN KEY (adress_id) REFERENCES public.adress(adress_id);


--
-- Name: cars cars_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(branch_id);


--
-- Name: cars cars_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.models(model_id);


--
-- Name: clients clients_adress_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_adress_id_fkey FOREIGN KEY (adress_id) REFERENCES public.adress(adress_id);


--
-- Name: rent rent_cars_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.rent
    ADD CONSTRAINT rent_cars_id_fkey FOREIGN KEY (cars_id) REFERENCES public.cars(cars_id);


--
-- Name: rent rent_clients_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.rent
    ADD CONSTRAINT rent_clients_id_fkey FOREIGN KEY (clients_id) REFERENCES public.clients(clients_id);


--
-- PostgreSQL database dump complete
--

