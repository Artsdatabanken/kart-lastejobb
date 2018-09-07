select na.code, na.area, count(g.id) from
    (
    select agg.code, round(st_area(agg.geom)) as area, geom from 
        (
            select ch.predecessor as code, ST_Collect(g.geography::geometry)::geography as geom 
            from data.geometry g, data.codes_geometry cg, data.codeshierarchy ch 
            where g.id = cg.geometry_id and cg.code like 'NA_%' and ch.successor = cg.code
            group by ch.predecessor

            union all

            select lowest.code, ST_Collect(g.geography::geometry)::geography as geom 
            from
            (
                SELECT c.code
                FROM data.codes c
                LEFT JOIN (		
                    select ch.predecessor as code 
                    from data.geometry g, data.codes_geometry cg, data.codeshierarchy ch 
                    where g.id = cg.geometry_id and cg.code like 'NA_%' and ch.successor = cg.code
                    group by ch.predecessor) as existing ON existing.code = c.code
                WHERE existing.code IS NULL and c.code like 'NA_%'
            ) as lowest, data.geometry g, data.codes_geometry cg
            where g.id = cg.geometry_id and cg.code like 'NA_%' and cg.code = lowest.code
            group by lowest.code
        ) as agg
    ) as na, data.geometry g, data.codes_geometry cg
    where g.id = cg.geometry_id and cg.code like 'AR_%' and st_intersects(na.geom, g.geography)
    group by na.code, na.area
    order by na.code
