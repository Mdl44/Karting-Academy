--c) Cerin?? : S? se afi?eze numele ?i prenumele pilo?ilor care au licen?? interna?ional? tip A (Licenta-A Internationala) ?i sunt antrena?i de instructori cu salariu peste 500000, împreun? cu numele instructorilor lor ?i data început a preg?tirii.
SELECT DISTINCT 
    p.nume AS nume_pilot,
    p.prenume AS prenume_pilot,
    i.nume AS nume_instructor,
    i.prenume AS prenume_instructor,
    pi.data_inceput AS data_start_pregatire
FROM PILOT p
JOIN LICENTA l ON p.id_pilot = l.id_pilot
JOIN PILOT_INSTRUCTOR pi ON p.id_pilot = pi.id_pilot  
JOIN INSTRUCTOR i ON pi.id_instructor = i.id_instructor
WHERE l.tip_licenta = 'Licenta-A Internationala'
AND i.salariu > 500000
ORDER BY pi.data_inceput;

--d) Cerin?? : S? se afi?eze instructorii care au preg?tit mai mult de 2 pilo?i ?i au un salariu peste medie, afi?ând numele instructorului, num?rul de pilo?i preg?ti?i ?i salariul acestuia
SELECT i.nume, i.prenume, 
       COUNT(DISTINCT pi.id_pilot) as numar_piloti, 
       TO_CHAR(i.salariu, '999,999.00') as salariu
FROM INSTRUCTOR i
JOIN PILOT_INSTRUCTOR pi ON i.id_instructor = pi.id_instructor
GROUP BY i.id_instructor, i.nume, i.prenume, i.salariu
HAVING COUNT(DISTINCT pi.id_pilot) > 2 
AND i.salariu > (SELECT AVG(salariu) FROM INSTRUCTOR)
ORDER BY numar_piloti DESC;

--compus?
--f) Cerin??  : S? se afi?eze to?i pilo?ii, împreun? cu echipamentele lor.
CREATE OR REPLACE VIEW v_pilot_echipament AS
SELECT p.id_pilot,
       p.nume,
       p.prenume,
       p.email,
       p.numar_competitie,
       e.id_echipament,
       e.tip,
       e.marime,
       e.data_achizitie
FROM PILOT p
JOIN ECHIPAMENT e ON p.id_pilot = e.id_pilot;

SELECT * FROM v_pilot_echipament;

--complex?
CREATE OR REPLACE VIEW v_circuit_kart_stats AS
SELECT 
    s.id_sediu,
    s.tara,
    s.oras,
    COUNT(DISTINCT k.id_kart) as total_karturi,
    SUM(CASE WHEN k.model LIKE 'E-KART%' THEN 1 ELSE 0 END) as karturi_electrice,
    SUM(CASE WHEN k.model LIKE '%Combustion' THEN 1 ELSE 0 END) as karturi_combustie,
    SUM(CASE WHEN k.stare = 1 THEN 1 ELSE 0 END) as karturi_functionale,
    SUM(CASE WHEN k.stare = 0 THEN 1 ELSE 0 END) as karturi_defecte
FROM SEDIU s
JOIN GARAJ g ON s.id_sediu = g.id_sediu
JOIN GARAJ_KART gk ON g.id_garaj = gk.id_garaj
JOIN KART k ON gk.id_kart = k.id_kart
WHERE s.tip_sediu IN ('circuit', 'antrenament')
GROUP BY s.id_sediu, s.tara, s.oras
ORDER BY total_karturi DESC;
SELECT * FROM v_circuit_kart_stats;
