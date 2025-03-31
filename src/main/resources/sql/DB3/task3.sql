WITH hotel_categories AS (
    SELECT
        r.ID_hotel,  -- ID отеля
        AVG(r.price) AS average_price,  -- Средняя цена номера
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'  -- Категория "Дешевый"
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'  -- Категория "Средний"
            ELSE 'Дорогой'  -- Категория "Дорогой"
            END AS hotel_type  -- Присваиваем категорию отелю
    FROM
        Room r  -- Таблица номеров
    GROUP BY
        r.ID_hotel  -- Группируем по ID отеля
),
     customer_preferences AS (
         SELECT
             c.ID_customer,  -- ID клиента
             c.name,  -- Имя клиента
             -- Определяем предпочитаемый тип отеля
             CASE
                 WHEN MAX(CASE WHEN hc.hotel_type = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 'Дорогой'
                 WHEN MAX(CASE WHEN hc.hotel_type = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 'Средний'
                 WHEN MAX(CASE WHEN hc.hotel_type = 'Дешевый' THEN 1 ELSE 0 END) = 1 THEN 'Дешевый'
                 END AS preferred_hotel_type,  -- Предпочитаемый тип отеля
             STRING_AGG(DISTINCT h.name, ', ') AS visited_hotels  -- Список уникальных отелей, которые посетил клиент
         FROM
             Customer c  -- Таблица клиентов
                 JOIN
             Booking b ON c.ID_customer = b.ID_customer  -- Соединяем таблицу Booking с Customer по ID клиента
                 JOIN
             Room r ON b.ID_room = r.ID_room  -- Соединяем таблицу Room с Booking по ID номера
                 JOIN
             hotel_categories hc ON r.ID_hotel = hc.ID_hotel  -- Соединяем с категориями отелей
                 JOIN
             Hotel h ON r.ID_hotel = h.ID_hotel  -- Соединяем с таблицей отелей для получения названий
         GROUP BY
             c.ID_customer, c.name  -- Группируем по ID клиента и имени
     )
SELECT
    ID_customer,  -- ID клиента
    name,  -- Имя клиента
    preferred_hotel_type,  -- Предпочитаемый тип отеля
    visited_hotels  -- Список уникальных отелей
FROM
    customer_preferences  -- Используем результаты подзапроса
ORDER BY
    CASE preferred_hotel_type  -- Сортируем по предпочитаемому типу отеля
        WHEN 'Дешевый' THEN 1
        WHEN 'Средний' THEN 2
        WHEN 'Дорогой' THEN 3
        END;
