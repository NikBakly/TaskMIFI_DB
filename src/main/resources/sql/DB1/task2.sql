-- Извлекаем информацию о производителях, моделях, мощности, объеме двигателя и типе транспортного средства
SELECT maker, model, horsepower, engine_capacity, vehicle_type
FROM (
         -- Подзапрос для извлечения данных о легковых автомобилях
         SELECT v.maker, c.model, c.horsepower, c.engine_capacity, 'Car' AS vehicle_type
         FROM Car c
                  JOIN Vehicle v ON c.model = v.model  -- Объединяем таблицы Car и Vehicle по модели
         WHERE c.horsepower > 150              -- Условие: мощность больше 150 л.с.
           AND c.engine_capacity < 3.00        -- Условие: объем двигателя менее 3 литров
           AND c.price < 35000                 -- Условие: цена менее 35,000 долларов

         UNION ALL  -- Объединяем результаты с данными о мотоциклах

         -- Подзапрос для извлечения данных о мотоциклах
         SELECT v.maker, m.model, m.horsepower, m.engine_capacity, 'Motorcycle' AS vehicle_type
         FROM Motorcycle m
                  JOIN Vehicle v ON m.model = v.model  -- Объединяем таблицы Motorcycle и Vehicle по модели
         WHERE m.horsepower > 150              -- Условие: мощность больше 150 л.с.
           AND m.engine_capacity < 1.50        -- Условие: объем двигателя менее 1.5 литров
           AND m.price < 20000                 -- Условие: цена менее 20,000 долларов

         UNION ALL  -- Объединяем результаты с данными о велосипедах

         -- Подзапрос для извлечения данных о велосипедах
         SELECT v.maker, b.model, NULL AS horsepower, NULL AS engine_capacity, 'Bicycle' AS vehicle_type
         FROM Bicycle b
                  JOIN Vehicle v ON b.model = v.model  -- Объединяем таблицы Bicycle и Vehicle по модели
         WHERE b.gear_count > 18                -- Условие: количество передач больше 18
           AND b.price < 4000                   -- Условие: цена менее 4,000 долларов
     ) AS combined_results  -- Название подзапроса для дальнейшего использования

-- Сортируем результаты
ORDER BY
    CASE
        WHEN horsepower IS NULL THEN 1  -- Сначала велосипеды (где мощность NULL) будут внизу
        ELSE 0
        END,
    horsepower DESC;  -- Затем сортируем по мощности в порядке убывания
