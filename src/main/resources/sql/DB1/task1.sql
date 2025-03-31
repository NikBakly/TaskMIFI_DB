-- Извлекаем информацию о производителях и моделях мотоциклов
SELECT v.maker, m.model
FROM motorcycle m
         JOIN vehicle v ON m.model = v.model  -- Объединяем таблицы motorcycle и vehicle по модели
WHERE m.horsepower > 150              -- Условие: мощность мотоцикла больше 150 л.с.
  AND m.price < 20000                 -- Условие: цена мотоцикла менее 20,000 долларов
  AND m.type = 'Sport'                 -- Условие: тип мотоцикла - спортивный (Sport)
ORDER BY m.horsepower DESC;           -- Сортируем результаты по мощности в порядке убывания
