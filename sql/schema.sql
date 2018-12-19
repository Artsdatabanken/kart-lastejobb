--
-- PostgreSQL database dump
--

-- Dumped from database version 10.2
-- Dumped by pg_dump version 10.5

-- Started on 2018-12-13 11:59:59

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
-- TOC entry 7 (class 2615 OID 1208660)
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
-- TOC entry 4293 (class 0 OID 0)
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
-- TOC entry 4294 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 213 (class 1259 OID 1208661)
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
-- TOC entry 214 (class 1259 OID 1208667)
-- Name: codes_geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.codes_geometry (
    geometry_id bigint NOT NULL,
    code text NOT NULL,
    codes_id bigint,
    fraction integer,
    created timestamp without time zone,
    aggregated boolean DEFAULT false
);


ALTER TABLE data.codes_geometry OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 1208674)
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
-- TOC entry 4295 (class 0 OID 0)
-- Dependencies: 215
-- Name: codes_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.codes_id_seq OWNED BY data.codes.id;


--
-- TOC entry 216 (class 1259 OID 1208676)
-- Name: codeshierarchy; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.codeshierarchy (
    predecessor text,
    successor text
);


ALTER TABLE data.codeshierarchy OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 1208682)
-- Name: dataset; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.dataset (
    id bigint NOT NULL,
    prefix_id integer,
    description text
);


ALTER TABLE data.dataset OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 1208688)
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
-- TOC entry 4296 (class 0 OID 0)
-- Dependencies: 218
-- Name: dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.dataset_id_seq OWNED BY data.dataset.id;


--
-- TOC entry 219 (class 1259 OID 1208690)
-- Name: geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.geometry (
    id bigint NOT NULL,
    geography public.geography,
    dataset_id integer NOT NULL
);


ALTER TABLE data.geometry OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 1208696)
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
-- TOC entry 4297 (class 0 OID 0)
-- Dependencies: 220
-- Name: geometry_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.geometry_id_seq OWNED BY data.geometry.id;


--
-- TOC entry 221 (class 1259 OID 1208698)
-- Name: localid_geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.localid_geometry (
    geometry_id bigint NOT NULL,
    localid text NOT NULL
);


ALTER TABLE data.localid_geometry OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 1208704)
-- Name: prefix; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.prefix (
    id integer NOT NULL,
    value text,
    description text
);


ALTER TABLE data.prefix OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 1208710)
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
-- TOC entry 4298 (class 0 OID 0)
-- Dependencies: 223
-- Name: prefix_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.prefix_id_seq OWNED BY data.prefix.id;


--
-- TOC entry 224 (class 1259 OID 1208712)
-- Name: v_geometry; Type: MATERIALIZED VIEW; Schema: data; Owner: postgres
--

CREATE MATERIALIZED VIEW data.v_geometry AS
 SELECT row_number() OVER (ORDER BY g.id) AS id,
    g.id AS geometry_id,
    g.geography,
    c.code,
    c.title,
        CASE
            WHEN (l_g.localid IS NULL) THEN ''::text
            ELSE l_g.localid
        END AS localid,
    p.value AS prefix,
    p.description AS prefixdescription,
    d.description AS datasetdescription
   FROM (data.geometry g
     LEFT JOIN data.localid_geometry l_g ON ((g.id = l_g.geometry_id))),
    data.codes_geometry c_g,
    data.dataset d,
    data.prefix p,
    data.codes c
  WHERE ((g.id = c_g.geometry_id) AND (c_g.codes_id = c.id) AND (g.dataset_id = d.id) AND (p.id = d.prefix_id) AND ((c_g.aggregated <> true) OR (c_g.aggregated IS NULL)))
  WITH NO DATA;


ALTER TABLE data.v_geometry OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 1213466)
-- Name: v_geometry_all; Type: MATERIALIZED VIEW; Schema: data; Owner: postgres
--

CREATE MATERIALIZED VIEW data.v_geometry_all AS
 SELECT row_number() OVER (ORDER BY g.id) AS id,
    g.id AS geometry_id,
    g.geography,
    c.code,
    c.title,
        CASE
            WHEN (l_g.localid IS NULL) THEN ''::text
            ELSE l_g.localid
        END AS localid,
    p.value AS prefix,
    p.description AS prefixdescription,
    d.description AS datasetdescription
   FROM (data.geometry g
     LEFT JOIN data.localid_geometry l_g ON ((g.id = l_g.geometry_id))),
    data.codes_geometry c_g,
    data.dataset d,
    data.prefix p,
    data.codes c
  WHERE ((g.id = c_g.geometry_id) AND (c_g.codes_id = c.id) AND (g.dataset_id = d.id) AND (p.id = d.prefix_id))
  WITH NO DATA;


ALTER TABLE data.v_geometry_all OWNER TO postgres;

--
-- TOC entry 4124 (class 2604 OID 1208720)
-- Name: codes id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codes ALTER COLUMN id SET DEFAULT nextval('data.codes_id_seq'::regclass);


--
-- TOC entry 4126 (class 2604 OID 1208721)
-- Name: dataset id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.dataset ALTER COLUMN id SET DEFAULT nextval('data.dataset_id_seq'::regclass);


--
-- TOC entry 4127 (class 2604 OID 1208722)
-- Name: geometry id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.geometry ALTER COLUMN id SET DEFAULT nextval('data.geometry_id_seq'::regclass);


--
-- TOC entry 4128 (class 2604 OID 1208723)
-- Name: prefix id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.prefix ALTER COLUMN id SET DEFAULT nextval('data.prefix_id_seq'::regclass);


--
-- TOC entry 4131 (class 2606 OID 1208725)
-- Name: codes codes_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codes
    ADD CONSTRAINT codes_pk PRIMARY KEY (id);


--
-- TOC entry 4137 (class 2606 OID 1208727)
-- Name: dataset dataset_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.dataset
    ADD CONSTRAINT dataset_pk PRIMARY KEY (id);


--
-- TOC entry 4142 (class 2606 OID 1208729)
-- Name: geometry geometry_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.geometry
    ADD CONSTRAINT geometry_pk PRIMARY KEY (id);


--
-- TOC entry 4146 (class 2606 OID 1208731)
-- Name: prefix prefix_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.prefix
    ADD CONSTRAINT prefix_pk PRIMARY KEY (id);


--
-- TOC entry 4129 (class 1259 OID 1208732)
-- Name: code_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX code_idx ON data.codes USING btree (code);


--
-- TOC entry 4132 (class 1259 OID 1208733)
-- Name: codes_geometry_aggregated_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX codes_geometry_aggregated_idx ON data.codes_geometry USING btree (code, geometry_id, codes_id, aggregated);


--
-- TOC entry 4133 (class 1259 OID 1208734)
-- Name: codes_geometry_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX codes_geometry_idx ON data.codes_geometry USING btree (geometry_id, codes_id);


--
-- TOC entry 4139 (class 1259 OID 1208735)
-- Name: fki_dataset_id_fx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX fki_dataset_id_fx ON data.geometry USING btree (dataset_id);


--
-- TOC entry 4138 (class 1259 OID 1208736)
-- Name: fki_prefix_id_fk; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX fki_prefix_id_fk ON data.dataset USING btree (prefix_id);


--
-- TOC entry 4140 (class 1259 OID 1208737)
-- Name: geometry_geography_20180404; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX geometry_geography_20180404 ON data.geometry USING gist (geography);

ALTER TABLE data.geometry CLUSTER ON geometry_geography_20180404;


--
-- TOC entry 4143 (class 1259 OID 1208738)
-- Name: localid_geometry_geometry_id_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX localid_geometry_geometry_id_idx ON data.localid_geometry USING btree (geometry_id);


--
-- TOC entry 4144 (class 1259 OID 1208739)
-- Name: localid_geometry_localid_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX localid_geometry_localid_idx ON data.localid_geometry USING btree (localid);


--
-- TOC entry 4134 (class 1259 OID 1208740)
-- Name: predecessor_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX predecessor_idx ON data.codeshierarchy USING btree (predecessor);


--
-- TOC entry 4135 (class 1259 OID 1208741)
-- Name: successor_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX successor_idx ON data.codeshierarchy USING btree (successor);


--
-- TOC entry 4150 (class 1259 OID 1312711)
-- Name: v_geometry_all_code_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX v_geometry_all_code_idx ON data.v_geometry_all USING btree (code);


--
-- TOC entry 4151 (class 1259 OID 1312719)
-- Name: v_geometry_all_geometry_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX v_geometry_all_geometry_idx ON data.v_geometry_all USING gist (geography);


--
-- TOC entry 4148 (class 1259 OID 1208742)
-- Name: v_geometry_code_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX v_geometry_code_idx ON data.v_geometry USING btree (code);


--
-- TOC entry 4149 (class 1259 OID 1208743)
-- Name: v_geometry_geometry_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX v_geometry_geometry_idx ON data.v_geometry USING gist (geography);


--
-- TOC entry 4147 (class 1259 OID 1208744)
-- Name: value_description_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX value_description_idx ON data.prefix USING btree (value, description);


--
-- TOC entry 4154 (class 2606 OID 1208745)
-- Name: geometry dataset_id_fx; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.geometry
    ADD CONSTRAINT dataset_id_fx FOREIGN KEY (dataset_id) REFERENCES data.dataset(id) ON DELETE CASCADE;


--
-- TOC entry 4152 (class 2606 OID 1208750)
-- Name: codes_geometry geometry_id; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codes_geometry
    ADD CONSTRAINT geometry_id FOREIGN KEY (geometry_id) REFERENCES data.geometry(id) ON DELETE CASCADE;


--
-- TOC entry 4155 (class 2606 OID 1208755)
-- Name: localid_geometry geometry_id; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.localid_geometry
    ADD CONSTRAINT geometry_id FOREIGN KEY (geometry_id) REFERENCES data.geometry(id) ON DELETE CASCADE;


--
-- TOC entry 4153 (class 2606 OID 1208760)
-- Name: dataset prefix_id_fk; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.dataset
    ADD CONSTRAINT prefix_id_fk FOREIGN KEY (prefix_id) REFERENCES data.prefix(id) ON DELETE CASCADE;


--
-- TOC entry 4299 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE v_geometry; Type: ACL; Schema: data; Owner: postgres
--

GRANT SELECT ON TABLE data.v_geometry TO reader;


--
-- TOC entry 4300 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE v_geometry_all; Type: ACL; Schema: data; Owner: postgres
--

GRANT SELECT ON TABLE data.v_geometry_all TO reader;


-- Completed on 2018-12-13 11:59:59

--
-- PostgreSQL database dump complete
--

