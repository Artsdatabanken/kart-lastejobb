insert into data.codes_geometry (codes_id, geometry_id, code, aggregated)
select p.id as codes_id, cg.geometry_id, p.code, true
from 
data.codes s,
data.codes p,
data.codes_geometry cg,
data.codeshierarchy ch
where s.id = cg.codes_id
and s.code = ch.successor
and p.code = ch.predecessor
and not exists(
select 1 from 
data.codes_geometry cg1
where cg1.codes_id = p.id
and  cg1.geometry_id = cg.geometry_id
)
 group by p.id , cg.geometry_id, p.code 