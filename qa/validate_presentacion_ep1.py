#!/usr/bin/env python3
"""QA estático de la presentación EP1 de EDUBIO360.

No requiere dependencias externas. Inspecciona el PPTX como archivo Open XML,
extrae textos/notas y valida cobertura mínima de la pauta oficial.
"""

from __future__ import annotations

import re
import sys
import zipfile
from pathlib import Path
from xml.etree import ElementTree as ET

PPTX = Path("docs/presentacion/EDUBIO360_EP1_PRESENTACION_FINAL.pptx")

A_NS = "{http://schemas.openxmlformats.org/drawingml/2006/main}"
P_NS = "{http://schemas.openxmlformats.org/presentationml/2006/main}"


def natural_key(path: str) -> tuple:
    return tuple(int(x) if x.isdigit() else x.lower() for x in re.split(r"(\d+)", path))


def xml_text(data: bytes) -> str:
    root = ET.fromstring(data)
    return " ".join((node.text or "").strip() for node in root.iter(f"{A_NS}t") if (node.text or "").strip())


def count_pictures(data: bytes) -> int:
    root = ET.fromstring(data)
    return sum(1 for _ in root.iter(f"{P_NS}pic"))


def contains(text: str, *terms: str) -> bool:
    t = text.casefold()
    return all(term.casefold() in t for term in terms)


def any_contains(text: str, terms: tuple[str, ...]) -> bool:
    t = text.casefold()
    return any(term.casefold() in t for term in terms)


def check(label: str, ok: bool, detail: str, results: list[tuple[str, bool, str]]) -> None:
    results.append((label, ok, detail))


def main() -> int:
    if not PPTX.exists():
        print(f"ERROR: no existe {PPTX}")
        return 2

    results: list[tuple[str, bool, str]] = []

    try:
        with zipfile.ZipFile(PPTX) as zf:
            names = zf.namelist()
            slide_files = sorted(
                [n for n in names if re.fullmatch(r"ppt/slides/slide\d+\.xml", n)],
                key=natural_key,
            )
            note_files = sorted(
                [n for n in names if re.fullmatch(r"ppt/notesSlides/notesSlide\d+\.xml", n)],
                key=natural_key,
            )
            slides = [xml_text(zf.read(n)) for n in slide_files]
            notes = [xml_text(zf.read(n)) for n in note_files]
            picture_counts = [count_pictures(zf.read(n)) for n in slide_files]
    except (zipfile.BadZipFile, ET.ParseError) as exc:
        print(f"ERROR: PPTX inválido o XML corrupto: {exc}")
        return 2

    deck = "\n".join(slides)
    note_text = "\n".join(notes)
    combined = deck + "\n" + note_text

    check("PPTX válido", len(slides) > 0, f"{len(slides)} diapositivas detectadas", results)
    check("Extensión ejecutiva", 8 <= len(slides) <= 12, f"{len(slides)} diapositivas", results)
    check("Notas del presentador", len(notes) == len(slides) and all(len(n.strip()) >= 30 for n in notes), f"{len(notes)} notas para {len(slides)} diapositivas", results)

    check(
        "Problema, relevancia y contexto",
        any_contains(combined, ("problema", "estructura plana")) and contains(combined, "EDUBIO360"),
        "Se explica el problema de la fuente plana y el objetivo de EDUBIO360.",
        results,
    )
    check(
        "Datos e información a generar",
        contains(combined, "106.555", "28 columnas") and any_contains(combined, ("comparar ofertas", "ofertas académicas")),
        "Incluye volumen, tipos de datos y objetivo de consulta/comparación.",
        results,
    )

    record_ok = contains(combined, "RECORD", "oferta") and any_contains(combined, ("agrupa", "estructura"))
    varray_ok = contains(combined, "VARRAY", "5") and contains(combined, "BULK COLLECT")
    check("IE1.1.2 RECORD", record_ok, "Justifica RECORD como estructura para una oferta académica.", results)
    check("IE1.1.2 VARRAY", varray_ok, "Justifica VARRAY(5), límite conocido y BULK COLLECT.", results)

    cursor_ok = (
        contains(combined, "cursor sin parámetros", "cursor parametrizado")
        and contains(combined, "c_ofertas_por_area", "p_id_area")
        and contains(combined, "LOOP externo", "LOOP interno")
    )
    check("IE1.2.2 Cursores + loops", cursor_ok, "Incluye cursor sin parámetros, parametrizado y loops anidados.", results)
    check(
        "Cursores desde múltiples tablas",
        contains(combined, "denominación", "carrera", "nivel", "oferta", "institución", "plan"),
        "La presentación explicita la integración de varias tablas relacionadas.",
        results,
    )

    exc_ok = contains(combined, "NO_DATA_FOUND", "TOO_MANY_ROWS", "e_arancel_invalido")
    exc_conditions_ok = contains(combined, "no devuelve ninguna fila") and contains(combined, "devuelve varias") and contains(combined, "arancel es negativo")
    check("IE1.3.2 Excepciones", exc_ok, "Incluye excepciones Oracle y una excepción definida por el usuario.", results)
    check("Condiciones de uso de excepciones", exc_conditions_ok, "Explica cuándo se dispara cada caso.", results)

    stored_ok = all(term.casefold() in combined.casefold() for term in ("PROCEDURE", "FUNCTION", "PACKAGE", "TRIGGER"))
    future_ok = any_contains(combined, ("uso futuro", "se incorporarían", "futuro"))
    risk_ok = contains(combined, "Rendimiento", "Mantenimiento", "Seguridad", "Integridad")
    check("IE1.4.2 Objetos almacenados", stored_ok and future_ok, "Explica utilización futura de Procedure, Function, Package y Trigger.", results)
    check("Interacción y riesgos", risk_ok, "Incluye rendimiento, mantenimiento, seguridad e integridad.", results)

    check("Conclusión", any_contains(slides[-1] if slides else "", ("Conclusión", "Resultado")), "La última diapositiva cierra con síntesis y resultado.", results)

    max_chars = max((len(s) for s in slides), default=0)
    check("Carga textual controlada", max_chars <= 1700, f"Máximo {max_chars} caracteres de texto en una diapositiva", results)
    check("Apoyo visual", sum(1 for n in picture_counts if n > 0) >= 3, f"{sum(1 for n in picture_counts if n > 0)} diapositivas contienen imágenes", results)
    check("Sin placeholders", not any_contains(combined, ("lorem ipsum", "placeholder", "insert text")), "No se detectaron textos de relleno.", results)

    passed = sum(1 for _, ok, _ in results if ok)
    total = len(results)

    print("EDUBIO360 - QA PRESENTACIÓN EP1")
    print("=" * 58)
    for label, ok, detail in results:
        print(f"[{'PASS' if ok else 'FAIL'}] {label}: {detail}")
    print("-" * 58)
    print(f"RESULTADO: {passed}/{total} controles aprobados")

    return 0 if passed == total else 1


if __name__ == "__main__":
    sys.exit(main())
