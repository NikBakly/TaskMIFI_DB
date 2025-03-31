WITH ClassAveragePositions AS (
    -- Вычисляем среднюю позицию и количество гонок для каждого класса
    SELECT
        cl.class AS car_class,              -- Класс автомобиля
        AVG(r.position) AS average_position, -- Средняя позиция для класса
        COUNT(r.race) AS total_races        -- Общее количество гонок для класса
    FROM
        Cars c                              -- Таблица автомобилей
            JOIN
        Results r ON c.name = r.car        -- Объединяем с таблицей результатов по имени автомобиля
            JOIN
        Classes cl ON c.class = cl.class    -- Объединяем с таблицей классов по классу автомобиля
    GROUP BY
        cl.class                            -- Группируем результаты по классу
),
     MinAveragePosition AS (
         -- Находим минимальную среднюю позицию среди всех классов
         SELECT
             MIN(average_position) AS min_average_position
         FROM
             ClassAveragePositions               -- Используем данные из предыдущей временной таблицы
     )

-- Основной запрос для получения информации о каждом автомобиле из классов с наименьшей средней позицией
SELECT
    c.name AS car_name,                   -- Имя автомобиля
    cl.class AS car_class,                -- Класс автомобиля
    AVG(r.position) AS average_position,   -- Средняя позиция автомобиля
    COUNT(r.race) AS race_count,          -- Количество гонок, в которых участвовал автомобиль
    cl.country AS car_country,             -- Страна производства класса автомобиля
    cap.total_races                        -- Общее количество гонок для класса
FROM
    Cars c
        JOIN
    Results r ON c.name = r.car          -- Объединяем с таблицей результатов по имени автомобиля
        JOIN
    Classes cl ON c.class = cl.class      -- Объединяем с таблицей классов по классу автомобиля
        JOIN
    ClassAveragePositions cap ON cl.class = cap.car_class -- Объединяем с классами и их средней позицией
        JOIN
    MinAveragePosition map ON cap.average_position = map.min_average_position -- Объединяем с минимальной средней позицией
GROUP BY
    c.name, cl.class, cl.country, cap.total_races -- Группируем результаты по имени автомобиля, классу, стране и общему количеству гонок
ORDER BY
    c.name;                               -- Сортируем результаты по имени автомобиля
