# Convention Rules

Este documento define las reglas relacionadas con convenciones, claridad y uso correcto de SQL utilizadas por SQL Reviewer.

Las reglas de este archivo complementan el comportamiento definido en `SKILL.md`.

---

## CONV-001 - Nombres poco descriptivos

**Severity:** `LOW`

### Condition

IF table OR column names are evidently ambiguous or non-descriptive
THEN severity = LOW

### Problem

Los nombres poco descriptivos pueden dificultar la comprensión y el mantenimiento de una base de datos.

### Example

```sql
CREATE TABLE x (
    a INT,
    b VARCHAR(100)
);
```

Los nombres `x`, `a` y `b` no permiten comprender claramente qué información representan.

### Recommendation

Utilizar nombres que indiquen claramente el propósito de la tabla y de sus columnas.

Ejemplo:

```sql
CREATE TABLE usuarios (
    id_usuario INT,
    nombre VARCHAR(100)
);
```

---

## CONV-002 - Convenciones de nombres inconsistentes

**Severity:** `LOW`

### Condition

IF identifiers use evidently inconsistent naming conventions
THEN severity = LOW

### Example

```sql
CREATE TABLE usuarios (
    id_usuario INT,
    NombreUsuario VARCHAR(100),
    correo_electronico VARCHAR(150)
);
```

### Problem

La combinación de diferentes estilos de nombres puede dificultar la lectura y mantenimiento del esquema.

### Recommendation

Mantener una convención consistente dentro del proyecto, por ejemplo:

```text
id_usuario
nombre_usuario
correo_electronico
```

La skill no deberá imponer una convención específica cuando el proyecto no la haya definido; deberá señalar únicamente la inconsistencia evidente.

---

## CONV-003 - Comparación incorrecta con NULL

**Severity:** `MEDIUM`

### Condition

IF comparison uses `= NULL`
OR comparison uses `!= NULL`
OR comparison uses `<> NULL`
THEN severity = MEDIUM

### Problem

`NULL` representa la ausencia de un valor y no debe compararse mediante operadores normales de igualdad o desigualdad.

### Invalid example

```sql
SELECT id, nombre
FROM usuarios
WHERE telefono = NULL;
```

### Recommendation

Utilizar:

```sql
SELECT id, nombre
FROM usuarios
WHERE telefono IS NULL;
```

Para comprobar que exista un valor, utilizar:

```sql
WHERE telefono IS NOT NULL;
```

---

## CONV-004 - Tipo de dato potencialmente inadecuado

**Severity:** `MEDIUM`

### Condition

IF schema definition is available
AND data type is evidently inconsistent with the demonstrated purpose of the column
THEN severity = MEDIUM

### Example

```sql
CREATE TABLE productos (
    id INT,
    precio VARCHAR(50)
);
```

### Problem

En el ejemplo, `precio` se almacena como texto aunque el SQL proporcionado muestra que representa un valor que podría requerir operaciones numéricas.

### Recommendation

Revisar si un tipo numérico apropiado, como `DECIMAL`, representa mejor el dato.

La skill no deberá determinar automáticamente un tipo exacto sin conocer los requisitos de precisión y rango.

---

## CONV-005 - Tipo de dato sin contexto suficiente

**Severity:** `INFO`

### Condition

IF determining the correct data type requires business requirements
AND requirements are not provided
THEN severity = INFO

### Problem

El nombre de una columna por sí solo no siempre permite determinar qué tipo de dato debe utilizarse.

### Example

```sql
CREATE TABLE clientes (
    telefono VARCHAR(20)
);
```

La skill no deberá asumir que `telefono` debería ser un número únicamente porque contiene dígitos.

### Recommendation

Solicitar o considerar los requisitos del dato antes de recomendar un cambio de tipo.

---

## CONV-006 - Alias poco descriptivo

**Severity:** `LOW`

### Condition

IF aliases are used
AND aliases make the query evidently harder to understand
THEN severity = LOW

### Example

```sql
SELECT a.nombre, b.total
FROM usuarios a
JOIN ventas b ON a.id = b.usuario_id;
```

### Problem

En consultas complejas, alias demasiado genéricos pueden dificultar identificar qué tabla representa cada referencia.

### Recommendation

Cuando mejore la claridad, utilizar alias descriptivos.

Ejemplo:

```sql
SELECT usr.nombre, vta.total
FROM usuarios AS usr
JOIN ventas AS vta ON usr.id = vta.usuario_id;
```

No se deberá generar este hallazgo automáticamente para todos los alias cortos. Solo deberá reportarse cuando afecte razonablemente la comprensión de la consulta.

---

## Convention validation

Antes de generar un hallazgo relacionado con convenciones, SQL Reviewer deberá comprobar:

1. Que el problema sea visible en el SQL proporcionado.
2. Que no se esté asumiendo una convención que el proyecto no haya definido.
3. Que no se inventen requisitos de negocio.
4. Que los tipos de datos solamente se cuestionen cuando exista evidencia suficiente.
5. Que las recomendaciones mejoren razonablemente la claridad o corrección del SQL.
6. Que una preferencia personal de estilo no se presente como un error obligatorio.
