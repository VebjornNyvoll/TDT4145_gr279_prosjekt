import sqlite3

con = sqlite3.connect('database_v0.db')
c = con.cursor()


def setKunde_nr():
    while(True):
        kundeID = input("Oppgi kundenummer, eller epost: \n")
        if kundeID.isdigit():
          c.execute("SELECT kunde_nr FROM Kunde WHERE kunde_nr = ?", (kundeID,))
          Kunde_nr = c.fetchone()
          if Kunde_nr is not None:
              print(f"Kunde with kunde_nr = {kundeID} exists")
              return Kunde_nr
          else:
              print(f"No kunde with kunde_nr = {kundeID}")
        else:
          c.execute("SELECT kunde_nr FROM Kunde WHERE epost = ?", (kundeID,))
          Kunde_nr = c.fetchone()
          if Kunde_nr is not None:
              print(f"Kunde with epost = {kundeID} exists")
              return Kunde_nr
          else:
              print(f"No kunde with epost = {kundeID}")



# oppgi epost eller kundenummer
kundeNr = setKunde_nr()


def previousOrders():
    # finn ordrenummer basert på kundenummer
    c.execute("SELECT ordre_nr FROM Kundeordre WHERE kunde_nr = ?", (kundeNr[0],))
    order_IDs = [order[0] for order in c.fetchall()]

    # finn forekomstID basert på kundenummer
    c.execute("SELECT forekomst_ID FROM Kundeordre WHERE kunde_nr = ?", (kundeNr[0],))
    forekomst_IDs = c.fetchall()

    togturer = {}
    
    # finne ruteID og dato basert på togruteforekomst
    for forekomst_ID in forekomst_IDs:
        c.execute("SELECT rute_ID, dato FROM Togruteforekomst WHERE forekomst_ID = ?", (forekomst_ID[0],))
        rute_info = c.fetchone()
        rute_ID = rute_info[0]
        date = rute_info[1]
        togturer[rute_ID] = date

    # formater og skriv ut resultatet
    print("Ordre-ID\tRute-ID\tDato")
    for rute_ID, date in togturer.items():
        for order_ID in order_IDs:
            print(f"{order_ID}\t\t{rute_ID}\t{date}")



previousOrders()

