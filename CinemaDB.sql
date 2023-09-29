---------- QUERY: ----------

--1
SELECT "Titolo", "Durata-minuti", "Nome", "Cognome"
FROM "Film", "Regista"
WHERE "Regista"."Nome"='PARAMETRO1' AND "Regista"."Cognome"='PARAMETRO2'
AND "Film"."CF-regista"="Regista"."CF";

--2
SELECT "Nome" AS "Nome_premio", "Anno", "Nome_film" AS "Vincitore"
FROM "Premio"
WHERE "Anno"='PARAMETRO1' AND "Nome_film" IS NOT NULL
UNION
SELECT "Premio"."Nome" AS "Nome_premio", "Anno", "Attore"."Nome" AS "Vincitore"
FROM "Premio", "Attore"
WHERE "Anno"='PARAMETRO1' AND "Premio"."CF_attore"="Attore"."CF"
UNION
SELECT "Premio"."Nome" AS "Nome_premio", "Anno", "Regista"."Nome" AS "Vincitore"
FROM "Premio", "Regista"
WHERE "Anno"='PARAMETRO1' AND "Premio"."CF_regista"="Regista"."CF";

--3
SELECT "Nome_film", "Lingua", "3D"
FROM "Proiezione"
WHERE "3D"='1' AND EXTRACT(MONTH FROM "Data")=PARAMETRO1;

--4
SELECT "Titolo", "Durata-minuti", "Genere"
FROM "Film"
WHERE "Genere" LIKE '%PARMETRO1%'; --tengo conto del fatto che un film può avere anche più generi

--5
SELECT "Cinema"."Nome", "Sito", "Cinema"."Indirizzo", "CF" AS "CF Direttore"
FROM "Cinema", "Possiede", "Sala", "Contiene", "Posto", "Direttore"
WHERE "Cinema"."Nome"="Possiede"."Nome_cinema" AND "Possiede"."Numero_sala"="Sala"."Numero"
AND "Sala"."Numero"="Contiene"."Numero_sala" AND "Contiene"."Numero_posto"="Posto"."Numero"
AND "Direttore"."Nome-cinema"="Cinema"."Nome"
AND "Vip"='1'
GROUP BY "Cinema"."Nome", "Sito", "Cinema"."Indirizzo", "CF"
HAVING COUNT(*)>150;

--6
SELECT "Nome", "Qualifica", "Recensione"
FROM "Critico", "Valutazione_critica"
WHERE "Valutazione_critica"."CF_critico"="Critico"."CF"
AND "Nome"='Erwin';

--7
SELECT "Titolo", ROUND(AVG("Voto"), 1) AS "Media"
FROM "Film", "Valutazione_critica"
WHERE "Valutazione_critica"."Nome_film"="Film"."Titolo"
GROUP BY "Titolo"
HAVING AVG("Voto")>=6
ORDER BY AVG("Voto") DESC;

--8
SELECT "Nome", "Cognome", SUM("Contratto") AS "Guadagno (Euro)"
FROM "Attore", "Recita"
WHERE "Attore"."CF"="Recita"."CF_attore"
GROUP BY "Attore"."CF"
ORDER BY "Guadagno (Euro)" DESC
LIMIT 10;

--9
SELECT "Titolo", "Voto", "Nome", "Cognome"
FROM "Film", "Valutazione_pubblico", "Spettatore"
WHERE "Valutazione_pubblico"."Nome_film"="Film"."Titolo"
AND "Valutazione_pubblico"."CF_spettatore"="Spettatore"."CF"
AND "Voto"<6;

--10
SELECT "Nome_film", COUNT(*) AS "Numero proiezioni"
FROM "Proiezione\"
GROUP BY "Nome_film";

----------------------------




--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

-- Started on 2023-08-28 21:19:44

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3457 (class 1262 OID 16399)
-- Name: CinemaDB; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "CinemaDB" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United Kingdom.1252';


ALTER DATABASE "CinemaDB" OWNER TO postgres;

\connect "CinemaDB"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 225 (class 1259 OID 16660)
-- Name: Attore; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Attore" (
    "CF" character varying(16) NOT NULL,
    "Eta" integer,
    "Indirizzo" character varying(100),
    "Sesso" character varying(1),
    "Nome" character varying(100) NOT NULL,
    "Cognome" character varying(100) NOT NULL
);


ALTER TABLE public."Attore" OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16494)
-- Name: Cinema; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Cinema" (
    "Nome" character varying(255) NOT NULL,
    "Sito" character varying(255),
    "Indirizzo" character varying(255)
);


ALTER TABLE public."Cinema" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16595)
-- Name: Contiene; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Contiene" (
    "Numero_posto" integer NOT NULL,
    "Numero_sala" integer NOT NULL
);


ALTER TABLE public."Contiene" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16645)
-- Name: Critico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Critico" (
    "CF" character varying(16) NOT NULL,
    "Eta" integer,
    "Indirizzo" character varying(100),
    "Sesso" character varying(1),
    "Nome" character varying(100) NOT NULL,
    "Cognome" character varying(100) NOT NULL,
    "Qualifica" character varying(100) NOT NULL
);


ALTER TABLE public."Critico" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16665)
-- Name: Direttore; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Direttore" (
    "CF" character varying(16) NOT NULL,
    "Eta" integer,
    "Indirizzo" character varying(100),
    "Sesso" character varying(1),
    "Nome" character varying(100) NOT NULL,
    "Cognome" character varying(100) NOT NULL,
    "Nome-cinema" character varying(100)
);


ALTER TABLE public."Direttore" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16506)
-- Name: Film; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Film" (
    "Titolo" character varying(100) NOT NULL,
    "Durata-minuti" integer,
    "Genere" character varying(100),
    "CF-regista" character varying(16)
);


ALTER TABLE public."Film" OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16610)
-- Name: Possiede; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Possiede" (
    "Numero_sala" integer NOT NULL,
    "Nome_cinema" character varying(255) NOT NULL
);


ALTER TABLE public."Possiede" OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16526)
-- Name: Posto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Posto" (
    "Numero" integer NOT NULL,
    "Vip" bit(1)
);


ALTER TABLE public."Posto" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16531)
-- Name: Premio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Premio" (
    "Nome" character varying(50) NOT NULL,
    "Anno" integer NOT NULL,
    "Nome_film" character varying(100),
    "CF_attore" character varying(16),
    "CF_regista" character varying(16)
);


ALTER TABLE public."Premio" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16628)
-- Name: Proiezione; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Proiezione" (
    "Data" date NOT NULL,
    "Ora-inizio" time without time zone NOT NULL,
    "Ora-fine" time without time zone,
    "Numero_sala" integer NOT NULL,
    "3D" bit(1),
    "Costo-normale" double precision,
    "Costo-vip" double precision,
    "Lingua" character varying(100),
    "Nome_film" character varying(100)
);


ALTER TABLE public."Proiezione" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16744)
-- Name: Recita; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Recita" (
    "CF_attore" character varying(16) NOT NULL,
    "Nome_film" character varying(100) NOT NULL,
    "Contratto" integer,
    "Ruolo" character varying(100)
);


ALTER TABLE public."Recita" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16655)
-- Name: Regista; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Regista" (
    "CF" character varying(16) NOT NULL,
    "Eta" integer,
    "Indirizzo" character varying(100),
    "Sesso" character varying(1),
    "Nome" character varying(100) NOT NULL,
    "Cognome" character varying(100) NOT NULL
);


ALTER TABLE public."Regista" OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16572)
-- Name: Sala; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Sala" (
    "Numero" integer NOT NULL
);


ALTER TABLE public."Sala" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16650)
-- Name: Spettatore; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Spettatore" (
    "CF" character varying(16) NOT NULL,
    "Eta" integer,
    "Indirizzo" character varying(100),
    "Sesso" character varying(1),
    "Nome" character varying(100) NOT NULL,
    "Cognome" character varying(100) NOT NULL
);


ALTER TABLE public."Spettatore" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16705)
-- Name: Valutazione_critica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Valutazione_critica" (
    "Nome_film" character varying(100) NOT NULL,
    "CF_critico" character(16) NOT NULL,
    "Voto" integer NOT NULL,
    "Recensione" character varying(1000)
);


ALTER TABLE public."Valutazione_critica" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16712)
-- Name: Valutazione_pubblico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Valutazione_pubblico" (
    "Nome_film" character varying(100) NOT NULL,
    "CF_spettatore" character varying(16) NOT NULL,
    "Voto" integer NOT NULL
);


ALTER TABLE public."Valutazione_pubblico" OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16807)
-- Name: view_5; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_5 AS
 SELECT "Cinema"."Nome",
    "Cinema"."Sito",
    "Cinema"."Indirizzo"
   FROM public."Cinema",
    public."Possiede",
    public."Sala",
    public."Contiene",
    public."Posto"
  WHERE ((("Cinema"."Nome")::text = ("Possiede"."Nome_cinema")::text) AND ("Possiede"."Numero_sala" = "Sala"."Numero") AND ("Sala"."Numero" = "Contiene"."Numero_sala") AND ("Contiene"."Numero_posto" = "Posto"."Numero") AND ("Posto"."Vip" = '1'::"bit"));


ALTER TABLE public.view_5 OWNER TO postgres;

--
-- TOC entry 3447 (class 0 OID 16660)
-- Dependencies: 225
-- Data for Name: Attore; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Attore" VALUES ('DJMMZG31Z31E010V', 36, '5214 Mallard Junction', 'F', 'Carlynn', 'Quin');
INSERT INTO public."Attore" VALUES ('DIMNIF66R84F774V', 52, '51891 Pennsylvania Lane', 'M', 'Valentine', 'Willers');
INSERT INTO public."Attore" VALUES ('GOPAUS28P64O689R', 19, '3438 Bayside Center', 'F', 'Marcela', 'Matas');
INSERT INTO public."Attore" VALUES ('WVOOBJ59L91Y304K', 71, '6 Barnett Crossing', 'M', 'Mikkel', 'Cranefield');
INSERT INTO public."Attore" VALUES ('HUMAQM51B08Z578G', 70, '266 Riverside Road', 'F', 'Rodie', 'McFaul');
INSERT INTO public."Attore" VALUES ('FPCXRR67N67K247X', 33, '65437 Arkansas Circle', 'M', 'Inglis', 'Ericsson');
INSERT INTO public."Attore" VALUES ('TXUNSZ54P02Q657W', 69, '69530 Shopko Place', 'M', 'Fletcher', 'Lidden');
INSERT INTO public."Attore" VALUES ('BAZMYN35W57O831R', 75, '367 Washington Court', 'M', 'Hermie', 'Rabjohns');
INSERT INTO public."Attore" VALUES ('OTPHZV27Y71E882Z', 19, '62961 Johnson Plaza', 'M', 'Loren', 'Kenright');
INSERT INTO public."Attore" VALUES ('HPTYVZ86X30F388V', 42, '2 Graceland Alley', 'M', 'Jens', 'McKee');
INSERT INTO public."Attore" VALUES ('IWFNUT42P24E682Z', 18, '0048 Messerschmidt Drive', 'F', 'Christin', 'Brauns');
INSERT INTO public."Attore" VALUES ('VZGYYN71Q74B606O', 27, '62127 Springs Terrace', 'M', 'Clemmie', 'Folling');
INSERT INTO public."Attore" VALUES ('GJMLAK58L46B708Y', 19, '42 Norway Maple Crossing', 'F', 'Mikaela', 'McSporrin');
INSERT INTO public."Attore" VALUES ('KPXHAO63N50P806T', 21, '486 Hooker Hill', 'M', 'Spence', 'Oxburgh');
INSERT INTO public."Attore" VALUES ('CMMYIL90W26R836A', 39, '174 Derek Junction', 'M', 'Brenden', 'Greenrodd');
INSERT INTO public."Attore" VALUES ('TGLTOD52S83R646W', 53, '510 Dennis Terrace', 'F', 'Stephie', 'Bullick');
INSERT INTO public."Attore" VALUES ('ONAXAM15O57B236B', 23, '13 Cardinal Park', 'M', 'Godwin', 'Corzor');
INSERT INTO public."Attore" VALUES ('ZENGKR35M47L113B', 52, '5402 Magdeline Trail', 'M', 'Byram', 'Cutmore');
INSERT INTO public."Attore" VALUES ('FZLBXW48C50Y893P', 48, '0 Hanson Drive', 'F', 'Agathe', 'Whitwam');
INSERT INTO public."Attore" VALUES ('SPUYMG72I01G211L', 70, '041 Division Point', 'F', 'Sharline', 'Clapton');
INSERT INTO public."Attore" VALUES ('EPVIIQ64L27W231V', 60, '38559 Surrey Drive', 'F', 'Lanni', 'O''Kieran');
INSERT INTO public."Attore" VALUES ('SNXIIY19Q95N099F', 65, '1743 Sheridan Park', 'F', 'Ilyse', 'Yetman');
INSERT INTO public."Attore" VALUES ('FAONOR75Q31W618U', 64, '10 Comanche Park', 'F', 'Denyse', 'Jelf');
INSERT INTO public."Attore" VALUES ('DUJHCZ49O39R797M', 78, '64483 Morning Road', 'M', 'Emmy', 'Ibbs');
INSERT INTO public."Attore" VALUES ('OWXSVQ22E13M482K', 43, '3 Lindbergh Alley', 'M', 'Osborne', 'Roocroft');
INSERT INTO public."Attore" VALUES ('MJWJJV79R57S988A', 71, '0547 7th Plaza', 'F', 'Marguerite', 'MacAskie');
INSERT INTO public."Attore" VALUES ('UFOEDJ09C28M452Q', 38, '973 Brentwood Lane', 'F', 'Othelia', 'Bolzen');
INSERT INTO public."Attore" VALUES ('HXPBIJ47Y12K224M', 25, '12179 Hollow Ridge Street', 'M', 'Levi', 'Haller');
INSERT INTO public."Attore" VALUES ('COWPQT79G19A198I', 39, '296 Meadow Valley Terrace', 'F', 'Rhonda', 'Hindge');
INSERT INTO public."Attore" VALUES ('VCRBGM98T66J346R', 48, '9984 Clemons Drive', 'F', 'Modesta', 'Meindl');
INSERT INTO public."Attore" VALUES ('VSODYG58H09U245D', 60, '323 Bartelt Alley', 'M', 'Mischa', 'Flux');
INSERT INTO public."Attore" VALUES ('FDJYGS58U60L510J', 30, '9 Arrowood Circle', 'F', 'Kyrstin', 'Scamp');
INSERT INTO public."Attore" VALUES ('RNSRBV23K43Y969N', 76, '39 Hoffman Trail', 'F', 'Clary', 'Tax');
INSERT INTO public."Attore" VALUES ('QHOQFV30I40A436W', 29, '14725 Gerald Junction', 'F', 'Shandee', 'Hoffmann');
INSERT INTO public."Attore" VALUES ('KFCHLF91J27Z907E', 42, '19069 Pine View Plaza', 'F', 'Ree', 'Zincke');
INSERT INTO public."Attore" VALUES ('BNDKHS92H51Z657X', 77, '75 Meadow Valley Place', 'M', 'Christos', 'Mucklow');
INSERT INTO public."Attore" VALUES ('YIPFXY68W11N274U', 77, '5 Heath Street', 'F', 'Tandie', 'Lipprose');
INSERT INTO public."Attore" VALUES ('DGQNMG80K01A483G', 78, '69 Commercial Terrace', 'F', 'Ellene', 'Trunks');
INSERT INTO public."Attore" VALUES ('VOZJDF41H43W079I', 76, '49598 Everett Drive', 'F', 'Carree', 'Cornau');
INSERT INTO public."Attore" VALUES ('KJSCPR78I84Y203J', 30, '31 Hauk Place', 'F', 'Magdalen', 'Charrisson');
INSERT INTO public."Attore" VALUES ('FKBIMT21J50F212A', 33, '9 Westend Parkway', 'F', 'Ianthe', 'Boutton');
INSERT INTO public."Attore" VALUES ('EFHAMI32F19A135H', 38, '5888 Westport Avenue', 'M', 'Baudoin', 'Lille');
INSERT INTO public."Attore" VALUES ('OHSOZS65O42G121Y', 57, '1437 Express Alley', 'F', 'Oneida', 'Astall');
INSERT INTO public."Attore" VALUES ('JLNFUW11R33J032O', 70, '9073 Cottonwood Parkway', 'M', 'Con', 'Jumonet');
INSERT INTO public."Attore" VALUES ('QKBXDZ07C62W650D', 38, '311 Holy Cross Terrace', 'M', 'Dur', 'Alder');
INSERT INTO public."Attore" VALUES ('ZJFWGR45X75O101E', 56, '9 Ryan Plaza', 'F', 'Lanette', 'Leyborne');
INSERT INTO public."Attore" VALUES ('OXIQNQ61W59Q659X', 28, '0 Dennis Street', 'M', 'Ransom', 'Ritmeyer');
INSERT INTO public."Attore" VALUES ('JJKFQX59M91W607B', 27, '12 Eliot Crossing', 'F', 'Tamqrah', 'Niess');
INSERT INTO public."Attore" VALUES ('UJCYLQ20B51O642E', 33, '8 Hudson Pass', 'F', 'Bridgette', 'Mariotte');
INSERT INTO public."Attore" VALUES ('ZAIUMK22C98L832Z', 33, '3486 Moulton Plaza', 'M', 'Freeman', 'Dentith');


--
-- TOC entry 3436 (class 0 OID 16494)
-- Dependencies: 214
-- Data for Name: Cinema; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Cinema" VALUES ('Jaxspan', 'jaxspan.ca', '7770 Mesta Lane');
INSERT INTO public."Cinema" VALUES ('Youtags', 'youtags.com', '6 Havey Terrace');
INSERT INTO public."Cinema" VALUES ('Quinu', 'quinu.gov', '4 Johnson Street');
INSERT INTO public."Cinema" VALUES ('Thoughtworks', 'thoughtworks.nl', '079 Marquette Plaza');
INSERT INTO public."Cinema" VALUES ('Gigazoom', 'gigazoom.edu', '6 Lerdahl Hill');
INSERT INTO public."Cinema" VALUES ('Livepath', 'livepath.com', '0 Canary Hill');
INSERT INTO public."Cinema" VALUES ('Jetwire', 'jetwire.com', '98 Dayton Drive');
INSERT INTO public."Cinema" VALUES ('Eabox', 'eabox.com', '63117 Ridgeview Drive');
INSERT INTO public."Cinema" VALUES ('Leenti', 'leenti.com', '4 Hazelcrest Road');
INSERT INTO public."Cinema" VALUES ('Babblestorm', 'babblestorm.com', '27 Jenifer Place');
INSERT INTO public."Cinema" VALUES ('Kwilith', 'kwilith.br', '58 Hayes Drive');
INSERT INTO public."Cinema" VALUES ('Photofeed', 'photofeed.com', '34 Menomonie Junction');
INSERT INTO public."Cinema" VALUES ('Blogtags', 'blogtags.fr', '78981 Gateway Crossing');
INSERT INTO public."Cinema" VALUES ('Thoughtstorm', 'thoughstorm.it', '8230 8th Point');
INSERT INTO public."Cinema" VALUES ('Jabbersphere', 'jabbersphere.au', '981 Ruskin Road');
INSERT INTO public."Cinema" VALUES ('Buzzbean', 'buzzbean.de', '78 Coolidge Trail');
INSERT INTO public."Cinema" VALUES ('Feedfire', 'feedfire.com', '669 Lillian Junction');
INSERT INTO public."Cinema" VALUES ('Twiner', 'twiner.com', '633 Johnson Terrace');
INSERT INTO public."Cinema" VALUES ('Buzzster', 'buzzster.com', '1 Bartelt Road');
INSERT INTO public."Cinema" VALUES ('Kamba', 'kamba.com', '84 Farwell Way');


--
-- TOC entry 3441 (class 0 OID 16595)
-- Dependencies: 219
-- Data for Name: Contiene; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Contiene" VALUES (1, 1);
INSERT INTO public."Contiene" VALUES (2, 1);
INSERT INTO public."Contiene" VALUES (3, 1);
INSERT INTO public."Contiene" VALUES (4, 1);
INSERT INTO public."Contiene" VALUES (5, 1);
INSERT INTO public."Contiene" VALUES (6, 1);
INSERT INTO public."Contiene" VALUES (7, 1);
INSERT INTO public."Contiene" VALUES (8, 1);
INSERT INTO public."Contiene" VALUES (9, 1);
INSERT INTO public."Contiene" VALUES (10, 1);
INSERT INTO public."Contiene" VALUES (11, 1);
INSERT INTO public."Contiene" VALUES (12, 1);
INSERT INTO public."Contiene" VALUES (13, 1);
INSERT INTO public."Contiene" VALUES (14, 1);
INSERT INTO public."Contiene" VALUES (15, 1);
INSERT INTO public."Contiene" VALUES (16, 1);
INSERT INTO public."Contiene" VALUES (17, 1);
INSERT INTO public."Contiene" VALUES (18, 1);
INSERT INTO public."Contiene" VALUES (19, 1);
INSERT INTO public."Contiene" VALUES (20, 1);
INSERT INTO public."Contiene" VALUES (21, 1);
INSERT INTO public."Contiene" VALUES (22, 1);
INSERT INTO public."Contiene" VALUES (23, 1);
INSERT INTO public."Contiene" VALUES (24, 1);
INSERT INTO public."Contiene" VALUES (25, 1);
INSERT INTO public."Contiene" VALUES (26, 1);
INSERT INTO public."Contiene" VALUES (27, 1);
INSERT INTO public."Contiene" VALUES (28, 1);
INSERT INTO public."Contiene" VALUES (29, 1);
INSERT INTO public."Contiene" VALUES (30, 1);
INSERT INTO public."Contiene" VALUES (31, 1);
INSERT INTO public."Contiene" VALUES (32, 1);
INSERT INTO public."Contiene" VALUES (33, 1);
INSERT INTO public."Contiene" VALUES (34, 1);
INSERT INTO public."Contiene" VALUES (35, 1);
INSERT INTO public."Contiene" VALUES (36, 1);
INSERT INTO public."Contiene" VALUES (37, 1);
INSERT INTO public."Contiene" VALUES (38, 1);
INSERT INTO public."Contiene" VALUES (39, 1);
INSERT INTO public."Contiene" VALUES (40, 1);
INSERT INTO public."Contiene" VALUES (41, 1);
INSERT INTO public."Contiene" VALUES (42, 1);
INSERT INTO public."Contiene" VALUES (43, 1);
INSERT INTO public."Contiene" VALUES (44, 1);
INSERT INTO public."Contiene" VALUES (45, 1);
INSERT INTO public."Contiene" VALUES (46, 1);
INSERT INTO public."Contiene" VALUES (47, 1);
INSERT INTO public."Contiene" VALUES (48, 1);
INSERT INTO public."Contiene" VALUES (49, 1);
INSERT INTO public."Contiene" VALUES (50, 1);
INSERT INTO public."Contiene" VALUES (51, 1);
INSERT INTO public."Contiene" VALUES (52, 1);
INSERT INTO public."Contiene" VALUES (53, 1);
INSERT INTO public."Contiene" VALUES (54, 1);
INSERT INTO public."Contiene" VALUES (55, 1);
INSERT INTO public."Contiene" VALUES (56, 1);
INSERT INTO public."Contiene" VALUES (57, 1);
INSERT INTO public."Contiene" VALUES (58, 1);
INSERT INTO public."Contiene" VALUES (59, 1);
INSERT INTO public."Contiene" VALUES (60, 1);
INSERT INTO public."Contiene" VALUES (61, 1);
INSERT INTO public."Contiene" VALUES (62, 1);
INSERT INTO public."Contiene" VALUES (63, 1);
INSERT INTO public."Contiene" VALUES (64, 1);
INSERT INTO public."Contiene" VALUES (65, 1);
INSERT INTO public."Contiene" VALUES (66, 1);
INSERT INTO public."Contiene" VALUES (67, 1);
INSERT INTO public."Contiene" VALUES (68, 1);
INSERT INTO public."Contiene" VALUES (69, 1);
INSERT INTO public."Contiene" VALUES (70, 1);
INSERT INTO public."Contiene" VALUES (71, 1);
INSERT INTO public."Contiene" VALUES (72, 1);
INSERT INTO public."Contiene" VALUES (73, 1);
INSERT INTO public."Contiene" VALUES (74, 1);
INSERT INTO public."Contiene" VALUES (75, 1);
INSERT INTO public."Contiene" VALUES (76, 1);
INSERT INTO public."Contiene" VALUES (77, 1);
INSERT INTO public."Contiene" VALUES (78, 1);
INSERT INTO public."Contiene" VALUES (79, 1);
INSERT INTO public."Contiene" VALUES (80, 1);
INSERT INTO public."Contiene" VALUES (81, 1);
INSERT INTO public."Contiene" VALUES (82, 1);
INSERT INTO public."Contiene" VALUES (83, 1);
INSERT INTO public."Contiene" VALUES (84, 1);
INSERT INTO public."Contiene" VALUES (85, 1);
INSERT INTO public."Contiene" VALUES (86, 1);
INSERT INTO public."Contiene" VALUES (87, 1);
INSERT INTO public."Contiene" VALUES (88, 1);
INSERT INTO public."Contiene" VALUES (89, 1);
INSERT INTO public."Contiene" VALUES (90, 1);
INSERT INTO public."Contiene" VALUES (91, 1);
INSERT INTO public."Contiene" VALUES (92, 1);
INSERT INTO public."Contiene" VALUES (93, 1);
INSERT INTO public."Contiene" VALUES (94, 1);
INSERT INTO public."Contiene" VALUES (95, 1);
INSERT INTO public."Contiene" VALUES (96, 1);
INSERT INTO public."Contiene" VALUES (97, 1);
INSERT INTO public."Contiene" VALUES (98, 1);
INSERT INTO public."Contiene" VALUES (99, 1);
INSERT INTO public."Contiene" VALUES (100, 1);
INSERT INTO public."Contiene" VALUES (101, 1);
INSERT INTO public."Contiene" VALUES (102, 1);
INSERT INTO public."Contiene" VALUES (103, 1);
INSERT INTO public."Contiene" VALUES (104, 1);
INSERT INTO public."Contiene" VALUES (105, 1);
INSERT INTO public."Contiene" VALUES (106, 1);
INSERT INTO public."Contiene" VALUES (107, 1);
INSERT INTO public."Contiene" VALUES (108, 1);
INSERT INTO public."Contiene" VALUES (109, 1);
INSERT INTO public."Contiene" VALUES (110, 1);
INSERT INTO public."Contiene" VALUES (111, 1);
INSERT INTO public."Contiene" VALUES (112, 1);
INSERT INTO public."Contiene" VALUES (113, 1);
INSERT INTO public."Contiene" VALUES (114, 1);
INSERT INTO public."Contiene" VALUES (115, 1);
INSERT INTO public."Contiene" VALUES (116, 1);
INSERT INTO public."Contiene" VALUES (117, 1);
INSERT INTO public."Contiene" VALUES (118, 1);
INSERT INTO public."Contiene" VALUES (119, 1);
INSERT INTO public."Contiene" VALUES (120, 1);
INSERT INTO public."Contiene" VALUES (121, 1);
INSERT INTO public."Contiene" VALUES (122, 1);
INSERT INTO public."Contiene" VALUES (123, 1);
INSERT INTO public."Contiene" VALUES (124, 1);
INSERT INTO public."Contiene" VALUES (125, 1);
INSERT INTO public."Contiene" VALUES (126, 1);
INSERT INTO public."Contiene" VALUES (127, 1);
INSERT INTO public."Contiene" VALUES (128, 1);
INSERT INTO public."Contiene" VALUES (129, 1);
INSERT INTO public."Contiene" VALUES (130, 1);
INSERT INTO public."Contiene" VALUES (131, 1);
INSERT INTO public."Contiene" VALUES (132, 1);
INSERT INTO public."Contiene" VALUES (133, 1);
INSERT INTO public."Contiene" VALUES (134, 1);
INSERT INTO public."Contiene" VALUES (135, 1);
INSERT INTO public."Contiene" VALUES (136, 1);
INSERT INTO public."Contiene" VALUES (137, 1);
INSERT INTO public."Contiene" VALUES (138, 1);
INSERT INTO public."Contiene" VALUES (139, 1);
INSERT INTO public."Contiene" VALUES (140, 1);
INSERT INTO public."Contiene" VALUES (141, 1);
INSERT INTO public."Contiene" VALUES (142, 1);
INSERT INTO public."Contiene" VALUES (143, 1);
INSERT INTO public."Contiene" VALUES (144, 1);
INSERT INTO public."Contiene" VALUES (145, 1);
INSERT INTO public."Contiene" VALUES (146, 1);
INSERT INTO public."Contiene" VALUES (147, 1);
INSERT INTO public."Contiene" VALUES (148, 1);
INSERT INTO public."Contiene" VALUES (149, 1);
INSERT INTO public."Contiene" VALUES (150, 1);
INSERT INTO public."Contiene" VALUES (151, 1);
INSERT INTO public."Contiene" VALUES (152, 1);
INSERT INTO public."Contiene" VALUES (153, 1);
INSERT INTO public."Contiene" VALUES (154, 1);
INSERT INTO public."Contiene" VALUES (155, 1);
INSERT INTO public."Contiene" VALUES (156, 1);
INSERT INTO public."Contiene" VALUES (157, 1);
INSERT INTO public."Contiene" VALUES (158, 1);
INSERT INTO public."Contiene" VALUES (159, 1);
INSERT INTO public."Contiene" VALUES (160, 1);
INSERT INTO public."Contiene" VALUES (161, 1);
INSERT INTO public."Contiene" VALUES (162, 1);
INSERT INTO public."Contiene" VALUES (163, 1);
INSERT INTO public."Contiene" VALUES (164, 1);
INSERT INTO public."Contiene" VALUES (165, 1);
INSERT INTO public."Contiene" VALUES (166, 1);
INSERT INTO public."Contiene" VALUES (167, 1);
INSERT INTO public."Contiene" VALUES (168, 1);
INSERT INTO public."Contiene" VALUES (169, 1);
INSERT INTO public."Contiene" VALUES (170, 1);
INSERT INTO public."Contiene" VALUES (171, 1);
INSERT INTO public."Contiene" VALUES (172, 1);
INSERT INTO public."Contiene" VALUES (173, 1);
INSERT INTO public."Contiene" VALUES (174, 1);
INSERT INTO public."Contiene" VALUES (175, 1);
INSERT INTO public."Contiene" VALUES (176, 1);
INSERT INTO public."Contiene" VALUES (177, 1);
INSERT INTO public."Contiene" VALUES (178, 1);
INSERT INTO public."Contiene" VALUES (179, 1);
INSERT INTO public."Contiene" VALUES (180, 1);
INSERT INTO public."Contiene" VALUES (181, 1);
INSERT INTO public."Contiene" VALUES (182, 1);
INSERT INTO public."Contiene" VALUES (183, 1);
INSERT INTO public."Contiene" VALUES (184, 1);
INSERT INTO public."Contiene" VALUES (185, 1);
INSERT INTO public."Contiene" VALUES (186, 1);
INSERT INTO public."Contiene" VALUES (187, 1);
INSERT INTO public."Contiene" VALUES (188, 1);
INSERT INTO public."Contiene" VALUES (189, 1);
INSERT INTO public."Contiene" VALUES (190, 1);
INSERT INTO public."Contiene" VALUES (191, 1);
INSERT INTO public."Contiene" VALUES (192, 1);
INSERT INTO public."Contiene" VALUES (193, 1);
INSERT INTO public."Contiene" VALUES (194, 1);
INSERT INTO public."Contiene" VALUES (195, 1);
INSERT INTO public."Contiene" VALUES (196, 1);
INSERT INTO public."Contiene" VALUES (197, 1);
INSERT INTO public."Contiene" VALUES (198, 1);
INSERT INTO public."Contiene" VALUES (199, 1);
INSERT INTO public."Contiene" VALUES (200, 1);
INSERT INTO public."Contiene" VALUES (1, 2);
INSERT INTO public."Contiene" VALUES (2, 2);
INSERT INTO public."Contiene" VALUES (3, 2);
INSERT INTO public."Contiene" VALUES (4, 2);
INSERT INTO public."Contiene" VALUES (5, 2);
INSERT INTO public."Contiene" VALUES (6, 2);
INSERT INTO public."Contiene" VALUES (7, 2);
INSERT INTO public."Contiene" VALUES (8, 2);
INSERT INTO public."Contiene" VALUES (9, 2);
INSERT INTO public."Contiene" VALUES (10, 2);
INSERT INTO public."Contiene" VALUES (11, 2);
INSERT INTO public."Contiene" VALUES (12, 2);
INSERT INTO public."Contiene" VALUES (13, 2);
INSERT INTO public."Contiene" VALUES (14, 2);
INSERT INTO public."Contiene" VALUES (15, 2);
INSERT INTO public."Contiene" VALUES (16, 2);
INSERT INTO public."Contiene" VALUES (17, 2);
INSERT INTO public."Contiene" VALUES (18, 2);
INSERT INTO public."Contiene" VALUES (19, 2);
INSERT INTO public."Contiene" VALUES (20, 2);
INSERT INTO public."Contiene" VALUES (21, 2);
INSERT INTO public."Contiene" VALUES (22, 2);
INSERT INTO public."Contiene" VALUES (23, 2);
INSERT INTO public."Contiene" VALUES (24, 2);
INSERT INTO public."Contiene" VALUES (25, 2);
INSERT INTO public."Contiene" VALUES (26, 2);
INSERT INTO public."Contiene" VALUES (27, 2);
INSERT INTO public."Contiene" VALUES (28, 2);
INSERT INTO public."Contiene" VALUES (29, 2);
INSERT INTO public."Contiene" VALUES (30, 2);
INSERT INTO public."Contiene" VALUES (31, 2);
INSERT INTO public."Contiene" VALUES (32, 2);
INSERT INTO public."Contiene" VALUES (33, 2);
INSERT INTO public."Contiene" VALUES (34, 2);
INSERT INTO public."Contiene" VALUES (35, 2);
INSERT INTO public."Contiene" VALUES (36, 2);
INSERT INTO public."Contiene" VALUES (37, 2);
INSERT INTO public."Contiene" VALUES (38, 2);
INSERT INTO public."Contiene" VALUES (39, 2);
INSERT INTO public."Contiene" VALUES (40, 2);
INSERT INTO public."Contiene" VALUES (41, 2);
INSERT INTO public."Contiene" VALUES (42, 2);
INSERT INTO public."Contiene" VALUES (43, 2);
INSERT INTO public."Contiene" VALUES (44, 2);
INSERT INTO public."Contiene" VALUES (45, 2);
INSERT INTO public."Contiene" VALUES (46, 2);
INSERT INTO public."Contiene" VALUES (47, 2);
INSERT INTO public."Contiene" VALUES (48, 2);
INSERT INTO public."Contiene" VALUES (49, 2);
INSERT INTO public."Contiene" VALUES (50, 2);
INSERT INTO public."Contiene" VALUES (51, 2);
INSERT INTO public."Contiene" VALUES (52, 2);
INSERT INTO public."Contiene" VALUES (53, 2);
INSERT INTO public."Contiene" VALUES (54, 2);
INSERT INTO public."Contiene" VALUES (55, 2);
INSERT INTO public."Contiene" VALUES (56, 2);
INSERT INTO public."Contiene" VALUES (57, 2);
INSERT INTO public."Contiene" VALUES (58, 2);
INSERT INTO public."Contiene" VALUES (59, 2);
INSERT INTO public."Contiene" VALUES (60, 2);
INSERT INTO public."Contiene" VALUES (61, 2);
INSERT INTO public."Contiene" VALUES (62, 2);
INSERT INTO public."Contiene" VALUES (63, 2);
INSERT INTO public."Contiene" VALUES (64, 2);
INSERT INTO public."Contiene" VALUES (65, 2);
INSERT INTO public."Contiene" VALUES (66, 2);
INSERT INTO public."Contiene" VALUES (67, 2);
INSERT INTO public."Contiene" VALUES (68, 2);
INSERT INTO public."Contiene" VALUES (69, 2);
INSERT INTO public."Contiene" VALUES (70, 2);
INSERT INTO public."Contiene" VALUES (71, 2);
INSERT INTO public."Contiene" VALUES (72, 2);
INSERT INTO public."Contiene" VALUES (73, 2);
INSERT INTO public."Contiene" VALUES (74, 2);
INSERT INTO public."Contiene" VALUES (75, 2);
INSERT INTO public."Contiene" VALUES (76, 2);
INSERT INTO public."Contiene" VALUES (77, 2);
INSERT INTO public."Contiene" VALUES (78, 2);
INSERT INTO public."Contiene" VALUES (79, 2);
INSERT INTO public."Contiene" VALUES (80, 2);
INSERT INTO public."Contiene" VALUES (81, 2);
INSERT INTO public."Contiene" VALUES (82, 2);
INSERT INTO public."Contiene" VALUES (83, 2);
INSERT INTO public."Contiene" VALUES (84, 2);
INSERT INTO public."Contiene" VALUES (85, 2);
INSERT INTO public."Contiene" VALUES (86, 2);
INSERT INTO public."Contiene" VALUES (87, 2);
INSERT INTO public."Contiene" VALUES (88, 2);
INSERT INTO public."Contiene" VALUES (89, 2);
INSERT INTO public."Contiene" VALUES (90, 2);
INSERT INTO public."Contiene" VALUES (91, 2);
INSERT INTO public."Contiene" VALUES (92, 2);
INSERT INTO public."Contiene" VALUES (93, 2);
INSERT INTO public."Contiene" VALUES (94, 2);
INSERT INTO public."Contiene" VALUES (95, 2);
INSERT INTO public."Contiene" VALUES (96, 2);
INSERT INTO public."Contiene" VALUES (97, 2);
INSERT INTO public."Contiene" VALUES (98, 2);
INSERT INTO public."Contiene" VALUES (99, 2);
INSERT INTO public."Contiene" VALUES (100, 2);
INSERT INTO public."Contiene" VALUES (101, 2);
INSERT INTO public."Contiene" VALUES (102, 2);
INSERT INTO public."Contiene" VALUES (103, 2);
INSERT INTO public."Contiene" VALUES (104, 2);
INSERT INTO public."Contiene" VALUES (105, 2);
INSERT INTO public."Contiene" VALUES (106, 2);
INSERT INTO public."Contiene" VALUES (107, 2);
INSERT INTO public."Contiene" VALUES (108, 2);
INSERT INTO public."Contiene" VALUES (109, 2);
INSERT INTO public."Contiene" VALUES (110, 2);
INSERT INTO public."Contiene" VALUES (111, 2);
INSERT INTO public."Contiene" VALUES (112, 2);
INSERT INTO public."Contiene" VALUES (113, 2);
INSERT INTO public."Contiene" VALUES (114, 2);
INSERT INTO public."Contiene" VALUES (115, 2);
INSERT INTO public."Contiene" VALUES (116, 2);
INSERT INTO public."Contiene" VALUES (117, 2);
INSERT INTO public."Contiene" VALUES (118, 2);
INSERT INTO public."Contiene" VALUES (119, 2);
INSERT INTO public."Contiene" VALUES (120, 2);
INSERT INTO public."Contiene" VALUES (121, 2);
INSERT INTO public."Contiene" VALUES (122, 2);
INSERT INTO public."Contiene" VALUES (123, 2);
INSERT INTO public."Contiene" VALUES (124, 2);
INSERT INTO public."Contiene" VALUES (125, 2);
INSERT INTO public."Contiene" VALUES (126, 2);
INSERT INTO public."Contiene" VALUES (127, 2);
INSERT INTO public."Contiene" VALUES (128, 2);
INSERT INTO public."Contiene" VALUES (129, 2);
INSERT INTO public."Contiene" VALUES (130, 2);
INSERT INTO public."Contiene" VALUES (131, 2);
INSERT INTO public."Contiene" VALUES (132, 2);
INSERT INTO public."Contiene" VALUES (133, 2);
INSERT INTO public."Contiene" VALUES (134, 2);
INSERT INTO public."Contiene" VALUES (135, 2);
INSERT INTO public."Contiene" VALUES (136, 2);
INSERT INTO public."Contiene" VALUES (137, 2);
INSERT INTO public."Contiene" VALUES (138, 2);
INSERT INTO public."Contiene" VALUES (139, 2);
INSERT INTO public."Contiene" VALUES (140, 2);
INSERT INTO public."Contiene" VALUES (141, 2);
INSERT INTO public."Contiene" VALUES (142, 2);
INSERT INTO public."Contiene" VALUES (143, 2);
INSERT INTO public."Contiene" VALUES (144, 2);
INSERT INTO public."Contiene" VALUES (145, 2);
INSERT INTO public."Contiene" VALUES (146, 2);
INSERT INTO public."Contiene" VALUES (147, 2);
INSERT INTO public."Contiene" VALUES (148, 2);
INSERT INTO public."Contiene" VALUES (149, 2);
INSERT INTO public."Contiene" VALUES (150, 2);
INSERT INTO public."Contiene" VALUES (151, 2);
INSERT INTO public."Contiene" VALUES (152, 2);
INSERT INTO public."Contiene" VALUES (153, 2);
INSERT INTO public."Contiene" VALUES (154, 2);
INSERT INTO public."Contiene" VALUES (155, 2);
INSERT INTO public."Contiene" VALUES (156, 2);
INSERT INTO public."Contiene" VALUES (157, 2);
INSERT INTO public."Contiene" VALUES (158, 2);
INSERT INTO public."Contiene" VALUES (159, 2);
INSERT INTO public."Contiene" VALUES (160, 2);
INSERT INTO public."Contiene" VALUES (161, 2);
INSERT INTO public."Contiene" VALUES (162, 2);
INSERT INTO public."Contiene" VALUES (163, 2);
INSERT INTO public."Contiene" VALUES (164, 2);
INSERT INTO public."Contiene" VALUES (165, 2);
INSERT INTO public."Contiene" VALUES (166, 2);
INSERT INTO public."Contiene" VALUES (167, 2);
INSERT INTO public."Contiene" VALUES (168, 2);
INSERT INTO public."Contiene" VALUES (169, 2);
INSERT INTO public."Contiene" VALUES (170, 2);
INSERT INTO public."Contiene" VALUES (171, 2);
INSERT INTO public."Contiene" VALUES (172, 2);
INSERT INTO public."Contiene" VALUES (173, 2);
INSERT INTO public."Contiene" VALUES (174, 2);
INSERT INTO public."Contiene" VALUES (175, 2);
INSERT INTO public."Contiene" VALUES (1, 3);
INSERT INTO public."Contiene" VALUES (2, 3);
INSERT INTO public."Contiene" VALUES (3, 3);
INSERT INTO public."Contiene" VALUES (4, 3);
INSERT INTO public."Contiene" VALUES (5, 3);
INSERT INTO public."Contiene" VALUES (6, 3);
INSERT INTO public."Contiene" VALUES (7, 3);
INSERT INTO public."Contiene" VALUES (8, 3);
INSERT INTO public."Contiene" VALUES (9, 3);
INSERT INTO public."Contiene" VALUES (10, 3);
INSERT INTO public."Contiene" VALUES (11, 3);
INSERT INTO public."Contiene" VALUES (12, 3);
INSERT INTO public."Contiene" VALUES (13, 3);
INSERT INTO public."Contiene" VALUES (14, 3);
INSERT INTO public."Contiene" VALUES (15, 3);
INSERT INTO public."Contiene" VALUES (16, 3);
INSERT INTO public."Contiene" VALUES (17, 3);
INSERT INTO public."Contiene" VALUES (18, 3);
INSERT INTO public."Contiene" VALUES (19, 3);
INSERT INTO public."Contiene" VALUES (20, 3);
INSERT INTO public."Contiene" VALUES (21, 3);
INSERT INTO public."Contiene" VALUES (22, 3);
INSERT INTO public."Contiene" VALUES (23, 3);
INSERT INTO public."Contiene" VALUES (24, 3);
INSERT INTO public."Contiene" VALUES (25, 3);
INSERT INTO public."Contiene" VALUES (26, 3);
INSERT INTO public."Contiene" VALUES (27, 3);
INSERT INTO public."Contiene" VALUES (28, 3);
INSERT INTO public."Contiene" VALUES (29, 3);
INSERT INTO public."Contiene" VALUES (30, 3);
INSERT INTO public."Contiene" VALUES (31, 3);
INSERT INTO public."Contiene" VALUES (32, 3);
INSERT INTO public."Contiene" VALUES (33, 3);
INSERT INTO public."Contiene" VALUES (34, 3);
INSERT INTO public."Contiene" VALUES (35, 3);
INSERT INTO public."Contiene" VALUES (36, 3);
INSERT INTO public."Contiene" VALUES (37, 3);
INSERT INTO public."Contiene" VALUES (38, 3);
INSERT INTO public."Contiene" VALUES (39, 3);
INSERT INTO public."Contiene" VALUES (40, 3);
INSERT INTO public."Contiene" VALUES (41, 3);
INSERT INTO public."Contiene" VALUES (42, 3);
INSERT INTO public."Contiene" VALUES (43, 3);
INSERT INTO public."Contiene" VALUES (44, 3);
INSERT INTO public."Contiene" VALUES (45, 3);
INSERT INTO public."Contiene" VALUES (46, 3);
INSERT INTO public."Contiene" VALUES (47, 3);
INSERT INTO public."Contiene" VALUES (48, 3);
INSERT INTO public."Contiene" VALUES (49, 3);
INSERT INTO public."Contiene" VALUES (50, 3);
INSERT INTO public."Contiene" VALUES (51, 3);
INSERT INTO public."Contiene" VALUES (52, 3);
INSERT INTO public."Contiene" VALUES (53, 3);
INSERT INTO public."Contiene" VALUES (54, 3);
INSERT INTO public."Contiene" VALUES (55, 3);
INSERT INTO public."Contiene" VALUES (56, 3);
INSERT INTO public."Contiene" VALUES (57, 3);
INSERT INTO public."Contiene" VALUES (58, 3);
INSERT INTO public."Contiene" VALUES (59, 3);
INSERT INTO public."Contiene" VALUES (60, 3);
INSERT INTO public."Contiene" VALUES (61, 3);
INSERT INTO public."Contiene" VALUES (62, 3);
INSERT INTO public."Contiene" VALUES (63, 3);
INSERT INTO public."Contiene" VALUES (64, 3);
INSERT INTO public."Contiene" VALUES (65, 3);
INSERT INTO public."Contiene" VALUES (66, 3);
INSERT INTO public."Contiene" VALUES (67, 3);
INSERT INTO public."Contiene" VALUES (68, 3);
INSERT INTO public."Contiene" VALUES (69, 3);
INSERT INTO public."Contiene" VALUES (70, 3);
INSERT INTO public."Contiene" VALUES (71, 3);
INSERT INTO public."Contiene" VALUES (72, 3);
INSERT INTO public."Contiene" VALUES (73, 3);
INSERT INTO public."Contiene" VALUES (74, 3);
INSERT INTO public."Contiene" VALUES (75, 3);
INSERT INTO public."Contiene" VALUES (76, 3);
INSERT INTO public."Contiene" VALUES (77, 3);
INSERT INTO public."Contiene" VALUES (78, 3);
INSERT INTO public."Contiene" VALUES (79, 3);
INSERT INTO public."Contiene" VALUES (80, 3);
INSERT INTO public."Contiene" VALUES (81, 3);
INSERT INTO public."Contiene" VALUES (82, 3);
INSERT INTO public."Contiene" VALUES (83, 3);
INSERT INTO public."Contiene" VALUES (84, 3);
INSERT INTO public."Contiene" VALUES (85, 3);
INSERT INTO public."Contiene" VALUES (86, 3);
INSERT INTO public."Contiene" VALUES (87, 3);
INSERT INTO public."Contiene" VALUES (88, 3);
INSERT INTO public."Contiene" VALUES (89, 3);
INSERT INTO public."Contiene" VALUES (90, 3);
INSERT INTO public."Contiene" VALUES (91, 3);
INSERT INTO public."Contiene" VALUES (92, 3);
INSERT INTO public."Contiene" VALUES (93, 3);
INSERT INTO public."Contiene" VALUES (94, 3);
INSERT INTO public."Contiene" VALUES (95, 3);
INSERT INTO public."Contiene" VALUES (96, 3);
INSERT INTO public."Contiene" VALUES (97, 3);
INSERT INTO public."Contiene" VALUES (98, 3);
INSERT INTO public."Contiene" VALUES (99, 3);
INSERT INTO public."Contiene" VALUES (100, 3);
INSERT INTO public."Contiene" VALUES (101, 3);
INSERT INTO public."Contiene" VALUES (102, 3);
INSERT INTO public."Contiene" VALUES (103, 3);
INSERT INTO public."Contiene" VALUES (104, 3);
INSERT INTO public."Contiene" VALUES (105, 3);
INSERT INTO public."Contiene" VALUES (106, 3);
INSERT INTO public."Contiene" VALUES (107, 3);
INSERT INTO public."Contiene" VALUES (108, 3);
INSERT INTO public."Contiene" VALUES (109, 3);
INSERT INTO public."Contiene" VALUES (110, 3);
INSERT INTO public."Contiene" VALUES (111, 3);
INSERT INTO public."Contiene" VALUES (112, 3);
INSERT INTO public."Contiene" VALUES (113, 3);
INSERT INTO public."Contiene" VALUES (114, 3);
INSERT INTO public."Contiene" VALUES (115, 3);
INSERT INTO public."Contiene" VALUES (116, 3);
INSERT INTO public."Contiene" VALUES (117, 3);
INSERT INTO public."Contiene" VALUES (118, 3);
INSERT INTO public."Contiene" VALUES (119, 3);
INSERT INTO public."Contiene" VALUES (120, 3);
INSERT INTO public."Contiene" VALUES (121, 3);
INSERT INTO public."Contiene" VALUES (122, 3);
INSERT INTO public."Contiene" VALUES (123, 3);
INSERT INTO public."Contiene" VALUES (124, 3);
INSERT INTO public."Contiene" VALUES (125, 3);
INSERT INTO public."Contiene" VALUES (126, 3);
INSERT INTO public."Contiene" VALUES (127, 3);
INSERT INTO public."Contiene" VALUES (128, 3);
INSERT INTO public."Contiene" VALUES (129, 3);
INSERT INTO public."Contiene" VALUES (130, 3);
INSERT INTO public."Contiene" VALUES (131, 3);
INSERT INTO public."Contiene" VALUES (132, 3);
INSERT INTO public."Contiene" VALUES (133, 3);
INSERT INTO public."Contiene" VALUES (134, 3);
INSERT INTO public."Contiene" VALUES (135, 3);
INSERT INTO public."Contiene" VALUES (136, 3);
INSERT INTO public."Contiene" VALUES (137, 3);
INSERT INTO public."Contiene" VALUES (138, 3);
INSERT INTO public."Contiene" VALUES (139, 3);
INSERT INTO public."Contiene" VALUES (140, 3);
INSERT INTO public."Contiene" VALUES (141, 3);
INSERT INTO public."Contiene" VALUES (142, 3);
INSERT INTO public."Contiene" VALUES (143, 3);
INSERT INTO public."Contiene" VALUES (144, 3);
INSERT INTO public."Contiene" VALUES (145, 3);
INSERT INTO public."Contiene" VALUES (146, 3);
INSERT INTO public."Contiene" VALUES (147, 3);
INSERT INTO public."Contiene" VALUES (148, 3);
INSERT INTO public."Contiene" VALUES (149, 3);
INSERT INTO public."Contiene" VALUES (150, 3);
INSERT INTO public."Contiene" VALUES (1, 4);
INSERT INTO public."Contiene" VALUES (2, 4);
INSERT INTO public."Contiene" VALUES (3, 4);
INSERT INTO public."Contiene" VALUES (4, 4);
INSERT INTO public."Contiene" VALUES (5, 4);
INSERT INTO public."Contiene" VALUES (6, 4);
INSERT INTO public."Contiene" VALUES (7, 4);
INSERT INTO public."Contiene" VALUES (8, 4);
INSERT INTO public."Contiene" VALUES (9, 4);
INSERT INTO public."Contiene" VALUES (10, 4);
INSERT INTO public."Contiene" VALUES (11, 4);
INSERT INTO public."Contiene" VALUES (12, 4);
INSERT INTO public."Contiene" VALUES (13, 4);
INSERT INTO public."Contiene" VALUES (14, 4);
INSERT INTO public."Contiene" VALUES (15, 4);
INSERT INTO public."Contiene" VALUES (16, 4);
INSERT INTO public."Contiene" VALUES (17, 4);
INSERT INTO public."Contiene" VALUES (18, 4);
INSERT INTO public."Contiene" VALUES (19, 4);
INSERT INTO public."Contiene" VALUES (20, 4);
INSERT INTO public."Contiene" VALUES (21, 4);
INSERT INTO public."Contiene" VALUES (22, 4);
INSERT INTO public."Contiene" VALUES (23, 4);
INSERT INTO public."Contiene" VALUES (24, 4);
INSERT INTO public."Contiene" VALUES (25, 4);
INSERT INTO public."Contiene" VALUES (26, 4);
INSERT INTO public."Contiene" VALUES (27, 4);
INSERT INTO public."Contiene" VALUES (28, 4);
INSERT INTO public."Contiene" VALUES (29, 4);
INSERT INTO public."Contiene" VALUES (30, 4);
INSERT INTO public."Contiene" VALUES (31, 4);
INSERT INTO public."Contiene" VALUES (32, 4);
INSERT INTO public."Contiene" VALUES (33, 4);
INSERT INTO public."Contiene" VALUES (34, 4);
INSERT INTO public."Contiene" VALUES (35, 4);
INSERT INTO public."Contiene" VALUES (36, 4);
INSERT INTO public."Contiene" VALUES (37, 4);
INSERT INTO public."Contiene" VALUES (38, 4);
INSERT INTO public."Contiene" VALUES (39, 4);
INSERT INTO public."Contiene" VALUES (40, 4);
INSERT INTO public."Contiene" VALUES (41, 4);
INSERT INTO public."Contiene" VALUES (42, 4);
INSERT INTO public."Contiene" VALUES (43, 4);
INSERT INTO public."Contiene" VALUES (44, 4);
INSERT INTO public."Contiene" VALUES (45, 4);
INSERT INTO public."Contiene" VALUES (46, 4);
INSERT INTO public."Contiene" VALUES (47, 4);
INSERT INTO public."Contiene" VALUES (48, 4);
INSERT INTO public."Contiene" VALUES (49, 4);
INSERT INTO public."Contiene" VALUES (50, 4);
INSERT INTO public."Contiene" VALUES (51, 4);
INSERT INTO public."Contiene" VALUES (52, 4);
INSERT INTO public."Contiene" VALUES (53, 4);
INSERT INTO public."Contiene" VALUES (54, 4);
INSERT INTO public."Contiene" VALUES (55, 4);
INSERT INTO public."Contiene" VALUES (56, 4);
INSERT INTO public."Contiene" VALUES (57, 4);
INSERT INTO public."Contiene" VALUES (58, 4);
INSERT INTO public."Contiene" VALUES (59, 4);
INSERT INTO public."Contiene" VALUES (60, 4);
INSERT INTO public."Contiene" VALUES (61, 4);
INSERT INTO public."Contiene" VALUES (62, 4);
INSERT INTO public."Contiene" VALUES (63, 4);
INSERT INTO public."Contiene" VALUES (64, 4);
INSERT INTO public."Contiene" VALUES (65, 4);
INSERT INTO public."Contiene" VALUES (66, 4);
INSERT INTO public."Contiene" VALUES (67, 4);
INSERT INTO public."Contiene" VALUES (68, 4);
INSERT INTO public."Contiene" VALUES (69, 4);
INSERT INTO public."Contiene" VALUES (70, 4);
INSERT INTO public."Contiene" VALUES (71, 4);
INSERT INTO public."Contiene" VALUES (72, 4);
INSERT INTO public."Contiene" VALUES (73, 4);
INSERT INTO public."Contiene" VALUES (74, 4);
INSERT INTO public."Contiene" VALUES (75, 4);
INSERT INTO public."Contiene" VALUES (76, 4);
INSERT INTO public."Contiene" VALUES (77, 4);
INSERT INTO public."Contiene" VALUES (78, 4);
INSERT INTO public."Contiene" VALUES (79, 4);
INSERT INTO public."Contiene" VALUES (80, 4);
INSERT INTO public."Contiene" VALUES (81, 4);
INSERT INTO public."Contiene" VALUES (82, 4);
INSERT INTO public."Contiene" VALUES (83, 4);
INSERT INTO public."Contiene" VALUES (84, 4);
INSERT INTO public."Contiene" VALUES (85, 4);
INSERT INTO public."Contiene" VALUES (86, 4);
INSERT INTO public."Contiene" VALUES (87, 4);
INSERT INTO public."Contiene" VALUES (88, 4);
INSERT INTO public."Contiene" VALUES (89, 4);
INSERT INTO public."Contiene" VALUES (90, 4);
INSERT INTO public."Contiene" VALUES (91, 4);
INSERT INTO public."Contiene" VALUES (92, 4);
INSERT INTO public."Contiene" VALUES (93, 4);
INSERT INTO public."Contiene" VALUES (94, 4);
INSERT INTO public."Contiene" VALUES (95, 4);
INSERT INTO public."Contiene" VALUES (96, 4);
INSERT INTO public."Contiene" VALUES (97, 4);
INSERT INTO public."Contiene" VALUES (98, 4);
INSERT INTO public."Contiene" VALUES (99, 4);
INSERT INTO public."Contiene" VALUES (100, 4);
INSERT INTO public."Contiene" VALUES (101, 4);
INSERT INTO public."Contiene" VALUES (102, 4);
INSERT INTO public."Contiene" VALUES (103, 4);
INSERT INTO public."Contiene" VALUES (104, 4);
INSERT INTO public."Contiene" VALUES (105, 4);
INSERT INTO public."Contiene" VALUES (106, 4);
INSERT INTO public."Contiene" VALUES (107, 4);
INSERT INTO public."Contiene" VALUES (108, 4);
INSERT INTO public."Contiene" VALUES (109, 4);
INSERT INTO public."Contiene" VALUES (110, 4);
INSERT INTO public."Contiene" VALUES (111, 4);
INSERT INTO public."Contiene" VALUES (112, 4);
INSERT INTO public."Contiene" VALUES (113, 4);
INSERT INTO public."Contiene" VALUES (114, 4);
INSERT INTO public."Contiene" VALUES (115, 4);
INSERT INTO public."Contiene" VALUES (116, 4);
INSERT INTO public."Contiene" VALUES (117, 4);
INSERT INTO public."Contiene" VALUES (118, 4);
INSERT INTO public."Contiene" VALUES (119, 4);
INSERT INTO public."Contiene" VALUES (120, 4);
INSERT INTO public."Contiene" VALUES (121, 4);
INSERT INTO public."Contiene" VALUES (122, 4);
INSERT INTO public."Contiene" VALUES (123, 4);
INSERT INTO public."Contiene" VALUES (124, 4);
INSERT INTO public."Contiene" VALUES (125, 4);
INSERT INTO public."Contiene" VALUES (1, 5);
INSERT INTO public."Contiene" VALUES (2, 5);
INSERT INTO public."Contiene" VALUES (3, 5);
INSERT INTO public."Contiene" VALUES (4, 5);
INSERT INTO public."Contiene" VALUES (5, 5);
INSERT INTO public."Contiene" VALUES (6, 5);
INSERT INTO public."Contiene" VALUES (7, 5);
INSERT INTO public."Contiene" VALUES (8, 5);
INSERT INTO public."Contiene" VALUES (9, 5);
INSERT INTO public."Contiene" VALUES (10, 5);
INSERT INTO public."Contiene" VALUES (11, 5);
INSERT INTO public."Contiene" VALUES (12, 5);
INSERT INTO public."Contiene" VALUES (13, 5);
INSERT INTO public."Contiene" VALUES (14, 5);
INSERT INTO public."Contiene" VALUES (15, 5);
INSERT INTO public."Contiene" VALUES (16, 5);
INSERT INTO public."Contiene" VALUES (17, 5);
INSERT INTO public."Contiene" VALUES (18, 5);
INSERT INTO public."Contiene" VALUES (19, 5);
INSERT INTO public."Contiene" VALUES (20, 5);
INSERT INTO public."Contiene" VALUES (21, 5);
INSERT INTO public."Contiene" VALUES (22, 5);
INSERT INTO public."Contiene" VALUES (23, 5);
INSERT INTO public."Contiene" VALUES (24, 5);
INSERT INTO public."Contiene" VALUES (25, 5);
INSERT INTO public."Contiene" VALUES (26, 5);
INSERT INTO public."Contiene" VALUES (27, 5);
INSERT INTO public."Contiene" VALUES (28, 5);
INSERT INTO public."Contiene" VALUES (29, 5);
INSERT INTO public."Contiene" VALUES (30, 5);
INSERT INTO public."Contiene" VALUES (31, 5);
INSERT INTO public."Contiene" VALUES (32, 5);
INSERT INTO public."Contiene" VALUES (33, 5);
INSERT INTO public."Contiene" VALUES (34, 5);
INSERT INTO public."Contiene" VALUES (35, 5);
INSERT INTO public."Contiene" VALUES (36, 5);
INSERT INTO public."Contiene" VALUES (37, 5);
INSERT INTO public."Contiene" VALUES (38, 5);
INSERT INTO public."Contiene" VALUES (39, 5);
INSERT INTO public."Contiene" VALUES (40, 5);
INSERT INTO public."Contiene" VALUES (41, 5);
INSERT INTO public."Contiene" VALUES (42, 5);
INSERT INTO public."Contiene" VALUES (43, 5);
INSERT INTO public."Contiene" VALUES (44, 5);
INSERT INTO public."Contiene" VALUES (45, 5);
INSERT INTO public."Contiene" VALUES (46, 5);
INSERT INTO public."Contiene" VALUES (47, 5);
INSERT INTO public."Contiene" VALUES (48, 5);
INSERT INTO public."Contiene" VALUES (49, 5);
INSERT INTO public."Contiene" VALUES (50, 5);
INSERT INTO public."Contiene" VALUES (51, 5);
INSERT INTO public."Contiene" VALUES (52, 5);
INSERT INTO public."Contiene" VALUES (53, 5);
INSERT INTO public."Contiene" VALUES (54, 5);
INSERT INTO public."Contiene" VALUES (55, 5);
INSERT INTO public."Contiene" VALUES (56, 5);
INSERT INTO public."Contiene" VALUES (57, 5);
INSERT INTO public."Contiene" VALUES (58, 5);
INSERT INTO public."Contiene" VALUES (59, 5);
INSERT INTO public."Contiene" VALUES (60, 5);
INSERT INTO public."Contiene" VALUES (61, 5);
INSERT INTO public."Contiene" VALUES (62, 5);
INSERT INTO public."Contiene" VALUES (63, 5);
INSERT INTO public."Contiene" VALUES (64, 5);
INSERT INTO public."Contiene" VALUES (65, 5);
INSERT INTO public."Contiene" VALUES (66, 5);
INSERT INTO public."Contiene" VALUES (67, 5);
INSERT INTO public."Contiene" VALUES (68, 5);
INSERT INTO public."Contiene" VALUES (69, 5);
INSERT INTO public."Contiene" VALUES (70, 5);
INSERT INTO public."Contiene" VALUES (71, 5);
INSERT INTO public."Contiene" VALUES (72, 5);
INSERT INTO public."Contiene" VALUES (73, 5);
INSERT INTO public."Contiene" VALUES (74, 5);
INSERT INTO public."Contiene" VALUES (75, 5);
INSERT INTO public."Contiene" VALUES (76, 5);
INSERT INTO public."Contiene" VALUES (77, 5);
INSERT INTO public."Contiene" VALUES (78, 5);
INSERT INTO public."Contiene" VALUES (79, 5);
INSERT INTO public."Contiene" VALUES (80, 5);
INSERT INTO public."Contiene" VALUES (81, 5);
INSERT INTO public."Contiene" VALUES (82, 5);
INSERT INTO public."Contiene" VALUES (83, 5);
INSERT INTO public."Contiene" VALUES (84, 5);
INSERT INTO public."Contiene" VALUES (85, 5);
INSERT INTO public."Contiene" VALUES (86, 5);
INSERT INTO public."Contiene" VALUES (87, 5);
INSERT INTO public."Contiene" VALUES (88, 5);
INSERT INTO public."Contiene" VALUES (89, 5);
INSERT INTO public."Contiene" VALUES (90, 5);
INSERT INTO public."Contiene" VALUES (91, 5);
INSERT INTO public."Contiene" VALUES (92, 5);
INSERT INTO public."Contiene" VALUES (93, 5);
INSERT INTO public."Contiene" VALUES (94, 5);
INSERT INTO public."Contiene" VALUES (95, 5);
INSERT INTO public."Contiene" VALUES (96, 5);
INSERT INTO public."Contiene" VALUES (97, 5);
INSERT INTO public."Contiene" VALUES (98, 5);
INSERT INTO public."Contiene" VALUES (99, 5);
INSERT INTO public."Contiene" VALUES (100, 5);
INSERT INTO public."Contiene" VALUES (1, 6);
INSERT INTO public."Contiene" VALUES (2, 6);
INSERT INTO public."Contiene" VALUES (3, 6);
INSERT INTO public."Contiene" VALUES (4, 6);
INSERT INTO public."Contiene" VALUES (5, 6);
INSERT INTO public."Contiene" VALUES (6, 6);
INSERT INTO public."Contiene" VALUES (7, 6);
INSERT INTO public."Contiene" VALUES (8, 6);
INSERT INTO public."Contiene" VALUES (9, 6);
INSERT INTO public."Contiene" VALUES (10, 6);
INSERT INTO public."Contiene" VALUES (11, 6);
INSERT INTO public."Contiene" VALUES (12, 6);
INSERT INTO public."Contiene" VALUES (13, 6);
INSERT INTO public."Contiene" VALUES (14, 6);
INSERT INTO public."Contiene" VALUES (15, 6);
INSERT INTO public."Contiene" VALUES (16, 6);
INSERT INTO public."Contiene" VALUES (17, 6);
INSERT INTO public."Contiene" VALUES (18, 6);
INSERT INTO public."Contiene" VALUES (19, 6);
INSERT INTO public."Contiene" VALUES (20, 6);
INSERT INTO public."Contiene" VALUES (21, 6);
INSERT INTO public."Contiene" VALUES (22, 6);
INSERT INTO public."Contiene" VALUES (23, 6);
INSERT INTO public."Contiene" VALUES (24, 6);
INSERT INTO public."Contiene" VALUES (25, 6);
INSERT INTO public."Contiene" VALUES (26, 6);
INSERT INTO public."Contiene" VALUES (27, 6);
INSERT INTO public."Contiene" VALUES (28, 6);
INSERT INTO public."Contiene" VALUES (29, 6);
INSERT INTO public."Contiene" VALUES (30, 6);
INSERT INTO public."Contiene" VALUES (31, 6);
INSERT INTO public."Contiene" VALUES (32, 6);
INSERT INTO public."Contiene" VALUES (33, 6);
INSERT INTO public."Contiene" VALUES (34, 6);
INSERT INTO public."Contiene" VALUES (35, 6);
INSERT INTO public."Contiene" VALUES (36, 6);
INSERT INTO public."Contiene" VALUES (37, 6);
INSERT INTO public."Contiene" VALUES (38, 6);
INSERT INTO public."Contiene" VALUES (39, 6);
INSERT INTO public."Contiene" VALUES (40, 6);
INSERT INTO public."Contiene" VALUES (41, 6);
INSERT INTO public."Contiene" VALUES (42, 6);
INSERT INTO public."Contiene" VALUES (43, 6);
INSERT INTO public."Contiene" VALUES (44, 6);
INSERT INTO public."Contiene" VALUES (45, 6);
INSERT INTO public."Contiene" VALUES (46, 6);
INSERT INTO public."Contiene" VALUES (47, 6);
INSERT INTO public."Contiene" VALUES (48, 6);
INSERT INTO public."Contiene" VALUES (49, 6);
INSERT INTO public."Contiene" VALUES (50, 6);
INSERT INTO public."Contiene" VALUES (51, 6);
INSERT INTO public."Contiene" VALUES (52, 6);
INSERT INTO public."Contiene" VALUES (53, 6);
INSERT INTO public."Contiene" VALUES (54, 6);
INSERT INTO public."Contiene" VALUES (55, 6);
INSERT INTO public."Contiene" VALUES (56, 6);
INSERT INTO public."Contiene" VALUES (57, 6);
INSERT INTO public."Contiene" VALUES (58, 6);
INSERT INTO public."Contiene" VALUES (59, 6);
INSERT INTO public."Contiene" VALUES (60, 6);
INSERT INTO public."Contiene" VALUES (61, 6);
INSERT INTO public."Contiene" VALUES (62, 6);
INSERT INTO public."Contiene" VALUES (63, 6);
INSERT INTO public."Contiene" VALUES (64, 6);
INSERT INTO public."Contiene" VALUES (65, 6);
INSERT INTO public."Contiene" VALUES (66, 6);
INSERT INTO public."Contiene" VALUES (67, 6);
INSERT INTO public."Contiene" VALUES (68, 6);
INSERT INTO public."Contiene" VALUES (69, 6);
INSERT INTO public."Contiene" VALUES (70, 6);
INSERT INTO public."Contiene" VALUES (71, 6);
INSERT INTO public."Contiene" VALUES (72, 6);
INSERT INTO public."Contiene" VALUES (73, 6);
INSERT INTO public."Contiene" VALUES (74, 6);
INSERT INTO public."Contiene" VALUES (75, 6);
INSERT INTO public."Contiene" VALUES (1, 7);
INSERT INTO public."Contiene" VALUES (2, 7);
INSERT INTO public."Contiene" VALUES (3, 7);
INSERT INTO public."Contiene" VALUES (4, 7);
INSERT INTO public."Contiene" VALUES (5, 7);
INSERT INTO public."Contiene" VALUES (6, 7);
INSERT INTO public."Contiene" VALUES (7, 7);
INSERT INTO public."Contiene" VALUES (8, 7);
INSERT INTO public."Contiene" VALUES (9, 7);
INSERT INTO public."Contiene" VALUES (10, 7);
INSERT INTO public."Contiene" VALUES (11, 7);
INSERT INTO public."Contiene" VALUES (12, 7);
INSERT INTO public."Contiene" VALUES (13, 7);
INSERT INTO public."Contiene" VALUES (14, 7);
INSERT INTO public."Contiene" VALUES (15, 7);
INSERT INTO public."Contiene" VALUES (16, 7);
INSERT INTO public."Contiene" VALUES (17, 7);
INSERT INTO public."Contiene" VALUES (18, 7);
INSERT INTO public."Contiene" VALUES (19, 7);
INSERT INTO public."Contiene" VALUES (20, 7);
INSERT INTO public."Contiene" VALUES (21, 7);
INSERT INTO public."Contiene" VALUES (22, 7);
INSERT INTO public."Contiene" VALUES (23, 7);
INSERT INTO public."Contiene" VALUES (24, 7);
INSERT INTO public."Contiene" VALUES (25, 7);
INSERT INTO public."Contiene" VALUES (26, 7);
INSERT INTO public."Contiene" VALUES (27, 7);
INSERT INTO public."Contiene" VALUES (28, 7);
INSERT INTO public."Contiene" VALUES (29, 7);
INSERT INTO public."Contiene" VALUES (30, 7);
INSERT INTO public."Contiene" VALUES (31, 7);
INSERT INTO public."Contiene" VALUES (32, 7);
INSERT INTO public."Contiene" VALUES (33, 7);
INSERT INTO public."Contiene" VALUES (34, 7);
INSERT INTO public."Contiene" VALUES (35, 7);
INSERT INTO public."Contiene" VALUES (36, 7);
INSERT INTO public."Contiene" VALUES (37, 7);
INSERT INTO public."Contiene" VALUES (38, 7);
INSERT INTO public."Contiene" VALUES (39, 7);
INSERT INTO public."Contiene" VALUES (40, 7);
INSERT INTO public."Contiene" VALUES (41, 7);
INSERT INTO public."Contiene" VALUES (42, 7);
INSERT INTO public."Contiene" VALUES (43, 7);
INSERT INTO public."Contiene" VALUES (44, 7);
INSERT INTO public."Contiene" VALUES (45, 7);
INSERT INTO public."Contiene" VALUES (46, 7);
INSERT INTO public."Contiene" VALUES (47, 7);
INSERT INTO public."Contiene" VALUES (48, 7);
INSERT INTO public."Contiene" VALUES (49, 7);
INSERT INTO public."Contiene" VALUES (50, 7);
INSERT INTO public."Contiene" VALUES (1, 8);
INSERT INTO public."Contiene" VALUES (2, 8);
INSERT INTO public."Contiene" VALUES (3, 8);
INSERT INTO public."Contiene" VALUES (4, 8);
INSERT INTO public."Contiene" VALUES (5, 8);
INSERT INTO public."Contiene" VALUES (6, 8);
INSERT INTO public."Contiene" VALUES (7, 8);
INSERT INTO public."Contiene" VALUES (8, 8);
INSERT INTO public."Contiene" VALUES (9, 8);
INSERT INTO public."Contiene" VALUES (10, 8);
INSERT INTO public."Contiene" VALUES (11, 8);
INSERT INTO public."Contiene" VALUES (12, 8);
INSERT INTO public."Contiene" VALUES (13, 8);
INSERT INTO public."Contiene" VALUES (14, 8);
INSERT INTO public."Contiene" VALUES (15, 8);
INSERT INTO public."Contiene" VALUES (16, 8);
INSERT INTO public."Contiene" VALUES (17, 8);
INSERT INTO public."Contiene" VALUES (18, 8);
INSERT INTO public."Contiene" VALUES (19, 8);
INSERT INTO public."Contiene" VALUES (20, 8);
INSERT INTO public."Contiene" VALUES (21, 8);
INSERT INTO public."Contiene" VALUES (22, 8);
INSERT INTO public."Contiene" VALUES (23, 8);
INSERT INTO public."Contiene" VALUES (24, 8);
INSERT INTO public."Contiene" VALUES (25, 8);
INSERT INTO public."Contiene" VALUES (26, 8);
INSERT INTO public."Contiene" VALUES (27, 8);
INSERT INTO public."Contiene" VALUES (28, 8);
INSERT INTO public."Contiene" VALUES (29, 8);
INSERT INTO public."Contiene" VALUES (30, 8);
INSERT INTO public."Contiene" VALUES (31, 8);
INSERT INTO public."Contiene" VALUES (32, 8);
INSERT INTO public."Contiene" VALUES (33, 8);
INSERT INTO public."Contiene" VALUES (34, 8);
INSERT INTO public."Contiene" VALUES (35, 8);
INSERT INTO public."Contiene" VALUES (36, 8);
INSERT INTO public."Contiene" VALUES (37, 8);
INSERT INTO public."Contiene" VALUES (38, 8);
INSERT INTO public."Contiene" VALUES (39, 8);
INSERT INTO public."Contiene" VALUES (40, 8);
INSERT INTO public."Contiene" VALUES (41, 8);
INSERT INTO public."Contiene" VALUES (42, 8);
INSERT INTO public."Contiene" VALUES (43, 8);
INSERT INTO public."Contiene" VALUES (44, 8);
INSERT INTO public."Contiene" VALUES (45, 8);
INSERT INTO public."Contiene" VALUES (46, 8);
INSERT INTO public."Contiene" VALUES (47, 8);
INSERT INTO public."Contiene" VALUES (48, 8);
INSERT INTO public."Contiene" VALUES (49, 8);
INSERT INTO public."Contiene" VALUES (50, 8);
INSERT INTO public."Contiene" VALUES (1, 9);
INSERT INTO public."Contiene" VALUES (2, 9);
INSERT INTO public."Contiene" VALUES (3, 9);
INSERT INTO public."Contiene" VALUES (4, 9);
INSERT INTO public."Contiene" VALUES (5, 9);
INSERT INTO public."Contiene" VALUES (6, 9);
INSERT INTO public."Contiene" VALUES (7, 9);
INSERT INTO public."Contiene" VALUES (8, 9);
INSERT INTO public."Contiene" VALUES (9, 9);
INSERT INTO public."Contiene" VALUES (10, 9);
INSERT INTO public."Contiene" VALUES (11, 9);
INSERT INTO public."Contiene" VALUES (12, 9);
INSERT INTO public."Contiene" VALUES (13, 9);
INSERT INTO public."Contiene" VALUES (14, 9);
INSERT INTO public."Contiene" VALUES (15, 9);
INSERT INTO public."Contiene" VALUES (16, 9);
INSERT INTO public."Contiene" VALUES (17, 9);
INSERT INTO public."Contiene" VALUES (18, 9);
INSERT INTO public."Contiene" VALUES (19, 9);
INSERT INTO public."Contiene" VALUES (20, 9);
INSERT INTO public."Contiene" VALUES (21, 9);
INSERT INTO public."Contiene" VALUES (22, 9);
INSERT INTO public."Contiene" VALUES (23, 9);
INSERT INTO public."Contiene" VALUES (24, 9);
INSERT INTO public."Contiene" VALUES (25, 9);
INSERT INTO public."Contiene" VALUES (26, 9);
INSERT INTO public."Contiene" VALUES (27, 9);
INSERT INTO public."Contiene" VALUES (28, 9);
INSERT INTO public."Contiene" VALUES (29, 9);
INSERT INTO public."Contiene" VALUES (30, 9);
INSERT INTO public."Contiene" VALUES (31, 9);
INSERT INTO public."Contiene" VALUES (32, 9);
INSERT INTO public."Contiene" VALUES (33, 9);
INSERT INTO public."Contiene" VALUES (34, 9);
INSERT INTO public."Contiene" VALUES (35, 9);
INSERT INTO public."Contiene" VALUES (36, 9);
INSERT INTO public."Contiene" VALUES (37, 9);
INSERT INTO public."Contiene" VALUES (38, 9);
INSERT INTO public."Contiene" VALUES (39, 9);
INSERT INTO public."Contiene" VALUES (40, 9);
INSERT INTO public."Contiene" VALUES (41, 9);
INSERT INTO public."Contiene" VALUES (42, 9);
INSERT INTO public."Contiene" VALUES (43, 9);
INSERT INTO public."Contiene" VALUES (44, 9);
INSERT INTO public."Contiene" VALUES (45, 9);
INSERT INTO public."Contiene" VALUES (46, 9);
INSERT INTO public."Contiene" VALUES (47, 9);
INSERT INTO public."Contiene" VALUES (48, 9);
INSERT INTO public."Contiene" VALUES (49, 9);
INSERT INTO public."Contiene" VALUES (50, 9);
INSERT INTO public."Contiene" VALUES (51, 9);
INSERT INTO public."Contiene" VALUES (52, 9);
INSERT INTO public."Contiene" VALUES (53, 9);
INSERT INTO public."Contiene" VALUES (54, 9);
INSERT INTO public."Contiene" VALUES (55, 9);
INSERT INTO public."Contiene" VALUES (56, 9);
INSERT INTO public."Contiene" VALUES (57, 9);
INSERT INTO public."Contiene" VALUES (58, 9);
INSERT INTO public."Contiene" VALUES (59, 9);
INSERT INTO public."Contiene" VALUES (60, 9);
INSERT INTO public."Contiene" VALUES (61, 9);
INSERT INTO public."Contiene" VALUES (62, 9);
INSERT INTO public."Contiene" VALUES (63, 9);
INSERT INTO public."Contiene" VALUES (64, 9);
INSERT INTO public."Contiene" VALUES (65, 9);
INSERT INTO public."Contiene" VALUES (66, 9);
INSERT INTO public."Contiene" VALUES (67, 9);
INSERT INTO public."Contiene" VALUES (68, 9);
INSERT INTO public."Contiene" VALUES (69, 9);
INSERT INTO public."Contiene" VALUES (70, 9);
INSERT INTO public."Contiene" VALUES (71, 9);
INSERT INTO public."Contiene" VALUES (72, 9);
INSERT INTO public."Contiene" VALUES (73, 9);
INSERT INTO public."Contiene" VALUES (74, 9);
INSERT INTO public."Contiene" VALUES (75, 9);
INSERT INTO public."Contiene" VALUES (76, 9);
INSERT INTO public."Contiene" VALUES (77, 9);
INSERT INTO public."Contiene" VALUES (78, 9);
INSERT INTO public."Contiene" VALUES (79, 9);
INSERT INTO public."Contiene" VALUES (80, 9);
INSERT INTO public."Contiene" VALUES (81, 9);
INSERT INTO public."Contiene" VALUES (82, 9);
INSERT INTO public."Contiene" VALUES (83, 9);
INSERT INTO public."Contiene" VALUES (84, 9);
INSERT INTO public."Contiene" VALUES (85, 9);
INSERT INTO public."Contiene" VALUES (86, 9);
INSERT INTO public."Contiene" VALUES (87, 9);
INSERT INTO public."Contiene" VALUES (88, 9);
INSERT INTO public."Contiene" VALUES (89, 9);
INSERT INTO public."Contiene" VALUES (90, 9);
INSERT INTO public."Contiene" VALUES (91, 9);
INSERT INTO public."Contiene" VALUES (92, 9);
INSERT INTO public."Contiene" VALUES (93, 9);
INSERT INTO public."Contiene" VALUES (94, 9);
INSERT INTO public."Contiene" VALUES (95, 9);
INSERT INTO public."Contiene" VALUES (96, 9);
INSERT INTO public."Contiene" VALUES (97, 9);
INSERT INTO public."Contiene" VALUES (98, 9);
INSERT INTO public."Contiene" VALUES (99, 9);
INSERT INTO public."Contiene" VALUES (100, 9);
INSERT INTO public."Contiene" VALUES (1, 10);
INSERT INTO public."Contiene" VALUES (2, 10);
INSERT INTO public."Contiene" VALUES (3, 10);
INSERT INTO public."Contiene" VALUES (4, 10);
INSERT INTO public."Contiene" VALUES (5, 10);
INSERT INTO public."Contiene" VALUES (6, 10);
INSERT INTO public."Contiene" VALUES (7, 10);
INSERT INTO public."Contiene" VALUES (8, 10);
INSERT INTO public."Contiene" VALUES (9, 10);
INSERT INTO public."Contiene" VALUES (10, 10);
INSERT INTO public."Contiene" VALUES (11, 10);
INSERT INTO public."Contiene" VALUES (12, 10);
INSERT INTO public."Contiene" VALUES (13, 10);
INSERT INTO public."Contiene" VALUES (14, 10);
INSERT INTO public."Contiene" VALUES (15, 10);
INSERT INTO public."Contiene" VALUES (16, 10);
INSERT INTO public."Contiene" VALUES (17, 10);
INSERT INTO public."Contiene" VALUES (18, 10);
INSERT INTO public."Contiene" VALUES (19, 10);
INSERT INTO public."Contiene" VALUES (20, 10);
INSERT INTO public."Contiene" VALUES (21, 10);
INSERT INTO public."Contiene" VALUES (22, 10);
INSERT INTO public."Contiene" VALUES (23, 10);
INSERT INTO public."Contiene" VALUES (24, 10);
INSERT INTO public."Contiene" VALUES (25, 10);
INSERT INTO public."Contiene" VALUES (26, 10);
INSERT INTO public."Contiene" VALUES (27, 10);
INSERT INTO public."Contiene" VALUES (28, 10);
INSERT INTO public."Contiene" VALUES (29, 10);
INSERT INTO public."Contiene" VALUES (30, 10);
INSERT INTO public."Contiene" VALUES (31, 10);
INSERT INTO public."Contiene" VALUES (32, 10);
INSERT INTO public."Contiene" VALUES (33, 10);
INSERT INTO public."Contiene" VALUES (34, 10);
INSERT INTO public."Contiene" VALUES (35, 10);
INSERT INTO public."Contiene" VALUES (36, 10);
INSERT INTO public."Contiene" VALUES (37, 10);
INSERT INTO public."Contiene" VALUES (38, 10);
INSERT INTO public."Contiene" VALUES (39, 10);
INSERT INTO public."Contiene" VALUES (40, 10);
INSERT INTO public."Contiene" VALUES (41, 10);
INSERT INTO public."Contiene" VALUES (42, 10);
INSERT INTO public."Contiene" VALUES (43, 10);
INSERT INTO public."Contiene" VALUES (44, 10);
INSERT INTO public."Contiene" VALUES (45, 10);
INSERT INTO public."Contiene" VALUES (46, 10);
INSERT INTO public."Contiene" VALUES (47, 10);
INSERT INTO public."Contiene" VALUES (48, 10);
INSERT INTO public."Contiene" VALUES (49, 10);
INSERT INTO public."Contiene" VALUES (50, 10);
INSERT INTO public."Contiene" VALUES (51, 10);
INSERT INTO public."Contiene" VALUES (52, 10);
INSERT INTO public."Contiene" VALUES (53, 10);
INSERT INTO public."Contiene" VALUES (54, 10);
INSERT INTO public."Contiene" VALUES (55, 10);
INSERT INTO public."Contiene" VALUES (56, 10);
INSERT INTO public."Contiene" VALUES (57, 10);
INSERT INTO public."Contiene" VALUES (58, 10);
INSERT INTO public."Contiene" VALUES (59, 10);
INSERT INTO public."Contiene" VALUES (60, 10);
INSERT INTO public."Contiene" VALUES (61, 10);
INSERT INTO public."Contiene" VALUES (62, 10);
INSERT INTO public."Contiene" VALUES (63, 10);
INSERT INTO public."Contiene" VALUES (64, 10);
INSERT INTO public."Contiene" VALUES (65, 10);
INSERT INTO public."Contiene" VALUES (66, 10);
INSERT INTO public."Contiene" VALUES (67, 10);
INSERT INTO public."Contiene" VALUES (68, 10);
INSERT INTO public."Contiene" VALUES (69, 10);
INSERT INTO public."Contiene" VALUES (70, 10);
INSERT INTO public."Contiene" VALUES (71, 10);
INSERT INTO public."Contiene" VALUES (72, 10);
INSERT INTO public."Contiene" VALUES (73, 10);
INSERT INTO public."Contiene" VALUES (74, 10);
INSERT INTO public."Contiene" VALUES (75, 10);
INSERT INTO public."Contiene" VALUES (76, 10);
INSERT INTO public."Contiene" VALUES (77, 10);
INSERT INTO public."Contiene" VALUES (78, 10);
INSERT INTO public."Contiene" VALUES (79, 10);
INSERT INTO public."Contiene" VALUES (80, 10);
INSERT INTO public."Contiene" VALUES (81, 10);
INSERT INTO public."Contiene" VALUES (82, 10);
INSERT INTO public."Contiene" VALUES (83, 10);
INSERT INTO public."Contiene" VALUES (84, 10);
INSERT INTO public."Contiene" VALUES (85, 10);
INSERT INTO public."Contiene" VALUES (86, 10);
INSERT INTO public."Contiene" VALUES (87, 10);
INSERT INTO public."Contiene" VALUES (88, 10);
INSERT INTO public."Contiene" VALUES (89, 10);
INSERT INTO public."Contiene" VALUES (90, 10);
INSERT INTO public."Contiene" VALUES (91, 10);
INSERT INTO public."Contiene" VALUES (92, 10);
INSERT INTO public."Contiene" VALUES (93, 10);
INSERT INTO public."Contiene" VALUES (94, 10);
INSERT INTO public."Contiene" VALUES (95, 10);
INSERT INTO public."Contiene" VALUES (96, 10);
INSERT INTO public."Contiene" VALUES (97, 10);
INSERT INTO public."Contiene" VALUES (98, 10);
INSERT INTO public."Contiene" VALUES (99, 10);
INSERT INTO public."Contiene" VALUES (100, 10);
INSERT INTO public."Contiene" VALUES (101, 10);
INSERT INTO public."Contiene" VALUES (102, 10);
INSERT INTO public."Contiene" VALUES (103, 10);
INSERT INTO public."Contiene" VALUES (104, 10);
INSERT INTO public."Contiene" VALUES (105, 10);
INSERT INTO public."Contiene" VALUES (106, 10);
INSERT INTO public."Contiene" VALUES (107, 10);
INSERT INTO public."Contiene" VALUES (108, 10);
INSERT INTO public."Contiene" VALUES (109, 10);
INSERT INTO public."Contiene" VALUES (110, 10);
INSERT INTO public."Contiene" VALUES (111, 10);
INSERT INTO public."Contiene" VALUES (112, 10);
INSERT INTO public."Contiene" VALUES (113, 10);
INSERT INTO public."Contiene" VALUES (114, 10);
INSERT INTO public."Contiene" VALUES (115, 10);
INSERT INTO public."Contiene" VALUES (116, 10);
INSERT INTO public."Contiene" VALUES (117, 10);
INSERT INTO public."Contiene" VALUES (118, 10);
INSERT INTO public."Contiene" VALUES (119, 10);
INSERT INTO public."Contiene" VALUES (120, 10);
INSERT INTO public."Contiene" VALUES (121, 10);
INSERT INTO public."Contiene" VALUES (122, 10);
INSERT INTO public."Contiene" VALUES (123, 10);
INSERT INTO public."Contiene" VALUES (124, 10);
INSERT INTO public."Contiene" VALUES (125, 10);
INSERT INTO public."Contiene" VALUES (126, 10);
INSERT INTO public."Contiene" VALUES (127, 10);
INSERT INTO public."Contiene" VALUES (128, 10);
INSERT INTO public."Contiene" VALUES (129, 10);
INSERT INTO public."Contiene" VALUES (130, 10);
INSERT INTO public."Contiene" VALUES (131, 10);
INSERT INTO public."Contiene" VALUES (132, 10);
INSERT INTO public."Contiene" VALUES (133, 10);
INSERT INTO public."Contiene" VALUES (134, 10);
INSERT INTO public."Contiene" VALUES (135, 10);
INSERT INTO public."Contiene" VALUES (136, 10);
INSERT INTO public."Contiene" VALUES (137, 10);
INSERT INTO public."Contiene" VALUES (138, 10);
INSERT INTO public."Contiene" VALUES (139, 10);
INSERT INTO public."Contiene" VALUES (140, 10);
INSERT INTO public."Contiene" VALUES (141, 10);
INSERT INTO public."Contiene" VALUES (142, 10);
INSERT INTO public."Contiene" VALUES (143, 10);
INSERT INTO public."Contiene" VALUES (144, 10);
INSERT INTO public."Contiene" VALUES (145, 10);
INSERT INTO public."Contiene" VALUES (146, 10);
INSERT INTO public."Contiene" VALUES (147, 10);
INSERT INTO public."Contiene" VALUES (148, 10);
INSERT INTO public."Contiene" VALUES (149, 10);
INSERT INTO public."Contiene" VALUES (150, 10);


--
-- TOC entry 3444 (class 0 OID 16645)
-- Dependencies: 222
-- Data for Name: Critico; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Critico" VALUES ('JHBEAP63Q41A340Y', 67, '7 Merry Drive', 'M', 'Ivan', 'Biggen', 'Masters in Film Criticism');
INSERT INTO public."Critico" VALUES ('UGHMKP81T80Y588U', 29, '44 Hazelcrest Place', 'M', 'Allister', 'O''Connor', 'Master''s Degree in Cinematography');
INSERT INTO public."Critico" VALUES ('QYYLBM41C28F955D', 44, '37592 Loeprich Way', 'F', 'Rosanne', 'Gilloran', 'Masters in Film Criticism');
INSERT INTO public."Critico" VALUES ('XTERKI29Q22S385S', 44, '221 Onsgard Way', 'M', 'Erwin', 'Goudie', 'Bachelor''s degree in Literature');
INSERT INTO public."Critico" VALUES ('USMSXS47Q03D495W', 46, '4400 Sunbrook Crossing', 'M', 'Yanaton', 'Morstatt', 'Masters in Film Criticism');
INSERT INTO public."Critico" VALUES ('OVOKDX24W63O917N', 34, '9 Wayridge Court', 'F', 'Patrizia', 'Wareham', 'Degree in Communication Sciences');
INSERT INTO public."Critico" VALUES ('IHQZWV45F75U829S', 26, '2 Debra Hill', 'F', 'Elyssa', 'Dello', 'Master''s Degree in Cinematography');
INSERT INTO public."Critico" VALUES ('UELZJQ07J48C905Z', 46, '2 American Ash Plaza', 'M', 'Ethelred', 'Oliveira', 'Masters in Film Criticism');
INSERT INTO public."Critico" VALUES ('MIXGDQ63T03W702U', 54, '997 Memorial Center', 'F', 'Tedi', 'Malenfant', 'Degree in Communication Sciences');
INSERT INTO public."Critico" VALUES ('GWSNLP07U27B761W', 70, '07496 Northview Avenue', 'M', 'Dirk', 'Olenikov', 'Master''s Degree in Cinematography');
INSERT INTO public."Critico" VALUES ('RSBNTC58Y11V067Z', 28, '33792 Ilene Alley', 'M', 'Massimo', 'Kernar', 'Bachelor''s degree in Literature');
INSERT INTO public."Critico" VALUES ('ZFADEY53W40T013K', 77, '4 Brown Crossing', 'F', 'Sondra', 'Djurdjevic', 'Degree in Communication Sciences');
INSERT INTO public."Critico" VALUES ('NBTWTO08M22B853Y', 42, '933 Garrison Terrace', 'M', 'Bondy', 'MacBey', 'Degree in Communication Sciences');
INSERT INTO public."Critico" VALUES ('BGZUDI31I39R955Z', 39, '318 Sloan Plaza', 'M', 'Aleksandr', 'O''Glassane', 'Master''s Degree in Cinematography');
INSERT INTO public."Critico" VALUES ('FSYCWK61R72H705O', 41, '4 Arapahoe Crossing', 'M', 'Martino', 'Blackaller', 'Degree in Communication Sciences');
INSERT INTO public."Critico" VALUES ('GQZZPD55R63L069U', 26, '6391 Everett Lane', 'F', 'Andie', 'Snoxall', 'Masters in Film Criticism');
INSERT INTO public."Critico" VALUES ('DVIVPM39C11J760M', 50, '65 Mariners Cove Trail', 'F', 'Bernadina', 'Hourican', 'Masters in Film Criticism');
INSERT INTO public."Critico" VALUES ('SHUEFG80B31Z777A', 70, '574 Artisan Point', 'M', 'Chandler', 'Blakeway', 'Bachelor''s degree in Literature');
INSERT INTO public."Critico" VALUES ('QBDCKM52Q11G049X', 51, '253 Moland Alley', 'M', 'Kinsley', 'Boxhall', 'Master''s Degree in Cinematography');
INSERT INTO public."Critico" VALUES ('NQHGSM84H66J782N', 27, '8410 Tennyson Alley', 'M', 'Ford', 'Roskelly', 'Degree in Communication Sciences');


--
-- TOC entry 3448 (class 0 OID 16665)
-- Dependencies: 226
-- Data for Name: Direttore; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Direttore" VALUES ('APYBQL73S62Q964U', 79, '5766 Melby Street', 'F', 'Estrellita', 'Bevar', 'Jaxspan');
INSERT INTO public."Direttore" VALUES ('ATLYFL02A68I228S', 56, '59869 Sauthoff Terrace', 'M', 'Huey', 'Circuit', 'Youtags');
INSERT INTO public."Direttore" VALUES ('AYMKRA93J73N483L', 51, '2349 Lerdahl Point', 'F', 'Ramona', 'McFetridge', 'Quinu');
INSERT INTO public."Direttore" VALUES ('CONHWB35M14G921D', 32, '821 Northfield Plaza', 'M', 'Carleton', 'Layburn', 'Thoughtworks');
INSERT INTO public."Direttore" VALUES ('CQRLMI34K21P021Y', 48, '33177 Muir Hill', 'M', 'Skell', 'Cuttell', 'Gigazoom');
INSERT INTO public."Direttore" VALUES ('DSBLKE05R43C850U', 25, '1 Rutledge Trail', 'F', 'Ileana', 'Matevushev', 'Livepath');
INSERT INTO public."Direttore" VALUES ('FCDISF98V00X306Y', 80, '5 Doe Crossing Avenue', 'M', 'Urbano', 'Smooth', 'Jetwire');
INSERT INTO public."Direttore" VALUES ('HPZCCS53X35Y669L', 20, '906 Ohio Street', 'F', 'Birgitta', 'Dee', 'Eabox');
INSERT INTO public."Direttore" VALUES ('JLRNBF34T19U762X', 22, '24 Bellgrove Plaza', 'F', 'Nolana', 'Tooth', 'Leenti');
INSERT INTO public."Direttore" VALUES ('KFILBW60U52T058E', 73, '74668 Autumn Leaf Drive', 'M', 'Hewie', 'Emblow', 'Babblestorm');
INSERT INTO public."Direttore" VALUES ('NERIVU98W31L443O', 76, '66 Thierer Center', 'F', 'Lorilee', 'Janc', 'Kwilith');
INSERT INTO public."Direttore" VALUES ('RGOAFV62R73P675J', 52, '730 Claremont Circle', 'F', 'Ibbie', 'Hayers', 'Photofeed');
INSERT INTO public."Direttore" VALUES ('RVGJBB95N49A791B', 20, '561 Service Junction', 'M', 'Trent', 'Crone', 'Blogtags');
INSERT INTO public."Direttore" VALUES ('SNKGRW55S70O076M', 50, '626 Roxbury Avenue', 'F', 'Cindelyn', 'Yaknov', 'Thoughtstorm');
INSERT INTO public."Direttore" VALUES ('TOWHPZ61C41H383A', 69, '97889 Blaine Circle', 'F', 'Kellyann', 'Thow', 'Jabbersphere');
INSERT INTO public."Direttore" VALUES ('TPSGCJ61Y18C184I', 32, '3109 Fordem Avenue', 'F', 'Celesta', 'Cantrill', 'Buzzbean');
INSERT INTO public."Direttore" VALUES ('TWELVS64V10V504T', 51, '40 Hoepker Alley', 'F', 'Lori', 'Dow', 'Feedfire');
INSERT INTO public."Direttore" VALUES ('WLLOTR86W02N375J', 43, '46 Lakeland Plaza', 'F', 'Shela', 'Bolding', 'Twiner');
INSERT INTO public."Direttore" VALUES ('ZFJHSD73J64L336W', 27, '774 Fuller Court', 'F', 'Stephi', 'Carriage', 'Buzzster');
INSERT INTO public."Direttore" VALUES ('ZOZWVU22P50E105Y', 69, '77356 Calypso Circle', 'M', 'Huntlee', 'Macieiczyk', 'Kamba');


--
-- TOC entry 3437 (class 0 OID 16506)
-- Dependencies: 215
-- Data for Name: Film; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Film" VALUES ('Amer', 178, 'Drama|Horror', 'USFKWW73R02G016J');
INSERT INTO public."Film" VALUES ('An Apology to Elephants', 151, 'Documentary', 'USFKWW73R02G016J');
INSERT INTO public."Film" VALUES ('Astronaut Farmer, The', 159, 'Drama', 'USFKWW73R02G016J');
INSERT INTO public."Film" VALUES ('Bannen Way, The', 128, 'Action|Comedy|Crime|Thriller', 'CCWDUB72V50B164D');
INSERT INTO public."Film" VALUES ('Beatdown', 146, 'Action|Crime|Thriller', 'CCWDUB72V50B164D');
INSERT INTO public."Film" VALUES ('Being Cyrus', 112, 'Comedy|Drama|Thriller', 'CCWDUB72V50B164D');
INSERT INTO public."Film" VALUES ('Bertie and Elizabeth', 64, 'Drama', 'CCWDUB72V50B164D');
INSERT INTO public."Film" VALUES ('Closet, The (Placard, Le)', 154, 'Comedy', 'CCWDUB72V50B164D');
INSERT INTO public."Film" VALUES ('Death by Hanging (Koshikei)', 115, 'Comedy|Crime', 'MYKCZU29I79U716F');
INSERT INTO public."Film" VALUES ('Doctor X', 78, 'Horror|Thriller', 'MYKCZU29I79U716F');
INSERT INTO public."Film" VALUES ('Electric Boogaloo: The Wild, Untold Story of Cannon Films', 99, 'Comedy|Documentary', 'MYKCZU29I79U716F');
INSERT INTO public."Film" VALUES ('Every Girl Should Be Married', 158, 'Comedy|Romance', 'MYKCZU29I79U716F');
INSERT INTO public."Film" VALUES ('Fast and the Furious: Tokyo Drift, The (Fast and the Furious 3, The)', 96, 'Action|Crime|Drama|Thriller', 'MYKCZU29I79U716F');
INSERT INTO public."Film" VALUES ('Fiston', 102, 'Comedy', 'MYKCZU29I79U716F');
INSERT INTO public."Film" VALUES ('For All Mankind', 121, 'Documentary', 'LPZFLL17X75D244H');
INSERT INTO public."Film" VALUES ('Fugitive, The', 118, 'Thriller', 'LPZFLL17X75D244H');
INSERT INTO public."Film" VALUES ('Gas, Food, Lodging', 65, 'Drama|Romance', 'LPZFLL17X75D244H');
INSERT INTO public."Film" VALUES ('Gasoline (Benzina)', 130, 'Crime', 'LPZFLL17X75D244H');
INSERT INTO public."Film" VALUES ('Ghostbusters (a.k.a. Ghost Busters)', 84, 'Action|Comedy|Sci-Fi', 'LPZFLL17X75D244H');
INSERT INTO public."Film" VALUES ('Grouse', 72, 'Comedy', 'YVQEZF05S30O275L');
INSERT INTO public."Film" VALUES ('Headhunter''s Sister, The', 111, 'Drama', 'YVQEZF05S30O275L');
INSERT INTO public."Film" VALUES ('Hellfighters', 77, 'Action|Adventure', 'YVQEZF05S30O275L');
INSERT INTO public."Film" VALUES ('Iceman', 88, 'Action|Comedy|Sci-Fi', 'YVQEZF05S30O275L');
INSERT INTO public."Film" VALUES ('Justice League: Doom ', 74, 'Action|Animation|Fantasy', 'YVQEZF05S30O275L');
INSERT INTO public."Film" VALUES ('Kill the Irishman', 147, 'Action|Crime', 'BMNWBE40P43X019K');
INSERT INTO public."Film" VALUES ('Kit Kittredge: An American Girl', 138, 'Children|Comedy|Drama|Mystery', 'BMNWBE40P43X019K');
INSERT INTO public."Film" VALUES ('Last Unicorn, The', 122, 'Animation|Children|Fantasy', 'BMNWBE40P43X019K');
INSERT INTO public."Film" VALUES ('Looking for Eric', 118, 'Comedy|Drama|Fantasy', 'BMNWBE40P43X019K');
INSERT INTO public."Film" VALUES ('Movie 43', 84, 'Comedy', 'BMNWBE40P43X019K');
INSERT INTO public."Film" VALUES ('North Star (a.k.a. Tashunga)', 75, 'Action|Adventure|Crime|Drama|Western', 'WUDXLV49L61W177U');
INSERT INTO public."Film" VALUES ('Once Upon a Time in the West (C''era una volta il West)', 69, 'Action|Drama|Western', 'WUDXLV49L61W177U');
INSERT INTO public."Film" VALUES ('Outsider', 106, 'Drama', 'WUDXLV49L61W177U');
INSERT INTO public."Film" VALUES ('Personals, The (Zheng hun qi shi)', 174, 'Drama', 'WUDXLV49L61W177U');
INSERT INTO public."Film" VALUES ('Pleasure Seekers, The', 102, 'Comedy|Musical|Romance', 'WUDXLV49L61W177U');
INSERT INTO public."Film" VALUES ('Rachel Papers, The', 90, 'Drama|Romance', 'IFOJHB30P09U447A');
INSERT INTO public."Film" VALUES ('Red Tent, The (Krasnaya palatka)', 155, 'Adventure|Drama|Fantasy', 'IFOJHB30P09U447A');
INSERT INTO public."Film" VALUES ('River, The', 60, 'Drama', 'IFOJHB30P09U447A');
INSERT INTO public."Film" VALUES ('Rovaniemen markkinoilla', 87, 'Comedy|Musical', 'IFOJHB30P09U447A');
INSERT INTO public."Film" VALUES ('Square, The (Al Midan)', 116, 'Documentary', 'SPMSNZ70E10O903F');
INSERT INTO public."Film" VALUES ('St. Elmo''s Fire', 74, 'Drama|Romance', 'SPMSNZ70E10O903F');
INSERT INTO public."Film" VALUES ('Teen Spirit', 133, 'Comedy|Drama|Fantasy', 'SPMSNZ70E10O903F');
INSERT INTO public."Film" VALUES ('Tess', 97, 'Drama|Romance', 'SPMSNZ70E10O903F');
INSERT INTO public."Film" VALUES ('The Swedish Moment', 132, 'Comedy', 'SPMSNZ70E10O903F');
INSERT INTO public."Film" VALUES ('They Call Me Renegade', 111, 'Action|Adventure|Comedy|Western', 'SPMSNZ70E10O903F');
INSERT INTO public."Film" VALUES ('Too Shy to Try (Je suis timide... mais je me soigne)', 148, 'Comedy', 'SPMSNZ70E10O903F');
INSERT INTO public."Film" VALUES ('Train on the Brain', 62, 'Documentary', 'SPMSNZ70E10O903F');
INSERT INTO public."Film" VALUES ('Twilight', 134, 'Crime|Drama|Thriller', 'NEGICV12B11O513U');
INSERT INTO public."Film" VALUES ('Wake Island', 74, 'Drama|War', 'NEGICV12B11O513U');
INSERT INTO public."Film" VALUES ('West Point Story, The', 178, 'Comedy|Musical', 'NEGICV12B11O513U');
INSERT INTO public."Film" VALUES ('Yearling, The', 146, 'Adventure|Children|Drama', 'NEGICV12B11O513U');


--
-- TOC entry 3442 (class 0 OID 16610)
-- Dependencies: 220
-- Data for Name: Possiede; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Possiede" VALUES (1, 'Jaxspan');
INSERT INTO public."Possiede" VALUES (2, 'Jaxspan');
INSERT INTO public."Possiede" VALUES (3, 'Jaxspan');
INSERT INTO public."Possiede" VALUES (4, 'Jaxspan');
INSERT INTO public."Possiede" VALUES (5, 'Jaxspan');
INSERT INTO public."Possiede" VALUES (1, 'Youtags');
INSERT INTO public."Possiede" VALUES (2, 'Youtags');
INSERT INTO public."Possiede" VALUES (3, 'Youtags');
INSERT INTO public."Possiede" VALUES (1, 'Quinu');
INSERT INTO public."Possiede" VALUES (2, 'Quinu');
INSERT INTO public."Possiede" VALUES (3, 'Quinu');
INSERT INTO public."Possiede" VALUES (4, 'Quinu');
INSERT INTO public."Possiede" VALUES (5, 'Quinu');
INSERT INTO public."Possiede" VALUES (1, 'Thoughtworks');
INSERT INTO public."Possiede" VALUES (1, 'Gigazoom');
INSERT INTO public."Possiede" VALUES (2, 'Gigazoom');
INSERT INTO public."Possiede" VALUES (3, 'Gigazoom');
INSERT INTO public."Possiede" VALUES (4, 'Gigazoom');
INSERT INTO public."Possiede" VALUES (5, 'Gigazoom');
INSERT INTO public."Possiede" VALUES (6, 'Gigazoom');
INSERT INTO public."Possiede" VALUES (7, 'Gigazoom');
INSERT INTO public."Possiede" VALUES (8, 'Gigazoom');
INSERT INTO public."Possiede" VALUES (9, 'Gigazoom');
INSERT INTO public."Possiede" VALUES (10, 'Gigazoom');
INSERT INTO public."Possiede" VALUES (1, 'Livepath');
INSERT INTO public."Possiede" VALUES (2, 'Livepath');
INSERT INTO public."Possiede" VALUES (3, 'Livepath');
INSERT INTO public."Possiede" VALUES (4, 'Livepath');
INSERT INTO public."Possiede" VALUES (1, 'Jetwire');
INSERT INTO public."Possiede" VALUES (2, 'Jetwire');
INSERT INTO public."Possiede" VALUES (1, 'Eabox');
INSERT INTO public."Possiede" VALUES (1, 'Leenti');
INSERT INTO public."Possiede" VALUES (2, 'Leenti');
INSERT INTO public."Possiede" VALUES (3, 'Leenti');
INSERT INTO public."Possiede" VALUES (1, 'Babblestorm');
INSERT INTO public."Possiede" VALUES (2, 'Babblestorm');
INSERT INTO public."Possiede" VALUES (3, 'Babblestorm');
INSERT INTO public."Possiede" VALUES (4, 'Babblestorm');
INSERT INTO public."Possiede" VALUES (5, 'Babblestorm');
INSERT INTO public."Possiede" VALUES (6, 'Babblestorm');
INSERT INTO public."Possiede" VALUES (7, 'Babblestorm');
INSERT INTO public."Possiede" VALUES (1, 'Kwilith');
INSERT INTO public."Possiede" VALUES (2, 'Kwilith');
INSERT INTO public."Possiede" VALUES (1, 'Photofeed');
INSERT INTO public."Possiede" VALUES (1, 'Blogtags');
INSERT INTO public."Possiede" VALUES (2, 'Blogtags');
INSERT INTO public."Possiede" VALUES (3, 'Blogtags');
INSERT INTO public."Possiede" VALUES (4, 'Blogtags');
INSERT INTO public."Possiede" VALUES (5, 'Blogtags');
INSERT INTO public."Possiede" VALUES (6, 'Blogtags');
INSERT INTO public."Possiede" VALUES (1, 'Thoughtstorm');
INSERT INTO public."Possiede" VALUES (2, 'Thoughtstorm');
INSERT INTO public."Possiede" VALUES (3, 'Thoughtstorm');
INSERT INTO public."Possiede" VALUES (1, 'Jabbersphere');
INSERT INTO public."Possiede" VALUES (2, 'Jabbersphere');
INSERT INTO public."Possiede" VALUES (3, 'Jabbersphere');
INSERT INTO public."Possiede" VALUES (4, 'Jabbersphere');
INSERT INTO public."Possiede" VALUES (5, 'Jabbersphere');
INSERT INTO public."Possiede" VALUES (6, 'Jabbersphere');
INSERT INTO public."Possiede" VALUES (7, 'Jabbersphere');
INSERT INTO public."Possiede" VALUES (8, 'Jabbersphere');
INSERT INTO public."Possiede" VALUES (9, 'Jabbersphere');
INSERT INTO public."Possiede" VALUES (1, 'Buzzbean');
INSERT INTO public."Possiede" VALUES (2, 'Buzzbean');
INSERT INTO public."Possiede" VALUES (3, 'Buzzbean');
INSERT INTO public."Possiede" VALUES (4, 'Buzzbean');
INSERT INTO public."Possiede" VALUES (1, 'Feedfire');
INSERT INTO public."Possiede" VALUES (2, 'Feedfire');
INSERT INTO public."Possiede" VALUES (1, 'Twiner');
INSERT INTO public."Possiede" VALUES (2, 'Twiner');
INSERT INTO public."Possiede" VALUES (3, 'Twiner');
INSERT INTO public."Possiede" VALUES (4, 'Twiner');
INSERT INTO public."Possiede" VALUES (1, 'Buzzster');
INSERT INTO public."Possiede" VALUES (1, 'Kamba');
INSERT INTO public."Possiede" VALUES (2, 'Kamba');
INSERT INTO public."Possiede" VALUES (3, 'Kamba');


--
-- TOC entry 3438 (class 0 OID 16526)
-- Dependencies: 216
-- Data for Name: Posto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Posto" VALUES (1, B'0');
INSERT INTO public."Posto" VALUES (2, B'0');
INSERT INTO public."Posto" VALUES (3, B'1');
INSERT INTO public."Posto" VALUES (4, B'0');
INSERT INTO public."Posto" VALUES (5, B'1');
INSERT INTO public."Posto" VALUES (6, B'0');
INSERT INTO public."Posto" VALUES (7, B'1');
INSERT INTO public."Posto" VALUES (8, B'1');
INSERT INTO public."Posto" VALUES (9, B'1');
INSERT INTO public."Posto" VALUES (10, B'0');
INSERT INTO public."Posto" VALUES (11, B'1');
INSERT INTO public."Posto" VALUES (12, B'0');
INSERT INTO public."Posto" VALUES (13, B'1');
INSERT INTO public."Posto" VALUES (14, B'0');
INSERT INTO public."Posto" VALUES (15, B'0');
INSERT INTO public."Posto" VALUES (16, B'0');
INSERT INTO public."Posto" VALUES (17, B'1');
INSERT INTO public."Posto" VALUES (18, B'1');
INSERT INTO public."Posto" VALUES (19, B'0');
INSERT INTO public."Posto" VALUES (20, B'0');
INSERT INTO public."Posto" VALUES (21, B'1');
INSERT INTO public."Posto" VALUES (22, B'0');
INSERT INTO public."Posto" VALUES (23, B'1');
INSERT INTO public."Posto" VALUES (24, B'1');
INSERT INTO public."Posto" VALUES (25, B'0');
INSERT INTO public."Posto" VALUES (26, B'0');
INSERT INTO public."Posto" VALUES (27, B'1');
INSERT INTO public."Posto" VALUES (28, B'1');
INSERT INTO public."Posto" VALUES (29, B'1');
INSERT INTO public."Posto" VALUES (30, B'0');
INSERT INTO public."Posto" VALUES (31, B'0');
INSERT INTO public."Posto" VALUES (32, B'1');
INSERT INTO public."Posto" VALUES (33, B'1');
INSERT INTO public."Posto" VALUES (34, B'1');
INSERT INTO public."Posto" VALUES (35, B'1');
INSERT INTO public."Posto" VALUES (36, B'1');
INSERT INTO public."Posto" VALUES (37, B'0');
INSERT INTO public."Posto" VALUES (38, B'1');
INSERT INTO public."Posto" VALUES (39, B'0');
INSERT INTO public."Posto" VALUES (40, B'1');
INSERT INTO public."Posto" VALUES (41, B'0');
INSERT INTO public."Posto" VALUES (42, B'0');
INSERT INTO public."Posto" VALUES (43, B'1');
INSERT INTO public."Posto" VALUES (44, B'1');
INSERT INTO public."Posto" VALUES (45, B'0');
INSERT INTO public."Posto" VALUES (46, B'0');
INSERT INTO public."Posto" VALUES (47, B'1');
INSERT INTO public."Posto" VALUES (48, B'1');
INSERT INTO public."Posto" VALUES (49, B'1');
INSERT INTO public."Posto" VALUES (50, B'1');
INSERT INTO public."Posto" VALUES (51, B'1');
INSERT INTO public."Posto" VALUES (52, B'1');
INSERT INTO public."Posto" VALUES (53, B'0');
INSERT INTO public."Posto" VALUES (54, B'0');
INSERT INTO public."Posto" VALUES (55, B'1');
INSERT INTO public."Posto" VALUES (56, B'1');
INSERT INTO public."Posto" VALUES (57, B'0');
INSERT INTO public."Posto" VALUES (58, B'1');
INSERT INTO public."Posto" VALUES (59, B'1');
INSERT INTO public."Posto" VALUES (60, B'1');
INSERT INTO public."Posto" VALUES (61, B'1');
INSERT INTO public."Posto" VALUES (62, B'0');
INSERT INTO public."Posto" VALUES (63, B'0');
INSERT INTO public."Posto" VALUES (64, B'0');
INSERT INTO public."Posto" VALUES (65, B'0');
INSERT INTO public."Posto" VALUES (66, B'0');
INSERT INTO public."Posto" VALUES (67, B'1');
INSERT INTO public."Posto" VALUES (68, B'0');
INSERT INTO public."Posto" VALUES (69, B'1');
INSERT INTO public."Posto" VALUES (70, B'0');
INSERT INTO public."Posto" VALUES (71, B'0');
INSERT INTO public."Posto" VALUES (72, B'0');
INSERT INTO public."Posto" VALUES (73, B'0');
INSERT INTO public."Posto" VALUES (74, B'1');
INSERT INTO public."Posto" VALUES (75, B'0');
INSERT INTO public."Posto" VALUES (76, B'1');
INSERT INTO public."Posto" VALUES (77, B'1');
INSERT INTO public."Posto" VALUES (78, B'1');
INSERT INTO public."Posto" VALUES (79, B'1');
INSERT INTO public."Posto" VALUES (80, B'0');
INSERT INTO public."Posto" VALUES (81, B'0');
INSERT INTO public."Posto" VALUES (82, B'0');
INSERT INTO public."Posto" VALUES (83, B'1');
INSERT INTO public."Posto" VALUES (84, B'1');
INSERT INTO public."Posto" VALUES (85, B'0');
INSERT INTO public."Posto" VALUES (86, B'1');
INSERT INTO public."Posto" VALUES (87, B'1');
INSERT INTO public."Posto" VALUES (88, B'0');
INSERT INTO public."Posto" VALUES (89, B'1');
INSERT INTO public."Posto" VALUES (90, B'1');
INSERT INTO public."Posto" VALUES (91, B'0');
INSERT INTO public."Posto" VALUES (92, B'1');
INSERT INTO public."Posto" VALUES (93, B'0');
INSERT INTO public."Posto" VALUES (94, B'0');
INSERT INTO public."Posto" VALUES (95, B'0');
INSERT INTO public."Posto" VALUES (96, B'1');
INSERT INTO public."Posto" VALUES (97, B'0');
INSERT INTO public."Posto" VALUES (98, B'0');
INSERT INTO public."Posto" VALUES (99, B'1');
INSERT INTO public."Posto" VALUES (100, B'0');
INSERT INTO public."Posto" VALUES (101, B'0');
INSERT INTO public."Posto" VALUES (102, B'0');
INSERT INTO public."Posto" VALUES (103, B'0');
INSERT INTO public."Posto" VALUES (104, B'0');
INSERT INTO public."Posto" VALUES (105, B'1');
INSERT INTO public."Posto" VALUES (106, B'0');
INSERT INTO public."Posto" VALUES (107, B'1');
INSERT INTO public."Posto" VALUES (108, B'0');
INSERT INTO public."Posto" VALUES (109, B'0');
INSERT INTO public."Posto" VALUES (110, B'1');
INSERT INTO public."Posto" VALUES (111, B'1');
INSERT INTO public."Posto" VALUES (112, B'1');
INSERT INTO public."Posto" VALUES (113, B'0');
INSERT INTO public."Posto" VALUES (114, B'0');
INSERT INTO public."Posto" VALUES (115, B'0');
INSERT INTO public."Posto" VALUES (116, B'1');
INSERT INTO public."Posto" VALUES (117, B'1');
INSERT INTO public."Posto" VALUES (118, B'0');
INSERT INTO public."Posto" VALUES (119, B'0');
INSERT INTO public."Posto" VALUES (120, B'1');
INSERT INTO public."Posto" VALUES (121, B'1');
INSERT INTO public."Posto" VALUES (122, B'0');
INSERT INTO public."Posto" VALUES (123, B'0');
INSERT INTO public."Posto" VALUES (124, B'1');
INSERT INTO public."Posto" VALUES (125, B'1');
INSERT INTO public."Posto" VALUES (126, B'1');
INSERT INTO public."Posto" VALUES (127, B'0');
INSERT INTO public."Posto" VALUES (128, B'1');
INSERT INTO public."Posto" VALUES (129, B'0');
INSERT INTO public."Posto" VALUES (130, B'1');
INSERT INTO public."Posto" VALUES (131, B'1');
INSERT INTO public."Posto" VALUES (132, B'0');
INSERT INTO public."Posto" VALUES (133, B'1');
INSERT INTO public."Posto" VALUES (134, B'1');
INSERT INTO public."Posto" VALUES (135, B'1');
INSERT INTO public."Posto" VALUES (136, B'1');
INSERT INTO public."Posto" VALUES (137, B'0');
INSERT INTO public."Posto" VALUES (138, B'0');
INSERT INTO public."Posto" VALUES (139, B'1');
INSERT INTO public."Posto" VALUES (140, B'0');
INSERT INTO public."Posto" VALUES (141, B'0');
INSERT INTO public."Posto" VALUES (142, B'1');
INSERT INTO public."Posto" VALUES (143, B'1');
INSERT INTO public."Posto" VALUES (144, B'1');
INSERT INTO public."Posto" VALUES (145, B'0');
INSERT INTO public."Posto" VALUES (146, B'0');
INSERT INTO public."Posto" VALUES (147, B'1');
INSERT INTO public."Posto" VALUES (148, B'0');
INSERT INTO public."Posto" VALUES (149, B'0');
INSERT INTO public."Posto" VALUES (150, B'0');
INSERT INTO public."Posto" VALUES (151, B'0');
INSERT INTO public."Posto" VALUES (152, B'0');
INSERT INTO public."Posto" VALUES (153, B'1');
INSERT INTO public."Posto" VALUES (154, B'1');
INSERT INTO public."Posto" VALUES (155, B'0');
INSERT INTO public."Posto" VALUES (156, B'1');
INSERT INTO public."Posto" VALUES (157, B'0');
INSERT INTO public."Posto" VALUES (158, B'0');
INSERT INTO public."Posto" VALUES (159, B'0');
INSERT INTO public."Posto" VALUES (160, B'0');
INSERT INTO public."Posto" VALUES (161, B'1');
INSERT INTO public."Posto" VALUES (162, B'1');
INSERT INTO public."Posto" VALUES (163, B'1');
INSERT INTO public."Posto" VALUES (164, B'0');
INSERT INTO public."Posto" VALUES (165, B'1');
INSERT INTO public."Posto" VALUES (166, B'1');
INSERT INTO public."Posto" VALUES (167, B'1');
INSERT INTO public."Posto" VALUES (168, B'1');
INSERT INTO public."Posto" VALUES (169, B'0');
INSERT INTO public."Posto" VALUES (170, B'0');
INSERT INTO public."Posto" VALUES (171, B'1');
INSERT INTO public."Posto" VALUES (172, B'0');
INSERT INTO public."Posto" VALUES (173, B'1');
INSERT INTO public."Posto" VALUES (174, B'1');
INSERT INTO public."Posto" VALUES (175, B'1');
INSERT INTO public."Posto" VALUES (176, B'0');
INSERT INTO public."Posto" VALUES (177, B'0');
INSERT INTO public."Posto" VALUES (178, B'1');
INSERT INTO public."Posto" VALUES (179, B'1');
INSERT INTO public."Posto" VALUES (180, B'1');
INSERT INTO public."Posto" VALUES (181, B'1');
INSERT INTO public."Posto" VALUES (182, B'1');
INSERT INTO public."Posto" VALUES (183, B'1');
INSERT INTO public."Posto" VALUES (184, B'1');
INSERT INTO public."Posto" VALUES (185, B'1');
INSERT INTO public."Posto" VALUES (186, B'0');
INSERT INTO public."Posto" VALUES (187, B'1');
INSERT INTO public."Posto" VALUES (188, B'1');
INSERT INTO public."Posto" VALUES (189, B'0');
INSERT INTO public."Posto" VALUES (190, B'1');
INSERT INTO public."Posto" VALUES (191, B'0');
INSERT INTO public."Posto" VALUES (192, B'0');
INSERT INTO public."Posto" VALUES (193, B'1');
INSERT INTO public."Posto" VALUES (194, B'1');
INSERT INTO public."Posto" VALUES (195, B'1');
INSERT INTO public."Posto" VALUES (196, B'1');
INSERT INTO public."Posto" VALUES (197, B'0');
INSERT INTO public."Posto" VALUES (198, B'0');
INSERT INTO public."Posto" VALUES (199, B'1');
INSERT INTO public."Posto" VALUES (200, B'1');


--
-- TOC entry 3439 (class 0 OID 16531)
-- Dependencies: 217
-- Data for Name: Premio; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Premio" VALUES ('Academy Award for Best Picture', 2019, 'Ghostbusters (a.k.a. Ghost Busters)', NULL, NULL);
INSERT INTO public."Premio" VALUES ('Academy Award for Best Picture', 2020, 'Movie 43', NULL, NULL);
INSERT INTO public."Premio" VALUES ('Academy Award for Best Picture', 2021, 'Amer', NULL, NULL);
INSERT INTO public."Premio" VALUES ('Academy Award for Best Picture', 2022, 'Looking for Eric', NULL, NULL);
INSERT INTO public."Premio" VALUES ('Academy Award for Best Director', 2022, NULL, NULL, 'WUDXLV49L61W177U');
INSERT INTO public."Premio" VALUES ('Academy Award for Best Director', 2021, NULL, NULL, 'IFOJHB30P09U447A');
INSERT INTO public."Premio" VALUES ('Academy Award for Best Director', 2020, NULL, NULL, 'SPMSNZ70E10O903F');
INSERT INTO public."Premio" VALUES ('Academy Award for Best Director', 2019, NULL, NULL, 'NEGICV12B11O513U');
INSERT INTO public."Premio" VALUES ('Academy Award for Best Actor', 2022, NULL, 'ZAIUMK22C98L832Z', NULL);
INSERT INTO public."Premio" VALUES ('Academy Award for Best Actor', 2019, NULL, 'OXIQNQ61W59Q659X', NULL);
INSERT INTO public."Premio" VALUES ('Academy Award for Best Actor', 2020, NULL, 'DUJHCZ49O39R797M', NULL);
INSERT INTO public."Premio" VALUES ('Academy Award for Best Actor', 2021, NULL, 'OWXSVQ22E13M482K', NULL);


--
-- TOC entry 3443 (class 0 OID 16628)
-- Dependencies: 221
-- Data for Name: Proiezione; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Proiezione" VALUES ('2023-01-22', '15:50:00', '17:40:00', 7, B'1', 10.63, 17.64, 'English', 'Twilight');
INSERT INTO public."Proiezione" VALUES ('2023-02-25', '15:21:00', '17:13:00', 4, B'1', 8.49, 16.23, 'Italian', 'Red Tent, The (Krasnaya palatka)');
INSERT INTO public."Proiezione" VALUES ('2023-02-28', '15:28:00', '17:55:00', 3, B'1', 10.58, 16.74, 'Italian', 'Red Tent, The (Krasnaya palatka)');
INSERT INTO public."Proiezione" VALUES ('2023-03-08', '15:54:00', '17:02:00', 6, B'1', 10.78, 18.6, 'Italian', 'An Apology to Elephants');
INSERT INTO public."Proiezione" VALUES ('2023-04-08', '15:35:00', '17:42:00', 1, B'0', 7.67, 13.49, 'English', 'Looking for Eric');
INSERT INTO public."Proiezione" VALUES ('2023-04-22', '15:48:00', '17:39:00', 1, B'0', 8.37, 15.26, 'Italian', 'Yearling, The');
INSERT INTO public."Proiezione" VALUES ('2023-04-25', '15:11:00', '17:49:00', 4, B'0', 7.19, 15.98, 'Italian', 'Rachel Papers, The');
INSERT INTO public."Proiezione" VALUES ('2023-05-27', '15:52:00', '17:10:00', 8, B'1', 10.93, 15.01, 'Italian', 'Fiston');
INSERT INTO public."Proiezione" VALUES ('2023-06-17', '15:36:00', '17:27:00', 1, B'1', 8.91, 15.62, 'English', 'North Star (a.k.a. Tashunga)');
INSERT INTO public."Proiezione" VALUES ('2023-06-20', '15:08:00', '17:01:00', 5, B'0', 8.59, 17.67, 'German', 'Personals, The (Zheng hun qi shi)');
INSERT INTO public."Proiezione" VALUES ('2023-07-13', '15:29:00', '17:20:00', 6, B'0', 7.43, 17.34, 'Italian', 'Personals, The (Zheng hun qi shi)');
INSERT INTO public."Proiezione" VALUES ('2023-07-16', '15:47:00', '17:48:00', 9, B'1', 9.31, 17.35, 'English', 'Every Girl Should Be Married');
INSERT INTO public."Proiezione" VALUES ('2023-07-21', '15:20:00', '17:31:00', 9, B'0', 9.73, 17.01, 'Italian', 'Every Girl Should Be Married');
INSERT INTO public."Proiezione" VALUES ('2023-07-30', '15:36:00', '17:35:00', 4, B'1', 8.95, 14.41, 'Italian', 'Every Girl Should Be Married');
INSERT INTO public."Proiezione" VALUES ('2023-08-06', '15:19:00', '17:49:00', 4, B'1', 7.82, 17.1, 'Italian', 'Teen Spirit');
INSERT INTO public."Proiezione" VALUES ('2023-08-13', '15:14:00', '17:45:00', 9, B'0', 10.07, 14.15, 'Italian', 'Bannen Way, The');
INSERT INTO public."Proiezione" VALUES ('2023-08-20', '15:57:00', '17:29:00', 5, B'1', 7.19, 13.03, 'Italian', 'Amer');
INSERT INTO public."Proiezione" VALUES ('2023-08-22', '15:31:00', '17:28:00', 4, B'0', 9.66, 17.59, 'English', 'They Call Me Renegade');
INSERT INTO public."Proiezione" VALUES ('2023-09-02', '15:29:00', '17:00:00', 8, B'0', 8.89, 15.75, 'Italian', 'Electric Boogaloo: The Wild, Untold Story of Cannon Films');
INSERT INTO public."Proiezione" VALUES ('2023-09-09', '15:27:00', '17:03:00', 3, B'0', 10.01, 16.62, 'English', 'West Point Story, The');
INSERT INTO public."Proiezione" VALUES ('2023-09-30', '15:50:00', '17:36:00', 5, B'1', 10.07, 15.66, 'Spanish', 'Bertie and Elizabeth');
INSERT INTO public."Proiezione" VALUES ('2023-10-21', '15:03:00', '17:41:00', 6, B'1', 10.28, 18.5, 'English', 'Electric Boogaloo: The Wild, Untold Story of Cannon Films');
INSERT INTO public."Proiezione" VALUES ('2023-10-23', '15:58:00', '17:17:00', 5, B'0', 10.8, 15.71, 'Italian', 'Closet, The (Placard, Le)');
INSERT INTO public."Proiezione" VALUES ('2023-11-14', '15:46:00', '17:04:00', 7, B'1', 9.51, 17.81, 'Italian', 'Outsider');
INSERT INTO public."Proiezione" VALUES ('2023-11-18', '15:00:00', '17:13:00', 3, B'0', 8.01, 15.22, 'Italian', 'Being Cyrus');
INSERT INTO public."Proiezione" VALUES ('2023-11-28', '15:59:00', '17:30:00', 9, B'0', 10.38, 13.81, 'Italian', 'Gas, Food, Lodging');
INSERT INTO public."Proiezione" VALUES ('2023-12-01', '15:35:00', '17:30:00', 5, B'0', 8.95, 15.72, 'English', 'Gas, Food, Lodging');
INSERT INTO public."Proiezione" VALUES ('2023-12-14', '15:15:00', '17:41:00', 2, B'0', 7.02, 15.18, 'Italian', 'Too Shy to Try (Je suis timide... mais je me soigne)');
INSERT INTO public."Proiezione" VALUES ('2023-12-19', '15:41:00', '17:04:00', 1, B'0', 9.56, 16.96, 'Italian', 'Death by Hanging (Koshikei)');
INSERT INTO public."Proiezione" VALUES ('2023-12-21', '15:53:00', '17:04:00', 9, B'1', 10.84, 14.88, 'English', 'Wake Island');


--
-- TOC entry 3451 (class 0 OID 16744)
-- Dependencies: 229
-- Data for Name: Recita; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Recita" VALUES ('BNDKHS92H51Z657X', 'Hellfighters', 12472, 'comparsa');
INSERT INTO public."Recita" VALUES ('CMMYIL90W26R836A', 'They Call Me Renegade', 24666, 'coprotagonista');
INSERT INTO public."Recita" VALUES ('COWPQT79G19A198I', 'Closet, The (Placard, Le)', 22476, 'protagonista');
INSERT INTO public."Recita" VALUES ('DGQNMG80K01A483G', 'Amer', 14575, 'antagonista');
INSERT INTO public."Recita" VALUES ('DGQNMG80K01A483G', 'Every Girl Should Be Married', 29942, 'protagonista');
INSERT INTO public."Recita" VALUES ('DGQNMG80K01A483G', 'Kill the Irishman', 21591, 'protagonista');
INSERT INTO public."Recita" VALUES ('DIMNIF66R84F774V', 'Bannen Way, The', 13345, 'protagonista');
INSERT INTO public."Recita" VALUES ('DIMNIF66R84F774V', 'Beatdown', 16449, 'protagonista');
INSERT INTO public."Recita" VALUES ('DIMNIF66R84F774V', 'Ghostbusters (a.k.a. Ghost Busters)', 25910, 'cameo');
INSERT INTO public."Recita" VALUES ('DIMNIF66R84F774V', 'Iceman', 10284, 'protagonista');
INSERT INTO public."Recita" VALUES ('DIMNIF66R84F774V', 'Personals, The (Zheng hun qi shi)', 29594, 'protagonista');
INSERT INTO public."Recita" VALUES ('DIMNIF66R84F774V', 'Teen Spirit', 29124, 'antagonista');
INSERT INTO public."Recita" VALUES ('DJMMZG31Z31E010V', 'Ghostbusters (a.k.a. Ghost Busters)', 20741, 'antagonista');
INSERT INTO public."Recita" VALUES ('DJMMZG31Z31E010V', 'Pleasure Seekers, The', 27873, 'protagonista');
INSERT INTO public."Recita" VALUES ('DJMMZG31Z31E010V', 'Twilight', 18519, 'protagonista');
INSERT INTO public."Recita" VALUES ('DUJHCZ49O39R797M', 'West Point Story, The', 17771, 'protagonista');
INSERT INTO public."Recita" VALUES ('EFHAMI32F19A135H', 'Grouse', 16397, 'protagonista');
INSERT INTO public."Recita" VALUES ('EPVIIQ64L27W231V', 'Astronaut Farmer, The', 28766, 'antagonista');
INSERT INTO public."Recita" VALUES ('FAONOR75Q31W618U', 'Electric Boogaloo: The Wild, Untold Story of Cannon Films', 24640, 'protagonista');
INSERT INTO public."Recita" VALUES ('FAONOR75Q31W618U', 'Grouse', 29083, 'coprotagonista');
INSERT INTO public."Recita" VALUES ('FAONOR75Q31W618U', 'River, The', 10541, 'protagonista');
INSERT INTO public."Recita" VALUES ('FDJYGS58U60L510J', 'Rovaniemen markkinoilla', 19172, 'protagonista');
INSERT INTO public."Recita" VALUES ('FKBIMT21J50F212A', 'Doctor X', 26815, 'protagonista');
INSERT INTO public."Recita" VALUES ('FKBIMT21J50F212A', 'Gasoline (Benzina)', 28854, 'protagonista');
INSERT INTO public."Recita" VALUES ('FKBIMT21J50F212A', 'Wake Island', 26815, 'protagonista');
INSERT INTO public."Recita" VALUES ('FPCXRR67N67K247X', 'Fast and the Furious: Tokyo Drift, The (Fast and the Furious 3, The)', 29534, 'protagonista');
INSERT INTO public."Recita" VALUES ('FZLBXW48C50Y893P', 'Astronaut Farmer, The', 15814, 'protagonista');
INSERT INTO public."Recita" VALUES ('HXPBIJ47Y12K224M', 'Last Unicorn, The', 11104, 'coprotagonista');
INSERT INTO public."Recita" VALUES ('JJKFQX59M91W607B', 'Rachel Papers, The', 16570, 'protagonista');
INSERT INTO public."Recita" VALUES ('JLNFUW11R33J032O', 'An Apology to Elephants', 11801, 'protagonista');
INSERT INTO public."Recita" VALUES ('KFCHLF91J27Z907E', 'Hellfighters', 22503, 'antagonista');
INSERT INTO public."Recita" VALUES ('KJSCPR78I84Y203J', 'For All Mankind', 29460, 'protagonista');
INSERT INTO public."Recita" VALUES ('MJWJJV79R57S988A', 'Amer', 10777, 'protagonista');
INSERT INTO public."Recita" VALUES ('MJWJJV79R57S988A', 'Ghostbusters (a.k.a. Ghost Busters)', 27689, 'protagonista');
INSERT INTO public."Recita" VALUES ('MJWJJV79R57S988A', 'Looking for Eric', 12719, 'protagonista');
INSERT INTO public."Recita" VALUES ('OHSOZS65O42G121Y', 'St. Elmo''s Fire', 20347, 'protagonista');
INSERT INTO public."Recita" VALUES ('ONAXAM15O57B236B', 'The Swedish Moment', 25418, 'protagonista');
INSERT INTO public."Recita" VALUES ('OWXSVQ22E13M482K', 'Death by Hanging (Koshikei)', 28264, 'protagonista');
INSERT INTO public."Recita" VALUES ('OWXSVQ22E13M482K', 'Movie 43', 12249, 'protagonista');
INSERT INTO public."Recita" VALUES ('OXIQNQ61W59Q659X', 'Fiston', 23741, 'protagonista');
INSERT INTO public."Recita" VALUES ('OXIQNQ61W59Q659X', 'Justice League: Doom ', 16728, 'protagonista');
INSERT INTO public."Recita" VALUES ('QHOQFV30I40A436W', 'Outsider', 20694, 'comparsa');
INSERT INTO public."Recita" VALUES ('QKBXDZ07C62W650D', 'Headhunter''s Sister, The', 18073, 'protagonista');
INSERT INTO public."Recita" VALUES ('RNSRBV23K43Y969N', 'Outsider', 20253, 'protagonista');
INSERT INTO public."Recita" VALUES ('SNXIIY19Q95N099F', 'Astronaut Farmer, The', 19967, 'comparsa');
INSERT INTO public."Recita" VALUES ('SNXIIY19Q95N099F', 'Being Cyrus', 21077, 'protagonista');
INSERT INTO public."Recita" VALUES ('SNXIIY19Q95N099F', 'Fugitive, The', 13788, 'protagonista');
INSERT INTO public."Recita" VALUES ('SPUYMG72I01G211L', 'Astronaut Farmer, The', 22059, 'coprotagonista');
INSERT INTO public."Recita" VALUES ('SPUYMG72I01G211L', 'Bertie and Elizabeth', 13902, 'protagonista');
INSERT INTO public."Recita" VALUES ('TGLTOD52S83R646W', 'They Call Me Renegade', 17186, 'antagonista');
INSERT INTO public."Recita" VALUES ('UFOEDJ09C28M452Q', 'Hellfighters', 21126, 'protagonista');
INSERT INTO public."Recita" VALUES ('UFOEDJ09C28M452Q', 'Too Shy to Try (Je suis timide... mais je me soigne)', 15577, 'protagonista');
INSERT INTO public."Recita" VALUES ('UFOEDJ09C28M452Q', 'Train on the Brain', 16909, 'protagonista');
INSERT INTO public."Recita" VALUES ('UFOEDJ09C28M452Q', 'Yearling, The', 22756, 'protagonista');
INSERT INTO public."Recita" VALUES ('UJCYLQ20B51O642E', 'Fiston', 27679, 'coprotagonista');
INSERT INTO public."Recita" VALUES ('VCRBGM98T66J346R', 'Once Upon a Time in the West (C''era una volta il West)', 20371, 'protagonista');
INSERT INTO public."Recita" VALUES ('VOZJDF41H43W079I', 'Grouse', 23793, 'antagonista');
INSERT INTO public."Recita" VALUES ('VSODYG58H09U245D', 'Red Tent, The (Krasnaya palatka)', 15287, 'protagonista');
INSERT INTO public."Recita" VALUES ('VZGYYN71Q74B606O', 'Last Unicorn, The', 21477, 'protagonista');
INSERT INTO public."Recita" VALUES ('VZGYYN71Q74B606O', 'They Call Me Renegade', 23396, 'protagonista');
INSERT INTO public."Recita" VALUES ('YIPFXY68W11N274U', 'Gas, Food, Lodging', 13967, 'protagonista');
INSERT INTO public."Recita" VALUES ('ZAIUMK22C98L832Z', 'Beatdown', 18595, 'comparsa');
INSERT INTO public."Recita" VALUES ('ZAIUMK22C98L832Z', 'Iceman', 25827, 'comparsa');
INSERT INTO public."Recita" VALUES ('ZAIUMK22C98L832Z', 'North Star (a.k.a. Tashunga)', 21428, 'protagonista');
INSERT INTO public."Recita" VALUES ('ZAIUMK22C98L832Z', 'Teen Spirit', 25643, 'protagonista');
INSERT INTO public."Recita" VALUES ('ZENGKR35M47L113B', 'Kit Kittredge: An American Girl', 20979, 'protagonista');
INSERT INTO public."Recita" VALUES ('ZJFWGR45X75O101E', 'Fiston', 13365, 'cameo');
INSERT INTO public."Recita" VALUES ('ZJFWGR45X75O101E', 'Square, The (Al Midan)', 24170, 'protagonista');
INSERT INTO public."Recita" VALUES ('ZJFWGR45X75O101E', 'Tess', 17168, 'protagonista');
INSERT INTO public."Recita" VALUES ('ZJFWGR45X75O101E', 'Yearling, The', 21973, 'antagonista');


--
-- TOC entry 3446 (class 0 OID 16655)
-- Dependencies: 224
-- Data for Name: Regista; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Regista" VALUES ('USFKWW73R02G016J', 48, '607 Doe Crossing Lane', 'M', 'Arte', 'Deville');
INSERT INTO public."Regista" VALUES ('CCWDUB72V50B164D', 66, '2 Butternut Crossing', 'F', 'Mavra', 'Kneel');
INSERT INTO public."Regista" VALUES ('MYKCZU29I79U716F', 30, '48498 Schlimgen Pass', 'M', 'Benjamen', 'Gabriel');
INSERT INTO public."Regista" VALUES ('LPZFLL17X75D244H', 40, '25 Vermont Lane', 'F', 'Marrissa', 'Keele');
INSERT INTO public."Regista" VALUES ('YVQEZF05S30O275L', 28, '5 Atwood Terrace', 'M', 'Svend', 'Sawdy');
INSERT INTO public."Regista" VALUES ('BMNWBE40P43X019K', 33, '06 Independence Trail', 'M', 'Cliff', 'Plaister');
INSERT INTO public."Regista" VALUES ('WUDXLV49L61W177U', 33, '22021 International Street', 'M', 'Turner', 'Corley');
INSERT INTO public."Regista" VALUES ('IFOJHB30P09U447A', 69, '13 Maywood Alley', 'M', 'Trev', 'Labin');
INSERT INTO public."Regista" VALUES ('SPMSNZ70E10O903F', 78, '12155 Oneill Pass', 'M', 'Niven', 'McLardie');
INSERT INTO public."Regista" VALUES ('NEGICV12B11O513U', 31, '3 Carpenter Way', 'F', 'Annmaria', 'Hazard');


--
-- TOC entry 3440 (class 0 OID 16572)
-- Dependencies: 218
-- Data for Name: Sala; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Sala" VALUES (1);
INSERT INTO public."Sala" VALUES (2);
INSERT INTO public."Sala" VALUES (3);
INSERT INTO public."Sala" VALUES (4);
INSERT INTO public."Sala" VALUES (5);
INSERT INTO public."Sala" VALUES (6);
INSERT INTO public."Sala" VALUES (7);
INSERT INTO public."Sala" VALUES (8);
INSERT INTO public."Sala" VALUES (9);
INSERT INTO public."Sala" VALUES (10);


--
-- TOC entry 3445 (class 0 OID 16650)
-- Dependencies: 223
-- Data for Name: Spettatore; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Spettatore" VALUES ('KHHPEY61J73L609B', 69, '22 Jackson Hill', 'M', 'Pierre', 'Potier');
INSERT INTO public."Spettatore" VALUES ('VOPBNU74M91D707B', 26, '86442 Tennessee Place', 'M', 'Burnaby', 'Castlake');
INSERT INTO public."Spettatore" VALUES ('YVDKJZ46E66S602P', 56, '86 Oneill Way', 'M', 'Rickey', 'Darleston');
INSERT INTO public."Spettatore" VALUES ('LJYQGP83G37S233G', 28, '6666 Clemons Drive', 'F', 'Babara', 'Timeby');
INSERT INTO public."Spettatore" VALUES ('HDPPHU80Y05Y142N', 81, '727 Schlimgen Pass', 'F', 'Morena', 'McKerlie');
INSERT INTO public."Spettatore" VALUES ('TAVZII24X38W157N', 22, '7205 Russell Crossing', 'F', 'Heddi', 'Housam');
INSERT INTO public."Spettatore" VALUES ('ULCSGF46M94Z056Q', 33, '495 Butternut Center', 'M', 'Adriano', 'Kienle');
INSERT INTO public."Spettatore" VALUES ('SPVMUD32S19Z532E', 41, '2061 Canary Lane', 'M', 'Devy', 'Bauman');
INSERT INTO public."Spettatore" VALUES ('NZLWEE20J57X151P', 47, '4 Schiller Terrace', 'M', 'Wadsworth', 'Bleackly');
INSERT INTO public."Spettatore" VALUES ('YOYWJR13S96U177H', 71, '295 Gateway Circle', 'M', 'Mitchell', 'January');
INSERT INTO public."Spettatore" VALUES ('NGKKLP63M00S201L', 58, '98 Lakewood Gardens Street', 'M', 'Adrian', 'Nassey');
INSERT INTO public."Spettatore" VALUES ('MFTBZU06I43C981O', 43, '5 Bellgrove Way', 'M', 'Esme', 'Boules');
INSERT INTO public."Spettatore" VALUES ('NBEPWL47O15L613B', 60, '778 Oneill Park', 'F', 'Cindelyn', 'Garshore');
INSERT INTO public."Spettatore" VALUES ('JUXAGZ17W51Z367O', 69, '1 Dapin Lane', 'F', 'Karoline', 'Wolseley');
INSERT INTO public."Spettatore" VALUES ('OCUVAO09E04K517O', 51, '82794 Ilene Drive', 'M', 'Hayward', 'Fransewich');
INSERT INTO public."Spettatore" VALUES ('UADRSV39O09O432K', 56, '9247 Barby Circle', 'F', 'Loralie', 'Stukings');
INSERT INTO public."Spettatore" VALUES ('USZNPS96A75Z038G', 22, '018 Badeau Junction', 'F', 'Myrtice', 'Barbrook');
INSERT INTO public."Spettatore" VALUES ('ZJRTZZ78E14Z468T', 28, '7927 Arkansas Center', 'F', 'Sherilyn', 'Curnick');
INSERT INTO public."Spettatore" VALUES ('SCOKIT65C60X620B', 25, '1796 Karstens Avenue', 'M', 'Wes', 'Stapels');
INSERT INTO public."Spettatore" VALUES ('PCEZGD99K23N397I', 77, '40 Erie Court', 'M', 'Isaak', 'Ivic');
INSERT INTO public."Spettatore" VALUES ('BEPVXU52H40B126V', 60, '49083 Menomonie Place', 'F', 'Lotta', 'Melmoth');
INSERT INTO public."Spettatore" VALUES ('CLDOED24D28Q309N', 43, '10286 Carioca Avenue', 'F', 'Elladine', 'Took');
INSERT INTO public."Spettatore" VALUES ('DNWFNX15T64Q262N', 40, '86675 Golf View Junction', 'M', 'Natty', 'Mosedale');
INSERT INTO public."Spettatore" VALUES ('PMSWWS29S51Z167Z', 26, '8 Lighthouse Bay Circle', 'F', 'Deb', 'Axtell');
INSERT INTO public."Spettatore" VALUES ('PEEDGX12Z16Q242U', 74, '146 Grim Lane', 'M', 'Lemmie', 'Tomsett');
INSERT INTO public."Spettatore" VALUES ('LRRLRL04E33E219P', 53, '78783 Mallard Drive', 'M', 'Merwyn', 'Kittow');
INSERT INTO public."Spettatore" VALUES ('ABRJFT72A99K382Y', 43, '71992 Westerfield Point', 'F', 'Minnaminnie', 'Limpkin');
INSERT INTO public."Spettatore" VALUES ('XECEZI70I89T754F', 28, '284 Schlimgen Point', 'M', 'Joaquin', 'Brugsma');
INSERT INTO public."Spettatore" VALUES ('JRDYWT42P36M105E', 57, '95250 Helena Road', 'F', 'Thomasina', 'Adamovsky');
INSERT INTO public."Spettatore" VALUES ('KZYBPR61M62C409M', 47, '22049 Packers Pass', 'M', 'Orran', 'Drydale');
INSERT INTO public."Spettatore" VALUES ('WYLFRX89J73D528P', 61, '5 Schlimgen Alley', 'F', 'Bobine', 'Itscowics');
INSERT INTO public."Spettatore" VALUES ('EUIVZH69X28T999D', 52, '7861 Mcbride Center', 'F', 'Clare', 'Erskine Sandys');
INSERT INTO public."Spettatore" VALUES ('OBCAEJ57D33N678V', 52, '5 Elmside Plaza', 'F', 'Simone', 'Jellis');
INSERT INTO public."Spettatore" VALUES ('CQPAZL50P52T455F', 25, '2 Trailsway Alley', 'F', 'Jaine', 'Meates');
INSERT INTO public."Spettatore" VALUES ('YXXLVO10D42L811U', 20, '72777 Hauk Center', 'F', 'Nollie', 'Broomhead');
INSERT INTO public."Spettatore" VALUES ('NPSAKN29P08F812E', 39, '87 Stone Corner Center', 'F', 'Vannie', 'Steere');
INSERT INTO public."Spettatore" VALUES ('ATKZEF48U80U951N', 34, '800 Stuart Crossing', 'M', 'Fraze', 'Lackington');
INSERT INTO public."Spettatore" VALUES ('KOPKZR42L85O671U', 19, '79238 Dwight Circle', 'M', 'Oswell', 'Hallstone');
INSERT INTO public."Spettatore" VALUES ('BCAULW40Q66R270I', 20, '2943 Moose Center', 'F', 'Clair', 'Bullen');
INSERT INTO public."Spettatore" VALUES ('LQAOWX99V12L889P', 70, '458 Oneill Parkway', 'M', 'Hinze', 'De Hooge');
INSERT INTO public."Spettatore" VALUES ('EOKPOR74H59K636P', 41, '6917 Corry Pass', 'M', 'Jess', 'Jovicic');
INSERT INTO public."Spettatore" VALUES ('ZCNJKZ52H45I246S', 79, '33 Eagle Crest Plaza', 'F', 'Cherry', 'Nusche');
INSERT INTO public."Spettatore" VALUES ('JPGMBR02U57Y882U', 42, '59032 Lien Junction', 'M', 'Aristotle', 'Meenan');
INSERT INTO public."Spettatore" VALUES ('SMYXTN15U39H109B', 29, '857 Gulseth Trail', 'M', 'Stanly', 'Acum');
INSERT INTO public."Spettatore" VALUES ('BSYWII80Y72N919S', 48, '687 Village Road', 'M', 'Barbabas', 'Gilhouley');
INSERT INTO public."Spettatore" VALUES ('RXXBZQ39H57T029U', 55, '44 Pennsylvania Circle', 'F', 'Barrie', 'Ever');
INSERT INTO public."Spettatore" VALUES ('VFKGDP51S04V327K', 77, '8922 Buhler Lane', 'M', 'Kent', 'Whitnell');
INSERT INTO public."Spettatore" VALUES ('JYTXNL88E28U648S', 63, '12423 Fieldstone Circle', 'M', 'Florian', 'Bartali');
INSERT INTO public."Spettatore" VALUES ('HHUWOM64G92U959E', 53, '7 5th Drive', 'F', 'Frayda', 'Stains');
INSERT INTO public."Spettatore" VALUES ('VUIUOC03H15I337A', 20, '51 Burrows Street', 'F', 'Marijo', 'Martinez');
INSERT INTO public."Spettatore" VALUES ('CJJPXB36K67T354A', 71, '08958 Bonner Plaza', 'M', 'Steven', 'Steuhlmeyer');
INSERT INTO public."Spettatore" VALUES ('GMPXWN83Y97Z542S', 56, '2529 Northwestern Way', 'F', 'Lenka', 'Highton');
INSERT INTO public."Spettatore" VALUES ('ZCRBLH52M89A630S', 47, '6513 Holmberg Pass', 'M', 'Alastair', 'Kingsley');
INSERT INTO public."Spettatore" VALUES ('RXLXYI23G16E063L', 56, '54 Crowley Street', 'F', 'Charleen', 'Caygill');
INSERT INTO public."Spettatore" VALUES ('FWDAZN80O82Y970X', 28, '8 Barnett Center', 'M', 'Alaric', 'Andriss');
INSERT INTO public."Spettatore" VALUES ('FKNNDJ29T27E042C', 35, '3 Bultman Crossing', 'M', 'Vassili', 'Caddie');
INSERT INTO public."Spettatore" VALUES ('VFEHZF47U32Y654M', 72, '5340 Northland Plaza', 'M', 'Crichton', 'Oxtaby');
INSERT INTO public."Spettatore" VALUES ('HGFYWN58X20J435A', 64, '149 Dawn Crossing', 'F', 'Bennie', 'Tabard');
INSERT INTO public."Spettatore" VALUES ('ZBKJWR50N20Q389Q', 53, '9 6th Way', 'M', 'Kin', 'Fideler');
INSERT INTO public."Spettatore" VALUES ('CHRXEN88A07U793N', 28, '004 4th Point', 'M', 'Frants', 'Matyushkin');
INSERT INTO public."Spettatore" VALUES ('RBESTK98B89D371U', 21, '84 Corry Junction', 'F', 'Athene', 'Hellyar');
INSERT INTO public."Spettatore" VALUES ('EZDYAG61X11J645Z', 34, '05 Hauk Park', 'M', 'Aldrich', 'Callister');
INSERT INTO public."Spettatore" VALUES ('XATSFK23I04X304U', 48, '63210 Esch Trail', 'F', 'Lou', 'Malan');
INSERT INTO public."Spettatore" VALUES ('HTWTXW85N37S634Y', 76, '98280 Di Loreto Crossing', 'F', 'Ricca', 'Sallinger');
INSERT INTO public."Spettatore" VALUES ('UDTULI38S44F357E', 71, '68 Raven Crossing', 'M', 'Giorgio', 'Firmin');
INSERT INTO public."Spettatore" VALUES ('RAJNZI89W91Q905Q', 41, '0815 Muir Pass', 'M', 'Riobard', 'Laye');
INSERT INTO public."Spettatore" VALUES ('QEJTKA98I24A756I', 40, '98 Sullivan Road', 'M', 'Mac', 'Jakobssen');
INSERT INTO public."Spettatore" VALUES ('ABPUZX56Y37Q602Z', 39, '72 Corscot Point', 'F', 'Eveleen', 'Cattenach');
INSERT INTO public."Spettatore" VALUES ('NGNRAV98G61O129K', 76, '882 Ronald Regan Parkway', 'M', 'Carl', 'Dobrowski');
INSERT INTO public."Spettatore" VALUES ('RSXTGY47Z54L008R', 70, '443 Veith Center', 'F', 'Carlynne', 'Miliffe');
INSERT INTO public."Spettatore" VALUES ('VQBMZP58H43V213M', 33, '2692 Elmside Road', 'F', 'Florina', 'Fairfoul');
INSERT INTO public."Spettatore" VALUES ('ITBGBA03D49X346N', 52, '09 Grasskamp Alley', 'M', 'Martyn', 'Stenner');
INSERT INTO public."Spettatore" VALUES ('UPFCQM25J05Z585P', 20, '1 Darwin Circle', 'F', 'Caterina', 'Welbelove');
INSERT INTO public."Spettatore" VALUES ('SHRFKO83L91I509M', 66, '4 Menomonie Avenue', 'F', 'Berna', 'Ferneyhough');
INSERT INTO public."Spettatore" VALUES ('AVBUOF59F40J487E', 34, '0048 Pankratz Hill', 'M', 'Brion', 'Gooders');
INSERT INTO public."Spettatore" VALUES ('PJZSDL96L20A377S', 48, '5 Montana Point', 'F', 'Kandy', 'Winslett');
INSERT INTO public."Spettatore" VALUES ('TBFKJD34L33J148D', 35, '45 Westridge Hill', 'F', 'Gwenneth', 'MacGraith');
INSERT INTO public."Spettatore" VALUES ('VQKGJK73E33S751C', 73, '2907 Schmedeman Alley', 'M', 'Gerome', 'Cleverly');
INSERT INTO public."Spettatore" VALUES ('FNHGFI13F41X538H', 25, '77 Hazelcrest Alley', 'F', 'Fancie', 'Dingate');
INSERT INTO public."Spettatore" VALUES ('BOKQGU97K46Z211E', 63, '7 Fordem Court', 'M', 'Gerrard', 'Ricioppo');
INSERT INTO public."Spettatore" VALUES ('YUSMGT18K58Z312P', 29, '70 Crowley Crossing', 'M', 'Car', 'Hardison');
INSERT INTO public."Spettatore" VALUES ('TLCGLS79M48L963G', 56, '5720 Ridgeway Court', 'M', 'Griswold', 'Pittoli');
INSERT INTO public."Spettatore" VALUES ('CGVQPT07F53W790W', 81, '1512 Parkside Place', 'M', 'Abdul', 'Thurling');
INSERT INTO public."Spettatore" VALUES ('DDTEIF82A52H235K', 51, '6 Miller Pass', 'F', 'Nalani', 'Local');
INSERT INTO public."Spettatore" VALUES ('VKBMDT55V68Y858P', 19, '5636 Weeping Birch Terrace', 'F', 'Candy', 'Yglesia');
INSERT INTO public."Spettatore" VALUES ('OYWJHV99I07H011A', 43, '1755 Hoffman Parkway', 'F', 'Suellen', 'Beining');
INSERT INTO public."Spettatore" VALUES ('GAPPXV88P14Z476D', 79, '0651 Karstens Hill', 'F', 'Kiri', 'Casiroli');
INSERT INTO public."Spettatore" VALUES ('QPGRHH94P37D382V', 21, '13 Granby Hill', 'F', 'Andrei', 'Vasilenko');
INSERT INTO public."Spettatore" VALUES ('NIOYMF92R78V786Y', 68, '73 Debra Pass', 'F', 'Devan', 'Itzhaiek');
INSERT INTO public."Spettatore" VALUES ('GVAEYV84T21C291K', 24, '49411 Truax Lane', 'M', 'Hamlen', 'Kubes');
INSERT INTO public."Spettatore" VALUES ('UZOOAY79Y44O360Q', 23, '3 Summit Pass', 'M', 'Abrahan', 'Bushell');
INSERT INTO public."Spettatore" VALUES ('GUWCZT35H21C484M', 76, '5 Annamark Junction', 'F', 'Ceil', 'Harron');
INSERT INTO public."Spettatore" VALUES ('ODAIYT05U21B917T', 38, '9 Kim Circle', 'F', 'Nissy', 'de Leon');
INSERT INTO public."Spettatore" VALUES ('JYYZDK00I66V054G', 47, '97 Becker Drive', 'F', 'Calli', 'Buckthought');
INSERT INTO public."Spettatore" VALUES ('LYFZRJ04K56B381U', 34, '24 Katie Place', 'M', 'Itch', 'Ligertwood');
INSERT INTO public."Spettatore" VALUES ('LFFTXN98P08K694P', 31, '208 Alpine Crossing', 'F', 'Dallas', 'Strike');
INSERT INTO public."Spettatore" VALUES ('NEBWLJ54T40G921N', 21, '56545 Vermont Lane', 'M', 'Bastian', 'Drewet');
INSERT INTO public."Spettatore" VALUES ('FSBNRB15Z76M386W', 56, '17 Monterey Junction', 'F', 'Mathilde', 'Gladwell');
INSERT INTO public."Spettatore" VALUES ('VAJORE53A67E366K', 73, '18 Spohn Pass', 'F', 'Sibylla', 'Hamlin');
INSERT INTO public."Spettatore" VALUES ('KFQOBJ27D61S276M', 78, '49845 Brickson Park Drive', 'F', 'Ynez', 'Gye');
INSERT INTO public."Spettatore" VALUES ('BSQAND16U62Q823S', 26, '8 Brown Road', 'M', 'Tibold', 'Knoton');
INSERT INTO public."Spettatore" VALUES ('UYEXDX50A25N145F', 19, '843 Larry Center', 'F', 'Ninnette', 'Filippucci');
INSERT INTO public."Spettatore" VALUES ('TBYMFM34U35T619P', 45, '295 Sheridan Park', 'F', 'Sibley', 'Di Batista');
INSERT INTO public."Spettatore" VALUES ('MKQRWP63O97B993S', 52, '6329 Anthes Plaza', 'M', 'Thomas', 'Gentil');
INSERT INTO public."Spettatore" VALUES ('QCBTRG84S39R402U', 71, '1454 Dixon Trail', 'M', 'Haley', 'Valasek');
INSERT INTO public."Spettatore" VALUES ('TJKCDN47Y96R983Q', 34, '00213 Declaration Road', 'F', 'Joannes', 'Jobe');
INSERT INTO public."Spettatore" VALUES ('LOZYDY86L23T762R', 63, '719 Judy Drive', 'F', 'Donetta', 'Yes');
INSERT INTO public."Spettatore" VALUES ('EILEXH98R69O767U', 33, '4 Stuart Terrace', 'F', 'Lydie', 'Maith');
INSERT INTO public."Spettatore" VALUES ('HFIYBZ24D57R206Y', 43, '587 Huxley Avenue', 'F', 'Cassie', 'Duffit');
INSERT INTO public."Spettatore" VALUES ('LAGIAI43P73K469V', 54, '862 Kedzie Junction', 'M', 'Pen', 'Carwithen');
INSERT INTO public."Spettatore" VALUES ('ZWUYVK63Z58R708R', 73, '6614 Corscot Way', 'F', 'Rebeka', 'Brockwell');
INSERT INTO public."Spettatore" VALUES ('OKNILO96O64O184M', 62, '6 Old Gate Center', 'F', 'Maxy', 'Casella');
INSERT INTO public."Spettatore" VALUES ('OPHLAV74Y47E764G', 32, '218 Reindahl Pass', 'M', 'Alberik', 'Wurz');
INSERT INTO public."Spettatore" VALUES ('KEUJZB88L61F278K', 21, '095 Melody Avenue', 'M', 'Arie', 'Brabyn');
INSERT INTO public."Spettatore" VALUES ('JUJTFD12V49D318S', 43, '03539 Mariners Cove Trail', 'F', 'Bibbye', 'Lysaght');
INSERT INTO public."Spettatore" VALUES ('KDLNSE92E34J738E', 19, '6 Paget Alley', 'M', 'Adolphus', 'Linton');
INSERT INTO public."Spettatore" VALUES ('JQBSRW71R60Q537J', 34, '70654 Waubesa Avenue', 'F', 'Lorelle', 'Anselmi');
INSERT INTO public."Spettatore" VALUES ('ENUUQE15Q86B312O', 19, '87762 7th Court', 'F', 'Regina', 'Kilvington');
INSERT INTO public."Spettatore" VALUES ('HEOJYP46G40S412D', 35, '07277 Charing Cross Point', 'M', 'Fred', 'Haberjam');
INSERT INTO public."Spettatore" VALUES ('OXAEAF06H44N066T', 65, '72135 Spaight Road', 'M', 'Bryant', 'Sennett');
INSERT INTO public."Spettatore" VALUES ('WCBVTM56V75A435S', 47, '78 Donald Lane', 'F', 'Ladonna', 'Stife');
INSERT INTO public."Spettatore" VALUES ('GOJTCP00Z45I189I', 33, '1 Eastlawn Avenue', 'F', 'Zara', 'Burgoyne');
INSERT INTO public."Spettatore" VALUES ('EEOGEC51S88N270L', 74, '0 Stephen Junction', 'M', 'Gaspard', 'Bernadot');
INSERT INTO public."Spettatore" VALUES ('WZABTC39J29X504K', 60, '7774 Helena Terrace', 'M', 'Cammy', 'Godrich');
INSERT INTO public."Spettatore" VALUES ('BQMJQT36C62W936X', 28, '7 5th Parkway', 'M', 'Julie', 'Abramof');
INSERT INTO public."Spettatore" VALUES ('XLPESJ57R18M269C', 79, '159 Lakeland Terrace', 'F', 'Katinka', 'Cristofol');
INSERT INTO public."Spettatore" VALUES ('QGKOQN46R05N596V', 21, '490 Nova Lane', 'F', 'Laney', 'Hanbridge');
INSERT INTO public."Spettatore" VALUES ('WZKFQY64Y95N488Z', 80, '141 Orin Street', 'F', 'Tonia', 'Hellier');
INSERT INTO public."Spettatore" VALUES ('NDZODG21A05N907P', 61, '567 Tomscot Avenue', 'M', 'Asa', 'Jorissen');
INSERT INTO public."Spettatore" VALUES ('BHLDPP37Y89Q009T', 64, '52 Nancy Lane', 'M', 'Ruben', 'Flowith');
INSERT INTO public."Spettatore" VALUES ('TMLEON00X97I122B', 71, '34947 Bayside Parkway', 'F', 'Camila', 'Tobin');
INSERT INTO public."Spettatore" VALUES ('EBCBXF55N70Y226W', 55, '852 Badeau Way', 'F', 'Jackelyn', 'Delion');
INSERT INTO public."Spettatore" VALUES ('ECLCCX32J14A669Y', 33, '6152 East Parkway', 'F', 'Rivy', 'Gait');
INSERT INTO public."Spettatore" VALUES ('JNOGEL95K47Q027A', 70, '52 Hallows Avenue', 'M', 'Bruce', 'Suffield');
INSERT INTO public."Spettatore" VALUES ('TCHKRJ18Y01A849M', 55, '3 Roxbury Place', 'M', 'Rourke', 'Osmon');
INSERT INTO public."Spettatore" VALUES ('SPZCVL92X16A257R', 18, '519 Schlimgen Point', 'M', 'Ravi', 'Ramshaw');
INSERT INTO public."Spettatore" VALUES ('QCMUSD73E31I535E', 36, '51 Jackson Hill', 'F', 'Annice', 'Glastonbury');
INSERT INTO public."Spettatore" VALUES ('XALZTI65B06T043A', 59, '2 Sheridan Center', 'F', 'Glennie', 'Gavrielli');
INSERT INTO public."Spettatore" VALUES ('FSDNMA94Q89N076Z', 18, '7 Cascade Pass', 'M', 'Hurlee', 'Burr');
INSERT INTO public."Spettatore" VALUES ('YUQMIS32T67G645U', 68, '41999 Anhalt Avenue', 'M', 'Clem', 'Gummow');
INSERT INTO public."Spettatore" VALUES ('OZXKKZ88F30U513O', 24, '1 4th Trail', 'M', 'Max', 'Spillard');
INSERT INTO public."Spettatore" VALUES ('GHGZWQ23K53B750O', 40, '40 Nobel Road', 'F', 'Elysha', 'Eversfield');
INSERT INTO public."Spettatore" VALUES ('WHOSPY72R13G073D', 22, '75 Anthes Parkway', 'M', 'Jacob', 'Worsam');
INSERT INTO public."Spettatore" VALUES ('DYFPXD06S96L171P', 48, '24610 Cardinal Hill', 'M', 'Garvy', 'Chiechio');
INSERT INTO public."Spettatore" VALUES ('FQSHKQ48S55F243Y', 21, '7384 Drewry Junction', 'M', 'Tait', 'Boynton');
INSERT INTO public."Spettatore" VALUES ('UQCURV12O22F447D', 66, '15 Ryan Avenue', 'F', 'Tracie', 'Millward');
INSERT INTO public."Spettatore" VALUES ('OENBFJ81C86T474W', 58, '4284 New Castle Hill', 'F', 'Opal', 'Hillborne');
INSERT INTO public."Spettatore" VALUES ('HEOGEC70U26J964E', 66, '4 Clyde Gallagher Place', 'F', 'Audie', 'Kleeborn');
INSERT INTO public."Spettatore" VALUES ('NZECBJ03O59M608G', 30, '35 Beilfuss Drive', 'M', 'Karney', 'Keuntje');
INSERT INTO public."Spettatore" VALUES ('BVUGAW07U94X848I', 45, '273 Huxley Crossing', 'M', 'Rance', 'Spurge');
INSERT INTO public."Spettatore" VALUES ('GDSKKE39V71T923K', 25, '5333 Del Mar Hill', 'F', 'Sunshine', 'Shankster');
INSERT INTO public."Spettatore" VALUES ('SFXLNQ39X04K322I', 64, '920 Anthes Street', 'M', 'Dun', 'Strewther');
INSERT INTO public."Spettatore" VALUES ('SGOZZI21T44M027A', 64, '65041 Golf Course Hill', 'M', 'Whitney', 'Horbath');
INSERT INTO public."Spettatore" VALUES ('MVALTG23S99A732U', 23, '3 Reinke Park', 'F', 'Kiah', 'Bell');
INSERT INTO public."Spettatore" VALUES ('OSDSJJ15T62G904Z', 46, '17 Dwight Center', 'M', 'Alexio', 'Donald');
INSERT INTO public."Spettatore" VALUES ('KVTLER19W54O737Z', 71, '26919 Stoughton Park', 'F', 'Sela', 'Malenoir');
INSERT INTO public."Spettatore" VALUES ('UQFARV43I77K031K', 61, '321 Caliangt Parkway', 'M', 'Stanley', 'Symonds');
INSERT INTO public."Spettatore" VALUES ('IDWXWM91X84Y248T', 18, '8 Esch Pass', 'M', 'Alonzo', 'Goble');
INSERT INTO public."Spettatore" VALUES ('VLXPMY69K85X248M', 73, '05 Meadow Ridge Parkway', 'M', 'Giorgio', 'Dawid');
INSERT INTO public."Spettatore" VALUES ('LZMZIH92N53V439U', 55, '578 Cambridge Trail', 'M', 'Obie', 'Feldmesser');
INSERT INTO public."Spettatore" VALUES ('UKSTAF95Y12S318M', 76, '65 Red Cloud Point', 'M', 'Mead', 'Grindell');
INSERT INTO public."Spettatore" VALUES ('OAGAUS27K82U709F', 74, '013 Killdeer Court', 'F', 'Mariya', 'Rolls');
INSERT INTO public."Spettatore" VALUES ('EROOAC65V39G564U', 74, '7 Basil Drive', 'F', 'Meara', 'Steinham');
INSERT INTO public."Spettatore" VALUES ('NYJFOM34J87W874R', 33, '7 Melody Court', 'F', 'Blondy', 'Mabee');
INSERT INTO public."Spettatore" VALUES ('ZIRUTB15W13S994Y', 76, '0049 Superior Avenue', 'F', 'Alex', 'O''Grogane');
INSERT INTO public."Spettatore" VALUES ('HPWFZT75O76S046Q', 78, '0210 Autumn Leaf Parkway', 'M', 'Serge', 'Camidge');
INSERT INTO public."Spettatore" VALUES ('KKEOHV10E25N518K', 38, '6 Declaration Terrace', 'F', 'Hali', 'Bartel');
INSERT INTO public."Spettatore" VALUES ('MNVXSZ00J70K484P', 76, '44469 Knutson Junction', 'M', 'Solly', 'Dake');
INSERT INTO public."Spettatore" VALUES ('SCTSUT53L63S666B', 53, '289 Waxwing Road', 'M', 'Cesare', 'Bernholt');
INSERT INTO public."Spettatore" VALUES ('DJRUKA52V47L675X', 43, '7233 Cardinal Drive', 'F', 'Petunia', 'Phillp');
INSERT INTO public."Spettatore" VALUES ('VIKAYH77F43D258Z', 74, '0 Meadow Valley Hill', 'F', 'Brietta', 'Hirtzmann');
INSERT INTO public."Spettatore" VALUES ('AXDCBJ76X01A225X', 56, '1 Bunting Plaza', 'F', 'Katherina', 'Di Antonio');
INSERT INTO public."Spettatore" VALUES ('WDRIRT45Z33P775G', 74, '172 Mallard Trail', 'M', 'Loren', 'McUre');
INSERT INTO public."Spettatore" VALUES ('GNOEGQ73D34Y613M', 36, '68 Melvin Place', 'M', 'Tedie', 'Cape');
INSERT INTO public."Spettatore" VALUES ('BXEFQS35W75E834J', 39, '77667 Tony Street', 'M', 'Gaby', 'Ronchi');
INSERT INTO public."Spettatore" VALUES ('WKVBAT64N10I586I', 74, '761 Cascade Drive', 'F', 'Vinnie', 'Somerlie');
INSERT INTO public."Spettatore" VALUES ('AJAGPT29A92E350S', 21, '2801 Grayhawk Way', 'M', 'Judon', 'Roches');
INSERT INTO public."Spettatore" VALUES ('OKTBTO08K78E733C', 79, '94 Arrowood Crossing', 'M', 'Grannie', 'Lismore');
INSERT INTO public."Spettatore" VALUES ('MHFSDV03X00Z221Q', 61, '7 Corben Point', 'F', 'Adriane', 'Gubbin');
INSERT INTO public."Spettatore" VALUES ('SOUJDB34N23J336Q', 66, '1568 Hooker Crossing', 'F', 'Pauly', 'Bonson');
INSERT INTO public."Spettatore" VALUES ('GBHTVD05I47D638G', 42, '01599 Waubesa Street', 'M', 'Norbie', 'Burstowe');
INSERT INTO public."Spettatore" VALUES ('DJIBMQ25B42C514F', 73, '3448 Derek Junction', 'M', 'Jesse', 'Mulqueeny');
INSERT INTO public."Spettatore" VALUES ('QYLTNM01Z21O887V', 61, '199 Chinook Drive', 'F', 'Ethelin', 'Kelshaw');
INSERT INTO public."Spettatore" VALUES ('BFUKWQ46W59V277S', 81, '775 Del Sol Center', 'F', 'Leesa', 'Agneau');
INSERT INTO public."Spettatore" VALUES ('KEHSQQ59S20P817Q', 52, '14679 Parkside Court', 'F', 'Teri', 'Saxon');
INSERT INTO public."Spettatore" VALUES ('RQUZWL91L44J264C', 48, '89018 Di Loreto Hill', 'F', 'Fara', 'Starzaker');
INSERT INTO public."Spettatore" VALUES ('UMTFXM98T34O952E', 61, '18 Everett Hill', 'M', 'Bengt', 'Sanney');
INSERT INTO public."Spettatore" VALUES ('MWIBHD13D40V877G', 40, '495 Washington Junction', 'M', 'Rafael', 'Bacher');
INSERT INTO public."Spettatore" VALUES ('WUKRYZ96D28A863E', 42, '49351 Banding Hill', 'F', 'Robenia', 'Veness');
INSERT INTO public."Spettatore" VALUES ('PVSCKU27I27J979R', 45, '241 Larry Drive', 'M', 'Garrek', 'Diss');
INSERT INTO public."Spettatore" VALUES ('ARTUSV89R74V788V', 50, '55 Mendota Center', 'F', 'Isadora', 'Longcake');
INSERT INTO public."Spettatore" VALUES ('FEJNYE87I64N658V', 46, '42 Anthes Way', 'F', 'Emmeline', 'Kener');
INSERT INTO public."Spettatore" VALUES ('QVZMRD38P47E597Z', 71, '1932 Swallow Court', 'F', 'Christie', 'Lindenbluth');
INSERT INTO public."Spettatore" VALUES ('XHPZHY86W32V978D', 54, '63 Brown Hill', 'M', 'Sammy', 'Maneylaws');
INSERT INTO public."Spettatore" VALUES ('QRLKFG20V33M936T', 66, '222 Bobwhite Terrace', 'M', 'Alaster', 'Fellona');
INSERT INTO public."Spettatore" VALUES ('YBWVTO13K55M601I', 50, '6 Kings Avenue', 'F', 'Timmy', 'Vanyard');
INSERT INTO public."Spettatore" VALUES ('QZGSYW33O10G597I', 19, '99 Pleasure Avenue', 'M', 'Kenneth', 'Arnecke');
INSERT INTO public."Spettatore" VALUES ('CGRPTI32W35P148V', 49, '3 Meadow Vale Road', 'F', 'Britt', 'Eshelby');
INSERT INTO public."Spettatore" VALUES ('ESYKTF55P27W524M', 52, '77 Melrose Crossing', 'F', 'Christean', 'Valenta');
INSERT INTO public."Spettatore" VALUES ('OZJEXL94Z21E390O', 39, '396 Fair Oaks Hill', 'F', 'Nerty', 'Hrinishin');
INSERT INTO public."Spettatore" VALUES ('TPYPOA71G84G971A', 60, '19 Talisman Lane', 'M', 'Patricio', 'Behan');
INSERT INTO public."Spettatore" VALUES ('PMCWSM43O07N521V', 72, '89 Lunder Avenue', 'F', 'Addy', 'Draude');
INSERT INTO public."Spettatore" VALUES ('QRBVFC26P58E731S', 62, '59623 Iowa Plaza', 'F', 'Cassi', 'Albiston');
INSERT INTO public."Spettatore" VALUES ('ZGQGAN99Z55S965Z', 62, '713 Maywood Drive', 'F', 'Minetta', 'Gendrich');
INSERT INTO public."Spettatore" VALUES ('BNNCEI00V69Q999S', 30, '53554 Cody Place', 'F', 'Danika', 'Swinglehurst');
INSERT INTO public."Spettatore" VALUES ('JPWKUQ13H63W533Y', 24, '319 Esch Alley', 'F', 'Yoshiko', 'Pomfret');
INSERT INTO public."Spettatore" VALUES ('HQCICX03Z09N477O', 73, '50139 Oak Valley Plaza', 'F', 'Judith', 'Batten');
INSERT INTO public."Spettatore" VALUES ('NUJVIL88H96K436Q', 63, '35474 Scoville Pass', 'F', 'Sadella', 'Gridon');
INSERT INTO public."Spettatore" VALUES ('ICBVPJ32B79R736V', 59, '60 Charing Cross Court', 'M', 'Bendix', 'Sergeant');
INSERT INTO public."Spettatore" VALUES ('GUSASU00V10X460E', 29, '85634 Buhler Street', 'M', 'James', 'Parchment');
INSERT INTO public."Spettatore" VALUES ('HQCVUV12P25K553L', 43, '0 Laurel Road', 'F', 'Bren', 'Grise');
INSERT INTO public."Spettatore" VALUES ('WPQPTW05F67Q730H', 58, '17393 Ridgeview Point', 'F', 'Adan', 'Grimster');
INSERT INTO public."Spettatore" VALUES ('EBHTKI15N84G677T', 55, '10 Haas Street', 'F', 'Lonni', 'Pietrasik');
INSERT INTO public."Spettatore" VALUES ('NAQQJJ31Z17U939Q', 22, '18 Kennedy Pass', 'F', 'Tine', 'Symson');
INSERT INTO public."Spettatore" VALUES ('GHIEPP88C95K151G', 56, '1 Del Mar Trail', 'M', 'Palm', 'MacCague');
INSERT INTO public."Spettatore" VALUES ('OEMKWC45Y18M211A', 20, '24216 Pearson Way', 'F', 'Ruperta', 'Timcke');
INSERT INTO public."Spettatore" VALUES ('RGCWTC09F15G399O', 78, '61 6th Court', 'F', 'Nikkie', 'Rosendahl');
INSERT INTO public."Spettatore" VALUES ('SBPAWH14K56E851B', 60, '767 Hauk Circle', 'M', 'Edlin', 'Langelay');
INSERT INTO public."Spettatore" VALUES ('KSWEVX59H00B933R', 60, '06504 Old Shore Circle', 'F', 'Crin', 'Pauli');
INSERT INTO public."Spettatore" VALUES ('YHSEFP77S09X285A', 78, '41 Milwaukee Avenue', 'F', 'Nessi', 'Antonescu');
INSERT INTO public."Spettatore" VALUES ('QCIMGW26N54H280J', 79, '8083 Mcbride Hill', 'M', 'Adrian', 'Murch');
INSERT INTO public."Spettatore" VALUES ('XRAVKF80T90B159W', 31, '3 Northfield Point', 'F', 'Sada', 'Kann');
INSERT INTO public."Spettatore" VALUES ('GZLXQL57J21J980T', 59, '21 Novick Alley', 'M', 'Barnard', 'Leyband');
INSERT INTO public."Spettatore" VALUES ('KTQEUY94P72H191U', 37, '45 Sachs Alley', 'M', 'Hayward', 'Lages');
INSERT INTO public."Spettatore" VALUES ('HXXFCC47Q10A636U', 61, '17308 Chinook Avenue', 'M', 'Massimo', 'Lestor');
INSERT INTO public."Spettatore" VALUES ('LLAXIS16U19V728I', 29, '19557 Maple Wood Road', 'M', 'Carney', 'Kondratowicz');
INSERT INTO public."Spettatore" VALUES ('RUWSIZ13B32G434K', 72, '2202 Corscot Point', 'F', 'Glennie', 'Rupert');
INSERT INTO public."Spettatore" VALUES ('AOEUVW00K21X000S', 43, '0 Granby Road', 'F', 'Tedda', 'Paskell');
INSERT INTO public."Spettatore" VALUES ('ZYAVKS89Z68G290T', 37, '02698 Toban Circle', 'F', 'Fayette', 'Gerg');
INSERT INTO public."Spettatore" VALUES ('LBKACU15I19W501J', 60, '79610 Caliangt Circle', 'M', 'Warden', 'D''Elia');
INSERT INTO public."Spettatore" VALUES ('YSCJGD43V24T946O', 19, '7 Sutherland Place', 'M', 'Merrill', 'Smitherman');
INSERT INTO public."Spettatore" VALUES ('MYOJLB57O53M398V', 48, '9 Sunfield Lane', 'F', 'Bamby', 'Adanez');
INSERT INTO public."Spettatore" VALUES ('GPCCBV39X20K668B', 72, '2404 Grayhawk Crossing', 'M', 'Mackenzie', 'Duncan');
INSERT INTO public."Spettatore" VALUES ('HXFMLO73N06S771T', 26, '040 Anniversary Center', 'F', 'Drona', 'Bestar');
INSERT INTO public."Spettatore" VALUES ('BGZEAB32G18G121W', 79, '66794 Steensland Place', 'F', 'Noreen', 'Allden');
INSERT INTO public."Spettatore" VALUES ('SBUSKQ62K29L549B', 43, '71 Nova Road', 'F', 'Benoite', 'Epine');
INSERT INTO public."Spettatore" VALUES ('LEZBIB49K44X244Y', 58, '63100 Elmside Park', 'M', 'Herschel', 'McCoughan');
INSERT INTO public."Spettatore" VALUES ('PAFUKB62B65L113X', 38, '41 Parkside Avenue', 'M', 'Keith', 'Westwood');
INSERT INTO public."Spettatore" VALUES ('FETLWA79U55I784N', 45, '7443 Miller Way', 'F', 'Valencia', 'Mattersley');
INSERT INTO public."Spettatore" VALUES ('AWXMQI89U46V757J', 70, '48 Spohn Pass', 'M', 'Arie', 'Van De Cappelle');
INSERT INTO public."Spettatore" VALUES ('ZKBLIO84O25Q562M', 65, '3 Grover Park', 'M', 'Hinze', 'Salaman');
INSERT INTO public."Spettatore" VALUES ('GAFCJB23C38U809N', 40, '1255 Daystar Center', 'M', 'Pierre', 'Bailey');
INSERT INTO public."Spettatore" VALUES ('ZJPTSU19U43H199O', 56, '03815 Birchwood Lane', 'M', 'Avigdor', 'Thexton');
INSERT INTO public."Spettatore" VALUES ('YYCNAJ49M99B363V', 79, '8670 Bayside Alley', 'M', 'Ignatius', 'Vine');
INSERT INTO public."Spettatore" VALUES ('EZWVEM16L14M760R', 56, '0830 Independence Center', 'F', 'Chrystel', 'Clinton');
INSERT INTO public."Spettatore" VALUES ('YPTYFL49R54X616A', 34, '60 Havey Place', 'M', 'Henrik', 'Jonke');
INSERT INTO public."Spettatore" VALUES ('KXGHYN25V48I260G', 80, '67 Straubel Way', 'M', 'Cozmo', 'Milligan');
INSERT INTO public."Spettatore" VALUES ('NYLMBK29U03D768Q', 43, '0 Eastlawn Circle', 'F', 'Devin', 'Doddrell');
INSERT INTO public."Spettatore" VALUES ('ABRWKQ97R06Z890D', 57, '636 Killdeer Circle', 'M', 'Jeff', 'Chyuerton');
INSERT INTO public."Spettatore" VALUES ('XTDSGN66I16K329E', 44, '6718 Granby Alley', 'F', 'Ardys', 'Ennew');
INSERT INTO public."Spettatore" VALUES ('JXZGNQ71L60P483I', 41, '188 Merchant Hill', 'F', 'Carmencita', 'Treven');
INSERT INTO public."Spettatore" VALUES ('OOSZPO70I81R170E', 53, '9494 Melrose Crossing', 'M', 'Trumaine', 'Kirkman');
INSERT INTO public."Spettatore" VALUES ('CYOTLL18Y21O734L', 76, '2335 Morning Street', 'F', 'Sibilla', 'Hoyle');
INSERT INTO public."Spettatore" VALUES ('OKPKCZ35T76D807A', 36, '182 6th Point', 'F', 'Gilberte', 'Zanni');
INSERT INTO public."Spettatore" VALUES ('UQDMBN54J64Y411D', 58, '38 Burrows Plaza', 'F', 'Tonia', 'Will');
INSERT INTO public."Spettatore" VALUES ('WLEHYG59W98S907U', 74, '094 Manufacturers Pass', 'M', 'Colman', 'Dobson');
INSERT INTO public."Spettatore" VALUES ('LNOHRA22N63Y502X', 41, '8876 Morningstar Place', 'M', 'Sarge', 'Cruikshank');
INSERT INTO public."Spettatore" VALUES ('FEOAPS09A57O025T', 47, '77409 Crownhardt Hill', 'M', 'Lance', 'Gurery');
INSERT INTO public."Spettatore" VALUES ('YMAMZJ80L53T768F', 47, '63 Thompson Junction', 'F', 'Loria', 'Francecione');
INSERT INTO public."Spettatore" VALUES ('NRZDXH97M04T879H', 41, '77 Vera Place', 'F', 'Mollee', 'Lowres');
INSERT INTO public."Spettatore" VALUES ('PVMXHW50I83K693X', 76, '8456 Cottonwood Crossing', 'F', 'Ester', 'Lethbrig');
INSERT INTO public."Spettatore" VALUES ('WPJZBS68T12Q791U', 26, '8847 Lakeland Center', 'M', 'Osbourne', 'Coppin');
INSERT INTO public."Spettatore" VALUES ('REGHJI20C14F554V', 48, '75006 Erie Lane', 'F', 'Eliza', 'Vickors');
INSERT INTO public."Spettatore" VALUES ('MDWKIP11I38E969W', 26, '230 Morrow Street', 'M', 'Barth', 'Fehner');
INSERT INTO public."Spettatore" VALUES ('JBMUWX91B22J231G', 74, '63 Caliangt Avenue', 'F', 'Blisse', 'Stuck');
INSERT INTO public."Spettatore" VALUES ('KRRGBO32O84C135D', 66, '742 Golf View Junction', 'M', 'Evelin', 'Pountney');
INSERT INTO public."Spettatore" VALUES ('GVXDRI16Y05P615Q', 46, '828 Elka Park', 'M', 'Loydie', 'Gilby');
INSERT INTO public."Spettatore" VALUES ('OPDTEZ92L54E695Z', 81, '069 Armistice Road', 'M', 'Manfred', 'Ferrario');
INSERT INTO public."Spettatore" VALUES ('JAVKRN37J91I738X', 63, '90714 Reindahl Trail', 'F', 'Lavinia', 'Crotch');
INSERT INTO public."Spettatore" VALUES ('IGWEXN89S59D814U', 27, '32194 Marcy Terrace', 'M', 'Arvin', 'Kettleson');
INSERT INTO public."Spettatore" VALUES ('YFJJGU57R55G869X', 30, '618 Ronald Regan Lane', 'F', 'Madonna', 'Yon');
INSERT INTO public."Spettatore" VALUES ('FHJSTA96N27A333R', 41, '60477 Express Park', 'F', 'Sidonnie', 'Bowra');
INSERT INTO public."Spettatore" VALUES ('BPFRJM86C23Q728Q', 39, '60744 Delaware Lane', 'M', 'Spike', 'Monroe');
INSERT INTO public."Spettatore" VALUES ('YIRMMC77J24K087F', 56, '3 Valley Edge Court', 'F', 'Joyann', 'Brobeck');
INSERT INTO public."Spettatore" VALUES ('FNOKOX64A42I626L', 74, '2 Northview Place', 'F', 'Adrianne', 'Macklam');
INSERT INTO public."Spettatore" VALUES ('ZPLTEH69H01G207R', 60, '0685 Westerfield Park', 'M', 'Guilbert', 'Hulme');
INSERT INTO public."Spettatore" VALUES ('DLNYZT46W15M914S', 18, '76 Porter Circle', 'F', 'Shanda', 'Bemwell');
INSERT INTO public."Spettatore" VALUES ('CJARDU73J46W654V', 34, '618 Sunnyside Parkway', 'M', 'Dannel', 'Spacey');
INSERT INTO public."Spettatore" VALUES ('TQZVNS34Y67P303C', 66, '4 Jackson Parkway', 'M', 'Neale', 'Carncross');
INSERT INTO public."Spettatore" VALUES ('TAEHWA96X23T344V', 34, '1 Village Green Junction', 'M', 'Derk', 'Vowdon');
INSERT INTO public."Spettatore" VALUES ('YHQQWI94S14S852P', 81, '2330 Fordem Junction', 'M', 'Sanson', 'Sandes');
INSERT INTO public."Spettatore" VALUES ('SJULAV38J78Y625S', 55, '407 Stone Corner Lane', 'F', 'Albertine', 'Narramore');
INSERT INTO public."Spettatore" VALUES ('YQXDMO18R89Z084Q', 74, '6 Porter Pass', 'M', 'Rawley', 'Burk');
INSERT INTO public."Spettatore" VALUES ('BMYCAG44D46L419C', 79, '03906 Schurz Parkway', 'M', 'Giuseppe', 'McCluin');
INSERT INTO public."Spettatore" VALUES ('QXYTZK96D96G616P', 57, '6577 Delaware Hill', 'M', 'Brannon', 'Lardnar');
INSERT INTO public."Spettatore" VALUES ('ORAMQW36J69T909X', 24, '95 Coleman Parkway', 'M', 'Errol', 'Atwood');
INSERT INTO public."Spettatore" VALUES ('RFAHUN54S77N952Q', 35, '124 Browning Point', 'M', 'Olav', 'Jewks');
INSERT INTO public."Spettatore" VALUES ('LBFLCP90Q66P816L', 39, '5707 Lerdahl Plaza', 'F', 'Viole', 'Fedynski');
INSERT INTO public."Spettatore" VALUES ('LXZOPW91D32Q442K', 55, '882 Blaine Junction', 'F', 'Perla', 'Gemmill');
INSERT INTO public."Spettatore" VALUES ('JCHLPU82J62W599W', 67, '271 Shasta Parkway', 'F', 'Alexandra', 'Clother');
INSERT INTO public."Spettatore" VALUES ('JFXNKO30K96I017T', 56, '0 Daystar Court', 'M', 'Maddy', 'Gallatly');
INSERT INTO public."Spettatore" VALUES ('TECKZH62X51X332C', 26, '1 Mandrake Point', 'M', 'Noe', 'Dearsley');
INSERT INTO public."Spettatore" VALUES ('ZTZXSP87M31X274K', 21, '05 Comanche Trail', 'F', 'Eilis', 'Lucchi');
INSERT INTO public."Spettatore" VALUES ('SHVYUE60Z79G141W', 26, '066 Nevada Hill', 'F', 'Cinda', 'Liver');
INSERT INTO public."Spettatore" VALUES ('OTEXFY09W12E212E', 56, '67 Mariners Cove Drive', 'M', 'Odo', 'Gerok');
INSERT INTO public."Spettatore" VALUES ('OTDLKJ45V54A925C', 20, '26 Golf Course Alley', 'M', 'Oswald', 'Kohnemann');
INSERT INTO public."Spettatore" VALUES ('LRWXDA35I67B445C', 79, '3 Manley Lane', 'F', 'Minna', 'Dursley');
INSERT INTO public."Spettatore" VALUES ('UBZIQX09O99G504E', 40, '7406 Porter Court', 'M', 'Eldon', 'Koppke');
INSERT INTO public."Spettatore" VALUES ('NBDENI20Q57J849Z', 39, '79825 Manitowish Drive', 'F', 'Eloisa', 'Glancy');
INSERT INTO public."Spettatore" VALUES ('IQIKSS15S23P532O', 67, '21662 Basil Junction', 'M', 'Erl', 'Etheredge');


--
-- TOC entry 3449 (class 0 OID 16705)
-- Dependencies: 227
-- Data for Name: Valutazione_critica; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Valutazione_critica" VALUES ('Last Unicorn, The', 'MIXGDQ63T03W702U', 7, 'Protracted sequences make you impatient for forward motion, but then, in an instant, you’re left to mourn beauties hastened away.');
INSERT INTO public."Valutazione_critica" VALUES ('Bertie and Elizabeth', 'XTERKI29Q22S385S', 10, 'A handbook on cinematic lucidity. All events are described clearly. Motives of all the characters are set right there on the table next to the pasta for our consideration.');
INSERT INTO public."Valutazione_critica" VALUES ('Movie 43', 'UELZJQ07J48C905Z', 9, 'Rear Window lovingly invests in suspense all through the film, banking it in our memory, so that when the final payoff arrives, the whole film has been the thriller equivalent of foreplay.');
INSERT INTO public."Valutazione_critica" VALUES ('Ghostbusters (a.k.a. Ghost Busters)', 'OVOKDX24W63O917N', 10, 'Masterpiece of voyeurism.');
INSERT INTO public."Valutazione_critica" VALUES ('Train on the Brain', 'OVOKDX24W63O917N', 8, 'The film still works beautifully: its complex propagandist subtexts and vision of a reluctantly martial America’s ‘stumbling’ morality still intrigue, just as Bogart’s cult reputation among younger viewers still obtains.');
INSERT INTO public."Valutazione_critica" VALUES ('Electric Boogaloo: The Wild, Untold Story of Cannon Films', 'USMSXS47Q03D495W', 9, 'In its quietly radical grace, it’s a cultural watershed — a work that dismantles all the ways our media view young black men and puts in their place a series of intimate truths. You walk out feeling dazed, more whole, a little cleaner.');
INSERT INTO public."Valutazione_critica" VALUES ('Astronaut Farmer, The', 'XTERKI29Q22S385S', 7, 'Intolerance is thrilling and vital, a collision of historical periods that feels as earth-shaking as the movement of tectonic plates.');
INSERT INTO public."Valutazione_critica" VALUES ('Kit Kittredge: An American Girl', 'QYYLBM41C28F955D', 8, 'Probably the most influential of all silent films after The Birth of a Nation, it launched ideas about associative editing that have been essential to the cinema ever since, from Soviet montage classics to recent American experimental films. And in the use of crosscutting and action to generate suspense, the film''s climax hasn''t been surpassed.');
INSERT INTO public."Valutazione_critica" VALUES ('They Call Me Renegade', 'JHBEAP63Q41A340Y', 8, 'The thematic approach no longer works (if it ever did); the title cards are stiffly Victorian and sometimes laughably pedantic; but the visual poetry is overwhelming, especially in the massed crowd scenes.');
INSERT INTO public."Valutazione_critica" VALUES ('Electric Boogaloo: The Wild, Untold Story of Cannon Films', 'QYYLBM41C28F955D', 10, 'It is a film of much humanity and very far from smart European pap. But the external brilliance of its making does at times subvert its inner workings, as if its manufacture and its meaning were not quite in perfect harmony.');
INSERT INTO public."Valutazione_critica" VALUES ('Gas, Food, Lodging', 'RSBNTC58Y11V067Z', 3, 'The film’s genuine sweetness and affection for its characters go a long way toward compensating for its numbing overfamiliarity.
');
INSERT INTO public."Valutazione_critica" VALUES ('Looking for Eric', 'RSBNTC58Y11V067Z', 6, 'Beyond the tepid cultural commentary, the film has few other redeeming qualities.
');
INSERT INTO public."Valutazione_critica" VALUES ('Outsider', 'MIXGDQ63T03W702U', 4, 'Even when the relentlessly salty humor gets fully crass (a dog is thrown out a high window), the product is bland.');
INSERT INTO public."Valutazione_critica" VALUES ('Being Cyrus', 'ZFADEY53W40T013K', 5, 'I love a good gonzo binge boozing comedy as much as the next guy, but I found almost nothing funny in this.
');
INSERT INTO public."Valutazione_critica" VALUES ('Rovaniemen markkinoilla', 'MIXGDQ63T03W702U', 6, 'It ultimately feels like a counterfeit of priceless treasure: the shape and the gleam of it might be superficially convincing for a bit, but the shabbier craftsmanship gets all the more glaring the longer you look.
');
INSERT INTO public."Valutazione_critica" VALUES ('Red Tent, The (Krasnaya palatka)', 'GWSNLP07U27B761W', 4, 'It opts for too many broad, clunky or far-fetched beats to move the story and its requisite emotional needs forward, rather than weave a more organic, effectively lived-in and, yes, genuinely funny tale.
');
INSERT INTO public."Valutazione_critica" VALUES ('Twilight', 'IHQZWV45F75U829S', 2, 'Stupefyingly sluggish.
');
INSERT INTO public."Valutazione_critica" VALUES ('Last Unicorn, The', 'XTERKI29Q22S385S', 6, 'None of the action scenes have any passion to them and, even worse, they can feel downright contrived. That it then pretends to have something more to say strains credulity.
');
INSERT INTO public."Valutazione_critica" VALUES ('Astronaut Farmer, The', 'QYYLBM41C28F955D', 6, 'What the movie needs is a more coherent story. While keeping an audience off-kilter and disoriented is a worthy goal, particularly in a horror film, it’s got to add up to something. In this case it’s more like meandering.');


--
-- TOC entry 3450 (class 0 OID 16712)
-- Dependencies: 228
-- Data for Name: Valutazione_pubblico; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Valutazione_pubblico" VALUES ('Looking for Eric', 'AVBUOF59F40J487E', 9);
INSERT INTO public."Valutazione_pubblico" VALUES ('Pleasure Seekers, The', 'SHRFKO83L91I509M', 8);
INSERT INTO public."Valutazione_pubblico" VALUES ('Hellfighters', 'UPFCQM25J05Z585P', 6);
INSERT INTO public."Valutazione_pubblico" VALUES ('Hellfighters', 'ITBGBA03D49X346N', 6);
INSERT INTO public."Valutazione_pubblico" VALUES ('Gas, Food, Lodging', 'HTWTXW85N37S634Y', 9);
INSERT INTO public."Valutazione_pubblico" VALUES ('Too Shy to Try (Je suis timide... mais je me soigne)', 'FKNNDJ29T27E042C', 8);
INSERT INTO public."Valutazione_pubblico" VALUES ('Grouse', 'HGFYWN58X20J435A', 7);
INSERT INTO public."Valutazione_pubblico" VALUES ('Wake Island', 'ZCRBLH52M89A630S', 6);
INSERT INTO public."Valutazione_pubblico" VALUES ('An Apology to Elephants', 'ZCRBLH52M89A630S', 5);
INSERT INTO public."Valutazione_pubblico" VALUES ('Ghostbusters (a.k.a. Ghost Busters)', 'TAVZII24X38W157N', 10);


--
-- TOC entry 3265 (class 2606 OID 16664)
-- Name: Attore Attore_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Attore"
    ADD CONSTRAINT "Attore_pkey" PRIMARY KEY ("CF");


--
-- TOC entry 3237 (class 2606 OID 16500)
-- Name: Cinema Cinema_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Cinema"
    ADD CONSTRAINT "Cinema_pkey" PRIMARY KEY ("Nome");


--
-- TOC entry 3250 (class 2606 OID 16599)
-- Name: Contiene Contiene_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Contiene"
    ADD CONSTRAINT "Contiene_pkey" PRIMARY KEY ("Numero_posto", "Numero_sala");


--
-- TOC entry 3259 (class 2606 OID 16649)
-- Name: Critico Critico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Critico"
    ADD CONSTRAINT "Critico_pkey" PRIMARY KEY ("CF");


--
-- TOC entry 3267 (class 2606 OID 16669)
-- Name: Direttore Direttore_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Direttore"
    ADD CONSTRAINT "Direttore_pkey" PRIMARY KEY ("CF");


--
-- TOC entry 3239 (class 2606 OID 16510)
-- Name: Film Film_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Film"
    ADD CONSTRAINT "Film_pkey" PRIMARY KEY ("Titolo");


--
-- TOC entry 3252 (class 2606 OID 16614)
-- Name: Possiede Possiede_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Possiede"
    ADD CONSTRAINT "Possiede_pkey" PRIMARY KEY ("Numero_sala", "Nome_cinema");


--
-- TOC entry 3241 (class 2606 OID 16530)
-- Name: Posto Posto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Posto"
    ADD CONSTRAINT "Posto_pkey" PRIMARY KEY ("Numero");


--
-- TOC entry 3243 (class 2606 OID 16741)
-- Name: Premio Premio_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Premio"
    ADD CONSTRAINT "Premio_pk" PRIMARY KEY ("Nome", "Anno");


--
-- TOC entry 3256 (class 2606 OID 16632)
-- Name: Proiezione Proiezione_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Proiezione"
    ADD CONSTRAINT "Proiezione_pkey" PRIMARY KEY ("Data", "Ora-inizio", "Numero_sala");


--
-- TOC entry 3276 (class 2606 OID 16748)
-- Name: Recita Recita_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Recita"
    ADD CONSTRAINT "Recita_pkey" PRIMARY KEY ("CF_attore", "Nome_film");


--
-- TOC entry 3263 (class 2606 OID 16659)
-- Name: Regista Regista_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Regista"
    ADD CONSTRAINT "Regista_pkey" PRIMARY KEY ("CF");


--
-- TOC entry 3248 (class 2606 OID 16576)
-- Name: Sala Sala_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sala"
    ADD CONSTRAINT "Sala_pkey" PRIMARY KEY ("Numero");


--
-- TOC entry 3261 (class 2606 OID 16654)
-- Name: Spettatore Spettatore_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Spettatore"
    ADD CONSTRAINT "Spettatore_pkey" PRIMARY KEY ("CF");


--
-- TOC entry 3269 (class 2606 OID 16711)
-- Name: Valutazione_critica Valutazione_critica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Valutazione_critica"
    ADD CONSTRAINT "Valutazione_critica_pkey" PRIMARY KEY ("Nome_film", "CF_critico");


--
-- TOC entry 3273 (class 2606 OID 16716)
-- Name: Valutazione_pubblico Valutazione_pubblico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Valutazione_pubblico"
    ADD CONSTRAINT "Valutazione_pubblico_pkey" PRIMARY KEY ("CF_spettatore", "Nome_film");


--
-- TOC entry 3244 (class 1259 OID 16686)
-- Name: fki_Attore_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Attore_fk" ON public."Premio" USING btree ("CF_attore");


--
-- TOC entry 3253 (class 1259 OID 16626)
-- Name: fki_Cinema_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Cinema_fk" ON public."Possiede" USING btree ("Nome_cinema");


--
-- TOC entry 3270 (class 1259 OID 16727)
-- Name: fki_Critico_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Critico_fk" ON public."Valutazione_critica" USING btree ("CF_critico");


--
-- TOC entry 3245 (class 1259 OID 16546)
-- Name: fki_FIlm_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_FIlm_fk" ON public."Premio" USING btree ("Nome_film");


--
-- TOC entry 3257 (class 1259 OID 16643)
-- Name: fki_Film_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Film_fk" ON public."Proiezione" USING btree ("Nome_film");


--
-- TOC entry 3246 (class 1259 OID 16692)
-- Name: fki_Regista_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Regista_fk" ON public."Premio" USING btree ("CF_regista");


--
-- TOC entry 3254 (class 1259 OID 16627)
-- Name: fki_Sala_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Sala_fk" ON public."Possiede" USING btree ("Numero_sala");


--
-- TOC entry 3274 (class 1259 OID 16738)
-- Name: fki_Spettatore_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Spettatore_fk" ON public."Valutazione_pubblico" USING btree ("CF_spettatore");


--
-- TOC entry 3271 (class 1259 OID 16811)
-- Name: recensioni_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recensioni_index ON public."Valutazione_critica" USING btree ("Voto", "Recensione");


--
-- TOC entry 3277 (class 2606 OID 16681)
-- Name: Premio Attore_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Premio"
    ADD CONSTRAINT "Attore_fk" FOREIGN KEY ("CF_attore") REFERENCES public."Attore"("CF");


--
-- TOC entry 3291 (class 2606 OID 16749)
-- Name: Recita Attore_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Recita"
    ADD CONSTRAINT "Attore_fk" FOREIGN KEY ("CF_attore") REFERENCES public."Attore"("CF");


--
-- TOC entry 3282 (class 2606 OID 16615)
-- Name: Possiede Cinema_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Possiede"
    ADD CONSTRAINT "Cinema_fk" FOREIGN KEY ("Nome_cinema") REFERENCES public."Cinema"("Nome");


--
-- TOC entry 3286 (class 2606 OID 16670)
-- Name: Direttore Cinema_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Direttore"
    ADD CONSTRAINT "Cinema_fk" FOREIGN KEY ("Nome-cinema") REFERENCES public."Cinema"("Nome");


--
-- TOC entry 3287 (class 2606 OID 16722)
-- Name: Valutazione_critica Critico_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Valutazione_critica"
    ADD CONSTRAINT "Critico_fk" FOREIGN KEY ("CF_critico") REFERENCES public."Critico"("CF");


--
-- TOC entry 3278 (class 2606 OID 16536)
-- Name: Premio FIlm_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Premio"
    ADD CONSTRAINT "FIlm_fk" FOREIGN KEY ("Nome_film") REFERENCES public."Film"("Titolo");


--
-- TOC entry 3284 (class 2606 OID 16633)
-- Name: Proiezione Film_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Proiezione"
    ADD CONSTRAINT "Film_fk" FOREIGN KEY ("Nome_film") REFERENCES public."Film"("Titolo");


--
-- TOC entry 3288 (class 2606 OID 16717)
-- Name: Valutazione_critica Film_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Valutazione_critica"
    ADD CONSTRAINT "Film_fk" FOREIGN KEY ("Nome_film") REFERENCES public."Film"("Titolo");


--
-- TOC entry 3289 (class 2606 OID 16728)
-- Name: Valutazione_pubblico Film_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Valutazione_pubblico"
    ADD CONSTRAINT "Film_fk" FOREIGN KEY ("Nome_film") REFERENCES public."Film"("Titolo");


--
-- TOC entry 3292 (class 2606 OID 16754)
-- Name: Recita Film_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Recita"
    ADD CONSTRAINT "Film_fk" FOREIGN KEY ("Nome_film") REFERENCES public."Film"("Titolo");


--
-- TOC entry 3280 (class 2606 OID 16600)
-- Name: Contiene Posto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Contiene"
    ADD CONSTRAINT "Posto_fk" FOREIGN KEY ("Numero_posto") REFERENCES public."Posto"("Numero");


--
-- TOC entry 3279 (class 2606 OID 16687)
-- Name: Premio Regista_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Premio"
    ADD CONSTRAINT "Regista_fk" FOREIGN KEY ("CF_regista") REFERENCES public."Regista"("CF");


--
-- TOC entry 3281 (class 2606 OID 16605)
-- Name: Contiene Sala_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Contiene"
    ADD CONSTRAINT "Sala_fk" FOREIGN KEY ("Numero_sala") REFERENCES public."Sala"("Numero");


--
-- TOC entry 3283 (class 2606 OID 16620)
-- Name: Possiede Sala_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Possiede"
    ADD CONSTRAINT "Sala_fk" FOREIGN KEY ("Numero_sala") REFERENCES public."Sala"("Numero");


--
-- TOC entry 3285 (class 2606 OID 16638)
-- Name: Proiezione Sala_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Proiezione"
    ADD CONSTRAINT "Sala_fk" FOREIGN KEY ("Numero_sala") REFERENCES public."Sala"("Numero");


--
-- TOC entry 3290 (class 2606 OID 16733)
-- Name: Valutazione_pubblico Spettatore_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Valutazione_pubblico"
    ADD CONSTRAINT "Spettatore_fk" FOREIGN KEY ("CF_spettatore") REFERENCES public."Spettatore"("CF");


-- Completed on 2023-08-28 21:19:44

--
-- PostgreSQL database dump complete
--

