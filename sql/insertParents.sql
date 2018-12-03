insert into data.codes_geometry (codes_id, geometry_id, code, fraction, created)
select p.id as codes_id, cg.geometry_id, p.code, cg.fraction, cg.created from 
data.codes s,
data.codes p,
data.codes_geometry cg
where s.id = cg.codes_id
and p.predecessor = s.code
and not exists(
select 1 from 
data.codes_geometry cg1
where cg1.codes_id = p.id
and  cg1.geometry_id = cg.geometry_id

)