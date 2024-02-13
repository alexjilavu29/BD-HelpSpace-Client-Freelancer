DROP TABLE IF EXISTS freelancer CASCADE;
CREATE TABLE freelancer (
	freelancer_id int NOT NULL GENERATED ALWAYS AS IDENTITY,
	nume_f VARCHAR(25) NOT NULL,
	prenume_f VARCHAR(25) NOT NULL,
	email_f VARCHAR(100) NOT NULL,
	numar_telefon_f VARCHAR(15),
	parola_cont_f VARCHAR(25),
	domeniu_activitate VARCHAR(25),
	pregatire_profesionala VARCHAR[],
	experienta DATE,
	auto_evaluare INT NOT NULL CHECK (auto_evaluare>=1) CHECK (auto_evaluare<=5),
	rating FLOAT DEFAULT 10,
	PRIMARY KEY (freelancer_id)
);
ALTER TABLE freelancer OWNER TO postgres;

DROP TABLE IF EXISTS client CASCADE;
CREATE TABLE client (
	client_id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
	nume_c VARCHAR(25) NOT NULL,
	prenume_c VARCHAR(25) NOT NULL,
	cont_id INT NOT NULL,
	nivel_cont INT NOT NULL,
	nume_cont VARCHAR(25),
	email_client VARCHAR(100) NOT NULL,
	numar_telefon VARCHAR(15),
	parola_cont VARCHAR(25),
	rating FLOAT DEFAULT 10,
	PRIMARY KEY (client_id),
	CONSTRAINT cont_nivel_idfk FOREIGN KEY (cont_id) REFERENCES cont (cont_id)
);
ALTER TABLE client OWNER TO postgres;

DROP TABLE IF EXISTS cont CASCADE;
CREATE TABLE cont (
	cont_id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
	nivel INT NOT NULL CHECK ((nivel>=1) and (nivel<=4)),
	nume VARCHAR(25) NOT NULL,
	pret INT DEFAULT 0 CHECK ((pret=0) or (pret=25)),
	comision INT DEFAULT 5 CHECK ((comision>=0) and (comision<=5)),
	timp_lucru_maxim INT NOT NULL CHECK ((timp_lucru_maxim>=1) and (timp_lucru_maxim<=5)),
	reducere INT DEFAULT 0 CHECK ((reducere=0) or (reducere=15)),
	PRIMARY KEY (cont_id)
);
ALTER TABLE cont OWNER TO postgres;

DROP TABLE IF EXISTS comanda CASCADE;
CREATE TABLE comanda(
	comanda_id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
	nume VARCHAR(25) NOT NULL,
	client_id INT NOT NULL,
	freelancer_id INT NOT NULL,
	descriere VARCHAR(250) NOT NULL, 
	pret INT DEFAULT 1,
	timp_lucru INT,
	PRIMARY KEY (comanda_id),
	CONSTRAINT id_client_comanda FOREIGN KEY (client_id) REFERENCES client (client_id),
	CONSTRAINT id_freelancer_comanda FOREIGN KEY (freelancer_id) REFERENCES freelancer (freelancer_id)
);
ALTER TABLE comanda OWNER TO postgres;

DROP TABLE IF EXISTS reprezentant CASCADE;
CREATE TABLE reprezentant (
	reprezentant_id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
	nume_reprezentant VARCHAR(50) NOT NULL,
	domeniu_reprezentant VARCHAR(25) NOT NULL,
	PRIMARY KEY (reprezentant_id)
);
ALTER TABLE reprezentant OWNER TO postgres;

DROP TABLE IF EXISTS workshop CASCADE;
CREATE TABLE workshop(
	workshop_id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
	freelancer_id INT NOT NULL,
	reprezentant_id_w INT NOT NULL,
	ora_incepere TIME NOT NULL,
	ora_terminare TIME NOT NULL,
	locatie VARCHAR(100) NOT NULL,
	subiect VARCHAR(100) NOT NULL,
	domeniu_activitate VARCHAR(25),
	PRIMARY KEY (workshop_id),
	CONSTRAINT id_freelancer_workshop FOREIGN KEY (freelancer_id) REFERENCES freelancer (freelancer_id)
);
ALTER TABLE workshop OWNER TO postgres;

CREATE TABLE domeniu_activitate(
	domeniu_id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
	tip VARCHAR(25) NOT NULL,
	PRIMARY KEY (domeniu_id)
);
ALTER TABLE domeniu_activitate OWNER TO postgres;

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
