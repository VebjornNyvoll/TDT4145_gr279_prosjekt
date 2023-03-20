CREATE TABLE Banestrekning (
  strekning_ID INT PRIMARY KEY,
  strekning_navn VARCHAR(255) NOT NULL, 
  fremdriftsenergi VARCHAR(255)
);

CREATE TABLE Delstrekning (
  delstrekning_ID INT PRIMARY KEY,
  segment_lengde DECIMAL(10,2) NOT NULL,
  dobbeltspor BOOLEAN NOT NULL,
  strekning_ID INT NOT NULL,
  FOREIGN KEY (strekning_ID) REFERENCES Banestrekning(strekning_ID) ON UPDATE CASCADE
);

CREATE TABLE VognOppsett (
  vognoppsett_nr INT PRIMARY KEY
);

CREATE TABLE Operatoer (
  operatoer_ID INT PRIMARY KEY,
  navn VARCHAR(255) NOT NULL
);

CREATE TABLE Sovevogn (
    vogn_ID INT PRIMARY KEY,
    sengerPerKupe INT,
    operatoer_ID INT NOT NULL,
    vognoppsett_nr INT NOT NULL,
    FOREIGN KEY (operatoer_ID) REFERENCES Operatoer(operatoer_ID) ON UPDATE CASCADE,
    FOREIGN KEY (vognoppsett_nr) REFERENCES VognOppsett(vognoppsett_nr) ON UPDATE CASCADE
);

CREATE TABLE Sittevogn (
    vogn_ID INT PRIMARY KEY,
    seteRader INT,
    seterPerRad INT,
    operatoer_ID INT NOT NULL,
    vognoppsett_nr INT NOT NULL,
    FOREIGN KEY (operatoer_ID) REFERENCES Operatoer(operatoer_ID) ON UPDATE CASCADE,
    FOREIGN KEY (vognoppsett_nr) REFERENCES VognOppsett(vognoppsett_nr) ON UPDATE CASCADE
);

CREATE TABLE Togrute (
  rute_ID INT PRIMARY KEY,
  hovedretning VARCHAR(255) NOT NULL,
  operatoer_ID INT NOT NULL,
  vognopsett_nr INT NOT NULL,
  FOREIGN KEY (operatoer_ID) REFERENCES Operatoer(operatoer_ID) ON UPDATE CASCADE,
  FOREIGN KEY (vognopsett_nr) REFERENCES VognOppsett(vognopsett_nr) ON UPDATE CASCADE
);

CREATE TABLE Togruteforekomst (
  forekomst_ID INT PRIMARY KEY,
  dato DATE NOT NULL,
  rute_ID INT NOT NULL,
  FOREIGN KEY (rute_ID) REFERENCES Togrute(rute_ID) ON UPDATE CASCADE
);

CREATE TABLE Kunde (
  kunde_nr INT PRIMARY KEY,
  navn VARCHAR(255) NOT NULL,
  epost VARCHAR(255) NOT NULL,
  tlf_nr VARCHAR(255) NOT NULL
);

CREATE TABLE Kundeordre (
  ordre_nr INT PRIMARY KEY,
  dag DATE NOT NULL,
  tid TIME NOT NULL,
  kunde_nr INT NOT NULL,
  FOREIGN KEY (kunde_nr) REFERENCES Kunde(kunde_nr) ON UPDATE CASCADE
);

CREATE TABLE Sete (
  sete_nr INT PRIMARY KEY,
  vogn_ID INT NOT NULL,
  FOREIGN KEY (vogn_ID) REFERENCES Sittevogn(vogn_ID) ON UPDATE CASCADE
);

CREATE TABLE Sovekupe (
  kupe_nr INT PRIMARY KEY,
  vogn_ID INT NOT NULL,
  kunde_nr INT NOT NULL,
  FOREIGN KEY (vogn_ID) REFERENCES Sovevogn(vogn_ID) ON UPDATE CASCADE,
  FOREIGN KEY (kunde_nr) REFERENCES Kunde(kunde_nr) ON UPDATE CASCADE
);

CREATE TABLE Seng (
  seng_nr INT PRIMARY KEY,
  kupe_nr INT NOT NULL,
  vogn_ID INT NOT NULL,
  FOREIGN KEY (kupe_nr) REFERENCES Sovekupe(kupe_nr) ON UPDATE CASCADE,
  FOREIGN KEY (vogn_ID) REFERENCES Sovevogn(vogn_ID) ON UPDATE CASCADE
);

CREATE TABLE SengBillett (
  billett_ID INT PRIMARY KEY,
  seng_nr INT NOT NULL,
  kupe_nr INT NOT NULL,
  vogn_ID INT NOT NULL,
  ordre_nr INT NOT NULL,
  FOREIGN KEY (seng_nr) REFERENCES Seng(seng_nr) ON UPDATE CASCADE,
  FOREIGN KEY (kupe_nr) REFERENCES Sovekupe(kupe_nr) ON UPDATE CASCADE,
  FOREIGN KEY (vogn_ID) REFERENCES Sovevogn(vogn_ID) ON UPDATE CASCADE,
  FOREIGN KEY (ordre_nr) REFERENCES Kundeordre(ordre_nr) ON UPDATE CASCADE
);

CREATE TABLE Setebillett (
  billett_ID INT PRIMARY KEY,
  sete_nr INT NOT NULL,
  kupe_nr INT NOT NULL,
  vogn_ID INT NOT NULL,
  ordre_nr INT NOT NULL,
  FOREIGN KEY (sete_nr) REFERENCES Sete(sete_nr) ON UPDATE CASCADE,
  FOREIGN KEY (kupe_nr) REFERENCES Sovekupe(kupe_nr) ON UPDATE CASCADE,
  FOREIGN KEY (vogn_ID) REFERENCES Sovevogn(vogn_ID) ON UPDATE CASCADE,
  FOREIGN KEY (ordre_nr) REFERENCES Kundeordre(ordre_nr) ON UPDATE CASCADE
);

CREATE TABLE Stasjon (
  stasjon_ID INT PRIMARY KEY,
  stasjon_navn VARCHAR(255) NOT NULL,
  moh INT NOT NULL
);

CREATE TABLE RutePaaStrekning (
    delstrekning_ID INT,
    rute_ID INT,
    PRIMARY KEY (delstrekning_ID, rute_ID),
    FOREIGN KEY (delstrekning_ID) REFERENCES Delstrekning(delstrekning_ID) ON UPDATE CASCADE,
    FOREIGN KEY (rute_ID) REFERENCES Togrute(rute_ID) ON UPDATE CASCADE
);

CREATE TABLE Ukedag (
    rute_ID INT,
    ukedag VARCHAR(9),
    PRIMARY KEY (rute_ID, ukedag),
    FOREIGN KEY (rute_ID) REFERENCES Togrute(rute_ID) ON UPDATE CASCADE
);

CREATE TABLE StartStasjon (
    forekomst_ID INT,
    stasjon_ID INT NOT NULL,
    avgangstid TIME,
    PRIMARY KEY (forekomst_ID),
    FOREIGN KEY (forekomst_ID) REFERENCES Togruteforekomst(forekomst_ID) ON UPDATE CASCADE,
    FOREIGN KEY (stasjon_ID) REFERENCES Stasjon(stasjon_ID) ON UPDATE CASCADE
);

CREATE TABLE MellomStasjon (
    forekomst_ID INT,
    stasjon_ID INT,
    avgangstid TIME,
    ankomsttid TIME,
    PRIMARY KEY (forekomst_ID, stasjon_ID),
    FOREIGN KEY (forekomst_ID) REFERENCES Togruteforekomst(forekomst_ID) ON UPDATE CASCADE,
    FOREIGN KEY (stasjon_ID) REFERENCES Stasjon(stasjon_ID) ON UPDATE CASCADE
);

CREATE TABLE Endestasjon (
    forekomst_ID INT,
    stasjon_ID INT,
    ankomsttid TIME,
    PRIMARY KEY (forekomst_ID),
    FOREIGN KEY (forekomst_ID) REFERENCES Togruteforekomst(forekomst_ID) ON UPDATE CASCADE,
    FOREIGN KEY (stasjon_ID) REFERENCES Stasjon(stasjon_ID) ON UPDATE CASCADE
);

CREATE TABLE GaarAvStasjon (
    billett_ID INT,
    stasjon_ID INT NOT NULL,
    PRIMARY KEY (billett_ID),
    FOREIGN KEY (billett_ID) REFERENCES Setebillett(billett_ID) ON UPDATE CASCADE,
    FOREIGN KEY (stasjon_ID) REFERENCES Stasjon(stasjon_ID) ON UPDATE CASCADE
);

CREATE TABLE GaarPaaStasjon (
    billett_ID INT,
    stasjon_ID INT NOT NULL,
    PRIMARY KEY (billett_ID),
    FOREIGN KEY (billett_ID) REFERENCES Setebillett(billett_ID) ON UPDATE CASCADE,
    FOREIGN KEY (stasjon_ID) REFERENCES Stasjon(stasjon_ID) ON UPDATE CASCADE
);

CREATE TABLE StartDelStrekning (
  delstrekning_ID INT,
  stasjon_ID INT,
  PRIMARY KEY (delstrekning_ID, stasjon_ID),
  FOREIGN KEY (delstrekning_ID) REFERENCES Delstrekning(delstrekning_ID) ON UPDATE CASCADE,
  FOREIGN KEY (stasjon_ID) REFERENCES Stasjon(stasjon_ID) ON UPDATE CASCADE
);
  
CREATE TABLE SluttDelStrekning (
  delstrekning_ID INT,
  stasjon_ID INT,
  PRIMARY KEY (delstrekning_ID, stasjon_ID),
  FOREIGN KEY (delstrekning_ID) REFERENCES Delstrekning(delstrekning_ID),
  FOREIGN KEY (stasjon_ID) REFERENCES Stasjon(stasjon_ID)
);