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

## Actual behavior

Pendiente de ejecución.

## Pass / Fail

Pendiente.

## Problem detected

Pendiente de ejecución.

## Modification made to the skill

Pendiente.
