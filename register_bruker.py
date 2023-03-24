import sqlite3
import re

con = sqlite3.connect('database_v0.db')
c = con.cursor()


def register_bruker():
    email_regex = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b'
    name = input("Hva er navnet ditt? \n")
    email = input("\nHva er eposten din? \n")

    while(True):
        if(re.fullmatch(email_regex, email)):
            break
        else:
            print("Validering feilet - eposten må skrives som en gyldig epost!")
            email = input("Hva er eposten din? \n")

    phone = input("\nHva er telefonnummeret ditt? \n")

    while(True):
        try:
            int(phone)
            break
        except ValueError:
            print("Validering feilet - telefonnummeret må skrives som kun tall!")
            phone = input("Hva er telefonnummeret ditt? \n")

    execute_string = "INSERT INTO Kunde (kunde_nr, navn, epost, tlf_nr) VALUES (NULL, " + "'" + name + "'" + ", " + "'" + email + "'" + ", " + phone + ");"
    print(execute_string)
        
    c.execute(execute_string)
    con.commit()
    con.close()

register_bruker()
