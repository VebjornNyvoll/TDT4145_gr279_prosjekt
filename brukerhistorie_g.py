import sqlite3

con = sqlite3.connect('database_v0.db')
c = con.cursor()

def setKunde_nr():
    while(True):
        kundeID = input("Oppgi kunde nummer, eller epost: \n")
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

def setStasjon():
    while(True):
        stasjon = input("Oppgi stasjon navn, eller stasjon id: \n")
        if stasjon.isdigit():
          c.execute("SELECT stasjon_ID FROM Stasjon WHERE stasjon_ID = ?", (stasjon,))
          stasjon_ID = c.fetchone()
          if stasjon_ID is not None:
              print(f"Stasjon with stasjon_ID = {stasjon} exists")
              stasjon_ID = stasjon_ID[0]
              return stasjon_ID
          else:
              print(f"No stasjon with stasjon_ID = {stasjon}")
        else:
          c.execute("SELECT stasjon_ID FROM Stasjon WHERE stasjon_navn = ?", (stasjon,))
          stasjon_ID = c.fetchone()
          if stasjon_ID is not None:
              print(f"Stasjon with stasjon navn: = {stasjon} exists")
              stasjon_ID = stasjon_ID[0]
              return stasjon_ID
          else:
              print(f"No stasjon with stasjon navn: = {stasjon}")

def getStasjonNavn(stasjon_ID):
    c.execute("SELECT stasjon_navn FROM Stasjon WHERE stasjon_ID = ?", (stasjon_ID,))
    stasjon_navn = c.fetchone()
    if stasjon_navn is not None:
        print(f"Stasjon with stasjon_ID = {stasjon_ID} exists")
        stasjon_navn = stasjon_navn[0]
        return stasjon_navn
    else:
        print(f"No stasjon with stasjon_ID = {stasjon_ID}")

def brukerhistorie_g():
    Kunde_nr = setKunde_nr()
    # print("Kunde_nr: ", Kunde_nr)

    # Load the sql file that is used in the third c.execute
    with open ('d.sql', 'r') as f:
        sql = f.read()

    StartStasjon = setStasjon()
    EndStasjon = setStasjon()    

    # Get all the togruter that goes from start_stasjon to ende_stasjon using external sql script
    c.execute(sql, (StartStasjon, EndStasjon))
    togruter = c.fetchall()
    togrute_IDer = []

    # Get the togrute_ID for all the togruter
    for i in range(len(togruter)):
        togrute_IDer.append(togruter[i][0])

    # Check if there exists togruter between the start_stasjon and ende_stasjon
    if(len(togruter) == 0):
        print("Det finnes ingen togruter mellom " + getStasjonNavn(StartStasjon) + " og " + getStasjonNavn(EndStasjon) + "!")
        return
    
    # Get all the togruteforekomster that goes from start_stasjon to ende_stasjon in the same date and the date after
    c.execute("SELECT * FROM Togruteforekomst WHERE Togruteforekomst.rute_ID IN " + str(tuple(togrute_IDer)) + "")
    togruteforekomster = c.fetchall()

    # Check if there exists togruteforekomster between the start_stasjon and ende_stasjon
    if len(togruteforekomster) == 0:
        print("Det finnes ingen togruter mellom " + getStasjonNavn(StartStasjon) + " og " + getStasjonNavn(EndStasjon) + " på valgt dato eller dagen etter!")
        return

    # Print all the togruteforekomster that match the query in a nice format
    print("\nTakk for din hendvendelse!")
    print("Dette er alle togrutene som går mellom " + getStasjonNavn(StartStasjon) + " og " + getStasjonNavn(EndStasjon) + ":")
    for i in range(len(togruter)):
        for j in range(len(togruteforekomster)):
            if(togruter[i][0] == togruteforekomster[j][2]):
                togruter[i] = togruter[i] + togruteforekomster[j][1:2]
            print("_"*50)
            print("Rute: " + str(togruter[i][0]))
            print("Avgang " + str(togruter[i][1]) + " " + str(togruter[i][3]))
            print("Ankomst " + str(togruter[i][2]) + " " + str(togruter[i][4]))

    # ------husk input validering------
    togrute_ID = input("Oppgi rute id \n")
    
    # finne alle seter som er i en gitt togrute
    # bruke rute_ID til å finne vognopsett_nr med Togrute
    c.execute("SELECT vognopsett_nr FROM Togrute WHERE rute_ID = ?", (togrute_ID,))
    vognoppsett_nr = c.fetchone()
    # bruke vognopsett_nr til å finnne alle vogn_ID med Vogn
    c.execute("SELECT vogn_ID FROM Vogn WHERE vognoppsett_nr = ?", (vognoppsett_nr[0],))
    vogn_ID = c.fetchall()
    # bruke vognopsett_nr + vogn_ID til å finne alle sete_nr med sete
    for i in range(len(vogn_ID)):
        c.execute("SELECT sete_nr FROM Sete WHERE vogn_ID = ? AND vognoppsett_nr = ?", (vogn_ID[i][0], vognoppsett_nr[0],))
        sete_nr = c.fetchall()
        for j in range(len(sete_nr)):
            print("Vogn:" + str(vogn_ID[i][0]) + "Sete:" + str(sete_nr[j][0]))
        
    # finne alle seter som er opptatt i hver forekomst
    for i in range(len(togruteforekomster)):
        c.execute("SELECT ordre_nr FROM Kundeordre WHERE forekomst_ID = ?", (togruteforekomster[i][0],))
        ordre_nr = c.fetchone()
        c.execute("SELECT sete_nr FROM Setebillett WHERE startstasjon = ? AND endestasjon = ? AND vognoppsett_nr = ? AND vogn_ID = ?", (StartStasjon, EndStasjon, vognoppsett_nr[0], vogn_ID[0][0]))
        opptattSete = c.fetchall()
        # remove opptatt sete from sete_nr
        # for j in range(len(sete_nr)):
        #     sete_nr.remove(opptattSete[j])
        #     print("Forekomst: " + str(togruteforekomster[i][0]) + " " + str(togruteforekomster[i][1]))



    # forekomst_ID = input("Oppgi forekomst id \n")
    # vogn_ID = input("Oppgi vogn id \n")
    # sete_nr = input("Oppgi sete nr \n")
    
    # execute_string = "INSERT INTO Kundeordre (ordre_nr, dag, tid, kunde_nr, forekomst_ID, ) VALUES (NULL, NULL, NULL " + str(Kunde_nr) + ", " + str(forekomst_ID) + ");"
    # c.execute(execute_string)
    

    
brukerhistorie_g()
con.close()