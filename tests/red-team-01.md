# Red Team 01 - Filtro potencialmente masivo

## Objective

Intentar encontrar una sentencia `DELETE` que contenga una condición `WHERE` y que pueda superar las reglas de seguridad existentes.

## Input

```sql
DELETE FROM usuarios
WHERE id > 0;
```

## Initial behavior

La versión inicial de SQL Reviewer detectaba condiciones evidentemente inseguras como:

* `WHERE 1 = 1`
* `WHERE TRUE`
* `WHERE id = id`
* `LIKE '%'`

Sin embargo, no contemplaba suficientemente condiciones como `WHERE id > 0`, cuyo alcance depende de los datos almacenados.

La sentencia contiene un `WHERE`, por lo que no activa la regla de `DELETE` sin condición.

Además, no existe información suficiente para afirmar que todos los valores de `id` son mayores que cero.

## Initial result

**FAIL**

Se identificó una limitación en las reglas existentes.

## Problem detected

La skill podía pasar por alto condiciones que no son universalmente verdaderas de forma evidente, pero que potencialmente pueden afectar una gran cantidad de registros.

## Modification made to the skill

Se agregó la regla:

`SEC-007 - Filtro potencialmente masivo con impacto desconocido`

También se incorporó `RULE-013` al archivo `SKILL.md`.

La nueva regla establece:

IF statement = DELETE OR UPDATE
AND WHERE exists
AND condition may affect a broad range of records
AND actual affected rows cannot be determined
THEN severity = HIGH

La skill no debe asumir cuántos registros serán afectados cuando no dispone de los datos necesarios.

## Retest

Se volvió a analizar:

```sql
DELETE FROM usuarios
WHERE id > 0;
```

La versión actualizada generó:

* Rule: `SEC-007`
* Severity: `HIGH`
* Problem: filtro potencialmente masivo con impacto desconocido.
* Recommendation: verificar los registros afectados antes de ejecutar la eliminación.

## Final result

**PASS**

La modificación permitió que la skill detectara el riesgo sin asumir que todos los identificadores existentes son mayores que cero.

## Conclusion

La prueba Red Team permitió identificar una limitación que no había sido cubierta por los cinco casos iniciales.

La skill fue modificada y posteriormente volvió a probarse, obteniendo el comportamiento esperado.
