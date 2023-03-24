import sqlite3

con = sqlite3.connect('database_v0.db')
c = con.cursor()


def brukerhistorie_d():
    start_stasjon_navn = input("Oppgi startstasjon: \n")

    ende_stasjon_navn = input("\nOppgi endestasjon: \n")

    execute_first = "SELECT stasjon_ID FROM Stasjon WHERE stasjon_navn = " + "'" + start_stasjon_navn + "'" + ";"
    c.execute(execute_first)
    start_stasjon = c.fetchone()
    
    execute_second = "SELECT stasjon_ID FROM Stasjon WHERE stasjon_navn = " + "'" + ende_stasjon_navn + "'" + ";"
    c.execute(execute_second)
    ende_stasjon = c.fetchone()

    #Join togrute, startstasjon and endestasjon to get all the togruter that goes from start_stasjon to ende_stasjon
    execute_third = "SELECT * FROM StartStasjon JOIN Endestasjon ON StartStasjon.togrute_ID = Endestasjon.togrute_ID WHERE StartStasjon.stasjon_ID = " + str(start_stasjon[0]) + " AND Endestasjon.stasjon_ID = " + str(ende_stasjon[0]) + ";"
    c.execute(execute_third)
    togruter = c.fetchall()

    #Teknisk sett ikke del av brukerhistorie_d men greit å vite hva som er infoen jeg jobber med
    print("\nDisse rutene går mellom valgte stasjoner: ")
    for i in range(len(togruter)):
        print("Avgang " + start_stasjon_navn + " " + str(togruter[i][2]) + " Ankomst " + ende_stasjon_navn + " " + str(togruter[i][5]))

    # date = input("Hvilken dato vil du reise? (YYYY-MM-DD) \n")
    # date2 = date[0:8] + str(int(date[8:10]) + 1)
   

    # #Get all the togruteforekomster that goes from start_stasjon to ende_stasjon in the same date and the date after
    # execute_fourth = "SELECT togruteforekomst_nr FROM TogRuteforekomst WHERE togrute_nr IN " + str(togruter) + " AND dato BETWEEN " + "'" + date + "'" + " AND " + "'" + date2 + "'" + " ORDER BY time;"
    # c.execute(execute_fourth)
    # togruteforekomster = c.fetchall()

    # #Print all the togruteforekomster in order based on time
    # for i in range(len(togruteforekomster)):
    #     print(togruteforekomster[i])

brukerhistorie_d()
con.close()