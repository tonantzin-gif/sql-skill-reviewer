-- Ejemplos de consultas SQL válidas para SQL Reviewer

-- Consulta de un usuario específico
SELECT id, nombre, email
FROM usuarios
WHERE id = 10
LIMIT 1;

-- Consulta con NULL utilizado correctamente
SELECT id, nombre, telefono
FROM usuarios
WHERE telefono IS NULL
LIMIT 50;

-- Consulta con JOIN y nombres descriptivos
SELECT usr.nombre, vta.total
FROM usuarios AS usr
JOIN ventas AS vta ON usr.id = vta.usuario_id
WHERE usr.id = 10
LIMIT 50;

-- Actualización específica
UPDATE usuarios
SET nombre = 'Ana'
WHERE id = 10;

-- Eliminación específica
DELETE FROM usuarios
WHERE id = 25;