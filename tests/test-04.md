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

La prueba fue ejecutada en Claude utilizando la versión actualizada del repositorio
`sql-skill-reviewer` desde GitHub.

La skill detectó que el usuario solicitó explícitamente evaluar si la columna
`email` necesita un índice.

Se generó el siguiente hallazgo:

- Regla: RULE-011
- Severidad: INFO
- Problema: revisión potencial de índice.
- Evidencia: WHERE email = 'ejemplo@email.com'
- Razón: no se proporcionó información sobre los índices existentes en la tabla
  usuarios.
- Recomendación: verificar si la columna email cuenta con un índice cuando esta
  consulta se ejecute frecuentemente o sobre una tabla con un volumen considerable
  de registros.

La skill no afirmó que la columna careciera de índice y reconoció correctamente
la falta de información.

El riesgo general obtenido fue:

INFO

Resumen:

- Critical: 0
- High: 0
- Medium: 0
- Low: 0
- Info: 1

## Pass / Fail

PASS

El comportamiento obtenido coincide con el comportamiento esperado.

La skill reconoció correctamente que no dispone de información suficiente para
confirmar si la columna email necesita un índice.

## Problem detected

Ninguno.

La versión actualizada de RULE-011 funcionó correctamente y solamente generó
el hallazgo INFO porque el usuario solicitó explícitamente un análisis de índices.

## Modification made to the skill

Ninguna adicional.

La modificación realizada previamente a RULE-011 permitió manejar correctamente
esta prueba sin inventar información sobre los índices existentes.
## Pass / Fail

**PASS**

El comportamiento obtenido coincide con el comportamiento esperado. La skill reconoció correctamente que no disponía de información suficiente para confirmar la existencia de un problema de índices.

## Problem detected

Ninguno.

La skill diferenció correctamente entre un problema confirmado y una posible recomendación que requiere información adicional.

## Modification made to the skill

Ninguna.

No fue necesario modificar la skill porque las reglas existentes manejaron correctamente la falta de información.
