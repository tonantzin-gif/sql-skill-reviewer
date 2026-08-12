# Security Rules

Este documento define las reglas de seguridad utilizadas por SQL Reviewer.

Las reglas de este archivo complementan el comportamiento definido en `SKILL.md`.

---

## SEC-001 - DELETE sin WHERE

**Severity:** `CRITICAL`

### Condition

IF statement = DELETE
AND WHERE is absent
THEN severity = CRITICAL
AND recommend = DO NOT EXECUTE

### Problem

Una sentencia `DELETE` sin una condición `WHERE` puede eliminar todos los registros de una tabla.

### Example

```sql
DELETE FROM usuarios;
```

### Recommendation

No ejecutar la sentencia hasta agregar una condición `WHERE` segura que limite correctamente los registros que serán eliminados.

---

## SEC-002 - UPDATE sin WHERE

**Severity:** `CRITICAL`

### Condition

IF statement = UPDATE
AND WHERE is absent
THEN severity = CRITICAL
AND recommend = DO NOT EXECUTE

### Problem

Una sentencia `UPDATE` sin `WHERE` puede modificar todos los registros de una tabla.

### Example

```sql
UPDATE usuarios
SET rol = 'ADMIN';
```

### Recommendation

No ejecutar la sentencia hasta agregar una condición `WHERE` segura que limite los registros que deben modificarse.

---

## SEC-003 - WHERE evidentemente inseguro

**Severity:** `CRITICAL`

### Condition

IF statement = DELETE OR UPDATE
AND WHERE condition is evidently always true
THEN severity = CRITICAL
AND recommend = DO NOT EXECUTE

### Problem

La presencia de `WHERE` no garantiza que una operación sea segura. Una condición que siempre sea verdadera puede afectar todos los registros.

### Examples

```sql
DELETE FROM usuarios
WHERE 1 = 1;
```

```sql
UPDATE usuarios
SET activo = 0
WHERE TRUE;
```

```sql
DELETE FROM usuarios
WHERE id = id;
```

### Recommendation

Reemplazar la condición por un filtro específico que identifique únicamente los registros que realmente deben modificarse o eliminarse.

---

## SEC-004 - Filtro demasiado amplio

**Severity:** `CRITICAL`

### Condition

IF statement = DELETE OR UPDATE
AND WHERE uses an evidently universal condition
THEN severity = CRITICAL
AND recommend = DO NOT EXECUTE

### Example

```sql
UPDATE usuarios
SET rol = 'ADMIN'
WHERE email LIKE '%';
```

### Problem

Aunque existe una condición `WHERE`, el patrón puede coincidir con prácticamente todos los valores no nulos de la columna y provocar una modificación masiva.

### Recommendation

Utilizar una condición específica que identifique únicamente los registros que realmente deben modificarse.

---

## SEC-005 - Operación destructiva

**Severity:** `HIGH`

### Condition

IF statement contains DROP OR TRUNCATE
THEN severity = HIGH

### Examples

```sql
DROP TABLE usuarios;
```

```sql
TRUNCATE TABLE usuarios;
```

### Problem

Estas operaciones pueden eliminar estructuras o grandes cantidades de información.

### Recommendation

Verificar explícitamente que la operación sea intencional antes de ejecutarla y comprobar que existan mecanismos de recuperación apropiados cuando sean necesarios.

Si el contexto proporcionado demuestra un riesgo inmediato de pérdida total de información, el hallazgo podrá elevarse a `CRITICAL` explicando la razón.

---

## SEC-006 - Posible SQL Injection

**Severity:** `HIGH`

### Condition

IF SQL construction contains evident string concatenation
AND concatenated value comes from external or user-controlled input
THEN severity = HIGH

### Example

```text
"SELECT * FROM usuarios WHERE nombre = '" + userInput + "'"
```

### Problem

Construir SQL mediante concatenación de datos proporcionados por el usuario puede permitir la alteración de la consulta original.

### Recommendation

Utilizar consultas parametrizadas o prepared statements en lugar de concatenar directamente la entrada del usuario.

### Insufficient information

Si se observa una concatenación pero no existe información suficiente para determinar el origen del valor, SQL Reviewer no deberá afirmar que existe una vulnerabilidad confirmada.

Deberá indicar que se necesita conocer el origen de los datos para determinar el riesgo.

---

## Conflict handling

Una sentencia puede activar más de una regla de seguridad.

Todos los hallazgos aplicables deberán reportarse.

Para calcular el riesgo general se utilizará la prioridad definida en `SKILL.md`:

`CRITICAL > HIGH > MEDIUM > LOW > INFO`

Una regla de menor severidad nunca deberá ocultar un hallazgo de mayor severidad.
