--csomagk�ld� B script futatva van ld. tananyag
select * from cikk
select * from vev�
select * from csomag
select * from rendel�s
select * from rend_t�tel

--�sszetett megszorit�sok, adattra vonatkoz� megszorit�sok


--pl-k�nt egy rossz �gyvitelhez tartoz� megszorit�s:
--az �j rend_t�tel sor mennyis�ge <= cikksz�mhoz tartoz� akt_k�szlet (a Cikkben)
go
--kell 1 skal�rt vissza ad� fgv-t irni:
go
--f�ggv�ny
create function k�szlet
(
@cikk char(10)
)
returns smallint 
as 
begin
	return
	(
	select akt_k�szlet from cikk where cikksz�m=@cikk
	)

end

go

alter table rend_t�tel 
add check (menny<=dbo.k�szlet(cikksz�m) )

go

create view n�zet1 as 
select *, dbo.k�szlet(cikksz�m) as pill_k�szlete
from rend_t�tel 


--select * from n�zet1

--XOR nem kell m�shova ilyen fgv, e�rt a fgv-ben d�nt�nk, h ez az �rt�k j� e


alter table rend_t�tel with nocheck
add check (dbo.j�_k�szlet(cikksz�m, menny)=1)
