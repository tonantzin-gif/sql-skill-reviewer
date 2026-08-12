-- Ejemplos con violaciones evidentes

-- SELECT * y consulta potencialmente masiva
SELECT *
FROM usuarios;

-- DELETE sin WHERE
DELETE FROM clientes;

-- UPDATE sin WHERE
UPDATE usuarios
SET rol = 'ADMIN';

-- Uso incorrecto de NULL
SELECT id, nombre
FROM usuarios
WHERE telefono = NULL;

-- Operación destructiva
DROP TABLE usuarios;

-- Nombres poco descriptivos y tipo de dato cuestionable
CREATE TABLE x (
    a INT,
    precio VARCHAR(50)
);