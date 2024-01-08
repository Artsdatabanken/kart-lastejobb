REFRESH MATERIALIZED VIEW data.v_geometry;

CLUSTER data.v_geometry USING v_geometry_geometry_idx;

REFRESH MATERIALIZED VIEW data.v_geometry_all;

CLUSTER data.v_geometry_all USING v_geometry_allgeometry_idx;
