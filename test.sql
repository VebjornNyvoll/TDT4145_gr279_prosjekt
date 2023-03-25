CREATE TABLE "Sete" (
	"sete_nr"	INT,
	"vogn_ID"	INT NOT NULL,
	"vognoppsett_nr"	INT NOT NULL,
	PRIMARY KEY("sete_nr", "vogn_ID", "vognoppsett_nr"),
	FOREIGN KEY("vogn_ID", "vognoppsett_nr") REFERENCES "Sittevogn"("vogn_ID", "vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE,
);


CREATE TABLE "Sittevogn" (
	"vogn_ID"	INT,
	"seteRader"	INT NOT NULL,
	"seterPerRad"	INT NOT NULL,
	"vognoppsett_nr"	INT,
	PRIMARY KEY("vogn_ID","vognoppsett_nr"),
	FOREIGN KEY("vogn_ID", "vognoppsett_nr") REFERENCES "Vogn"("vogn_ID", "vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "Seng" (
	"seng_nr"	INT,
	"kupe_nr"	INT NOT NULL,
	"vogn_ID"	INT NOT NULL,
	"vognoppsett_nr"	INT NOT NULL,
	PRIMARY KEY("seng_nr", "vogn_ID", "vognoppsett_nr"),
	FOREIGN KEY("kupe_nr", "vogn_ID", "vognoppsett_nr") REFERENCES "Sovekupe"("kupe_nr", "vogn_ID", "vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "Sovekupe" (
	"kupe_nr"	INT,
	"vogn_ID"	INT NOT NULL,
	"kunde_nr"	INT NOT NULL,
	"vognoppsett_nr"	INT,
	PRIMARY KEY("kupe_nr","vogn_ID","vognoppsett_nr"),
	FOREIGN KEY("kunde_nr") REFERENCES "Kunde"("kunde_nr") ON UPDATE CASCADE,
	FOREIGN KEY("vogn_ID", "vognoppsett_nr") REFERENCES "Sovevogn"("vogn_ID", "vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "Sovevogn" (
	"vogn_ID"	INT,
	"sengerPerKupe"	INT,
	"vognoppsett_nr"	INT,
	FOREIGN KEY("vogn_ID", "vognoppsett_nr") REFERENCES "Vogn"("vogn_ID", "vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("vogn_ID","vognoppsett_nr")
);

CREATE TABLE "Setebillett" (
	"billett_ID"	INT,
	"sete_nr"	INT NOT NULL,
	"kupe_nr"	INT NOT NULL,
	"vogn_ID"	INT NOT NULL,
	"ordre_nr"	INT NOT NULL,
	"vognoppsett_nr"	INT,
	FOREIGN KEY("sete_nr", "vogn_ID", "vognoppsett_nr") REFERENCES "Sete"("sete_nr", "vogn_ID", "vognoppsett_nr") ON UPDATE CASCADE,
	FOREIGN KEY("ordre_nr") REFERENCES "Kundeordre"("ordre_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("billett_ID")
);

CREATE TABLE "SengBillett" (
	"billett_ID"	INT,
	"seng_nr"	INT NOT NULL,
	"kupe_nr"	INT NOT NULL,
	"vogn_ID"	INT NOT NULL,
	"ordre_nr"	INT NOT NULL,
	"vognoppsett_nr"	INT NOT NULL,
	FOREIGN KEY("seng_nr", "kupe_nr", "vogn_ID", "vognoppsett_nr") REFERENCES "Seng"("seng_nr", "kupe_nr", "vogn_ID", "vognoppsett_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("ordre_nr") REFERENCES "Kundeordre"("ordre_nr") ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY("billett_ID")
);

CREATE TABLE "Vogn" (
	"vogn_ID"	INTEGER,
	"vognoppsett_nr"	INTEGER,
    "operatoer_ID"	INT,
    FOREIGN KEY("operatoer_ID") REFERENCES "Operatoer"("operatoer_ID") ON UPDATE CASCADE,
	PRIMARY KEY("vogn_ID","vognoppsett_nr")
);