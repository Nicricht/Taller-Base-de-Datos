from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]

results = []

def read(path):
    p = ROOT / path
    return p.read_text(encoding="utf-8") if p.exists() else ""

def check(name, condition, detail):
    results.append((name, bool(condition), detail))

report = read("docs/informe/EDUBIO360_EP1_INFORME.md")
ddl = read("database/01_create_tables.sql")
normalizacion = read("docs/normalizacion-3fn.md")
record_sql = read("plsql/01_record.sql")
varray_sql = read("plsql/02_varray.sql")
cursor_sql = read("plsql/03_cursor_loops.sql")
exceptions_sql = read("plsql/04_excepciones.sql")
future = read("docs/stored-objects-futuro.md")
assert_final = read("database/10_assert_final.sql")

check(
    "Proyecto identificado como EDUBIO360",
    "# EDUBIO360" in report and "**Proyecto:** EDUBIO360" in report,
    "El informe debe usar EDUBIO360 como nombre del proyecto."
)

required_report_sections = [
    "# 1. Introducción",
    "## 1.1 Descripción del proyecto",
    "## 1.2 Alcance",
    "## 1.3 Tecnologías utilizadas",
    "# 2. Contexto de negocio y datos a procesar",
    "# 3. Modelo de base de datos",
    "# 4. Tipos de datos compuestos",
    "## 4.1 RECORD",
    "## 4.2 VARRAY",
    "# 5. Cursores y loops",
    "# 6. Control de excepciones",
    "# 7. Evaluación de procedimientos, funciones, packages y triggers",
    "# 8. Conclusión",
    "# 9. Anexos",
]
missing_sections = [s for s in required_report_sections if s not in report]
check(
    "Estructura completa del informe",
    not missing_sections,
    "Faltan: " + ", ".join(missing_sections) if missing_sections else "Todas las secciones principales están presentes."
)

table_count = len(re.findall(r"\bCREATE\s+TABLE\b", ddl, flags=re.I))
check(
    "Mínimo de 10 tablas relacionadas",
    table_count >= 10,
    f"Se detectaron {table_count} tablas de negocio en 01_create_tables.sql."
)

check(
    "Normalización documentada hasta 3FN",
    all(term in normalizacion.upper() for term in ["1FN", "2FN", "3FN"]),
    "docs/normalizacion-3fn.md debe justificar 1FN, 2FN y 3FN."
)

check(
    "RECORD implementado",
    bool(re.search(r"\bTYPE\s+\w+\s+IS\s+RECORD\b", record_sql, flags=re.I)),
    "plsql/01_record.sql debe declarar y usar un RECORD."
)

check(
    "VARRAY implementado",
    bool(re.search(r"\bVARRAY\s*\(", varray_sql, flags=re.I)),
    "plsql/02_varray.sql debe declarar y usar un VARRAY."
)

parameterized_cursor = bool(re.search(r"\bCURSOR\s+\w+\s*\([^)]*\)\s+IS\b", cursor_sql, flags=re.I | re.S))
plain_cursor = bool(re.search(r"\bCURSOR\s+\w+\s+IS\b", cursor_sql, flags=re.I))
loop_count = len(re.findall(r"\bLOOP\b", cursor_sql, flags=re.I))
check(
    "Cursor explícito con parámetros",
    parameterized_cursor,
    "La pauta exige justificar un cursor explícito complejo parametrizado."
)
check(
    "Cursor sin parámetros",
    plain_cursor,
    "Las instrucciones específicas piden demostrar cursores con y sin parámetros."
)
check(
    "Más de un loop en el ejercicio de cursores",
    loop_count >= 2,
    f"Se detectaron {loop_count} apariciones de LOOP en plsql/03_cursor_loops.sql."
)

check(
    "Excepción predefinida de Oracle",
    "NO_DATA_FOUND" in exceptions_sql.upper(),
    "Debe existir al menos una excepción predefinida, actualmente se espera NO_DATA_FOUND."
)
check(
    "Excepción definida por el usuario",
    bool(re.search(r"\b\w+\s+EXCEPTION\s*;", exceptions_sql, flags=re.I))
    and bool(re.search(r"\bRAISE\s+\w+\s*;", exceptions_sql, flags=re.I)),
    "Debe declararse y lanzarse una excepción propia."
)

future_upper = (future + "\n" + report).upper()
objects_ok = all(word in future_upper for word in ["PROCEDURE", "FUNCTION", "PACKAGE", "TRIGGER"])
strategy_ok = any(word in future_upper for word in ["ESTRATEGIA", "FUTUR", "IMPLEMENTAR"])
limitations_ok = any(word in future_upper for word in ["LIMITACION", "LIMITACIÓN", "RENDIMIENTO", "MANTENIMIENTO", "SEGURIDAD"])
check(
    "Evaluación futura de Procedure, Function, Package y Trigger",
    objects_ok and strategy_ok and limitations_ok,
    "Debe explicar los cuatro objetos, su estrategia futura y al menos limitaciones/rendimiento/mantenimiento/seguridad."
)

check(
    "Volumen final superior a 1.000 registros contemplado",
    "106555" in assert_final or bool(re.search(r"\b[1-9]\d{3,}\b", assert_final)),
    "database/10_assert_final.sql debe comprobar un volumen final superior a 1.000 registros."
)

annex_terms = ["Código Completo", "Diagramas", "Anexos"]
check(
    "Anexos preparados en el informe",
    "# 9. Anexos" in report and any(term.lower() in report.lower() for term in annex_terms),
    "El informe final debe incluir código completo y diagramas/modelos como anexos."
)

evidence_dir = ROOT / "docs/evidencias/ejecucion-oracle"
evidence_files = []
if evidence_dir.exists():
    evidence_files = [
        p for p in evidence_dir.rglob("*")
        if p.is_file() and p.name.lower() != "readme.md"
    ]
check(
    "Evidencia real de ejecución Oracle",
    len(evidence_files) > 0,
    "CI solo comprueba que exista evidencia guardada. La validez de capturas/salidas debe revisarse manualmente."
)

passed = sum(1 for _, ok, _ in results if ok)
total = len(results)

print("=" * 72)
print("EDUBIO360 - QA DE CUMPLIMIENTO EP1")
print("=" * 72)
for name, ok, detail in results:
    state = "OK" if ok else "FALTA"
    print(f"[{state}] {name}")
    print(f"       {detail}")

print("-" * 72)
print(f"Resultado estático: {passed}/{total} controles aprobados.")

manual = [
    "Revisar que las explicaciones del informe sean coherentes con el código real.",
    "Ejecutar los scripts en Oracle y comprobar que las salidas coincidan con lo documentado.",
    "Verificar visualmente las capturas/evidencias antes de entregar.",
    "Completar nombres de integrantes y datos de portada.",
    "Exportar el informe final a DOCX/PDF y revisar formato, ortografía y legibilidad.",
]
print("\nCONTROLES MANUALES OBLIGATORIOS:")
for item in manual:
    print(f"- {item}")

if passed != total:
    print("\nQA NO APROBADO: todavía existen requisitos pendientes.")
    sys.exit(1)

print("\nQA ESTÁTICO APROBADO. Aún deben completarse los controles manuales.")
