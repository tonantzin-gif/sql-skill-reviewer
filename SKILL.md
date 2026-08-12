# SQL Reviewer

## Purpose

SQL Reviewer es una skill diseñada para analizar sentencias y scripts SQL con el objetivo de identificar problemas de seguridad, rendimiento, convenciones y uso incorrecto del lenguaje SQL.

La skill no ejecuta consultas ni modifica bases de datos. Su función es revisar el código recibido, detectar posibles problemas, clasificar cada hallazgo por nivel de severidad y generar recomendaciones.

## When to activate

La skill debe activarse cuando el usuario:

* Solicite revisar una consulta SQL.
* Proporcione una sentencia SQL para analizar.
* Solicite detectar problemas de seguridad en una consulta SQL.
* Solicite revisar posibles problemas de rendimiento.
* Solicite identificar malas prácticas o errores en código SQL.
* Proporcione un script SQL que necesite revisión técnica.

## When NOT to activate

La skill no debe activarse cuando:

* La entrada no contenga código SQL.
* El usuario solicite ejecutar directamente una consulta.
* El usuario solicite conectarse o modificar una base de datos real.
* El usuario únicamente solicite una explicación teórica sobre bases de datos sin proporcionar código SQL para revisar.
* La información proporcionada no permita identificar una sentencia SQL.

Si la entrada es ambigua, la skill debe solicitar información adicional y no debe inventar código o contexto.

## Inputs

La skill puede recibir:

* Una sentencia SQL.
* Varias sentencias SQL.
* Un script SQL completo.
* Opcionalmente, el motor de base de datos utilizado.
* Opcionalmente, información sobre tablas, columnas, índices o relaciones.
* Opcionalmente, información sobre el objetivo de la consulta.

Cuando no se proporcione contexto suficiente para evaluar un aspecto específico, la skill debe indicarlo claramente y evitar asumir información no disponible.

# Sección para agregar a SKILL.md

## Procedure

Cuando la skill reciba código SQL deberá realizar el análisis siguiendo este orden:

1. **Validar la entrada**

   * Verificar que la entrada contenga una o más sentencias SQL reconocibles.
   * Si la entrada no contiene SQL suficiente para realizar el análisis, indicarlo y solicitar información adicional.

2. **Identificar el tipo de sentencia**

   * Determinar si se trata de `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `CREATE`, `ALTER`, `DROP` u otra operación SQL.

3. **Revisar riesgos de seguridad**

   * Detectar operaciones potencialmente destructivas.
   * Revisar `UPDATE` y `DELETE` para determinar si cuentan con una condición `WHERE` segura.
   * Detectar condiciones que puedan ser siempre verdaderas, como `WHERE 1 = 1`.
   * Buscar concatenaciones evidentes que puedan facilitar SQL Injection.

4. **Revisar posibles problemas de rendimiento**

   * Detectar el uso de `SELECT *`.
   * Revisar consultas potencialmente masivas sin `LIMIT`.
   * Identificar posibles problemas relacionados con índices cuando exista información suficiente.
   * Detectar operaciones que razonablemente puedan afectar el rendimiento.

5. **Revisar convenciones y uso del lenguaje SQL**

   * Identificar nombres poco descriptivos.
   * Revisar convenciones inconsistentes.
   * Detectar usos incorrectos de `NULL`.
   * Revisar posibles problemas con tipos de datos cuando exista información suficiente.

6. **Clasificar los hallazgos**

   * Asignar a cada problema uno de los siguientes niveles:

     * `CRITICAL`
     * `HIGH`
     * `MEDIUM`
     * `LOW`
     * `INFO`

7. **Generar recomendaciones**

   * Explicar qué problema fue encontrado.
   * Mostrar la evidencia correspondiente.
   * Indicar por qué representa un problema.
   * Proporcionar una recomendación para corregirlo.

8. **Validar el resultado**

   * No reportar problemas que no puedan justificarse con el SQL o el contexto proporcionado.
   * No inventar tablas, columnas, índices, relaciones o características de la base de datos.
   * Cuando falte información, indicarlo explícitamente.

9. **Generar la respuesta final**

   * Mostrar todos los hallazgos encontrados.
   * Mostrar la severidad de cada hallazgo.
   * Indicar el nivel de riesgo general de la consulta.
   * Si no se encuentran problemas, indicarlo sin generar hallazgos artificiales.

# Secciones para agregar a SKILL.md

## Rules

La skill deberá aplicar las siguientes reglas durante el análisis.

### RULE-001 - DELETE sin WHERE

IF statement = DELETE
AND WHERE is absent
THEN severity = CRITICAL
AND recommend = DO NOT EXECUTE

La sentencia puede eliminar todos los registros de una tabla.

### RULE-002 - UPDATE sin WHERE

IF statement = UPDATE
AND WHERE is absent
THEN severity = CRITICAL
AND recommend = DO NOT EXECUTE

La sentencia puede modificar todos los registros de una tabla.

### RULE-003 - WHERE no seguro

IF statement = DELETE OR UPDATE
AND WHERE condition is evidently always true
THEN severity = CRITICAL
AND recommend = DO NOT EXECUTE

Ejemplos de condiciones evidentemente inseguras:

* `WHERE 1 = 1`
* `WHERE TRUE`
* `WHERE id = id`
* Condiciones equivalentes que claramente coincidan con todos los registros.

La existencia de `WHERE` por sí sola no significa que una operación sea segura.

Los patrones LIKE '%' deberán evaluarse mediante la regla específica
de filtros demasiado amplios y no mediante RULE-003.

Los patrones demasiado amplios como LIKE '%' deberán ser evaluados mediante
RULE-014 / SEC-004 y no mediante RULE-003.

RULE-003 deberá utilizarse principalmente para condiciones evidentemente siempre
verdaderas, como:

- WHERE 1 = 1
- WHERE TRUE
- WHERE id = id

### RULE-004 - Operación destructiva

IF statement contains DROP OR TRUNCATE
THEN severity = HIGH

La skill deberá advertir que la operación puede eliminar estructuras o grandes cantidades de información.

Si el contexto demuestra un riesgo inmediato de pérdida total de información, la severidad puede elevarse a `CRITICAL`, explicando el motivo.

### RULE-005 - SELECT *

IF SELECT contains *
THEN severity = MEDIUM

Se deberá recomendar seleccionar únicamente las columnas necesarias cuando sea posible.

### RULE-006 - Consulta potencialmente masiva sin LIMIT

IF statement = SELECT
AND query has no restrictive condition
AND LIMIT is absent
THEN severity = MEDIUM

La skill deberá advertir que la consulta podría devolver una gran cantidad de registros.

No deberá afirmar cuántos registros devolverá si esa información no está disponible.

### RULE-007 - LIMIT aparentemente ineficaz

IF statement = SELECT
AND LIMIT exists
AND LIMIT value is evidently excessive
THEN severity = MEDIUM

La existencia de `LIMIT` no deberá considerarse automáticamente suficiente para clasificar una consulta como segura o eficiente.

### RULE-008 - Posible SQL Injection

IF SQL contains evident dynamic string concatenation using external or user-controlled input
THEN severity = HIGH

La skill deberá recomendar el uso de consultas parametrizadas o prepared statements.

Si no existe información suficiente para determinar el origen de los valores concatenados, deberá indicarlo en lugar de asumir que existe una vulnerabilidad confirmada.

### RULE-009 - Uso incorrecto de NULL

IF comparison uses = NULL OR != NULL OR <> NULL
THEN severity = MEDIUM

Recomendar:

* `IS NULL`
* `IS NOT NULL`

según corresponda.

### RULE-010 - Nombres poco descriptivos

IF table OR column names are evidently ambiguous or non-descriptive
THEN severity = LOW

Ejemplos:

* `tabla1`
* `dato`
* `x`
* `a`

La skill deberá explicar por qué el nombre dificulta la comprensión antes de generar el hallazgo.

### RULE-011 - Revisión potencial de índice

SI el usuario solicita explícitamente un análisis de índices o rendimiento
O la consulta contiene evidencia razonable de un posible problema de rendimiento
Y no se proporciona información sobre los índices existentes
ENTONCES severity = INFO

No generar un hallazgo relacionado con índices únicamente porque una columna
aparezca en WHERE, JOIN u ORDER BY.

Si la consulta es simple y no existe evidencia de un problema de rendimiento,
no se debe generar un hallazgo INFO de manera artificial.

La skill no debe asumir si un índice existe o no.

### RULE-012 - Tipo de dato potencialmente inadecuado

IF schema definition is provided
AND a data type is evidently inconsistent with the purpose shown in the SQL
THEN severity = MEDIUM

Si no existe información suficiente para determinar el uso real del campo, la skill deberá indicar la limitación y no asumir que el tipo es incorrecto.

### RULE-013 - Filtro potencialmente masivo

IF statement = DELETE OR UPDATE
AND WHERE exists
AND condition may affect a broad range of records
AND actual affected rows cannot be determined
THEN severity = HIGH

Do not assume how many rows will be affected.
Recommend verifying the affected records before execution.

### RULE-014 - Filtro demasiado amplio

SI statement = DELETE OR UPDATE
Y WHERE utiliza un patrón evidentemente demasiado amplio, como LIKE '%'
ENTONCES severity = CRITICAL

La skill deberá reconocer que la existencia de una condición WHERE no garantiza
que la operación sea segura cuando el filtro puede coincidir con una gran cantidad
de registros.

Ejemplo:

UPDATE usuarios
SET rol = 'ADMIN'
WHERE email LIKE '%';

La skill deberá indicar que LIKE '%' puede coincidir con prácticamente todos los
valores no nulos de la columna.

NO deberá afirmar que necesariamente coincide con todos los registros.

La recomendación deberá ser:

DO NOT EXECUTE.

Se deberá utilizar una condición específica que limite correctamente los registros
que realmente deben modificarse o eliminarse.
---

## Severity levels

Los hallazgos deberán clasificarse utilizando uno de los siguientes niveles:

### CRITICAL

Problema con posibilidad evidente de producir pérdida masiva de información, modificación masiva no controlada o consecuencias graves si la sentencia es ejecutada.

Ejemplos:

* `DELETE` sin `WHERE`.
* `UPDATE` sin `WHERE`.
* `DELETE` o `UPDATE` con una condición evidentemente siempre verdadera.

### HIGH

Problema grave de seguridad, integridad de datos u operación destructiva que requiere revisión antes de ejecutar la sentencia.

Ejemplos:

* Posible SQL Injection claramente identificable.
* Operaciones destructivas como `DROP` o `TRUNCATE`.

### MEDIUM

Problema que puede afectar el rendimiento, la calidad de la consulta o el comportamiento esperado, pero que normalmente no representa una pérdida inmediata de información.

Ejemplos:

* `SELECT *`.
* Consulta potencialmente masiva sin `LIMIT`.
* Uso incorrecto de `NULL`.

### LOW

Problema menor relacionado principalmente con claridad, mantenimiento o convenciones.

Ejemplo:

* Nombres evidentemente poco descriptivos.

### INFO

Información o recomendación que requiere contexto adicional para determinar si realmente existe un problema.

Ejemplo:

* Recomendar verificar un posible índice cuando no se conoce la estructura de índices de la tabla.

### Conflicto entre reglas

Una misma sentencia puede activar varias reglas.

La skill deberá reportar todos los hallazgos aplicables.

Para determinar el riesgo general se utilizará la siguiente prioridad:

`CRITICAL > HIGH > MEDIUM > LOW > INFO`

El nivel de riesgo general será igual a la severidad más alta encontrada.

Una regla de menor severidad no deberá ocultar un hallazgo de mayor severidad.

# Secciones finales para SKILL.md

## Expected output

La skill deberá generar una respuesta clara y consistente utilizando la siguiente estructura:

### SQL REVIEW RESULT

**Overall risk:** `CRITICAL | HIGH | MEDIUM | LOW | INFO | NONE`

### Findings

Por cada problema encontrado se deberá mostrar:

* **Rule:** identificador de la regla activada.
* **Severity:** nivel de severidad.
* **Problem:** descripción breve del problema.
* **Evidence:** parte de la sentencia SQL que originó el hallazgo.
* **Reason:** explicación de por qué representa un problema.
* **Recommendation:** acción recomendada para corregir o revisar el problema.

Ejemplo:

```text
SQL REVIEW RESULT

Overall risk: CRITICAL

Findings:

1. RULE-001
   Severity: CRITICAL
   Problem: DELETE sin WHERE
   Evidence: DELETE FROM usuarios;
   Reason: La sentencia puede eliminar todos los registros de la tabla.
   Recommendation: No ejecutar la sentencia hasta agregar una condición WHERE segura.

Summary:
Critical: 1
High: 0
Medium: 0
Low: 0
Info: 0
```

Si no se encuentran problemas:

```text
SQL REVIEW RESULT

Overall risk: NONE

Findings:
No se encontraron problemas evidentes con las reglas disponibles.

Summary:
Critical: 0
High: 0
Medium: 0
Low: 0
Info: 0
```

La skill no deberá crear hallazgos artificiales únicamente para llenar el reporte.

---

## Validation

Antes de generar la respuesta final, la skill deberá comprobar:

1. Que cada hallazgo corresponda con una regla definida.
2. Que cada hallazgo incluya una severidad válida:

   * `CRITICAL`
   * `HIGH`
   * `MEDIUM`
   * `LOW`
   * `INFO`
3. Que la evidencia utilizada exista realmente en el SQL proporcionado.
4. Que las recomendaciones estén relacionadas con el problema detectado.
5. Que no se hayan inventado tablas, columnas, índices, relaciones o datos.
6. Que la existencia de `WHERE` no sea considerada automáticamente como una operación segura.
7. Que la existencia de `LIMIT` no sea considerada automáticamente como garantía de una consulta eficiente.
8. Que los hallazgos que requieran contexto adicional sean identificados como tales.
9. Que el nivel `Overall risk` corresponda a la severidad más alta encontrada.
10. Que una consulta correcta pueda finalizar sin hallazgos cuando ninguna regla sea activada.

Si una validación falla, la skill deberá corregir el análisis antes de generar la respuesta final.

---

## Failure handling

La skill deberá manejar los casos en los que no pueda realizar un análisis confiable.

### Entrada sin SQL

Si la entrada no contiene una sentencia SQL reconocible, la skill deberá indicar:

`No se identificó una sentencia SQL para revisar.`

No deberá inventar una consulta para continuar el análisis.

### SQL incompleto

Si la sentencia parece estar incompleta y esto impide realizar un análisis confiable, la skill deberá indicar qué información falta.

Ejemplo:

```sql
SELECT nombre
FROM
```

Respuesta esperada:

`La sentencia SQL parece estar incompleta. No es posible realizar una revisión completa hasta conocer la tabla consultada.`

### Información insuficiente

Cuando una regla requiera información que no fue proporcionada, la skill deberá reconocer la limitación.

Por ejemplo, si se analiza:

```sql
SELECT nombre
FROM usuarios
WHERE email = 'ejemplo@email.com';
```

y no existe información sobre índices, la skill no deberá afirmar:

`La columna email no tiene índice.`

En su lugar deberá indicar:

`No se proporcionó información sobre los índices existentes. Se recomienda verificar si email cuenta con un índice cuando la consulta se ejecuta frecuentemente sobre una tabla grande.`

### Motor de base de datos desconocido

Si una conclusión depende de características específicas de MySQL, PostgreSQL, SQL Server, Oracle u otro motor y el usuario no especificó cuál utiliza, la skill deberá indicarlo.

No deberá asumir automáticamente un motor de base de datos.

### Entrada ambigua

Si existen varias interpretaciones razonables que podrían cambiar el resultado del análisis, la skill deberá solicitar contexto adicional o indicar la incertidumbre.

### Intentos de evadir las reglas

La skill deberá analizar el comportamiento probable de una sentencia y no limitarse a comprobar la presencia de palabras como `WHERE` o `LIMIT`.

Por ejemplo:

```sql
DELETE FROM usuarios WHERE 1 = 1;
```

deberá seguir considerándose una operación crítica aunque contenga `WHERE`.

### Regla general ante fallos

Cuando no exista información suficiente para llegar a una conclusión confiable:

**No inventar contexto → indicar la limitación → solicitar o recomendar la información necesaria.**
