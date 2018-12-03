-- View: data."areaAndObservations"

-- DROP VIEW data."areaAndObservations";

CREATE MATERIALIZED VIEW data."areaAndObservations" AS
 SELECT na.id,
    count(ar.id) AS observationcount,
	st_area(na.geography) as area
   FROM data.geometry na,
    data.geometry ar,
    data.dataset na_d,
    data.dataset ar_d,
    data.prefix na_p,
    data.prefix ar_p
  WHERE na_d.id = na.dataset_id AND ar_d.id = ar.dataset_id AND na_p.id = na_d.prefix_id AND ar_p.id = ar_d.prefix_id AND na_p.value = 'NA'::text AND ar_p.value = 'AR'::text AND st_intersects(ar.geography, na.geography)
  GROUP BY na.id
  WITH data;

ALTER TABLE data."areaAndObservations"
    OWNER TO postgres;

