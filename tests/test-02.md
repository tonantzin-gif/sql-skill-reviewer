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

# Resultado para completar Test 02

## Actual behavior

La skill analizó las cuatro sentencias SQL y detectó correctamente cuatro violaciones:

1. `PERF-001`

   * Severity: `MEDIUM`
   * Problema: uso de `SELECT *`.

2. `SEC-001`

   * Severity: `CRITICAL`
   * Problema: sentencia `DELETE` sin condición `WHERE`.

3. `SEC-002`

   * Severity: `CRITICAL`
   * Problema: sentencia `UPDATE` sin condición `WHERE`.

4. `CONV-003`

   * Severity: `MEDIUM`
   * Problema: comparación incorrecta utilizando `= NULL`.

El nivel de riesgo general obtenido fue:

`CRITICAL`

Resumen del resultado:

* Critical: 2
* High: 0
* Medium: 2
* Low: 0
* Info: 0

La skill recomendó no ejecutar las operaciones `DELETE` y `UPDATE` hasta agregar condiciones `WHERE` seguras.

## Pass / Fail

**PASS**

El comportamiento obtenido coincide con el comportamiento esperado. La skill detectó todas las violaciones principales y asignó correctamente sus niveles de severidad.

## Problem detected

Ninguno.

La skill fue capaz de analizar múltiples sentencias y reportar varios hallazgos sin ocultar los problemas de mayor severidad.

## Modification made to the skill

Ninguna.

No fue necesario modificar la skill porque las reglas existentes detectaron correctamente las violaciones incluidas en esta prueba.
