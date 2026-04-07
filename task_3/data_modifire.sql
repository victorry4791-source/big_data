-- 1. Просмотр 5 случайных строк
SELECT *
FROM user_logs
ORDER BY RANDOM()
LIMIT 5;

-- 2. Попытка посчитать среднее значение по s_all_avg
SELECT AVG(s_all_avg)
FROM user_logs;

-- 3. Поиск значений с запятой
SELECT s_all_avg
FROM user_logs
WHERE s_all_avg LIKE '%,%'
LIMIT 10;

-- 4. Замена запятых на точки
UPDATE user_logs
SET s_all_avg = REPLACE(s_all_avg, ',', '.')
WHERE s_all_avg LIKE '%,%';

-- 5. Изменение типа столбца на REAL
ALTER TABLE user_logs
ALTER COLUMN s_all_avg TYPE REAL
USING s_all_avg::REAL;

-- 6. Повторная проверка среднего значения
SELECT AVG(s_all_avg)
FROM user_logs;
