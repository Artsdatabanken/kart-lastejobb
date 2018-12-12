--
-- PostgreSQL database dump
--

-- Dumped from database version 10.2
-- Dumped by pg_dump version 10.5

-- Started on 2018-12-12 14:29:36

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
-- TOC entry 8 (class 2615 OID 543741)
-- Name: data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA data;


ALTER SCHEMA data OWNER TO postgres;

--
-- TOC entry 1 (class 3079 OID 536130)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 4306 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 2 (class 3079 OID 536135)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 4307 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 213 (class 1259 OID 543742)
-- Name: codes; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.codes (
    id bigint NOT NULL,
    code text,
    title text,
    level integer,
    index bigint,
    predecessor text
);


ALTER TABLE data.codes OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 543748)
-- Name: codes_geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.codes_geometry (
    geometry_id bigint NOT NULL,
    code text NOT NULL,
    codes_id bigint,
    fraction integer,
    created timestamp without time zone,
    aggregated boolean DEFAULT false NOT NULL
);


ALTER TABLE data.codes_geometry OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 543754)
-- Name: codes_id_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE data.codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data.codes_id_seq OWNER TO postgres;

--
-- TOC entry 4308 (class 0 OID 0)
-- Dependencies: 215
-- Name: codes_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.codes_id_seq OWNED BY data.codes.id;


--
-- TOC entry 216 (class 1259 OID 543756)
-- Name: codeshierarchy; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.codeshierarchy (
    predecessor text,
    successor text
);


ALTER TABLE data.codeshierarchy OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 543762)
-- Name: dataset; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.dataset (
    id bigint NOT NULL,
    prefix_id integer,
    description text
);


ALTER TABLE data.dataset OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 543768)
-- Name: dataset_id_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE data.dataset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data.dataset_id_seq OWNER TO postgres;

--
-- TOC entry 4309 (class 0 OID 0)
-- Dependencies: 218
-- Name: dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.dataset_id_seq OWNED BY data.dataset.id;


--
-- TOC entry 219 (class 1259 OID 543770)
-- Name: geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.geometry (
    id bigint NOT NULL,
    geography public.geography,
    dataset_id integer NOT NULL
);


ALTER TABLE data.geometry OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 543776)
-- Name: geometry_id_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE data.geometry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data.geometry_id_seq OWNER TO postgres;

--
-- TOC entry 4310 (class 0 OID 0)
-- Dependencies: 220
-- Name: geometry_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.geometry_id_seq OWNED BY data.geometry.id;


--
-- TOC entry 221 (class 1259 OID 543778)
-- Name: localid_geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.localid_geometry (
    geometry_id bigint NOT NULL,
    localid text NOT NULL
);


ALTER TABLE data.localid_geometry OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 543784)
-- Name: prefix; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.prefix (
    id integer NOT NULL,
    value text,
    description text
);


ALTER TABLE data.prefix OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 543790)
-- Name: prefix_id_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE data.prefix_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data.prefix_id_seq OWNER TO postgres;

--
-- TOC entry 4311 (class 0 OID 0)
-- Dependencies: 223
-- Name: prefix_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.prefix_id_seq OWNED BY data.prefix.id;


--
-- TOC entry 224 (class 1259 OID 543792)
-- Name: v_codeshierarchy; Type: VIEW; Schema: data; Owner: postgres
--

CREATE VIEW data.v_codeshierarchy AS
 SELECT DISTINCT u.predecessor,
    u.successor,
    cp.level AS predecessor_level,
    cs.level AS successor_level
   FROM ( SELECT codeshierarchy.predecessor,
            codeshierarchy.successor
           FROM data.codeshierarchy
        UNION ALL
         SELECT a.predecessor,
            b.successor
           FROM data.codeshierarchy a,
            data.codeshierarchy b
          WHERE (a.successor = b.predecessor)) u,
    data.codes cs,
    data.codes cp
  WHERE ((cs.code = u.successor) AND (cp.code = u.predecessor));


ALTER TABLE data.v_codeshierarchy OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 543796)
-- Name: v_first_successor; Type: VIEW; Schema: data; Owner: postgres
--

CREATE VIEW data.v_first_successor AS
 SELECT p.code AS predecessor,
    s.code AS first_successor
   FROM data.codes p,
    data.codes s,
    data.codeshierarchy ch
  WHERE ((p.code = ch.predecessor) AND (s.code = ch.successor) AND ((s.level - p.level) = 1));


ALTER TABLE data.v_first_successor OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 543800)
-- Name: v_codeshierarchy_first_successor; Type: VIEW; Schema: data; Owner: postgres
--

CREATE VIEW data.v_codeshierarchy_first_successor AS
 SELECT ch.predecessor,
    ch.successor,
    fs.first_successor
   FROM data.v_codeshierarchy ch,
    data.v_first_successor fs
  WHERE ((ch.predecessor = fs.predecessor) AND (fs.first_successor IN ( SELECT ch2.predecessor
           FROM data.v_codeshierarchy ch2
          WHERE (ch2.successor = ch.successor))))
UNION ALL
 SELECT v_first_successor.predecessor,
    codes.code AS successor,
    v_first_successor.first_successor
   FROM data.v_first_successor,
    data.codes
  WHERE (v_first_successor.first_successor = codes.code);


ALTER TABLE data.v_codeshierarchy_first_successor OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 543804)
-- Name: v_codetree; Type: VIEW; Schema: data; Owner: postgres
--

CREATE VIEW data.v_codetree AS
 WITH RECURSIVE q AS (
         SELECT m.predecessor,
            m.successor,
            (row_number() OVER (ORDER BY m.successor))::text AS bc
           FROM data.codeshierarchy m
          WHERE (m.predecessor IS NULL)
        UNION ALL
         SELECT m.predecessor,
            m.successor,
            ((q_1.bc || '.'::text) || (row_number() OVER (PARTITION BY m.predecessor ORDER BY m.successor))::text)
           FROM (data.codeshierarchy m
             JOIN q q_1 ON ((m.predecessor = q_1.successor)))
        )
 SELECT q.predecessor,
    q.successor,
    q.bc
   FROM q
  ORDER BY q.bc;


ALTER TABLE data.v_codetree OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 543809)
-- Name: v_codetree_complete; Type: VIEW; Schema: data; Owner: postgres
--

CREATE VIEW data.v_codetree_complete AS
 WITH RECURSIVE q AS (
         SELECT v_codetree.predecessor,
            v_codetree.successor,
            v_codetree.bc
           FROM data.v_codetree
          WHERE (v_codetree.predecessor IS NULL)
        UNION ALL
         SELECT m.predecessor,
            m.successor,
            m.bc
           FROM (data.v_codetree m
             JOIN q q_1 ON ((q_1.successor ~~ (m.predecessor || '%'::text))))
        )
 SELECT q.predecessor,
    q.successor
   FROM q;


ALTER TABLE data.v_codetree_complete OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 543814)
-- Name: v_geometry; Type: VIEW; Schema: data; Owner: postgres
--

CREATE VIEW data.v_geometry AS
 SELECT row_number() OVER (ORDER BY g.id) AS id,
    g.id AS geometry_id,
    g.geography,
    c.code,
    c.title,
        CASE
            WHEN (l_g.localid IS NULL) THEN ''::text
            ELSE l_g.localid
        END AS localid,
    p.value,
    p.description AS prefixdescription,
    d.description AS datasetdescription
   FROM (data.geometry g
     LEFT JOIN data.localid_geometry l_g ON ((g.id = l_g.geometry_id))),
    data.codes_geometry c_g,
    data.dataset d,
    data.prefix p,
    data.codes c
  WHERE ((g.id = c_g.geometry_id) AND (c_g.codes_id = c.id) AND (g.dataset_id = d.id) AND (p.id = d.prefix_id) AND (c_g.aggregated = false));


ALTER TABLE data.v_geometry OWNER TO postgres;

--
-- TOC entry 4138 (class 2604 OID 543819)
-- Name: codes id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codes ALTER COLUMN id SET DEFAULT nextval('data.codes_id_seq'::regclass);


--
-- TOC entry 4140 (class 2604 OID 543820)
-- Name: dataset id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.dataset ALTER COLUMN id SET DEFAULT nextval('data.dataset_id_seq'::regclass);


--
-- TOC entry 4141 (class 2604 OID 543821)
-- Name: geometry id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.geometry ALTER COLUMN id SET DEFAULT nextval('data.geometry_id_seq'::regclass);


--
-- TOC entry 4142 (class 2604 OID 543822)
-- Name: prefix id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.prefix ALTER COLUMN id SET DEFAULT nextval('data.prefix_id_seq'::regclass);


--
-- TOC entry 4145 (class 2606 OID 543824)
-- Name: codes codes_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codes
    ADD CONSTRAINT codes_pk PRIMARY KEY (id);


--
-- TOC entry 4150 (class 2606 OID 543826)
-- Name: dataset dataset_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.dataset
    ADD CONSTRAINT dataset_pk PRIMARY KEY (id);


--
-- TOC entry 4155 (class 2606 OID 543828)
-- Name: geometry geometry_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.geometry
    ADD CONSTRAINT geometry_pk PRIMARY KEY (id);


--
-- TOC entry 4159 (class 2606 OID 543830)
-- Name: prefix prefix_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.prefix
    ADD CONSTRAINT prefix_pk PRIMARY KEY (id);


--
-- TOC entry 4143 (class 1259 OID 543831)
-- Name: code_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX code_idx ON data.codes USING btree (code);


--
-- TOC entry 4146 (class 1259 OID 543832)
-- Name: codes_geometry_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX codes_geometry_idx ON data.codes_geometry USING btree (geometry_id, codes_id);


--
-- TOC entry 4152 (class 1259 OID 543833)
-- Name: fki_dataset_id_fx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX fki_dataset_id_fx ON data.geometry USING btree (dataset_id);


--
-- TOC entry 4151 (class 1259 OID 543834)
-- Name: fki_prefix_id_fk; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX fki_prefix_id_fk ON data.dataset USING btree (prefix_id);


--
-- TOC entry 4153 (class 1259 OID 543835)
-- Name: geometry_geography_20180404; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX geometry_geography_20180404 ON data.geometry USING gist (geography);

ALTER TABLE data.geometry CLUSTER ON geometry_geography_20180404;


--
-- TOC entry 4156 (class 1259 OID 543836)
-- Name: localid_geometry_geometry_id_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX localid_geometry_geometry_id_idx ON data.localid_geometry USING btree (geometry_id);


--
-- TOC entry 4157 (class 1259 OID 543837)
-- Name: localid_geometry_localid_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX localid_geometry_localid_idx ON data.localid_geometry USING btree (localid);


--
-- TOC entry 4147 (class 1259 OID 543838)
-- Name: predecessor_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX predecessor_idx ON data.codeshierarchy USING btree (predecessor);


--
-- TOC entry 4148 (class 1259 OID 543839)
-- Name: successor_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX successor_idx ON data.codeshierarchy USING btree (successor);


--
-- TOC entry 4160 (class 1259 OID 543840)
-- Name: value_description_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX value_description_idx ON data.prefix USING btree (value, description);


--
-- TOC entry 4163 (class 2606 OID 543841)
-- Name: geometry dataset_id_fx; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.geometry
    ADD CONSTRAINT dataset_id_fx FOREIGN KEY (dataset_id) REFERENCES data.dataset(id) ON DELETE CASCADE;


--
-- TOC entry 4161 (class 2606 OID 543846)
-- Name: codes_geometry geometry_id; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codes_geometry
    ADD CONSTRAINT geometry_id FOREIGN KEY (geometry_id) REFERENCES data.geometry(id) ON DELETE CASCADE;


--
-- TOC entry 4164 (class 2606 OID 543851)
-- Name: localid_geometry geometry_id; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.localid_geometry
    ADD CONSTRAINT geometry_id FOREIGN KEY (geometry_id) REFERENCES data.geometry(id) ON DELETE CASCADE;


--
-- TOC entry 4162 (class 2606 OID 543856)
-- Name: dataset prefix_id_fk; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.dataset
    ADD CONSTRAINT prefix_id_fk FOREIGN KEY (prefix_id) REFERENCES data.prefix(id) ON DELETE CASCADE;


--
-- TOC entry 4312 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE v_geometry; Type: ACL; Schema: data; Owner: postgres
--

GRANT SELECT ON TABLE data.v_geometry TO reader;


-- Completed on 2018-12-12 14:29:36

--
-- PostgreSQL database dump complete
--

