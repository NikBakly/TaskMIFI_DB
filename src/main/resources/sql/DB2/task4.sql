WITH ClassAveragePositions AS (
    -- Вычисляем среднюю позицию для каждого класса автомобилей
    SELECT
        cl.class AS car_class,              -- Класс автомобиля
        AVG(r.position) AS average_position, -- Средняя позиция для класса
        COUNT(c.name) AS car_count          -- Количество автомобилей в классе
    FROM
        Cars c                              -- Таблица автомобилей
            JOIN
        Results r ON c.name = r.car        -- Объединяем с таблицей результатов по имени автомобиля
            JOIN
        Classes cl ON c.class = cl.class    -- Объединяем с таблицей классов по классу автомобиля
    GROUP BY
        cl.class                            -- Группируем результаты по классу
    HAVING
        COUNT(c.name) >= 2                  -- Убедимся, что в классе минимум два автомобиля
)

-- Основной запрос для получения информации об автомобилях с лучшей средней позицией
SELECT
    c.name AS car_name,                   -- Имя автомобиля
    cl.class AS car_class,                -- Класс автомобиля
    AVG(r.position) AS average_position,   -- Средняя позиция автомобиля
    COUNT(r.race) AS race_count,          -- Количество гонок, в которых участвовал автомобиль
    cl.country AS car_country              -- Страна производства класса автомобиля
FROM
    Cars c
        JOIN
    Results r ON c.name = r.car          -- Объединяем с таблицей результатов по имени автомобиля
        JOIN
    Classes cl ON c.class = cl.class      -- Объединяем с таблицей классов по классу автомобиля
GROUP BY
    c.name, cl.class, cl.country          -- Группируем результаты по имени автомобиля, классу и стране
HAVING
    AVG(r.position) < (                   -- Условие для выбора автомобилей с лучшей средней позицией
        SELECT average_position            -- Подзапрос для получения средней позиции класса
        FROM ClassAveragePositions cap
        WHERE cap.car_class = cl.class     -- Сравниваем с средней позицией класса
    )
ORDER BY
    cl.class,                             -- Сортируем по классу
    average_position;                     -- Затем по средней позиции
