# sql-skill-reviewer
Skill de IA para revisar código SQL, detectar riesgos de seguridad, rendimiento y malas prácticas, clasificando los hallazgos por nivel de severidad.

# SQL Reviewer Skill

Skill reutilizable para sistemas de inteligencia artificial diseñada para analizar código SQL e identificar posibles problemas de seguridad, rendimiento, convenciones y uso incorrecto del lenguaje SQL.

## Objetivo

El objetivo de este proyecto es construir una skill capaz de revisar sentencias y scripts SQL mediante un procedimiento definido, reglas explícitas, niveles de severidad, validaciones y manejo de errores.

La skill no ejecuta consultas ni modifica bases de datos. Su función es analizar el código proporcionado y generar recomendaciones técnicas.

## Integrantes

* Tonanzin Valentín Hernandez
* Janeth Aguelles Contreras

## Funcionalidades principales

SQL Reviewer puede detectar problemas como:

* Uso de `SELECT *`.
* `DELETE` sin una condición `WHERE` segura.
* `UPDATE` sin una condición `WHERE` segura.
* Condiciones aparentemente válidas pero potencialmente peligrosas.
* Operaciones destructivas como `DROP` y `TRUNCATE`.
* Posibles casos de SQL Injection.
* Consultas potencialmente masivas sin `LIMIT`.
* Valores de `LIMIT` excesivamente altos.
* Uso incorrecto de `NULL`.
* Nombres poco descriptivos.
* Convenciones inconsistentes.
* Posibles problemas relacionados con tipos de datos.
* Posibles índices que requieren revisión.
* Problemas razonables de rendimiento.

## Niveles de severidad

Los hallazgos se clasifican utilizando los siguientes niveles:

* `CRITICAL`: riesgo evidente de pérdida o modificación masiva de información.
* `HIGH`: problema grave que requiere revisión antes de ejecutar la sentencia.
* `MEDIUM`: problema relacionado principalmente con rendimiento o uso incorrecto de SQL.
* `LOW`: problema menor relacionado con claridad o convenciones.
* `INFO`: recomendación que necesita información adicional para confirmarse.

La prioridad utilizada es:

`CRITICAL > HIGH > MEDIUM > LOW > INFO`

## Estructura del proyecto

```text
sql-skill-reviewer/
│
├── README.md
├── SKILL.md
│
├── rules/
│   ├── security.md
│   ├── performance.md
│   └── conventions.md
│
├── examples/
│   ├── valid.sql
│   ├── invalid.sql
│   └── edge-cases.sql
│
└── tests/
    ├── test-01.md
    ├── test-02.md
    ├── test-03.md
    ├── test-04.md
    ├── test-05.md
    └── red-team-01.md
```

## Archivos principales

### `SKILL.md`

Define el comportamiento general de SQL Reviewer:

* Cuándo debe activarse.
* Cuándo no debe activarse.
* Qué entradas acepta.
* Procedimiento de análisis.
* Reglas.
* Niveles de severidad.
* Formato de salida.
* Validaciones.
* Manejo de errores.

### `rules/security.md`

Contiene las reglas relacionadas con seguridad e integridad de los datos.

### `rules/performance.md`

Contiene las reglas relacionadas con rendimiento, consultas masivas, uso de `LIMIT` e índices.

### `rules/conventions.md`

Contiene las reglas relacionadas con nombres, convenciones, uso de `NULL` y tipos de datos.

### `examples/`

Contiene ejemplos de consultas válidas, inválidas y casos límite.

### `tests/`

Contiene las pruebas realizadas para verificar el comportamiento de la skill.

## Ejemplo de uso

### Entrada

```sql
DELETE FROM usuarios
WHERE 1 = 1;
```

### Resultado esperado

```text
SQL REVIEW RESULT

Overall risk: CRITICAL

Findings:

Rule: SEC-003
Severity: CRITICAL
Problem: Condición WHERE evidentemente insegura.
Evidence: WHERE 1 = 1;
Reason: La condición es siempre verdadera y puede provocar
la eliminación de todos los registros.
Recommendation: DO NOT EXECUTE. Utilizar un filtro específico.
```

## Pruebas realizadas

Se realizaron cinco pruebas principales:

| Test    | Tipo                     | Resultado |
| ------- | ------------------------ | --------- |
| Test 01 | Happy Path               | PASS      |
| Test 02 | Error evidente           | PASS      |
| Test 03 | Edge Case                | PASS      |
| Test 04 | Información insuficiente | PASS      |
| Test 05 | Adversarial              | PASS      |

## Red Team

Después de las pruebas iniciales se realizó una prueba Red Team con la siguiente sentencia:

```sql
DELETE FROM usuarios
WHERE id > 0;
```

La versión inicial de la skill podía no identificar adecuadamente este caso porque la sentencia contiene una condición `WHERE` que no es universalmente verdadera de forma evidente.

### Problema encontrado

La skill detectaba condiciones como:

```sql
WHERE 1 = 1
```

pero no contemplaba suficientemente filtros cuyo alcance pudiera ser muy grande dependiendo de los datos almacenados.

### Mejora realizada

Se agregó:

`SEC-007 - Filtro potencialmente masivo con impacto desconocido`

y se incorporó `RULE-013` al archivo `SKILL.md`.

La nueva regla permite advertir sobre operaciones potencialmente masivas sin inventar cuántos registros serán afectados.

### Resultado

Resultado inicial:

`FAIL`

Después de modificar la skill:

`PASS`

## Manejo de información insuficiente

SQL Reviewer no debe inventar información cuando el contexto proporcionado no es suficiente.

Por ejemplo, ante:

```sql
SELECT nombre
FROM usuarios
WHERE email = 'ejemplo@email.com';
```

la skill no puede afirmar automáticamente que `email` necesita un índice si no conoce los índices existentes, el tamaño de la tabla o el plan de ejecución.

En estos casos genera una recomendación de tipo `INFO` y especifica qué información adicional sería necesaria.

## Limitaciones

La skill realiza el análisis con base en el SQL y el contexto proporcionado.

Algunos aspectos pueden requerir información adicional, como:

* Motor de base de datos.
* Estructura completa de las tablas.
* Índices existentes.
* Tamaño de las tablas.
* Estadísticas de la base de datos.
* Plan de ejecución.
* Reglas de negocio.

La skill no debe asumir esta información cuando no ha sido proporcionada.

## Conclusión

SQL Reviewer fue desarrollada como una skill reutilizable basada en reglas explícitas y un procedimiento de análisis definido.

Las pruebas permitieron comprobar su comportamiento ante consultas correctas, errores evidentes, casos límite, información insuficiente y entradas adversariales.

La fase Red Team permitió descubrir una limitación en las reglas iniciales, modificar la skill y verificar mediante una nueva prueba que el comportamiento había mejorado.
