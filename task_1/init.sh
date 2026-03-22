#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- 1. основная таблица (со всеми колонками)
    CREATE TABLE IF NOT EXISTS user_logs (
        courseid INTEGER,
        userid INTEGER,
        num_week INTEGER,
        s_all INTEGER,
        s_all_avg VARCHAR(255),
        s_course_viewed INTEGER,
        s_course_viewed_avg VARCHAR(255),
        s_q_attempt_viewed INTEGER,
        s_q_attempt_viewed_avg VARCHAR(255),
        s_a_course_module_viewed INTEGER,
        s_a_course_module_viewed_avg VARCHAR(255),
        s_a_submission_status_viewed INTEGER,
        s_a_submission_status_viewed_avg VARCHAR(255),
        NameR_Level VARCHAR(255),
        Name_vAtt VARCHAR(255),
        "Depart" VARCHAR(255), -- Сначала создаем как текст, чтобы загрузить данные
        Name_OsnO VARCHAR(255),
        Name_FormOPril VARCHAR(255),
        LevelEd VARCHAR(255),
        Num_Sem INTEGER,
        Kurs INTEGER,
        Date_vAtt VARCHAR(255)
    );

    -- 2. загрузка данных из основного файла
    \copy user_logs FROM '/datasets/aggrigation_logs_per_week.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

    -- 3. Создаем таблицу-справочник кафедр
    CREATE TABLE IF NOT EXISTS departments (
        id INTEGER PRIMARY KEY,
        dep_name TEXT
    );

    -- 4. загрузка данных в справочник (убедись, что файл лежит в папке datasets)
    \copy departments(id, dep_name) FROM '/datasets/departments.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

    -- 5. Преобразование Depart в integer 
    ALTER TABLE user_logs ALTER COLUMN "Depart" TYPE INTEGER USING ("Depart"::integer);

    -- 6. Финальный проверочный запрос 
    SELECT u.userid, u.courseid, d.dep_name 
    FROM user_logs u
    JOIN departments d ON u."Depart" = d.id
    LIMIT 10;
EOSQL