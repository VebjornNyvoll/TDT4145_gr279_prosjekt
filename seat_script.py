import sqlite3

con = sqlite3.connect('database_v0.db')
c = con.cursor()

execute_string = ""

for j in range(1, 2):
    for i in range(1, 13):
        execute_string = "INSERT INTO Sete VALUES (" + str(i) + ", " + str(j) + ", 2);"
        print(execute_string)
con.commit()
con.close()
    