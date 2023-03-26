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
CREATE TABLE IF NOT EXISTS "GaarAvStasjon" (
	"billett_ID"	INT,
	"stasjon_ID"	INT NOT NULL,
	FOREIGN KEY("billett_ID") REFERENCES "Setebillett"("billett_ID") ON UPDATE CASCADE,
	FOREIGN KEY("stasjon_ID") REFERENCES "Stasjon"("stasjon_ID") ON UPDATE CASCADE,
	PRIMARY KEY("billett_ID")
);
CREATE TABLE IF NOT EXISTS "GaarPaaStasjon" (
	"billett_ID"	INT,
	"stasjon_ID"	INT NOT NULL,
	FOREIGN KEY("billett_ID") REFERENCES "Setebillett"("billett_ID") ON UPDATE CASCADE,
	FOREIGN KEY("stasjon_ID") REFERENCES "Stasjon"("stasjon_ID") ON UPDATE CASCADE,
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
	FOREIGN KEY("delstrekning_ID") REFERENCES "Delstrekning"("delstrekning_ID"),
	FOREIGN KEY("stasjon_ID") REFERENCES "Stasjon"("stasjon_ID"),
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
	FOREIGN KEY("vognopsett_nr") REFERENCES "VognOppsett"("vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("operatoer_ID") REFERENCES "Operatoer"("operatoer_ID") ON UPDATE CASCADE,
	PRIMARY KEY("rute_ID")
);
CREATE TABLE IF NOT EXISTS "StartStasjon" (
	"togrute_ID"	INT,
	"stasjon_ID"	INT NOT NULL,
	"avgangstid"	TIME,
	FOREIGN KEY("togrute_ID") REFERENCES "Togruteforekomst"("forekomst_ID") ON UPDATE CASCADE,
	FOREIGN KEY("stasjon_ID") REFERENCES "Stasjon"("stasjon_ID") ON UPDATE CASCADE,
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
	FOREIGN KEY("rute_ID") REFERENCES "Togrute"("rute_ID") ON UPDATE CASCADE,
	PRIMARY KEY("rute_ID","ukedag")
);
CREATE TABLE IF NOT EXISTS "Vogn" (
	"vogn_ID"	INTEGER,
	"vognoppsett_nr"	INTEGER,
	"operatoer_ID"	INT,
	FOREIGN KEY("operatoer_ID") REFERENCES "Operatoer"("operatoer_ID") ON UPDATE CASCADE,
	PRIMARY KEY("vogn_ID","vognoppsett_nr")
);
CREATE TABLE IF NOT EXISTS "Sete" (
	"sete_nr"	INT,
	"vogn_ID"	INT NOT NULL,
	"vognoppsett_nr"	INT NOT NULL,
	FOREIGN KEY("vogn_ID","vognoppsett_nr") REFERENCES "Sittevogn"("vogn_ID","vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("sete_nr","vogn_ID","vognoppsett_nr")
);
CREATE TABLE IF NOT EXISTS "Sittevogn" (
	"vogn_ID"	INT,
	"seteRader"	INT NOT NULL,
	"seterPerRad"	INT NOT NULL,
	"vognoppsett_nr"	INT,
	FOREIGN KEY("vogn_ID","vognoppsett_nr") REFERENCES "Vogn"("vogn_ID","vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("vogn_ID","vognoppsett_nr")
);
CREATE TABLE IF NOT EXISTS "Seng" (
	"seng_nr"	INT,
	"kupe_nr"	INT NOT NULL,
	"vogn_ID"	INT NOT NULL,
	"vognoppsett_nr"	INT NOT NULL,
	FOREIGN KEY("kupe_nr","vogn_ID","vognoppsett_nr") REFERENCES "Sovekupe"("kupe_nr","vogn_ID","vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("seng_nr","vogn_ID","vognoppsett_nr")
);
CREATE TABLE IF NOT EXISTS "Sovevogn" (
	"vogn_ID"	INT,
	"sengerPerKupe"	INT,
	"vognoppsett_nr"	INT,
	FOREIGN KEY("vogn_ID","vognoppsett_nr") REFERENCES "Vogn"("vogn_ID","vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("vogn_ID","vognoppsett_nr")
);
CREATE TABLE IF NOT EXISTS "Setebillett" (
	"billett_ID"	INT,
	"sete_nr"	INT NOT NULL,
	"kupe_nr"	INT NOT NULL,
	"vogn_ID"	INT NOT NULL,
	"ordre_nr"	INT NOT NULL,
	"vognoppsett_nr"	INT,
	FOREIGN KEY("sete_nr","vogn_ID","vognoppsett_nr") REFERENCES "Sete"("sete_nr","vogn_ID","vognoppsett_nr") ON UPDATE CASCADE,
	FOREIGN KEY("ordre_nr") REFERENCES "Kundeordre"("ordre_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("billett_ID")
);
CREATE TABLE IF NOT EXISTS "Kunde" (
	"kunde_nr"	INTEGER,
	"navn"	VARCHAR(255) NOT NULL,
	"epost"	VARCHAR(255) NOT NULL UNIQUE COLLATE NOCASE,
	"tlf_nr"	VARCHAR(255) NOT NULL,
	PRIMARY KEY("kunde_nr" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "Stasjon" (
	"stasjon_ID"	NUMERIC,
	"stasjon_navn"	VARCHAR(255) NOT NULL UNIQUE COLLATE NOCASE,
	"moh"	INT NOT NULL,
	UNIQUE("stasjon_navn"),
	PRIMARY KEY("stasjon_ID")
);
CREATE TABLE IF NOT EXISTS "Kundeordre" (
	"ordre_nr"	INT,
	"dag"	DATE NOT NULL,
	"tid"	TIME NOT NULL,
	"kunde_nr"	INT NOT NULL,
	"forekomst_ID"	INT NOT NULL,
	FOREIGN KEY("kunde_nr") REFERENCES "Kunde"("kunde_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("forekomst_ID") REFERENCES "Togruteforekomst"("forekomst_ID") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("ordre_nr")
);
CREATE TABLE IF NOT EXISTS "Sovekupe" (
	"kupe_nr"	INT,
	"vogn_ID"	INT NOT NULL,
	"vognoppsett_nr"	INT,
	FOREIGN KEY("vogn_ID","vognoppsett_nr") REFERENCES "Sovevogn"("vogn_ID","vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("kupe_nr","vogn_ID","vognoppsett_nr")
);
CREATE TABLE IF NOT EXISTS "KupeKundeForekomst" (
	"kunde_nr"	INTEGER,
	"kupe_nr"	INTEGER,
	"vogn_ID"	INTEGER,
	"vognoppsett_nr"	INTEGER,
	"forekomst_ID"	INTEGER,
	"kupekunde_ID"	INTEGER,
	FOREIGN KEY("forekomst_ID") REFERENCES "Togruteforekomst"("forekomst_ID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("kupe_nr","vogn_ID","vognoppsett_nr") REFERENCES "Sovekupe"("vogn_ID","vognoppsett_nr","kupe_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("kunde_nr") REFERENCES "Kunde"("kunde_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("kupekunde_ID")
);
INSERT INTO "Delstrekning" VALUES (0,120,'true',0),
 (1,280,'false',0),
 (2,90,'false',0),
 (3,170,'false',0),
 (4,60,'false',0);
INSERT INTO "VognOppsett" VALUES (0),
 (1),
 (2);
INSERT INTO "Operatoer" VALUES (0,'SJ');
INSERT INTO "Togruteforekomst" VALUES (0,'2023-04-03',0),
 (1,'2023-04-03',1),
 (2,'2023-04-03',2),
 (3,'2023-04-04',0),
 (4,'2023-04-04',1),
 (5,'2023-04-04',2);
INSERT INTO "StartDelStrekning" VALUES (0,0),
 (1,1),
 (2,2),
 (3,3),
 (4,4);
INSERT INTO "SluttDelStrekning" VALUES (0,1),
 (1,2),
 (2,3),
 (3,4),
 (4,5);
INSERT INTO "Banestrekning" VALUES (0,'Nordlandsbanen','diesel','Trondheim - Bodø');
INSERT INTO "Togrute" VALUES (0,'true',0,0),
 (1,'true',0,1),
 (2,'false',0,2);
INSERT INTO "StartStasjon" VALUES (0,0,'07:49:00'),
 (1,0,'23:05:00'),
 (2,3,'08:11:00');
INSERT INTO "Endestasjon" VALUES (0,5,'17:34:00'),
 (1,5,'09:05:00'),
 (2,0,'14:13:00');
INSERT INTO "MellomStasjon" VALUES (0,1,'09:51:00','09:48:00'),
 (0,2,'13:20:00','13:17:00'),
 (0,3,'14:31:00','14:28:00'),
 (0,4,'16:49:00','14:46:00'),
 (1,1,'00:57:00','00:54:00'),
 (1,2,'04:41:00','04:38:00'),
 (1,3,'05:55:00','05:52:00'),
 (1,4,'08:19:00','08:16:00'),
 (2,2,'09:14:00','09:11:00'),
 (2,1,'12:31:00','12:28:00');
INSERT INTO "Ukedag" VALUES (0,0),
 (0,1),
 (0,2),
 (0,3),
 (0,4),
 (1,0),
 (1,1),
 (1,2),
 (1,3),
 (1,4),
 (1,5),
 (1,6),
 (2,0),
 (2,1),
 (2,2),
 (2,3),
 (2,4);
INSERT INTO "Vogn" VALUES (1,0,0),
 (2,0,0),
 (1,1,0),
 (2,1,0),
 (1,2,0);
INSERT INTO "Sete" VALUES (1,1,0),
 (2,1,0),
 (3,1,0),
 (4,1,0),
 (5,1,0),
 (6,1,0),
 (7,1,0),
 (8,1,0),
 (9,1,0),
 (10,1,0),
 (11,1,0),
 (12,1,0),
 (1,2,0),
 (2,2,0),
 (3,2,0),
 (4,2,0),
 (5,2,0),
 (6,2,0),
 (7,2,0),
 (8,2,0),
 (9,2,0),
 (10,2,0),
 (11,2,0),
 (12,2,0),
 (1,1,1),
 (2,1,1),
 (3,1,1),
 (4,1,1),
 (5,1,1),
 (6,1,1),
 (7,1,1),
 (8,1,1),
 (9,1,1),
 (10,1,1),
 (11,1,1),
 (12,1,1),
 (1,1,2),
 (2,1,2),
 (3,1,2),
 (4,1,2),
 (5,1,2),
 (6,1,2),
 (7,1,2),
 (8,1,2),
 (9,1,2),
 (10,1,2),
 (11,1,2),
 (12,1,2);
INSERT INTO "Sittevogn" VALUES (1,3,4,0),
 (2,3,4,0),
 (1,3,4,1),
 (1,3,4,2);
INSERT INTO "Seng" VALUES (1,1,2,1),
 (2,1,2,1),
 (3,2,2,1),
 (4,2,2,1),
 (5,3,2,1),
 (6,3,2,1),
 (7,3,2,1),
 (8,3,2,1);
INSERT INTO "Sovevogn" VALUES (2,2,1);
INSERT INTO "Stasjon" VALUES (0,'Trondheim',5.1),
 (1,'Steinkjer',3.6),
 (2,'Mosjøen',6.8),
 (3,'Mo i Rana',3.5),
 (4,'Fauske',34),
 (5,'Bodø',4.1);
INSERT INTO "Sovekupe" VALUES (1,2,1),
 (2,2,1),
 (3,2,1),
 (4,2,1);
COMMIT;
