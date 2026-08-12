-- Casos límite para SQL Reviewer
-- Estas consultas pueden parecer correctas superficialmente,
-- pero contienen riesgos.

-- Tiene WHERE, pero la condición siempre es verdadera
DELETE FROM usuarios
WHERE 1 = 1;

-- Tiene WHERE, pero puede modificar prácticamente todos los registros
UPDATE usuarios
SET rol = 'ADMIN'
WHERE email LIKE '%';

-- Tiene LIMIT, pero el valor es excesivamente alto
SELECT *
FROM usuarios
LIMIT 1000000000;

-- Tiene WHERE, pero la comparación puede ser verdadera
-- para todos los registros con id no nulo
DELETE FROM usuarios
WHERE id = id;

-- Otra condición evidentemente verdadera
UPDATE usuarios
SET activo = 0
WHERE 2 > 1;