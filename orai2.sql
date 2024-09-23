-- normaliz�l�s, 
-- szerk. b�v, Patika fh. funkci�ira

create database patika

use patika

create table Orvos
(
k�d int,
nev varchar(30) not null,
szak char(40) not null,
primary key (k�d)
)


insert into orvos values (12345, 'dr M�z', 'gyerekorvos')
select * from orvos

insert into orvos values (54321, 'dr M�z', 'gyerekorvos')
insert into orvos values (55555, 'dr �', 'sz�l�sz-n�gy�gy�sz')

-- fa: a SZK legyen sz�t�razott... az adatok el ne vesszenek!

create table Szak
(
szak int identity(11,1), -- autoincrement
megnevez�s char(40),
primary key (szak)
)

insert into szak
select distinct szak
from orvos

create unique index neves1 on szak (megnevez�s)
insert into szak values ('onkol�gus')

select * from szak
select * from orvos

alter table orvos
add szaKK int

select szak.szak 
from orvos 
	inner join szak on orvos.szak=szak.megnevez�s


update orvos
set szakk=(select szak from szak where szak.megnevez�s=orvos.szak)
-- ott a KKnak val� �rt�k a r�gi sz.

alter table orvos
drop column szak

-- �tnevezhet� ...
alter table orvos
add foreign key (szakk) references szak (szak) 


select * from szak
select * from orvos

-- ez 1 pl. volt egy�b szerk.v�ltoztat�si munk�ra


-- BETEG (taj_sz�m, n�v, sz�l_d�tum, lakhely) 

create table beteg
(
tajsz�m char(9),
n�v varchar (30),
sz�l_d�tum date,
lakhely varchar(60), --�rdemes 3 mez�ben tartani
primary key (tajsz�m)
)

-- V�NY (azonos�t�, fel�r�s_kelt, bev�lt�s_kelt, orvos, taj_sz�m)

create table v�ny
(
azonos�t� int,
fel�r�s_kelt date,
bev�lt�s_kelt date,
orvos int,
tajsz�m char(9)
primary key (azonos�t�),
foreign key (orvos) references orvos(k�d),
foreign key (tajsz�m) references beteg(tajsz�m)
)

----------------------------
--2024.09.23
use patika
--FAJTA(fajta,le�r�s)
create table FAJTA
(
fajta int identity(101,1), --identity: egyedi azonosit�ja lesz a rekordoknak, aut matikusan hozza l�tre 
le�r�s char (30),
primary key (fajta),
)

create unique index fajta_egyedi --hogy ne lehessen t�bsz�r felvinni hogy pl l�zcsilapito. Hozz l�tre egy egyedi indexet a fajta t�bl�bol a le�r�s szerint
on fajta(le�r�s)

insert into fajta values ('lazcsillapit�')

select * from fajta
insert into fajta values ('k�ptet�')

select ident_current('fajta')--az utolj�ra dobott,gener�lt azonos�t� az adott t�bl�ban

--GY�GYSZER (gysz�m, lenevez�s, fajta, egys_�r, k�szlet)
--k�s�bb lesz: hat�anyag, v�nyes_e
create table GY�GYSZER (
gysz�m int PRIMARY KEY,
elenevez�s  varchar(40) not null, --k�telez� �rt�ket adni neki
fajta int not null,
v�nyes_e bit not null,
foreign key(fajta) references fajta(fajta) --Gy�gyszer fajta oszlopa kapcsolatban, idegen kulcsa a fajta t�bla fajt�val
)

create table KISZEREL�S
(
k_azon int identity(1,1),
tartalom char(20),
mennyis�g smallint,
m�rt�kegys�g char(3) not null
)

insert into KISZEREL�S values 
('tabletta', 10, 'db'),
('tabletta', 30, 'db')

select * from KISZEREL�S


--TERM�K(tk�d, gy�gyszer, kiszerel�s, e�r1, e�r2, e�r3, k�szlet)
create table TERM�K
(
tk�d int,
gy�gyszer int not null ,
kiszerel�s int not null,
e�r1 money not null,
e�r2 money not null,
e�r3 money not null,
--k�szlete nem ennek hanem a lej�rattol f�gg� term�knek lesz
primary key (tk�d),
foreign key (gy�gyszer) references gy�gyszer (gysz�m),
--foreign key (kiszerel�s) references kiszerel�s (k_azon),
check(e�r1>=0),
check(e�r2>=0),
check(e�r3>=0),
--1 csheck is lehetet volna itt zezzel a felt�telel: (e�e>0 and e�r2>=0 and e�r3>=0)

)

select * from term�k
select * from gy�gyszer
select * from fajta
select * from KISZEREL�S


insert into gy�gyszer values (12345, 'Algopyrin', 101, 0);

insert into term�k values 
(0102030405, 12345, 1, 2200, 2200, 0)

insert into term�k values 
(1020304050, 12345, 2, 4400, 4400, 0)

insert into term�k values 
(20405060, 12345, 2, 4400, 4400, -230)
