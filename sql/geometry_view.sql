-- View: data.v_geometry

-- DROP VIEW data.v_geometry;

CREATE OR REPLACE VIEW data.v_geometry AS
 SELECT ROW_NUMBER () OVER (ORDER BY g.id) as id,
    g.id as geometry_id,
    g.geography,
    g.geometry,
	c.code,
	c.title,
	CASE WHEN l_g.localid is null THEN ''
     ELSE l_g.localid
	END as localid,
	p.value,
	p.description as prefixdescription,
	d.description as datasetdescription
   FROM data.geometry g left join data.localid_geometry l_g on g.id =  l_g.geometry_id,
    data.codes_geometry c_g,
    data.dataset d,
    data.prefix p,
    data.codes c
	where g.id = c_g.geometry_id and c_g.codes_id = c.id and g.dataset_id = d.id and p.id = d.prefix_id;

ALTER TABLE data.v_geometry
    OWNER TO postgres;
	
GRANT SELECT ON TABLE data.v_geometry TO reader;

