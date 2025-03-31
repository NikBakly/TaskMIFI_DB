-- Определяем рекурсивный CTE для извлечения иерархии сотрудников
WITH RECURSIVE EmployeeHierarchy AS (
    -- Начинаем с выбора всех сотрудников
    SELECT
        EmployeeID,                     -- Идентификатор сотрудника
        Name AS EmployeeName,          -- Имя сотрудника
        ManagerID,                     -- Идентификатор менеджера
        DepartmentID,                  -- Идентификатор отдела
        RoleID                         -- Идентификатор роли
    FROM Employees

    UNION ALL

    -- Рекурсивно выбираем подчиненных сотрудников
    SELECT
        e.EmployeeID,                 -- Идентификатор подчиненного сотрудника
        e.Name AS EmployeeName,       -- Имя подчиненного сотрудника
        e.ManagerID,                  -- Идентификатор менеджера подчиненного
        e.DepartmentID,               -- Идентификатор отдела подчиненного
        e.RoleID                      -- Идентификатор роли подчиненного
    FROM Employees e
             INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID  -- Соединяем с предыдущими результатами по менеджеру
)

-- Основной запрос для извлечения информации о менеджерах с подчиненными
SELECT
    eh.EmployeeID,                     -- Идентификатор сотрудника
    eh.EmployeeName,                   -- Имя сотрудника
    eh.ManagerID,                      -- Идентификатор менеджера
    d.DepartmentName,                  -- Название отдела
    r.RoleName,                        -- Название роли
    COALESCE(string_agg(DISTINCT p.ProjectName, ', '), NULL) AS ProjectNames,  -- Конкатенация названий проектов
    COALESCE(string_agg(DISTINCT t.TaskName, ', '), NULL) AS TaskNames,          -- Конкатенация названий задач
    COUNT(DISTINCT sub.EmployeeID) AS TotalSubordinates  -- Общее количество подчиненных (включая их подчиненных)
FROM EmployeeHierarchy eh
         LEFT JOIN Departments d ON eh.DepartmentID = d.DepartmentID  -- Соединяем с таблицей отделов
         LEFT JOIN Roles r ON eh.RoleID = r.RoleID                    -- Соединяем с таблицей ролей
         LEFT JOIN Projects p ON p.DepartmentID = d.DepartmentID      -- Соединяем с таблицей проектов по отделу
         LEFT JOIN Tasks t ON t.AssignedTo = eh.EmployeeID            -- Соединяем с таблицей задач по назначенному сотруднику
         LEFT JOIN Employees sub ON sub.ManagerID = eh.EmployeeID      -- Соединяем с таблицей сотрудников для подсчета подчиненных
WHERE r.RoleName = 'Менеджер'                                  -- Фильтруем только менеджеров
GROUP BY
    eh.EmployeeID,
    eh.EmployeeName,
    eh.ManagerID,
    d.DepartmentName,
    r.RoleName
HAVING COUNT(DISTINCT sub.EmployeeID) > 0                     -- Условие для наличия подчиненных
ORDER BY eh.EmployeeName;  -- Сортируем результаты по имени сотрудника
