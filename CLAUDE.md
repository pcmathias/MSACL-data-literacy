# MSACL DS 100: Data Literacy — Project Context for Claude

This file gives Claude the context needed to work on this project. Read it fully before making any suggestions or edits.

---

## What This Course Is

**DS 100** is a 9-hour short course taught at the MSACL (Mass Spectrometry: Applications to the Clinical Laboratory) conference. It teaches data literacy, visualization best practices, and computational thinking to clinical laboratory professionals. The target audience ranges from trainees to experienced academics who work with data every day but have rarely been taught foundational principles for thinking about and organizing it.

The course uses **RStudio and the tidyverse exclusively** — no spreadsheet software of any kind. It is designed as a **conceptual companion to MSACL 101** ("Breaking Up with Excel"), which teaches R syntax in depth. DS 100 builds the mental models; MSACL 101 builds the mechanics. Learners who take DS 100 before or alongside MSACL 101 will understand *why* they are writing each line of code, not just *how*.

**Statistics content (t-tests, regression, correlation) has been phased out.** The course now focuses on data literacy, visualization principles, computational thinking, data validation, joins, and reproducibility.

---

## Course Structure: Option 2 (4 Modules, 9 Hours)

The current working structure is **Option 2**, a 4-module design. The full detailed outline is in `updates_2026/DS100_course_outline_option2.md`. Here is the module summary:

| Module | Title | Duration | Primary tool/data |
|--------|-------|----------|-------------------|
| 1 | Data Literacy Foundations | 1.5 hrs | Text editor only — no R |
| 2 | Introduction to R and RStudio | 2.0 hrs | chem_data |
| 3 | Visualization Principles and Best Practices | 2.0 hrs | chem_data |
| 4 | Computational Approaches to Data | 3.5 hrs | chem_data (first half) + MS data (second half) |

**Exercise format:** Short check-ins (5–10 min) are interspersed after each topic section rather than batched at the end. Module 4 has a mid-module break. The only long exercise is the Module 4 capstone (44 min).

**Module 4 internal structure:**
- First half: CT framework → filter/select → pipe → mutate → group_by/summarize/pivot → Break
- Second half: Relational data/joins (using MS dataset) → Reproducibility/Quarto → Capstone

**Why visualization (Module 3) comes before transformation (Module 4):** Learners can build charts immediately using import skills from Module 2, which delivers an early win. The Module 3 setup chunks contain `filter()` calls with a comment "we'll understand this in Module 4" — a deliberate forward reference that makes the Module 4 callback land with recognition.

**Computational thinking pillars and their tidyverse mappings:**
- Decomposition → `filter()`, `select()`
- Algorithm → the pipe `|>`
- Abstraction → `mutate()`
- Pattern recognition → `group_by()` + `summarize()`

---

## Datasets

### chem_data (primary dataset, used Modules 2–4 first half)

**File:** `data/chem_data.csv`  
**Source:** Clinical chemistry data adapted from NHANES with synthetic patient identifiers  
**Size:** 155,544 rows, 6,481 patients, 24 analytes  
**Date range:** 2022-12-26 to 2022-12-27 (only 2 days — important for time-series exercises)

**Columns:** mrn, gender, age, pregnancy_status_at_exam, collect_dt, receive_dt, verify_dt, pat_type, payor_groups, last_name, test, value, units

**Key data facts:**
- `collect_dt` format in the raw CSV: `"%Y/%m/%d %H:%M:%S"` (must be specified explicitly in `col_datetime()`)
- `pat_type` values: outpatient, inpatient, icu, cancer center, client — with ~17% missing/NA
- `pregnancy_status_at_exam` is ~83% missing
- 24 analytes include: alanine_aminotransferase, albumin, alkaline_phosphatase, aspartate_aminotransferase, bicarbonate, blood_urea_nitrogen, chloride, cholesterol, creatine_phosphokinase, creatinine, gamma_glutamyl_transferase, globulin, glucose, iron, lactate_dehydrogenase, osmolality, phosphorus, potassium, sodium, total_bilirubin, total_calcium, total_protein, triglycerides, uric_acid
- Sodium reference range used in exercises: 135–145 mmol/L
- `data/chem_data_wide.csv` is the same data pivoted wide (~6,481 rows, one column per analyte)

**Relative path from exercise files:** `../../data/chem_data.csv`

### LC-MS/MS pain management dataset (used Module 4 second half)

Three related tables that mirror how instrument software actually exports data — used for the joins conceptual section and the capstone exercise:

| File | Rows | Columns | Description |
|------|------|---------|-------------|
| `data/peak_data.csv` | ~747K | batch_name, sample_name, compound_name, chromatogram_name, peak_area, peak_quality, manually_modified | Raw peak areas per ion transition |
| `data/sample_data.csv` | ~187K | batch_name, sample_name, compound_name, ion_ratio, response, concentration, sample_type, expected_concentration, used_for_curve, sample_passed | Processed results per sample |
| `data/batch_data_ts.csv` | ~3,594 | batch_name, instrument_name, compound_name, calibration_slope, calibration_intercept, calibration_R2, batch_passed, reviewer_name, batch_collected_ts, review_start_ts, review_complete_ts | Per-compound batch metadata |

**Key join facts:**
- `sample_data` joins to `batch_data_ts` on **both** `batch_name` AND `compound_name` (compound key — a deliberate teaching point)
- `peak_data` joins to `sample_data` on `batch_name` + `sample_name` + `compound_name`
- Compounds include opioids + deuterated internal standards (morphine, hydromorphone, oxymorphone, codeine, hydrocodone, oxycodone + their isotope-labeled analogs)
- 599 unique batches; ~23,712 unique samples

**Capstone exercise (4H)** uses `sample_data` + `batch_data_ts` to build a reproducible batch review pipeline: import → validate → explore patient sample concentrations → join on compound key → filter to passed batches → compute CV by compound × instrument → polished chart with 15% CV reference line.

---

## What Has Been Built

All files are in the `updates_2026/` directory:

```
updates_2026/
  DS100_course_outline_option2.md   ← Full detailed outline (source of truth)
  exercises/
    module_1_exercises.qmd          ← Check-ins 1A (data types), 1B (tidy/not tidy)
    module_2_exercises.qmd          ← Check-ins 2A (RStudio orientation), 2B (import), 2C (validation)
    module_3_exercises.qmd          ← Check-ins 3A–3C (written) + Exercises 3D–3E (coding)
    module_4_exercises.qmd          ← Check-ins 4A–4G + Capstone 4H (MS data)
    module_5_exercises.qmd          ← SUPERSEDED — content moved to module_4_exercises.qmd
```

**Not yet built:** Slide presentations for each module.

The original 5-module outline is at `DS100_course_outline.md` — kept for reference but superseded by Option 2.

---

## Relationship to MSACL 101

The MSACL 101 course ("Breaking Up with Excel," by Holmes, Spies, and Master) is in `background/MSACL 101 Course/`. It covers:
- Base R syntax, data structures (matrices, data frames, lists)
- Data I/O, sanity checking
- Regression: OLS, Passing-Bablok, Deming
- String manipulation
- Tidyverse: pivot, filter, select, joins, pipes, mutate, summarize

**DS 100 must not duplicate MSACL 101 content.** When DS 100 covers filter/mutate/joins/etc., it introduces the *concept and mental model*, not the syntax. MSACL 101 teaches the syntax.

---

## Key Design Decisions

- **No Excel anywhere.** RStudio only.
- **One primary dataset throughout** (chem_data), with the MS dataset introduced only in Module 4 second half.
- **Statistics removed.** No t-tests, regression, or correlation.
- **Quarto (.qmd) for all exercises.** Literate programming from day one — even Module 1, which has no R code, uses a .qmd so learners get comfortable with the environment before they need it computationally.
- **Module 1 has no R code.** Learners open the .qmd in RStudio as a text editor. A preamble instructs them to open the .Rproj file first — this is the orientation step before Module 2 formalizes RStudio as a computational tool.
- **Course material distribution:** Download ZIP from GitHub (not git clone — too complex for the venue). A QR code at the session points to the repo. Pre-course communications go out 1–2 weeks before with explicit "install before you arrive" instructions. Posit Cloud is the fallback for installation failures.
- **Exercise format:** Short check-ins (5–10 min) after each topic section. The only long standalone exercise is the Module 4 capstone.
- **The filter() preview in Module 3:** Setup chunks contain pre-written filter() calls labeled "we'll understand this in Module 4." This is intentional — it seeds curiosity and makes the Module 4 callback pedagogically powerful.
- **Capstone (4H) uses MS data** because chem_data's single-table structure doesn't create a natural need for joins. The MS dataset's three-table structure mirrors real instrument exports.

---

## Coding Conventions Used in Exercises

- Pipe: `|>` (base R pipe, not `%>%`)
- Always use `na.rm = TRUE` in summary functions
- Datetime imports always specify format explicitly: `col_datetime("%Y/%m/%d %H:%M:%S")`
- Factor columns use `col_factor()` in `read_csv()`
- Exercise blanks use `___` (three underscores)
- Code chunk labels use kebab-case: `filter-alk-phos`, `mutate-tat`, etc.
- Setup chunk always has `#| message: false` and `#| warning: false`
