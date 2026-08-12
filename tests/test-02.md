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

La prueba fue ejecutada en Claude utilizando la versión actualizada del repositorio
`sql-skill-reviewer` desde GitHub.

La skill detectó cinco hallazgos:

1. RULE-005 / PERF-001
   Severity: MEDIUM
   Problema: uso de SELECT *.

2. RULE-006 / PERF-002
   Severity: MEDIUM
   Problema: consulta potencialmente masiva sin LIMIT.

3. RULE-001 / SEC-001
   Severity: CRITICAL
   Problema: DELETE sin WHERE.

4. RULE-002 / SEC-002
   Severity: CRITICAL
   Problema: UPDATE sin WHERE.

5. RULE-009
   Severity: MEDIUM
   Problema: comparación incorrecta con NULL.

El riesgo general obtenido fue:

CRITICAL

Resumen:

- Critical: 2
- High: 0
- Medium: 3
- Low: 0
- Info: 0
git 
## Pass / Fail

**PASS**

La skill detectó todos los problemas principales esperados y adicionalmente
identificó correctamente que SELECT * FROM usuarios; puede representar una
consulta potencialmente masiva sin LIMIT.

## Problem detected

No se detectó un problema en la skill.

Se observó que el comportamiento esperado original del test no contemplaba
PERF-002, aunque esta regla sí aplica correctamente a SELECT * FROM usuarios;
porque la consulta no contiene una condición restrictiva ni LIMIT.

## Modification made to the skill

Ninguna.

No fue necesario modificar la skill. Únicamente se actualizó la documentación
del test para reflejar el hallazgo adicional válido.
