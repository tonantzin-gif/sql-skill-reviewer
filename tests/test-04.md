# Test 04 - Información insuficiente

## Input

```sql
SELECT nombre
FROM usuarios
WHERE email = 'ejemplo@email.com';
```

Pregunta adicional:

¿La columna `email` necesita un índice?

## Expected behavior

La skill deberá reconocer que no dispone de información suficiente para determinar si falta un índice.

No deberá afirmar que `email` carece de índice porque no se proporcionó el esquema completo, los índices existentes, el tamaño de la tabla ni el plan de ejecución.

Podrá generar un hallazgo `INFO` indicando que se recomienda revisar los índices existentes si el rendimiento de esta consulta es relevante.

### Overall risk esperado

`INFO`

La respuesta deberá distinguir entre un problema confirmado y una recomendación que requiere información adicional.

# Resultado para completar Test 04

## Actual behavior

La skill analizó la consulta y detectó que la columna `email` se utiliza como condición de búsqueda mediante `WHERE`.

Sin embargo, reconoció que no existe información suficiente para determinar si la columna necesita un índice.

Se generó el siguiente hallazgo:

* Regla: `PERF-004`
* Severity: `INFO`
* Evidencia: `WHERE email = 'ejemplo@email.com'`
* Problema: no existe información suficiente para determinar si falta un índice.
* Recomendación: revisar los índices existentes y, cuando el rendimiento sea relevante, analizar el plan de ejecución antes de recomendar la creación de un nuevo índice.

La skill no inventó información sobre los índices existentes, el tamaño de la tabla ni el plan de ejecución.

El nivel de riesgo general obtenido fue:

`INFO`

Resumen del resultado:

* Critical: 0
* High: 0
* Medium: 0
* Low: 0
* Info: 1

## Pass / Fail

**PASS**

El comportamiento obtenido coincide con el comportamiento esperado. La skill reconoció correctamente que no disponía de información suficiente para confirmar la existencia de un problema de índices.

## Problem detected

Ninguno.

La skill diferenció correctamente entre un problema confirmado y una posible recomendación que requiere información adicional.

## Modification made to the skill

Ninguna.

No fue necesario modificar la skill porque las reglas existentes manejaron correctamente la falta de información.
