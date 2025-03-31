WITH customer_analysis AS (
    SELECT
        c.ID_customer,  -- ID клиента
        c.name,  -- Имя клиента
        COUNT(b.ID_booking) AS total_bookings,  -- Общее количество бронирований
        COUNT(DISTINCT r.ID_hotel) AS unique_hotels,  -- Общее количество уникальных отелей
        SUM(r.price) AS total_spent  -- Общая сумма, потраченная на бронирования
    FROM
        Customer c  -- Таблица клиентов
            JOIN
        Booking b ON c.ID_customer = b.ID_customer  -- Соединяем таблицу Booking с Customer по ID клиента
            JOIN
        Room r ON b.ID_room = r.ID_room  -- Соединяем таблицу Room с Booking по ID номера
    GROUP BY
        c.ID_customer, c.name  -- Группируем по ID клиента и имени
    HAVING
        COUNT(b.ID_booking) > 2 AND COUNT(DISTINCT r.ID_hotel) > 1  -- Фильтруем клиентов, которые сделали более 2 бронирований в разных отелях
),
     high_spenders AS (
         SELECT
             c.ID_customer,  -- ID клиента
             c.name,  -- Имя клиента
             SUM(r.price) AS total_spent,  -- Общая сумма, потраченная на бронирования
             COUNT(b.ID_booking) AS total_bookings  -- Общее количество бронирований
         FROM
             Customer c  -- Таблица клиентов
                 JOIN
             Booking b ON c.ID_customer = b.ID_customer  -- Соединяем таблицу Booking с Customer по ID клиента
                 JOIN
             Room r ON b.ID_room = r.ID_room  -- Соединяем таблицу Room с Booking по ID номера
         GROUP BY
             c.ID_customer, c.name  -- Группируем по ID клиента и имени
         HAVING
             SUM(r.price) > 500  -- Фильтруем клиентов, которые потратили более 500 долларов
     )
SELECT
    ca.ID_customer,  -- ID клиента
    ca.name,  -- Имя клиента
    ca.total_bookings,  -- Общее количество бронирований
    ca.total_spent,  -- Общая сумма, потраченная на бронирования
    ca.unique_hotels  -- Общее количество уникальных отелей
FROM
    customer_analysis ca  -- Используем результаты первого подзапроса
        JOIN
    high_spenders hs ON ca.ID_customer = hs.ID_customer  -- Объединяем с результатами второго подзапроса
ORDER BY
    ca.total_spent ASC;  -- Сортируем по общей сумме, потраченной клиентами, в порядке возрастания
