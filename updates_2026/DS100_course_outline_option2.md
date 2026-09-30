# DS 100: Data Literacy for Clinical Laboratory Professionals
## Course Outline — Option 2 (4-Module Structure)

**Total instructional time:** 9 hours  
**Format:** 4 modules; exercises are short (5–15 min) and interspersed after each topic section rather than batched at the end; Module 4 includes a mid-module break  
**Primary dataset:** Clinical chemistry data adapted from NHANES with synthetic patient information (chem_data); the original course's LC-MS/MS pain management dataset (peak_data, sample_data, batch_data_ts) is reintroduced for the joins exercise and capstone  
**Tools:** RStudio and the tidyverse throughout — no spreadsheet software required

### Relationship to MSACL 101 (Breaking Up with Excel)

This course is designed as a conceptual companion to the MSACL 101 R programming course. Where MSACL 101 teaches the syntax and mechanics of R in depth — functions, data structures, regression, string manipulation — DS 100 builds the underlying mental models and data literacy frameworks that make those skills meaningful. Learners who take DS 100 before or alongside MSACL 101 will understand *why* they are writing each line of code, not just *how*. Topics taught at the function level in MSACL 101 (joins, pivot, filter/select, mutate, summarize) are introduced here at the conceptual level so learners arrive with the right mental model already in place.

### Rationale for 4-Module Structure

The 5-module version treats computational thinking as a destination — a standalone module introduced after learners have been practicing it for two hours without knowing it. This structure brings the computational thinking framework forward as an explicit organizing lens for data transformation, then uses visualization as the bridge between "understanding your data" (Modules 1–2) and "systematically working with it" (Module 4). Reproducibility becomes the capstone of the merged module rather than a separate topic, because a reproducible analysis is simply a well-documented algorithm applied to well-organized data — the natural endpoint of everything that came before.

---

## Module 1: Data Literacy Foundations
**Duration: 1.4 hours**

### Learning Objectives
- Distinguish common data types and explain why type matters for downstream analysis
- Identify whether a dataset follows tidy data principles and articulate the tradeoffs
- Recognize common data quality issues and explain their downstream consequences

### Topics and Interspersed Exercises

**1.1 What Is Data? (10 min)**  
Data as observations recorded systematically; the distinction between raw and derived values; why structure matters before any analysis begins.

**1.2 Data Types — including censored/LOD values (15 min)**  
Numeric, categorical, ordinal, datetime, and censored/LOD types; why misidentifying a type causes downstream errors; how types appear in a raw CSV.

→ **Check-in 1A: Spot the Types (10 min)**  
Open chem_data.csv in a text editor (no R yet). For each of the 13 columns, predict the data type and note any ambiguities — particularly collect_dt, value, and pregnancy_status_at_exam. Debrief as a group; instructor highlights the datetime format string and the LOD issue in value.

**1.3 Tidy Data Principles (12 min)**  
Each variable a column, each observation a row, each value a cell; why the same data can be structured multiple ways; the tradeoffs between long and wide formats.

→ **Check-in 1B: Tidy or Not Tidy? (8 min)**  
Two printed or projected tables — one tidy (long), one wide. Answer three written questions: which is tidy, what would need to change to make the other one tidy, and which format would you use for a chart vs. a pivot table?

**1.4 Data Quality and Common Pitfalls (10 min)**  
Missing values, duplicate rows, out-of-range values, encoding inconsistencies, timestamp errors; how each can silently corrupt downstream results.

---

## Module 2: Introduction to R and RStudio
**Duration: 2.1 hours**

### Learning Objectives
- Navigate the RStudio interface and understand the purpose of each pane
- Apply project and file organization principles to set up a reproducible analysis environment
- Import and inspect a dataset using the tidyverse
- Recognize and correct common data type misassignments
- Apply a systematic data validation checklist after importing data

### Topics and Interspersed Exercises

**2.1 Why Use a Programmatic Tool? (12 min)**  
Reproducibility, auditability, scale; what a script can do that a spreadsheet cannot; the mental model shift from "cells" to "operations on a dataset."

→ **Check-in 2A: RStudio Orientation (8 min)**  
Open the course .Rproj file. Fill in a table identifying the four panes and their purpose. Run one line in the console: `1 + 1`. Confirm the environment is working.

**2.2 R Basics: Objects, Functions, and Packages (12 min)**  
Assignment with `<-`; the difference between an object and a function; packages as bundled tools; `library(tidyverse)` as the only package needed for this course.

**2.2b Project and File Organization (10 min)**  
Why RStudio needs a "point of reference": the working directory, and why the same relative path can resolve differently on two machines. The `.Rproj` file as the fix — opening it anchors the working directory to the project folder, so every relative path (`data/chem_data.csv`) works the same way regardless of whose computer it's on. A simple, durable folder structure (`data/`, `R/`, `output/`); `data/` treated as read-only in spirit — never modify raw data by hand. This is *why* every module in this course starts with "open the `.Rproj` file first" — including the one learners just did in Check-in 2A.

**2.3 Importing Data with Explicit Column Types (18 min)**  
`read_csv()` and type inference; why R guesses wrong on datetime and factor columns; specifying `col_types` explicitly; the collect_dt format string `"%Y/%m/%d %H:%M:%S"`.

→ **Check-in 2B: Import and Inspect chem_data (20 min)**  
Two-part: (1) import with `read_csv()` using default types, run `glimpse()` and `summary()` — identify which columns are wrong; (2) re-import with explicit `col_types`, confirm the corrections. Fill in two blanks: the datetime format string and `col_factor()` for pat_type.

**2.4 Data Validation Checklist (15 min)**  
Why validation is the first step after every import; the six-step checklist: `nrow()`, `n_distinct()`, `count()` by analyte, `count()` by pat_type, value range spot-check on a single analyte (sodium, using a preview `filter()` — "we'll understand this in Module 4"), timestamp completeness with `is.na()`.

→ **Check-in 2C: Run the Checklist (15 min)**  
Step through all six validation checks on the correctly imported chem_data. Record findings. Instructor debrief: what to do when validation reveals a problem.

---

## Module 3: Visualization Principles and Best Practices
**Duration: 2 hours** (60 min lecture / 60 min exercises)

### Why Visualization Comes Before Transformation

Placing visualization here — before the formal introduction to data transformation — serves two purposes. First, learners can build meaningful charts immediately using just the data import skills from Module 2, which delivers an early win and sustains motivation. Second, encountering the limits of what you can visualize with unmanipulated data creates a natural motivating question for Module 4: *what would I need to do to the data to make the chart I actually want?* The setup chunks for Module 3 exercises contain `filter()` calls that learners have not yet learned; these are provided pre-written with a note that Module 4 will explain them. This deliberate preview seeds curiosity and makes the callback in Module 4 land with recognition.

### Learning Objectives
- Select an appropriate chart type given data characteristics and the question being asked
- Apply core visualization design principles to improve clarity and honesty
- Distinguish between exploratory and explanatory visualization and choose the appropriate approach
- Build and iteratively refine plots using ggplot2's grammar of graphics

### Topics and Interspersed Exercises

**3.1 Why Visualize? (8 min)**  
Anscombe's Quartet; visualization as both a thinking tool and a communication tool; the cost of a misleading chart in clinical or operational contexts.

**3.2 Two Modes of Visualization (8 min)**  
Exploratory (fast, rough, for yourself) vs. explanatory (for an audience, every choice deliberate); why conflating them produces charts that are neither useful for exploration nor clear for communication.

→ **Check-in 3A: Classify (5 min)**  
Three projected charts — a rough histogram with default ggplot2 styling, a polished figure from a published MS paper, a QC scatter plot from a lab report. Learners vote: exploratory or explanatory? Brief group discussion on what signals they used to decide.

**3.3 Choosing the Right Chart Type (12 min)**  
Single distribution (histogram, boxplot); comparing groups (side-by-side boxplots, faceting); change over time (run chart, the conceptual basis of Levey-Jennings); when tables beat charts. Decision framework: start from the question, not the chart type.

→ **Check-in 3B: Match the Chart (5 min)**  
Five written scenarios from the MS lab context (e.g., "compare sodium distributions across patient types"; "show one month of QC results for potassium"; "display the analyte reference ranges for a poster"). Learners write the chart type they would choose and one sentence of justification. Quick show-of-hands debrief.

**3.4 Design Principles (12 min)**  
Data-ink ratio; color encodes (not decorates) — categorical vs. sequential palettes, colorblind accessibility; axis scaling and the ethics of truncated axes; required labels; the cost of chartjunk in a clinical audience.

→ **Check-in 3C: Spot the Flaws (8 min)**  
Two pre-built bad charts displayed on screen (the same charts that appear as Exercise 3E later, but shown as images rather than run): (1) rainbow bar chart of 24-analyte means on a single axis; (2) sodium boxplot with truncated y-axis. Learners name the problems in writing before any code. This primes them for the rewrite exercise later.

**3.5 Introduction to ggplot2 (10 min)**  
Grammar of graphics: data + aesthetics + geometric objects + optional layers; the template `ggplot(data, aes(...)) + geom_*()`; common geoms: `geom_histogram()`, `geom_boxplot()`, `geom_point()`, `geom_line()`, `geom_hline()`; `facet_wrap()` for small multiples; `theme_bw()` and `labs()` for polish.

→ **Exercise 3D: First Plots — Histogram and Distributions (20 min)**  
Using a pre-filtered potassium subset (filter code provided in setup chunk, labeled "we'll understand this in Module 4"): (1) build a histogram skeleton with two blanks — x aesthetic and binwidth — then try three binwidth values and choose the best; (2) add `pat_type` as a fill aesthetic, apply `theme_bw()` and proper labels; (3) classify the result as exploratory or explanatory and describe what would need to change for a conference poster. This is the first substantive coding exercise — instructor circulates.

*Debrief (~3 min): instructor highlights how `fill = pat_type` revealed a clinically interesting pattern.*

→ **Exercise 3E: Run Chart and Bad Chart Rewrites (22 min)**  
Part 1 (8 min): boxplots of four electrolytes faceted by patient type; add reference lines to a sodium run chart using `geom_hline()` at 135 and 145 mmol/L; written question: what elements would make this a proper Levey-Jennings chart?  
Part 2 (14 min): run the two pre-built bad charts from Check-in 3C; rewrite both to fix the flaws identified earlier. Learners explain their changes in the narrative space below each chunk.

---

## Module 4: Computational Approaches to Data
**Duration: 3.5 hours** (115 min lecture / 100 min exercises, with a mid-module break)

### Structure

This module is divided into two halves by a break. The first half establishes the computational thinking framework and applies it to the core data transformation operations using chem_data. The second half introduces the course's LC-MS/MS pain management dataset (three related tables: `peak_data`, `sample_data`, `batch_data_ts`) to motivate relational data concepts with a genuinely realistic structure, and builds toward a complete reproducible analysis on that dataset as the capstone. The arc of the module is: *think → transform → connect → document*.

**Why introduce a second dataset here?** The chem_data flat file is excellent for learning import, validation, visualization, and transformation — but its single-table structure does not create a natural need for joins. The LC-MS/MS dataset has a three-table structure that mirrors exactly how instrument software exports data in practice: peaks and sample results in separate files, batch metadata in a third. Learners who work in MS labs will recognize this immediately. Introducing it in the second half of Module 4 — after the CT framework is established — means learners can reason about the join problem conceptually before they have to solve it in code.

### Learning Objectives
- Describe the four pillars of computational thinking and identify them in data transformation workflows
- Use core tidyverse verbs to filter, mutate, group, summarize, reshape, and join data
- Explain what relational data is, what a key variable is, and which join type fits a given scenario
- Build a complete, documented, reproducible analysis in Quarto that re-runs correctly with updated inputs

---

### FIRST HALF — Topics and Interspersed Exercises (approx. 100 min before break)

**4.1 Computational Thinking as a Framework (12 min)**  
Four pillars as tools for reasoning before touching a keyboard:
- **Decomposition:** break the problem into answerable sub-questions
- **Pattern recognition:** identify structure that repeats across the data
- **Abstraction:** express a rule once and apply it generally, not just to one case
- **Algorithm:** a precise, ordered sequence of steps that produces a reproducible result — the pipe chain *is* a written algorithm

Connection to MSACL 101: functions and loops in R are implementations of abstraction and algorithms — this framework is the conceptual foundation for that syntax. Callback: the `filter()` calls in Module 3's setup chunk were decomposition.

→ **Check-in 4A: Decompose Before You Code (8 min)**  
Given the scenario: *"Which analytes had a turnaround time over 4 hours for more than 5% of results, broken down by patient type?"* — work through all four CT steps in writing. No code. Identify sub-questions (decompose), what columns make it solvable (pattern), what would change for a different threshold (abstraction), and write plain-English pseudocode (algorithm). Instructor collects a few responses; debrief reveals that almost everyone's pseudocode looks like a pipe chain.

**4.2 Decomposition: Filtering and Selecting (12 min)**  
`filter()` for rows; `select()` for columns; logical operators: `==`, `!=`, `>`, `<`, `%in%`, `is.na()`; AND vs. OR for multiple criteria. Recognition moment: *"this is exactly what was happening in the Module 3 setup chunk."*

→ **Check-in 4B: Write the Filter (8 min)**  
Four blanks: filter chem_data to outpatient alkaline phosphatase results for female patients aged 50+. Run it; check the row count; verify it is plausible given the full dataset size. One written question: which of the four conditions was decomposition — narrowing scope — and which was pattern recognition — applying a criterion uniformly to every row?

**4.3 Algorithms: The Pipe and Readable Pipelines (8 min)**  
`|>` as a written algorithm: "start with data, then do X, then do Y"; reading a pipeline top to bottom like a written procedure; `#` comments as documentation that make reasoning visible; the immutability principle — pipelines produce new objects, raw data is never modified.

→ **Check-in 4C: Read the Pipeline (5 min)**  
A pre-written four-step pipeline is displayed without explanation. Learners predict in writing what the output will look like — how many rows, what columns, what the values represent — before running it. Running it to verify takes 60 seconds; the debrief focuses on which step most people misread and why.

**4.4 Abstraction: Creating New Variables (8 min)**  
`mutate()` as abstraction: expressing a derivation as a rule stated once and applied uniformly to every row; arithmetic on columns; computing turnaround time from two timestamp columns using subtraction and `as.numeric()`.

→ **Check-in 4D: Compute TAT (7 min)**  
Two blanks: fill in the start and end timestamps to compute `total_tat_hours`. Run `summary()` on the result; written question: does the maximum value seem realistic, and what might explain it?

**4.5 Pattern Recognition: Grouping, Summarizing, and Reshaping (12 min)**  
`group_by()` + `summarize()`: the same summary operation applied to every group simultaneously — this is pattern recognition in code; what "group" means; summary functions with `na.rm = TRUE`; `pivot_wider()` for human-readable tables vs. long format for computation and visualization.

→ **Check-in 4E: Group and Reshape (10 min)**  
Three blanks: `group_by()` by two variables, fill in the summary function names, then `pivot_wider()` on the analyte-only result. Written question: which format — long or wide — would you pipe into `ggplot2`? Which would you paste into a report slide? Why does the answer differ?

---

**[Mid-Module Break — 10 minutes]**

---

### SECOND HALF — Topics and Interspersed Exercises (approx. 90 min after break)

**4.6 Relational Data and Joins (15 min)**  
Why data lives in multiple tables: relational structure keeps each fact in one place and eliminates redundancy. The course's LC-MS/MS pain management dataset makes this concrete — the data the instrument produces is stored across three tables that must be joined to answer any real question:

- `peak_data` — one row per ion transition per sample per compound: raw peak areas, peak quality, and whether the integration was manually modified
- `sample_data` — one row per sample per compound: processed concentrations, ion ratios, sample type (calibrator, QC, patient), pass/fail
- `batch_data_ts` — one row per compound per batch: instrument name, calibration slope/intercept/R², batch pass/fail, reviewer, and three timestamps

Key variables: the column(s) that uniquely link rows across tables — identifying the key is the essential first step before any join. What is the key between `batch_data_ts` and `sample_data`? Not just `batch_name` — both `batch_name` and `compound_name` are needed together (a compound key). The four join types as conceptual tools:
- `left_join()` — enrich your primary data with reference information; keeps all left rows
- `inner_join()` — complete records only; silently drops unmatched rows on either side
- `full_join()` — full picture including mismatches; NAs fill gaps
- `anti_join()` — validation tool: which rows have no match?  

What can go wrong: row multiplication when a key is not unique; silent data loss with `inner_join()`. Note: MSACL 101 covers join syntax in depth — this section builds the mental model for choosing the right join type.

→ **Check-in 4F: Navigate the MS Dataset (10 min)**  
Working with the three-table pain management dataset. Four questions: (1) What is the key variable that links `sample_data` to `batch_data_ts`? (Is `batch_name` alone sufficient? How would you check?) (2) Write the `left_join()` call to enrich `sample_data` with instrument name and batch pass/fail from `batch_data_ts`. (3) Write the `anti_join()` call to find `sample_data` rows whose `batch_name` has no entry in `batch_data_ts` — what would such orphaned rows indicate about data quality? (4) If `batch_data_ts` had a duplicate row for one batch/compound combination, how many rows would the join produce for each matching row in `sample_data`? Written answers; instructor debrief highlights that compound keys are common in LC-MS/MS data and that the `anti_join()` question is exactly what a QC audit would ask.

**4.7 Reproducibility and Documentation (15 min)**  
The reproducibility test: given raw data and code, can someone else — or you in six months — re-run the analysis and get the same result? The reproducibility spectrum: console commands → saved script → self-documenting Quarto report → version-controlled project. Quarto as a documented algorithm: each chunk is a step; the narrative explains the reasoning; rendering re-executes every step in sequence. Parameterized reports: changing one value re-runs the entire document — this is abstraction applied to documentation.

→ **Check-in 4G: Anatomy of a Quarto Document (5 min)**  
A pre-written Quarto document is displayed (the capstone skeleton). Learners label five elements: YAML header, a narrative paragraph, a code chunk, a chunk option, and rendered output. No coding — this is orientation before the capstone.

**4.8 The Complete Analytical Workflow (8 min)**  
Bringing the four modules together as a single coherent process:
- Module 1: understand what your data is
- Module 2: import it correctly and validate it  
- Module 3: look at it
- Module 4: manipulate it systematically and document what you did  

The complete pipeline as an instantiation of all four CT pillars simultaneously. What learners are now equipped to do, and what MSACL 101 will build on top of this foundation.

→ **Exercise 4H: Capstone — An LC-MS/MS Batch Review Pipeline (44 min)**  
A structured Quarto document that simulates a real task: an analyst wants a reproducible summary of batch quality across the pain management dataset, so that re-running it on any future data export produces the same report structure with updated numbers. The document has four sections, each with a small number of blanks and a narrative space.

*Section 1 — Import and Validate (8 min):* import `sample_data.csv` and `batch_data_ts.csv`; run `nrow()`, `n_distinct()` on batch_name and compound_name for each table; check for NAs in the pass/fail columns. Two blanks; write two sentences of validation findings. This applies the Module 2 checklist to a new dataset — reinforcing that validation is not chem_data-specific but a universal first step.

*Section 2 — Explore (8 min):* one blank to filter `sample_data` to patient samples only (`sample_type == "patient"`); build an exploratory boxplot of measured concentration by compound, faceted by `sample_passed`. Label it explicitly as exploratory in the narrative. This applies Module 3 skills; the pre-written `filter()` code in the setup is now fully understood rather than opaque.

*Section 3 — Join and Summarize (12 min):* the pre-structured pipeline uses `left_join()` to enrich `sample_data` with instrument name and batch pass/fail from `batch_data_ts`, then filters to passed batches, then groups by compound and instrument to compute mean concentration, CV (sd/mean × 100), and n. Four blanks: the join key columns (both), the `group_by()` variables, and the CV formula. The pipeline structure and `|>` scaffolding are provided with step comments — learners fill in the arguments, not the shape.

*Section 4 — Communicate (8 min):* build one polished chart from the Section 3 summary — a bar chart or dot plot of CV by compound, colored by instrument, with a horizontal reference line at 15% (a typical acceptable CV threshold for LC-MS/MS). Add a title, axis labels with units (%), and one sentence caption explaining what a CV above the line implies for the batch.

*Render and reflect (8 min):* render to HTML; change `sample_type == "patient"` to `sample_type == "calibrator"` in Section 2 and re-render; answer: which sections updated automatically, which needed edits, and what single change would make the `sample_type` filter fully parameterized across all four sections? Closing reflection: this is what a reproducible QC report looks like — the same document, re-run on the next export, with no manual steps between data and output.

---

## Course Summary and Timing

Exercises are interspersed throughout each module rather than batched at the end. The table below shows the approximate breakdown, but in practice the lecture/exercise boundary is fluid — each check-in follows directly from the preceding concept.

| Module | Title | Lecture | Check-ins / Exercises | Total |
|--------|-------|---------|-----------|-------|
| 1 | Data Literacy Foundations | 40 min | 18 min (2 check-ins) | 1.4 hrs |
| 2 | Introduction to R and RStudio | 67 min | 43 min (3 check-ins) | 2.1 hrs |
| 3 | Visualization Principles and Best Practices | 50 min | 60 min (3 check-ins + 2 exercises) | 2.0 hrs |
| 4 | Computational Approaches to Data | 50 min | 143 min (7 check-ins + capstone) | 3.5 hrs |
| **Total** | | **207 min** | **264 min** | **9.0 hrs** |

*Module 4 includes a 10-minute mid-module break absorbed within the 3.5-hour allocation. The larger exercise-to-lecture ratio in Module 4 is intentional: once each CT pillar is introduced (≤12 min), learners immediately apply it before the next concept is introduced.*

---

## What Changes Relative to the 5-Module Outline

**Structure:**
- Visualization moves from Module 4 to Module 3 — earlier, so learners see their data before they transform it
- Modules 3 and 5 (Transformation and Computational Thinking) merge into a single 3.5-hour Module 4
- All exercises shortened and interspersed after each topic section; no module has a long exercise block at the end except the Module 4 capstone

**Pedagogical improvements:**
- Short check-ins (5–10 min) immediately after each concept section mean learners apply an idea while it is still fresh, before the next concept is introduced
- The instructor can read the room at each check-in: if most learners complete it quickly, move on; if the room is stuck, that is signal for more explanation before proceeding
- Computational thinking is introduced *as* learners begin writing transformation code; each transformation verb is anchored to a CT pillar at the moment of introduction
- The Module 3 visualization setup chunks preview `filter()` with a labeled forward reference, seeding curiosity for Module 4; the Check-in 4B callback ("this is what was happening in Module 3") lands with recognition
- The capstone (4H) is pre-structured — the pipe shape and step comments are provided; learners fill in verb arguments, not scaffolding. This keeps it achievable in 44 minutes while still being integrative

**Tradeoffs:**
- More transitions between lecture and exercise increase cognitive overhead for the instructor and require tighter time discipline
- Very short check-ins (5–8 min) leave little time for struggling learners — the instructor must decide quickly whether to address a blockage in the room or move on and offer help during the next check-in
- Module 4 at 3.5 hours is still long; the mid-module break remains essential
- The 5-module version is easier to teach in separate sessions on different days; this structure works better as a single-day intensive
