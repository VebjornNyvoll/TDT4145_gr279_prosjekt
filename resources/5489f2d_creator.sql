BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "Delstrekning" (
	"delstrekning_ID"	INT,
	"segment_lengde"	DECIMAL(10, 2) NOT NULL,
	"dobbeltspor"	BOOLEAN NOT NULL,
	"strekning_ID"	INT NOT NULL,
	FOREIGN KEY("strekning_ID") REFERENCES "Banestrekning"("strekning_ID") ON UPDATE CASCADE,
	PRIMARY KEY("delstrekning_ID")
);
CREATE TABLE IF NOT EXISTS "VognOppsett" (
	"vognoppsett_nr"	INT,
	PRIMARY KEY("vognoppsett_nr")
);
CREATE TABLE IF NOT EXISTS "Operatoer" (
	"operatoer_ID"	INT,
	"navn"	VARCHAR(255) NOT NULL,
	PRIMARY KEY("operatoer_ID")
);
CREATE TABLE IF NOT EXISTS "Togruteforekomst" (
	"forekomst_ID"	INT,
	"dato"	DATE NOT NULL,
	"rute_ID"	INT NOT NULL,
	FOREIGN KEY("rute_ID") REFERENCES "Togrute"("rute_ID") ON UPDATE CASCADE,
	PRIMARY KEY("forekomst_ID")
);
CREATE TABLE IF NOT EXISTS "Kunde" (
	"kunde_nr"	INT,
	"navn"	VARCHAR(255) NOT NULL,
	"epost"	VARCHAR(255) NOT NULL,
	"tlf_nr"	VARCHAR(255) NOT NULL,
	PRIMARY KEY("kunde_nr")
);
CREATE TABLE IF NOT EXISTS "Kundeordre" (
	"ordre_nr"	INT,
	"dag"	DATE NOT NULL,
	"tid"	TIME NOT NULL,
	"kunde_nr"	INT NOT NULL,
	FOREIGN KEY("kunde_nr") REFERENCES "Kunde"("kunde_nr") ON UPDATE CASCADE,
	PRIMARY KEY("ordre_nr")
);
CREATE TABLE IF NOT EXISTS "GaarAvStasjon" (
	"billett_ID"	INT,
	"stasjon_ID"	INT NOT NULL,
	FOREIGN KEY("stasjon_ID") REFERENCES "Stasjon"("stasjon_ID") ON UPDATE CASCADE,
	FOREIGN KEY("billett_ID") REFERENCES "Setebillett"("billett_ID") ON UPDATE CASCADE,
	PRIMARY KEY("billett_ID")
);
CREATE TABLE IF NOT EXISTS "GaarPaaStasjon" (
	"billett_ID"	INT,
	"stasjon_ID"	INT NOT NULL,
	FOREIGN KEY("stasjon_ID") REFERENCES "Stasjon"("stasjon_ID") ON UPDATE CASCADE,
	FOREIGN KEY("billett_ID") REFERENCES "Setebillett"("billett_ID") ON UPDATE CASCADE,
	PRIMARY KEY("billett_ID")
);
CREATE TABLE IF NOT EXISTS "StartDelStrekning" (
	"delstrekning_ID"	INT,
	"stasjon_ID"	INT,
	FOREIGN KEY("delstrekning_ID") REFERENCES "Delstrekning"("delstrekning_ID") ON UPDATE CASCADE,
	FOREIGN KEY("stasjon_ID") REFERENCES "Stasjon"("stasjon_ID") ON UPDATE CASCADE,
	PRIMARY KEY("delstrekning_ID","stasjon_ID")
);
CREATE TABLE IF NOT EXISTS "SluttDelStrekning" (
	"delstrekning_ID"	INT,
	"stasjon_ID"	INT,
	FOREIGN KEY("stasjon_ID") REFERENCES "Stasjon"("stasjon_ID"),
	FOREIGN KEY("delstrekning_ID") REFERENCES "Delstrekning"("delstrekning_ID"),
	PRIMARY KEY("delstrekning_ID","stasjon_ID")
);
CREATE TABLE IF NOT EXISTS "Banestrekning" (
	"strekning_ID"	INT,
	"strekning_navn"	VARCHAR(255) NOT NULL,
	"fremdriftsenergi"	VARCHAR(255),
	"hovedretning"	VARCHAR(255),
	PRIMARY KEY("strekning_ID")
);
CREATE TABLE IF NOT EXISTS "Togrute" (
	"rute_ID"	INT,
	"hovedretning"	BOOLEAN NOT NULL,
	"operatoer_ID"	INT NOT NULL,
	"vognopsett_nr"	INT NOT NULL,
	FOREIGN KEY("operatoer_ID") REFERENCES "Operatoer"("operatoer_ID") ON UPDATE CASCADE,
	FOREIGN KEY("vognopsett_nr") REFERENCES "VognOppsett"("vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("rute_ID")
);
CREATE TABLE IF NOT EXISTS "StartStasjon" (
	"togrute_ID"	INT,
	"stasjon_ID"	INT NOT NULL,
	"avgangstid"	TIME,
	FOREIGN KEY("stasjon_ID") REFERENCES "Stasjon"("stasjon_ID") ON UPDATE CASCADE,
	FOREIGN KEY("togrute_ID") REFERENCES "Togruteforekomst"("forekomst_ID") ON UPDATE CASCADE,
	PRIMARY KEY("togrute_ID")
);
CREATE TABLE IF NOT EXISTS "Endestasjon" (
	"togrute_ID"	INT,
	"stasjon_ID"	INT,
	"ankomsttid"	TIME,
	FOREIGN KEY("stasjon_ID") REFERENCES "Stasjon"("stasjon_ID") ON UPDATE CASCADE,
	FOREIGN KEY("togrute_ID") REFERENCES "Togruteforekomst"("forekomst_ID") ON UPDATE CASCADE,
	PRIMARY KEY("togrute_ID")
);
CREATE TABLE IF NOT EXISTS "Stasjon" (
	"stasjon_ID"	NUMERIC,
	"stasjon_navn"	VARCHAR(255) NOT NULL,
	"moh"	INT NOT NULL,
	PRIMARY KEY("stasjon_ID"),
	UNIQUE("stasjon_navn")
);
CREATE TABLE IF NOT EXISTS "MellomStasjon" (
	"togrute_ID"	INT,
	"stasjon_ID"	INT,
	"avgangstid"	TIME,
	"ankomsttid"	TIME,
	FOREIGN KEY("togrute_ID") REFERENCES "Togruteforekomst"("forekomst_ID") ON UPDATE CASCADE,
	FOREIGN KEY("stasjon_ID") REFERENCES "Stasjon"("stasjon_ID") ON UPDATE CASCADE,
	PRIMARY KEY("togrute_ID","stasjon_ID")
);
CREATE TABLE IF NOT EXISTS "Ukedag" (
	"rute_ID"	INT,
	"ukedag"	INT,
	PRIMARY KEY("rute_ID","ukedag"),
	FOREIGN KEY("rute_ID") REFERENCES "Togrute"("rute_ID") ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS "Vogn" (
	"vogn_ID"	INTEGER,
	"vognoppsett_nr"	INTEGER,
	"operatoer_ID"	INT,
	PRIMARY KEY("vogn_ID","vognoppsett_nr"),
	FOREIGN KEY("operatoer_ID") REFERENCES "Operatoer"("operatoer_ID") ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS "Sete" (
	"sete_nr"	INT,
	"vogn_ID"	INT NOT NULL,
	"vognoppsett_nr"	INT NOT NULL,
	PRIMARY KEY("sete_nr","vogn_ID","vognoppsett_nr"),
	FOREIGN KEY("vogn_ID","vognoppsett_nr") REFERENCES "Sittevogn"("vogn_ID","vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Sittevogn" (
	"vogn_ID"	INT,
	"seteRader"	INT NOT NULL,
	"seterPerRad"	INT NOT NULL,
	"vognoppsett_nr"	INT,
	PRIMARY KEY("vogn_ID","vognoppsett_nr"),
	FOREIGN KEY("vogn_ID","vognoppsett_nr") REFERENCES "Vogn"("vogn_ID","vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Seng" (
	"seng_nr"	INT,
	"kupe_nr"	INT NOT NULL,
	"vogn_ID"	INT NOT NULL,
	"vognoppsett_nr"	INT NOT NULL,
	PRIMARY KEY("seng_nr","vogn_ID","vognoppsett_nr"),
	FOREIGN KEY("kupe_nr","vogn_ID","vognoppsett_nr") REFERENCES "Sovekupe"("kupe_nr","vogn_ID","vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Sovevogn" (
	"vogn_ID"	INT,
	"sengerPerKupe"	INT,
	"vognoppsett_nr"	INT,
	PRIMARY KEY("vogn_ID","vognoppsett_nr"),
	FOREIGN KEY("vogn_ID","vognoppsett_nr") REFERENCES "Vogn"("vogn_ID","vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Setebillett" (
	"billett_ID"	INT,
	"sete_nr"	INT NOT NULL,
	"kupe_nr"	INT NOT NULL,
	"vogn_ID"	INT NOT NULL,
	"ordre_nr"	INT NOT NULL,
	"vognoppsett_nr"	INT,
	PRIMARY KEY("billett_ID"),
	FOREIGN KEY("sete_nr","vogn_ID","vognoppsett_nr") REFERENCES "Sete"("sete_nr","vogn_ID","vognoppsett_nr") ON UPDATE CASCADE,
	FOREIGN KEY("ordre_nr") REFERENCES "Kundeordre"("ordre_nr") ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Sovekupe" (
	"kupe_nr"	INT,
	"vogn_ID"	INT NOT NULL,
	"vognoppsett_nr"	INT,
	"kunde_nr"	INT,
	PRIMARY KEY("kupe_nr","vogn_ID","vognoppsett_nr"),
	FOREIGN KEY("vogn_ID","vognoppsett_nr") REFERENCES "Sovevogn"("vogn_ID","vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO "Delstrekning" VALUES (0,120,'true',0);
INSERT INTO "Delstrekning" VALUES (1,280,'false',0);
INSERT INTO "Delstrekning" VALUES (2,90,'false',0);
INSERT INTO "Delstrekning" VALUES (3,170,'false',0);
INSERT INTO "Delstrekning" VALUES (4,60,'false',0);
INSERT INTO "VognOppsett" VALUES (0);
INSERT INTO "VognOppsett" VALUES (1);
INSERT INTO "VognOppsett" VALUES (2);
INSERT INTO "Operatoer" VALUES (0,'SJ');
INSERT INTO "Togruteforekomst" VALUES (0,'2023-04-03',0);
INSERT INTO "Togruteforekomst" VALUES (1,'2023-04-03',1);
INSERT INTO "Togruteforekomst" VALUES (2,'2023-04-03',2);
INSERT INTO "Togruteforekomst" VALUES (3,'2023-04-04',0);
INSERT INTO "Togruteforekomst" VALUES (4,'2023-04-04',1);
INSERT INTO "Togruteforekomst" VALUES (5,'2023-04-04',2);
INSERT INTO "StartDelStrekning" VALUES (0,0);
INSERT INTO "StartDelStrekning" VALUES (1,1);
INSERT INTO "StartDelStrekning" VALUES (2,2);
INSERT INTO "StartDelStrekning" VALUES (3,3);
INSERT INTO "StartDelStrekning" VALUES (4,4);
INSERT INTO "SluttDelStrekning" VALUES (0,1);
INSERT INTO "SluttDelStrekning" VALUES (1,2);
INSERT INTO "SluttDelStrekning" VALUES (2,3);
INSERT INTO "SluttDelStrekning" VALUES (3,4);
INSERT INTO "SluttDelStrekning" VALUES (4,5);
INSERT INTO "Banestrekning" VALUES (0,'Nordlandsbanen','diesel','Trondheim - Bodø');
INSERT INTO "Togrute" VALUES (0,'true',0,0);
INSERT INTO "Togrute" VALUES (1,'true',0,0);
INSERT INTO "Togrute" VALUES (2,'false',0,0);
INSERT INTO "StartStasjon" VALUES (0,0,'07:49:00');
INSERT INTO "StartStasjon" VALUES (1,0,'23:05:00');
INSERT INTO "StartStasjon" VALUES (2,3,'08:11:00');
INSERT INTO "Endestasjon" VALUES (0,5,'17:34:00');
INSERT INTO "Endestasjon" VALUES (1,5,'09:05:00');
INSERT INTO "Endestasjon" VALUES (2,0,'14:13:00');
INSERT INTO "Stasjon" VALUES (0,'Trondheim',5.1);
INSERT INTO "Stasjon" VALUES (1,'Steinkjer',3.6);
INSERT INTO "Stasjon" VALUES (2,'Mosjøen',6.8);
INSERT INTO "Stasjon" VALUES (3,'Mo i Rana',3.5);
INSERT INTO "Stasjon" VALUES (4,'Fauske',34);
INSERT INTO "Stasjon" VALUES (5,'Bodø',4.1);
INSERT INTO "MellomStasjon" VALUES (0,1,'09:51:00','09:48:00');
INSERT INTO "MellomStasjon" VALUES (0,2,'13:20:00','13:17:00');
INSERT INTO "MellomStasjon" VALUES (0,3,'14:31:00','14:28:00');
INSERT INTO "MellomStasjon" VALUES (0,4,'16:49:00','14:46:00');
INSERT INTO "MellomStasjon" VALUES (1,1,'00:57:00','00:54:00');
INSERT INTO "MellomStasjon" VALUES (1,2,'04:41:00','04:38:00');
INSERT INTO "MellomStasjon" VALUES (1,3,'05:55:00','05:52:00');
INSERT INTO "MellomStasjon" VALUES (1,4,'08:19:00','08:16:00');
INSERT INTO "MellomStasjon" VALUES (2,2,'09:14:00','09:11:00');
INSERT INTO "MellomStasjon" VALUES (2,1,'12:31:00','12:28:00');
INSERT INTO "Ukedag" VALUES (0,0);
INSERT INTO "Ukedag" VALUES (0,1);
INSERT INTO "Ukedag" VALUES (0,2);
INSERT INTO "Ukedag" VALUES (0,3);
INSERT INTO "Ukedag" VALUES (0,4);
INSERT INTO "Ukedag" VALUES (1,0);
INSERT INTO "Ukedag" VALUES (1,1);
INSERT INTO "Ukedag" VALUES (1,2);
INSERT INTO "Ukedag" VALUES (1,3);
INSERT INTO "Ukedag" VALUES (1,4);
INSERT INTO "Ukedag" VALUES (1,5);
INSERT INTO "Ukedag" VALUES (1,6);
INSERT INTO "Ukedag" VALUES (2,0);
INSERT INTO "Ukedag" VALUES (2,1);
INSERT INTO "Ukedag" VALUES (2,2);
INSERT INTO "Ukedag" VALUES (2,3);
INSERT INTO "Ukedag" VALUES (2,4);
INSERT INTO "Vogn" VALUES (1,0,0);
INSERT INTO "Vogn" VALUES (2,0,0);
INSERT INTO "Vogn" VALUES (1,1,0);
INSERT INTO "Vogn" VALUES (2,1,0);
INSERT INTO "Vogn" VALUES (1,2,0);
INSERT INTO "Sete" VALUES (1,1,0);
INSERT INTO "Sete" VALUES (2,1,0);
INSERT INTO "Sete" VALUES (3,1,0);
INSERT INTO "Sete" VALUES (4,1,0);
INSERT INTO "Sete" VALUES (5,1,0);
INSERT INTO "Sete" VALUES (6,1,0);
INSERT INTO "Sete" VALUES (7,1,0);
INSERT INTO "Sete" VALUES (8,1,0);
INSERT INTO "Sete" VALUES (9,1,0);
INSERT INTO "Sete" VALUES (10,1,0);
INSERT INTO "Sete" VALUES (11,1,0);
INSERT INTO "Sete" VALUES (12,1,0);
INSERT INTO "Sete" VALUES (1,2,0);
INSERT INTO "Sete" VALUES (2,2,0);
INSERT INTO "Sete" VALUES (3,2,0);
INSERT INTO "Sete" VALUES (4,2,0);
INSERT INTO "Sete" VALUES (5,2,0);
INSERT INTO "Sete" VALUES (6,2,0);
INSERT INTO "Sete" VALUES (7,2,0);
INSERT INTO "Sete" VALUES (8,2,0);
INSERT INTO "Sete" VALUES (9,2,0);
INSERT INTO "Sete" VALUES (10,2,0);
INSERT INTO "Sete" VALUES (11,2,0);
INSERT INTO "Sete" VALUES (12,2,0);
INSERT INTO "Sete" VALUES (1,1,1);
INSERT INTO "Sete" VALUES (2,1,1);
INSERT INTO "Sete" VALUES (3,1,1);
INSERT INTO "Sete" VALUES (4,1,1);
INSERT INTO "Sete" VALUES (5,1,1);
INSERT INTO "Sete" VALUES (6,1,1);
INSERT INTO "Sete" VALUES (7,1,1);
INSERT INTO "Sete" VALUES (8,1,1);
INSERT INTO "Sete" VALUES (9,1,1);
INSERT INTO "Sete" VALUES (10,1,1);
INSERT INTO "Sete" VALUES (11,1,1);
INSERT INTO "Sete" VALUES (12,1,1);
INSERT INTO "Sete" VALUES (1,1,2);
INSERT INTO "Sete" VALUES (2,1,2);
INSERT INTO "Sete" VALUES (3,1,2);
INSERT INTO "Sete" VALUES (4,1,2);
INSERT INTO "Sete" VALUES (5,1,2);
INSERT INTO "Sete" VALUES (6,1,2);
INSERT INTO "Sete" VALUES (7,1,2);
INSERT INTO "Sete" VALUES (8,1,2);
INSERT INTO "Sete" VALUES (9,1,2);
INSERT INTO "Sete" VALUES (10,1,2);
INSERT INTO "Sete" VALUES (11,1,2);
INSERT INTO "Sete" VALUES (12,1,2);
INSERT INTO "Sittevogn" VALUES (1,3,4,0);
INSERT INTO "Sittevogn" VALUES (2,3,4,0);
INSERT INTO "Sittevogn" VALUES (1,3,4,1);
INSERT INTO "Sittevogn" VALUES (1,3,4,2);
INSERT INTO "Seng" VALUES (1,1,2,1);
INSERT INTO "Seng" VALUES (2,1,2,1);
INSERT INTO "Seng" VALUES (3,2,2,1);
INSERT INTO "Seng" VALUES (4,2,2,1);
INSERT INTO "Seng" VALUES (5,3,2,1);
INSERT INTO "Seng" VALUES (6,3,2,1);
INSERT INTO "Seng" VALUES (7,3,2,1);
INSERT INTO "Seng" VALUES (8,3,2,1);
INSERT INTO "Sovevogn" VALUES (2,2,1);
INSERT INTO "Sovekupe" VALUES (1,2,1,NULL);
INSERT INTO "Sovekupe" VALUES (2,2,1,NULL);
INSERT INTO "Sovekupe" VALUES (3,2,1,NULL);
INSERT INTO "Sovekupe" VALUES (4,2,1,NULL);
COMMIT;
