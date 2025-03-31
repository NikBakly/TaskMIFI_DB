WITH AveragePositions AS (
    SELECT
        c.name AS car_name,                -- Имя автомобиля
        cl.class AS car_class,              -- Класс автомобиля
        AVG(r.position) AS average_position, -- Средняя позиция автомобиля в гонках
        COUNT(r.race) AS race_count,        -- Количество гонок, в которых участвовал автомобиль
        cl.country AS car_country            -- Страна производства класса автомобиля
    FROM
        Cars c                              -- Таблица автомобилей
            JOIN
        Results r ON c.name = r.car        -- Объединяем с таблицей результатов по имени автомобиля
            JOIN
        Classes cl ON c.class = cl.class    -- Объединяем с таблицей классов по классу автомобиля
    GROUP BY
        c.name, cl.class, cl.country        -- Группируем результаты по имени автомобиля, классу и стране
)

SELECT
    car_name,                             -- Имя автомобиля
    car_class,                            -- Класс автомобиля
    average_position,                     -- Средняя позиция автомобиля
    race_count,                           -- Количество гонок, в которых участвовал автомобиль
    car_country                           -- Страна производства класса автомобиля
FROM
    AveragePositions                      -- Используем данные из временной таблицы AveragePositions
ORDER BY
    average_position,                     -- Сначала сортируем по средней позиции
    car_name                              -- Затем по имени автомобиля (в алфавитном порядке)
LIMIT 1;                                 -- Ограничиваем результат одним автомобилем
