# Test 03 - Edge Case

## Input

```sql
DELETE FROM usuarios
WHERE 1 = 1;
```

## Expected behavior

La skill no deberá considerar segura la sentencia únicamente porque contiene una condición `WHERE`.

Deberá reconocer que `WHERE 1 = 1` es una condición evidentemente verdadera y que la operación puede eliminar todos los registros.

### Hallazgo esperado

* Regla: `SEC-003`
* Severity: `CRITICAL`
* Problem: condición `WHERE` evidentemente insegura.
* Recommendation: `DO NOT EXECUTE`.

### Overall risk esperado

`CRITICAL`

# Resultado para completar Test 03

## Actual behavior

La skill analizó la sentencia `DELETE` y reconoció que, aunque existe una condición `WHERE`, dicha condición no limita realmente los registros afectados.

Se detectó el siguiente hallazgo:

* Regla: `SEC-003`
* Severity: `CRITICAL`
* Problema: condición `WHERE` evidentemente insegura.
* Evidencia: `WHERE 1 = 1`
* Recomendación: `DO NOT EXECUTE` hasta sustituir la condición por un filtro específico y seguro.

El nivel de riesgo general obtenido fue:

`CRITICAL`

Resumen del resultado:

* Critical: 1
* High: 0
* Medium: 0
* Low: 0
* Info: 0

## Pass / Fail

**PASS**

El comportamiento obtenido coincide con el comportamiento esperado. La skill no consideró segura la sentencia únicamente por contener una condición `WHERE`.

## Problem detected

Ninguno.

La regla `SEC-003` permitió detectar correctamente una condición que es verdadera para todos los registros.

## Modification made to the skill

Ninguna.

No fue necesario modificar la skill porque la regla existente detectó correctamente el caso límite.
