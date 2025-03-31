-- Определяем временную таблицу для хранения средней позиции и количества гонок для каждого автомобиля
WITH AveragePositions AS (
    SELECT
        c.name AS car_name,                -- Имя автомобиля
        cl.class AS car_class,              -- Класс автомобиля
        AVG(r.position) AS average_position, -- Средняя позиция автомобиля в гонках
        COUNT(r.race) AS race_count         -- Количество гонок, в которых участвовал автомобиль
    FROM
        Cars c                              -- Таблица автомобилей
            JOIN
        Results r ON c.name = r.car        -- Объединяем с таблицей результатов по имени автомобиля
            JOIN
        Classes cl ON c.class = cl.class    -- Объединяем с таблицей классов по классу автомобиля
    GROUP BY
        c.name, cl.class                    -- Группируем результаты по имени автомобиля и классу
),

-- Определяем временную таблицу для хранения минимальной средней позиции для каждого класса
     MinAveragePositions AS (
         SELECT
             car_class,                          -- Класс автомобиля
             MIN(average_position) AS min_average_position -- Минимальная средняя позиция для данного класса
         FROM
             AveragePositions                    -- Используем данные из предыдущей временной таблицы
         GROUP BY
             car_class                           -- Группируем результаты по классу
     )

-- Основной запрос для получения информации о автомобилях с наименьшей средней позицией в каждом классе
SELECT
    ap.car_name,                          -- Имя автомобиля
    ap.car_class,                         -- Класс автомобиля
    ap.average_position,                  -- Средняя позиция автомобиля
    ap.race_count                         -- Количество гонок, в которых участвовал автомобиль
FROM
    AveragePositions ap                   -- Используем данные из временной таблицы AveragePositions
        JOIN
    MinAveragePositions map ON ap.car_class = map.car_class
        AND ap.average_position = map.min_average_position -- Объединяем с минимальными позициями по классу и средней позиции
ORDER BY
    ap.average_position;                  -- Сортируем результаты по средней позиции
