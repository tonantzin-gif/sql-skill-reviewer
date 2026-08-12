# Performance Rules

Este documento define las reglas de rendimiento utilizadas por SQL Reviewer.

Las reglas de este archivo complementan el comportamiento definido en `SKILL.md`.

---

## PERF-001 - Uso de SELECT *

**Severity:** `MEDIUM`

### Condition

IF statement = SELECT
AND selected columns contain `*`
THEN severity = MEDIUM

### Problem

El uso de `SELECT *` solicita todas las columnas de una tabla aunque posiblemente no todas sean necesarias. Esto puede aumentar la cantidad de información recuperada y dificultar el mantenimiento de la consulta.

### Example

```sql
SELECT *
FROM usuarios;
```

### Recommendation

Seleccionar únicamente las columnas necesarias.

Ejemplo:

```sql
SELECT id, nombre, email
FROM usuarios;
```

---

## PERF-002 - Consulta potencialmente masiva sin LIMIT

**Severity:** `MEDIUM`

### Condition

IF statement = SELECT
AND LIMIT is absent
AND query has no evidently restrictive condition
THEN severity = MEDIUM

### Problem

Una consulta sin una condición suficientemente restrictiva y sin `LIMIT` puede devolver una gran cantidad de registros.

### Example

```sql
SELECT id, nombre, email
FROM usuarios;
```

### Recommendation

Cuando el objetivo de la consulta no requiera recuperar todos los registros, considerar agregar una condición apropiada o un `LIMIT`.

La skill no deberá afirmar cuántos registros devolverá la consulta si no dispone de esa información.

---

## PERF-003 - LIMIT aparentemente ineficaz

**Severity:** `MEDIUM`

### Condition

IF statement = SELECT
AND LIMIT exists
AND LIMIT value is evidently excessive
THEN severity = MEDIUM

### Example

```sql
SELECT id, nombre
FROM usuarios
LIMIT 1000000000;
```

### Problem

La presencia de `LIMIT` no garantiza que una consulta esté correctamente limitada. Un valor extremadamente alto puede tener prácticamente el mismo efecto que no utilizar un límite.

### Recommendation

Seleccionar un límite coherente con el objetivo de la consulta y con la cantidad de información que realmente necesita la aplicación.

---

## PERF-004 - Posible índice faltante

**Severity:** `INFO`

### Condition

IF query uses a column in WHERE, JOIN or ORDER BY
AND index information is not provided
THEN severity = INFO

### Problem

Las columnas utilizadas frecuentemente para filtros, relaciones u ordenamiento pueden beneficiarse de índices dependiendo del tamaño de la tabla y del patrón de uso.

Sin embargo, observar una columna en `WHERE`, `JOIN` u `ORDER BY` no demuestra por sí mismo que falte un índice.

### Example

```sql
SELECT id, nombre
FROM usuarios
WHERE email = 'ejemplo@email.com';
```

### Recommendation

Revisar los índices existentes y, cuando sea necesario, analizar el plan de ejecución antes de recomendar la creación de un nuevo índice.

### Insufficient information

Si no se proporciona información sobre los índices existentes, SQL Reviewer no deberá afirmar:

`La columna email necesita un índice.`

Deberá indicar:

`No se proporcionó información suficiente para determinar si la columna cuenta con un índice. Se recomienda revisar los índices existentes y el plan de ejecución cuando el rendimiento sea relevante.`

---

## PERF-005 - Operación sobre columna utilizada para búsqueda

**Severity:** `MEDIUM`

### Condition

IF a function or transformation is applied directly to a column used for filtering
THEN severity = MEDIUM
WHEN it may reasonably affect index usage

### Example

```sql
SELECT id, nombre
FROM usuarios
WHERE LOWER(email) = 'usuario@ejemplo.com';
```

### Problem

Aplicar una función directamente sobre una columna utilizada para filtrar puede afectar el uso eficiente de determinados índices, dependiendo del motor de base de datos y de los índices existentes.

### Recommendation

Revisar el plan de ejecución y las características del motor de base de datos antes de realizar una optimización.

La skill no deberá asegurar que el índice no será utilizado cuando no conozca el motor ni el plan de ejecución.

---

## PERF-006 - Consulta con información insuficiente para evaluar rendimiento

**Severity:** `INFO`

### Condition

IF determining performance requires table size, indexes, statistics or execution plan
AND this information is absent
THEN severity = INFO

### Problem

El rendimiento real de una consulta no siempre puede determinarse únicamente observando su código SQL.

### Recommendation

Solicitar o recomendar revisar información adicional como:

* Tamaño aproximado de las tablas.
* Índices existentes.
* Plan de ejecución.
* Cantidad estimada de registros.
* Motor de base de datos utilizado.

La skill deberá diferenciar entre un problema confirmado y una posible oportunidad de optimización.

---

## Performance validation

Antes de reportar un problema de rendimiento, SQL Reviewer deberá verificar:

1. Que exista evidencia en la consulta que justifique el hallazgo.
2. Que no se esté asumiendo el tamaño de una tabla.
3. Que no se inventen índices existentes o faltantes.
4. Que no se asuma un motor de base de datos específico.
5. Que `LIMIT` no sea considerado automáticamente suficiente.
6. Que una recomendación de índice se presente como posible cuando no exista información suficiente.
7. Que las conclusiones dependientes del plan de ejecución sean identificadas como tales.
