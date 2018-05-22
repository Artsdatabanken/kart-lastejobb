--
-- PostgreSQL database dump
--

-- Dumped from database version 10.2
-- Dumped by pg_dump version 10.2

-- Started on 2018-04-11 11:19:56

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 219630)
-- Name: data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA data;


ALTER SCHEMA data OWNER TO postgres;

--
-- TOC entry 1 (class 3079 OID 12924)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 4279 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 2 (class 3079 OID 129583)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 4280 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = data, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 213 (class 1259 OID 219631)
-- Name: codes; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE codes (
    id bigint NOT NULL,
    code text,
    title text
);


ALTER TABLE codes OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 219637)
-- Name: codes_geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE codes_geometry (
    geometry_id bigint NOT NULL,
    codes_id bigint NOT NULL
);


ALTER TABLE codes_geometry OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 219640)
-- Name: codes_id_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE codes_id_seq OWNER TO postgres;

--
-- TOC entry 4281 (class 0 OID 0)
-- Dependencies: 215
-- Name: codes_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE codes_id_seq OWNED BY codes.id;


--
-- TOC entry 216 (class 1259 OID 219642)
-- Name: codeshierarchy; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE codeshierarchy (
    id bigint NOT NULL,
    predecessor text,
    successor text
);


ALTER TABLE codeshierarchy OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 219648)
-- Name: codeshierarchy_id_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE codeshierarchy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE codeshierarchy_id_seq OWNER TO postgres;

--
-- TOC entry 4282 (class 0 OID 0)
-- Dependencies: 217
-- Name: codeshierarchy_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE codeshierarchy_id_seq OWNED BY codeshierarchy.id;


--
-- TOC entry 218 (class 1259 OID 219650)
-- Name: dataset; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE dataset (
    id bigint NOT NULL,
    prefix_id integer,
    description text
);


ALTER TABLE dataset OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 219656)
-- Name: dataset_id_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE dataset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dataset_id_seq OWNER TO postgres;

--
-- TOC entry 4283 (class 0 OID 0)
-- Dependencies: 219
-- Name: dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE dataset_id_seq OWNED BY dataset.id;


--
-- TOC entry 220 (class 1259 OID 219658)
-- Name: geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE geometry (
    id bigint NOT NULL,
    geography public.geography,
    geometry public.geometry(Geometry,3857),
    dataset_id integer
);


ALTER TABLE geometry OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 219664)
-- Name: geometry_id_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE geometry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE geometry_id_seq OWNER TO postgres;

--
-- TOC entry 4284 (class 0 OID 0)
-- Dependencies: 221
-- Name: geometry_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE geometry_id_seq OWNED BY geometry.id;


--
-- TOC entry 224 (class 1259 OID 219730)
-- Name: localid_geometry; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE localid_geometry (
    geometry_id bigint NOT NULL,
    localid text NOT NULL
);


ALTER TABLE localid_geometry OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 219666)
-- Name: prefix; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE prefix (
    id integer NOT NULL,
    value text,
    description text
);


ALTER TABLE prefix OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 219672)
-- Name: prefix_id_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE prefix_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prefix_id_seq OWNER TO postgres;

--
-- TOC entry 4285 (class 0 OID 0)
-- Dependencies: 223
-- Name: prefix_id_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE prefix_id_seq OWNED BY prefix.id;


--
-- TOC entry 4115 (class 2604 OID 219674)
-- Name: codes id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY codes ALTER COLUMN id SET DEFAULT nextval('codes_id_seq'::regclass);


--
-- TOC entry 4116 (class 2604 OID 219675)
-- Name: codeshierarchy id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY codeshierarchy ALTER COLUMN id SET DEFAULT nextval('codeshierarchy_id_seq'::regclass);


--
-- TOC entry 4117 (class 2604 OID 219676)
-- Name: dataset id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY dataset ALTER COLUMN id SET DEFAULT nextval('dataset_id_seq'::regclass);


--
-- TOC entry 4118 (class 2604 OID 219677)
-- Name: geometry id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY geometry ALTER COLUMN id SET DEFAULT nextval('geometry_id_seq'::regclass);


--
-- TOC entry 4119 (class 2604 OID 219678)
-- Name: prefix id; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY prefix ALTER COLUMN id SET DEFAULT nextval('prefix_id_seq'::regclass);


--
-- TOC entry 4122 (class 2606 OID 219680)
-- Name: codes codes_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY codes
    ADD CONSTRAINT codes_pk PRIMARY KEY (id);


--
-- TOC entry 4125 (class 2606 OID 219682)
-- Name: codeshierarchy codeshierarchy_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY codeshierarchy
    ADD CONSTRAINT codeshierarchy_pk PRIMARY KEY (id);


--
-- TOC entry 4129 (class 2606 OID 219684)
-- Name: dataset dataset_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY dataset
    ADD CONSTRAINT dataset_pk PRIMARY KEY (id);


--
-- TOC entry 4135 (class 2606 OID 219686)
-- Name: geometry geometry_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY geometry
    ADD CONSTRAINT geometry_pk PRIMARY KEY (id);


--
-- TOC entry 4137 (class 2606 OID 219688)
-- Name: prefix prefix_pk; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY prefix
    ADD CONSTRAINT prefix_pk PRIMARY KEY (id);


--
-- TOC entry 4120 (class 1259 OID 219689)
-- Name: code_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX code_idx ON codes USING btree (code);


--
-- TOC entry 4123 (class 1259 OID 219690)
-- Name: codes_geometry_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE UNIQUE INDEX codes_geometry_idx ON codes_geometry USING btree (geometry_id, codes_id);


-- Index: value_description_idx

-- DROP INDEX data.value_description_idx;

CREATE UNIQUE INDEX value_description_idx ON data.prefix USING btree (value, description);

--
-- TOC entry 4131 (class 1259 OID 219691)
-- Name: fki_dataset_id_fx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX fki_dataset_id_fx ON geometry USING btree (dataset_id);


--
-- TOC entry 4130 (class 1259 OID 219692)
-- Name: fki_prefix_id_fk; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX fki_prefix_id_fk ON dataset USING btree (prefix_id);


--
-- TOC entry 4132 (class 1259 OID 219693)
-- Name: geometry_geography_20180404; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX geometry_geography_20180404 ON geometry USING gist (geography);


--
-- TOC entry 4133 (class 1259 OID 219694)
-- Name: geometry_geometry_20180404; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX geometry_geometry_20180404 ON geometry USING gist (geometry);


--
-- TOC entry 4138 (class 1259 OID 219741)
-- Name: localid_geometry_geometry_id_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX localid_geometry_geometry_id_idx ON localid_geometry USING btree (geometry_id);


--
-- TOC entry 4139 (class 1259 OID 219742)
-- Name: localid_geometry_localid_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX localid_geometry_localid_idx ON localid_geometry USING btree (localid);


--
-- TOC entry 4126 (class 1259 OID 219695)
-- Name: predecessor_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX predecessor_idx ON codeshierarchy USING btree (predecessor);


--
-- TOC entry 4127 (class 1259 OID 219696)
-- Name: successor_idx; Type: INDEX; Schema: data; Owner: postgres
--

CREATE INDEX successor_idx ON codeshierarchy USING btree (successor);


--
-- TOC entry 4140 (class 2606 OID 219697)
-- Name: codes_geometry codes_id; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

--ALTER TABLE ONLY codes_geometry
--    ADD CONSTRAINT codes_id FOREIGN KEY (codes_id) REFERENCES codes(id) ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;


--
-- TOC entry 4143 (class 2606 OID 219702)
-- Name: geometry dataset_id_fx; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY geometry
    ADD CONSTRAINT dataset_id_fx FOREIGN KEY (dataset_id) REFERENCES dataset(id) ON DELETE CASCADE;


--
-- TOC entry 4141 (class 2606 OID 219707)
-- Name: codes_geometry geometry_id; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY codes_geometry
    ADD CONSTRAINT geometry_id FOREIGN KEY (geometry_id) REFERENCES geometry(id) ON DELETE CASCADE;


--
-- TOC entry 4144 (class 2606 OID 219736)
-- Name: localid_geometry geometry_id; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY localid_geometry
    ADD CONSTRAINT geometry_id FOREIGN KEY (geometry_id) REFERENCES geometry(id) ON DELETE CASCADE;


--
-- TOC entry 4142 (class 2606 OID 219712)
-- Name: dataset prefix_id_fk; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY dataset
    ADD CONSTRAINT prefix_id_fk FOREIGN KEY (prefix_id) REFERENCES prefix(id) ON DELETE CASCADE;


-- Completed on 2018-04-11 11:19:57

--
-- PostgreSQL database dump complete
--

