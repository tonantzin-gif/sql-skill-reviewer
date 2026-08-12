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

## Actual behavior

Pendiente de ejecución.

## Pass / Fail

Pendiente.

## Problem detected

Pendiente de ejecución.

## Modification made to the skill

Pendiente.
