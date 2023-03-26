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
    # Kunde_nr = setKunde_nr()
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

    # Print all the togruteforekomster that match the query in a nice format
    print("\nTakk for din hendvendelse!")
    print("Dette er alle togrutene som går mellom " + getStasjonNavn(StartStasjon) + " og " + getStasjonNavn(EndStasjon) + ":")
    for i in range(len(togruter)):
        print("_"*50)
        print("Rute: " + str(togruter[i][0]))
        print("Avgang " + str(togruter[i][1]) + " " + str(togruter[i][3]))
        print("Ankomst " + str(togruter[i][2]) + " " + str(togruter[i][4]))
brukerhistorie_g()
con.close()