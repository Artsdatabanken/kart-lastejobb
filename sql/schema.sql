--
-- PostgreSQL database dump
--

-- Dumped from database version 10.2
-- Dumped by pg_dump version 10.5

-- Started on 2018-12-12 16:05:20

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
-- TOC entry 4 (class 2615 OID 548089)
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
-- TOC entry 4282 (class 0 OID 0)
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
-- TOC entry 4283 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 213 (class 1259 OID 548090)
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
-- TOC entry 214 (class 1259 OID 548096)
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
-- TOC entry 215 (class 1259 OID 548103)
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
-- TOC entry 4284 (class 0 OID 0)
-- Dependencies: 215
-- Name: codes_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.codes_id_seq OWNED BY data.codes.id;


--
-- TOC entry 216 (class 1259 OID 548105)
-- Name: codeshierarchy; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.codeshierarchy (
    predecessor text,
    successor text
);


ALTER TABLE data.codeshierarchy OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 548111)
-- Name: dataset; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.dataset (
    id bigint NOT NULL,
    prefix_id integer,
    description text
);


ALTER TABLE data.dataset OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 548117)
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
-- TOC entry 4285 (class 0 OID 0)
-- Dependencies: 218
-- Name: dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.dataset_id_seq OWNED BY data.dataset.id;


--
-- TOC entry 219 (class 1259 OID 548119)
-- Name: geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.geometry (
    id bigint NOT NULL,
    geography public.geography,
    dataset_id integer NOT NULL
);


ALTER TABLE data.geometry OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 548125)
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
-- TOC entry 4286 (class 0 OID 0)
-- Dependencies: 220
-- Name: geometry_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.geometry_id_seq OWNED BY data.geometry.id;


--
-- TOC entry 221 (class 1259 OID 548127)
-- Name: localid_geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.localid_geometry (
    geometry_id bigint NOT NULL,
    localid text NOT NULL
);


ALTER TABLE data.localid_geometry OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 548133)
-- Name: prefix; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.prefix (
    id integer NOT NULL,
    value text,
    description text
);


ALTER TABLE data.prefix OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 548139)
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
-- TOC entry 4287 (class 0 OID 0)
-- Dependencies: 223
-- Name: prefix_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.prefix_id_seq OWNED BY data.prefix.id;


--
-- TOC entry 224 (class 1259 OID 548141)
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
  WHERE ((g.id = c_g.geometry_id) AND (c_g.codes_id = c.id) AND (g.dataset_id = d.id) AND (p.id = d.prefix_id) AND ((c_g.aggregated <> true) OR (c_g.aggregated IS NULL)));


ALTER TABLE data.v_geometry OWNER TO postgres;

--
-- TOC entry 4118 (class 2604 OID 548146)
-- Name: codes id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codes ALTER COLUMN id SET DEFAULT nextval('data.codes_id_seq'::regclass);


--
-- TOC entry 4120 (class 2604 OID 548147)
-- Name: dataset id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.dataset ALTER COLUMN id SET DEFAULT nextval('data.dataset_id_seq'::regclass);


--
-- TOC entry 4121 (class 2604 OID 548148)
-- Name: geometry id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.geometry ALTER COLUMN id SET DEFAULT nextval('data.geometry_id_seq'::regclass);


--
-- TOC entry 4122 (class 2604 OID 548149)
-- Name: prefix id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.prefix ALTER COLUMN id SET DEFAULT nextval('data.prefix_id_seq'::regclass);


--
-- TOC entry 4125 (class 2606 OID 548151)
-- Name: codes codes_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codes
    ADD CONSTRAINT codes_pk PRIMARY KEY (id);


--
-- TOC entry 4131 (class 2606 OID 548153)
-- Name: dataset dataset_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.dataset
    ADD CONSTRAINT dataset_pk PRIMARY KEY (id);


--
-- TOC entry 4136 (class 2606 OID 548155)
-- Name: geometry geometry_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.geometry
    ADD CONSTRAINT geometry_pk PRIMARY KEY (id);


--
-- TOC entry 4140 (class 2606 OID 548157)
-- Name: prefix prefix_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.prefix
    ADD CONSTRAINT prefix_pk PRIMARY KEY (id);


--
-- TOC entry 4123 (class 1259 OID 548158)
-- Name: code_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX code_idx ON data.codes USING btree (code);


--
-- TOC entry 4126 (class 1259 OID 551689)
-- Name: codes_geometry_aggregated_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX codes_geometry_aggregated_idx ON data.codes_geometry USING btree (code, geometry_id, codes_id, aggregated);


--
-- TOC entry 4127 (class 1259 OID 548159)
-- Name: codes_geometry_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX codes_geometry_idx ON data.codes_geometry USING btree (geometry_id, codes_id);


--
-- TOC entry 4133 (class 1259 OID 548160)
-- Name: fki_dataset_id_fx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX fki_dataset_id_fx ON data.geometry USING btree (dataset_id);


--
-- TOC entry 4132 (class 1259 OID 548161)
-- Name: fki_prefix_id_fk; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX fki_prefix_id_fk ON data.dataset USING btree (prefix_id);


--
-- TOC entry 4134 (class 1259 OID 548162)
-- Name: geometry_geography_20180404; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX geometry_geography_20180404 ON data.geometry USING gist (geography);

ALTER TABLE data.geometry CLUSTER ON geometry_geography_20180404;


--
-- TOC entry 4137 (class 1259 OID 548163)
-- Name: localid_geometry_geometry_id_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX localid_geometry_geometry_id_idx ON data.localid_geometry USING btree (geometry_id);


--
-- TOC entry 4138 (class 1259 OID 548164)
-- Name: localid_geometry_localid_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX localid_geometry_localid_idx ON data.localid_geometry USING btree (localid);


--
-- TOC entry 4128 (class 1259 OID 548165)
-- Name: predecessor_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX predecessor_idx ON data.codeshierarchy USING btree (predecessor);


--
-- TOC entry 4129 (class 1259 OID 548166)
-- Name: successor_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX successor_idx ON data.codeshierarchy USING btree (successor);


--
-- TOC entry 4141 (class 1259 OID 548167)
-- Name: value_description_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX value_description_idx ON data.prefix USING btree (value, description);


--
-- TOC entry 4144 (class 2606 OID 548168)
-- Name: geometry dataset_id_fx; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.geometry
    ADD CONSTRAINT dataset_id_fx FOREIGN KEY (dataset_id) REFERENCES data.dataset(id) ON DELETE CASCADE;


--
-- TOC entry 4142 (class 2606 OID 548173)
-- Name: codes_geometry geometry_id; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.codes_geometry
    ADD CONSTRAINT geometry_id FOREIGN KEY (geometry_id) REFERENCES data.geometry(id) ON DELETE CASCADE;


--
-- TOC entry 4145 (class 2606 OID 548178)
-- Name: localid_geometry geometry_id; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.localid_geometry
    ADD CONSTRAINT geometry_id FOREIGN KEY (geometry_id) REFERENCES data.geometry(id) ON DELETE CASCADE;


--
-- TOC entry 4143 (class 2606 OID 548183)
-- Name: dataset prefix_id_fk; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.dataset
    ADD CONSTRAINT prefix_id_fk FOREIGN KEY (prefix_id) REFERENCES data.prefix(id) ON DELETE CASCADE;


--
-- TOC entry 4288 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE v_geometry; Type: ACL; Schema: data; Owner: postgres
--

GRANT SELECT ON TABLE data.v_geometry TO reader;


-- Completed on 2018-12-12 16:05:20

--
-- PostgreSQL database dump complete
--

