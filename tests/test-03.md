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

## Actual behavior

Pendiente de ejecución.

## Pass / Fail

Pendiente.

## Problem detected

Pendiente de ejecución.

## Modification made to the skill

Pendiente.
