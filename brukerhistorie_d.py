import datetime
import sqlite3
from dateutil import parser

con = sqlite3.connect('database_v0.db')
c = con.cursor()


def brukerhistorie_d():
    # Load the sql file that is used in the third c.execute
    with open ('d.sql', 'r') as f:
        sql = f.read()

    #Get startstasjon from user
    while True:
        start_stasjon_navn = input("Oppgi startstasjon:\n")
        # Get the stasjon_ID for the startstasjon and endestasjon
        c.execute("SELECT stasjon_ID FROM Stasjon WHERE stasjon_navn = ?;", (start_stasjon_navn,))
        start_stasjon = c.fetchone()
        if start_stasjon is None:
            print("Stasjonen finnes ikke, prøv igjen!")
        else:
            start_stasjon = start_stasjon[0]
            print("")
            break
            
    #Get endestasjon from user
    while True:
        ende_stasjon_navn = input("Oppgi endestasjon:\n")
        c.execute("SELECT stasjon_ID FROM Stasjon WHERE stasjon_navn = ?;", (ende_stasjon_navn,))
        ende_stasjon = c.fetchone()
        if ende_stasjon is None:
            print("Stasjonen finnes ikke, prøv igjen!")
        else:
            ende_stasjon = ende_stasjon[0]
            print("")
            break

    # Get all the togruter that goes from start_stasjon to ende_stasjon using external sql script
    c.execute(sql, (start_stasjon, ende_stasjon))
    togruter = c.fetchall()
    togrute_IDer = []

    # Get the togrute_ID for all the togruter
    for i in range(len(togruter)):
        togrute_IDer.append(togruter[i][0])

    # Check if there exists togruter between the start_stasjon and ende_stasjon
    if(len(togruter) == 0):
        print("Det finnes ingen togruter mellom " + start_stasjon_navn + " og " + ende_stasjon_navn + "!")
        return
    
    # Get the preferred date from the user
    while True:
        input_date = input("Hvilken dato vil du reise? (YYYY-MM-DD) \n")
        try:
            datetime.date.fromisoformat(input_date)
            break
        except ValueError:
            print("\nValidering feilet - dato må skrives som YYYY-MM-DD!")

    # Convert input_date to a date object and add one day to it
    date = parser.parse(input_date).strftime('%Y%m%d')
    date1 = datetime.date(int(date[0:4]), int(date[4:6]), int(date[6:8]))
    date2 = date1 + datetime.timedelta(days=1)


    # Get all the togruteforekomster that goes from start_stasjon to ende_stasjon in the same date and the date after
    c.execute("SELECT * FROM Togruteforekomst WHERE Togruteforekomst.rute_ID IN " + str(tuple(togrute_IDer)) + " AND Togruteforekomst.dato BETWEEN " + "'" + str(date1) + "'" + " AND " + "'" + str(date2) + "'" + " ORDER BY Togruteforekomst.dato;")
    togruteforekomster = c.fetchall()

    # Check if there exists togruteforekomster between the start_stasjon and ende_stasjon
    if len(togruteforekomster) == 0:
        print("Det finnes ingen togruter mellom " + start_stasjon_navn + " og " + ende_stasjon_navn + " på valgt dato eller dagen etter!")
        return

    # Print all the togruteforekomster that match the query in a nice format
    print("\nTakk for din hendvendelse!")
    print("Dette er alle togrutene som går mellom " + start_stasjon_navn + " og " + ende_stasjon_navn + " ved valgt dato:")
    for i in range(len(togruter)):
        for j in range(len(togruteforekomster)):
            if(togruter[i][0] == togruteforekomster[j][2]):
                togruter[i] = togruter[i] + togruteforekomster[j][1:2]
        print("_"*50)
        print("Rute: " + str(togruter[i][0]))
        print("Avgang " + str(togruter[i][1]) + " " + str(togruter[i][3]))
        print("Ankomst " + str(togruter[i][2]) + " " + str(togruter[i][4]))

        # Check if the togrute goes on the same day or on the next day as well
        if len(togruter[i]) < 7:
            print("Ruta går på valgt dato: " + str(togruter[i][5]))
        else:
            print("Ruta går både " + str(togruter[i][5]) + " og " + str(togruter[i][6]))

        if(i == len(togruter)-1):
            print("_"*50)
        
        

    

   

    #  #Get all the togruteforekomster that goes from start_stasjon to ende_stasjon in the same date and the date after
    # execute_fourth = "SELECT * FROM TogRuteforekomst INNER JOIN StartStasjon ON StartStasjon.togrute_ID = Togruteforekomst.rute_ID INNER JOIN MellomStasjon on MellomStasjon.togrute_ID = Togruteforekomst.rute_ID WHERE Togruteforekomst.rute_ID IN " + togrute_IDer_string + " AND Togruteforekomst.dato BETWEEN " + "'" + str(date1) + "'" + " AND " + "'" + str(date2) + "'" + " ORDER BY Togruteforekomst.dato;"
    # c.execute(execute_fourth)
    # togruteforekomster = c.fetchall()
    # print(execute_fourth)

    # # #Print all the togruteforekomster in order based on time
    # for i in range(len(togruteforekomster)):
    #     print(togruteforekomster[i])
    
    # # Get all the togruteforekomster in MellomStasjon as well as StartStasjon and EndeStasjon
    
    
    
   

   

brukerhistorie_d()
con.close()