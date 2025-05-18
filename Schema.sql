DROP TABLE PILOT_INSTRUCTOR;
DROP TABLE PILOT_KART;
DROP TABLE GARAJ_KART;
DROP TABLE LICENTA;
DROP TABLE ECHIPAMENT;
DROP TABLE CERTIFICARE;
DROP TABLE KART;
DROP TABLE GARAJ;
DROP TABLE PILOT;
DROP TABLE INSTRUCTOR;
DROP TABLE SEDIU;

CREATE TABLE SEDIU (
    id_sediu NUMBER(3),
    tara VARCHAR2(20) NOT NULL,
    oras VARCHAR2(30) NOT NULL,
    cod_postal VARCHAR2(12) NOT NULL,
    adresa VARCHAR2(40) NOT NULL,
    tip_sediu VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_sediu PRIMARY KEY (id_sediu),
    CONSTRAINT ck_tip_sediu CHECK (tip_sediu IN ('administrativ', 'inscriere', 'antrenament', 'circuit', 'instruire_teoretica'))
);

CREATE TABLE PILOT (
    id_pilot NUMBER(6),
    nume VARCHAR2(20) NOT NULL,
    prenume VARCHAR2(25) NOT NULL,
    data_nastere DATE NOT NULL,
    email VARCHAR2(40) NOT NULL,
    numar_competitie NUMBER(3) NOT NULL,
    numar_telefon VARCHAR2(20) NOT NULL,
    data_inscriere DATE NOT NULL,
    data_expirare_contract DATE,
    CONSTRAINT pk_pilot PRIMARY KEY (id_pilot),
    CONSTRAINT uk_email_pilot UNIQUE (email),
    CONSTRAINT uk_telefon_pilot UNIQUE (numar_telefon),
    CONSTRAINT ck_numar_competitie CHECK (numar_competitie > 0),
    CONSTRAINT ck_email_format CHECK (email LIKE '%@%.%'),
    CONSTRAINT ck_date_pilot CHECK (data_expirare_contract IS NULL OR data_expirare_contract > data_inscriere
    )
);

CREATE TABLE INSTRUCTOR (
    id_instructor NUMBER(6),
    nume VARCHAR2(20) NOT NULL,
    prenume VARCHAR2(25) NOT NULL,
    data_angajare DATE NOT NULL,
    salariu NUMBER(8,2) NOT NULL,
    email VARCHAR2(40) NOT NULL,
    numar_telefon VARCHAR2(20) NOT NULL,
    data_expirare_contract DATE,
    CONSTRAINT pk_instructor PRIMARY KEY (id_instructor),
    CONSTRAINT uk_email_instructor UNIQUE (email),
    CONSTRAINT uk_telefon_instructor UNIQUE (numar_telefon),
    CONSTRAINT ck_salariu CHECK (salariu > 0),
    CONSTRAINT ck_date_contract CHECK (data_expirare_contract > data_angajare OR data_expirare_contract IS NULL),
    CONSTRAINT ck_email_format_inst CHECK (email LIKE '%@%.%')
);

CREATE TABLE KART (
    id_kart NUMBER(6),
    model VARCHAR2(20) NOT NULL,
    an_fabricatie DATE NOT NULL,
    stare NUMBER(1) NOT NULL,
    putere_motor NUMBER(4,2) NOT NULL,
    CONSTRAINT pk_kart PRIMARY KEY (id_kart),
    CONSTRAINT ck_stare CHECK (stare IN (0, 1)),
    CONSTRAINT ck_putere_pozitiva CHECK (putere_motor > 0),
    CONSTRAINT ck_model CHECK (model IN ('E-KART X1', 'E-KART X2', 'E-KART X3', 'E-KART X4', 'E-KART X5',
                                       'Lite-C Combustion', 'Mission-C Combustion', 'Junior-C Combustion', 
                                       'Kid-C Combustion'))
);

CREATE TABLE GARAJ (
    id_garaj NUMBER(4),
    tip_garaj NUMBER(1) NOT NULL,
    id_sediu NUMBER(3) NOT NULL,
    CONSTRAINT pk_garaj PRIMARY KEY (id_garaj),
    CONSTRAINT fk_garaj_sediu FOREIGN KEY (id_sediu) REFERENCES SEDIU(id_sediu) ON DELETE CASCADE,
    CONSTRAINT ck_tip_garaj CHECK (tip_garaj IN (1, 2, 3))
);

CREATE TABLE CERTIFICARE (
    id_certificare NUMBER(6),
    data_eliberare DATE NOT NULL,
    data_expirare DATE,
    tip_certificare VARCHAR2(20) NOT NULL,
    id_kart NUMBER(6) NOT NULL,
    CONSTRAINT pk_certificare PRIMARY KEY (id_certificare),
    CONSTRAINT fk_certificare_kart FOREIGN KEY (id_kart) REFERENCES KART(id_kart) ON DELETE CASCADE,
    CONSTRAINT ck_date_certificare CHECK (data_expirare IS NULL OR data_expirare > data_eliberare),
    CONSTRAINT ck_tip_certificare CHECK (tip_certificare IN ('siguranta', 'tehnic', 'performanta'))
);

CREATE TABLE ECHIPAMENT (
    id_echipament NUMBER(6),
    marime VARCHAR2(4) NOT NULL,
    data_achizitie DATE NOT NULL,
    tip VARCHAR2(15) NOT NULL,
    id_pilot NUMBER(6) NOT NULL,
    CONSTRAINT pk_echipament PRIMARY KEY (id_echipament),
    CONSTRAINT fk_echipament_pilot FOREIGN KEY (id_pilot) REFERENCES PILOT(id_pilot) ON DELETE CASCADE,
    CONSTRAINT ck_marime CHECK (marime IN ('S', 'M', 'L', 'XL', 'XXL')),
    CONSTRAINT ck_tip_echipament CHECK (tip IN ('casca', 'combinezon', 'ghete', 'manusi'))
);

CREATE TABLE LICENTA (
    id_licenta NUMBER(6),
    tip_licenta VARCHAR2(25) NOT NULL,
    data_eliberare DATE NOT NULL,
    data_expirare DATE NOT NULL,
    id_pilot NUMBER(6) NOT NULL,
    CONSTRAINT pk_licenta PRIMARY KEY (id_licenta),
    CONSTRAINT fk_licenta_pilot FOREIGN KEY (id_pilot) REFERENCES PILOT(id_pilot) ON DELETE CASCADE,
    CONSTRAINT ck_date_licenta CHECK (data_expirare > data_eliberare),
    CONSTRAINT ck_tip_licenta CHECK (tip_licenta IN ('Licenta-B', 'Licenta-A', 'Licenta-B Internationala', 'Licenta-A Internationala'))
);

CREATE TABLE GARAJ_KART (
    id_garaj NUMBER(4),
    id_kart NUMBER(6),
    data_adaugare DATE NOT NULL,
    CONSTRAINT pk_garaj_kart PRIMARY KEY (id_garaj, id_kart),
    CONSTRAINT fk_gk_garaj FOREIGN KEY (id_garaj) REFERENCES GARAJ(id_garaj) ON DELETE CASCADE,
    CONSTRAINT fk_gk_kart FOREIGN KEY (id_kart) REFERENCES KART(id_kart) ON DELETE CASCADE
);

CREATE TABLE PILOT_KART (
    id_pilot NUMBER(6),
    id_kart NUMBER(6),
    data_inceput DATE NOT NULL,
    data_sfarsit DATE,
    CONSTRAINT pk_pilot_kart PRIMARY KEY (id_pilot, id_kart, data_inceput),
    CONSTRAINT fk_pk_pilot FOREIGN KEY (id_pilot) REFERENCES PILOT(id_pilot) ON DELETE CASCADE,
    CONSTRAINT fk_pk_kart FOREIGN KEY (id_kart) REFERENCES KART(id_kart) ON DELETE CASCADE,
    CONSTRAINT ck_date_pilot_kart CHECK (data_sfarsit IS NULL OR data_sfarsit > data_inceput)
);

CREATE TABLE PILOT_INSTRUCTOR (
    id_pilot NUMBER(6),
    id_instructor NUMBER(6),
    data_inceput DATE NOT NULL,
    data_sfarsit DATE,
    CONSTRAINT pk_pilot_instructor PRIMARY KEY (id_pilot, id_instructor, data_inceput),
    CONSTRAINT fk_pi_pilot FOREIGN KEY (id_pilot) REFERENCES PILOT(id_pilot) ON DELETE CASCADE,
    CONSTRAINT fk_pi_instructor FOREIGN KEY (id_instructor) REFERENCES INSTRUCTOR(id_instructor) ON DELETE CASCADE,
    CONSTRAINT ck_date_pi CHECK (data_sfarsit IS NULL OR data_sfarsit > data_inceput)
);

CREATE OR REPLACE TRIGGER trg_validate_garaj_kart
BEFORE INSERT OR UPDATE ON GARAJ_KART
FOR EACH ROW
DECLARE
    v_garaj_tip NUMBER;
    v_kart_stare NUMBER;
    v_kart_model VARCHAR2(20);
BEGIN
    SELECT tip_garaj INTO v_garaj_tip 
    FROM GARAJ 
    WHERE id_garaj = :NEW.id_garaj;
    SELECT stare, model INTO v_kart_stare, v_kart_model
    FROM KART 
    WHERE id_kart = :NEW.id_kart;
    IF v_kart_stare = 0 AND v_garaj_tip != 3 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Kart-urile stricate trebuie plasate in garajele de service');
    END IF;
    
    IF v_kart_stare = 1 THEN
        IF v_kart_model LIKE 'E-KART%' AND v_garaj_tip != 1 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Kart-urile electrice trebuie plasate in garajele de incarcare');
        ELSIF v_kart_model LIKE '% Combustion' AND v_garaj_tip != 2 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Kart-urile cu motor termic trebuie plasate in garajele de combustibil');
        END IF;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_validate_pilot_kart
BEFORE INSERT OR UPDATE ON PILOT_KART
FOR EACH ROW
DECLARE
    v_kart_stare NUMBER;
    v_garaj_tip NUMBER;
    v_pilot_expiry DATE;
BEGIN
    SELECT stare INTO v_kart_stare
    FROM KART WHERE id_kart = :NEW.id_kart;
    SELECT g.tip_garaj INTO v_garaj_tip
    FROM GARAJ g, GARAJ_KART gk
    WHERE gk.id_kart = :NEW.id_kart
    AND gk.id_garaj = g.id_garaj;
    SELECT data_expirare_contract INTO v_pilot_expiry
    FROM PILOT WHERE id_pilot = :NEW.id_pilot;
    IF v_kart_stare = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Kart-urile stricate nu pot fi asignate pilotilor');
    END IF;
    IF v_garaj_tip = 3 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Kart-ul aflat in garajul de service nu poate fi asignat pilotilor');
    END IF;
    IF v_pilot_expiry IS NOT NULL AND :NEW.data_sfarsit > v_pilot_expiry THEN
        RAISE_APPLICATION_ERROR(-20006, 'Pilotii nu pot conduce kart-uri dupa expirarea contractului');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_validate_pilot_instructor
BEFORE INSERT OR UPDATE ON PILOT_INSTRUCTOR
FOR EACH ROW
DECLARE
    v_pilot_expiry DATE;
    v_instructor_expiry DATE;
BEGIN
    SELECT data_expirare_contract INTO v_pilot_expiry
    FROM PILOT WHERE id_pilot = :NEW.id_pilot;
    SELECT data_expirare_contract INTO v_instructor_expiry
    FROM INSTRUCTOR WHERE id_instructor = :NEW.id_instructor;
    IF v_pilot_expiry IS NOT NULL AND :NEW.data_sfarsit > v_pilot_expiry THEN
        RAISE_APPLICATION_ERROR(-20007, 'Perioada de instruire depaseste contractul pilotului');
    END IF;
    IF v_instructor_expiry IS NOT NULL AND :NEW.data_sfarsit > v_instructor_expiry THEN
        RAISE_APPLICATION_ERROR(-20008, 'Perioada de instruire depaseste contractul instructorului');
    END IF;
END;
/

--insert-uri

-- SEDIU
INSERT INTO SEDIU VALUES (1, 'Anglia', 'Silverstone', 'NN12 8TN', 'Silverstone Circuit, Towcester', 'administrativ');
INSERT INTO SEDIU VALUES (2, 'Portugalia', 'Braga', '4700-087', 'Rua do Kartodromo 1', 'inscriere');
INSERT INTO SEDIU VALUES (3, 'Franta', 'Salbris', '41300', '200 Rue des Karting', 'inscriere');
INSERT INTO SEDIU VALUES (4, 'Italia', 'Sarno', '84087', 'Via Sarno-Palma 84087', 'inscriere');
INSERT INTO SEDIU VALUES (5, 'Belgia', 'Mariembourg', '5660', 'Rue du Karting 1', 'inscriere');
INSERT INTO SEDIU VALUES (6, 'Germania', 'Kerpen', '50171', 'Erftlandring 5', 'inscriere');
INSERT INTO SEDIU VALUES (7, 'Japonia', 'Suzuka', '513-8611', '7992 Inoucho, Suzuka', 'inscriere');
INSERT INTO SEDIU VALUES (8, 'Anglia', 'Brandon', 'IP27 0NT', 'Carbone Hill', 'inscriere');
INSERT INTO SEDIU VALUES (11, 'Portugalia', 'Braga', '4700-087', 'Rua do Kartodromo 2', 'antrenament');
INSERT INTO SEDIU VALUES (12, 'Franta', 'Angerville', '91670', '1 Rue du Circuit', 'antrenament');
INSERT INTO SEDIU VALUES (13, 'Italia', 'La Conca', '73049', 'SP 362 Km 18,300', 'antrenament');
INSERT INTO SEDIU VALUES (14, 'Belgia', 'Mariembourg', '5660', 'Rue du Karting 2', 'antrenament');
INSERT INTO SEDIU VALUES (15, 'Germania', 'Kerpen', '50171', 'Erftlandring 7', 'antrenament');
INSERT INTO SEDIU VALUES (16, 'Japonia', 'Suzuka', '513-8611', '7992 Inoucho, Suzuka', 'antrenament');
INSERT INTO SEDIU VALUES (17, 'Anglia', 'Silverstone', 'NN12 8TN', 'Silverstone Circuit, Gate 5', 'antrenament');
INSERT INTO SEDIU VALUES (21, 'Portugalia', 'Braga', '4700-087', 'Kartodromo Internacional de Braga', 'circuit');
INSERT INTO SEDIU VALUES (22, 'Franta', 'Salbris', '41300', 'Circuit International Salbris', 'circuit');
INSERT INTO SEDIU VALUES (23, 'Franta', 'Angerville', '91670', 'Circuit Gabriel Thirouin', 'circuit');
INSERT INTO SEDIU VALUES (24, 'Italia', 'Sarno', '84087', 'Circuito Internazionale Napoli', 'circuit');
INSERT INTO SEDIU VALUES (25, 'Italia', 'La Conca', '73049', 'International Circuit La Conca', 'circuit');
INSERT INTO SEDIU VALUES (26, 'Belgia', 'Mariembourg', '5660', 'Karting des Fagnes', 'circuit');
INSERT INTO SEDIU VALUES (27, 'Germania', 'Kerpen', '50171', 'Michael Schumacher Kart Center', 'circuit');
INSERT INTO SEDIU VALUES (28, 'Japonia', 'Suzuka', '513-8611', 'Suzuka Circuit South Course', 'circuit');
INSERT INTO SEDIU VALUES (29, 'Anglia', 'Silverstone', 'NN12 8TN', 'PFi Circuit', 'circuit');
INSERT INTO SEDIU VALUES (30, 'Anglia', 'Brandon', 'IP27 0NT', 'Glan Y Gors Circuit', 'circuit');
INSERT INTO SEDIU VALUES (31, 'Portugalia', 'Braga', '4700-087', 'Centro de Formacao Braga', 'instruire_teoretica');
INSERT INTO SEDIU VALUES (32, 'Franta', 'Salbris', '41300', 'Centre de Formation Salbris', 'instruire_teoretica');
INSERT INTO SEDIU VALUES (33, 'Italia', 'Sarno', '84087', 'Centro di Formazione Sarno', 'instruire_teoretica');
INSERT INTO SEDIU VALUES (34, 'Belgia', 'Mariembourg', '5660', 'Centre de Formation Mariembourg', 'instruire_teoretica');
INSERT INTO SEDIU VALUES (35, 'Germania', 'Kerpen', '50171', 'Ausbildungszentrum Kerpen', 'instruire_teoretica');
INSERT INTO SEDIU VALUES (36, 'Japonia', 'Suzuka', '513-8611', 'Suzuka Racing School', 'instruire_teoretica');
INSERT INTO SEDIU VALUES (37, 'Anglia', 'Silverstone', 'NN12 8TN', 'Silverstone Training Centre', 'instruire_teoretica');

-- PILOT
INSERT INTO PILOT VALUES (100072, 'Laudato', 'Francesco', TO_DATE('1995-08-12', 'YYYY-MM-DD'), 'francesco.laudato04@yahoo.com', 29, '+39345678930', TO_DATE('2002-08-12', 'YYYY-MM-DD'), TO_DATE('2015-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100073, 'Christensen', 'Michael', TO_DATE('1996-05-17', 'YYYY-MM-DD'), 'michael.christensen06@hotmail.com', 87, '+4520234567', TO_DATE('2004-05-17', 'YYYY-MM-DD'), TO_DATE('2016-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100074, 'Ilott', 'Callum', TO_DATE('1996-10-22', 'YYYY-MM-DD'), 'callum.ilott08@outlook.com', 41, '+44739567896', TO_DATE('2003-10-22', 'YYYY-MM-DD'), TO_DATE('2016-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100075, 'Polo', 'Marco', TO_DATE('1997-04-14', 'YYYY-MM-DD'), 'marco.polo02@gmail.com', 63, '+39345678931', TO_DATE('2005-04-14', 'YYYY-MM-DD'), TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100076, 'Thonon', 'Jonathan', TO_DATE('1997-09-28', 'YYYY-MM-DD'), 'jonathan.thonon04@yahoo.com', 95, '+32615345678', TO_DATE('2006-09-28', 'YYYY-MM-DD'), TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100077, 'Ivanovic', 'Slavko', TO_DATE('1997-11-15', 'YYYY-MM-DD'), 'slavko.ivanovic06@hotmail.com', 18, '+38161234567', TO_DATE('2004-11-15', 'YYYY-MM-DD'), TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100078, 'Catt', 'Gary', TO_DATE('1998-06-11', 'YYYY-MM-DD'), 'gary.catt08@outlook.com', 56, '+44740567897', TO_DATE('2007-06-11', 'YYYY-MM-DD'), TO_DATE('2018-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100079, 'Ahmed', 'Enaam', TO_DATE('1998-11-25', 'YYYY-MM-DD'), 'enaam.ahmed03@gmail.com', 32, '+44741567898', TO_DATE('2005-11-25', 'YYYY-MM-DD'), TO_DATE('2018-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100080, 'Hanley', 'Ben', TO_DATE('1999-07-19', 'YYYY-MM-DD'), 'ben.hanley05@yahoo.com', 79, '+44742567899', TO_DATE('2008-07-19', 'YYYY-MM-DD'), TO_DATE('2019-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100081, 'Baiz', 'Mauricio', TO_DATE('1999-12-30', 'YYYY-MM-DD'), 'mauricio.baiz07@hotmail.com', 47, '+58412345678', TO_DATE('2006-12-30', 'YYYY-MM-DD'), TO_DATE('2019-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100082, 'de Vries', 'Nyck', TO_DATE('2000-05-23', 'YYYY-MM-DD'), 'nyck.devries09@outlook.com', 91, '+31617345678', TO_DATE('2007-05-23', 'YYYY-MM-DD'), TO_DATE('2020-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100083, 'Lammers', 'Bas', TO_DATE('2000-10-15', 'YYYY-MM-DD'), 'bas.lammers02@gmail.com', 64, '+31618345678', TO_DATE('2009-10-15', 'YYYY-MM-DD'), TO_DATE('2020-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100084, 'Alexander', 'Albon', TO_DATE('2001-03-15', 'YYYY-MM-DD'), 'alex.albon03@gmail.com', 23, '+66891234567', TO_DATE('2008-03-15', 'YYYY-MM-DD'), TO_DATE('2021-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100085, 'Vidales', 'David', TO_DATE('2001-08-22', 'YYYY-MM-DD'), 'david.vidales05@yahoo.com', 55, '+34612345678', TO_DATE('2010-08-22', 'YYYY-MM-DD'), TO_DATE('2021-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100086, 'Camponeschi', 'Flavio', TO_DATE('2002-04-10', 'YYYY-MM-DD'), 'flavio.camponeschi07@hotmail.com', 71, '+39345678932', TO_DATE('2009-04-10', 'YYYY-MM-DD'), TO_DATE('2022-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100087, 'Patterson', 'Dexter', TO_DATE('2002-09-18', 'YYYY-MM-DD'), 'dexter.patterson09@outlook.com', 28, '+44743567900', TO_DATE('2011-09-18', 'YYYY-MM-DD'), TO_DATE('2022-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100088, 'Joyner', 'Tom', TO_DATE('2003-02-25', 'YYYY-MM-DD'), 'tom.joyner02@gmail.com', 94, '+44744567901', TO_DATE('2010-02-25', 'YYYY-MM-DD'), TO_DATE('2023-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100089, 'Slater', 'Freddie', TO_DATE('2003-07-30', 'YYYY-MM-DD'), 'freddie.slater04@yahoo.com', 42, '+44745567902', TO_DATE('2012-07-30', 'YYYY-MM-DD'), TO_DATE('2023-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100090, 'Daruvala', 'Jehan', TO_DATE('2004-01-20', 'YYYY-MM-DD'), 'jehan.daruvala06@hotmail.com', 88, '+919812345678', TO_DATE('2011-01-20', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100091, 'Ardigo', 'Arthur', TO_DATE('2004-06-15', 'YYYY-MM-DD'), 'arthur.ardigo08@outlook.com', 15, '+39345678933', TO_DATE('2013-06-15', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100092, 'Basz', 'Karol', TO_DATE('2005-03-08', 'YYYY-MM-DD'), 'karol.basz03@gmail.com', 66, '+48512345678', TO_DATE('2012-03-08', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100093, 'Coronel', 'Rocco', TO_DATE('2005-08-12', 'YYYY-MM-DD'), 'rocco.coronel05@yahoo.com', 37, '+31619345678', TO_DATE('2013-08-12', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100094, 'Hiltbrand', 'Pedro', TO_DATE('2006-05-17', 'YYYY-MM-DD'), 'pedro.hiltbrand07@hotmail.com', 82, '+34613345678', TO_DATE('2014-05-17', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100095, 'Craigie', 'Kenzo', TO_DATE('2006-10-22', 'YYYY-MM-DD'), 'kenzo.craigie09@outlook.com', 19, '+44746567903', TO_DATE('2013-10-22', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100096, 'Keirle', 'Danny', TO_DATE('2007-04-14', 'YYYY-MM-DD'), 'danny.keirle02@gmail.com', 53, '+44747567904', TO_DATE('2015-04-14', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100097, 'De Conto', 'Paolo', TO_DATE('2007-09-28', 'YYYY-MM-DD'), 'paolo.deconto04@yahoo.com', 75, '+39345678934', TO_DATE('2014-09-28', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100098, 'Travisanutto', 'Lorenzo', TO_DATE('2008-06-11', 'YYYY-MM-DD'), 'lorenzo.travisanutto06@hotmail.com', 46, '+39345678935', TO_DATE('2015-06-11', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100099, 'Bradshaw', 'Callum', TO_DATE('2009-02-19', 'YYYY-MM-DD'), 'callum.bradshaw08@outlook.com', 91, '+44748567905', TO_DATE('2016-02-19', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100100, 'Longhi', 'Riccardo', TO_DATE('2009-07-25', 'YYYY-MM-DD'), 'riccardo.longhi03@gmail.com', 27, '+39345678936', TO_DATE('2015-07-25', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100101, 'Turney', 'Joe', TO_DATE('2010-03-30', 'YYYY-MM-DD'), 'joe.turney05@yahoo.com', 64, '+44749567906', TO_DATE('2016-03-30', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100102, 'Bray', 'Daniel', TO_DATE('2010-08-15', 'YYYY-MM-DD'), 'daniel.bray07@hotmail.com', 38, '+6421234567', TO_DATE('2015-08-15', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100103, 'Pollini', 'Giacomo', TO_DATE('2010-11-20', 'YYYY-MM-DD'), 'giacomo.pollini09@outlook.com', 83, '+39345678937', TO_DATE('2016-11-20', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100104, 'Pedersen', 'Oscar', TO_DATE('2012-03-15', 'YYYY-MM-DD'), 'oscar.pedersen02@gmail.com', 44, '+4670234567', TO_DATE('2017-03-15', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100105, 'Carbonnel', 'Arthur', TO_DATE('2012-08-22', 'YYYY-MM-DD'), 'arthur.carbonnel04@hotmail.com', 68, '+33626456789', TO_DATE('2018-08-22', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100106, 'Nakamura-Berta', 'Kean', TO_DATE('2013-04-10', 'YYYY-MM-DD'), 'kean.nakamura06@yahoo.com', 33, '+81345678901', TO_DATE('2019-04-10', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100107, 'Vasile', 'Daniel', TO_DATE('2013-09-18', 'YYYY-MM-DD'), 'daniel.vasile08@gmail.com', 77, '+40712345678', TO_DATE('2018-09-18', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100108, 'Barbieri', 'Giuseppe', TO_DATE('2013-11-25', 'YYYY-MM-DD'), 'giuseppe.barbieri03@outlook.com', 21, '+39345678938', TO_DATE('2019-11-25', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100109, 'Jeff-Hall', 'Ethan', TO_DATE('2014-03-15', 'YYYY-MM-DD'), 'ethan.jeffhall05@hotmail.com', 59, '+44750567907', TO_DATE('2020-03-15', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100110, 'Palomba', 'Giuseppe', TO_DATE('2014-08-22', 'YYYY-MM-DD'), 'giuseppe.palomba07@yahoo.com', 86, '+39345678939', TO_DATE('2019-08-22', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100111, 'Bertuca', 'Cristian', TO_DATE('2014-11-30', 'YYYY-MM-DD'), 'cristian.bertuca09@gmail.com', 42, '+39345678940', TO_DATE('2020-11-30', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100112, 'Popescu', 'Alexandru', TO_DATE('2012-05-15', 'YYYY-MM-DD'), 'alex.popescu@gmail.com', 99, '+40723456789', TO_DATE('2021-06-15', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100113, 'Martinez', 'Carlos', TO_DATE('2012-08-20', 'YYYY-MM-DD'), 'carlos.martinez@hotmail.com', 48, '+34678901234', TO_DATE('2022-07-20', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100114, 'Jensen', 'Magnus', TO_DATE('2014-03-10', 'YYYY-MM-DD'), 'magnus.jensen@outlook.com', 73, '+4591234567', TO_DATE('2023-04-10', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100115, 'Ferrari', 'Marco', TO_DATE('2014-09-25', 'YYYY-MM-DD'), 'marco.ferrari@yahoo.com', 85, '+39345678941', TO_DATE('2024-01-25', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT VALUES (100116, 'Smith', 'John', TO_DATE('2000-03-15', 'YYYY-MM-DD'), 'john.smith@gmail.com', 111, '+44123456789', TO_DATE('2010-03-15', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100117, 'Brown', 'Michael', TO_DATE('2000-09-20', 'YYYY-MM-DD'), 'michael.brown@gmail.com', 112, '+44123456790', TO_DATE('2010-09-20', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100118, 'Davis', 'William', TO_DATE('2001-03-25', 'YYYY-MM-DD'), 'william.davis@gmail.com', 113, '+44123456791', TO_DATE('2011-03-25', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100119, 'Wilson', 'James', TO_DATE('2001-09-30', 'YYYY-MM-DD'), 'james.wilson@gmail.com', 114, '+44123456792', TO_DATE('2011-09-30', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100120, 'Taylor', 'David', TO_DATE('2002-03-15', 'YYYY-MM-DD'), 'david.taylor@gmail.com', 115, '+44123456793', TO_DATE('2012-03-15', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100121, 'Anderson', 'Robert', TO_DATE('2002-09-20', 'YYYY-MM-DD'), 'robert.anderson@gmail.com', 116, '+44123456794', TO_DATE('2012-09-20', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100122, 'Thomas', 'Richard', TO_DATE('2003-03-25', 'YYYY-MM-DD'), 'richard.thomas@gmail.com', 117, '+44123456795', TO_DATE('2013-03-25', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100123, 'Moore', 'Charles', TO_DATE('2003-09-30', 'YYYY-MM-DD'), 'charles.moore@gmail.com', 118, '+44123456796', TO_DATE('2013-09-30', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100124, 'Martin', 'Joseph', TO_DATE('2004-03-15', 'YYYY-MM-DD'), 'joseph.martin@gmail.com', 119, '+44123456797', TO_DATE('2014-03-15', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT VALUES (100125, 'Jackson', 'Daniel', TO_DATE('2004-09-20', 'YYYY-MM-DD'), 'daniel.jackson@gmail.com', 120, '+44123456798', TO_DATE('2014-09-20', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));

-- INSTRUCTOR
INSERT INTO INSTRUCTOR VALUES (200093, 'Mcbride', 'Rihanna', TO_DATE('2000-08-12', 'YYYY-MM-DD'), 655000.25, 'rihanna.mcbride06@hotmail.com', '+44750123043', TO_DATE('2019-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200094, 'Ball', 'Keenan', TO_DATE('2000-08-12', 'YYYY-MM-DD'), 665000, 'keenan.ball08@outlook.com', '+44750123044', TO_DATE('2019-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200095, 'Mcmahon', 'Gerald', TO_DATE('2001-10-22', 'YYYY-MM-DD'), 675000.5, 'gerald.mcmahon03@gmail.com', '+44750123045', TO_DATE('2020-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200096, 'Jordan', 'Craig', TO_DATE('2001-10-22', 'YYYY-MM-DD'), 685000.75, 'craig.jordan05@yahoo.com', '+44750123046', TO_DATE('2020-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200097, 'Waters', 'Maisha', TO_DATE('2002-05-17', 'YYYY-MM-DD'), 695000.25, 'maisha.waters07@hotmail.com', '+44750123047', TO_DATE('2020-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200098, 'Bush', 'Owen', TO_DATE('2002-05-17', 'YYYY-MM-DD'), 705000, 'owen.bush09@outlook.com', '+44750123048', TO_DATE('2020-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200099, 'Edwards', 'Benedict', TO_DATE('2002-11-15', 'YYYY-MM-DD'), 715000.5, 'benedict.edwards02@gmail.com', '+44750123049', TO_DATE('2021-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200100, 'Chase', 'Dean', TO_DATE('2002-11-15', 'YYYY-MM-DD'), 725000.75, 'dean.chase04@yahoo.com', '+44750123050', TO_DATE('2021-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200101, 'Hensley', 'Saad', TO_DATE('2005-09-05', 'YYYY-MM-DD'), 425000.5, 'saad.hensley02@gmail.com', '+44750123051', TO_DATE('2015-12-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200102, 'Oliver', 'Rocco', TO_DATE('2005-12-12', 'YYYY-MM-DD'), 890000.75, 'rocco.oliver04@yahoo.com', '+44750123052', TO_DATE('2014-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200103, 'Palmer', 'Florence', TO_DATE('2006-03-20', 'YYYY-MM-DD'), 235000.25, 'florence.palmer06@hotmail.com', '+44750123053', TO_DATE('2016-03-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200104, 'Hale', 'Anika', TO_DATE('2006-06-15', 'YYYY-MM-DD'), 765000, 'anika.hale08@outlook.com', '+44750123054', TO_DATE('2015-09-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200105, 'Rogers', 'Eshal', TO_DATE('2006-09-28', 'YYYY-MM-DD'), 155000.5, 'eshal.rogers03@gmail.com', '+44750123055', TO_DATE('2016-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200106, 'Anderson', 'Mikey', TO_DATE('2006-12-10', 'YYYY-MM-DD'), 685000.75, 'mikey.anderson05@yahoo.com', '+44750123056', TO_DATE('2015-03-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200107, 'Meadows', 'Gail', TO_DATE('2007-03-25', 'YYYY-MM-DD'), 345000.25, 'gail.meadows07@hotmail.com', '+44750123057', TO_DATE('2016-12-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200108, 'Fernandez', 'Yuvraj', TO_DATE('2007-06-18', 'YYYY-MM-DD'), 895000, 'yuvraj.fernandez09@outlook.com', '+44750123058', TO_DATE('2015-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200109, 'Hardy', 'Neo', TO_DATE('2007-09-30', 'YYYY-MM-DD'), 195000.5, 'neo.hardy02@gmail.com', '+44750123059', TO_DATE('2016-09-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200110, 'Dean', 'Alissa', TO_DATE('2007-12-15', 'YYYY-MM-DD'), 725000.75, 'alissa.dean04@yahoo.com', '+44750123060', TO_DATE('2015-12-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200111, 'Trujillo', 'Clark', TO_DATE('2008-03-10', 'YYYY-MM-DD'), 445000.5, 'clark.trujillo02@gmail.com', '+14155550123', TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200112, 'Friedman', 'Maeve', TO_DATE('2008-06-22', 'YYYY-MM-DD'), 785000.75, 'maeve.friedman04@yahoo.com', '+61478123456', TO_DATE('2016-09-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200113, 'Yang', 'Mason', TO_DATE('2008-09-15', 'YYYY-MM-DD'), 255000.25, 'mason.yang06@hotmail.com', '+819012345678', TO_DATE('2018-03-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200114, 'Hicks', 'Nellie', TO_DATE('2008-12-08', 'YYYY-MM-DD'), 675000, 'nellie.hicks08@outlook.com', '+14165550199', TO_DATE('2017-09-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200115, 'Manning', 'Nieve', TO_DATE('2009-03-20', 'YYYY-MM-DD'), 335000.5, 'nieve.manning03@gmail.com', '+4930123456789', TO_DATE('2018-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200116, 'Mcclain', 'Ffion', TO_DATE('2009-06-15', 'YYYY-MM-DD'), 895000.75, 'ffion.mcclain05@yahoo.com', '+33612345678', TO_DATE('2017-12-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200117, 'O''Sullivan', 'Peter', TO_DATE('2009-09-28', 'YYYY-MM-DD'), 175000.25, 'peter.osullivan07@hotmail.com', '+390123456789', TO_DATE('2019-03-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200118, 'Pitts', 'Emelia', TO_DATE('2009-12-10', 'YYYY-MM-DD'), 555000, 'emelia.pitts09@outlook.com', '+34612345678', TO_DATE('2018-09-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200119, 'Tyler', 'Josie', TO_DATE('2010-03-25', 'YYYY-MM-DD'), 645000.5, 'josie.tyler02@gmail.com', '+919876543210', TO_DATE('2019-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200120, 'Galvan', 'Edwin', TO_DATE('2010-06-18', 'YYYY-MM-DD'), 425000.75, 'edwin.galvan04@yahoo.com', '+447700900123', TO_DATE('2018-12-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200121, 'Logan', 'Wojciech', TO_DATE('2010-09-10', 'YYYY-MM-DD'), 567000.5, 'wojciech.logan02@gmail.com', '+48501234567', TO_DATE('2019-12-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200122, 'Khan', 'Aleena', TO_DATE('2010-12-22', 'YYYY-MM-DD'), 298000.75, 'aleena.khan04@yahoo.com', '+923451234567', TO_DATE('2020-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200123, 'Gardner', 'Phillip', TO_DATE('2011-03-15', 'YYYY-MM-DD'), 842000.25, 'phillip.gardner06@hotmail.com', '+61412987654', TO_DATE('2021-03-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200124, 'Schaefer', 'Kaiden', TO_DATE('2011-06-08', 'YYYY-MM-DD'), 156000, 'kaiden.schaefer08@outlook.com', '+43664987654', TO_DATE('2020-12-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200125, 'Baldwin', 'Kayne', TO_DATE('2011-09-20', 'YYYY-MM-DD'), 735000.5, 'kayne.baldwin03@gmail.com', '+46701234567', TO_DATE('2021-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200126, 'Mcgrath', 'Halima', TO_DATE('2011-12-15', 'YYYY-MM-DD'), 459000.75, 'halima.mcgrath05@yahoo.com', '+971501234567', TO_DATE('2020-09-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200127, 'Gilmore', 'Tyrell', TO_DATE('2012-03-28', 'YYYY-MM-DD'), 623000.25, 'tyrell.gilmore07@hotmail.com', '+5511987654321', TO_DATE('2022-03-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200128, 'Bright', 'Nate', TO_DATE('2012-06-10', 'YYYY-MM-DD'), 378000, 'nate.bright09@outlook.com', '+8613912345678', TO_DATE('2021-12-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200129, 'Espinoza', 'Phyllis', TO_DATE('2012-09-25', 'YYYY-MM-DD'), 891000.5, 'phyllis.espinoza02@gmail.com', '+79161234567', TO_DATE('2022-06-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200130, 'Bolton', 'Gabriel', TO_DATE('2012-12-18', 'YYYY-MM-DD'), 192000.75, 'gabriel.bolton04@yahoo.com', '+972541234567', TO_DATE('2021-09-30', 'YYYY-MM-DD'));
INSERT INTO INSTRUCTOR VALUES (200131, 'Ryan', 'Marco', TO_DATE('2014-03-10', 'YYYY-MM-DD'),478000.50, 'marco.ryan02@gmail.com', '+35850123456', NULL);
INSERT INTO INSTRUCTOR VALUES (200132, 'Newman', 'Anita', TO_DATE('2014-06-22', 'YYYY-MM-DD'),672000.75, 'anita.newman04@yahoo.com', '+27721234567', NULL);
INSERT INTO INSTRUCTOR VALUES (200133, 'Mora', 'Kiana', TO_DATE('2014-09-15', 'YYYY-MM-DD'),243000.25, 'kiana.mora06@hotmail.com', '+5215512345678', NULL);
INSERT INTO INSTRUCTOR VALUES (200134, 'Duran', 'Rhea', TO_DATE('2014-12-08', 'YYYY-MM-DD'),891000.00, 'rhea.duran08@outlook.com', '+85264123456', NULL);
INSERT INTO INSTRUCTOR VALUES (200135, 'Ramsey', 'Yasin', TO_DATE('2015-03-20', 'YYYY-MM-DD'),367000.50, 'yasin.ramsey03@gmail.com', '+6598765432', NULL);
INSERT INTO INSTRUCTOR VALUES (200136, 'Haynes', 'Yahya', TO_DATE('2015-06-15', 'YYYY-MM-DD'),582000.75, 'yahya.haynes05@yahoo.com', '+20109876543', NULL);
INSERT INTO INSTRUCTOR VALUES (200137, 'White', 'Robin', TO_DATE('2015-09-28', 'YYYY-MM-DD'),754000.25, 'robin.white07@hotmail.com', '+351912345678', NULL);
INSERT INTO INSTRUCTOR VALUES (200138, 'Summers', 'Lexi', TO_DATE('2015-12-10', 'YYYY-MM-DD'),429000.00, 'lexi.summers09@outlook.com', '+4670987654', NULL);
INSERT INTO INSTRUCTOR VALUES (200139, 'Carpenter', 'Catherine', TO_DATE('2016-03-25', 'YYYY-MM-DD'),876000.50, 'catherine.carpenter02@gmail.com', '+353871234567', NULL);
INSERT INTO INSTRUCTOR VALUES (200140, 'Carroll', 'Jason', TO_DATE('2016-06-18', 'YYYY-MM-DD'),193000.75, 'jason.carroll04@yahoo.com', '+6421987654', NULL);
INSERT INTO INSTRUCTOR VALUES (200141, 'Bennett', 'Ariana', TO_DATE('2016-09-10', 'YYYY-MM-DD'),647000.50, 'ariana.bennett06@hotmail.com', '+5491123456789', NULL);
INSERT INTO INSTRUCTOR VALUES (200142, 'Whitehead', 'Alina', TO_DATE('2016-12-22', 'YYYY-MM-DD'),528000.75, 'alina.whitehead08@outlook.com', '+420601234567', NULL);
INSERT INTO INSTRUCTOR VALUES (200143, 'Walter', 'Kristian', TO_DATE('2017-03-15', 'YYYY-MM-DD'),739000.25, 'kristian.walter02@gmail.com', '+4550123456', NULL);
INSERT INTO INSTRUCTOR VALUES (200144, 'Sutherland', 'Blaine', TO_DATE('2017-06-08', 'YYYY-MM-DD'),184000.00, 'blaine.sutherland04@yahoo.com', '+12897654321', NULL);
INSERT INTO INSTRUCTOR VALUES (200145, 'Valenzuela', 'Ishaq', TO_DATE('2017-09-20', 'YYYY-MM-DD'),926000.50, 'ishaq.valenzuela06@hotmail.com', '+56912345678', NULL);
INSERT INTO INSTRUCTOR VALUES (200146, 'Mullen', 'Bridie', TO_DATE('2017-12-15', 'YYYY-MM-DD'),374000.75, 'bridie.mullen08@outlook.com', '+6221987654', NULL);
INSERT INTO INSTRUCTOR VALUES (200147, 'Glass', 'Josephine', TO_DATE('2018-03-28', 'YYYY-MM-DD'),562000.25, 'josephine.glass02@gmail.com', '+41791234567', NULL);
INSERT INTO INSTRUCTOR VALUES (200148, 'Carlson', 'Sofia', TO_DATE('2018-06-10', 'YYYY-MM-DD'),843000.00, 'sofia.carlson04@yahoo.com', '+4796123456', NULL);
INSERT INTO INSTRUCTOR VALUES (200149, 'Glover', 'Anna', TO_DATE('2018-09-25', 'YYYY-MM-DD'),267000.50, 'anna.glover06@hotmail.com', '+886912345678', NULL);
INSERT INTO INSTRUCTOR VALUES (200150, 'Knox', 'Raheem', TO_DATE('2018-12-18', 'YYYY-MM-DD'),715000.75, 'raheem.knox08@outlook.com', '+525512345678', NULL);
INSERT INTO INSTRUCTOR VALUES (200151, 'Zimmerman', 'Max', TO_DATE('2019-03-15', 'YYYY-MM-DD'),468000.50, 'max.zimmerman02@gmail.com', '+35812345678', NULL);
INSERT INTO INSTRUCTOR VALUES (200152, 'Huber', 'Ronald', TO_DATE('2020-06-20', 'YYYY-MM-DD'),723000.75, 'ronald.huber04@yahoo.com', '+50761234567', NULL);
INSERT INTO INSTRUCTOR VALUES (200153, 'Hilton', 'Isabel', TO_DATE('2021-09-10', 'YYYY-MM-DD'),356000.25, 'isabel.hilton06@hotmail.com', '+6491234567', NULL);
INSERT INTO INSTRUCTOR VALUES (200154, 'Hampton', 'Lennox', TO_DATE('2022-12-05', 'YYYY-MM-DD'),892000.00, 'lennox.hampton08@outlook.com', '+21621234567', NULL);
INSERT INTO INSTRUCTOR VALUES (200155, 'Preston', 'Rhiannon', TO_DATE('2023-03-20', 'YYYY-MM-DD'),247000.50, 'rhiannon.preston02@gmail.com', '+59891234567', NULL);

-- KART
INSERT INTO KART VALUES (300001, 'E-KART X1', TO_DATE('1982-01-15', 'YYYY-MM-DD'), 0, 12.5);
INSERT INTO KART VALUES (300002, 'E-KART X1', TO_DATE('1982-06-20', 'YYYY-MM-DD'), 1, 12.5);
INSERT INTO KART VALUES (300003, 'E-KART X1', TO_DATE('1982-11-10', 'YYYY-MM-DD'), 1, 12.5);
INSERT INTO KART VALUES (300004, 'E-KART X1', TO_DATE('1983-04-25', 'YYYY-MM-DD'), 1, 12.5);
INSERT INTO KART VALUES (300005, 'E-KART X1', TO_DATE('1983-09-30', 'YYYY-MM-DD'), 1, 12.5);
INSERT INTO KART VALUES (300011, 'E-KART X2', TO_DATE('1986-03-20', 'YYYY-MM-DD'), 0, 15.0);
INSERT INTO KART VALUES (300012, 'E-KART X2', TO_DATE('1986-08-25', 'YYYY-MM-DD'), 1, 15.0);
INSERT INTO KART VALUES (300013, 'E-KART X2', TO_DATE('1987-01-30', 'YYYY-MM-DD'), 1, 15.0);
INSERT INTO KART VALUES (300014, 'E-KART X2', TO_DATE('1987-06-15', 'YYYY-MM-DD'), 1, 15.0);
INSERT INTO KART VALUES (300015, 'E-KART X2', TO_DATE('1987-11-20', 'YYYY-MM-DD'), 1, 15.0);
INSERT INTO KART VALUES (300021, 'E-KART X3', TO_DATE('1990-05-10', 'YYYY-MM-DD'), 0, 17.5);
INSERT INTO KART VALUES (300022, 'E-KART X3', TO_DATE('1990-10-15', 'YYYY-MM-DD'), 1, 17.5);
INSERT INTO KART VALUES (300023, 'E-KART X3', TO_DATE('1991-03-20', 'YYYY-MM-DD'), 1, 17.5);
INSERT INTO KART VALUES (300024, 'E-KART X3', TO_DATE('1991-08-25', 'YYYY-MM-DD'), 1, 17.5);
INSERT INTO KART VALUES (300025, 'E-KART X3', TO_DATE('1992-01-30', 'YYYY-MM-DD'), 1, 17.5);
INSERT INTO KART VALUES (300031, 'E-KART X4', TO_DATE('1994-07-20', 'YYYY-MM-DD'), 0, 20.0);
INSERT INTO KART VALUES (300032, 'E-KART X4', TO_DATE('1994-12-25', 'YYYY-MM-DD'), 1, 20.0);
INSERT INTO KART VALUES (300033, 'E-KART X4', TO_DATE('1995-05-10', 'YYYY-MM-DD'), 1, 20.0);
INSERT INTO KART VALUES (300034, 'E-KART X4', TO_DATE('1995-10-15', 'YYYY-MM-DD'), 1, 20.0);
INSERT INTO KART VALUES (300035, 'E-KART X4', TO_DATE('1996-03-20', 'YYYY-MM-DD'), 1, 20.0);
INSERT INTO KART VALUES (300041, 'E-KART X5', TO_DATE('1998-09-30', 'YYYY-MM-DD'), 0, 22.5);
INSERT INTO KART VALUES (300042, 'E-KART X5', TO_DATE('1999-02-15', 'YYYY-MM-DD'), 1, 22.5);
INSERT INTO KART VALUES (300043, 'E-KART X5', TO_DATE('1999-07-20', 'YYYY-MM-DD'), 1, 22.5);
INSERT INTO KART VALUES (300044, 'E-KART X5', TO_DATE('1999-12-25', 'YYYY-MM-DD'), 1, 22.5);
INSERT INTO KART VALUES (300045, 'E-KART X5', TO_DATE('2000-05-10', 'YYYY-MM-DD'), 1, 22.5);
INSERT INTO KART VALUES (300051, 'Lite-C Combustion', TO_DATE('2002-11-20', 'YYYY-MM-DD'), 0, 25.0);
INSERT INTO KART VALUES (300052, 'Lite-C Combustion', TO_DATE('2003-04-25', 'YYYY-MM-DD'), 1, 25.0);
INSERT INTO KART VALUES (300053, 'Lite-C Combustion', TO_DATE('2003-09-30', 'YYYY-MM-DD'), 1, 25.0);
INSERT INTO KART VALUES (300054, 'Lite-C Combustion', TO_DATE('2004-02-15', 'YYYY-MM-DD'), 1, 25.0);
INSERT INTO KART VALUES (300055, 'Lite-C Combustion', TO_DATE('2004-07-20', 'YYYY-MM-DD'), 1, 25.0);
INSERT INTO KART VALUES (300056, 'Lite-C Combustion', TO_DATE('2004-12-25', 'YYYY-MM-DD'), 1, 25.0);
INSERT INTO KART VALUES (300064, 'Mission-C Combustion', TO_DATE('2008-04-25', 'YYYY-MM-DD'), 0, 27.5);
INSERT INTO KART VALUES (300065, 'Mission-C Combustion', TO_DATE('2008-09-30', 'YYYY-MM-DD'), 1, 27.5);
INSERT INTO KART VALUES (300066, 'Mission-C Combustion', TO_DATE('2009-02-15', 'YYYY-MM-DD'), 1, 27.5);
INSERT INTO KART VALUES (300067, 'Mission-C Combustion', TO_DATE('2009-07-20', 'YYYY-MM-DD'), 1, 27.5);
INSERT INTO KART VALUES (300068, 'Mission-C Combustion', TO_DATE('2009-12-25', 'YYYY-MM-DD'), 1, 27.5);
INSERT INTO KART VALUES (300069, 'Mission-C Combustion', TO_DATE('2010-05-10', 'YYYY-MM-DD'), 1, 27.5);
INSERT INTO KART VALUES (300076, 'Junior-C Combustion', TO_DATE('2013-04-25', 'YYYY-MM-DD'), 0, 25.0);
INSERT INTO KART VALUES (300077, 'Junior-C Combustion', TO_DATE('2013-09-30', 'YYYY-MM-DD'), 1, 25.0);
INSERT INTO KART VALUES (300078, 'Junior-C Combustion', TO_DATE('2014-02-15', 'YYYY-MM-DD'), 1, 25.0);
INSERT INTO KART VALUES (300079, 'Junior-C Combustion', TO_DATE('2014-07-20', 'YYYY-MM-DD'), 1, 25.0);
INSERT INTO KART VALUES (300080, 'Junior-C Combustion', TO_DATE('2014-12-25', 'YYYY-MM-DD'), 1, 25.0);
INSERT INTO KART VALUES (300081, 'Junior-C Combustion', TO_DATE('2015-05-10', 'YYYY-MM-DD'), 1, 25.0);
INSERT INTO KART VALUES (300088, 'Kid-C Combustion', TO_DATE('2018-04-25', 'YYYY-MM-DD'), 0, 22.5);
INSERT INTO KART VALUES (300089, 'Kid-C Combustion', TO_DATE('2018-09-18', 'YYYY-MM-DD'), 1, 22.5);
INSERT INTO KART VALUES (300090, 'Kid-C Combustion', TO_DATE('2019-02-15', 'YYYY-MM-DD'), 1, 22.5);
INSERT INTO KART VALUES (300091, 'Kid-C Combustion', TO_DATE('2019-07-20', 'YYYY-MM-DD'), 1, 22.5);
INSERT INTO KART VALUES (300092, 'Kid-C Combustion', TO_DATE('2019-08-22', 'YYYY-MM-DD'), 1, 22.5);
INSERT INTO KART VALUES (300093, 'Kid-C Combustion', TO_DATE('2020-05-10', 'YYYY-MM-DD'), 1, 22.5);
INSERT INTO KART VALUES (300094, 'E-KART X5', TO_DATE('2021-06-15', 'YYYY-MM-DD'), 1, 22.5);
INSERT INTO KART VALUES (300095, 'E-KART X5', TO_DATE('2022-07-20', 'YYYY-MM-DD'), 1, 22.5);
INSERT INTO KART VALUES (300096, 'E-KART X5', TO_DATE('2023-04-10', 'YYYY-MM-DD'), 1, 22.5);
INSERT INTO KART VALUES (300097, 'E-KART X5', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 1, 22.5);

--GARAJ
INSERT INTO GARAJ VALUES (4001, 1, 21);
INSERT INTO GARAJ VALUES (4002, 1, 21);
INSERT INTO GARAJ VALUES (4003, 2, 21);
INSERT INTO GARAJ VALUES (4004, 2, 21);
INSERT INTO GARAJ VALUES (4005, 3, 21);
INSERT INTO GARAJ VALUES (4006, 1, 22);
INSERT INTO GARAJ VALUES (4007, 1, 22);
INSERT INTO GARAJ VALUES (4008, 2, 22);
INSERT INTO GARAJ VALUES (4009, 2, 22);
INSERT INTO GARAJ VALUES (4010, 3, 22);
INSERT INTO GARAJ VALUES (4011, 1, 23);
INSERT INTO GARAJ VALUES (4012, 1, 23);
INSERT INTO GARAJ VALUES (4013, 2, 23);
INSERT INTO GARAJ VALUES (4014, 2, 23);
INSERT INTO GARAJ VALUES (4015, 3, 23);
INSERT INTO GARAJ VALUES (4016, 1, 24);
INSERT INTO GARAJ VALUES (4017, 1, 24);
INSERT INTO GARAJ VALUES (4018, 2, 24);
INSERT INTO GARAJ VALUES (4019, 2, 24);
INSERT INTO GARAJ VALUES (4020, 3, 24);
INSERT INTO GARAJ VALUES (4021, 1, 25);
INSERT INTO GARAJ VALUES (4022, 1, 25);
INSERT INTO GARAJ VALUES (4023, 2, 25);
INSERT INTO GARAJ VALUES (4024, 2, 25);
INSERT INTO GARAJ VALUES (4025, 3, 25);
INSERT INTO GARAJ VALUES (4026, 1, 26);
INSERT INTO GARAJ VALUES (4027, 1, 26);
INSERT INTO GARAJ VALUES (4028, 2, 26);
INSERT INTO GARAJ VALUES (4029, 2, 26);
INSERT INTO GARAJ VALUES (4030, 3, 26);
INSERT INTO GARAJ VALUES (4031, 1, 27);
INSERT INTO GARAJ VALUES (4032, 1, 27);
INSERT INTO GARAJ VALUES (4033, 2, 27);
INSERT INTO GARAJ VALUES (4034, 2, 27);
INSERT INTO GARAJ VALUES (4035, 3, 27);
INSERT INTO GARAJ VALUES (4036, 1, 28);
INSERT INTO GARAJ VALUES (4037, 1, 28);
INSERT INTO GARAJ VALUES (4038, 2, 28);
INSERT INTO GARAJ VALUES (4039, 2, 28);
INSERT INTO GARAJ VALUES (4040, 3, 28);
INSERT INTO GARAJ VALUES (4041, 1, 29);
INSERT INTO GARAJ VALUES (4042, 1, 29);
INSERT INTO GARAJ VALUES (4043, 2, 29);
INSERT INTO GARAJ VALUES (4044, 2, 29);
INSERT INTO GARAJ VALUES (4045, 3, 29);
INSERT INTO GARAJ VALUES (4046, 1, 30);
INSERT INTO GARAJ VALUES (4047, 1, 30);
INSERT INTO GARAJ VALUES (4048, 2, 30);
INSERT INTO GARAJ VALUES (4049, 2, 30);
INSERT INTO GARAJ VALUES (4050, 3, 30);
INSERT INTO GARAJ VALUES (4051, 1, 11);
INSERT INTO GARAJ VALUES (4052, 1, 11);
INSERT INTO GARAJ VALUES (4053, 2, 11);
INSERT INTO GARAJ VALUES (4054, 2, 11);
INSERT INTO GARAJ VALUES (4055, 3, 11);
INSERT INTO GARAJ VALUES (4056, 1, 12);
INSERT INTO GARAJ VALUES (4057, 1, 12);
INSERT INTO GARAJ VALUES (4058, 2, 12);
INSERT INTO GARAJ VALUES (4059, 2, 12);
INSERT INTO GARAJ VALUES (4060, 3, 12);
INSERT INTO GARAJ VALUES (4061, 1, 13);
INSERT INTO GARAJ VALUES (4062, 1, 13);
INSERT INTO GARAJ VALUES (4063, 2, 13);
INSERT INTO GARAJ VALUES (4064, 2, 13);
INSERT INTO GARAJ VALUES (4065, 3, 13);
INSERT INTO GARAJ VALUES (4066, 1, 14);
INSERT INTO GARAJ VALUES (4067, 1, 14);
INSERT INTO GARAJ VALUES (4068, 2, 14);
INSERT INTO GARAJ VALUES (4069, 2, 14);
INSERT INTO GARAJ VALUES (4070, 3, 14);
INSERT INTO GARAJ VALUES (4071, 1, 15);
INSERT INTO GARAJ VALUES (4072, 1, 15);
INSERT INTO GARAJ VALUES (4073, 2, 15);
INSERT INTO GARAJ VALUES (4074, 2, 15);
INSERT INTO GARAJ VALUES (4075, 3, 15);
INSERT INTO GARAJ VALUES (4076, 1, 16);
INSERT INTO GARAJ VALUES (4077, 1, 16);
INSERT INTO GARAJ VALUES (4078, 2, 16);
INSERT INTO GARAJ VALUES (4079, 2, 16);
INSERT INTO GARAJ VALUES (4080, 3, 16);
INSERT INTO GARAJ VALUES (4081, 1, 17);
INSERT INTO GARAJ VALUES (4082, 1, 17);
INSERT INTO GARAJ VALUES (4083, 2, 17);
INSERT INTO GARAJ VALUES (4084, 2, 17);
INSERT INTO GARAJ VALUES (4085, 3, 17);

--CERTIFICARE
INSERT INTO CERTIFICARE VALUES (500111, TO_DATE('1984-01-15', 'YYYY-MM-DD'), TO_DATE('1991-01-15', 'YYYY-MM-DD'), 'tehnic', 300001);
INSERT INTO CERTIFICARE VALUES (500112, TO_DATE('1984-06-20', 'YYYY-MM-DD'), NULL, 'tehnic', 300002);
INSERT INTO CERTIFICARE VALUES (500113, TO_DATE('1984-11-10', 'YYYY-MM-DD'), NULL, 'tehnic', 300003);
INSERT INTO CERTIFICARE VALUES (500114, TO_DATE('1985-04-25', 'YYYY-MM-DD'), NULL, 'tehnic', 300004);
INSERT INTO CERTIFICARE VALUES (500115, TO_DATE('1985-09-30', 'YYYY-MM-DD'), NULL, 'tehnic', 300005);
INSERT INTO CERTIFICARE VALUES (500121, TO_DATE('1988-03-20', 'YYYY-MM-DD'), TO_DATE('1996-03-20', 'YYYY-MM-DD'), 'tehnic', 300011);
INSERT INTO CERTIFICARE VALUES (500122, TO_DATE('1988-08-25', 'YYYY-MM-DD'), NULL, 'tehnic', 300012);
INSERT INTO CERTIFICARE VALUES (500123, TO_DATE('1989-01-30', 'YYYY-MM-DD'), NULL, 'tehnic', 300013);
INSERT INTO CERTIFICARE VALUES (500124, TO_DATE('1989-06-15', 'YYYY-MM-DD'), NULL, 'tehnic', 300014);
INSERT INTO CERTIFICARE VALUES (500125, TO_DATE('1989-11-20', 'YYYY-MM-DD'), NULL, 'tehnic', 300015);
INSERT INTO CERTIFICARE VALUES (500131, TO_DATE('1992-05-10', 'YYYY-MM-DD'), TO_DATE('1999-05-10', 'YYYY-MM-DD'), 'tehnic', 300021);
INSERT INTO CERTIFICARE VALUES (500132, TO_DATE('1992-10-15', 'YYYY-MM-DD'), NULL, 'tehnic', 300022);
INSERT INTO CERTIFICARE VALUES (500133, TO_DATE('1993-03-20', 'YYYY-MM-DD'), NULL, 'tehnic', 300023);
INSERT INTO CERTIFICARE VALUES (500134, TO_DATE('1993-08-25', 'YYYY-MM-DD'), NULL, 'tehnic', 300024);
INSERT INTO CERTIFICARE VALUES (500135, TO_DATE('1994-01-30', 'YYYY-MM-DD'), NULL, 'tehnic', 300025);
INSERT INTO CERTIFICARE VALUES (500141, TO_DATE('1996-07-20', 'YYYY-MM-DD'), TO_DATE('2004-07-20', 'YYYY-MM-DD'), 'tehnic', 300031);
INSERT INTO CERTIFICARE VALUES (500142, TO_DATE('1996-12-25', 'YYYY-MM-DD'), NULL, 'tehnic', 300032);
INSERT INTO CERTIFICARE VALUES (500143, TO_DATE('1997-05-10', 'YYYY-MM-DD'), NULL, 'tehnic', 300033);
INSERT INTO CERTIFICARE VALUES (500144, TO_DATE('1997-10-15', 'YYYY-MM-DD'), NULL, 'tehnic', 300034);
INSERT INTO CERTIFICARE VALUES (500145, TO_DATE('1998-03-20', 'YYYY-MM-DD'), NULL, 'tehnic', 300035);
INSERT INTO CERTIFICARE VALUES (500151, TO_DATE('2000-09-30', 'YYYY-MM-DD'), TO_DATE('2008-09-30', 'YYYY-MM-DD'), 'tehnic', 300041);
INSERT INTO CERTIFICARE VALUES (500152, TO_DATE('2001-02-15', 'YYYY-MM-DD'), NULL, 'tehnic', 300042);
INSERT INTO CERTIFICARE VALUES (500153, TO_DATE('2001-07-20', 'YYYY-MM-DD'), NULL, 'tehnic', 300043);
INSERT INTO CERTIFICARE VALUES (500154, TO_DATE('2001-12-25', 'YYYY-MM-DD'), NULL, 'tehnic', 300044);
INSERT INTO CERTIFICARE VALUES (500155, TO_DATE('2002-05-10', 'YYYY-MM-DD'), NULL, 'tehnic', 300045);
INSERT INTO CERTIFICARE VALUES (500211, TO_DATE('2004-11-20', 'YYYY-MM-DD'), TO_DATE('2012-11-20', 'YYYY-MM-DD'), 'tehnic', 300051);
INSERT INTO CERTIFICARE VALUES (500212, TO_DATE('2005-04-25', 'YYYY-MM-DD'), NULL, 'tehnic', 300052);
INSERT INTO CERTIFICARE VALUES (500213, TO_DATE('2005-09-30', 'YYYY-MM-DD'), NULL, 'tehnic', 300053);
INSERT INTO CERTIFICARE VALUES (500214, TO_DATE('2006-02-15', 'YYYY-MM-DD'), NULL, 'tehnic', 300054);
INSERT INTO CERTIFICARE VALUES (500215, TO_DATE('2006-07-20', 'YYYY-MM-DD'), NULL, 'tehnic', 300055);
INSERT INTO CERTIFICARE VALUES (500216, TO_DATE('2006-12-25', 'YYYY-MM-DD'), NULL, 'tehnic', 300056);
INSERT INTO CERTIFICARE VALUES (500221, TO_DATE('2010-04-25', 'YYYY-MM-DD'), TO_DATE('2018-04-25', 'YYYY-MM-DD'), 'tehnic', 300064);
INSERT INTO CERTIFICARE VALUES (500222, TO_DATE('2010-09-30', 'YYYY-MM-DD'), NULL, 'tehnic', 300065);
INSERT INTO CERTIFICARE VALUES (500223, TO_DATE('2011-02-15', 'YYYY-MM-DD'), NULL, 'tehnic', 300066);
INSERT INTO CERTIFICARE VALUES (500224, TO_DATE('2011-07-20', 'YYYY-MM-DD'), NULL, 'tehnic', 300067);
INSERT INTO CERTIFICARE VALUES (500225, TO_DATE('2011-12-25', 'YYYY-MM-DD'), NULL, 'tehnic', 300068);
INSERT INTO CERTIFICARE VALUES (500226, TO_DATE('2012-05-10', 'YYYY-MM-DD'), NULL, 'tehnic', 300069);
INSERT INTO CERTIFICARE VALUES (500231, TO_DATE('2015-04-25', 'YYYY-MM-DD'), TO_DATE('2023-04-25', 'YYYY-MM-DD'), 'tehnic', 300076);
INSERT INTO CERTIFICARE VALUES (500232, TO_DATE('2015-09-30', 'YYYY-MM-DD'), NULL, 'tehnic', 300077);
INSERT INTO CERTIFICARE VALUES (500233, TO_DATE('2016-02-15', 'YYYY-MM-DD'), NULL, 'tehnic', 300078);
INSERT INTO CERTIFICARE VALUES (500234, TO_DATE('2016-07-20', 'YYYY-MM-DD'), NULL, 'tehnic', 300079);
INSERT INTO CERTIFICARE VALUES (500235, TO_DATE('2016-12-25', 'YYYY-MM-DD'), NULL, 'tehnic', 300080);
INSERT INTO CERTIFICARE VALUES (500236, TO_DATE('2017-05-10', 'YYYY-MM-DD'), NULL, 'tehnic', 300081);
INSERT INTO CERTIFICARE VALUES (500241, TO_DATE('2020-04-25', 'YYYY-MM-DD'), TO_DATE('2028-04-25', 'YYYY-MM-DD'), 'tehnic', 300088);
INSERT INTO CERTIFICARE VALUES (500242, TO_DATE('2020-09-30', 'YYYY-MM-DD'), NULL, 'tehnic', 300089);
INSERT INTO CERTIFICARE VALUES (500243, TO_DATE('2021-02-15', 'YYYY-MM-DD'), NULL, 'tehnic', 300090);
INSERT INTO CERTIFICARE VALUES (500244, TO_DATE('2021-07-20', 'YYYY-MM-DD'), NULL, 'tehnic', 300091);
INSERT INTO CERTIFICARE VALUES (500245, TO_DATE('2021-12-25', 'YYYY-MM-DD'), NULL, 'tehnic', 300092);
INSERT INTO CERTIFICARE VALUES (500246, TO_DATE('2022-05-10', 'YYYY-MM-DD'), NULL, 'tehnic', 300093);
INSERT INTO CERTIFICARE VALUES (501111, TO_DATE('1984-01-15', 'YYYY-MM-DD'), TO_DATE('1992-01-15', 'YYYY-MM-DD'), 'siguranta', 300001);
INSERT INTO CERTIFICARE VALUES (501112, TO_DATE('1984-06-20', 'YYYY-MM-DD'), NULL, 'siguranta', 300002);
INSERT INTO CERTIFICARE VALUES (501113, TO_DATE('1984-11-10', 'YYYY-MM-DD'), NULL, 'siguranta', 300003);
INSERT INTO CERTIFICARE VALUES (501114, TO_DATE('1985-04-25', 'YYYY-MM-DD'), NULL, 'siguranta', 300004);
INSERT INTO CERTIFICARE VALUES (501115, TO_DATE('1985-09-30', 'YYYY-MM-DD'), NULL, 'siguranta', 300005);
INSERT INTO CERTIFICARE VALUES (501121, TO_DATE('1988-03-20', 'YYYY-MM-DD'), TO_DATE('1996-03-20', 'YYYY-MM-DD'), 'siguranta', 300011);
INSERT INTO CERTIFICARE VALUES (501122, TO_DATE('1988-08-25', 'YYYY-MM-DD'), NULL, 'siguranta', 300012);
INSERT INTO CERTIFICARE VALUES (501123, TO_DATE('1989-01-30', 'YYYY-MM-DD'), NULL, 'siguranta', 300013);
INSERT INTO CERTIFICARE VALUES (501124, TO_DATE('1989-06-15', 'YYYY-MM-DD'), NULL, 'siguranta', 300014);
INSERT INTO CERTIFICARE VALUES (501125, TO_DATE('1989-11-20', 'YYYY-MM-DD'), NULL, 'siguranta', 300015);
INSERT INTO CERTIFICARE VALUES (501131, TO_DATE('1992-05-10', 'YYYY-MM-DD'), TO_DATE('2000-05-10', 'YYYY-MM-DD'), 'siguranta', 300021);
INSERT INTO CERTIFICARE VALUES (501132, TO_DATE('1992-10-15', 'YYYY-MM-DD'), NULL, 'siguranta', 300022);
INSERT INTO CERTIFICARE VALUES (501133, TO_DATE('1993-03-20', 'YYYY-MM-DD'), NULL, 'siguranta', 300023);
INSERT INTO CERTIFICARE VALUES (501134, TO_DATE('1993-08-25', 'YYYY-MM-DD'), NULL, 'siguranta', 300024);
INSERT INTO CERTIFICARE VALUES (501135, TO_DATE('1994-01-30', 'YYYY-MM-DD'), NULL, 'siguranta', 300025);
INSERT INTO CERTIFICARE VALUES (502221, TO_DATE('2010-04-25', 'YYYY-MM-DD'), TO_DATE('2018-04-25', 'YYYY-MM-DD'), 'performanta', 300064);
INSERT INTO CERTIFICARE VALUES (502222, TO_DATE('2010-09-30', 'YYYY-MM-DD'), NULL, 'performanta', 300065);
INSERT INTO CERTIFICARE VALUES (502223, TO_DATE('2011-02-15', 'YYYY-MM-DD'), NULL, 'performanta', 300066);
INSERT INTO CERTIFICARE VALUES (502224, TO_DATE('2011-07-20', 'YYYY-MM-DD'), NULL, 'performanta', 300067);
INSERT INTO CERTIFICARE VALUES (502225, TO_DATE('2011-12-25', 'YYYY-MM-DD'), NULL, 'performanta', 300068);
INSERT INTO CERTIFICARE VALUES (502226, TO_DATE('2012-05-10', 'YYYY-MM-DD'), NULL, 'performanta', 300069);
INSERT INTO CERTIFICARE VALUES (500247, TO_DATE('2021-06-15', 'YYYY-MM-DD'), NULL, 'tehnic', 300094);
INSERT INTO CERTIFICARE VALUES (500248, TO_DATE('2022-07-20', 'YYYY-MM-DD'), NULL, 'tehnic', 300095);
INSERT INTO CERTIFICARE VALUES (500249, TO_DATE('2023-04-10', 'YYYY-MM-DD'), NULL, 'tehnic', 300096);
INSERT INTO CERTIFICARE VALUES (500250, TO_DATE('2024-01-25', 'YYYY-MM-DD'), NULL, 'tehnic', 300097);

--ECHIPAMENT
INSERT INTO ECHIPAMENT VALUES (600001, 'M', TO_DATE('2002-08-19', 'YYYY-MM-DD'), 'combinezon', 100072);
INSERT INTO ECHIPAMENT VALUES (600002, 'L', TO_DATE('2004-05-24', 'YYYY-MM-DD'), 'combinezon', 100073);
INSERT INTO ECHIPAMENT VALUES (600003, 'XL', TO_DATE('2003-10-29', 'YYYY-MM-DD'), 'combinezon', 100074);
INSERT INTO ECHIPAMENT VALUES (600004, 'XXL', TO_DATE('2005-04-21', 'YYYY-MM-DD'), 'combinezon', 100075);
INSERT INTO ECHIPAMENT VALUES (600005, 'S', TO_DATE('2006-10-05', 'YYYY-MM-DD'), 'combinezon', 100076);
INSERT INTO ECHIPAMENT VALUES (600006, 'M', TO_DATE('2004-11-22', 'YYYY-MM-DD'), 'combinezon', 100077);
INSERT INTO ECHIPAMENT VALUES (600007, 'L', TO_DATE('2007-06-18', 'YYYY-MM-DD'), 'combinezon', 100078);
INSERT INTO ECHIPAMENT VALUES (600008, 'XL', TO_DATE('2005-12-02', 'YYYY-MM-DD'), 'combinezon', 100079);
INSERT INTO ECHIPAMENT VALUES (600009, 'XXL', TO_DATE('2008-07-26', 'YYYY-MM-DD'), 'combinezon', 100080);
INSERT INTO ECHIPAMENT VALUES (600010, 'S', TO_DATE('2007-01-06', 'YYYY-MM-DD'), 'combinezon', 100081);
INSERT INTO ECHIPAMENT VALUES (600011, 'M', TO_DATE('2007-05-30', 'YYYY-MM-DD'), 'combinezon', 100082);
INSERT INTO ECHIPAMENT VALUES (600012, 'L', TO_DATE('2009-10-22', 'YYYY-MM-DD'), 'combinezon', 100083);
INSERT INTO ECHIPAMENT VALUES (600013, 'XL', TO_DATE('2008-03-22', 'YYYY-MM-DD'), 'combinezon', 100084);
INSERT INTO ECHIPAMENT VALUES (600014, 'XXL', TO_DATE('2010-08-29', 'YYYY-MM-DD'), 'combinezon', 100085);
INSERT INTO ECHIPAMENT VALUES (600015, 'S', TO_DATE('2009-04-17', 'YYYY-MM-DD'), 'combinezon', 100086);
INSERT INTO ECHIPAMENT VALUES (600016, 'M', TO_DATE('2011-09-25', 'YYYY-MM-DD'), 'combinezon', 100087);
INSERT INTO ECHIPAMENT VALUES (600017, 'L', TO_DATE('2010-03-04', 'YYYY-MM-DD'), 'combinezon', 100088);
INSERT INTO ECHIPAMENT VALUES (600018, 'XL', TO_DATE('2012-08-06', 'YYYY-MM-DD'), 'combinezon', 100089);
INSERT INTO ECHIPAMENT VALUES (600019, 'XXL', TO_DATE('2011-01-27', 'YYYY-MM-DD'), 'combinezon', 100090);
INSERT INTO ECHIPAMENT VALUES (600020, 'S', TO_DATE('2013-06-22', 'YYYY-MM-DD'), 'combinezon', 100091);
INSERT INTO ECHIPAMENT VALUES (600021, 'L', TO_DATE('2012-03-15', 'YYYY-MM-DD'), 'combinezon', 100092);
INSERT INTO ECHIPAMENT VALUES (600022, 'M', TO_DATE('2013-08-19', 'YYYY-MM-DD'), 'combinezon', 100093);
INSERT INTO ECHIPAMENT VALUES (600023, 'L', TO_DATE('2014-05-24', 'YYYY-MM-DD'), 'combinezon', 100094);
INSERT INTO ECHIPAMENT VALUES (600024, 'M', TO_DATE('2013-10-29', 'YYYY-MM-DD'), 'combinezon', 100095);
INSERT INTO ECHIPAMENT VALUES (600025, 'XXL', TO_DATE('2015-04-21', 'YYYY-MM-DD'), 'combinezon', 100096);
INSERT INTO ECHIPAMENT VALUES (600026, 'L', TO_DATE('2014-10-05', 'YYYY-MM-DD'), 'combinezon', 100097);
INSERT INTO ECHIPAMENT VALUES (600027, 'M', TO_DATE('2015-06-18', 'YYYY-MM-DD'), 'combinezon', 100098);
INSERT INTO ECHIPAMENT VALUES (600028, 'XL', TO_DATE('2016-02-26', 'YYYY-MM-DD'), 'combinezon', 100099);
INSERT INTO ECHIPAMENT VALUES (600029, 'L', TO_DATE('2015-08-01', 'YYYY-MM-DD'), 'combinezon', 100100);
INSERT INTO ECHIPAMENT VALUES (600030, 'M', TO_DATE('2016-04-06', 'YYYY-MM-DD'), 'combinezon', 100101);
INSERT INTO ECHIPAMENT VALUES (600031, 'L', TO_DATE('2015-08-22', 'YYYY-MM-DD'), 'combinezon', 100102);
INSERT INTO ECHIPAMENT VALUES (600032, 'S', TO_DATE('2016-11-27', 'YYYY-MM-DD'), 'combinezon', 100103);
INSERT INTO ECHIPAMENT VALUES (600033, 'M', TO_DATE('2017-03-22', 'YYYY-MM-DD'), 'combinezon', 100104);
INSERT INTO ECHIPAMENT VALUES (600034, 'L', TO_DATE('2018-08-29', 'YYYY-MM-DD'), 'combinezon', 100105);
INSERT INTO ECHIPAMENT VALUES (600035, 'M', TO_DATE('2019-04-17', 'YYYY-MM-DD'), 'combinezon', 100106);
INSERT INTO ECHIPAMENT VALUES (600036, 'L', TO_DATE('2018-09-25', 'YYYY-MM-DD'), 'combinezon', 100107);
INSERT INTO ECHIPAMENT VALUES (600037, 'XL', TO_DATE('2019-12-02', 'YYYY-MM-DD'), 'combinezon', 100108);
INSERT INTO ECHIPAMENT VALUES (600038, 'M', TO_DATE('2020-03-22', 'YYYY-MM-DD'), 'combinezon', 100109);
INSERT INTO ECHIPAMENT VALUES (600039, 'L', TO_DATE('2019-08-29', 'YYYY-MM-DD'), 'combinezon', 100110);
INSERT INTO ECHIPAMENT VALUES (600040, 'S', TO_DATE('2020-12-07', 'YYYY-MM-DD'), 'combinezon', 100111);
INSERT INTO ECHIPAMENT VALUES (600041, 'XL', TO_DATE('2019-11-30', 'YYYY-MM-DD'), 'combinezon', 100107);
INSERT INTO ECHIPAMENT VALUES (600042, 'M', TO_DATE('2002-08-19', 'YYYY-MM-DD'), 'casca', 100072);
INSERT INTO ECHIPAMENT VALUES (600043, 'L', TO_DATE('2004-05-24', 'YYYY-MM-DD'), 'casca', 100073);
INSERT INTO ECHIPAMENT VALUES (600044, 'XL', TO_DATE('2003-10-29', 'YYYY-MM-DD'), 'casca', 100074);
INSERT INTO ECHIPAMENT VALUES (600045, 'XXL', TO_DATE('2005-04-21', 'YYYY-MM-DD'), 'casca', 100075);
INSERT INTO ECHIPAMENT VALUES (600046, 'S', TO_DATE('2006-10-05', 'YYYY-MM-DD'), 'casca', 100076);
INSERT INTO ECHIPAMENT VALUES (600047, 'M', TO_DATE('2004-11-22', 'YYYY-MM-DD'), 'casca', 100077);
INSERT INTO ECHIPAMENT VALUES (600048, 'L', TO_DATE('2007-06-18', 'YYYY-MM-DD'), 'casca', 100078);
INSERT INTO ECHIPAMENT VALUES (600049, 'XL', TO_DATE('2005-12-02', 'YYYY-MM-DD'), 'casca', 100079);
INSERT INTO ECHIPAMENT VALUES (600050, 'XXL', TO_DATE('2008-07-26', 'YYYY-MM-DD'), 'casca', 100080);
INSERT INTO ECHIPAMENT VALUES (600051, 'S', TO_DATE('2007-01-06', 'YYYY-MM-DD'), 'casca', 100081);
INSERT INTO ECHIPAMENT VALUES (600052, 'M', TO_DATE('2007-05-30', 'YYYY-MM-DD'), 'ghete', 100082);
INSERT INTO ECHIPAMENT VALUES (600053, 'L', TO_DATE('2009-10-22', 'YYYY-MM-DD'), 'ghete', 100083);
INSERT INTO ECHIPAMENT VALUES (600054, 'XL', TO_DATE('2008-03-22', 'YYYY-MM-DD'), 'ghete', 100084);
INSERT INTO ECHIPAMENT VALUES (600055, 'XXL', TO_DATE('2010-08-29', 'YYYY-MM-DD'), 'ghete', 100085);
INSERT INTO ECHIPAMENT VALUES (600056, 'S', TO_DATE('2009-04-17', 'YYYY-MM-DD'), 'ghete', 100086);
INSERT INTO ECHIPAMENT VALUES (600057, 'M', TO_DATE('2011-09-25', 'YYYY-MM-DD'), 'ghete', 100087);
INSERT INTO ECHIPAMENT VALUES (600058, 'L', TO_DATE('2010-03-04', 'YYYY-MM-DD'), 'ghete', 100088);
INSERT INTO ECHIPAMENT VALUES (600059, 'XL', TO_DATE('2012-08-06', 'YYYY-MM-DD'), 'ghete', 100089);
INSERT INTO ECHIPAMENT VALUES (600060, 'XXL', TO_DATE('2011-01-27', 'YYYY-MM-DD'), 'ghete', 100090);
INSERT INTO ECHIPAMENT VALUES (600061, 'S', TO_DATE('2013-06-22', 'YYYY-MM-DD'), 'ghete', 100091);
INSERT INTO ECHIPAMENT VALUES (600062, 'L', TO_DATE('2012-03-15', 'YYYY-MM-DD'), 'manusi', 100092);
INSERT INTO ECHIPAMENT VALUES (600063, 'M', TO_DATE('2013-08-19', 'YYYY-MM-DD'), 'manusi', 100093);
INSERT INTO ECHIPAMENT VALUES (600064, 'L', TO_DATE('2014-05-24', 'YYYY-MM-DD'), 'manusi', 100094);
INSERT INTO ECHIPAMENT VALUES (600065, 'M', TO_DATE('2013-10-29', 'YYYY-MM-DD'), 'manusi', 100095);
INSERT INTO ECHIPAMENT VALUES (600066, 'XXL', TO_DATE('2015-04-21', 'YYYY-MM-DD'), 'manusi', 100096);
INSERT INTO ECHIPAMENT VALUES (600067, 'L', TO_DATE('2014-10-05', 'YYYY-MM-DD'), 'manusi', 100097);
INSERT INTO ECHIPAMENT VALUES (600068, 'M', TO_DATE('2015-06-18', 'YYYY-MM-DD'), 'manusi', 100098);
INSERT INTO ECHIPAMENT VALUES (600069, 'XL', TO_DATE('2016-02-26', 'YYYY-MM-DD'), 'manusi', 100099);
INSERT INTO ECHIPAMENT VALUES (600070, 'L', TO_DATE('2015-08-01', 'YYYY-MM-DD'), 'manusi', 100100);
INSERT INTO ECHIPAMENT VALUES (600071, 'M', TO_DATE('2016-04-06', 'YYYY-MM-DD'), 'manusi', 100101);
INSERT INTO ECHIPAMENT VALUES (600072, 'L', TO_DATE('2015-08-22', 'YYYY-MM-DD'), 'manusi', 100102);
INSERT INTO ECHIPAMENT VALUES (600073, 'S', TO_DATE('2016-11-27', 'YYYY-MM-DD'), 'manusi', 100103);
INSERT INTO ECHIPAMENT VALUES (600074, 'M', TO_DATE('2017-03-22', 'YYYY-MM-DD'), 'manusi', 100104);
INSERT INTO ECHIPAMENT VALUES (600075, 'L', TO_DATE('2018-08-29', 'YYYY-MM-DD'), 'manusi', 100105);
INSERT INTO ECHIPAMENT VALUES (600076, 'M', TO_DATE('2019-04-17', 'YYYY-MM-DD'), 'manusi', 100106);
INSERT INTO ECHIPAMENT VALUES (600077, 'L', TO_DATE('2018-09-25', 'YYYY-MM-DD'), 'manusi', 100107);
INSERT INTO ECHIPAMENT VALUES (600078, 'XL', TO_DATE('2019-12-02', 'YYYY-MM-DD'), 'manusi', 100108);
INSERT INTO ECHIPAMENT VALUES (600079, 'M', TO_DATE('2020-03-22', 'YYYY-MM-DD'), 'manusi', 100109);
INSERT INTO ECHIPAMENT VALUES (600080, 'L', TO_DATE('2019-08-29', 'YYYY-MM-DD'), 'manusi', 100110);
INSERT INTO ECHIPAMENT VALUES (600081, 'S', TO_DATE('2020-12-07', 'YYYY-MM-DD'), 'manusi', 100111);
INSERT INTO ECHIPAMENT VALUES (600082, 'M', TO_DATE('2021-06-15', 'YYYY-MM-DD'), 'combinezon', 100112);
INSERT INTO ECHIPAMENT VALUES (600097, 'L', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 'manusi', 100115);
INSERT INTO ECHIPAMENT VALUES (600098, 'M', TO_DATE('2010-03-22', 'YYYY-MM-DD'), 'combinezon', 100116);
INSERT INTO ECHIPAMENT VALUES (600099, 'M', TO_DATE('2010-03-22', 'YYYY-MM-DD'), 'casca', 100116);
INSERT INTO ECHIPAMENT VALUES (600100, 'M', TO_DATE('2010-03-22', 'YYYY-MM-DD'), 'ghete', 100116);
INSERT INTO ECHIPAMENT VALUES (600101, 'M', TO_DATE('2010-03-22', 'YYYY-MM-DD'), 'manusi', 100116);
INSERT INTO ECHIPAMENT VALUES (600102, 'L', TO_DATE('2010-09-27', 'YYYY-MM-DD'), 'combinezon', 100117);
INSERT INTO ECHIPAMENT VALUES (600103, 'L', TO_DATE('2010-09-27', 'YYYY-MM-DD'), 'casca', 100117);
INSERT INTO ECHIPAMENT VALUES (600104, 'L', TO_DATE('2010-09-27', 'YYYY-MM-DD'), 'ghete', 100117);
INSERT INTO ECHIPAMENT VALUES (600105, 'L', TO_DATE('2010-09-27', 'YYYY-MM-DD'), 'manusi', 100117);
INSERT INTO ECHIPAMENT VALUES (600106, 'M', TO_DATE('2011-04-01', 'YYYY-MM-DD'), 'combinezon', 100118);
INSERT INTO ECHIPAMENT VALUES (600107, 'M', TO_DATE('2011-04-01', 'YYYY-MM-DD'), 'casca', 100118);
INSERT INTO ECHIPAMENT VALUES (600108, 'M', TO_DATE('2011-04-01', 'YYYY-MM-DD'), 'ghete', 100118);
INSERT INTO ECHIPAMENT VALUES (600109, 'M', TO_DATE('2011-04-01', 'YYYY-MM-DD'), 'manusi', 100118);
INSERT INTO ECHIPAMENT VALUES (600110, 'L', TO_DATE('2011-10-07', 'YYYY-MM-DD'), 'combinezon', 100119);
INSERT INTO ECHIPAMENT VALUES (600111, 'L', TO_DATE('2011-10-07', 'YYYY-MM-DD'), 'casca', 100119);
INSERT INTO ECHIPAMENT VALUES (600112, 'L', TO_DATE('2011-10-07', 'YYYY-MM-DD'), 'ghete', 100119);
INSERT INTO ECHIPAMENT VALUES (600113, 'L', TO_DATE('2011-10-07', 'YYYY-MM-DD'), 'manusi', 100119);
INSERT INTO ECHIPAMENT VALUES (600114, 'M', TO_DATE('2012-03-22', 'YYYY-MM-DD'), 'combinezon', 100120);
INSERT INTO ECHIPAMENT VALUES (600115, 'M', TO_DATE('2012-03-22', 'YYYY-MM-DD'), 'casca', 100120);
INSERT INTO ECHIPAMENT VALUES (600116, 'M', TO_DATE('2012-03-22', 'YYYY-MM-DD'), 'ghete', 100120);
INSERT INTO ECHIPAMENT VALUES (600117, 'M', TO_DATE('2012-03-22', 'YYYY-MM-DD'), 'manusi', 100120);
INSERT INTO ECHIPAMENT VALUES (600118, 'L', TO_DATE('2012-09-27', 'YYYY-MM-DD'), 'combinezon', 100121);
INSERT INTO ECHIPAMENT VALUES (600119, 'L', TO_DATE('2012-09-27', 'YYYY-MM-DD'), 'casca', 100121);
INSERT INTO ECHIPAMENT VALUES (600120, 'L', TO_DATE('2012-09-27', 'YYYY-MM-DD'), 'ghete', 100121);
INSERT INTO ECHIPAMENT VALUES (600121, 'L', TO_DATE('2012-09-27', 'YYYY-MM-DD'), 'manusi', 100121);
INSERT INTO ECHIPAMENT VALUES (600122, 'M', TO_DATE('2013-04-01', 'YYYY-MM-DD'), 'combinezon', 100122);
INSERT INTO ECHIPAMENT VALUES (600123, 'M', TO_DATE('2013-04-01', 'YYYY-MM-DD'), 'casca', 100122);
INSERT INTO ECHIPAMENT VALUES (600124, 'M', TO_DATE('2013-04-01', 'YYYY-MM-DD'), 'ghete', 100122);
INSERT INTO ECHIPAMENT VALUES (600125, 'M', TO_DATE('2013-04-01', 'YYYY-MM-DD'), 'manusi', 100122);
INSERT INTO ECHIPAMENT VALUES (600126, 'L', TO_DATE('2013-10-07', 'YYYY-MM-DD'), 'combinezon', 100123);
INSERT INTO ECHIPAMENT VALUES (600127, 'L', TO_DATE('2013-10-07', 'YYYY-MM-DD'), 'casca', 100123);
INSERT INTO ECHIPAMENT VALUES (600128, 'L', TO_DATE('2013-10-07', 'YYYY-MM-DD'), 'ghete', 100123);
INSERT INTO ECHIPAMENT VALUES (600129, 'L', TO_DATE('2013-10-07', 'YYYY-MM-DD'), 'manusi', 100123);
INSERT INTO ECHIPAMENT VALUES (600130, 'M', TO_DATE('2014-03-22', 'YYYY-MM-DD'), 'combinezon', 100124);
INSERT INTO ECHIPAMENT VALUES (600131, 'M', TO_DATE('2014-03-22', 'YYYY-MM-DD'), 'casca', 100124);
INSERT INTO ECHIPAMENT VALUES (600132, 'M', TO_DATE('2014-03-22', 'YYYY-MM-DD'), 'ghete', 100124);
INSERT INTO ECHIPAMENT VALUES (600133, 'M', TO_DATE('2014-03-22', 'YYYY-MM-DD'), 'manusi', 100124);
INSERT INTO ECHIPAMENT VALUES (600134, 'L', TO_DATE('2014-09-27', 'YYYY-MM-DD'), 'combinezon', 100125);
INSERT INTO ECHIPAMENT VALUES (600135, 'L', TO_DATE('2014-09-27', 'YYYY-MM-DD'), 'casca', 100125);
INSERT INTO ECHIPAMENT VALUES (600136, 'L', TO_DATE('2014-09-27', 'YYYY-MM-DD'), 'ghete', 100125);
INSERT INTO ECHIPAMENT VALUES (600137, 'L', TO_DATE('2014-09-27', 'YYYY-MM-DD'), 'manusi', 100125);

--LICENTA
INSERT INTO LICENTA VALUES (700001, 'Licenta-B', TO_DATE('2008-02-12', 'YYYY-MM-DD'), TO_DATE('2018-02-12', 'YYYY-MM-DD'), 100072);
INSERT INTO LICENTA VALUES (700002, 'Licenta-B', TO_DATE('2009-11-17', 'YYYY-MM-DD'), TO_DATE('2019-11-17', 'YYYY-MM-DD'), 100073);
INSERT INTO LICENTA VALUES (700003, 'Licenta-B', TO_DATE('2009-04-22', 'YYYY-MM-DD'), TO_DATE('2019-04-22', 'YYYY-MM-DD'), 100074);
INSERT INTO LICENTA VALUES (700004, 'Licenta-B', TO_DATE('2010-10-14', 'YYYY-MM-DD'), TO_DATE('2020-10-14', 'YYYY-MM-DD'), 100075);
INSERT INTO LICENTA VALUES (700005, 'Licenta-B', TO_DATE('2012-03-28', 'YYYY-MM-DD'), TO_DATE('2022-03-28', 'YYYY-MM-DD'), 100076);
INSERT INTO LICENTA VALUES (700006, 'Licenta-B', TO_DATE('2010-05-15', 'YYYY-MM-DD'), TO_DATE('2020-05-15', 'YYYY-MM-DD'), 100077);
INSERT INTO LICENTA VALUES (700007, 'Licenta-B', TO_DATE('2013-01-11', 'YYYY-MM-DD'), TO_DATE('2023-01-11', 'YYYY-MM-DD'), 100078);
INSERT INTO LICENTA VALUES (700008, 'Licenta-B', TO_DATE('2011-05-25', 'YYYY-MM-DD'), TO_DATE('2021-05-25', 'YYYY-MM-DD'), 100079);
INSERT INTO LICENTA VALUES (700009, 'Licenta-B', TO_DATE('2014-01-19', 'YYYY-MM-DD'), TO_DATE('2024-01-19', 'YYYY-MM-DD'), 100080);
INSERT INTO LICENTA VALUES (700010, 'Licenta-B', TO_DATE('2012-06-30', 'YYYY-MM-DD'), TO_DATE('2022-06-30', 'YYYY-MM-DD'), 100081);
INSERT INTO LICENTA VALUES (700011, 'Licenta-B', TO_DATE('2012-11-23', 'YYYY-MM-DD'), TO_DATE('2022-11-23', 'YYYY-MM-DD'), 100082);
INSERT INTO LICENTA VALUES (700012, 'Licenta-B', TO_DATE('2015-04-15', 'YYYY-MM-DD'), TO_DATE('2025-04-15', 'YYYY-MM-DD'), 100083);
INSERT INTO LICENTA VALUES (700013, 'Licenta-B', TO_DATE('2013-09-15', 'YYYY-MM-DD'), TO_DATE('2023-09-15', 'YYYY-MM-DD'), 100084);
INSERT INTO LICENTA VALUES (700014, 'Licenta-B', TO_DATE('2015-08-22', 'YYYY-MM-DD'), TO_DATE('2025-08-22', 'YYYY-MM-DD'), 100085);
INSERT INTO LICENTA VALUES (700015, 'Licenta-B', TO_DATE('2014-10-10', 'YYYY-MM-DD'), TO_DATE('2024-10-10', 'YYYY-MM-DD'), 100086);
INSERT INTO LICENTA VALUES (700016, 'Licenta-B', TO_DATE('2015-09-18', 'YYYY-MM-DD'), TO_DATE('2025-09-18', 'YYYY-MM-DD'), 100087);
INSERT INTO LICENTA VALUES (700017, 'Licenta-B', TO_DATE('2015-08-25', 'YYYY-MM-DD'), TO_DATE('2025-08-25', 'YYYY-MM-DD'), 100088);
INSERT INTO LICENTA VALUES (700018, 'Licenta-B', TO_DATE('2015-07-30', 'YYYY-MM-DD'), TO_DATE('2025-07-30', 'YYYY-MM-DD'), 100089);
INSERT INTO LICENTA VALUES (700019, 'Licenta-B', TO_DATE('2015-07-20', 'YYYY-MM-DD'), TO_DATE('2025-07-20', 'YYYY-MM-DD'), 100090);
INSERT INTO LICENTA VALUES (700020, 'Licenta-B', TO_DATE('2015-12-15', 'YYYY-MM-DD'), TO_DATE('2025-12-15', 'YYYY-MM-DD'), 100091);
INSERT INTO LICENTA VALUES (700021, 'Licenta-B', TO_DATE('2015-09-08', 'YYYY-MM-DD'), TO_DATE('2025-09-08', 'YYYY-MM-DD'), 100092);
INSERT INTO LICENTA VALUES (700022, 'Licenta-B', TO_DATE('2015-08-12', 'YYYY-MM-DD'), TO_DATE('2025-08-12', 'YYYY-MM-DD'), 100093);
INSERT INTO LICENTA VALUES (700023, 'Licenta-B', TO_DATE('2015-11-17', 'YYYY-MM-DD'), TO_DATE('2025-11-17', 'YYYY-MM-DD'), 100094);
INSERT INTO LICENTA VALUES (700024, 'Licenta-B', TO_DATE('2015-04-22', 'YYYY-MM-DD'), TO_DATE('2025-04-22', 'YYYY-MM-DD'), 100095);
INSERT INTO LICENTA VALUES (700025, 'Licenta-B', TO_DATE('2015-10-14', 'YYYY-MM-DD'), TO_DATE('2025-10-14', 'YYYY-MM-DD'), 100096);
INSERT INTO LICENTA VALUES (700026, 'Licenta-B', TO_DATE('2015-03-28', 'YYYY-MM-DD'), TO_DATE('2025-03-28', 'YYYY-MM-DD'), 100097);
INSERT INTO LICENTA VALUES (700027, 'Licenta-B', TO_DATE('2015-12-11', 'YYYY-MM-DD'), TO_DATE('2025-12-11', 'YYYY-MM-DD'), 100098);
INSERT INTO LICENTA VALUES (700100, 'Licenta-A', TO_DATE('2012-02-12', 'YYYY-MM-DD'), TO_DATE('2022-02-12', 'YYYY-MM-DD'), 100072);
INSERT INTO LICENTA VALUES (700101, 'Licenta-A', TO_DATE('2013-11-17', 'YYYY-MM-DD'), TO_DATE('2023-11-17', 'YYYY-MM-DD'), 100073);
INSERT INTO LICENTA VALUES (700102, 'Licenta-A', TO_DATE('2013-04-22', 'YYYY-MM-DD'), TO_DATE('2023-04-22', 'YYYY-MM-DD'), 100074);
INSERT INTO LICENTA VALUES (700103, 'Licenta-A', TO_DATE('2014-10-14', 'YYYY-MM-DD'), TO_DATE('2024-10-14', 'YYYY-MM-DD'), 100075);
INSERT INTO LICENTA VALUES (700104, 'Licenta-A', TO_DATE('2016-03-28', 'YYYY-MM-DD'), TO_DATE('2026-03-28', 'YYYY-MM-DD'), 100076);
INSERT INTO LICENTA VALUES (700105, 'Licenta-A', TO_DATE('2014-05-15', 'YYYY-MM-DD'), TO_DATE('2024-05-15', 'YYYY-MM-DD'), 100077);
INSERT INTO LICENTA VALUES (700106, 'Licenta-A', TO_DATE('2017-01-11', 'YYYY-MM-DD'), TO_DATE('2027-01-11', 'YYYY-MM-DD'), 100078);
INSERT INTO LICENTA VALUES (700107, 'Licenta-A', TO_DATE('2015-05-25', 'YYYY-MM-DD'), TO_DATE('2025-05-25', 'YYYY-MM-DD'), 100079);
INSERT INTO LICENTA VALUES (700108, 'Licenta-A', TO_DATE('2018-01-19', 'YYYY-MM-DD'), TO_DATE('2028-01-19', 'YYYY-MM-DD'), 100080);
INSERT INTO LICENTA VALUES (700109, 'Licenta-A', TO_DATE('2016-06-30', 'YYYY-MM-DD'), TO_DATE('2026-06-30', 'YYYY-MM-DD'), 100081);
INSERT INTO LICENTA VALUES (700110, 'Licenta-A', TO_DATE('2016-11-23', 'YYYY-MM-DD'), TO_DATE('2026-11-23', 'YYYY-MM-DD'), 100082);
INSERT INTO LICENTA VALUES (700200, 'Licenta-A', TO_DATE('2013-04-22', 'YYYY-MM-DD'), TO_DATE('2023-04-22', 'YYYY-MM-DD'), 100074);
INSERT INTO LICENTA VALUES (700201, 'Licenta-B Internationala', TO_DATE('2011-04-22', 'YYYY-MM-DD'), TO_DATE('2021-04-22', 'YYYY-MM-DD'), 100074);
INSERT INTO LICENTA VALUES (700202, 'Licenta-A Internationala', TO_DATE('2015-04-22', 'YYYY-MM-DD'), TO_DATE('2025-04-22', 'YYYY-MM-DD'), 100074);
INSERT INTO LICENTA VALUES (700203, 'Licenta-B Internationala', TO_DATE('2014-11-23', 'YYYY-MM-DD'), TO_DATE('2024-11-23', 'YYYY-MM-DD'), 100082);
INSERT INTO LICENTA VALUES (700204, 'Licenta-A Internationala', TO_DATE('2018-11-23', 'YYYY-MM-DD'), TO_DATE('2028-11-23', 'YYYY-MM-DD'), 100082);
INSERT INTO LICENTA VALUES (700205, 'Licenta-A', TO_DATE('2017-09-15', 'YYYY-MM-DD'), TO_DATE('2027-09-15', 'YYYY-MM-DD'), 100084);
INSERT INTO LICENTA VALUES (700206, 'Licenta-B Internationala', TO_DATE('2015-09-15', 'YYYY-MM-DD'), TO_DATE('2025-09-15', 'YYYY-MM-DD'), 100084);
INSERT INTO LICENTA VALUES (700207, 'Licenta-A Internationala', TO_DATE('2019-09-15', 'YYYY-MM-DD'), TO_DATE('2029-09-15', 'YYYY-MM-DD'), 100084);
INSERT INTO LICENTA VALUES (700208, 'Licenta-A', TO_DATE('2019-08-22', 'YYYY-MM-DD'), TO_DATE('2029-08-22', 'YYYY-MM-DD'), 100085);
INSERT INTO LICENTA VALUES (700209, 'Licenta-B Internationala', TO_DATE('2017-08-22', 'YYYY-MM-DD'), TO_DATE('2027-08-22', 'YYYY-MM-DD'), 100085);
INSERT INTO LICENTA VALUES (700210, 'Licenta-A Internationala', TO_DATE('2021-08-22', 'YYYY-MM-DD'), TO_DATE('2031-08-22', 'YYYY-MM-DD'), 100085);
INSERT INTO LICENTA VALUES (700211, 'Licenta-A', TO_DATE('2019-07-20', 'YYYY-MM-DD'), TO_DATE('2029-07-20', 'YYYY-MM-DD'), 100090);
INSERT INTO LICENTA VALUES (700212, 'Licenta-B Internationala', TO_DATE('2017-07-20', 'YYYY-MM-DD'), TO_DATE('2027-07-20', 'YYYY-MM-DD'), 100090);
INSERT INTO LICENTA VALUES (700213, 'Licenta-A Internationala', TO_DATE('2021-07-20', 'YYYY-MM-DD'), TO_DATE('2031-07-20', 'YYYY-MM-DD'), 100090);
INSERT INTO LICENTA VALUES (700214, 'Licenta-A', TO_DATE('2019-04-22', 'YYYY-MM-DD'), TO_DATE('2029-04-22', 'YYYY-MM-DD'), 100095);
INSERT INTO LICENTA VALUES (700215, 'Licenta-B Internationala', TO_DATE('2017-04-22', 'YYYY-MM-DD'), TO_DATE('2027-04-22', 'YYYY-MM-DD'), 100095);
INSERT INTO LICENTA VALUES (700216, 'Licenta-A Internationala', TO_DATE('2021-04-22', 'YYYY-MM-DD'), TO_DATE('2031-04-22', 'YYYY-MM-DD'), 100095);
INSERT INTO LICENTA VALUES (700217, 'Licenta-B', TO_DATE('2015-03-15', 'YYYY-MM-DD'), TO_DATE('2025-03-15', 'YYYY-MM-DD'), 100116);
INSERT INTO LICENTA VALUES (700218, 'Licenta-B', TO_DATE('2015-09-20', 'YYYY-MM-DD'), TO_DATE('2025-09-20', 'YYYY-MM-DD'), 100117);
INSERT INTO LICENTA VALUES (700219, 'Licenta-B', TO_DATE('2016-03-25', 'YYYY-MM-DD'), TO_DATE('2026-03-25', 'YYYY-MM-DD'), 100118);
INSERT INTO LICENTA VALUES (700220, 'Licenta-B', TO_DATE('2016-09-30', 'YYYY-MM-DD'), TO_DATE('2026-09-30', 'YYYY-MM-DD'), 100119);
INSERT INTO LICENTA VALUES (700221, 'Licenta-B', TO_DATE('2017-03-15', 'YYYY-MM-DD'), TO_DATE('2027-03-15', 'YYYY-MM-DD'), 100120);
INSERT INTO LICENTA VALUES (700222, 'Licenta-B', TO_DATE('2017-09-20', 'YYYY-MM-DD'), TO_DATE('2027-09-20', 'YYYY-MM-DD'), 100121);
INSERT INTO LICENTA VALUES (700223, 'Licenta-A', TO_DATE('2022-12-31', 'YYYY-MM-DD'), TO_DATE('2032-12-31', 'YYYY-MM-DD'), 100121);
INSERT INTO LICENTA VALUES (700224, 'Licenta-B', TO_DATE('2018-03-25', 'YYYY-MM-DD'), TO_DATE('2028-03-25', 'YYYY-MM-DD'), 100122);
INSERT INTO LICENTA VALUES (700225, 'Licenta-A', TO_DATE('2022-12-31', 'YYYY-MM-DD'), TO_DATE('2032-12-31', 'YYYY-MM-DD'), 100122);
INSERT INTO LICENTA VALUES (700226, 'Licenta-B', TO_DATE('2018-09-30', 'YYYY-MM-DD'), TO_DATE('2028-09-30', 'YYYY-MM-DD'), 100123);
INSERT INTO LICENTA VALUES (700227, 'Licenta-A', TO_DATE('2022-12-31', 'YYYY-MM-DD'), TO_DATE('2032-12-31', 'YYYY-MM-DD'), 100123);
INSERT INTO LICENTA VALUES (700228, 'Licenta-B', TO_DATE('2019-03-15', 'YYYY-MM-DD'), TO_DATE('2029-03-15', 'YYYY-MM-DD'), 100124);
INSERT INTO LICENTA VALUES (700229, 'Licenta-A', TO_DATE('2022-12-31', 'YYYY-MM-DD'), TO_DATE('2032-12-31', 'YYYY-MM-DD'), 100124);
INSERT INTO LICENTA VALUES (700230, 'Licenta-B', TO_DATE('2019-09-20', 'YYYY-MM-DD'), TO_DATE('2029-09-20', 'YYYY-MM-DD'), 100125);
INSERT INTO LICENTA VALUES (700231, 'Licenta-A', TO_DATE('2022-12-31', 'YYYY-MM-DD'), TO_DATE('2032-12-31', 'YYYY-MM-DD'), 100125);

--GARAJ_KART
INSERT INTO GARAJ_KART VALUES (4005, 300001, TO_DATE('1982-03-15', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4010, 300011, TO_DATE('1986-05-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4015, 300021, TO_DATE('1990-07-10', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4020, 300031, TO_DATE('1994-09-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4025, 300041, TO_DATE('1998-11-30', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4030, 300051, TO_DATE('2003-01-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4035, 300064, TO_DATE('2008-06-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4040, 300076, TO_DATE('2013-06-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4045, 300088, TO_DATE('2018-06-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4001, 300002, TO_DATE('1982-08-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4002, 300003, TO_DATE('1983-01-10', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4006, 300004, TO_DATE('1983-06-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4007, 300005, TO_DATE('1983-11-30', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4011, 300012, TO_DATE('1986-10-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4012, 300013, TO_DATE('1987-03-30', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4016, 300014, TO_DATE('1987-08-15', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4017, 300015, TO_DATE('1988-01-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4021, 300022, TO_DATE('1990-12-15', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4022, 300023, TO_DATE('1991-05-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4026, 300024, TO_DATE('1991-10-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4027, 300025, TO_DATE('1992-03-30', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4031, 300032, TO_DATE('1995-02-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4032, 300033, TO_DATE('1995-07-10', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4036, 300034, TO_DATE('1995-12-15', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4037, 300035, TO_DATE('1996-05-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4041, 300042, TO_DATE('1999-04-15', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4042, 300043, TO_DATE('1999-09-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4046, 300044, TO_DATE('2000-02-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4047, 300045, TO_DATE('2000-07-10', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4051, 300094, TO_DATE('2021-08-15', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4052, 300095, TO_DATE('2022-09-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4056, 300096, TO_DATE('2023-06-10', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4057, 300097, TO_DATE('2024-03-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4003, 300052, TO_DATE('2003-06-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4004, 300053, TO_DATE('2003-11-30', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4008, 300054, TO_DATE('2004-04-15', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4009, 300055, TO_DATE('2004-09-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4013, 300056, TO_DATE('2005-02-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4014, 300065, TO_DATE('2008-11-30', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4018, 300066, TO_DATE('2009-04-15', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4019, 300067, TO_DATE('2009-09-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4023, 300068, TO_DATE('2010-02-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4024, 300069, TO_DATE('2010-07-10', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4028, 300077, TO_DATE('2013-11-30', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4029, 300078, TO_DATE('2014-04-15', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4033, 300079, TO_DATE('2014-09-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4034, 300080, TO_DATE('2015-02-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4038, 300081, TO_DATE('2015-07-10', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4039, 300089, TO_DATE('2018-11-30', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4043, 300090, TO_DATE('2019-04-15', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4044, 300091, TO_DATE('2019-09-20', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4048, 300092, TO_DATE('2020-02-25', 'YYYY-MM-DD'));
INSERT INTO GARAJ_KART VALUES (4049, 300093, TO_DATE('2020-07-10', 'YYYY-MM-DD'));

--PILOT_KART
INSERT INTO PILOT_KART VALUES (100072, 300002, TO_DATE('2002-08-12', 'YYYY-MM-DD'), TO_DATE('2015-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100074, 300004, TO_DATE('2003-10-22', 'YYYY-MM-DD'), TO_DATE('2016-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100073, 300003, TO_DATE('2004-05-17', 'YYYY-MM-DD'), TO_DATE('2016-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100077, 300013, TO_DATE('2004-11-15', 'YYYY-MM-DD'), TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100075, 300005, TO_DATE('2005-04-14', 'YYYY-MM-DD'), TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100079, 300015, TO_DATE('2005-11-25', 'YYYY-MM-DD'), TO_DATE('2018-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100076, 300012, TO_DATE('2006-09-28', 'YYYY-MM-DD'), TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100081, 300023, TO_DATE('2006-12-30', 'YYYY-MM-DD'), TO_DATE('2019-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100082, 300024, TO_DATE('2007-05-23', 'YYYY-MM-DD'), TO_DATE('2020-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100078, 300014, TO_DATE('2007-06-11', 'YYYY-MM-DD'), TO_DATE('2018-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100084, 300032, TO_DATE('2008-03-15', 'YYYY-MM-DD'), TO_DATE('2021-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100080, 300022, TO_DATE('2008-07-19', 'YYYY-MM-DD'), TO_DATE('2019-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100086, 300034, TO_DATE('2009-04-10', 'YYYY-MM-DD'), TO_DATE('2022-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100083, 300025, TO_DATE('2009-10-15', 'YYYY-MM-DD'), TO_DATE('2020-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100088, 300042, TO_DATE('2010-02-25', 'YYYY-MM-DD'), TO_DATE('2023-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100085, 300033, TO_DATE('2010-08-22', 'YYYY-MM-DD'), TO_DATE('2021-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100090, 300044, TO_DATE('2011-01-20', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100087, 300035, TO_DATE('2011-09-18', 'YYYY-MM-DD'), TO_DATE('2022-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100092, 300052, TO_DATE('2012-03-08', 'YYYY-MM-DD'), TO_DATE('2024-01-31', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100089, 300043, TO_DATE('2012-07-30', 'YYYY-MM-DD'), TO_DATE('2023-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100091, 300045, TO_DATE('2013-06-15', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100095, 300055, TO_DATE('2013-10-22', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100093, 300053, TO_DATE('2013-08-12', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100097, 300065, TO_DATE('2014-09-28', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100094, 300054, TO_DATE('2014-05-17', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100096, 300056, TO_DATE('2015-04-14', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100098, 300066, TO_DATE('2015-06-11', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100102, 300077, TO_DATE('2015-08-15', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100100, 300068, TO_DATE('2015-07-25', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100099, 300067, TO_DATE('2016-02-19', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100101, 300069, TO_DATE('2016-03-30', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100103, 300078, TO_DATE('2016-11-20', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100104, 300079, TO_DATE('2017-03-15', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100107, 300089, TO_DATE('2018-09-18', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100105, 300080, TO_DATE('2018-08-22', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100106, 300081, TO_DATE('2019-04-10', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100110, 300092, TO_DATE('2019-08-22', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100108, 300090, TO_DATE('2019-11-25', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100109, 300091, TO_DATE('2020-03-15', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100111, 300093, TO_DATE('2020-11-30', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100112, 300094, TO_DATE('2021-06-15', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100113, 300095, TO_DATE('2022-07-20', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100114, 300096, TO_DATE('2023-04-10', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100115, 300097, TO_DATE('2024-01-25', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100092, 300022, TO_DATE('2024-02-01', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_KART VALUES (100116, 300022, TO_DATE('2010-03-15', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100117, 300023, TO_DATE('2010-09-20', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100118, 300024, TO_DATE('2011-03-25', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100119, 300025, TO_DATE('2011-09-30', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100120, 300032, TO_DATE('2012-03-15', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100121, 300033, TO_DATE('2012-09-20', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100122, 300034, TO_DATE('2013-03-25', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100123, 300035, TO_DATE('2013-09-30', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100124, 300042, TO_DATE('2014-03-15', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOT_KART VALUES (100125, 300043, TO_DATE('2014-09-20', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));

--PILOT_INSTRUCTOR
INSERT INTO PILOT_INSTRUCTOR VALUES (100072, 200093, TO_DATE('2002-08-12', 'YYYY-MM-DD'), TO_DATE('2015-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100073, 200094, TO_DATE('2004-05-17', 'YYYY-MM-DD'), TO_DATE('2016-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100074, 200095, TO_DATE('2003-10-22', 'YYYY-MM-DD'), TO_DATE('2016-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100075, 200096, TO_DATE('2005-04-14', 'YYYY-MM-DD'), TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100076, 200097, TO_DATE('2006-09-28', 'YYYY-MM-DD'), TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100077, 200098, TO_DATE('2004-11-15', 'YYYY-MM-DD'), TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100078, 200099, TO_DATE('2007-06-11', 'YYYY-MM-DD'), TO_DATE('2018-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100079, 200100, TO_DATE('2005-11-25', 'YYYY-MM-DD'), TO_DATE('2018-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100080, 200101, TO_DATE('2008-07-19', 'YYYY-MM-DD'), TO_DATE('2015-12-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100081, 200102, TO_DATE('2006-12-30', 'YYYY-MM-DD'), TO_DATE('2014-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100082, 200103, TO_DATE('2007-05-23', 'YYYY-MM-DD'), TO_DATE('2016-03-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100083, 200104, TO_DATE('2009-10-15', 'YYYY-MM-DD'), TO_DATE('2015-09-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100084, 200105, TO_DATE('2008-03-15', 'YYYY-MM-DD'), TO_DATE('2016-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100085, 200106, TO_DATE('2010-08-22', 'YYYY-MM-DD'), TO_DATE('2015-03-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100086, 200107, TO_DATE('2009-04-10', 'YYYY-MM-DD'), TO_DATE('2016-12-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100087, 200108, TO_DATE('2011-09-18', 'YYYY-MM-DD'), TO_DATE('2015-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100088, 200109, TO_DATE('2010-02-25', 'YYYY-MM-DD'), TO_DATE('2016-09-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100089, 200110, TO_DATE('2012-07-30', 'YYYY-MM-DD'), TO_DATE('2015-12-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100090, 200111, TO_DATE('2011-01-20', 'YYYY-MM-DD'), TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100091, 200112, TO_DATE('2013-06-15', 'YYYY-MM-DD'), TO_DATE('2016-09-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100092, 200131, TO_DATE('2012-03-08', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100093, 200132, TO_DATE('2013-08-12', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100094, 200133, TO_DATE('2014-05-17', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100095, 200134, TO_DATE('2013-10-22', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100096, 200135, TO_DATE('2015-04-14', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100097, 200136, TO_DATE('2014-09-28', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100098, 200137, TO_DATE('2015-06-11', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100099, 200138, TO_DATE('2016-02-19', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100100, 200139, TO_DATE('2015-07-25', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100101, 200140, TO_DATE('2016-03-30', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100102, 200141, TO_DATE('2015-08-15', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100103, 200142, TO_DATE('2016-11-20', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100104, 200143, TO_DATE('2017-03-15', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100105, 200144, TO_DATE('2018-08-22', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100106, 200145, TO_DATE('2019-04-10', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100107, 200146, TO_DATE('2018-09-18', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100108, 200147, TO_DATE('2019-11-25', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100109, 200148, TO_DATE('2020-03-15', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100110, 200149, TO_DATE('2019-08-22', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100111, 200150, TO_DATE('2020-11-30', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100112, 200151, TO_DATE('2021-06-15', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100113, 200152, TO_DATE('2022-07-20', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100114, 200153, TO_DATE('2023-04-10', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100115, 200154, TO_DATE('2024-01-25', 'YYYY-MM-DD'), NULL);
INSERT INTO PILOT_INSTRUCTOR VALUES (100093, 200131, TO_DATE('2013-09-15', 'YYYY-MM-DD'), TO_DATE('2016-09-15', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100094, 200131, TO_DATE('2014-06-20', 'YYYY-MM-DD'), TO_DATE('2017-06-20', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100095, 200131, TO_DATE('2014-01-22', 'YYYY-MM-DD'), TO_DATE('2017-01-22', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100096, 200132, TO_DATE('2015-05-14', 'YYYY-MM-DD'), TO_DATE('2018-05-14', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100097, 200132, TO_DATE('2014-10-28', 'YYYY-MM-DD'), TO_DATE('2017-10-28', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100098, 200132, TO_DATE('2015-07-11', 'YYYY-MM-DD'), TO_DATE('2018-07-11', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100099, 200133, TO_DATE('2016-03-19', 'YYYY-MM-DD'), TO_DATE('2019-03-19', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100100, 200133, TO_DATE('2015-08-25', 'YYYY-MM-DD'), TO_DATE('2018-08-25', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100101, 200133, TO_DATE('2016-04-30', 'YYYY-MM-DD'), TO_DATE('2019-04-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100102, 200134, TO_DATE('2016-08-15', 'YYYY-MM-DD'), TO_DATE('2019-08-15', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100103, 200134, TO_DATE('2016-11-25', 'YYYY-MM-DD'), TO_DATE('2019-11-25', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100104, 200134, TO_DATE('2017-03-20', 'YYYY-MM-DD'), TO_DATE('2020-03-20', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100105, 200135, TO_DATE('2018-09-01', 'YYYY-MM-DD'), TO_DATE('2021-09-01', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100106, 200135, TO_DATE('2019-04-15', 'YYYY-MM-DD'), TO_DATE('2022-04-15', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100107, 200135, TO_DATE('2018-10-01', 'YYYY-MM-DD'), TO_DATE('2021-10-01', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100108, 200136, TO_DATE('2019-12-01', 'YYYY-MM-DD'), TO_DATE('2022-12-01', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100109, 200136, TO_DATE('2020-03-20', 'YYYY-MM-DD'), TO_DATE('2023-03-20', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100110, 200136, TO_DATE('2019-09-01', 'YYYY-MM-DD'), TO_DATE('2022-09-01', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100116, 200111, TO_DATE('2010-03-15', 'YYYY-MM-DD'), TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100117, 200112, TO_DATE('2010-09-20', 'YYYY-MM-DD'), TO_DATE('2016-09-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100118, 200113, TO_DATE('2011-03-25', 'YYYY-MM-DD'), TO_DATE('2018-03-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100119, 200114, TO_DATE('2011-09-30', 'YYYY-MM-DD'), TO_DATE('2017-09-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100120, 200115, TO_DATE('2012-03-15', 'YYYY-MM-DD'), TO_DATE('2018-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100116, 200116, TO_DATE('2017-07-01', 'YYYY-MM-DD'), TO_DATE('2017-12-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100117, 200117, TO_DATE('2016-10-01', 'YYYY-MM-DD'), TO_DATE('2019-03-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100118, 200118, TO_DATE('2018-04-01', 'YYYY-MM-DD'), TO_DATE('2018-09-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100119, 200119, TO_DATE('2017-10-01', 'YYYY-MM-DD'), TO_DATE('2019-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100120, 200120, TO_DATE('2018-07-01', 'YYYY-MM-DD'), TO_DATE('2018-12-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100121, 200121, TO_DATE('2012-09-20', 'YYYY-MM-DD'), TO_DATE('2019-12-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100122, 200122, TO_DATE('2013-03-25', 'YYYY-MM-DD'), TO_DATE('2020-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100123, 200123, TO_DATE('2013-09-30', 'YYYY-MM-DD'), TO_DATE('2021-03-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100124, 200124, TO_DATE('2014-03-15', 'YYYY-MM-DD'), TO_DATE('2020-12-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100125, 200125, TO_DATE('2014-09-20', 'YYYY-MM-DD'), TO_DATE('2021-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100121, 200126, TO_DATE('2020-01-01', 'YYYY-MM-DD'), TO_DATE('2020-09-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100122, 200127, TO_DATE('2020-07-01', 'YYYY-MM-DD'), TO_DATE('2022-03-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100123, 200128, TO_DATE('2021-04-01', 'YYYY-MM-DD'), TO_DATE('2021-12-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100124, 200129, TO_DATE('2021-01-01', 'YYYY-MM-DD'), TO_DATE('2022-06-30', 'YYYY-MM-DD'));
INSERT INTO PILOT_INSTRUCTOR VALUES (100125, 200130, TO_DATE('2021-07-01', 'YYYY-MM-DD'), TO_DATE('2021-09-30', 'YYYY-MM-DD'));
