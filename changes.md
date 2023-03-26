- Endret moh fra INT til numeric for å få med desimaltall

- Added ON DELETE CASCADE to several tables

- Endret forekomst_id til Togrute.rute_id i startstasjon, mellomstasjon og endestasjon

- Valgte at tidene på mellomstasjonene er avgangstid og ankomsttid er avgangs - 3 minutter (unntatt endestasjon hvor tiden er ankomsttid)

- Slettet RutePaaStrekning tabellen ettersom delstrekninger har blitt mellom to stasjoner uansett

- Endret ukedag til å være int mellom 0 og 6

- Added vognoppsett_nr to sovevogn, sittevogn, kupe, setebillett, sovebillett

- Changed foreign key references to composite references in weak relations

- Removed not null clause in kunde_nr in sovekupe

- Added autoincrement to kunde_nr

- Added unique clause to kunde.epost and Stasjon.stasjon_navn (as well as collate nocase)
