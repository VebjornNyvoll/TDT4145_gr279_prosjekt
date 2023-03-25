import datetime
import sqlite3
from dateutil import parser

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
    execute_third = "SELECT StartStasjon.togrute_ID FROM StartStasjon JOIN Endestasjon ON StartStasjon.togrute_ID = Endestasjon.togrute_ID JOIN MellomStasjon ON StartStasjon.togrute_ID = MellomStasjon.togrute_ID WHERE StartStasjon.stasjon_ID = " + str(start_stasjon[0]) + " AND Endestasjon.stasjon_ID = " + str(ende_stasjon[0]) + " OR StartStasjon.stasjon_ID = " + str(start_stasjon[0]) + " AND MellomStasjon.stasjon_ID = " + str(ende_stasjon[0]) + " OR MellomStasjon.stasjon_ID = " + str(start_stasjon[0]) + " AND EndeStasjon.stasjon_ID = " + str(ende_stasjon[0]) + " OR MellomStasjon.stasjon_ID = " + str(start_stasjon[0]) + " AND MellomStasjon.stasjon_ID = " + str(ende_stasjon[0]) + ";"
    c.execute(execute_third)
    togrute_tupler = c.fetchall()
    togrute_IDer_string = "("
    for i in range(len(togrute_tupler)):
        togrute_IDer_string += str(togrute_tupler[i][0]) + ", "
    togrute_IDer_string = togrute_IDer_string[:-2] + ")"
    print(togrute_IDer_string)

    input_date = parser.parse(input("Hvilken dato vil du reise? (YYYY-MM-DD) \n")).strftime('%Y%m%d')
    date1 = datetime.date(int(input_date[0:4]), int(input_date[4:6]), int(input_date[6:8]))
    date2 = date1 + datetime.timedelta(days=1)

     #Get all the togruteforekomster that goes from start_stasjon to ende_stasjon in the same date and the date after
    execute_fourth = "SELECT * FROM TogRuteforekomst INNER JOIN StartStasjon ON StartStasjon.togrute_ID = Togruteforekomst.rute_ID INNER JOIN MellomStasjon on MellomStasjon.togrute_ID = Togruteforekomst.rute_ID WHERE Togruteforekomst.rute_ID IN " + togrute_IDer_string + " AND Togruteforekomst.dato BETWEEN " + "'" + str(date1) + "'" + " AND " + "'" + str(date2) + "'" + " ORDER BY Togruteforekomst.dato;"
    c.execute(execute_fourth)
    togruteforekomster = c.fetchall()
    print(execute_fourth)

    # #Print all the togruteforekomster in order based on time
    for i in range(len(togruteforekomster)):
        print(togruteforekomster[i])
    
    # Get all the togruteforekomster in MellomStasjon as well as StartStasjon and EndeStasjon
    
    
   

   

brukerhistorie_d()
con.close()