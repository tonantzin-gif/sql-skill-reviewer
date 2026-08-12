# Test 02 - Error evidente

## Input

```sql
SELECT * FROM usuarios;

DELETE FROM clientes;

UPDATE usuarios
SET rol = 'ADMIN';

SELECT id, nombre
FROM usuarios
WHERE telefono = NULL;
```

## Expected behavior

La skill deberá detectar múltiples violaciones.

### Hallazgos esperados

1. `SELECT *`

   * Regla esperada: `PERF-001`
   * Severidad: `MEDIUM`

2. `DELETE` sin `WHERE`

   * Regla esperada: `SEC-001`
   * Severidad: `CRITICAL`

3. `UPDATE` sin `WHERE`

   * Regla esperada: `SEC-002`
   * Severidad: `CRITICAL`

4. Comparación incorrecta con `NULL`

   * Regla esperada: `CONV-003`
   * Severidad: `MEDIUM`

### Overall risk esperado

`CRITICAL`

La skill deberá recomendar no ejecutar las operaciones destructivas hasta corregir las condiciones inseguras.

## Actual behavior

Pendiente de ejecución.

## Pass / Fail

Pendiente.

## Problem detected

Pendiente de ejecución.

## Modification made to the skill

Pendiente.
