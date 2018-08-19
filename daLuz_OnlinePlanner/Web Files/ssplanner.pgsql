--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.12
-- Dumped by pg_dump version 9.5.12

SET statement_timeout = 0;
SET lock_timeout = 0;
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


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activity; Type: TABLE; Schema: public; Owner: christiandaluz
--

CREATE TABLE public.activity (
    activityid integer NOT NULL,
    catid integer NOT NULL,
    activityname character varying(125) NOT NULL,
    dueby timestamp without time zone NOT NULL,
    priority integer NOT NULL,
    description text,
    status character varying(15) NOT NULL,
    estimatedtime integer,
    CONSTRAINT activity_estimatedtime_check CHECK ((estimatedtime > 0)),
    CONSTRAINT activity_priority_check CHECK (((priority <= 5) AND (priority >= 1))),
    CONSTRAINT activity_status_check CHECK (((status)::text = ANY ((ARRAY['complete'::character varying, 'incomplete'::character varying])::text[])))
);


ALTER TABLE public.activity OWNER TO christiandaluz;

--
-- Name: activity2; Type: TABLE; Schema: public; Owner: christiandaluz
--

CREATE TABLE public.activity2 (
    activityid integer NOT NULL,
    catid integer NOT NULL,
    activityname character varying(125) NOT NULL,
    dueby timestamp without time zone NOT NULL,
    priority integer NOT NULL,
    description text,
    status character varying(15) NOT NULL,
    estimatedtime integer,
    CONSTRAINT activity2_dueby_check CHECK ((now() < dueby)),
    CONSTRAINT activity2_estimatedtime_check CHECK ((estimatedtime > 0)),
    CONSTRAINT activity2_priority_check CHECK (((priority <= 5) AND (priority >= 1))),
    CONSTRAINT activity2_status_check CHECK (((status)::text = ANY ((ARRAY['complete'::character varying, 'incomplete'::character varying])::text[])))
);


ALTER TABLE public.activity2 OWNER TO christiandaluz;

--
-- Name: activity2_activityid_seq; Type: SEQUENCE; Schema: public; Owner: christiandaluz
--

CREATE SEQUENCE public.activity2_activityid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activity2_activityid_seq OWNER TO christiandaluz;

--
-- Name: activity2_activityid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: christiandaluz
--

ALTER SEQUENCE public.activity2_activityid_seq OWNED BY public.activity2.activityid;


--
-- Name: activity_activityid_seq; Type: SEQUENCE; Schema: public; Owner: christiandaluz
--

CREATE SEQUENCE public.activity_activityid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activity_activityid_seq OWNER TO christiandaluz;

--
-- Name: activity_activityid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: christiandaluz
--

ALTER SEQUENCE public.activity_activityid_seq OWNED BY public.activity.activityid;


--
-- Name: category; Type: TABLE; Schema: public; Owner: christiandaluz
--

CREATE TABLE public.category (
    catid integer NOT NULL,
    clientid integer NOT NULL,
    catname character varying(40) NOT NULL
);


ALTER TABLE public.category OWNER TO christiandaluz;

--
-- Name: activitylistview; Type: VIEW; Schema: public; Owner: stephanieuschok
--

CREATE VIEW public.activitylistview AS
 SELECT activity.activityname,
    activity.dueby,
    activity.description,
    category.catname,
    activity.status,
    date_part('dow'::text, activity.dueby) AS dayofweek
   FROM (public.activity
     JOIN public.category ON ((activity.catid = category.catid)));


ALTER TABLE public.activitylistview OWNER TO stephanieuschok;

--
-- Name: category2; Type: TABLE; Schema: public; Owner: christiandaluz
--

CREATE TABLE public.category2 (
    catid integer NOT NULL,
    clientid integer NOT NULL,
    catname character varying(40) NOT NULL
);


ALTER TABLE public.category2 OWNER TO christiandaluz;

--
-- Name: category2_catid_seq; Type: SEQUENCE; Schema: public; Owner: christiandaluz
--

CREATE SEQUENCE public.category2_catid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category2_catid_seq OWNER TO christiandaluz;

--
-- Name: category2_catid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: christiandaluz
--

ALTER SEQUENCE public.category2_catid_seq OWNED BY public.category2.catid;


--
-- Name: category_catid_seq; Type: SEQUENCE; Schema: public; Owner: christiandaluz
--

CREATE SEQUENCE public.category_catid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_catid_seq OWNER TO christiandaluz;

--
-- Name: category_catid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: christiandaluz
--

ALTER SEQUENCE public.category_catid_seq OWNED BY public.category.catid;


--
-- Name: client; Type: TABLE; Schema: public; Owner: christiandaluz
--

CREATE TABLE public.client (
    clientid integer NOT NULL,
    username character varying(30) NOT NULL,
    passwordhash text NOT NULL,
    email character varying(40) NOT NULL
);


ALTER TABLE public.client OWNER TO christiandaluz;

--
-- Name: client2; Type: TABLE; Schema: public; Owner: christiandaluz
--

CREATE TABLE public.client2 (
    clientid integer NOT NULL,
    username character varying(30) NOT NULL,
    passwordhash text NOT NULL,
    email character varying(40) NOT NULL
);


ALTER TABLE public.client2 OWNER TO christiandaluz;

--
-- Name: client2_clientid_seq; Type: SEQUENCE; Schema: public; Owner: christiandaluz
--

CREATE SEQUENCE public.client2_clientid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client2_clientid_seq OWNER TO christiandaluz;

--
-- Name: client2_clientid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: christiandaluz
--

ALTER SEQUENCE public.client2_clientid_seq OWNED BY public.client2.clientid;


--
-- Name: client_clientid_seq; Type: SEQUENCE; Schema: public; Owner: christiandaluz
--

CREATE SEQUENCE public.client_clientid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client_clientid_seq OWNER TO christiandaluz;

--
-- Name: client_clientid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: christiandaluz
--

ALTER SEQUENCE public.client_clientid_seq OWNED BY public.client.clientid;


--
-- Name: weeklyview; Type: VIEW; Schema: public; Owner: stephanieuschok
--

CREATE VIEW public.weeklyview AS
 SELECT activitylistview.activityname,
    activitylistview.dueby,
    activitylistview.description,
    activitylistview.catname,
    activitylistview.status,
    activitylistview.dayofweek
   FROM public.activitylistview
  WHERE ((activitylistview.dueby >= ( SELECT date_trunc('week'::text, (('now'::text)::date)::timestamp with time zone) AS current_week)) AND (activitylistview.dueby <= ( SELECT (date_trunc('week'::text, (('now'::text)::date)::timestamp with time zone) + '6 days'::interval))));


ALTER TABLE public.weeklyview OWNER TO stephanieuschok;

--
-- Name: activityid; Type: DEFAULT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.activity ALTER COLUMN activityid SET DEFAULT nextval('public.activity_activityid_seq'::regclass);


--
-- Name: activityid; Type: DEFAULT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.activity2 ALTER COLUMN activityid SET DEFAULT nextval('public.activity2_activityid_seq'::regclass);


--
-- Name: catid; Type: DEFAULT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.category ALTER COLUMN catid SET DEFAULT nextval('public.category_catid_seq'::regclass);


--
-- Name: catid; Type: DEFAULT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.category2 ALTER COLUMN catid SET DEFAULT nextval('public.category2_catid_seq'::regclass);


--
-- Name: clientid; Type: DEFAULT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.client ALTER COLUMN clientid SET DEFAULT nextval('public.client_clientid_seq'::regclass);


--
-- Name: clientid; Type: DEFAULT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.client2 ALTER COLUMN clientid SET DEFAULT nextval('public.client2_clientid_seq'::regclass);


--
-- Data for Name: activity; Type: TABLE DATA; Schema: public; Owner: christiandaluz
--

COPY public.activity (activityid, catid, activityname, dueby, priority, description, status, estimatedtime) FROM stdin;
143	1	Weekly Attendance	2018-04-20 16:00:00	1		incomplete	\N
144	8	End of Sprint 4	2018-04-19 13:40:00	5	Project due!	complete	18000
146	9	Workout	2018-04-21 10:00:00	1	SWEAT!	incomplete	90
142	1	Student Reports	2018-04-18 13:30:00	2	Reports are due.	complete	60
147	10	Clean aquarium	2018-04-22 12:00:00	5	Chores!	incomplete	60
148	9	Workout	2018-04-18 12:00:00	1	Sweat!	incomplete	60
149	10	Clean room	2018-04-18 22:00:00	5	Chores!	complete	60
113	1	Alert boc	2018-04-10 18:00:00	1		complete	\N
108	6	Go to grocery store	2018-04-10 12:00:00	1		incomplete	\N
110	6	Dance	2018-04-11 12:50:00	2		incomplete	\N
1	1	Test these tables	2018-02-28 00:00:00	1	Test	incomplete	1
2	2	Test these tables	2018-02-28 00:00:00	1	Test	incomplete	1
81	2	Baseball	2018-03-27 00:00:00	1	Baseball practice!	incomplete	\N
82	2	Math homework	2018-03-28 00:00:00	1	Bleh!	incomplete	\N
83	2	Italian project	2018-03-28 00:00:00	1	Buongiorno	incomplete	\N
84	2	English quiz	2018-04-02 00:00:00	1	Study literature	incomplete	\N
85	6	Drama club	2018-04-03 00:00:00	1	 	incomplete	\N
86	2	Figure out this week date problem	2018-03-22 00:00:00	1	Pray for me!	incomplete	\N
89	2	Presentation for Senior Seminar	2018-03-22 00:00:00	1	Presentation	incomplete	\N
90	6	Work out	2018-03-23 00:00:00	1	Lift weights	incomplete	\N
91	1	Send resume to company	2018-03-24 00:00:00	1	Get hired!	incomplete	\N
92	6	Steph's Birthday!	2018-03-25 00:00:00	1	Happy birthday!	incomplete	\N
93	6	Party!	2018-03-24 00:00:00	1	Weekend!	incomplete	\N
95	6	Steph's Birthday!	2018-03-25 00:00:01	1	Cake!!!	incomplete	\N
102	6	Easter	2018-04-01 00:00:00	5	Happy Easter!	incomplete	\N
80	2	Swimming	2018-03-29 10:00:00	1	Swimming practice!	incomplete	\N
96	1	Printing	2018-03-30 19:45:00	3	Print booklets	incomplete	25
114	2	check to see if alert boxes work	2018-04-11 00:00:00	1		incomplete	\N
111	2	Test- this is due at midnight	2018-04-13 00:00:00	1		incomplete	\N
109	2	English Essay	2018-04-14 23:00:00	5		incomplete	\N
112	2	Finish check marks	2018-04-14 00:00:00	5		incomplete	120
117	8	Test -> EST: 1H1M	2018-04-14 17:00:00	5	Test this :3	incomplete	61
107	1	Figure out color scheme	2018-04-09 17:55:00	5	hi	incomplete	60
152	10	Feed fish	2018-04-22 12:00:00	1	They're hungry	incomplete	1
153	2	Demonstration for AutoSchedule	2018-04-22 15:00:00	3		incomplete	90
145	8	Assignment 9	2018-04-19 13:40:00	5	Write progress report and update requirements doc.	complete	60
150	8	Log hours	2018-04-18 16:00:00	3		complete	\N
170	2	Work on "Demonstration for AutoSchedule" for 30 minutes	2018-04-19 00:00:00	3	This is an auto-scheduled activity	incomplete	30
171	2	Work on "Demonstration for AutoSchedule" for 30 minutes	2018-04-20 00:00:00	3	This is an auto-scheduled activity	incomplete	30
172	2	Work on "Demonstration for AutoSchedule" for 30 minutes	2018-04-21 00:00:00	3	This is an auto-scheduled activity	incomplete	30
173	12	Jump in the pond	2018-05-01 00:00:00	5	jumps	incomplete	525600
174	12	2222	1999-01-01 00:00:00	4	rrr	incomplete	525600
175	12	Work on "Jump in the pond" for 65700 minutes	2018-04-23 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
176	12	Work on "Jump in the pond" for 65700 minutes	2018-04-24 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
177	12	Work on "Jump in the pond" for 65700 minutes	2018-04-25 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
178	12	Work on "Jump in the pond" for 65700 minutes	2018-04-26 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
179	12	Work on "Jump in the pond" for 65700 minutes	2018-04-27 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
180	12	Work on "Jump in the pond" for 65700 minutes	2018-04-28 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
181	12	Work on "Jump in the pond" for 65700 minutes	2018-04-29 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
182	12	Work on "Jump in the pond" for 65700 minutes	2018-04-30 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
183	12	juu	1969-12-31 19:00:00	4		incomplete	\N
185	12	Work on "Work on "Jump in the pond" for 65700 minutes" for 13140 minutes	2018-04-24 00:00:00	5	This is an auto-scheduled activity	incomplete	13140
186	12	Work on "Work on "Jump in the pond" for 65700 minutes" for 13140 minutes	2018-04-25 00:00:00	5	This is an auto-scheduled activity	incomplete	13140
187	12	Work on "Work on "Jump in the pond" for 65700 minutes" for 13140 minutes	2018-04-26 00:00:00	5	This is an auto-scheduled activity	incomplete	13140
188	12	Work on "Work on "Jump in the pond" for 65700 minutes" for 13140 minutes	2018-04-27 00:00:00	5	This is an auto-scheduled activity	incomplete	13140
184	12	Work on 	2018-04-23 00:00:00	5	This is an auto-scheduled activity	incomplete	13140
189	12	Work on "Jump in the pond" for 65700 minutes	2018-04-23 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
190	12	Work on "Jump in the pond" for 65700 minutes	2018-04-24 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
191	12	Work on "Jump in the pond" for 65700 minutes	2018-04-25 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
192	12	Work on "Jump in the pond" for 65700 minutes	2018-04-26 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
193	12	Work on "Jump in the pond" for 65700 minutes	2018-04-27 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
194	12	Work on "Jump in the pond" for 65700 minutes	2018-04-28 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
195	12	Work on "Jump in the pond" for 65700 minutes	2018-04-29 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
196	12	Work on "Jump in the pond" for 65700 minutes	2018-04-30 00:00:00	5	This is an auto-scheduled activity	incomplete	65700
197	2	Math Homework	2018-04-27 15:30:00	3		incomplete	\N
198	13	ff	2018-04-27 00:00:00	1		incomplete	\N
199	13	rrrr	2018-05-31 00:00:00	1		incomplete	\N
200	13	ffff	2060-06-03 00:00:00	1		incomplete	\N
201	13	fff	2018-04-27 00:00:00	5		complete	\N
202	13	the quick brown fox jumps over the lazy dog. 	2018-04-27 00:00:00	1		incomplete	\N
236	18	Since 	2018-05-09 00:00:00	1		incomplete	\N
207	2	Last day of class	2018-05-08 14:55:00	5		incomplete	\N
208	1	F	2018-05-03 00:00:00	1		incomplete	120
209	1	F	2018-05-03 19:00:00	1		incomplete	120
210	1	F	2018-05-05 00:00:00	1		incomplete	120
211	1	Work on "F" for 120 minutes	2018-05-04 00:00:00	1	This is an auto-scheduled activity	incomplete	120
213	1	Test activity	2018-05-06 00:00:00	1		incomplete	\N
233	34	Please Work	2018-05-08 00:00:00	1		incomplete	\N
235	22	The quick 	2018-05-12 01:00:00	2		incomplete	\N
237	18	Abstract	2019-05-09 00:00:00	1		incomplete	30000
227	33	Something	2018-05-08 00:00:00	2		incomplete	\N
238	18	jljhg	2018-05-10 00:00:00	1		incomplete	\N
239	18	f	2018-05-09 00:00:00	1		complete	\N
240	18	2	2019-05-09 00:00:00	1		incomplete	1
241	33	Auto scheduling	2018-05-12 00:00:00	1		incomplete	30000
242	33	Work on "Auto scheduling" for 15000 minutes	2018-05-10 00:00:00	1	This is an auto-scheduled activity	incomplete	15000
243	33	Work on "Auto scheduling" for 15000 minutes	2018-05-11 00:00:00	1	This is an auto-scheduled activity	incomplete	15000
244	33	Something	2018-05-11 00:00:00	2		incomplete	\N
245	36	Final Project	2019-05-09 00:00:00	5		incomplete	525
246	36	Work on "Final Project" for 1 minutes	2018-05-10 00:00:00	5	This is an auto-scheduled activity	incomplete	1
247	36	Work on "Final Project" for 1 minutes	2018-05-11 00:00:00	5	This is an auto-scheduled activity	incomplete	1
248	36	Work on "Final Project" for 1 minutes	2018-05-12 00:00:00	5	This is an auto-scheduled activity	incomplete	1
249	36	Work on "Final Project" for 1 minutes	2018-05-13 00:00:00	5	This is an auto-scheduled activity	incomplete	1
250	36	Work on "Final Project" for 1 minutes	2018-05-14 00:00:00	5	This is an auto-scheduled activity	incomplete	1
251	36	Work on "Final Project" for 1 minutes	2018-05-15 00:00:00	5	This is an auto-scheduled activity	incomplete	1
252	36	Work on "Final Project" for 1 minutes	2018-05-16 00:00:00	5	This is an auto-scheduled activity	incomplete	1
253	36	Work on "Final Project" for 1 minutes	2018-05-17 00:00:00	5	This is an auto-scheduled activity	incomplete	1
254	36	Work on "Final Project" for 1 minutes	2018-05-18 00:00:00	5	This is an auto-scheduled activity	incomplete	1
255	36	Work on "Final Project" for 1 minutes	2018-05-19 00:00:00	5	This is an auto-scheduled activity	incomplete	1
256	36	Work on "Final Project" for 1 minutes	2018-05-20 00:00:00	5	This is an auto-scheduled activity	incomplete	1
257	36	Work on "Final Project" for 1 minutes	2018-05-21 00:00:00	5	This is an auto-scheduled activity	incomplete	1
258	36	Work on "Final Project" for 1 minutes	2018-05-22 00:00:00	5	This is an auto-scheduled activity	incomplete	1
259	36	Work on "Final Project" for 1 minutes	2018-05-23 00:00:00	5	This is an auto-scheduled activity	incomplete	1
260	36	Work on "Final Project" for 1 minutes	2018-05-24 00:00:00	5	This is an auto-scheduled activity	incomplete	1
261	36	Work on "Final Project" for 1 minutes	2018-05-25 00:00:00	5	This is an auto-scheduled activity	incomplete	1
262	36	Work on "Final Project" for 1 minutes	2018-05-26 00:00:00	5	This is an auto-scheduled activity	incomplete	1
263	36	Work on "Final Project" for 1 minutes	2018-05-27 00:00:00	5	This is an auto-scheduled activity	incomplete	1
264	36	Work on "Final Project" for 1 minutes	2018-05-28 00:00:00	5	This is an auto-scheduled activity	incomplete	1
265	36	Work on "Final Project" for 1 minutes	2018-05-29 00:00:00	5	This is an auto-scheduled activity	incomplete	1
266	36	Work on "Final Project" for 1 minutes	2018-05-30 00:00:00	5	This is an auto-scheduled activity	incomplete	1
267	36	Work on "Final Project" for 1 minutes	2018-05-31 00:00:00	5	This is an auto-scheduled activity	incomplete	1
268	36	Work on "Final Project" for 1 minutes	2018-06-01 00:00:00	5	This is an auto-scheduled activity	incomplete	1
269	36	Work on "Final Project" for 1 minutes	2018-06-02 00:00:00	5	This is an auto-scheduled activity	incomplete	1
270	36	Work on "Final Project" for 1 minutes	2018-06-03 00:00:00	5	This is an auto-scheduled activity	incomplete	1
271	36	Work on "Final Project" for 1 minutes	2018-06-04 00:00:00	5	This is an auto-scheduled activity	incomplete	1
272	36	Work on "Final Project" for 1 minutes	2018-06-05 00:00:00	5	This is an auto-scheduled activity	incomplete	1
273	36	Work on "Final Project" for 1 minutes	2018-06-06 00:00:00	5	This is an auto-scheduled activity	incomplete	1
274	36	Work on "Final Project" for 1 minutes	2018-06-07 00:00:00	5	This is an auto-scheduled activity	incomplete	1
275	36	Work on "Final Project" for 1 minutes	2018-06-08 00:00:00	5	This is an auto-scheduled activity	incomplete	1
276	36	Work on "Final Project" for 1 minutes	2018-06-09 00:00:00	5	This is an auto-scheduled activity	incomplete	1
277	36	Work on "Final Project" for 1 minutes	2018-06-10 00:00:00	5	This is an auto-scheduled activity	incomplete	1
278	36	Work on "Final Project" for 1 minutes	2018-06-11 00:00:00	5	This is an auto-scheduled activity	incomplete	1
279	36	Work on "Final Project" for 1 minutes	2018-06-12 00:00:00	5	This is an auto-scheduled activity	incomplete	1
280	36	Work on "Final Project" for 1 minutes	2018-06-13 00:00:00	5	This is an auto-scheduled activity	incomplete	1
281	36	Work on "Final Project" for 1 minutes	2018-06-14 00:00:00	5	This is an auto-scheduled activity	incomplete	1
282	36	Work on "Final Project" for 1 minutes	2018-06-15 00:00:00	5	This is an auto-scheduled activity	incomplete	1
283	36	Work on "Final Project" for 1 minutes	2018-06-16 00:00:00	5	This is an auto-scheduled activity	incomplete	1
284	36	Work on "Final Project" for 1 minutes	2018-06-17 00:00:00	5	This is an auto-scheduled activity	incomplete	1
285	36	Work on "Final Project" for 1 minutes	2018-06-18 00:00:00	5	This is an auto-scheduled activity	incomplete	1
286	36	Work on "Final Project" for 1 minutes	2018-06-19 00:00:00	5	This is an auto-scheduled activity	incomplete	1
287	36	Work on "Final Project" for 1 minutes	2018-06-20 00:00:00	5	This is an auto-scheduled activity	incomplete	1
288	36	Work on "Final Project" for 1 minutes	2018-06-21 00:00:00	5	This is an auto-scheduled activity	incomplete	1
289	36	Work on "Final Project" for 1 minutes	2018-06-22 00:00:00	5	This is an auto-scheduled activity	incomplete	1
290	36	Work on "Final Project" for 1 minutes	2018-06-23 00:00:00	5	This is an auto-scheduled activity	incomplete	1
291	36	Work on "Final Project" for 1 minutes	2018-06-24 00:00:00	5	This is an auto-scheduled activity	incomplete	1
292	36	Work on "Final Project" for 1 minutes	2018-06-25 00:00:00	5	This is an auto-scheduled activity	incomplete	1
293	36	Work on "Final Project" for 1 minutes	2018-06-26 00:00:00	5	This is an auto-scheduled activity	incomplete	1
294	36	Work on "Final Project" for 1 minutes	2018-06-27 00:00:00	5	This is an auto-scheduled activity	incomplete	1
295	36	Work on "Final Project" for 1 minutes	2018-06-28 00:00:00	5	This is an auto-scheduled activity	incomplete	1
296	36	Work on "Final Project" for 1 minutes	2018-06-29 00:00:00	5	This is an auto-scheduled activity	incomplete	1
297	36	Work on "Final Project" for 1 minutes	2018-06-30 00:00:00	5	This is an auto-scheduled activity	incomplete	1
298	36	Work on "Final Project" for 1 minutes	2018-07-01 00:00:00	5	This is an auto-scheduled activity	incomplete	1
299	36	Work on "Final Project" for 1 minutes	2018-07-02 00:00:00	5	This is an auto-scheduled activity	incomplete	1
300	36	Work on "Final Project" for 1 minutes	2018-07-03 00:00:00	5	This is an auto-scheduled activity	incomplete	1
301	36	Work on "Final Project" for 1 minutes	2018-07-04 00:00:00	5	This is an auto-scheduled activity	incomplete	1
302	36	Work on "Final Project" for 1 minutes	2018-07-05 00:00:00	5	This is an auto-scheduled activity	incomplete	1
303	36	Work on "Final Project" for 1 minutes	2018-07-06 00:00:00	5	This is an auto-scheduled activity	incomplete	1
304	36	Work on "Final Project" for 1 minutes	2018-07-07 00:00:00	5	This is an auto-scheduled activity	incomplete	1
305	36	Work on "Final Project" for 1 minutes	2018-07-08 00:00:00	5	This is an auto-scheduled activity	incomplete	1
306	36	Work on "Final Project" for 1 minutes	2018-07-09 00:00:00	5	This is an auto-scheduled activity	incomplete	1
307	36	Work on "Final Project" for 1 minutes	2018-07-10 00:00:00	5	This is an auto-scheduled activity	incomplete	1
308	36	Work on "Final Project" for 1 minutes	2018-07-11 00:00:00	5	This is an auto-scheduled activity	incomplete	1
309	36	Work on "Final Project" for 1 minutes	2018-07-12 00:00:00	5	This is an auto-scheduled activity	incomplete	1
310	36	Work on "Final Project" for 1 minutes	2018-07-13 00:00:00	5	This is an auto-scheduled activity	incomplete	1
311	36	Work on "Final Project" for 1 minutes	2018-07-14 00:00:00	5	This is an auto-scheduled activity	incomplete	1
312	36	Work on "Final Project" for 1 minutes	2018-07-15 00:00:00	5	This is an auto-scheduled activity	incomplete	1
313	36	Work on "Final Project" for 1 minutes	2018-07-16 00:00:00	5	This is an auto-scheduled activity	incomplete	1
314	36	Work on "Final Project" for 1 minutes	2018-07-17 00:00:00	5	This is an auto-scheduled activity	incomplete	1
315	36	Work on "Final Project" for 1 minutes	2018-07-18 00:00:00	5	This is an auto-scheduled activity	incomplete	1
316	36	Work on "Final Project" for 1 minutes	2018-07-19 00:00:00	5	This is an auto-scheduled activity	incomplete	1
317	36	Work on "Final Project" for 1 minutes	2018-07-20 00:00:00	5	This is an auto-scheduled activity	incomplete	1
318	36	Work on "Final Project" for 1 minutes	2018-07-21 00:00:00	5	This is an auto-scheduled activity	incomplete	1
319	36	Work on "Final Project" for 1 minutes	2018-07-22 00:00:00	5	This is an auto-scheduled activity	incomplete	1
320	36	Work on "Final Project" for 1 minutes	2018-07-23 00:00:00	5	This is an auto-scheduled activity	incomplete	1
321	36	Work on "Final Project" for 1 minutes	2018-07-24 00:00:00	5	This is an auto-scheduled activity	incomplete	1
322	36	Work on "Final Project" for 1 minutes	2018-07-25 00:00:00	5	This is an auto-scheduled activity	incomplete	1
323	36	Work on "Final Project" for 1 minutes	2018-07-26 00:00:00	5	This is an auto-scheduled activity	incomplete	1
324	36	Work on "Final Project" for 1 minutes	2018-07-27 00:00:00	5	This is an auto-scheduled activity	incomplete	1
325	36	Work on "Final Project" for 1 minutes	2018-07-28 00:00:00	5	This is an auto-scheduled activity	incomplete	1
326	36	Work on "Final Project" for 1 minutes	2018-07-29 00:00:00	5	This is an auto-scheduled activity	incomplete	1
327	36	Work on "Final Project" for 1 minutes	2018-07-30 00:00:00	5	This is an auto-scheduled activity	incomplete	1
328	36	Work on "Final Project" for 1 minutes	2018-07-31 00:00:00	5	This is an auto-scheduled activity	incomplete	1
329	36	Work on "Final Project" for 1 minutes	2018-08-01 00:00:00	5	This is an auto-scheduled activity	incomplete	1
330	36	Work on "Final Project" for 1 minutes	2018-08-02 00:00:00	5	This is an auto-scheduled activity	incomplete	1
331	36	Work on "Final Project" for 1 minutes	2018-08-03 00:00:00	5	This is an auto-scheduled activity	incomplete	1
332	36	Work on "Final Project" for 1 minutes	2018-08-04 00:00:00	5	This is an auto-scheduled activity	incomplete	1
333	36	Work on "Final Project" for 1 minutes	2018-08-05 00:00:00	5	This is an auto-scheduled activity	incomplete	1
334	36	Work on "Final Project" for 1 minutes	2018-08-06 00:00:00	5	This is an auto-scheduled activity	incomplete	1
335	36	Work on "Final Project" for 1 minutes	2018-08-07 00:00:00	5	This is an auto-scheduled activity	incomplete	1
336	36	Work on "Final Project" for 1 minutes	2018-08-08 00:00:00	5	This is an auto-scheduled activity	incomplete	1
337	36	Work on "Final Project" for 1 minutes	2018-08-09 00:00:00	5	This is an auto-scheduled activity	incomplete	1
338	36	Work on "Final Project" for 1 minutes	2018-08-10 00:00:00	5	This is an auto-scheduled activity	incomplete	1
339	36	Work on "Final Project" for 1 minutes	2018-08-11 00:00:00	5	This is an auto-scheduled activity	incomplete	1
340	36	Work on "Final Project" for 1 minutes	2018-08-12 00:00:00	5	This is an auto-scheduled activity	incomplete	1
341	36	Work on "Final Project" for 1 minutes	2018-08-13 00:00:00	5	This is an auto-scheduled activity	incomplete	1
342	36	Work on "Final Project" for 1 minutes	2018-08-14 00:00:00	5	This is an auto-scheduled activity	incomplete	1
343	36	Work on "Final Project" for 1 minutes	2018-08-15 00:00:00	5	This is an auto-scheduled activity	incomplete	1
344	36	Work on "Final Project" for 1 minutes	2018-08-16 00:00:00	5	This is an auto-scheduled activity	incomplete	1
345	36	Work on "Final Project" for 1 minutes	2018-08-17 00:00:00	5	This is an auto-scheduled activity	incomplete	1
346	36	Work on "Final Project" for 1 minutes	2018-08-18 00:00:00	5	This is an auto-scheduled activity	incomplete	1
347	36	Work on "Final Project" for 1 minutes	2018-08-19 00:00:00	5	This is an auto-scheduled activity	incomplete	1
348	36	Work on "Final Project" for 1 minutes	2018-08-20 00:00:00	5	This is an auto-scheduled activity	incomplete	1
349	36	Work on "Final Project" for 1 minutes	2018-08-21 00:00:00	5	This is an auto-scheduled activity	incomplete	1
350	36	Work on "Final Project" for 1 minutes	2018-08-22 00:00:00	5	This is an auto-scheduled activity	incomplete	1
351	36	Work on "Final Project" for 1 minutes	2018-08-23 00:00:00	5	This is an auto-scheduled activity	incomplete	1
352	36	Work on "Final Project" for 1 minutes	2018-08-24 00:00:00	5	This is an auto-scheduled activity	incomplete	1
353	36	Work on "Final Project" for 1 minutes	2018-08-25 00:00:00	5	This is an auto-scheduled activity	incomplete	1
354	36	Work on "Final Project" for 1 minutes	2018-08-26 00:00:00	5	This is an auto-scheduled activity	incomplete	1
355	36	Work on "Final Project" for 1 minutes	2018-08-27 00:00:00	5	This is an auto-scheduled activity	incomplete	1
356	36	Work on "Final Project" for 1 minutes	2018-08-28 00:00:00	5	This is an auto-scheduled activity	incomplete	1
357	36	Work on "Final Project" for 1 minutes	2018-08-29 00:00:00	5	This is an auto-scheduled activity	incomplete	1
358	36	Work on "Final Project" for 1 minutes	2018-08-30 00:00:00	5	This is an auto-scheduled activity	incomplete	1
359	36	Work on "Final Project" for 1 minutes	2018-08-31 00:00:00	5	This is an auto-scheduled activity	incomplete	1
360	36	Work on "Final Project" for 1 minutes	2018-09-01 00:00:00	5	This is an auto-scheduled activity	incomplete	1
361	36	Work on "Final Project" for 1 minutes	2018-09-02 00:00:00	5	This is an auto-scheduled activity	incomplete	1
362	36	Work on "Final Project" for 1 minutes	2018-09-03 00:00:00	5	This is an auto-scheduled activity	incomplete	1
363	36	Work on "Final Project" for 1 minutes	2018-09-04 00:00:00	5	This is an auto-scheduled activity	incomplete	1
364	36	Work on "Final Project" for 1 minutes	2018-09-05 00:00:00	5	This is an auto-scheduled activity	incomplete	1
365	36	Work on "Final Project" for 1 minutes	2018-09-06 00:00:00	5	This is an auto-scheduled activity	incomplete	1
366	36	Work on "Final Project" for 1 minutes	2018-09-07 00:00:00	5	This is an auto-scheduled activity	incomplete	1
367	36	Work on "Final Project" for 1 minutes	2018-09-08 00:00:00	5	This is an auto-scheduled activity	incomplete	1
368	36	Work on "Final Project" for 1 minutes	2018-09-09 00:00:00	5	This is an auto-scheduled activity	incomplete	1
369	36	Work on "Final Project" for 1 minutes	2018-09-10 00:00:00	5	This is an auto-scheduled activity	incomplete	1
370	36	Work on "Final Project" for 1 minutes	2018-09-11 00:00:00	5	This is an auto-scheduled activity	incomplete	1
371	36	Work on "Final Project" for 1 minutes	2018-09-12 00:00:00	5	This is an auto-scheduled activity	incomplete	1
372	36	Work on "Final Project" for 1 minutes	2018-09-13 00:00:00	5	This is an auto-scheduled activity	incomplete	1
373	36	Work on "Final Project" for 1 minutes	2018-09-14 00:00:00	5	This is an auto-scheduled activity	incomplete	1
374	36	Work on "Final Project" for 1 minutes	2018-09-15 00:00:00	5	This is an auto-scheduled activity	incomplete	1
375	36	Work on "Final Project" for 1 minutes	2018-09-16 00:00:00	5	This is an auto-scheduled activity	incomplete	1
376	36	Work on "Final Project" for 1 minutes	2018-09-17 00:00:00	5	This is an auto-scheduled activity	incomplete	1
377	36	Work on "Final Project" for 1 minutes	2018-09-18 00:00:00	5	This is an auto-scheduled activity	incomplete	1
378	36	Work on "Final Project" for 1 minutes	2018-09-19 00:00:00	5	This is an auto-scheduled activity	incomplete	1
379	36	Work on "Final Project" for 1 minutes	2018-09-20 00:00:00	5	This is an auto-scheduled activity	incomplete	1
380	36	Work on "Final Project" for 1 minutes	2018-09-21 00:00:00	5	This is an auto-scheduled activity	incomplete	1
381	36	Work on "Final Project" for 1 minutes	2018-09-22 00:00:00	5	This is an auto-scheduled activity	incomplete	1
382	36	Work on "Final Project" for 1 minutes	2018-09-23 00:00:00	5	This is an auto-scheduled activity	incomplete	1
383	36	Work on "Final Project" for 1 minutes	2018-09-24 00:00:00	5	This is an auto-scheduled activity	incomplete	1
384	36	Work on "Final Project" for 1 minutes	2018-09-25 00:00:00	5	This is an auto-scheduled activity	incomplete	1
385	36	Work on "Final Project" for 1 minutes	2018-09-26 00:00:00	5	This is an auto-scheduled activity	incomplete	1
386	36	Work on "Final Project" for 1 minutes	2018-09-27 00:00:00	5	This is an auto-scheduled activity	incomplete	1
387	36	Work on "Final Project" for 1 minutes	2018-09-28 00:00:00	5	This is an auto-scheduled activity	incomplete	1
388	36	Work on "Final Project" for 1 minutes	2018-09-29 00:00:00	5	This is an auto-scheduled activity	incomplete	1
389	36	Work on "Final Project" for 1 minutes	2018-09-30 00:00:00	5	This is an auto-scheduled activity	incomplete	1
390	36	Work on "Final Project" for 1 minutes	2018-10-01 00:00:00	5	This is an auto-scheduled activity	incomplete	1
391	36	Work on "Final Project" for 1 minutes	2018-10-02 00:00:00	5	This is an auto-scheduled activity	incomplete	1
392	36	Work on "Final Project" for 1 minutes	2018-10-03 00:00:00	5	This is an auto-scheduled activity	incomplete	1
393	36	Work on "Final Project" for 1 minutes	2018-10-04 00:00:00	5	This is an auto-scheduled activity	incomplete	1
394	36	Work on "Final Project" for 1 minutes	2018-10-05 00:00:00	5	This is an auto-scheduled activity	incomplete	1
395	36	Work on "Final Project" for 1 minutes	2018-10-06 00:00:00	5	This is an auto-scheduled activity	incomplete	1
396	36	Work on "Final Project" for 1 minutes	2018-10-07 00:00:00	5	This is an auto-scheduled activity	incomplete	1
397	36	Work on "Final Project" for 1 minutes	2018-10-08 00:00:00	5	This is an auto-scheduled activity	incomplete	1
398	36	Work on "Final Project" for 1 minutes	2018-10-09 00:00:00	5	This is an auto-scheduled activity	incomplete	1
399	36	Work on "Final Project" for 1 minutes	2018-10-10 00:00:00	5	This is an auto-scheduled activity	incomplete	1
400	36	Work on "Final Project" for 1 minutes	2018-10-11 00:00:00	5	This is an auto-scheduled activity	incomplete	1
401	36	Work on "Final Project" for 1 minutes	2018-10-12 00:00:00	5	This is an auto-scheduled activity	incomplete	1
402	36	Work on "Final Project" for 1 minutes	2018-10-13 00:00:00	5	This is an auto-scheduled activity	incomplete	1
403	36	Work on "Final Project" for 1 minutes	2018-10-14 00:00:00	5	This is an auto-scheduled activity	incomplete	1
404	36	Work on "Final Project" for 1 minutes	2018-10-15 00:00:00	5	This is an auto-scheduled activity	incomplete	1
405	36	Work on "Final Project" for 1 minutes	2018-10-16 00:00:00	5	This is an auto-scheduled activity	incomplete	1
406	36	Work on "Final Project" for 1 minutes	2018-10-17 00:00:00	5	This is an auto-scheduled activity	incomplete	1
407	36	Work on "Final Project" for 1 minutes	2018-10-18 00:00:00	5	This is an auto-scheduled activity	incomplete	1
408	36	Work on "Final Project" for 1 minutes	2018-10-19 00:00:00	5	This is an auto-scheduled activity	incomplete	1
409	36	Work on "Final Project" for 1 minutes	2018-10-20 00:00:00	5	This is an auto-scheduled activity	incomplete	1
410	36	Work on "Final Project" for 1 minutes	2018-10-21 00:00:00	5	This is an auto-scheduled activity	incomplete	1
411	36	Work on "Final Project" for 1 minutes	2018-10-22 00:00:00	5	This is an auto-scheduled activity	incomplete	1
412	36	Work on "Final Project" for 1 minutes	2018-10-23 00:00:00	5	This is an auto-scheduled activity	incomplete	1
413	36	Work on "Final Project" for 1 minutes	2018-10-24 00:00:00	5	This is an auto-scheduled activity	incomplete	1
414	36	Work on "Final Project" for 1 minutes	2018-10-25 00:00:00	5	This is an auto-scheduled activity	incomplete	1
415	36	Work on "Final Project" for 1 minutes	2018-10-26 00:00:00	5	This is an auto-scheduled activity	incomplete	1
416	36	Work on "Final Project" for 1 minutes	2018-10-27 00:00:00	5	This is an auto-scheduled activity	incomplete	1
417	36	Work on "Final Project" for 1 minutes	2018-10-28 00:00:00	5	This is an auto-scheduled activity	incomplete	1
418	36	Work on "Final Project" for 1 minutes	2018-10-29 00:00:00	5	This is an auto-scheduled activity	incomplete	1
419	36	Work on "Final Project" for 1 minutes	2018-10-30 00:00:00	5	This is an auto-scheduled activity	incomplete	1
420	36	Work on "Final Project" for 1 minutes	2018-10-31 00:00:00	5	This is an auto-scheduled activity	incomplete	1
421	36	Work on "Final Project" for 1 minutes	2018-11-01 00:00:00	5	This is an auto-scheduled activity	incomplete	1
422	36	Work on "Final Project" for 1 minutes	2018-11-02 00:00:00	5	This is an auto-scheduled activity	incomplete	1
423	36	Work on "Final Project" for 1 minutes	2018-11-03 00:00:00	5	This is an auto-scheduled activity	incomplete	1
424	36	Work on "Final Project" for 1 minutes	2018-11-04 00:00:00	5	This is an auto-scheduled activity	incomplete	1
425	36	Work on "Final Project" for 1 minutes	2018-11-05 00:00:00	5	This is an auto-scheduled activity	incomplete	1
426	36	Work on "Final Project" for 1 minutes	2018-11-06 00:00:00	5	This is an auto-scheduled activity	incomplete	1
427	36	Work on "Final Project" for 1 minutes	2018-11-07 00:00:00	5	This is an auto-scheduled activity	incomplete	1
428	36	Work on "Final Project" for 1 minutes	2018-11-08 00:00:00	5	This is an auto-scheduled activity	incomplete	1
429	36	Work on "Final Project" for 1 minutes	2018-11-09 00:00:00	5	This is an auto-scheduled activity	incomplete	1
430	36	Work on "Final Project" for 1 minutes	2018-11-10 00:00:00	5	This is an auto-scheduled activity	incomplete	1
431	36	Work on "Final Project" for 1 minutes	2018-11-11 00:00:00	5	This is an auto-scheduled activity	incomplete	1
432	36	Work on "Final Project" for 1 minutes	2018-11-12 00:00:00	5	This is an auto-scheduled activity	incomplete	1
433	36	Work on "Final Project" for 1 minutes	2018-11-13 00:00:00	5	This is an auto-scheduled activity	incomplete	1
434	36	Work on "Final Project" for 1 minutes	2018-11-14 00:00:00	5	This is an auto-scheduled activity	incomplete	1
435	36	Work on "Final Project" for 1 minutes	2018-11-15 00:00:00	5	This is an auto-scheduled activity	incomplete	1
436	36	Work on "Final Project" for 1 minutes	2018-11-16 00:00:00	5	This is an auto-scheduled activity	incomplete	1
437	36	Work on "Final Project" for 1 minutes	2018-11-17 00:00:00	5	This is an auto-scheduled activity	incomplete	1
438	36	Work on "Final Project" for 1 minutes	2018-11-18 00:00:00	5	This is an auto-scheduled activity	incomplete	1
439	36	Work on "Final Project" for 1 minutes	2018-11-19 00:00:00	5	This is an auto-scheduled activity	incomplete	1
440	36	Work on "Final Project" for 1 minutes	2018-11-20 00:00:00	5	This is an auto-scheduled activity	incomplete	1
441	36	Work on "Final Project" for 1 minutes	2018-11-21 00:00:00	5	This is an auto-scheduled activity	incomplete	1
442	36	Work on "Final Project" for 1 minutes	2018-11-22 00:00:00	5	This is an auto-scheduled activity	incomplete	1
443	36	Work on "Final Project" for 1 minutes	2018-11-23 00:00:00	5	This is an auto-scheduled activity	incomplete	1
444	36	Work on "Final Project" for 1 minutes	2018-11-24 00:00:00	5	This is an auto-scheduled activity	incomplete	1
445	36	Work on "Final Project" for 1 minutes	2018-11-25 00:00:00	5	This is an auto-scheduled activity	incomplete	1
446	36	Work on "Final Project" for 1 minutes	2018-11-26 00:00:00	5	This is an auto-scheduled activity	incomplete	1
447	36	Work on "Final Project" for 1 minutes	2018-11-27 00:00:00	5	This is an auto-scheduled activity	incomplete	1
448	36	Work on "Final Project" for 1 minutes	2018-11-28 00:00:00	5	This is an auto-scheduled activity	incomplete	1
449	36	Work on "Final Project" for 1 minutes	2018-11-29 00:00:00	5	This is an auto-scheduled activity	incomplete	1
450	36	Work on "Final Project" for 1 minutes	2018-11-30 00:00:00	5	This is an auto-scheduled activity	incomplete	1
451	36	Work on "Final Project" for 1 minutes	2018-12-01 00:00:00	5	This is an auto-scheduled activity	incomplete	1
452	36	Work on "Final Project" for 1 minutes	2018-12-02 00:00:00	5	This is an auto-scheduled activity	incomplete	1
453	36	Work on "Final Project" for 1 minutes	2018-12-03 00:00:00	5	This is an auto-scheduled activity	incomplete	1
454	36	Work on "Final Project" for 1 minutes	2018-12-04 00:00:00	5	This is an auto-scheduled activity	incomplete	1
455	36	Work on "Final Project" for 1 minutes	2018-12-05 00:00:00	5	This is an auto-scheduled activity	incomplete	1
456	36	Work on "Final Project" for 1 minutes	2018-12-06 00:00:00	5	This is an auto-scheduled activity	incomplete	1
457	36	Work on "Final Project" for 1 minutes	2018-12-07 00:00:00	5	This is an auto-scheduled activity	incomplete	1
458	36	Work on "Final Project" for 1 minutes	2018-12-08 00:00:00	5	This is an auto-scheduled activity	incomplete	1
459	36	Work on "Final Project" for 1 minutes	2018-12-09 00:00:00	5	This is an auto-scheduled activity	incomplete	1
460	36	Work on "Final Project" for 1 minutes	2018-12-10 00:00:00	5	This is an auto-scheduled activity	incomplete	1
461	36	Work on "Final Project" for 1 minutes	2018-12-11 00:00:00	5	This is an auto-scheduled activity	incomplete	1
462	36	Work on "Final Project" for 1 minutes	2018-12-12 00:00:00	5	This is an auto-scheduled activity	incomplete	1
463	36	Work on "Final Project" for 1 minutes	2018-12-13 00:00:00	5	This is an auto-scheduled activity	incomplete	1
464	36	Work on "Final Project" for 1 minutes	2018-12-14 00:00:00	5	This is an auto-scheduled activity	incomplete	1
465	36	Work on "Final Project" for 1 minutes	2018-12-15 00:00:00	5	This is an auto-scheduled activity	incomplete	1
466	36	Work on "Final Project" for 1 minutes	2018-12-16 00:00:00	5	This is an auto-scheduled activity	incomplete	1
467	36	Work on "Final Project" for 1 minutes	2018-12-17 00:00:00	5	This is an auto-scheduled activity	incomplete	1
468	36	Work on "Final Project" for 1 minutes	2018-12-18 00:00:00	5	This is an auto-scheduled activity	incomplete	1
469	36	Work on "Final Project" for 1 minutes	2018-12-19 00:00:00	5	This is an auto-scheduled activity	incomplete	1
470	36	Work on "Final Project" for 1 minutes	2018-12-20 00:00:00	5	This is an auto-scheduled activity	incomplete	1
471	36	Work on "Final Project" for 1 minutes	2018-12-21 00:00:00	5	This is an auto-scheduled activity	incomplete	1
472	36	Work on "Final Project" for 1 minutes	2018-12-22 00:00:00	5	This is an auto-scheduled activity	incomplete	1
473	36	Work on "Final Project" for 1 minutes	2018-12-23 00:00:00	5	This is an auto-scheduled activity	incomplete	1
474	36	Work on "Final Project" for 1 minutes	2018-12-24 00:00:00	5	This is an auto-scheduled activity	incomplete	1
475	36	Work on "Final Project" for 1 minutes	2018-12-25 00:00:00	5	This is an auto-scheduled activity	incomplete	1
476	36	Work on "Final Project" for 1 minutes	2018-12-26 00:00:00	5	This is an auto-scheduled activity	incomplete	1
477	36	Work on "Final Project" for 1 minutes	2018-12-27 00:00:00	5	This is an auto-scheduled activity	incomplete	1
478	36	Work on "Final Project" for 1 minutes	2018-12-28 00:00:00	5	This is an auto-scheduled activity	incomplete	1
479	36	Work on "Final Project" for 1 minutes	2018-12-29 00:00:00	5	This is an auto-scheduled activity	incomplete	1
480	36	Work on "Final Project" for 1 minutes	2018-12-30 00:00:00	5	This is an auto-scheduled activity	incomplete	1
481	36	Work on "Final Project" for 1 minutes	2018-12-31 00:00:00	5	This is an auto-scheduled activity	incomplete	1
482	36	Work on "Final Project" for 1 minutes	2019-01-01 00:00:00	5	This is an auto-scheduled activity	incomplete	1
483	36	Work on "Final Project" for 1 minutes	2019-01-02 00:00:00	5	This is an auto-scheduled activity	incomplete	1
484	36	Work on "Final Project" for 1 minutes	2019-01-03 00:00:00	5	This is an auto-scheduled activity	incomplete	1
485	36	Work on "Final Project" for 1 minutes	2019-01-04 00:00:00	5	This is an auto-scheduled activity	incomplete	1
486	36	Work on "Final Project" for 1 minutes	2019-01-05 00:00:00	5	This is an auto-scheduled activity	incomplete	1
487	36	Work on "Final Project" for 1 minutes	2019-01-06 00:00:00	5	This is an auto-scheduled activity	incomplete	1
488	36	Work on "Final Project" for 1 minutes	2019-01-07 00:00:00	5	This is an auto-scheduled activity	incomplete	1
489	36	Work on "Final Project" for 1 minutes	2019-01-08 00:00:00	5	This is an auto-scheduled activity	incomplete	1
490	36	Work on "Final Project" for 1 minutes	2019-01-09 00:00:00	5	This is an auto-scheduled activity	incomplete	1
491	36	Work on "Final Project" for 1 minutes	2019-01-10 00:00:00	5	This is an auto-scheduled activity	incomplete	1
492	36	Work on "Final Project" for 1 minutes	2019-01-11 00:00:00	5	This is an auto-scheduled activity	incomplete	1
493	36	Work on "Final Project" for 1 minutes	2019-01-12 00:00:00	5	This is an auto-scheduled activity	incomplete	1
494	36	Work on "Final Project" for 1 minutes	2019-01-13 00:00:00	5	This is an auto-scheduled activity	incomplete	1
495	36	Work on "Final Project" for 1 minutes	2019-01-14 00:00:00	5	This is an auto-scheduled activity	incomplete	1
496	36	Work on "Final Project" for 1 minutes	2019-01-15 00:00:00	5	This is an auto-scheduled activity	incomplete	1
497	36	Work on "Final Project" for 1 minutes	2019-01-16 00:00:00	5	This is an auto-scheduled activity	incomplete	1
498	36	Work on "Final Project" for 1 minutes	2019-01-17 00:00:00	5	This is an auto-scheduled activity	incomplete	1
499	36	Work on "Final Project" for 1 minutes	2019-01-18 00:00:00	5	This is an auto-scheduled activity	incomplete	1
500	36	Work on "Final Project" for 1 minutes	2019-01-19 00:00:00	5	This is an auto-scheduled activity	incomplete	1
501	36	Work on "Final Project" for 1 minutes	2019-01-20 00:00:00	5	This is an auto-scheduled activity	incomplete	1
502	36	Work on "Final Project" for 1 minutes	2019-01-21 00:00:00	5	This is an auto-scheduled activity	incomplete	1
503	36	Work on "Final Project" for 1 minutes	2019-01-22 00:00:00	5	This is an auto-scheduled activity	incomplete	1
504	36	Work on "Final Project" for 1 minutes	2019-01-23 00:00:00	5	This is an auto-scheduled activity	incomplete	1
505	36	Work on "Final Project" for 1 minutes	2019-01-24 00:00:00	5	This is an auto-scheduled activity	incomplete	1
506	36	Work on "Final Project" for 1 minutes	2019-01-25 00:00:00	5	This is an auto-scheduled activity	incomplete	1
507	36	Work on "Final Project" for 1 minutes	2019-01-26 00:00:00	5	This is an auto-scheduled activity	incomplete	1
508	36	Work on "Final Project" for 1 minutes	2019-01-27 00:00:00	5	This is an auto-scheduled activity	incomplete	1
509	36	Work on "Final Project" for 1 minutes	2019-01-28 00:00:00	5	This is an auto-scheduled activity	incomplete	1
510	36	Work on "Final Project" for 1 minutes	2019-01-29 00:00:00	5	This is an auto-scheduled activity	incomplete	1
511	36	Work on "Final Project" for 1 minutes	2019-01-30 00:00:00	5	This is an auto-scheduled activity	incomplete	1
512	36	Work on "Final Project" for 1 minutes	2019-01-31 00:00:00	5	This is an auto-scheduled activity	incomplete	1
513	36	Work on "Final Project" for 1 minutes	2019-02-01 00:00:00	5	This is an auto-scheduled activity	incomplete	1
514	36	Work on "Final Project" for 1 minutes	2019-02-02 00:00:00	5	This is an auto-scheduled activity	incomplete	1
515	36	Work on "Final Project" for 1 minutes	2019-02-03 00:00:00	5	This is an auto-scheduled activity	incomplete	1
516	36	Work on "Final Project" for 1 minutes	2019-02-04 00:00:00	5	This is an auto-scheduled activity	incomplete	1
517	36	Work on "Final Project" for 1 minutes	2019-02-05 00:00:00	5	This is an auto-scheduled activity	incomplete	1
518	36	Work on "Final Project" for 1 minutes	2019-02-06 00:00:00	5	This is an auto-scheduled activity	incomplete	1
519	36	Work on "Final Project" for 1 minutes	2019-02-07 00:00:00	5	This is an auto-scheduled activity	incomplete	1
520	36	Work on "Final Project" for 1 minutes	2019-02-08 00:00:00	5	This is an auto-scheduled activity	incomplete	1
521	36	Work on "Final Project" for 1 minutes	2019-02-09 00:00:00	5	This is an auto-scheduled activity	incomplete	1
522	36	Work on "Final Project" for 1 minutes	2019-02-10 00:00:00	5	This is an auto-scheduled activity	incomplete	1
523	36	Work on "Final Project" for 1 minutes	2019-02-11 00:00:00	5	This is an auto-scheduled activity	incomplete	1
524	36	Work on "Final Project" for 1 minutes	2019-02-12 00:00:00	5	This is an auto-scheduled activity	incomplete	1
525	36	Work on "Final Project" for 1 minutes	2019-02-13 00:00:00	5	This is an auto-scheduled activity	incomplete	1
526	36	Work on "Final Project" for 1 minutes	2019-02-14 00:00:00	5	This is an auto-scheduled activity	incomplete	1
527	36	Work on "Final Project" for 1 minutes	2019-02-15 00:00:00	5	This is an auto-scheduled activity	incomplete	1
528	36	Work on "Final Project" for 1 minutes	2019-02-16 00:00:00	5	This is an auto-scheduled activity	incomplete	1
529	36	Work on "Final Project" for 1 minutes	2019-02-17 00:00:00	5	This is an auto-scheduled activity	incomplete	1
530	36	Work on "Final Project" for 1 minutes	2019-02-18 00:00:00	5	This is an auto-scheduled activity	incomplete	1
531	36	Work on "Final Project" for 1 minutes	2019-02-19 00:00:00	5	This is an auto-scheduled activity	incomplete	1
532	36	Work on "Final Project" for 1 minutes	2019-02-20 00:00:00	5	This is an auto-scheduled activity	incomplete	1
533	36	Work on "Final Project" for 1 minutes	2019-02-21 00:00:00	5	This is an auto-scheduled activity	incomplete	1
534	36	Work on "Final Project" for 1 minutes	2019-02-22 00:00:00	5	This is an auto-scheduled activity	incomplete	1
535	36	Work on "Final Project" for 1 minutes	2019-02-23 00:00:00	5	This is an auto-scheduled activity	incomplete	1
536	36	Work on "Final Project" for 1 minutes	2019-02-24 00:00:00	5	This is an auto-scheduled activity	incomplete	1
537	36	Work on "Final Project" for 1 minutes	2019-02-25 00:00:00	5	This is an auto-scheduled activity	incomplete	1
538	36	Work on "Final Project" for 1 minutes	2019-02-26 00:00:00	5	This is an auto-scheduled activity	incomplete	1
539	36	Work on "Final Project" for 1 minutes	2019-02-27 00:00:00	5	This is an auto-scheduled activity	incomplete	1
540	36	Work on "Final Project" for 1 minutes	2019-02-28 00:00:00	5	This is an auto-scheduled activity	incomplete	1
541	36	Work on "Final Project" for 1 minutes	2019-03-01 00:00:00	5	This is an auto-scheduled activity	incomplete	1
542	36	Work on "Final Project" for 1 minutes	2019-03-02 00:00:00	5	This is an auto-scheduled activity	incomplete	1
543	36	Work on "Final Project" for 1 minutes	2019-03-03 00:00:00	5	This is an auto-scheduled activity	incomplete	1
544	36	Work on "Final Project" for 1 minutes	2019-03-04 00:00:00	5	This is an auto-scheduled activity	incomplete	1
545	36	Work on "Final Project" for 1 minutes	2019-03-05 00:00:00	5	This is an auto-scheduled activity	incomplete	1
546	36	Work on "Final Project" for 1 minutes	2019-03-06 00:00:00	5	This is an auto-scheduled activity	incomplete	1
547	36	Work on "Final Project" for 1 minutes	2019-03-07 00:00:00	5	This is an auto-scheduled activity	incomplete	1
548	36	Work on "Final Project" for 1 minutes	2019-03-08 00:00:00	5	This is an auto-scheduled activity	incomplete	1
549	36	Work on "Final Project" for 1 minutes	2019-03-09 00:00:00	5	This is an auto-scheduled activity	incomplete	1
550	36	Work on "Final Project" for 1 minutes	2019-03-10 00:00:00	5	This is an auto-scheduled activity	incomplete	1
551	36	Work on "Final Project" for 1 minutes	2019-03-11 00:00:00	5	This is an auto-scheduled activity	incomplete	1
552	36	Work on "Final Project" for 1 minutes	2019-03-12 00:00:00	5	This is an auto-scheduled activity	incomplete	1
553	36	Work on "Final Project" for 1 minutes	2019-03-13 00:00:00	5	This is an auto-scheduled activity	incomplete	1
554	36	Work on "Final Project" for 1 minutes	2019-03-14 00:00:00	5	This is an auto-scheduled activity	incomplete	1
555	36	Work on "Final Project" for 1 minutes	2019-03-15 00:00:00	5	This is an auto-scheduled activity	incomplete	1
556	36	Work on "Final Project" for 1 minutes	2019-03-16 00:00:00	5	This is an auto-scheduled activity	incomplete	1
557	36	Work on "Final Project" for 1 minutes	2019-03-17 00:00:00	5	This is an auto-scheduled activity	incomplete	1
558	36	Work on "Final Project" for 1 minutes	2019-03-18 00:00:00	5	This is an auto-scheduled activity	incomplete	1
559	36	Work on "Final Project" for 1 minutes	2019-03-19 00:00:00	5	This is an auto-scheduled activity	incomplete	1
560	36	Work on "Final Project" for 1 minutes	2019-03-20 00:00:00	5	This is an auto-scheduled activity	incomplete	1
561	36	Work on "Final Project" for 1 minutes	2019-03-21 00:00:00	5	This is an auto-scheduled activity	incomplete	1
562	36	Work on "Final Project" for 1 minutes	2019-03-22 00:00:00	5	This is an auto-scheduled activity	incomplete	1
563	36	Work on "Final Project" for 1 minutes	2019-03-23 00:00:00	5	This is an auto-scheduled activity	incomplete	1
564	36	Work on "Final Project" for 1 minutes	2019-03-24 00:00:00	5	This is an auto-scheduled activity	incomplete	1
565	36	Work on "Final Project" for 1 minutes	2019-03-25 00:00:00	5	This is an auto-scheduled activity	incomplete	1
566	36	Work on "Final Project" for 1 minutes	2019-03-26 00:00:00	5	This is an auto-scheduled activity	incomplete	1
567	36	Work on "Final Project" for 1 minutes	2019-03-27 00:00:00	5	This is an auto-scheduled activity	incomplete	1
568	36	Work on "Final Project" for 1 minutes	2019-03-28 00:00:00	5	This is an auto-scheduled activity	incomplete	1
569	36	Work on "Final Project" for 1 minutes	2019-03-29 00:00:00	5	This is an auto-scheduled activity	incomplete	1
570	36	Work on "Final Project" for 1 minutes	2019-03-30 00:00:00	5	This is an auto-scheduled activity	incomplete	1
571	36	Work on "Final Project" for 1 minutes	2019-03-31 00:00:00	5	This is an auto-scheduled activity	incomplete	1
572	36	Work on "Final Project" for 1 minutes	2019-04-01 00:00:00	5	This is an auto-scheduled activity	incomplete	1
573	36	Work on "Final Project" for 1 minutes	2019-04-02 00:00:00	5	This is an auto-scheduled activity	incomplete	1
574	36	Work on "Final Project" for 1 minutes	2019-04-03 00:00:00	5	This is an auto-scheduled activity	incomplete	1
575	36	Work on "Final Project" for 1 minutes	2019-04-04 00:00:00	5	This is an auto-scheduled activity	incomplete	1
576	36	Work on "Final Project" for 1 minutes	2019-04-05 00:00:00	5	This is an auto-scheduled activity	incomplete	1
577	36	Work on "Final Project" for 1 minutes	2019-04-06 00:00:00	5	This is an auto-scheduled activity	incomplete	1
578	36	Work on "Final Project" for 1 minutes	2019-04-07 00:00:00	5	This is an auto-scheduled activity	incomplete	1
579	36	Work on "Final Project" for 1 minutes	2019-04-08 00:00:00	5	This is an auto-scheduled activity	incomplete	1
580	36	Work on "Final Project" for 1 minutes	2019-04-09 00:00:00	5	This is an auto-scheduled activity	incomplete	1
581	36	Work on "Final Project" for 1 minutes	2019-04-10 00:00:00	5	This is an auto-scheduled activity	incomplete	1
582	36	Work on "Final Project" for 1 minutes	2019-04-11 00:00:00	5	This is an auto-scheduled activity	incomplete	1
583	36	Work on "Final Project" for 1 minutes	2019-04-12 00:00:00	5	This is an auto-scheduled activity	incomplete	1
584	36	Work on "Final Project" for 1 minutes	2019-04-13 00:00:00	5	This is an auto-scheduled activity	incomplete	1
585	36	Work on "Final Project" for 1 minutes	2019-04-14 00:00:00	5	This is an auto-scheduled activity	incomplete	1
586	36	Work on "Final Project" for 1 minutes	2019-04-15 00:00:00	5	This is an auto-scheduled activity	incomplete	1
587	36	Work on "Final Project" for 1 minutes	2019-04-16 00:00:00	5	This is an auto-scheduled activity	incomplete	1
588	36	Work on "Final Project" for 1 minutes	2019-04-17 00:00:00	5	This is an auto-scheduled activity	incomplete	1
589	36	Work on "Final Project" for 1 minutes	2019-04-18 00:00:00	5	This is an auto-scheduled activity	incomplete	1
590	36	Work on "Final Project" for 1 minutes	2019-04-19 00:00:00	5	This is an auto-scheduled activity	incomplete	1
591	36	Work on "Final Project" for 1 minutes	2019-04-20 00:00:00	5	This is an auto-scheduled activity	incomplete	1
592	36	Work on "Final Project" for 1 minutes	2019-04-21 00:00:00	5	This is an auto-scheduled activity	incomplete	1
593	36	Work on "Final Project" for 1 minutes	2019-04-22 00:00:00	5	This is an auto-scheduled activity	incomplete	1
594	36	Work on "Final Project" for 1 minutes	2019-04-23 00:00:00	5	This is an auto-scheduled activity	incomplete	1
595	36	Work on "Final Project" for 1 minutes	2019-04-24 00:00:00	5	This is an auto-scheduled activity	incomplete	1
596	36	Work on "Final Project" for 1 minutes	2019-04-25 00:00:00	5	This is an auto-scheduled activity	incomplete	1
597	36	Work on "Final Project" for 1 minutes	2019-04-26 00:00:00	5	This is an auto-scheduled activity	incomplete	1
598	36	Work on "Final Project" for 1 minutes	2019-04-27 00:00:00	5	This is an auto-scheduled activity	incomplete	1
599	36	Work on "Final Project" for 1 minutes	2019-04-28 00:00:00	5	This is an auto-scheduled activity	incomplete	1
600	36	Work on "Final Project" for 1 minutes	2019-04-29 00:00:00	5	This is an auto-scheduled activity	incomplete	1
601	36	Work on "Final Project" for 1 minutes	2019-04-30 00:00:00	5	This is an auto-scheduled activity	incomplete	1
602	36	Work on "Final Project" for 1 minutes	2019-05-01 00:00:00	5	This is an auto-scheduled activity	incomplete	1
603	36	Work on "Final Project" for 1 minutes	2019-05-02 00:00:00	5	This is an auto-scheduled activity	incomplete	1
604	36	Work on "Final Project" for 1 minutes	2019-05-03 00:00:00	5	This is an auto-scheduled activity	incomplete	1
605	36	Work on "Final Project" for 1 minutes	2019-05-04 00:00:00	5	This is an auto-scheduled activity	incomplete	1
606	36	Work on "Final Project" for 1 minutes	2019-05-05 00:00:00	5	This is an auto-scheduled activity	incomplete	1
607	36	Work on "Final Project" for 1 minutes	2019-05-06 00:00:00	5	This is an auto-scheduled activity	incomplete	1
608	36	Work on "Final Project" for 1 minutes	2019-05-07 00:00:00	5	This is an auto-scheduled activity	incomplete	1
609	36	Work on "Final Project" for 1 minutes	2019-05-08 00:00:00	5	This is an auto-scheduled activity	incomplete	1
610	18	Work on "Abstract" for 82 minutes	2018-05-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
611	18	Work on "Abstract" for 82 minutes	2018-05-11 00:00:00	1	This is an auto-scheduled activity	incomplete	82
612	18	Work on "Abstract" for 82 minutes	2018-05-12 00:00:00	1	This is an auto-scheduled activity	incomplete	82
614	18	Work on "Abstract" for 82 minutes	2018-05-14 00:00:00	1	This is an auto-scheduled activity	incomplete	82
615	18	Work on "Abstract" for 82 minutes	2018-05-15 00:00:00	1	This is an auto-scheduled activity	incomplete	82
616	18	Work on "Abstract" for 82 minutes	2018-05-16 00:00:00	1	This is an auto-scheduled activity	incomplete	82
617	18	Work on "Abstract" for 82 minutes	2018-05-17 00:00:00	1	This is an auto-scheduled activity	incomplete	82
618	18	Work on "Abstract" for 82 minutes	2018-05-18 00:00:00	1	This is an auto-scheduled activity	incomplete	82
619	18	Work on "Abstract" for 82 minutes	2018-05-19 00:00:00	1	This is an auto-scheduled activity	incomplete	82
620	18	Work on "Abstract" for 82 minutes	2018-05-20 00:00:00	1	This is an auto-scheduled activity	incomplete	82
621	18	Work on "Abstract" for 82 minutes	2018-05-21 00:00:00	1	This is an auto-scheduled activity	incomplete	82
622	18	Work on "Abstract" for 82 minutes	2018-05-22 00:00:00	1	This is an auto-scheduled activity	incomplete	82
623	18	Work on "Abstract" for 82 minutes	2018-05-23 00:00:00	1	This is an auto-scheduled activity	incomplete	82
624	18	Work on "Abstract" for 82 minutes	2018-05-24 00:00:00	1	This is an auto-scheduled activity	incomplete	82
625	18	Work on "Abstract" for 82 minutes	2018-05-25 00:00:00	1	This is an auto-scheduled activity	incomplete	82
626	18	Work on "Abstract" for 82 minutes	2018-05-26 00:00:00	1	This is an auto-scheduled activity	incomplete	82
627	18	Work on "Abstract" for 82 minutes	2018-05-27 00:00:00	1	This is an auto-scheduled activity	incomplete	82
628	18	Work on "Abstract" for 82 minutes	2018-05-28 00:00:00	1	This is an auto-scheduled activity	incomplete	82
629	18	Work on "Abstract" for 82 minutes	2018-05-29 00:00:00	1	This is an auto-scheduled activity	incomplete	82
630	18	Work on "Abstract" for 82 minutes	2018-05-30 00:00:00	1	This is an auto-scheduled activity	incomplete	82
631	18	Work on "Abstract" for 82 minutes	2018-05-31 00:00:00	1	This is an auto-scheduled activity	incomplete	82
632	18	Work on "Abstract" for 82 minutes	2018-06-01 00:00:00	1	This is an auto-scheduled activity	incomplete	82
633	18	Work on "Abstract" for 82 minutes	2018-06-02 00:00:00	1	This is an auto-scheduled activity	incomplete	82
634	18	Work on "Abstract" for 82 minutes	2018-06-03 00:00:00	1	This is an auto-scheduled activity	incomplete	82
635	18	Work on "Abstract" for 82 minutes	2018-06-04 00:00:00	1	This is an auto-scheduled activity	incomplete	82
636	18	Work on "Abstract" for 82 minutes	2018-06-05 00:00:00	1	This is an auto-scheduled activity	incomplete	82
637	18	Work on "Abstract" for 82 minutes	2018-06-06 00:00:00	1	This is an auto-scheduled activity	incomplete	82
638	18	Work on "Abstract" for 82 minutes	2018-06-07 00:00:00	1	This is an auto-scheduled activity	incomplete	82
639	18	Work on "Abstract" for 82 minutes	2018-06-08 00:00:00	1	This is an auto-scheduled activity	incomplete	82
640	18	Work on "Abstract" for 82 minutes	2018-06-09 00:00:00	1	This is an auto-scheduled activity	incomplete	82
641	18	Work on "Abstract" for 82 minutes	2018-06-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
642	18	Work on "Abstract" for 82 minutes	2018-06-11 00:00:00	1	This is an auto-scheduled activity	incomplete	82
643	18	Work on "Abstract" for 82 minutes	2018-06-12 00:00:00	1	This is an auto-scheduled activity	incomplete	82
644	18	Work on "Abstract" for 82 minutes	2018-06-13 00:00:00	1	This is an auto-scheduled activity	incomplete	82
645	18	Work on "Abstract" for 82 minutes	2018-06-14 00:00:00	1	This is an auto-scheduled activity	incomplete	82
646	18	Work on "Abstract" for 82 minutes	2018-06-15 00:00:00	1	This is an auto-scheduled activity	incomplete	82
647	18	Work on "Abstract" for 82 minutes	2018-06-16 00:00:00	1	This is an auto-scheduled activity	incomplete	82
648	18	Work on "Abstract" for 82 minutes	2018-06-17 00:00:00	1	This is an auto-scheduled activity	incomplete	82
649	18	Work on "Abstract" for 82 minutes	2018-06-18 00:00:00	1	This is an auto-scheduled activity	incomplete	82
650	18	Work on "Abstract" for 82 minutes	2018-06-19 00:00:00	1	This is an auto-scheduled activity	incomplete	82
651	18	Work on "Abstract" for 82 minutes	2018-06-20 00:00:00	1	This is an auto-scheduled activity	incomplete	82
652	18	Work on "Abstract" for 82 minutes	2018-06-21 00:00:00	1	This is an auto-scheduled activity	incomplete	82
653	18	Work on "Abstract" for 82 minutes	2018-06-22 00:00:00	1	This is an auto-scheduled activity	incomplete	82
654	18	Work on "Abstract" for 82 minutes	2018-06-23 00:00:00	1	This is an auto-scheduled activity	incomplete	82
655	18	Work on "Abstract" for 82 minutes	2018-06-24 00:00:00	1	This is an auto-scheduled activity	incomplete	82
656	18	Work on "Abstract" for 82 minutes	2018-06-25 00:00:00	1	This is an auto-scheduled activity	incomplete	82
657	18	Work on "Abstract" for 82 minutes	2018-06-26 00:00:00	1	This is an auto-scheduled activity	incomplete	82
658	18	Work on "Abstract" for 82 minutes	2018-06-27 00:00:00	1	This is an auto-scheduled activity	incomplete	82
659	18	Work on "Abstract" for 82 minutes	2018-06-28 00:00:00	1	This is an auto-scheduled activity	incomplete	82
660	18	Work on "Abstract" for 82 minutes	2018-06-29 00:00:00	1	This is an auto-scheduled activity	incomplete	82
661	18	Work on "Abstract" for 82 minutes	2018-06-30 00:00:00	1	This is an auto-scheduled activity	incomplete	82
662	18	Work on "Abstract" for 82 minutes	2018-07-01 00:00:00	1	This is an auto-scheduled activity	incomplete	82
663	18	Work on "Abstract" for 82 minutes	2018-07-02 00:00:00	1	This is an auto-scheduled activity	incomplete	82
664	18	Work on "Abstract" for 82 minutes	2018-07-03 00:00:00	1	This is an auto-scheduled activity	incomplete	82
665	18	Work on "Abstract" for 82 minutes	2018-07-04 00:00:00	1	This is an auto-scheduled activity	incomplete	82
666	18	Work on "Abstract" for 82 minutes	2018-07-05 00:00:00	1	This is an auto-scheduled activity	incomplete	82
667	18	Work on "Abstract" for 82 minutes	2018-07-06 00:00:00	1	This is an auto-scheduled activity	incomplete	82
668	18	Work on "Abstract" for 82 minutes	2018-07-07 00:00:00	1	This is an auto-scheduled activity	incomplete	82
669	18	Work on "Abstract" for 82 minutes	2018-07-08 00:00:00	1	This is an auto-scheduled activity	incomplete	82
670	18	Work on "Abstract" for 82 minutes	2018-07-09 00:00:00	1	This is an auto-scheduled activity	incomplete	82
671	18	Work on "Abstract" for 82 minutes	2018-07-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
672	18	Work on "Abstract" for 82 minutes	2018-07-11 00:00:00	1	This is an auto-scheduled activity	incomplete	82
673	18	Work on "Abstract" for 82 minutes	2018-07-12 00:00:00	1	This is an auto-scheduled activity	incomplete	82
674	18	Work on "Abstract" for 82 minutes	2018-07-13 00:00:00	1	This is an auto-scheduled activity	incomplete	82
675	18	Work on "Abstract" for 82 minutes	2018-07-14 00:00:00	1	This is an auto-scheduled activity	incomplete	82
676	18	Work on "Abstract" for 82 minutes	2018-07-15 00:00:00	1	This is an auto-scheduled activity	incomplete	82
677	18	Work on "Abstract" for 82 minutes	2018-07-16 00:00:00	1	This is an auto-scheduled activity	incomplete	82
678	18	Work on "Abstract" for 82 minutes	2018-07-17 00:00:00	1	This is an auto-scheduled activity	incomplete	82
679	18	Work on "Abstract" for 82 minutes	2018-07-18 00:00:00	1	This is an auto-scheduled activity	incomplete	82
680	18	Work on "Abstract" for 82 minutes	2018-07-19 00:00:00	1	This is an auto-scheduled activity	incomplete	82
681	18	Work on "Abstract" for 82 minutes	2018-07-20 00:00:00	1	This is an auto-scheduled activity	incomplete	82
682	18	Work on "Abstract" for 82 minutes	2018-07-21 00:00:00	1	This is an auto-scheduled activity	incomplete	82
683	18	Work on "Abstract" for 82 minutes	2018-07-22 00:00:00	1	This is an auto-scheduled activity	incomplete	82
684	18	Work on "Abstract" for 82 minutes	2018-07-23 00:00:00	1	This is an auto-scheduled activity	incomplete	82
685	18	Work on "Abstract" for 82 minutes	2018-07-24 00:00:00	1	This is an auto-scheduled activity	incomplete	82
686	18	Work on "Abstract" for 82 minutes	2018-07-25 00:00:00	1	This is an auto-scheduled activity	incomplete	82
687	18	Work on "Abstract" for 82 minutes	2018-07-26 00:00:00	1	This is an auto-scheduled activity	incomplete	82
688	18	Work on "Abstract" for 82 minutes	2018-07-27 00:00:00	1	This is an auto-scheduled activity	incomplete	82
689	18	Work on "Abstract" for 82 minutes	2018-07-28 00:00:00	1	This is an auto-scheduled activity	incomplete	82
690	18	Work on "Abstract" for 82 minutes	2018-07-29 00:00:00	1	This is an auto-scheduled activity	incomplete	82
691	18	Work on "Abstract" for 82 minutes	2018-07-30 00:00:00	1	This is an auto-scheduled activity	incomplete	82
692	18	Work on "Abstract" for 82 minutes	2018-07-31 00:00:00	1	This is an auto-scheduled activity	incomplete	82
693	18	Work on "Abstract" for 82 minutes	2018-08-01 00:00:00	1	This is an auto-scheduled activity	incomplete	82
694	18	Work on "Abstract" for 82 minutes	2018-08-02 00:00:00	1	This is an auto-scheduled activity	incomplete	82
695	18	Work on "Abstract" for 82 minutes	2018-08-03 00:00:00	1	This is an auto-scheduled activity	incomplete	82
696	18	Work on "Abstract" for 82 minutes	2018-08-04 00:00:00	1	This is an auto-scheduled activity	incomplete	82
697	18	Work on "Abstract" for 82 minutes	2018-08-05 00:00:00	1	This is an auto-scheduled activity	incomplete	82
698	18	Work on "Abstract" for 82 minutes	2018-08-06 00:00:00	1	This is an auto-scheduled activity	incomplete	82
699	18	Work on "Abstract" for 82 minutes	2018-08-07 00:00:00	1	This is an auto-scheduled activity	incomplete	82
700	18	Work on "Abstract" for 82 minutes	2018-08-08 00:00:00	1	This is an auto-scheduled activity	incomplete	82
701	18	Work on "Abstract" for 82 minutes	2018-08-09 00:00:00	1	This is an auto-scheduled activity	incomplete	82
702	18	Work on "Abstract" for 82 minutes	2018-08-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
703	18	Work on "Abstract" for 82 minutes	2018-08-11 00:00:00	1	This is an auto-scheduled activity	incomplete	82
704	18	Work on "Abstract" for 82 minutes	2018-08-12 00:00:00	1	This is an auto-scheduled activity	incomplete	82
705	18	Work on "Abstract" for 82 minutes	2018-08-13 00:00:00	1	This is an auto-scheduled activity	incomplete	82
706	18	Work on "Abstract" for 82 minutes	2018-08-14 00:00:00	1	This is an auto-scheduled activity	incomplete	82
707	18	Work on "Abstract" for 82 minutes	2018-08-15 00:00:00	1	This is an auto-scheduled activity	incomplete	82
708	18	Work on "Abstract" for 82 minutes	2018-08-16 00:00:00	1	This is an auto-scheduled activity	incomplete	82
709	18	Work on "Abstract" for 82 minutes	2018-08-17 00:00:00	1	This is an auto-scheduled activity	incomplete	82
710	18	Work on "Abstract" for 82 minutes	2018-08-18 00:00:00	1	This is an auto-scheduled activity	incomplete	82
711	18	Work on "Abstract" for 82 minutes	2018-08-19 00:00:00	1	This is an auto-scheduled activity	incomplete	82
712	18	Work on "Abstract" for 82 minutes	2018-08-20 00:00:00	1	This is an auto-scheduled activity	incomplete	82
713	18	Work on "Abstract" for 82 minutes	2018-08-21 00:00:00	1	This is an auto-scheduled activity	incomplete	82
714	18	Work on "Abstract" for 82 minutes	2018-08-22 00:00:00	1	This is an auto-scheduled activity	incomplete	82
715	18	Work on "Abstract" for 82 minutes	2018-08-23 00:00:00	1	This is an auto-scheduled activity	incomplete	82
716	18	Work on "Abstract" for 82 minutes	2018-08-24 00:00:00	1	This is an auto-scheduled activity	incomplete	82
717	18	Work on "Abstract" for 82 minutes	2018-08-25 00:00:00	1	This is an auto-scheduled activity	incomplete	82
718	18	Work on "Abstract" for 82 minutes	2018-08-26 00:00:00	1	This is an auto-scheduled activity	incomplete	82
719	18	Work on "Abstract" for 82 minutes	2018-08-27 00:00:00	1	This is an auto-scheduled activity	incomplete	82
720	18	Work on "Abstract" for 82 minutes	2018-08-28 00:00:00	1	This is an auto-scheduled activity	incomplete	82
721	18	Work on "Abstract" for 82 minutes	2018-08-29 00:00:00	1	This is an auto-scheduled activity	incomplete	82
722	18	Work on "Abstract" for 82 minutes	2018-08-30 00:00:00	1	This is an auto-scheduled activity	incomplete	82
723	18	Work on "Abstract" for 82 minutes	2018-08-31 00:00:00	1	This is an auto-scheduled activity	incomplete	82
724	18	Work on "Abstract" for 82 minutes	2018-09-01 00:00:00	1	This is an auto-scheduled activity	incomplete	82
725	18	Work on "Abstract" for 82 minutes	2018-09-02 00:00:00	1	This is an auto-scheduled activity	incomplete	82
726	18	Work on "Abstract" for 82 minutes	2018-09-03 00:00:00	1	This is an auto-scheduled activity	incomplete	82
727	18	Work on "Abstract" for 82 minutes	2018-09-04 00:00:00	1	This is an auto-scheduled activity	incomplete	82
728	18	Work on "Abstract" for 82 minutes	2018-09-05 00:00:00	1	This is an auto-scheduled activity	incomplete	82
729	18	Work on "Abstract" for 82 minutes	2018-09-06 00:00:00	1	This is an auto-scheduled activity	incomplete	82
730	18	Work on "Abstract" for 82 minutes	2018-09-07 00:00:00	1	This is an auto-scheduled activity	incomplete	82
731	18	Work on "Abstract" for 82 minutes	2018-09-08 00:00:00	1	This is an auto-scheduled activity	incomplete	82
732	18	Work on "Abstract" for 82 minutes	2018-09-09 00:00:00	1	This is an auto-scheduled activity	incomplete	82
733	18	Work on "Abstract" for 82 minutes	2018-09-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
734	18	Work on "Abstract" for 82 minutes	2018-09-11 00:00:00	1	This is an auto-scheduled activity	incomplete	82
735	18	Work on "Abstract" for 82 minutes	2018-09-12 00:00:00	1	This is an auto-scheduled activity	incomplete	82
736	18	Work on "Abstract" for 82 minutes	2018-09-13 00:00:00	1	This is an auto-scheduled activity	incomplete	82
737	18	Work on "Abstract" for 82 minutes	2018-09-14 00:00:00	1	This is an auto-scheduled activity	incomplete	82
738	18	Work on "Abstract" for 82 minutes	2018-09-15 00:00:00	1	This is an auto-scheduled activity	incomplete	82
739	18	Work on "Abstract" for 82 minutes	2018-09-16 00:00:00	1	This is an auto-scheduled activity	incomplete	82
740	18	Work on "Abstract" for 82 minutes	2018-09-17 00:00:00	1	This is an auto-scheduled activity	incomplete	82
741	18	Work on "Abstract" for 82 minutes	2018-09-18 00:00:00	1	This is an auto-scheduled activity	incomplete	82
742	18	Work on "Abstract" for 82 minutes	2018-09-19 00:00:00	1	This is an auto-scheduled activity	incomplete	82
743	18	Work on "Abstract" for 82 minutes	2018-09-20 00:00:00	1	This is an auto-scheduled activity	incomplete	82
744	18	Work on "Abstract" for 82 minutes	2018-09-21 00:00:00	1	This is an auto-scheduled activity	incomplete	82
745	18	Work on "Abstract" for 82 minutes	2018-09-22 00:00:00	1	This is an auto-scheduled activity	incomplete	82
746	18	Work on "Abstract" for 82 minutes	2018-09-23 00:00:00	1	This is an auto-scheduled activity	incomplete	82
747	18	Work on "Abstract" for 82 minutes	2018-09-24 00:00:00	1	This is an auto-scheduled activity	incomplete	82
748	18	Work on "Abstract" for 82 minutes	2018-09-25 00:00:00	1	This is an auto-scheduled activity	incomplete	82
749	18	Work on "Abstract" for 82 minutes	2018-09-26 00:00:00	1	This is an auto-scheduled activity	incomplete	82
750	18	Work on "Abstract" for 82 minutes	2018-09-27 00:00:00	1	This is an auto-scheduled activity	incomplete	82
751	18	Work on "Abstract" for 82 minutes	2018-09-28 00:00:00	1	This is an auto-scheduled activity	incomplete	82
752	18	Work on "Abstract" for 82 minutes	2018-09-29 00:00:00	1	This is an auto-scheduled activity	incomplete	82
753	18	Work on "Abstract" for 82 minutes	2018-09-30 00:00:00	1	This is an auto-scheduled activity	incomplete	82
754	18	Work on "Abstract" for 82 minutes	2018-10-01 00:00:00	1	This is an auto-scheduled activity	incomplete	82
755	18	Work on "Abstract" for 82 minutes	2018-10-02 00:00:00	1	This is an auto-scheduled activity	incomplete	82
756	18	Work on "Abstract" for 82 minutes	2018-10-03 00:00:00	1	This is an auto-scheduled activity	incomplete	82
757	18	Work on "Abstract" for 82 minutes	2018-10-04 00:00:00	1	This is an auto-scheduled activity	incomplete	82
758	18	Work on "Abstract" for 82 minutes	2018-10-05 00:00:00	1	This is an auto-scheduled activity	incomplete	82
759	18	Work on "Abstract" for 82 minutes	2018-10-06 00:00:00	1	This is an auto-scheduled activity	incomplete	82
760	18	Work on "Abstract" for 82 minutes	2018-10-07 00:00:00	1	This is an auto-scheduled activity	incomplete	82
761	18	Work on "Abstract" for 82 minutes	2018-10-08 00:00:00	1	This is an auto-scheduled activity	incomplete	82
762	18	Work on "Abstract" for 82 minutes	2018-10-09 00:00:00	1	This is an auto-scheduled activity	incomplete	82
763	18	Work on "Abstract" for 82 minutes	2018-10-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
764	18	Work on "Abstract" for 82 minutes	2018-10-11 00:00:00	1	This is an auto-scheduled activity	incomplete	82
765	18	Work on "Abstract" for 82 minutes	2018-10-12 00:00:00	1	This is an auto-scheduled activity	incomplete	82
766	18	Work on "Abstract" for 82 minutes	2018-10-13 00:00:00	1	This is an auto-scheduled activity	incomplete	82
767	18	Work on "Abstract" for 82 minutes	2018-10-14 00:00:00	1	This is an auto-scheduled activity	incomplete	82
768	18	Work on "Abstract" for 82 minutes	2018-10-15 00:00:00	1	This is an auto-scheduled activity	incomplete	82
769	18	Work on "Abstract" for 82 minutes	2018-10-16 00:00:00	1	This is an auto-scheduled activity	incomplete	82
770	18	Work on "Abstract" for 82 minutes	2018-10-17 00:00:00	1	This is an auto-scheduled activity	incomplete	82
771	18	Work on "Abstract" for 82 minutes	2018-10-18 00:00:00	1	This is an auto-scheduled activity	incomplete	82
772	18	Work on "Abstract" for 82 minutes	2018-10-19 00:00:00	1	This is an auto-scheduled activity	incomplete	82
773	18	Work on "Abstract" for 82 minutes	2018-10-20 00:00:00	1	This is an auto-scheduled activity	incomplete	82
774	18	Work on "Abstract" for 82 minutes	2018-10-21 00:00:00	1	This is an auto-scheduled activity	incomplete	82
775	18	Work on "Abstract" for 82 minutes	2018-10-22 00:00:00	1	This is an auto-scheduled activity	incomplete	82
776	18	Work on "Abstract" for 82 minutes	2018-10-23 00:00:00	1	This is an auto-scheduled activity	incomplete	82
777	18	Work on "Abstract" for 82 minutes	2018-10-24 00:00:00	1	This is an auto-scheduled activity	incomplete	82
778	18	Work on "Abstract" for 82 minutes	2018-10-25 00:00:00	1	This is an auto-scheduled activity	incomplete	82
779	18	Work on "Abstract" for 82 minutes	2018-10-26 00:00:00	1	This is an auto-scheduled activity	incomplete	82
780	18	Work on "Abstract" for 82 minutes	2018-10-27 00:00:00	1	This is an auto-scheduled activity	incomplete	82
781	18	Work on "Abstract" for 82 minutes	2018-10-28 00:00:00	1	This is an auto-scheduled activity	incomplete	82
782	18	Work on "Abstract" for 82 minutes	2018-10-29 00:00:00	1	This is an auto-scheduled activity	incomplete	82
783	18	Work on "Abstract" for 82 minutes	2018-10-30 00:00:00	1	This is an auto-scheduled activity	incomplete	82
784	18	Work on "Abstract" for 82 minutes	2018-10-31 00:00:00	1	This is an auto-scheduled activity	incomplete	82
785	18	Work on "Abstract" for 82 minutes	2018-11-01 00:00:00	1	This is an auto-scheduled activity	incomplete	82
786	18	Work on "Abstract" for 82 minutes	2018-11-02 00:00:00	1	This is an auto-scheduled activity	incomplete	82
787	18	Work on "Abstract" for 82 minutes	2018-11-03 00:00:00	1	This is an auto-scheduled activity	incomplete	82
788	18	Work on "Abstract" for 82 minutes	2018-11-04 00:00:00	1	This is an auto-scheduled activity	incomplete	82
789	18	Work on "Abstract" for 82 minutes	2018-11-05 00:00:00	1	This is an auto-scheduled activity	incomplete	82
790	18	Work on "Abstract" for 82 minutes	2018-11-06 00:00:00	1	This is an auto-scheduled activity	incomplete	82
791	18	Work on "Abstract" for 82 minutes	2018-11-07 00:00:00	1	This is an auto-scheduled activity	incomplete	82
792	18	Work on "Abstract" for 82 minutes	2018-11-08 00:00:00	1	This is an auto-scheduled activity	incomplete	82
793	18	Work on "Abstract" for 82 minutes	2018-11-09 00:00:00	1	This is an auto-scheduled activity	incomplete	82
794	18	Work on "Abstract" for 82 minutes	2018-11-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
795	18	Work on "Abstract" for 82 minutes	2018-11-11 00:00:00	1	This is an auto-scheduled activity	incomplete	82
796	18	Work on "Abstract" for 82 minutes	2018-11-12 00:00:00	1	This is an auto-scheduled activity	incomplete	82
797	18	Work on "Abstract" for 82 minutes	2018-11-13 00:00:00	1	This is an auto-scheduled activity	incomplete	82
798	18	Work on "Abstract" for 82 minutes	2018-11-14 00:00:00	1	This is an auto-scheduled activity	incomplete	82
799	18	Work on "Abstract" for 82 minutes	2018-11-15 00:00:00	1	This is an auto-scheduled activity	incomplete	82
800	18	Work on "Abstract" for 82 minutes	2018-11-16 00:00:00	1	This is an auto-scheduled activity	incomplete	82
801	18	Work on "Abstract" for 82 minutes	2018-11-17 00:00:00	1	This is an auto-scheduled activity	incomplete	82
802	18	Work on "Abstract" for 82 minutes	2018-11-18 00:00:00	1	This is an auto-scheduled activity	incomplete	82
803	18	Work on "Abstract" for 82 minutes	2018-11-19 00:00:00	1	This is an auto-scheduled activity	incomplete	82
804	18	Work on "Abstract" for 82 minutes	2018-11-20 00:00:00	1	This is an auto-scheduled activity	incomplete	82
805	18	Work on "Abstract" for 82 minutes	2018-11-21 00:00:00	1	This is an auto-scheduled activity	incomplete	82
806	18	Work on "Abstract" for 82 minutes	2018-11-22 00:00:00	1	This is an auto-scheduled activity	incomplete	82
807	18	Work on "Abstract" for 82 minutes	2018-11-23 00:00:00	1	This is an auto-scheduled activity	incomplete	82
808	18	Work on "Abstract" for 82 minutes	2018-11-24 00:00:00	1	This is an auto-scheduled activity	incomplete	82
809	18	Work on "Abstract" for 82 minutes	2018-11-25 00:00:00	1	This is an auto-scheduled activity	incomplete	82
810	18	Work on "Abstract" for 82 minutes	2018-11-26 00:00:00	1	This is an auto-scheduled activity	incomplete	82
811	18	Work on "Abstract" for 82 minutes	2018-11-27 00:00:00	1	This is an auto-scheduled activity	incomplete	82
812	18	Work on "Abstract" for 82 minutes	2018-11-28 00:00:00	1	This is an auto-scheduled activity	incomplete	82
813	18	Work on "Abstract" for 82 minutes	2018-11-29 00:00:00	1	This is an auto-scheduled activity	incomplete	82
814	18	Work on "Abstract" for 82 minutes	2018-11-30 00:00:00	1	This is an auto-scheduled activity	incomplete	82
815	18	Work on "Abstract" for 82 minutes	2018-12-01 00:00:00	1	This is an auto-scheduled activity	incomplete	82
816	18	Work on "Abstract" for 82 minutes	2018-12-02 00:00:00	1	This is an auto-scheduled activity	incomplete	82
817	18	Work on "Abstract" for 82 minutes	2018-12-03 00:00:00	1	This is an auto-scheduled activity	incomplete	82
818	18	Work on "Abstract" for 82 minutes	2018-12-04 00:00:00	1	This is an auto-scheduled activity	incomplete	82
819	18	Work on "Abstract" for 82 minutes	2018-12-05 00:00:00	1	This is an auto-scheduled activity	incomplete	82
820	18	Work on "Abstract" for 82 minutes	2018-12-06 00:00:00	1	This is an auto-scheduled activity	incomplete	82
821	18	Work on "Abstract" for 82 minutes	2018-12-07 00:00:00	1	This is an auto-scheduled activity	incomplete	82
822	18	Work on "Abstract" for 82 minutes	2018-12-08 00:00:00	1	This is an auto-scheduled activity	incomplete	82
823	18	Work on "Abstract" for 82 minutes	2018-12-09 00:00:00	1	This is an auto-scheduled activity	incomplete	82
824	18	Work on "Abstract" for 82 minutes	2018-12-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
825	18	Work on "Abstract" for 82 minutes	2018-12-11 00:00:00	1	This is an auto-scheduled activity	incomplete	82
826	18	Work on "Abstract" for 82 minutes	2018-12-12 00:00:00	1	This is an auto-scheduled activity	incomplete	82
827	18	Work on "Abstract" for 82 minutes	2018-12-13 00:00:00	1	This is an auto-scheduled activity	incomplete	82
828	18	Work on "Abstract" for 82 minutes	2018-12-14 00:00:00	1	This is an auto-scheduled activity	incomplete	82
829	18	Work on "Abstract" for 82 minutes	2018-12-15 00:00:00	1	This is an auto-scheduled activity	incomplete	82
830	18	Work on "Abstract" for 82 minutes	2018-12-16 00:00:00	1	This is an auto-scheduled activity	incomplete	82
831	18	Work on "Abstract" for 82 minutes	2018-12-17 00:00:00	1	This is an auto-scheduled activity	incomplete	82
832	18	Work on "Abstract" for 82 minutes	2018-12-18 00:00:00	1	This is an auto-scheduled activity	incomplete	82
833	18	Work on "Abstract" for 82 minutes	2018-12-19 00:00:00	1	This is an auto-scheduled activity	incomplete	82
834	18	Work on "Abstract" for 82 minutes	2018-12-20 00:00:00	1	This is an auto-scheduled activity	incomplete	82
835	18	Work on "Abstract" for 82 minutes	2018-12-21 00:00:00	1	This is an auto-scheduled activity	incomplete	82
836	18	Work on "Abstract" for 82 minutes	2018-12-22 00:00:00	1	This is an auto-scheduled activity	incomplete	82
837	18	Work on "Abstract" for 82 minutes	2018-12-23 00:00:00	1	This is an auto-scheduled activity	incomplete	82
838	18	Work on "Abstract" for 82 minutes	2018-12-24 00:00:00	1	This is an auto-scheduled activity	incomplete	82
839	18	Work on "Abstract" for 82 minutes	2018-12-25 00:00:00	1	This is an auto-scheduled activity	incomplete	82
840	18	Work on "Abstract" for 82 minutes	2018-12-26 00:00:00	1	This is an auto-scheduled activity	incomplete	82
841	18	Work on "Abstract" for 82 minutes	2018-12-27 00:00:00	1	This is an auto-scheduled activity	incomplete	82
842	18	Work on "Abstract" for 82 minutes	2018-12-28 00:00:00	1	This is an auto-scheduled activity	incomplete	82
843	18	Work on "Abstract" for 82 minutes	2018-12-29 00:00:00	1	This is an auto-scheduled activity	incomplete	82
844	18	Work on "Abstract" for 82 minutes	2018-12-30 00:00:00	1	This is an auto-scheduled activity	incomplete	82
845	18	Work on "Abstract" for 82 minutes	2018-12-31 00:00:00	1	This is an auto-scheduled activity	incomplete	82
846	18	Work on "Abstract" for 82 minutes	2019-01-01 00:00:00	1	This is an auto-scheduled activity	incomplete	82
847	18	Work on "Abstract" for 82 minutes	2019-01-02 00:00:00	1	This is an auto-scheduled activity	incomplete	82
848	18	Work on "Abstract" for 82 minutes	2019-01-03 00:00:00	1	This is an auto-scheduled activity	incomplete	82
849	18	Work on "Abstract" for 82 minutes	2019-01-04 00:00:00	1	This is an auto-scheduled activity	incomplete	82
850	18	Work on "Abstract" for 82 minutes	2019-01-05 00:00:00	1	This is an auto-scheduled activity	incomplete	82
851	18	Work on "Abstract" for 82 minutes	2019-01-06 00:00:00	1	This is an auto-scheduled activity	incomplete	82
852	18	Work on "Abstract" for 82 minutes	2019-01-07 00:00:00	1	This is an auto-scheduled activity	incomplete	82
853	18	Work on "Abstract" for 82 minutes	2019-01-08 00:00:00	1	This is an auto-scheduled activity	incomplete	82
854	18	Work on "Abstract" for 82 minutes	2019-01-09 00:00:00	1	This is an auto-scheduled activity	incomplete	82
855	18	Work on "Abstract" for 82 minutes	2019-01-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
856	18	Work on "Abstract" for 82 minutes	2019-01-11 00:00:00	1	This is an auto-scheduled activity	incomplete	82
857	18	Work on "Abstract" for 82 minutes	2019-01-12 00:00:00	1	This is an auto-scheduled activity	incomplete	82
858	18	Work on "Abstract" for 82 minutes	2019-01-13 00:00:00	1	This is an auto-scheduled activity	incomplete	82
859	18	Work on "Abstract" for 82 minutes	2019-01-14 00:00:00	1	This is an auto-scheduled activity	incomplete	82
860	18	Work on "Abstract" for 82 minutes	2019-01-15 00:00:00	1	This is an auto-scheduled activity	incomplete	82
861	18	Work on "Abstract" for 82 minutes	2019-01-16 00:00:00	1	This is an auto-scheduled activity	incomplete	82
862	18	Work on "Abstract" for 82 minutes	2019-01-17 00:00:00	1	This is an auto-scheduled activity	incomplete	82
863	18	Work on "Abstract" for 82 minutes	2019-01-18 00:00:00	1	This is an auto-scheduled activity	incomplete	82
864	18	Work on "Abstract" for 82 minutes	2019-01-19 00:00:00	1	This is an auto-scheduled activity	incomplete	82
865	18	Work on "Abstract" for 82 minutes	2019-01-20 00:00:00	1	This is an auto-scheduled activity	incomplete	82
866	18	Work on "Abstract" for 82 minutes	2019-01-21 00:00:00	1	This is an auto-scheduled activity	incomplete	82
867	18	Work on "Abstract" for 82 minutes	2019-01-22 00:00:00	1	This is an auto-scheduled activity	incomplete	82
868	18	Work on "Abstract" for 82 minutes	2019-01-23 00:00:00	1	This is an auto-scheduled activity	incomplete	82
869	18	Work on "Abstract" for 82 minutes	2019-01-24 00:00:00	1	This is an auto-scheduled activity	incomplete	82
870	18	Work on "Abstract" for 82 minutes	2019-01-25 00:00:00	1	This is an auto-scheduled activity	incomplete	82
871	18	Work on "Abstract" for 82 minutes	2019-01-26 00:00:00	1	This is an auto-scheduled activity	incomplete	82
872	18	Work on "Abstract" for 82 minutes	2019-01-27 00:00:00	1	This is an auto-scheduled activity	incomplete	82
873	18	Work on "Abstract" for 82 minutes	2019-01-28 00:00:00	1	This is an auto-scheduled activity	incomplete	82
874	18	Work on "Abstract" for 82 minutes	2019-01-29 00:00:00	1	This is an auto-scheduled activity	incomplete	82
875	18	Work on "Abstract" for 82 minutes	2019-01-30 00:00:00	1	This is an auto-scheduled activity	incomplete	82
876	18	Work on "Abstract" for 82 minutes	2019-01-31 00:00:00	1	This is an auto-scheduled activity	incomplete	82
877	18	Work on "Abstract" for 82 minutes	2019-02-01 00:00:00	1	This is an auto-scheduled activity	incomplete	82
878	18	Work on "Abstract" for 82 minutes	2019-02-02 00:00:00	1	This is an auto-scheduled activity	incomplete	82
879	18	Work on "Abstract" for 82 minutes	2019-02-03 00:00:00	1	This is an auto-scheduled activity	incomplete	82
880	18	Work on "Abstract" for 82 minutes	2019-02-04 00:00:00	1	This is an auto-scheduled activity	incomplete	82
881	18	Work on "Abstract" for 82 minutes	2019-02-05 00:00:00	1	This is an auto-scheduled activity	incomplete	82
882	18	Work on "Abstract" for 82 minutes	2019-02-06 00:00:00	1	This is an auto-scheduled activity	incomplete	82
883	18	Work on "Abstract" for 82 minutes	2019-02-07 00:00:00	1	This is an auto-scheduled activity	incomplete	82
884	18	Work on "Abstract" for 82 minutes	2019-02-08 00:00:00	1	This is an auto-scheduled activity	incomplete	82
885	18	Work on "Abstract" for 82 minutes	2019-02-09 00:00:00	1	This is an auto-scheduled activity	incomplete	82
886	18	Work on "Abstract" for 82 minutes	2019-02-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
887	18	Work on "Abstract" for 82 minutes	2019-02-11 00:00:00	1	This is an auto-scheduled activity	incomplete	82
888	18	Work on "Abstract" for 82 minutes	2019-02-12 00:00:00	1	This is an auto-scheduled activity	incomplete	82
889	18	Work on "Abstract" for 82 minutes	2019-02-13 00:00:00	1	This is an auto-scheduled activity	incomplete	82
890	18	Work on "Abstract" for 82 minutes	2019-02-14 00:00:00	1	This is an auto-scheduled activity	incomplete	82
891	18	Work on "Abstract" for 82 minutes	2019-02-15 00:00:00	1	This is an auto-scheduled activity	incomplete	82
892	18	Work on "Abstract" for 82 minutes	2019-02-16 00:00:00	1	This is an auto-scheduled activity	incomplete	82
893	18	Work on "Abstract" for 82 minutes	2019-02-17 00:00:00	1	This is an auto-scheduled activity	incomplete	82
894	18	Work on "Abstract" for 82 minutes	2019-02-18 00:00:00	1	This is an auto-scheduled activity	incomplete	82
895	18	Work on "Abstract" for 82 minutes	2019-02-19 00:00:00	1	This is an auto-scheduled activity	incomplete	82
896	18	Work on "Abstract" for 82 minutes	2019-02-20 00:00:00	1	This is an auto-scheduled activity	incomplete	82
897	18	Work on "Abstract" for 82 minutes	2019-02-21 00:00:00	1	This is an auto-scheduled activity	incomplete	82
898	18	Work on "Abstract" for 82 minutes	2019-02-22 00:00:00	1	This is an auto-scheduled activity	incomplete	82
899	18	Work on "Abstract" for 82 minutes	2019-02-23 00:00:00	1	This is an auto-scheduled activity	incomplete	82
900	18	Work on "Abstract" for 82 minutes	2019-02-24 00:00:00	1	This is an auto-scheduled activity	incomplete	82
901	18	Work on "Abstract" for 82 minutes	2019-02-25 00:00:00	1	This is an auto-scheduled activity	incomplete	82
902	18	Work on "Abstract" for 82 minutes	2019-02-26 00:00:00	1	This is an auto-scheduled activity	incomplete	82
903	18	Work on "Abstract" for 82 minutes	2019-02-27 00:00:00	1	This is an auto-scheduled activity	incomplete	82
904	18	Work on "Abstract" for 82 minutes	2019-02-28 00:00:00	1	This is an auto-scheduled activity	incomplete	82
905	18	Work on "Abstract" for 82 minutes	2019-03-01 00:00:00	1	This is an auto-scheduled activity	incomplete	82
906	18	Work on "Abstract" for 82 minutes	2019-03-02 00:00:00	1	This is an auto-scheduled activity	incomplete	82
907	18	Work on "Abstract" for 82 minutes	2019-03-03 00:00:00	1	This is an auto-scheduled activity	incomplete	82
908	18	Work on "Abstract" for 82 minutes	2019-03-04 00:00:00	1	This is an auto-scheduled activity	incomplete	82
909	18	Work on "Abstract" for 82 minutes	2019-03-05 00:00:00	1	This is an auto-scheduled activity	incomplete	82
910	18	Work on "Abstract" for 82 minutes	2019-03-06 00:00:00	1	This is an auto-scheduled activity	incomplete	82
911	18	Work on "Abstract" for 82 minutes	2019-03-07 00:00:00	1	This is an auto-scheduled activity	incomplete	82
912	18	Work on "Abstract" for 82 minutes	2019-03-08 00:00:00	1	This is an auto-scheduled activity	incomplete	82
913	18	Work on "Abstract" for 82 minutes	2019-03-09 00:00:00	1	This is an auto-scheduled activity	incomplete	82
914	18	Work on "Abstract" for 82 minutes	2019-03-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
915	18	Work on "Abstract" for 82 minutes	2019-03-11 00:00:00	1	This is an auto-scheduled activity	incomplete	82
916	18	Work on "Abstract" for 82 minutes	2019-03-12 00:00:00	1	This is an auto-scheduled activity	incomplete	82
917	18	Work on "Abstract" for 82 minutes	2019-03-13 00:00:00	1	This is an auto-scheduled activity	incomplete	82
918	18	Work on "Abstract" for 82 minutes	2019-03-14 00:00:00	1	This is an auto-scheduled activity	incomplete	82
919	18	Work on "Abstract" for 82 minutes	2019-03-15 00:00:00	1	This is an auto-scheduled activity	incomplete	82
920	18	Work on "Abstract" for 82 minutes	2019-03-16 00:00:00	1	This is an auto-scheduled activity	incomplete	82
921	18	Work on "Abstract" for 82 minutes	2019-03-17 00:00:00	1	This is an auto-scheduled activity	incomplete	82
922	18	Work on "Abstract" for 82 minutes	2019-03-18 00:00:00	1	This is an auto-scheduled activity	incomplete	82
923	18	Work on "Abstract" for 82 minutes	2019-03-19 00:00:00	1	This is an auto-scheduled activity	incomplete	82
924	18	Work on "Abstract" for 82 minutes	2019-03-20 00:00:00	1	This is an auto-scheduled activity	incomplete	82
925	18	Work on "Abstract" for 82 minutes	2019-03-21 00:00:00	1	This is an auto-scheduled activity	incomplete	82
926	18	Work on "Abstract" for 82 minutes	2019-03-22 00:00:00	1	This is an auto-scheduled activity	incomplete	82
927	18	Work on "Abstract" for 82 minutes	2019-03-23 00:00:00	1	This is an auto-scheduled activity	incomplete	82
928	18	Work on "Abstract" for 82 minutes	2019-03-24 00:00:00	1	This is an auto-scheduled activity	incomplete	82
929	18	Work on "Abstract" for 82 minutes	2019-03-25 00:00:00	1	This is an auto-scheduled activity	incomplete	82
930	18	Work on "Abstract" for 82 minutes	2019-03-26 00:00:00	1	This is an auto-scheduled activity	incomplete	82
931	18	Work on "Abstract" for 82 minutes	2019-03-27 00:00:00	1	This is an auto-scheduled activity	incomplete	82
932	18	Work on "Abstract" for 82 minutes	2019-03-28 00:00:00	1	This is an auto-scheduled activity	incomplete	82
933	18	Work on "Abstract" for 82 minutes	2019-03-29 00:00:00	1	This is an auto-scheduled activity	incomplete	82
934	18	Work on "Abstract" for 82 minutes	2019-03-30 00:00:00	1	This is an auto-scheduled activity	incomplete	82
935	18	Work on "Abstract" for 82 minutes	2019-03-31 00:00:00	1	This is an auto-scheduled activity	incomplete	82
936	18	Work on "Abstract" for 82 minutes	2019-04-01 00:00:00	1	This is an auto-scheduled activity	incomplete	82
937	18	Work on "Abstract" for 82 minutes	2019-04-02 00:00:00	1	This is an auto-scheduled activity	incomplete	82
938	18	Work on "Abstract" for 82 minutes	2019-04-03 00:00:00	1	This is an auto-scheduled activity	incomplete	82
939	18	Work on "Abstract" for 82 minutes	2019-04-04 00:00:00	1	This is an auto-scheduled activity	incomplete	82
940	18	Work on "Abstract" for 82 minutes	2019-04-05 00:00:00	1	This is an auto-scheduled activity	incomplete	82
941	18	Work on "Abstract" for 82 minutes	2019-04-06 00:00:00	1	This is an auto-scheduled activity	incomplete	82
942	18	Work on "Abstract" for 82 minutes	2019-04-07 00:00:00	1	This is an auto-scheduled activity	incomplete	82
943	18	Work on "Abstract" for 82 minutes	2019-04-08 00:00:00	1	This is an auto-scheduled activity	incomplete	82
944	18	Work on "Abstract" for 82 minutes	2019-04-09 00:00:00	1	This is an auto-scheduled activity	incomplete	82
945	18	Work on "Abstract" for 82 minutes	2019-04-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
946	18	Work on "Abstract" for 82 minutes	2019-04-11 00:00:00	1	This is an auto-scheduled activity	incomplete	82
947	18	Work on "Abstract" for 82 minutes	2019-04-12 00:00:00	1	This is an auto-scheduled activity	incomplete	82
948	18	Work on "Abstract" for 82 minutes	2019-04-13 00:00:00	1	This is an auto-scheduled activity	incomplete	82
949	18	Work on "Abstract" for 82 minutes	2019-04-14 00:00:00	1	This is an auto-scheduled activity	incomplete	82
950	18	Work on "Abstract" for 82 minutes	2019-04-15 00:00:00	1	This is an auto-scheduled activity	incomplete	82
951	18	Work on "Abstract" for 82 minutes	2019-04-16 00:00:00	1	This is an auto-scheduled activity	incomplete	82
952	18	Work on "Abstract" for 82 minutes	2019-04-17 00:00:00	1	This is an auto-scheduled activity	incomplete	82
953	18	Work on "Abstract" for 82 minutes	2019-04-18 00:00:00	1	This is an auto-scheduled activity	incomplete	82
954	18	Work on "Abstract" for 82 minutes	2019-04-19 00:00:00	1	This is an auto-scheduled activity	incomplete	82
955	18	Work on "Abstract" for 82 minutes	2019-04-20 00:00:00	1	This is an auto-scheduled activity	incomplete	82
956	18	Work on "Abstract" for 82 minutes	2019-04-21 00:00:00	1	This is an auto-scheduled activity	incomplete	82
957	18	Work on "Abstract" for 82 minutes	2019-04-22 00:00:00	1	This is an auto-scheduled activity	incomplete	82
958	18	Work on "Abstract" for 82 minutes	2019-04-23 00:00:00	1	This is an auto-scheduled activity	incomplete	82
959	18	Work on "Abstract" for 82 minutes	2019-04-24 00:00:00	1	This is an auto-scheduled activity	incomplete	82
960	18	Work on "Abstract" for 82 minutes	2019-04-25 00:00:00	1	This is an auto-scheduled activity	incomplete	82
961	18	Work on "Abstract" for 82 minutes	2019-04-26 00:00:00	1	This is an auto-scheduled activity	incomplete	82
962	18	Work on "Abstract" for 82 minutes	2019-04-27 00:00:00	1	This is an auto-scheduled activity	incomplete	82
963	18	Work on "Abstract" for 82 minutes	2019-04-28 00:00:00	1	This is an auto-scheduled activity	incomplete	82
964	18	Work on "Abstract" for 82 minutes	2019-04-29 00:00:00	1	This is an auto-scheduled activity	incomplete	82
965	18	Work on "Abstract" for 82 minutes	2019-04-30 00:00:00	1	This is an auto-scheduled activity	incomplete	82
966	18	Work on "Abstract" for 82 minutes	2019-05-01 00:00:00	1	This is an auto-scheduled activity	incomplete	82
967	18	Work on "Abstract" for 82 minutes	2019-05-02 00:00:00	1	This is an auto-scheduled activity	incomplete	82
968	18	Work on "Abstract" for 82 minutes	2019-05-03 00:00:00	1	This is an auto-scheduled activity	incomplete	82
969	18	Work on "Abstract" for 82 minutes	2019-05-04 00:00:00	1	This is an auto-scheduled activity	incomplete	82
970	18	Work on "Abstract" for 82 minutes	2019-05-05 00:00:00	1	This is an auto-scheduled activity	incomplete	82
971	18	Work on "Abstract" for 82 minutes	2019-05-06 00:00:00	1	This is an auto-scheduled activity	incomplete	82
972	18	Work on "Abstract" for 82 minutes	2019-05-07 00:00:00	1	This is an auto-scheduled activity	incomplete	82
973	18	Work on "Abstract" for 82 minutes	2019-05-08 00:00:00	1	This is an auto-scheduled activity	incomplete	82
974	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 41 minutes	2018-05-10 00:00:00	1	This is an auto-scheduled activity	incomplete	41
975	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 41 minutes	2018-05-11 00:00:00	1	This is an auto-scheduled activity	incomplete	41
976	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 82 minutes	2018-05-10 00:00:00	1	This is an auto-scheduled activity	incomplete	82
977	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 13 minutes	2018-05-10 00:00:00	1	This is an auto-scheduled activity	incomplete	13
978	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 13 minutes	2018-05-11 00:00:00	1	This is an auto-scheduled activity	incomplete	13
979	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 13 minutes	2018-05-12 00:00:00	1	This is an auto-scheduled activity	incomplete	13
980	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 13 minutes	2018-05-13 00:00:00	1	This is an auto-scheduled activity	incomplete	13
981	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 13 minutes	2018-05-14 00:00:00	1	This is an auto-scheduled activity	incomplete	13
982	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 13 minutes	2018-05-15 00:00:00	1	This is an auto-scheduled activity	incomplete	13
983	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 10 minutes	2018-05-10 00:00:00	1	This is an auto-scheduled activity	incomplete	10
984	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 10 minutes	2018-05-11 00:00:00	1	This is an auto-scheduled activity	incomplete	10
985	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 10 minutes	2018-05-12 00:00:00	1	This is an auto-scheduled activity	incomplete	10
986	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 10 minutes	2018-05-13 00:00:00	1	This is an auto-scheduled activity	incomplete	10
987	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 10 minutes	2018-05-14 00:00:00	1	This is an auto-scheduled activity	incomplete	10
988	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 10 minutes	2018-05-15 00:00:00	1	This is an auto-scheduled activity	incomplete	10
989	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 10 minutes	2018-05-16 00:00:00	1	This is an auto-scheduled activity	incomplete	10
990	18	Work on "Work on &quot;Abstract&quot; for 82 minutes" for 10 minutes	2018-05-17 00:00:00	1	This is an auto-scheduled activity	incomplete	10
613	18	Work on 	2018-05-13 00:00:00	1	This is an auto-scheduled activity	incomplete	82
991	18	d	2018-05-09 00:00:00	1		incomplete	\N
992	18	'*	2018-05-09 00:00:00	1		incomplete	\N
993	18	'Select * from activities;	2018-05-09 00:00:00	1		incomplete	\N
996	18	'*	1969-12-31 19:00:00	1		incomplete	\N
997	18	bad time	1969-12-31 19:00:00	1		incomplete	\N
998	28	A	2018-12-24 23:59:00	5	52	incomplete	9999
999	28	Work on "A" for 43 minutes	2018-05-10 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1000	28	Work on "A" for 43 minutes	2018-05-11 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1001	28	Work on "A" for 43 minutes	2018-05-12 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1002	28	Work on "A" for 43 minutes	2018-05-13 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1003	28	Work on "A" for 43 minutes	2018-05-14 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1004	28	Work on "A" for 43 minutes	2018-05-15 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1005	28	Work on "A" for 43 minutes	2018-05-16 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1006	28	Work on "A" for 43 minutes	2018-05-17 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1007	28	Work on "A" for 43 minutes	2018-05-18 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1008	28	Work on "A" for 43 minutes	2018-05-19 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1009	28	Work on "A" for 43 minutes	2018-05-20 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1010	28	Work on "A" for 43 minutes	2018-05-21 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1011	28	Work on "A" for 43 minutes	2018-05-22 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1012	28	Work on "A" for 43 minutes	2018-05-23 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1013	28	Work on "A" for 43 minutes	2018-05-24 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1014	28	Work on "A" for 43 minutes	2018-05-25 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1015	28	Work on "A" for 43 minutes	2018-05-26 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1016	28	Work on "A" for 43 minutes	2018-05-27 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1017	28	Work on "A" for 43 minutes	2018-05-28 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1018	28	Work on "A" for 43 minutes	2018-05-29 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1019	28	Work on "A" for 43 minutes	2018-05-30 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1020	28	Work on "A" for 43 minutes	2018-05-31 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1021	28	Work on "A" for 43 minutes	2018-06-01 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1022	28	Work on "A" for 43 minutes	2018-06-02 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1023	28	Work on "A" for 43 minutes	2018-06-03 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1024	28	Work on "A" for 43 minutes	2018-06-04 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1025	28	Work on "A" for 43 minutes	2018-06-05 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1026	28	Work on "A" for 43 minutes	2018-06-06 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1027	28	Work on "A" for 43 minutes	2018-06-07 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1028	28	Work on "A" for 43 minutes	2018-06-08 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1029	28	Work on "A" for 43 minutes	2018-06-09 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1030	28	Work on "A" for 43 minutes	2018-06-10 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1031	28	Work on "A" for 43 minutes	2018-06-11 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1032	28	Work on "A" for 43 minutes	2018-06-12 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1033	28	Work on "A" for 43 minutes	2018-06-13 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1034	28	Work on "A" for 43 minutes	2018-06-14 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1035	28	Work on "A" for 43 minutes	2018-06-15 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1036	28	Work on "A" for 43 minutes	2018-06-16 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1037	28	Work on "A" for 43 minutes	2018-06-17 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1038	28	Work on "A" for 43 minutes	2018-06-18 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1039	28	Work on "A" for 43 minutes	2018-06-19 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1040	28	Work on "A" for 43 minutes	2018-06-20 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1041	28	Work on "A" for 43 minutes	2018-06-21 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1042	28	Work on "A" for 43 minutes	2018-06-22 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1043	28	Work on "A" for 43 minutes	2018-06-23 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1044	28	Work on "A" for 43 minutes	2018-06-24 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1045	28	Work on "A" for 43 minutes	2018-06-25 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1046	28	Work on "A" for 43 minutes	2018-06-26 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1047	28	Work on "A" for 43 minutes	2018-06-27 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1048	28	Work on "A" for 43 minutes	2018-06-28 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1049	28	Work on "A" for 43 minutes	2018-06-29 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1050	28	Work on "A" for 43 minutes	2018-06-30 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1051	28	Work on "A" for 43 minutes	2018-07-01 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1052	28	Work on "A" for 43 minutes	2018-07-02 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1053	28	Work on "A" for 43 minutes	2018-07-03 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1054	28	Work on "A" for 43 minutes	2018-07-04 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1055	28	Work on "A" for 43 minutes	2018-07-05 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1056	28	Work on "A" for 43 minutes	2018-07-06 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1057	28	Work on "A" for 43 minutes	2018-07-07 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1058	28	Work on "A" for 43 minutes	2018-07-08 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1059	28	Work on "A" for 43 minutes	2018-07-09 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1060	28	Work on "A" for 43 minutes	2018-07-10 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1061	28	Work on "A" for 43 minutes	2018-07-11 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1062	28	Work on "A" for 43 minutes	2018-07-12 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1063	28	Work on "A" for 43 minutes	2018-07-13 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1064	28	Work on "A" for 43 minutes	2018-07-14 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1065	28	Work on "A" for 43 minutes	2018-07-15 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1066	28	Work on "A" for 43 minutes	2018-07-16 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1067	28	Work on "A" for 43 minutes	2018-07-17 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1068	28	Work on "A" for 43 minutes	2018-07-18 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1069	28	Work on "A" for 43 minutes	2018-07-19 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1070	28	Work on "A" for 43 minutes	2018-07-20 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1071	28	Work on "A" for 43 minutes	2018-07-21 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1072	28	Work on "A" for 43 minutes	2018-07-22 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1073	28	Work on "A" for 43 minutes	2018-07-23 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1074	28	Work on "A" for 43 minutes	2018-07-24 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1075	28	Work on "A" for 43 minutes	2018-07-25 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1076	28	Work on "A" for 43 minutes	2018-07-26 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1077	28	Work on "A" for 43 minutes	2018-07-27 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1078	28	Work on "A" for 43 minutes	2018-07-28 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1079	28	Work on "A" for 43 minutes	2018-07-29 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1080	28	Work on "A" for 43 minutes	2018-07-30 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1081	28	Work on "A" for 43 minutes	2018-07-31 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1082	28	Work on "A" for 43 minutes	2018-08-01 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1083	28	Work on "A" for 43 minutes	2018-08-02 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1084	28	Work on "A" for 43 minutes	2018-08-03 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1085	28	Work on "A" for 43 minutes	2018-08-04 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1086	28	Work on "A" for 43 minutes	2018-08-05 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1087	28	Work on "A" for 43 minutes	2018-08-06 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1088	28	Work on "A" for 43 minutes	2018-08-07 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1089	28	Work on "A" for 43 minutes	2018-08-08 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1090	28	Work on "A" for 43 minutes	2018-08-09 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1091	28	Work on "A" for 43 minutes	2018-08-10 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1092	28	Work on "A" for 43 minutes	2018-08-11 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1093	28	Work on "A" for 43 minutes	2018-08-12 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1094	28	Work on "A" for 43 minutes	2018-08-13 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1095	28	Work on "A" for 43 minutes	2018-08-14 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1096	28	Work on "A" for 43 minutes	2018-08-15 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1097	28	Work on "A" for 43 minutes	2018-08-16 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1098	28	Work on "A" for 43 minutes	2018-08-17 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1099	28	Work on "A" for 43 minutes	2018-08-18 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1100	28	Work on "A" for 43 minutes	2018-08-19 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1101	28	Work on "A" for 43 minutes	2018-08-20 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1102	28	Work on "A" for 43 minutes	2018-08-21 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1103	28	Work on "A" for 43 minutes	2018-08-22 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1104	28	Work on "A" for 43 minutes	2018-08-23 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1105	28	Work on "A" for 43 minutes	2018-08-24 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1106	28	Work on "A" for 43 minutes	2018-08-25 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1107	28	Work on "A" for 43 minutes	2018-08-26 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1108	28	Work on "A" for 43 minutes	2018-08-27 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1109	28	Work on "A" for 43 minutes	2018-08-28 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1110	28	Work on "A" for 43 minutes	2018-08-29 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1111	28	Work on "A" for 43 minutes	2018-08-30 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1112	28	Work on "A" for 43 minutes	2018-08-31 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1113	28	Work on "A" for 43 minutes	2018-09-01 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1114	28	Work on "A" for 43 minutes	2018-09-02 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1115	28	Work on "A" for 43 minutes	2018-09-03 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1116	28	Work on "A" for 43 minutes	2018-09-04 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1117	28	Work on "A" for 43 minutes	2018-09-05 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1118	28	Work on "A" for 43 minutes	2018-09-06 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1119	28	Work on "A" for 43 minutes	2018-09-07 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1120	28	Work on "A" for 43 minutes	2018-09-08 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1121	28	Work on "A" for 43 minutes	2018-09-09 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1122	28	Work on "A" for 43 minutes	2018-09-10 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1123	28	Work on "A" for 43 minutes	2018-09-11 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1124	28	Work on "A" for 43 minutes	2018-09-12 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1125	28	Work on "A" for 43 minutes	2018-09-13 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1126	28	Work on "A" for 43 minutes	2018-09-14 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1127	28	Work on "A" for 43 minutes	2018-09-15 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1128	28	Work on "A" for 43 minutes	2018-09-16 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1129	28	Work on "A" for 43 minutes	2018-09-17 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1130	28	Work on "A" for 43 minutes	2018-09-18 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1131	28	Work on "A" for 43 minutes	2018-09-19 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1132	28	Work on "A" for 43 minutes	2018-09-20 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1133	28	Work on "A" for 43 minutes	2018-09-21 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1134	28	Work on "A" for 43 minutes	2018-09-22 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1135	28	Work on "A" for 43 minutes	2018-09-23 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1136	28	Work on "A" for 43 minutes	2018-09-24 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1137	28	Work on "A" for 43 minutes	2018-09-25 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1138	28	Work on "A" for 43 minutes	2018-09-26 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1139	28	Work on "A" for 43 minutes	2018-09-27 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1140	28	Work on "A" for 43 minutes	2018-09-28 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1141	28	Work on "A" for 43 minutes	2018-09-29 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1142	28	Work on "A" for 43 minutes	2018-09-30 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1143	28	Work on "A" for 43 minutes	2018-10-01 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1144	28	Work on "A" for 43 minutes	2018-10-02 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1145	28	Work on "A" for 43 minutes	2018-10-03 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1146	28	Work on "A" for 43 minutes	2018-10-04 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1147	28	Work on "A" for 43 minutes	2018-10-05 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1148	28	Work on "A" for 43 minutes	2018-10-06 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1149	28	Work on "A" for 43 minutes	2018-10-07 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1150	28	Work on "A" for 43 minutes	2018-10-08 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1151	28	Work on "A" for 43 minutes	2018-10-09 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1152	28	Work on "A" for 43 minutes	2018-10-10 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1153	28	Work on "A" for 43 minutes	2018-10-11 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1154	28	Work on "A" for 43 minutes	2018-10-12 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1155	28	Work on "A" for 43 minutes	2018-10-13 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1156	28	Work on "A" for 43 minutes	2018-10-14 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1157	28	Work on "A" for 43 minutes	2018-10-15 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1158	28	Work on "A" for 43 minutes	2018-10-16 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1159	28	Work on "A" for 43 minutes	2018-10-17 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1160	28	Work on "A" for 43 minutes	2018-10-18 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1161	28	Work on "A" for 43 minutes	2018-10-19 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1162	28	Work on "A" for 43 minutes	2018-10-20 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1163	28	Work on "A" for 43 minutes	2018-10-21 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1164	28	Work on "A" for 43 minutes	2018-10-22 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1165	28	Work on "A" for 43 minutes	2018-10-23 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1166	28	Work on "A" for 43 minutes	2018-10-24 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1167	28	Work on "A" for 43 minutes	2018-10-25 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1168	28	Work on "A" for 43 minutes	2018-10-26 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1169	28	Work on "A" for 43 minutes	2018-10-27 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1170	28	Work on "A" for 43 minutes	2018-10-28 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1171	28	Work on "A" for 43 minutes	2018-10-29 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1172	28	Work on "A" for 43 minutes	2018-10-30 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1173	28	Work on "A" for 43 minutes	2018-10-31 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1174	28	Work on "A" for 43 minutes	2018-11-01 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1175	28	Work on "A" for 43 minutes	2018-11-02 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1176	28	Work on "A" for 43 minutes	2018-11-03 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1177	28	Work on "A" for 43 minutes	2018-11-04 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1178	28	Work on "A" for 43 minutes	2018-11-05 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1179	28	Work on "A" for 43 minutes	2018-11-06 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1180	28	Work on "A" for 43 minutes	2018-11-07 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1181	28	Work on "A" for 43 minutes	2018-11-08 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1182	28	Work on "A" for 43 minutes	2018-11-09 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1183	28	Work on "A" for 43 minutes	2018-11-10 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1184	28	Work on "A" for 43 minutes	2018-11-11 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1185	28	Work on "A" for 43 minutes	2018-11-12 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1186	28	Work on "A" for 43 minutes	2018-11-13 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1187	28	Work on "A" for 43 minutes	2018-11-14 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1188	28	Work on "A" for 43 minutes	2018-11-15 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1189	28	Work on "A" for 43 minutes	2018-11-16 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1190	28	Work on "A" for 43 minutes	2018-11-17 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1191	28	Work on "A" for 43 minutes	2018-11-18 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1192	28	Work on "A" for 43 minutes	2018-11-19 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1193	28	Work on "A" for 43 minutes	2018-11-20 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1194	28	Work on "A" for 43 minutes	2018-11-21 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1195	28	Work on "A" for 43 minutes	2018-11-22 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1196	28	Work on "A" for 43 minutes	2018-11-23 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1197	28	Work on "A" for 43 minutes	2018-11-24 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1198	28	Work on "A" for 43 minutes	2018-11-25 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1199	28	Work on "A" for 43 minutes	2018-11-26 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1200	28	Work on "A" for 43 minutes	2018-11-27 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1201	28	Work on "A" for 43 minutes	2018-11-28 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1202	28	Work on "A" for 43 minutes	2018-11-29 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1203	28	Work on "A" for 43 minutes	2018-11-30 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1204	28	Work on "A" for 43 minutes	2018-12-01 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1205	28	Work on "A" for 43 minutes	2018-12-02 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1206	28	Work on "A" for 43 minutes	2018-12-03 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1207	28	Work on "A" for 43 minutes	2018-12-04 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1208	28	Work on "A" for 43 minutes	2018-12-05 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1209	28	Work on "A" for 43 minutes	2018-12-06 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1210	28	Work on "A" for 43 minutes	2018-12-07 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1211	28	Work on "A" for 43 minutes	2018-12-08 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1212	28	Work on "A" for 43 minutes	2018-12-09 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1213	28	Work on "A" for 43 minutes	2018-12-10 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1214	28	Work on "A" for 43 minutes	2018-12-11 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1215	28	Work on "A" for 43 minutes	2018-12-12 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1216	28	Work on "A" for 43 minutes	2018-12-13 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1217	28	Work on "A" for 43 minutes	2018-12-14 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1218	28	Work on "A" for 43 minutes	2018-12-15 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1219	28	Work on "A" for 43 minutes	2018-12-16 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1220	28	Work on "A" for 43 minutes	2018-12-17 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1221	28	Work on "A" for 43 minutes	2018-12-18 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1222	28	Work on "A" for 43 minutes	2018-12-19 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1223	28	Work on "A" for 43 minutes	2018-12-20 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1224	28	Work on "A" for 43 minutes	2018-12-21 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1225	28	Work on "A" for 43 minutes	2018-12-22 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1226	28	Work on "A" for 43 minutes	2018-12-23 00:00:00	5	This is an auto-scheduled activity	incomplete	43
1227	28	Work on "Work on &quot;A&quot; for 43 minutes" for 21 minutes	2018-05-11 00:00:00	5	This is an auto-scheduled activity	incomplete	21
1228	28	Work on "Work on &quot;A&quot; for 43 minutes" for 21 minutes	2018-05-12 00:00:00	5	This is an auto-scheduled activity	incomplete	21
1229	42	HW #1	2018-05-13 16:00:00	1		incomplete	30
1230	41	Exam	2018-05-24 19:00:00	1		incomplete	500
1232	41	Work on "Exam" for 35 minutes	2018-05-11 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1233	41	Work on "Exam" for 35 minutes	2018-05-12 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1234	41	Work on "Exam" for 35 minutes	2018-05-13 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1235	41	Work on "Exam" for 35 minutes	2018-05-14 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1236	41	Work on "Exam" for 35 minutes	2018-05-15 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1237	41	Work on "Exam" for 35 minutes	2018-05-16 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1238	41	Work on "Exam" for 35 minutes	2018-05-17 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1239	41	Work on "Exam" for 35 minutes	2018-05-18 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1240	41	Work on "Exam" for 35 minutes	2018-05-19 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1241	41	Work on "Exam" for 35 minutes	2018-05-20 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1242	41	Work on "Exam" for 35 minutes	2018-05-21 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1243	41	Work on "Exam" for 35 minutes	2018-05-22 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1244	41	Work on "Exam" for 35 minutes	2018-05-23 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1246	41	Work on "Exam" for 35 minutes	2018-05-11 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1247	41	Work on "Exam" for 35 minutes	2018-05-12 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1248	41	Work on "Exam" for 35 minutes	2018-05-13 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1249	41	Work on "Exam" for 35 minutes	2018-05-14 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1250	41	Work on "Exam" for 35 minutes	2018-05-15 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1251	41	Work on "Exam" for 35 minutes	2018-05-16 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1252	41	Work on "Exam" for 35 minutes	2018-05-17 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1253	41	Work on "Exam" for 35 minutes	2018-05-18 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1254	41	Work on "Exam" for 35 minutes	2018-05-19 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1255	41	Work on "Exam" for 35 minutes	2018-05-20 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1256	41	Work on "Exam" for 35 minutes	2018-05-21 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1257	41	Work on "Exam" for 35 minutes	2018-05-22 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1258	41	Work on "Exam" for 35 minutes	2018-05-23 00:00:00	1	This is an auto-scheduled activity	incomplete	35
1259	41	Work on "Work on &quot;Exam&quot; for 35 minutes" for 8 minutes	2018-05-11 00:00:00	1	This is an auto-scheduled activity	incomplete	8
1260	41	Work on "Work on &quot;Exam&quot; for 35 minutes" for 8 minutes	2018-05-12 00:00:00	1	This is an auto-scheduled activity	incomplete	8
1261	41	Work on "Work on &quot;Exam&quot; for 35 minutes" for 8 minutes	2018-05-13 00:00:00	1	This is an auto-scheduled activity	incomplete	8
1262	41	Work on "Work on &quot;Exam&quot; for 35 minutes" for 8 minutes	2018-05-14 00:00:00	1	This is an auto-scheduled activity	incomplete	8
1231	41	Work on 	2018-05-10 00:00:00	1	This is an auto-scheduled activity	incomplete	99
1245	41	Work on 	2018-05-10 00:00:00	1	This is an auto-scheduled activity	complete	35
1263	44	Presentation	2018-05-17 13:00:00	5	final!	incomplete	15
1264	44	Demonstration for Auto-Scheduler	2018-05-20 13:00:00	2	Demonstration	incomplete	120
1268	44	Work on "Demonstration for Auto-Scheduler" for 40 minutes	2018-05-17 00:00:00	2	This is an auto-scheduled activity	incomplete	40
1269	44	Work on "Demonstration for Auto-Scheduler" for 40 minutes	2018-05-18 00:00:00	2	This is an auto-scheduled activity	incomplete	40
1270	44	Work on "Demonstration for Auto-Scheduler" for 40 minutes	2018-05-19 00:00:00	2	This is an auto-scheduled activity	incomplete	40
1271	48	Play games 'n shit	2018-05-22 17:00:00	2	Shit	incomplete	69
1272	49	asdas	2018-05-17 00:00:00	1		incomplete	\N
1273	52	lol	2018-05-17 00:00:00	1	lol	incomplete	\N
1274	49	asdasd	2018-05-17 00:00:00	1		incomplete	\N
1275	50	Final Meeting	2018-05-17 00:00:00	1	Just do it	incomplete	\N
1276	49	lol	2018-05-17 14:00:00	1	123	incomplete	123
1277	54	Operations Management Final	2018-05-17 00:00:00	1		complete	\N
1278	51	Project Proposal	2018-05-18 09:00:00	5	Submit Proposal to Instructor	complete	240
1279	55	Graduation	2018-05-18 09:00:00	1		incomplete	\N
1280	51	Test	2018-05-20 09:00:00	2		incomplete	90
1281	51	Work on "Test" for 45 minutes	2018-05-18 00:00:00	2	This is an auto-scheduled activity	incomplete	45
1282	51	Work on "Test" for 45 minutes	2018-05-19 00:00:00	2	This is an auto-scheduled activity	incomplete	45
\.


--
-- Data for Name: activity2; Type: TABLE DATA; Schema: public; Owner: christiandaluz
--

COPY public.activity2 (activityid, catid, activityname, dueby, priority, description, status, estimatedtime) FROM stdin;
1	1	act1	2018-05-05 00:00:00	1	\N	incomplete	\N
2	2	act2	2018-05-05 00:00:00	2	\N	incomplete	\N
4	3	act3	2018-05-05 00:00:00	3	\N	incomplete	\N
5	4	act4	2018-05-05 00:00:00	4	\N	incomplete	\N
\.


--
-- Name: activity2_activityid_seq; Type: SEQUENCE SET; Schema: public; Owner: christiandaluz
--

SELECT pg_catalog.setval('public.activity2_activityid_seq', 5, true);


--
-- Name: activity_activityid_seq; Type: SEQUENCE SET; Schema: public; Owner: christiandaluz
--

SELECT pg_catalog.setval('public.activity_activityid_seq', 1282, true);


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: christiandaluz
--

COPY public.category (catid, clientid, catname) FROM stdin;
1	1	Work
6	1	Extracurricular
2	1	School
7	3	Work
8	1	SSPlanner
9	1	Sport
10	1	Miscellaneous
12	14	Cat5
13	15	1
14	15	f
15	15	f
16	15	ff
17	15	f
18	16	'8'
19	16	'*
20	16	\\;
21	16	*'
22	16	/*
23	16	*\\
24	16	'
25	16	''*
26	16	*
27	16	'<boo>
28	16	'Select * from categories;
33	4	This
34	4	Another One
35	4	'8'
36	16	Senior Seminar
37	16	Mathematical Modeling
38	16	Abstract Algebra
39	16	Analysis
40	16	MacroEconomics
41	17	American Modeling
42	17	National Economy
43	17	Abstract Algebra 
44	18	School2
46	20	Work shit
47	20	Home shit
48	20	Hobby shit
49	23	cat1
50	24	Exams/Finals
52	21	Sleep
53	23	asdasd
54	25	Exams
51	22	Senior Seminar Class
55	25	Other
\.


--
-- Data for Name: category2; Type: TABLE DATA; Schema: public; Owner: christiandaluz
--

COPY public.category2 (catid, clientid, catname) FROM stdin;
1	2	work2
2	3	work3
3	4	work4
4	2	school2
5	3	school3
6	4	school4
\.


--
-- Name: category2_catid_seq; Type: SEQUENCE SET; Schema: public; Owner: christiandaluz
--

SELECT pg_catalog.setval('public.category2_catid_seq', 6, true);


--
-- Name: category_catid_seq; Type: SEQUENCE SET; Schema: public; Owner: christiandaluz
--

SELECT pg_catalog.setval('public.category_catid_seq', 55, true);


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: christiandaluz
--

COPY public.client (clientid, username, passwordhash, email) FROM stdin;
4	admin	5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8	admin@hi.com
5	jrachmuth	85e5df14a00bd82052294978deff790a178105ab4110e68b6a6ecbd19d65eece	josephrachmuth@mail.adelphi.edu
6	harmitminhas	02556001a485e9ff393b5381ff225d98a943518961e829df83d52b9bf1169584	harmitminhas@mail.adelphi.edu
7	mmery	7edd3fa1cf00842a336254e175721fbdf39708b667f09c350ebc144f14ff14b5	marcomery@mail.adelphi.edu
8	zackp	ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f	zacharypournazari@mail.adelphi.edu
9	Potato	225c8061511cccc40c43b260599c4544b3d14c175691c6c1b3bc370ebc86cf3e	gummyfeared@yahoo.com
10	justtesting	acb4e1041b650becc2adc94e1048f65dc710acfb9d271359eacfd8783442daad	gvunwdwzp@emxgateway.com
11	Kris	6d642548110d0f4dd14b046b6e8aa7412a749b7c61a67f21f96d9aa58abb730b	chenyangsu@mail.adelphi.edu
1	User1	5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8	josephrachmuth@compsci.adelphi.edu
2	User2	5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8	josephrachmuth@compsci.adelphi.edu
3	user3	5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8	josephrachmuth@compsci.adelphi.edu
13	user100	5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8	nor@rachmuth.com
14	example2	9099d265eca27184d7ba33263bc8615667b0700a8f0abc6764e5389cdee664a0	ex@ex.co
15	jrachmuth11570	8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92	joseph@rachmuth.com
16	jrachmuth1	8bb0cf6eb9b17d0f7d22b456f121257dc1254e1f01665370476383ea776df414	josephrachmuth@mail.adelphi.edu
17	cdorantes	8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92	cdorantes@adelphi.edu
18	StephanieUschok	40b1bbb5445fc021a312315379f4633284851e14d1db83fb0730f58872d6033b	stephanieuschok@mail.adelphi.edu
19	suschok	4e56932e19e333a10b3c5bf48265dd7b08e5465b6b01328c5345367ddd962ac4	suschok@adelphi.edu
20	aperson	d11fe72f741f57b6cdd9114a3d190274d0a6acd9a3c8ded145c35210e9ddcf9e	snivyvonderpphucki@gmail.com
21	derrick	f1fe0010cd21217ba0eb289bc4ee42e0474929a6f1ecfd1ed48017bd3f9adb27	gummyfeared@yahoo.com
22	cdaluz	5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8	christiandaluz@mail.adelphi.edu
23	kris2	5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8	email@example.com
24	VinnySchilly	98df52f959f39e65f2a3152f4daa0408aedf695eedb768ef57862d84320bf87b	vincentschillero@mail.adelphi.edu
25	markiplier	e66e05bf11fa2e78573d213198ff1b15dfb72996c9d74daa86aff245c399b7cc	charlesbeach@mail.adelphi.edu
\.


--
-- Data for Name: client2; Type: TABLE DATA; Schema: public; Owner: christiandaluz
--

COPY public.client2 (clientid, username, passwordhash, email) FROM stdin;
2	christiandaluz	password	email1
3	user2	password	email1
4	user3	password	email1
5	user4	password	email1
\.


--
-- Name: client2_clientid_seq; Type: SEQUENCE SET; Schema: public; Owner: christiandaluz
--

SELECT pg_catalog.setval('public.client2_clientid_seq', 5, true);


--
-- Name: client_clientid_seq; Type: SEQUENCE SET; Schema: public; Owner: christiandaluz
--

SELECT pg_catalog.setval('public.client_clientid_seq', 25, true);


--
-- Name: activity2_pkey; Type: CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.activity2
    ADD CONSTRAINT activity2_pkey PRIMARY KEY (activityid, catid);


--
-- Name: activity_pkey; Type: CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT activity_pkey PRIMARY KEY (activityid, catid);


--
-- Name: category2_catid_key; Type: CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.category2
    ADD CONSTRAINT category2_catid_key UNIQUE (catid);


--
-- Name: category2_pkey; Type: CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.category2
    ADD CONSTRAINT category2_pkey PRIMARY KEY (clientid, catid);


--
-- Name: category_catid_key; Type: CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_catid_key UNIQUE (catid);


--
-- Name: category_pkey; Type: CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (clientid, catid);


--
-- Name: client2_clientid_key; Type: CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.client2
    ADD CONSTRAINT client2_clientid_key UNIQUE (clientid);


--
-- Name: client2_pkey; Type: CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.client2
    ADD CONSTRAINT client2_pkey PRIMARY KEY (clientid, username);


--
-- Name: client_clientid_key; Type: CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_clientid_key UNIQUE (clientid);


--
-- Name: client_pkey; Type: CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (clientid, username);


--
-- Name: activity2_catid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.activity2
    ADD CONSTRAINT activity2_catid_fkey FOREIGN KEY (catid) REFERENCES public.category2(catid);


--
-- Name: activity_catid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT activity_catid_fkey FOREIGN KEY (catid) REFERENCES public.category(catid);


--
-- Name: category2_catid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.category2
    ADD CONSTRAINT category2_catid_fkey FOREIGN KEY (clientid) REFERENCES public.client2(clientid);


--
-- Name: category_clientid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: christiandaluz
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_clientid_fkey FOREIGN KEY (clientid) REFERENCES public.client(clientid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: TABLE activity; Type: ACL; Schema: public; Owner: christiandaluz
--

REVOKE ALL ON TABLE public.activity FROM PUBLIC;
REVOKE ALL ON TABLE public.activity FROM christiandaluz;
GRANT ALL ON TABLE public.activity TO christiandaluz;
GRANT ALL ON TABLE public.activity TO josephrachmuth;
GRANT ALL ON TABLE public.activity TO stephanieuschok;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.activity TO "www-data";


--
-- Name: SEQUENCE activity_activityid_seq; Type: ACL; Schema: public; Owner: christiandaluz
--

REVOKE ALL ON SEQUENCE public.activity_activityid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.activity_activityid_seq FROM christiandaluz;
GRANT ALL ON SEQUENCE public.activity_activityid_seq TO christiandaluz;
GRANT SELECT,UPDATE ON SEQUENCE public.activity_activityid_seq TO josephrachmuth;
GRANT SELECT,UPDATE ON SEQUENCE public.activity_activityid_seq TO stephanieuschok;
GRANT SELECT,UPDATE ON SEQUENCE public.activity_activityid_seq TO "www-data";


--
-- Name: TABLE category; Type: ACL; Schema: public; Owner: christiandaluz
--

REVOKE ALL ON TABLE public.category FROM PUBLIC;
REVOKE ALL ON TABLE public.category FROM christiandaluz;
GRANT ALL ON TABLE public.category TO christiandaluz;
GRANT ALL ON TABLE public.category TO josephrachmuth;
GRANT ALL ON TABLE public.category TO stephanieuschok;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.category TO "www-data";


--
-- Name: TABLE activitylistview; Type: ACL; Schema: public; Owner: stephanieuschok
--

REVOKE ALL ON TABLE public.activitylistview FROM PUBLIC;
REVOKE ALL ON TABLE public.activitylistview FROM stephanieuschok;
GRANT ALL ON TABLE public.activitylistview TO stephanieuschok;
GRANT SELECT ON TABLE public.activitylistview TO "www-data";


--
-- Name: SEQUENCE category_catid_seq; Type: ACL; Schema: public; Owner: christiandaluz
--

REVOKE ALL ON SEQUENCE public.category_catid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.category_catid_seq FROM christiandaluz;
GRANT ALL ON SEQUENCE public.category_catid_seq TO christiandaluz;
GRANT SELECT,UPDATE ON SEQUENCE public.category_catid_seq TO "www-data";
GRANT SELECT,UPDATE ON SEQUENCE public.category_catid_seq TO josephrachmuth;
GRANT SELECT,UPDATE ON SEQUENCE public.category_catid_seq TO stephanieuschok;


--
-- Name: TABLE client; Type: ACL; Schema: public; Owner: christiandaluz
--

REVOKE ALL ON TABLE public.client FROM PUBLIC;
REVOKE ALL ON TABLE public.client FROM christiandaluz;
GRANT ALL ON TABLE public.client TO christiandaluz;
GRANT ALL ON TABLE public.client TO josephrachmuth;
GRANT ALL ON TABLE public.client TO stephanieuschok;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.client TO "www-data";


--
-- Name: SEQUENCE client_clientid_seq; Type: ACL; Schema: public; Owner: christiandaluz
--

REVOKE ALL ON SEQUENCE public.client_clientid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.client_clientid_seq FROM christiandaluz;
GRANT ALL ON SEQUENCE public.client_clientid_seq TO christiandaluz;
GRANT SELECT,UPDATE ON SEQUENCE public.client_clientid_seq TO "www-data";


--
-- Name: TABLE weeklyview; Type: ACL; Schema: public; Owner: stephanieuschok
--

REVOKE ALL ON TABLE public.weeklyview FROM PUBLIC;
REVOKE ALL ON TABLE public.weeklyview FROM stephanieuschok;
GRANT ALL ON TABLE public.weeklyview TO stephanieuschok;
GRANT SELECT ON TABLE public.weeklyview TO "www-data";


--
-- PostgreSQL database dump complete
--

