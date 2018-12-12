REFRESH MATERIALIZED VIEW data.v_geometry;

CLUSTER data.v_geometry USING v_geometry_geometry_idx;