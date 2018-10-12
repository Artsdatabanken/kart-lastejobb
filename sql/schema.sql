--
-- PostgreSQL database dump
--

-- Dumped from database version 10.2
-- Dumped by pg_dump version 10.4

-- Started on 2018-10-11 15:40:01

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
-- TOC entry 5 (class 2615 OID 434285)
-- Name: data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA data;


ALTER SCHEMA data OWNER TO postgres;

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 213 (class 1259 OID 434286)
-- Name: codes; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.codes (
    id bigint NOT NULL,
    code text,
    title text,
    level integer,
    index bigint
);


ALTER TABLE data.codes OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 434292)
-- Name: codes_geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.codes_geometry (
    geometry_id bigint NOT NULL,
    code text NOT NULL,
    codes_id bigint,
    fraction integer,
    created timestamp without time zone
);


ALTER TABLE data.codes_geometry OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 434298)
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
-- TOC entry 4258 (class 0 OID 0)
-- Dependencies: 215
-- Name: codes_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.codes_id_seq OWNED BY data.codes.id;


--
-- TOC entry 216 (class 1259 OID 434300)
-- Name: codeshierarchy; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.codeshierarchy (
    id bigint NOT NULL,
    predecessor text,
    successor text
);


ALTER TABLE data.codeshierarchy OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 434306)
-- Name: codeshierarchy_id_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE data.codeshierarchy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data.codeshierarchy_id_seq OWNER TO postgres;

--
-- TOC entry 4259 (class 0 OID 0)
-- Dependencies: 217
-- Name: codeshierarchy_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.codeshierarchy_id_seq OWNED BY data.codeshierarchy.id;


--
-- TOC entry 218 (class 1259 OID 434308)
-- Name: dataset; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.dataset (
    id bigint NOT NULL,
    prefix_id integer,
    description text
);


ALTER TABLE data.dataset OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 434314)
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
-- TOC entry 4260 (class 0 OID 0)
-- Dependencies: 219
-- Name: dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.dataset_id_seq OWNED BY data.dataset.id;


--
-- TOC entry 220 (class 1259 OID 434316)
-- Name: geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.geometry (
    id bigint NOT NULL,
    geography public.geography,
    geometry public.geometry(Geometry,3857),
    dataset_id integer NOT NULL
);


ALTER TABLE data.geometry OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 434322)
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
-- TOC entry 4261 (class 0 OID 0)
-- Dependencies: 221
-- Name: geometry_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.geometry_id_seq OWNED BY data.geometry.id;


--
-- TOC entry 222 (class 1259 OID 434324)
-- Name: localid_geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.localid_geometry (
    geometry_id bigint NOT NULL,
    localid text NOT NULL
);


ALTER TABLE data.localid_geometry OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 434330)
-- Name: prefix; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.prefix (
    id integer NOT NULL,
    value text,
    description text
);


ALTER TABLE data.prefix OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 434336)
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
-- TOC entry 4262 (class 0 OID 0)
-- Dependencies: 224
-- Name: prefix_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.prefix_id_seq OWNED BY data.prefix.id;


--
-- TOC entry 225 (class 1259 OID 438813)
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
  WHERE ((g.id = c_g.geometry_id) AND (c_g.codes_id = c.id) AND (g.dataset_id = d.id) AND (p.id = d.prefix_id));


ALTER TABLE data.v_geometry OWNER TO postgres;

--
-- TOC entry 4094 (class 2604 OID 434338)
-- Name: codes id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codes ALTER COLUMN id SET DEFAULT nextval('data.codes_id_seq'::regclass);


--
-- TOC entry 4095 (class 2604 OID 434339)
-- Name: codeshierarchy id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codeshierarchy ALTER COLUMN id SET DEFAULT nextval('data.codeshierarchy_id_seq'::regclass);


--
-- TOC entry 4096 (class 2604 OID 434340)
-- Name: dataset id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.dataset ALTER COLUMN id SET DEFAULT nextval('data.dataset_id_seq'::regclass);


--
-- TOC entry 4097 (class 2604 OID 434341)
-- Name: geometry id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.geometry ALTER COLUMN id SET DEFAULT nextval('data.geometry_id_seq'::regclass);


--
-- TOC entry 4098 (class 2604 OID 434342)
-- Name: prefix id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.prefix ALTER COLUMN id SET DEFAULT nextval('data.prefix_id_seq'::regclass);


--
-- TOC entry 4101 (class 2606 OID 434344)
-- Name: codes codes_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codes
    ADD CONSTRAINT codes_pk PRIMARY KEY (id);


--
-- TOC entry 4104 (class 2606 OID 434346)
-- Name: codeshierarchy codeshierarchy_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codeshierarchy
    ADD CONSTRAINT codeshierarchy_pk PRIMARY KEY (id);


--
-- TOC entry 4108 (class 2606 OID 434348)
-- Name: dataset dataset_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.dataset
    ADD CONSTRAINT dataset_pk PRIMARY KEY (id);


--
-- TOC entry 4114 (class 2606 OID 434350)
-- Name: geometry geometry_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.geometry
    ADD CONSTRAINT geometry_pk PRIMARY KEY (id);


--
-- TOC entry 4118 (class 2606 OID 434352)
-- Name: prefix prefix_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.prefix
    ADD CONSTRAINT prefix_pk PRIMARY KEY (id);


--
-- TOC entry 4099 (class 1259 OID 434353)
-- Name: code_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX code_idx ON data.codes USING btree (code);


--
-- TOC entry 4102 (class 1259 OID 434354)
-- Name: codes_geometry_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX codes_geometry_idx ON data.codes_geometry USING btree (geometry_id, codes_id);


--
-- TOC entry 4110 (class 1259 OID 434356)
-- Name: fki_dataset_id_fx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX fki_dataset_id_fx ON data.geometry USING btree (dataset_id);


--
-- TOC entry 4109 (class 1259 OID 434357)
-- Name: fki_prefix_id_fk; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX fki_prefix_id_fk ON data.dataset USING btree (prefix_id);


--
-- TOC entry 4111 (class 1259 OID 434358)
-- Name: geometry_geography_20180404; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX geometry_geography_20180404 ON data.geometry USING gist (geography);

ALTER TABLE data.geometry CLUSTER ON geometry_geography_20180404;


--
-- TOC entry 4112 (class 1259 OID 434359)
-- Name: geometry_geometry_20180404; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX geometry_geometry_20180404 ON data.geometry USING gist (geometry);


--
-- TOC entry 4115 (class 1259 OID 434360)
-- Name: localid_geometry_geometry_id_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX localid_geometry_geometry_id_idx ON data.localid_geometry USING btree (geometry_id);


--
-- TOC entry 4116 (class 1259 OID 434361)
-- Name: localid_geometry_localid_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX localid_geometry_localid_idx ON data.localid_geometry USING btree (localid);


--
-- TOC entry 4105 (class 1259 OID 434362)
-- Name: predecessor_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX predecessor_idx ON data.codeshierarchy USING btree (predecessor);


--
-- TOC entry 4106 (class 1259 OID 434363)
-- Name: successor_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX successor_idx ON data.codeshierarchy USING btree (successor);


--
-- TOC entry 4119 (class 1259 OID 434355)
-- Name: value_description_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX value_description_idx ON data.prefix USING btree (value, description);


--
-- TOC entry 4122 (class 2606 OID 434364)
-- Name: geometry dataset_id_fx; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.geometry
    ADD CONSTRAINT dataset_id_fx FOREIGN KEY (dataset_id) REFERENCES data.dataset(id) ON DELETE CASCADE;


--
-- TOC entry 4120 (class 2606 OID 434369)
-- Name: codes_geometry geometry_id; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codes_geometry
    ADD CONSTRAINT geometry_id FOREIGN KEY (geometry_id) REFERENCES data.geometry(id) ON DELETE CASCADE;


--
-- TOC entry 4123 (class 2606 OID 434374)
-- Name: localid_geometry geometry_id; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.localid_geometry
    ADD CONSTRAINT geometry_id FOREIGN KEY (geometry_id) REFERENCES data.geometry(id) ON DELETE CASCADE;


--
-- TOC entry 4121 (class 2606 OID 434379)
-- Name: dataset prefix_id_fk; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.dataset
    ADD CONSTRAINT prefix_id_fk FOREIGN KEY (prefix_id) REFERENCES data.prefix(id) ON DELETE CASCADE;


--
-- TOC entry 4263 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE v_geometry; Type: ACL; Schema: data; Owner: postgres
--

GRANT SELECT ON TABLE data.v_geometry TO reader;


-- Completed on 2018-10-11 15:40:01

--
-- PostgreSQL database dump complete
--

