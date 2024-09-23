--csomagküldõ B script futatva van ld. tananyag
select * from cikk
select * from vevõ
select * from csomag
select * from rendelés
select * from rend_tétel

--üsszetett megszoritások, adattra vonatkozó megszoritások


--pl-ként egy rossz ügyvitelhez tartozó megszoritás:
--az új rend_tétel sor mennyisége <= cikkszámhoz tartozó akt_készlet (a Cikkben)
go
--kell 1 skalárt vissza adó fgv-t irni:
go
--függvény
create function készlet
(
@cikk char(10)
)
returns smallint 
as 
begin
	return
	(
	select akt_készlet from cikk where cikkszám=@cikk
	)

end

go

alter table rend_tétel 
add check (menny<=dbo.készlet(cikkszám) )

go

create view nézet1 as 
select *, dbo.készlet(cikkszám) as pill_készlete
from rend_tétel 


--select * from nézet1

--XOR nem kell máshova ilyen fgv, eért a fgv-ben döntünk, h ez az érték jó e


alter table rend_tétel with nocheck
add check (dbo.jó_készlet(cikkszám, menny)=1)
