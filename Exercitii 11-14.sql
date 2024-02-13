-- Exericitul 11

-- ________________Filtrare la nivel de linii___________________

-- * Vizualizarea clientilor dupa id, nume, prenume si rating:

SELECT
		c.client_id AS client_id,
		c.nume_c AS nume_c,
		c.prenume_c AS prenume_c,
		c.rating AS rating
	FROM
		client c;

-- _________Subcereri sincronizate în care intervin cel puțin 3 tabele__________

-- Vizualizarea tuturor clientilor cu numele nivelului de cont al fiecăruia și comanda facuta de fiecare.

SELECT 
 	(SELECT nume_c FROM client WHERE client_id = a.client_id) AS nume_c,
	a.prenume_c,
	(SELECT nume FROM cont WHERE nivel = a.nivel_cont) AS nivel_cont,
	(SELECT nume FROM comanda WHERE client_id = a.client_id) AS nume
FROM client a

--__________Subcereri nesincronizate în care intervin cel puțin 3 tabele / Grupari de date _________

-- Vizualizarea tuturor domeniilor de activitate, cu numele si prenumele fiecarui freelancer care activeaza in domeniu + Totalul domeniilor, freelanceri-lor si workshop-urilor

SELECT
	b.tip AS domeniu_de_activitate,
	a.nume_f AS nume_freelancer,
	a.prenume_f AS prenume_freelancer,
	(SELECT COUNT(domeniu_id) FROM domeniu_activitate) AS total_domenii_de_activitate,
	(SELECT COUNT(freelancer_id) FROM freelancer) AS total_freelanceri,
	(SELECT COUNT(workshop_id) FROM workshop) AS total_workshops
	FROM freelancer a
INNER JOIN domeniu_activitate b ON a.domeniu_activitate = b.tip	


SELECT
	b.tip AS domeniu_de_activitate,
	a.nume_f AS nume_freelancer,
	a.prenume_f AS prenume_freelancer,
	(SELECT COUNT(domeniu_id) FROM domeniu_activitate) AS total_domenii_de_activitate,
	(SELECT COUNT(freelancer_id) FROM freelancer) AS total_freelanceri,
	(SELECT COUNT(workshop_id) FROM workshop) AS total_workshops
	FROM freelancer a
INNER JOIN domeniu_activitate b ON a.domeniu_activitate = b.tip	



-- _______________________________ORDONARI__________________________________

-- Vizualizarea tuturor clientilor in ordinea nivelului de cont al fiecaruia

SELECT
	a.nivel_cont AS nivel_cont,
	LOWER(a.nume_c) AS nume_client,     -- Functia LOWER pe sir de caractere
	UPPER(a.prenume_c) AS prenume_client    -- Functia UPPER pe sir de caractere
	FROM client a
ORDER BY nivel_cont

-- ___________Utilizarea a cel puțin 2 funcții pe șiruri de caractere, 2 funcții pe date 
-- calendaristice, a funcțiilor NVL și DECODE, a cel puțin unei expresii CASE___________

-- Acestea au fost indeplinite pe parcursul proiectului

-- _________________Utilizarea a cel puțin 1 bloc de cerere(clauza WITH)__________________

-- Vizualizarea tuturor workshop-urilor, cu o clasificare in functie de timpul din zi in care se petrec. Se va afisa totodata o concatenare a numelui complet al 
-- organizatorului, ora de incepere, minutele de incepere si numele reprezentantului care va supraveghea intalnirea

WITH selectare AS (
	SELECT a.subiect AS SUBIECT, 
	(SELECT CONCAT(nume_f,' ',prenume_f) FROM freelancer WHERE freelancer_id = a.freelancer_id) AS ORGANIZATOR,
	EXTRACT('HOUR' FROM a.ora_incepere) AS ORA_INCEPERE, 
	EXTRACT('MINUTE' FROM a.ora_incepere) AS MINUTE_INCEPERE,
	(SELECT nume_reprezentant FROM reprezentant WHERE a.reprezentant_id=reprezentant_id) AS REPREZENTANT
	FROM workshop a
)
SELECT 
	CASE    -- Functia CASE
		WHEN selectare.ORA_INCEPERE < 12 
			THEN 'AM' 
			ELSE 'PM' 
	END 
AS VALUE, 
* FROM selectare

-- Exericitiul 12

-- ___Implementarea a 3 operații de actualizare sau suprimare a datelor utilizând subcereri___

-- Actualizarea numelui de cont in functie de o schimbare la nivelul tabelului "cont"

UPDATE client
	SET nume_cont = (SELECT nume FROM cont c WHERE nivel_cont=c.cont_id);
SELECT * FROM client

-- Actualizarea nivelului de cont in functie de id-ul contului

UPDATE client
	SET nivel_cont = cont_id;

-- Actualizarea domeniului de activitate al unui workshop in functie de domeniul de activitate al reprezentantului care supravegheaza acel workshop

UPDATE workshop
	SET domeniu_activitate = (SELECT domeniu_reprezentant FROM reprezentant r WHERE reprezentant_id_w=r.reprezentant_id);
SELECT * FROM workshop

-- Exercitiul 13

-- __Crearea unei secvențe ce va fi utilizatăîn inserarea înregistrărilor în tabele(punctul 10)__

INSERT INTO freelancer (nume_f,prenume_f,email_f,numar_telefon_f,parola_cont_f,domeniu_activitate,pregatire_profesionala,experienta,auto_evaluare,rating)
	VALUES	('Popescu','Ionel','popescuionel@yahoo.com',0712345678,'popion','Muzica','{curs_producer,scoala_de_muzica}','05.02.2002',4,8.4),
			('Georgescu','Andrei','georgescuandrei@yahoo.com',0742342678,'geoand','Desen','{scoala_de_desen}','09.12.2017',2,5.6),
			('Calinescu','Alin','calinescualin@yahoo.com',0759482741,'calali','Desen','{}','12.12.2019',3,2.7),
			('Sandu','Maria','sandumaria@yahoo.com',0757462715,'sanmar','Desen','{olimpiada_desen}','5.06.2016',4,8.9),
			('Robert','Ioana','robertioana@yahoo.com',0754362172,'robioa','Arhitectura','{facultate_arhitectura, doctorat_arhitectura}','4.08.2012',5,9.7);

INSERT INTO client (nume_c, prenume_c, cont_id,nivel_cont, nume_cont, email_client, numar_telefon, parola_cont, rating)
	VALUES	('Cojocaru','Andrei',3,3,NULL,'cojocaruandrei@yahoo.com',0748266836,'cojand',9.2),
			('Andreescu','Florina',4,4,NULL,'andreescuflorina@yahoo.com',NULL,'andflo',4.5),
			('Ionescu','Andreea',1,1,NULL,'ionescuandreea@yahoo.com',0746276549,'ionand',7.5),
			('Rosu','Ion',2,2,NULL,'rosuion@yahoo.com',NULL,'rosion',8.1),
			('Verde','Simona',1,1,NULL,'verdesimona@yahoo.com',0747361953,'versim',4.8),
			('Albastru','George',4,4,NULL,'albastrugeorge@yahoo.com',NULL,'albgeo',1.2);
			
INSERT INTO comanda (nume,client_id,freelancer_id,descriere,pret,timp_lucru)
	VALUES	('Logo patiserie',3,4,'As dori un logo pentru patiseria mea!',50,4),
			('Pancarta show',1,2,'Buna ziua. Am nevoie de o pancarta pentru show-ul meu de stand-up.',150,2),
			('Intro scurtmetraj',4,1,'Buna seara. Sunt un tanar regizor de film. As dori un intro pentru noul meu film de scurtmetraj. Am atasat videoclipul mai jos.',250,2);
			

INSERT INTO cont (nivel,nume,pret,comision,timp_lucru_maxim,reducere)
	VALUES	(1,'Cont Casual',0,5,4,0),
			(2,'Cont Premium',25,0,2,0),
			(3,'Cont Fidel',0,1,2,0),
			(4,'Cont Fidel PLUS',25,0,1,15);
			
INSERT INTO reprezentant (nume_reprezentant,domeniu_reprezentant)
	VALUES	('Ramian Roberta', 'Desen'),
			('Bogdan Florin', 'Muzica'),
			('Cosmin Flavius', 'Arhitectura');

INSERT INTO workshop (freelancer_id,reprezentant_id_w,ora_incepere,ora_terminare,locatie,subiect,domeniu_activitate)
	VALUES	(2,1,'10:30','12:30','Parcul Herastrau','Invatam sa desenam portrete!',NULL),
			(4,1,'8:00','10:00','Parcul Iore','Buna dimineata ARTA!',NULL),
			(4,1,'22:00','00:00','Piata Unirii','Arta cosmica! Invatam sa desenam cerul instelat',NULL),
			(1,3,'12:00','15:00','Piata Unirii 15','Corul creativ',NULL),
			(1,3,'11:00','12:00','Piata Unirii 15','Invatam sa ne incalzim corzile vocale',NULL),
			(1,3,'16:00','17:00','Aviatorilor Nr. 26','Pregatiri pentru competitie de muzica si dans',NULL),
			(5,2,'14:00','16:00','Giulesti, Strada Florilor, Nr. 29','Schitam propia casa in 3D!',NULL);
			
INSERT INTO domeniu_activitate (tip)
	VALUES	('Muzica'),
			('Desen'),
			('Arhitectura');

-- Exercitiul 14 
-- _______Crearea  unei  vizualizări  compuse.  Dați  un  exemplu  de  operație  LMD permisă pe 
--vizualizarea respectivă și un exemplu de operație LMD nepermisă.______________________________

-- Exemplu de operatie LMD permisa

-- Creeare vizualizare compusa pentru stergerea datelor dintr-una din coloanele din tabelul initial

CREATE VIEW vizualizare_compusa AS
	SELECT nume_f, prenume_f, email_f, domeniu_activitate FROM freelancer;
SELECT * FROM vizualizare_compusa
UPDATE vizualizare_compusa 
	SET domeniu_activitate=NULL;
SELECT * FROM freelancer

-- O operatie LMD nepermisa este aceea de a selecta date din mai multe tabele, intrucat vizualizarea compusa
-- nu se va mai putea actualiza automat. 

-- Exemplu de operatie LMD nepermisa

CREATE VIEW vizualizare_compusa_nepermisa AS
	SELECT 
	b.tip AS domeniu_de_activitate,
	a.nume_f AS nume_freelancer,
	a.prenume_f AS prenume_freelancer,
	(SELECT COUNT(domeniu_id) FROM domeniu_activitate) AS total_domenii_de_activitate,
	(SELECT COUNT(freelancer_id) FROM freelancer) AS total_freelanceri,
	(SELECT COUNT(workshop_id) FROM workshop) AS total_workshops
	FROM freelancer a
	INNER JOIN domeniu_activitate b ON domeniu_activitate = b.tip;	
	SELECT * FROM vizualizare_compusa_nepermisa

