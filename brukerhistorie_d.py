import datetime
import sqlite3
from dateutil import parser

con = sqlite3.connect('database_v0.db')
c = con.cursor()


def brukerhistorie_d():
    # Hente ut sql-scriptet d.sql som brukes i tredje c.execute
    with open ('d.sql', 'r') as f:
        sql = f.read()

    # Hente ut start_stasjon og ende_stasjon fra bruker
    start_stasjon_navn = input("Oppgi startstasjon: \n")
    ende_stasjon_navn = input("\nOppgi endestasjon: \n")

    # Hente ut stasjon_ID til start_stasjon og ende_stasjon
    c.execute("SELECT stasjon_ID FROM Stasjon WHERE stasjon_navn = ?", (start_stasjon_navn,))
    start_stasjon = c.fetchone()[0]
    
    c.execute("SELECT stasjon_ID FROM Stasjon WHERE stasjon_navn = ?;", (ende_stasjon_navn,))
    ende_stasjon = c.fetchone()[0]

    # Hente ut alle togruter som går mellom start_stasjon og ende_stasjon via sql-scriptet d.sql
    c.execute(sql, (start_stasjon, ende_stasjon))
    togruter = c.fetchall()
    if(len(togruter) == 0):
        print("Det finnes ingen togruter mellom " + start_stasjon_navn + " og " + ende_stasjon_navn + "!")
        return
    print("\nTakk for din hendvendelse!")
    print("Dette er alle togrutene som går mellom " + start_stasjon_navn + " og " + ende_stasjon_navn + ":")

    # Print alle togruter på en fin måte
    for i in range(len(togruter)):
        print("_"*50)
        print("Rute " + str(togruter[i][0]))
        print("Avgang " + str(togruter[i][1]) + " " + str(togruter[i][3]))
        print("Ankomst " + str(togruter[i][2]) + " " + str(togruter[i][4]))
        if(i == len(togruter)-1):
            print("_"*50)

brukerhistorie_d()
con.close()