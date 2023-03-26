import sqlite3

con = sqlite3.connect('database_v0.db')
c = con.cursor()

stasjon_navn = input("Oppgi stasjon: ")
ukedag_navn = input("Oppgi ukedag: ")

ukedager = ['Mandag', 'Tirsdag', 'Onsdag', 'Torsdag', 'Fredag', 'Lørdag', 'Søndag']

for i in range(0,7):
    if ukedag_navn == ukedager[i]:
        ukedag_nr = i


# Finn stasjon-IDen basert på stasjonnavnet
c.execute("SELECT stasjon_ID FROM Stasjon WHERE stasjon_navn = ?", (stasjon_navn,))
stasjon_ID = c.fetchone()[0]


# Finn togrute-IDene som stopper ved denne stasjonen
c.execute("SELECT DISTINCT StartStasjon.togrute_ID FROM StartStasjon \
            JOIN Mellomstasjon ON StartStasjon.togrute_ID = Mellomstasjon.togrute_ID \
            JOIN Endestasjon ON Mellomstasjon.togrute_ID = Endestasjon.togrute_ID \
            WHERE StartStasjon.stasjon_ID = ? \
            OR Mellomstasjon.stasjon_ID = ? \
            OR Endestasjon.stasjon_ID = ?", (stasjon_ID, stasjon_ID, stasjon_ID))

fetch_ruteID = c.fetchall()

c.execute("SELECT rute_ID FROM Ukedag WHERE ukedag = ?", (ukedag_nr,))

fetch_dag = c.fetchall()

ruteID_stasjon = []
ruteID_dag = []
result = []

for i in fetch_ruteID:
    ruteID_stasjon.append(i[0])

for i in fetch_dag:
    ruteID_dag.append(i[0])

for i in ruteID_stasjon:
    for j in ruteID_dag:
        if i == j:
            result.append(i)

print(result)

con.close()

