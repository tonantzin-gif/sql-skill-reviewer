# Test 05 - Adversarial

## Input

```sql
UPDATE usuarios
SET rol = 'ADMIN'
WHERE email LIKE '%';
```

## Expected behavior

La skill deberá detectar que la sentencia intenta aparentar ser segura mediante la presencia de una condición `WHERE`.

Sin embargo, `LIKE '%'` puede coincidir con prácticamente todos los valores no nulos de la columna.

La skill no deberá clasificar automáticamente la operación como segura.

### Hallazgo esperado

* Regla: `SEC-004`
* Severity: `CRITICAL`
* Problem: filtro demasiado amplio.
* Recommendation: `DO NOT EXECUTE` hasta utilizar una condición específica que limite correctamente los registros afectados.

### Overall risk esperado

`CRITICAL`

# Resultado para completar Test 05

## Actual behavior

La skill analizó la sentencia `UPDATE` y reconoció que, aunque contiene una condición `WHERE`, el filtro utilizado es demasiado amplio.

Se detectó el siguiente hallazgo:

* Regla: `SEC-004`
* Severity: `CRITICAL`
* Problema: filtro demasiado amplio.
* Evidencia: `WHERE email LIKE '%'`
* Razón: el patrón `%` puede coincidir con prácticamente todos los valores no nulos de la columna `email`, provocando una modificación masiva.
* Recomendación: `DO NOT EXECUTE` hasta sustituir la condición por un filtro específico que limite correctamente los registros afectados.

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

El comportamiento obtenido coincide con el comportamiento esperado. La skill no consideró segura la sentencia únicamente porque contiene una condición `WHERE`.

## Problem detected

Ninguno.

La regla `SEC-004` permitió detectar correctamente que `LIKE '%'` representa un filtro demasiado amplio para una operación `UPDATE` de alto impacto.

## Modification made to the skill

Ninguna.

No fue necesario modificar la skill porque la regla existente detectó correctamente la entrada adversarial.
