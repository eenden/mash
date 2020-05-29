with mc1 as (
select tm.CaptionLong, tm.RoadID, nt.Caption, tm.EnterpriseID, count(*) as countIncidentsByRoads
from test_months tm
join incidents_nsi_types nt on (nt.id = tm.ID_SP_NAR)
where tm.Date_NAR > :start_date and tm.Date_NAR < :finish_date
group by tm.CaptionLong, tm.RoadID, nt.Caption, tm.EnterpriseID
),
mc2 as (
select 
	mc1.CaptionLong, 
	mc1.RoadID, 
	mc1.Caption, 
	mc1.EnterpriseID, 
	mc1.countIncidentsByRoads,
	rank() over(PARTITION by mc1.EnterpriseID order by mc1.countIncidentsByRoads desc) as rn
from mc1
)
select 
	mc2.CaptionLong, 
	mc2.RoadID, 
	mc2.Caption, 
	mc2.EnterpriseID, 
	mc2.countIncidentsByRoads
from mc2
where rn <= 10
order by rn