select t.persID as persID, (t.LastName || ' ' || t.FirstName || ' ' || t.PatrName) as person, count(distinct id_sp_nar) as _count
from test_months t
where t.'табельный номер инструктора' = :minstr
and Date_NAR > :start_date and Date_NAR < :finish_date
group by t.persID, t.LastName || ' ' || t.FirstName
order by count(distinct id_sp_nar) desc