- Endret moh fra INT til numeric for å få med desimaltall
- Added ON DELETE CASCADE to vognoppsett reference in togrute

- Endret forekomst_id til Togrute.rute_id i startstasjon, mellomstasjon og endestasjon

- Valgte at tidene på mellomstasjonene er avgangstid og ankomsttid er avgangs - 3 minutter (unntatt endestasjon hvor tiden er ankomsttid)

- Slettet RutePaaStrekning tabellen ettersom delstrekninger har blitt mellom to stasjoner uansett

- Endret ukedag til å være int mellom 0 og 6

- Added vognoppsett_nr to sovevogn, sittevogn, kupe, setebillett, sovebillett (A6)

TODO:
- FIKSE SVAKE RELASJONER OG ID-ene deres!(begynt på se A6)
