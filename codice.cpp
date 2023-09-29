#include <cstdio>
#include <iostream>
#include <string>
#include "dependencies/include/libpq-fe.h"
using std::cout;
using std::endl;
using std::string;
using std::cin;
using std::atoi;

#define PG_HOST "postgresql"
#define PG_USER "famenegh"
#define PG_DB "famenegh"
#define PG_PASS "7+_mr.qi0#Le"
#define PG_PORT "5432"

PGconn* connect(const char* host, const char* user, const char* db, const char* pass, const char* port) {
    char conninfo[256];
    sprintf(conninfo, "user=%s password=%s dbname=\'%s\' host=%s port=%s",
        user, pass, db, host, port);

    PGconn* conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        std::cerr << "Errore di connessione" << endl << PQerrorMessage(conn);
        PQfinish(conn);
        exit(1);
    }

    return conn;
}


PGresult* execute(PGconn* conn, const char* query) {
    PGresult* res = PQexec(conn, query);
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << "Risultati inconsistenti\n" << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }

    return res;
}


void printLine(int campi, int* maxChar) {
    for (int j = 0; j < campi; ++j) {
        cout << '+';
        for (int k = 0; k < maxChar[j] + 2; ++k)
            cout << '-';
    }
    cout << "+\n";
}
void printLine2(int campi, int* maxChar) {
    for (int j = 0; j < campi; ++j) {
        for (int k = 0; k < maxChar[j] + 3; ++k)
            cout << '*';
    }
    cout << "*\n";
}
void printQuery(PGresult* res) {
    // Preparazione dati
    const int tuple = PQntuples(res), campi = PQnfields(res);
    string v[tuple + 1][campi];

    for (int i = 0; i < campi; ++i) {
        string s = PQfname(res, i);
        v[0][i] = s;
    }
    for (int i = 0; i < tuple; ++i)
        for (int j = 0; j < campi; ++j) {
            if (string(PQgetvalue(res, i, j)) == "t" || string(PQgetvalue(res, i, j)) == "f")
                if (string(PQgetvalue(res, i, j)) == "t")
                    v[i + 1][j] = "si";
                else
                    v[i + 1][j] = "no";
            else
                v[i + 1][j] = PQgetvalue(res, i, j);
        }

    int maxChar[campi];
    for (int i = 0; i < campi; ++i)
        maxChar[i] = 0;
    
    for (int i = 0; i < campi; ++i) {
        for (int j = 0; j < tuple + 1; ++j) {
            int size = v[j][i].size();
            if(size>120) { ///////////////////////////////////////////////////////
                v[j][i]=v[j][i].substr(0, 120)+"...";
                size=123;
            }
            maxChar[i] = size > maxChar[i] ? size : maxChar[i];
        }
    }

    // Stampa effettiva delle tuple
    cout<<'\n';
    printLine2(campi, maxChar);
    for (int j = 0; j < campi; ++j) {
        cout << "| ";
        cout << v[0][j];
        for (int k = 0; k < maxChar[j] - v[0][j].size() + 1; ++k)
            cout << ' ';
        if (j == campi - 1)
            cout << '|';
    }
    cout << endl;
    printLine2(campi, maxChar);

    for (int i = 1; i < tuple + 1; ++i) {
        for (int j = 0; j < campi; ++j) {
            cout << "| ";
            cout << v[i][j];
            for (int k = 0; k < maxChar[j] - v[i][j].size() + 1; ++k)
                cout << ' ';
            if (j == campi - 1)
                cout << "|";
        }
        cout << endl;
    }
    printLine(campi, maxChar);
}

int main(int argc, char** argv) {
    PGconn* conn = connect(PG_HOST, PG_USER, PG_DB, PG_PASS, PG_PORT);

    const char* query[11] = {
        "SELECT \"Titolo\", \"Durata-minuti\", \"Nome\", \"Cognome\" \
        FROM \"Film\", \"Regista\" \
        WHERE \"Regista\".\"Nome\"='%s' AND \"Regista\".\"Cognome\"='%s' \
        AND \"Film\".\"CF-regista\"=\"Regista\".\"CF\";",

        "SELECT \"Nome\" AS \"Nome_premio\", \"Anno\", \"Nome_film\" AS \"Vincitore\" \
        FROM \"Premio\" \
        WHERE \"Anno\"='%s' AND \"Nome_film\" IS NOT NULL \
        UNION \
        SELECT \"Premio\".\"Nome\" AS \"Nome_premio\", \"Anno\", \"Attore\".\"Nome\" AS \"Vincitore\" \
        FROM \"Premio\", \"Attore\" \
        WHERE \"Anno\"='%s' AND \"Premio\".\"CF_attore\"=\"Attore\".\"CF\" \
        UNION \
        SELECT \"Premio\".\"Nome\" AS \"Nome_premio\", \"Anno\", \"Regista\".\"Nome\" AS \"Vincitore\" \
        FROM \"Premio\", \"Regista\" \
        WHERE \"Anno\"='%s' AND \"Premio\".\"CF_regista\"=\"Regista\".\"CF\"",

        "SELECT \"Nome_film\", \"Lingua\", \"3D\" \
        FROM \"Proiezione\" \
        WHERE \"3D\"='1' AND EXTRACT(MONTH FROM \"Data\")=%s;",

        "SELECT \"Titolo\", \"Durata-minuti\", \"Genere\" \
        FROM \"Film\" \
        WHERE \"Genere\" LIKE '%%%s%%';",

        "SELECT \"Cinema\".\"Nome\", \"Sito\", \"Cinema\".\"Indirizzo\", \"CF\" AS \"CF Direttore\" \
        FROM \"Cinema\", \"Possiede\", \"Sala\", \"Contiene\", \"Posto\", \"Direttore\" \
        WHERE \"Cinema\".\"Nome\"=\"Possiede\".\"Nome_cinema\" AND \"Possiede\".\"Numero_sala\"=\"Sala\".\"Numero\" \
        AND \"Sala\".\"Numero\"=\"Contiene\".\"Numero_sala\" AND \"Contiene\".\"Numero_posto\"=\"Posto\".\"Numero\" \
        AND \"Direttore\".\"Nome-cinema\"=\"Cinema\".\"Nome\" \
        AND \"Vip\"='1' \
        GROUP BY \"Cinema\".\"Nome\", \"Sito\", \"Cinema\".\"Indirizzo\", \"CF\" \
        HAVING COUNT(*)>150;",

        "SELECT \"Nome\", \"Qualifica\", \"Recensione\" \
        FROM \"Critico\", \"Valutazione_critica\" \
        WHERE \"Valutazione_critica\".\"CF_critico\"=\"Critico\".\"CF\" \
        AND \"Nome\"='Erwin';",

        "SELECT \"Titolo\", ROUND(AVG(\"Voto\"), 1) AS \"Media\" \
        FROM \"Film\", \"Valutazione_critica\" \
        WHERE \"Valutazione_critica\".\"Nome_film\"=\"Film\".\"Titolo\" \
        GROUP BY \"Titolo\" \
        HAVING AVG(\"Voto\")>=6 \
        ORDER BY AVG(\"Voto\") DESC;",

        "SELECT \"Nome\", \"Cognome\", SUM(\"Contratto\") AS \"Guadagno (Euro)\" \
        FROM \"Attore\", \"Recita\" \
        WHERE \"Attore\".\"CF\"=\"Recita\".\"CF_attore\" \
        GROUP BY \"Attore\".\"CF\" \
        ORDER BY \"Guadagno (Euro)\" DESC \
        LIMIT 10;",
        
        "SELECT \"Titolo\", \"Voto\", \"Nome\", \"Cognome\" \
        FROM \"Film\", \"Valutazione_pubblico\", \"Spettatore\" \
        WHERE \"Valutazione_pubblico\".\"Nome_film\"=\"Film\".\"Titolo\" \
        AND \"Valutazione_pubblico\".\"CF_spettatore\"=\"Spettatore\".\"CF\" \
        AND \"Voto\"<6;",
        
        "SELECT \"Nome_film\", COUNT(*) AS \"Numero proiezioni\" \
        FROM \"Proiezione\" \
        GROUP BY \"Nome_film\";"
    };

    while (true) {
        cout<<"\nQUERY DISPONIBILI:\n \
         1. Mostrare tutti i titoli dei film e la loro durata fatti da un regista il cui nome e cognome\n \
            vengono dati come input\n \
         2. Dato in input un anno (2019-2022), per ogni vincitore (film, attore, regista) in quell'anno\n \
            mostrare il nome del premio, l'anno e il vincitore\n \
         3. Data in input un mese (del 2023), mostrare i titoli di tutti i film in 3D proiettati in quel \n \
            mese e la loro lingua\n \
         4. Dato in input un genere, mostrare il titolo e la durata di tutti i film di quel genere\n \
         5. Mostrare il nome, il sito web, l'indirizzo e il codice fiscale del direttore di tutti cinema che contengono più di 150 posti vip in totale\n \
         6. Mostrare la qualifica e tutte le recensioni di tutti i critici di nome Erwin\n \
         7. Mostrare tutti i titoli e valutazione media dei film che hanno almeno 6.0 come valutazione media\n \
            della critica in ordine decrescente di valutazione\n \
         8. Mostrare i 10 attori che hanno guadagnato di più\n \
         9. Mostrare i titoli, i voti del pubblico e nome e cognome della persona che ha assegnato il voto\n \
            per ogni valutazione negativa (<6) assegnata dal pubblico\n \
        10. Per ogni film, mostrare quante volte è stato proiettato\n";

        cout << "\nScegli la Query da eseguire (0 per uscire): ";
        int q = 0;
        cin >> q;
        while (q < 0 || q > 10) {
            cout << "Inserisci un numero da 1 a 11\n";
            cout << "Scegli la Query da eseguire (0 per uscire): ";
            cin >> q;   
        }
        if (q == 0) break;
        char queryTemp[1500];

        int i = 0;
        switch (q) {
        case 1:
            char nome[100];
            char cognome[100];
            cout << "Inserisci il nome del regista: ";
            cin >> nome;
            cout << "Inserisci il cognome del regista: ";
            cin >> cognome;
            sprintf(queryTemp, query[0], nome, cognome);
            printQuery(execute(conn, queryTemp));
            break;
        case 2:
            char anno[100];
            do {
                cout << "Inserisci un anno (2019-2022): ";
                cin >> anno;
            } while(atoi(anno)<2019 || atoi(anno)>2022); //gli unici anni di cui sono presenti questi dati nel database sono dal 2019 al 2022
            sprintf(queryTemp, query[1], anno, anno, anno);
            printQuery(execute(conn, queryTemp));
            break;
        case 3:
            char mese[100];
            do {
                cout << "Inserisci un mese (1-12): ";
                cin >> mese;
            } while(atoi(mese)<1 || atoi(mese)>12);
            sprintf(queryTemp, query[2], mese);
            printQuery(execute(conn, queryTemp));
            break;
        case 4:
            char genere[100];
            cout << "Inserisci un genere: ";
            cin >> genere;
            sprintf(queryTemp, query[3], genere);
            printQuery(execute(conn, queryTemp));
            break;
        default:
            printQuery(execute(conn, query[q - 1]));
            break;
        }
    }

    PQfinish(conn);
}
