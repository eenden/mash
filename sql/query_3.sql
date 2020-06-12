with mc1 as (
select 
	t.id_sp_nar, 
	nt.Caption, 
	(t.LastName || ' ' || t.FirstName || ' ' || t.PatrName) as person,
	t.persID as persID,
	count(*) as _count, 
	x.totalCount as totalCount
from test_months t
join incidents_nsi_types nt on (nt.id = t.id_sp_nar)
join (
	select t.ID_SP_NAR, count(*) as totalCount
	from test_months t
	where t.Date_NAR > :start_date and t.Date_NAR < :finish_date
	and t.'табельный номер инструктора' = :minstr
	group by t.ID_SP_NAR
) x on (t.ID_SP_NAR = x.ID_SP_NAR)
where t.'табельный номер инструктора' = :minstr
and t.Date_NAR > :start_date and t.Date_NAR < :finish_date
group by t.id_sp_nar, nt.Caption, (t.LastName || ' ' || t.FirstName), t.persID
order by _count desc
),
mc2 as (
select 
	ID_SP_NAR as id_sp_nar, 
	Caption as caption, 
	mc1.persID as persID,
	mc1.person as person,
	mc1._count as _count,
	mc1.totalCount as totalCount,
	round(cast(_count as float) / cast(totalCount as float) * 100, 2) as ver 
from mc1
order by ver desc
)
select 
	id_sp_nar as id_sp_nar, 
	caption as caption,
	mc2.persID as persID,
	mc2.person as person,
	mc2._count as _count,
	mc2.totalCount as totalCount,
	mc2.ver as ver,
	case 
		when mc2.ver < 20 then 0
		when mc2.ver >= 20 and mc2.ver < 50 then 1
		else 2
	end as risk
from mc2