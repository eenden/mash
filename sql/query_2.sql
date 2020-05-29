with mc1 as (
select t.id_sp_nar, nt.Caption, count(*) as _count, x.totalCount
from test_months t
join incidents_nsi_types nt on (nt.id = t.id_sp_nar)
join (
	select t.ID_SP_NAR, count(*) as totalCount
	from test_months t
	where t.Date_NAR > :start_date and t.Date_NAR < :finish_date
	group by t.ID_SP_NAR
) x on (t.ID_SP_NAR = x.ID_SP_NAR)
where t.'табельный номер инструктора' = :minstr 
and t.Date_NAR > :start_date and t.Date_NAR < :finish_date
group by t.id_sp_nar, nt.Caption
order by _count desc
limit 10
)
select ID_SP_NAR, Caption, round(cast(_count as float) / cast(totalCount as float) * 100, 2) as ver 
from mc1
order by ver desc