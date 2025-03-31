SELECT
    c.name,  -- Имя клиента
    c.email,  -- Электронная почта клиента
    c.phone,  -- Телефон клиента
    COUNT(b.ID_booking) AS total_bookings,  -- Общее количество бронирований клиента
    STRING_AGG(DISTINCT h.name, ', ') AS hotels,  -- Список уникальных отелей, в которых клиент бронировал номера, объединенный через запятую
    AVG(b.check_out_date - b.check_in_date) AS average_stay_duration  -- Средняя длительность пребывания в днях
FROM
    Customer c  -- Таблица клиентов
        JOIN
    Booking b ON c.ID_customer = b.ID_customer  -- Соединяем таблицу Booking с Customer по ID клиента
        JOIN
    Room r ON b.ID_room = r.ID_room  -- Соединяем таблицу Room с Booking по ID номера
        JOIN
    Hotel h ON r.ID_hotel = h.ID_hotel  -- Соединяем таблицу Hotel с Room по ID отеля
GROUP BY
    c.ID_customer  -- Группируем результаты по ID клиента
HAVING
    COUNT(DISTINCT r.ID_hotel) > 1 AND COUNT(b.ID_booking) > 2  -- Фильтруем клиентов, у которых более 2 бронирований в разных отелях
ORDER BY
    total_bookings DESC;  -- Сортируем результаты по количеству бронирований в порядке убывания
