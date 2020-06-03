select t.persID as persID, (t.LastName || ' ' || t.FirstName || ' ' || t.PatrName) as person, x.count2 as count2, count(distinct t.id_sp_nar) as count1
from test_months t
join 
(
select tm.persID, count(distinct tm.ID_SP_NAR) as count2
from test_months tm
where tm.'табельный номер инструктора' = :minstr
and tm.Date_NAR > :start_date_2 and tm.Date_NAR < :finish_date_2
group by tm.persID
) x on (x.PersID = t.PersID)
where t.'табельный номер инструктора' = :minstr
and t.Date_NAR > :start_date_1 and t.Date_NAR < :finish_date_1
group by t.persID, t.LastName || ' ' || t.FirstName, x.count2
order by count(distinct t.id_sp_nar) desc