--1. Выбрать все дисциплины, стандарт на которые был введен более 5 лет назад

SELECT *
FROM disciplines
WHERE standard_year <= (EXTRACT(YEAR FROM CURRENT_DATE) - 5);

--2. Выбрать дисциплины, которые читают преподаватели с почасовой оплатой

SELECT DISTINCT
d.discipline_id,
d.title,
d.description,
d.standard_year
FROM disciplines d
JOIN workload w ON d.discipline_id = w.discipline_id
WHERE (w.hourly_rate IS NOT NULL) = TRUE;

--3. Создать таблицу, содержащую данные 2 запроса с указанием описания и года введения

SELECT DISTINCT
d.discipline_id,
d.title,
d.description,
d.standard_year
INTO disciplines_report
FROM disciplines d
JOIN workload w ON d.discipline_id = w.discipline_id
WHERE (w.hourly_rate IS NOT NULL) = TRUE;

--4. Добавить дисциплины, название которых состоит из нескольких слов и начинается со слова «основы»

INSERT INTO disciplines_report (discipline_id, title, description, standard_year)
SELECT d.*
FROM disciplines d
WHERE d.title ILIKE 'основы%'
AND d.title LIKE '% %'
  
AND NOT EXISTS (
SELECT 1
FROM disciplines_report dr
WHERE dr.discipline_id = d.discipline_id
);


--5. В созданной таблице изменить год введения на 2009 всем дисциплинам с четным кодом

UPDATE disciplines_report
SET standard_year = 2009
WHERE discipline_id % 2 = 0;

--6. Удалить из созданной таблицы записи для всех дисциплин, в названии которых встречается слово «математика».

DELETE FROM disciplines_report
WHERE title ILIKE '%математика%';


--7. Посчитать количество вводимых дисциплин за каждые 5 лет, начиная с 1990 года

SELECT
(1990 + ((standard_year - 1990) / 5) * 5) AS period_start_year,
COUNT(*) AS disciplines_count
FROM disciplines
WHERE standard_year >= 1990
GROUP BY (standard_year - 1990) / 5
ORDER BY period_start_year;

