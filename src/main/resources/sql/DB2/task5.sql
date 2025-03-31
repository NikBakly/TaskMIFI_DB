WITH ClassAveragePositions AS (
    -- Вычисляем среднюю позицию для каждого автомобиля и общее количество гонок для каждого класса
    SELECT
        cl.class AS car_class,              -- Класс автомобиля
        c.name AS car_name,                 -- Имя автомобиля
        AVG(r.position) AS average_position, -- Средняя позиция автомобиля
        COUNT(r.race) AS race_count,        -- Количество гонок, в которых участвовал автомобиль
        cl.country AS car_country            -- Страна производства класса автомобиля
    FROM
        Cars c
            JOIN
        Results r ON c.name = r.car        -- Объединяем с таблицей результатов по имени автомобиля
            JOIN
        Classes cl ON c.class = cl.class    -- Объединяем с таблицей классов по классу автомобиля
    GROUP BY
        cl.class, c.name, cl.country        -- Группируем результаты по классу, имени автомобиля и стране
),
     LowPositionCounts AS (
         -- Вычисляем количество автомобилей с низкой средней позицией для каждого класса
         SELECT
             car_class,
             COUNT(*) AS low_position_count       -- Количество автомобилей с средней позицией больше 3.0
         FROM
             ClassAveragePositions
         WHERE
             average_position > 3.0               -- Условие для выбора автомобилей с низкой средней позицией
         GROUP BY
             car_class
     ),
     ClassTotalCounts AS (
         -- Вычисляем общее количество автомобилей для каждого класса
         SELECT
             cl.class AS car_class,
             COUNT(c.name) AS total_races        -- Общее количество гонок для класса
         FROM
             Cars c
                 JOIN
             Results r ON c.name = r.car        -- Объединяем с таблицей результатов по имени автомобиля
                 JOIN
             Classes cl ON c.class = cl.class    -- Объединяем с таблицей классов по классу автомобиля
         GROUP BY
             cl.class
     )

-- Основной запрос для получения информации о каждом автомобиле из классов с наибольшим количеством автомобилей с низкой средней позицией
SELECT
    cap.car_name,                         -- Имя автомобиля
    cap.car_class,                        -- Класс автомобиля
    cap.average_position,                 -- Средняя позиция автомобиля
    cap.race_count,                       -- Количество гонок, в которых участвовал автомобиль
    cap.car_country,                      -- Страна производства класса автомобиля
    ct.total_races,                       -- Общее количество гонок для класса
    lc.low_position_count                  -- Количество автомобилей с низкой средней позицией в классе
FROM
    ClassAveragePositions cap
        JOIN
    LowPositionCounts lc ON cap.car_class = lc.car_class -- Объединяем с классами с низкой средней позицией
        JOIN
    ClassTotalCounts ct ON cap.car_class = ct.car_class -- Объединяем с общим количеством гонок для класса
ORDER BY
    lc.low_position_count DESC;           -- Сортируем по количеству автомобилей с низкой средней позицией
