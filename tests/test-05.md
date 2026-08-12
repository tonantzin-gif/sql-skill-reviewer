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

La prueba fue ejecutada en Claude utilizando la versión actualizada del repositorio
`sql-skill-reviewer` desde GitHub.

La skill identificó correctamente que la condición:

WHERE email LIKE '%'

representa un filtro demasiado amplio para una operación UPDATE.

El resultado obtenido fue:

- Regla aplicada: RULE-003
- Severidad: CRITICAL
- Riesgo general: CRITICAL

La skill recomendó no ejecutar la sentencia hasta utilizar una condición
más específica.

Sin embargo, se detectaron dos diferencias respecto al comportamiento esperado:

1. Se utilizó RULE-003 en lugar de SEC-004.
2. La explicación indicó que LIKE '%' coincide con cualquier valor de email,
   cuando sería más preciso indicar que puede coincidir con prácticamente
   todos los valores no nulos.

## Pass / Fail

FAIL - Ejecución inicial

## Problem detected

Existe una superposición entre RULE-003 y SEC-004.

La condición LIKE '%' puede ser interpretada tanto como un WHERE inseguro
como un filtro demasiado amplio, lo que provoca que la skill no aplique
siempre la misma regla.

Además, la explicación debe evitar afirmar que LIKE '%' coincide con todos
los valores, ya que pueden existir valores NULL.

## Modification made to the skill

Se deberá establecer que los patrones amplios como LIKE '%' sean evaluados
primero mediante SEC-004.

RULE-003 quedará reservada principalmente para condiciones evidentemente
siempre verdaderas como:

- WHERE 1 = 1
- WHERE TRUE
- WHERE id = id

## Pass / Fail

**PASS**

El comportamiento obtenido coincide con el comportamiento esperado. La skill no consideró segura la sentencia únicamente porque contiene una condición `WHERE`.

## Problem detected

Ninguno.

La regla `SEC-004` permitió detectar correctamente que `LIKE '%'` representa un filtro demasiado amplio para una operación `UPDATE` de alto impacto.

## Modification made to the skill

Ninguna.

No fue necesario modificar la skill porque la regla existente detectó correctamente la entrada adversarial.
