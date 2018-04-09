UPDATE data.geometry SET geometry=ST_Transform(geography::geometry, 3857);
CLUSTER data.geometry USING geometry_geography_20180404;