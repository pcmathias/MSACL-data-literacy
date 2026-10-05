# =====================================================================
# Computational Thinking with GenAI: ANSWER KEY (facilitators)
# Scenario: ICU clinicians say their chemistry results come back slower.
#   Q1. Does turnaround time (TAT) differ by patient type?
#   Q2. Are we meeting a 3-hour collect-to-verify goal?
# Tested with R 4.3.3 and dplyr 1.1.4.
# Learners' Claude-generated code will differ. Judge it by its OUTPUT,
# not by whether it matches this script line for line.
# =====================================================================

library(dplyr)
library(readr)

# ---------------------------------------------------------------------
# PART 0. Build the subset  (warm-up, learners run this)
# Coding concepts (Obj 5): objects, vectors, functions, the pipe
# ---------------------------------------------------------------------
tests_keep <- c("glucose", "sodium", "potassium", "creatinine",
                "alanine_aminotransferase", "total_bilirubin")

read_csv("chem_data.csv", show_col_types = FALSE) |>
  filter(test %in% tests_keep) |>
  write_csv("chem_subset.csv")

chem <- read_csv("chem_subset.csv", show_col_types = FALSE)
glimpse(chem)
# Expect: 38,886 rows x 14 columns (with all 6 tests)
# If a learner keeps fewer tests: rows = 6,481 x number of tests

# ---------------------------------------------------------------------
# EXERCISE 1. Decomposition  (Obj 1)  -- no code
# See facilitator guide for the model sub-task list.
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# EXERCISE 2. Pattern recognition  (Obj 2: generalize a solution)
# Coding concepts (Obj 5): filter(), group_by(), summarize()
# ---------------------------------------------------------------------

# Starter snippet given to learners: one test, one patient type
chem |>
  filter(test == "glucose", pat_type == "icu") |>
  summarize(n_results = n(), median_value = median(value))
# Expect: n_results 1103, median_value 92

# Generalization A: one test, every patient type
chem |>
  filter(test == "glucose") |>
  group_by(pat_type) |>
  summarize(n_results = n(), median_value = median(value))
# Expect: 6 rows (5 types + NA). Median 92 in every row.

# Generalization B: every test, every patient type
chem |>
  group_by(test, pat_type) |>
  summarize(n_results = n(), median_value = median(value),
            .groups = "drop") |>
  print(n = 40)
# Expect: 36 rows with 6 tests. Medians nearly identical across types.

# ---------------------------------------------------------------------
# EXERCISE 3. Abstraction  (Obj 3)  -- no code
# Learners write a data description. See handout for the template.
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# EXERCISE 4. Algorithm design  (Obj 4)
# Coding concepts (Obj 5): distinct(), mutate(), parameters, NA handling
# ---------------------------------------------------------------------

# THE TRAP: TAT repeats on every test row for the same patient.
# Counting rows inflates n by the number of tests per patient.
chem |>
  group_by(pat_type) |>
  summarize(n = n(), median_col_rec = median(col_rec_tat))
# Expect (6 tests): icu n = 6618  <-- WRONG. Real ICU patients = 1103.
# Medians still look right, because every patient repeats equally.

# Correct: one row per patient (one specimen) first
tat <- chem |>
  distinct(mrn, .keep_all = TRUE) |>
  mutate(total_tat = col_rec_tat + rec_ver_tat,
         pat_type  = coalesce(pat_type, "missing"))

tat_goal_hours <- 3   # a parameter: change it once, reuse everywhere

tat_summary <- tat |>
  group_by(pat_type) |>
  summarize(
    n_patients         = n(),
    median_col_rec_hrs = round(median(col_rec_tat), 2),
    median_rec_ver_hrs = round(median(rec_ver_tat), 2),
    median_total_hrs   = round(median(total_tat), 2),
    p90_total_hrs      = round(quantile(total_tat, 0.9), 2),
    pct_over_goal      = round(100 * mean(total_tat > tat_goal_hours), 1)
  ) |>
  arrange(desc(median_total_hrs), pat_type)

print(tat_summary)
# Expect:
# pat_type      n_patients median_total_hrs p90_total_hrs pct_over_goal
# inpatient           1067             2.55          3.39          26.6
# missing             1088             2.55          3.38          26.9
# outpatient          1072             2.55          3.36          24.8
# client              1092             2.53          3.37          25.5
# icu                 1103             2.53          3.38          25.9
# cancer center       1059             2.51          3.37          26.1
# These TAT numbers do NOT depend on which tests were kept.

# ---------------------------------------------------------------------
# DEBRIEF. Sense checks  (Obj 5: verifying code)
# ---------------------------------------------------------------------
n_distinct(chem$mrn)                 # 6481 patients
nrow(chem) / n_distinct(chem$mrn)    # rows per patient = tests kept
sum(tat_summary$n_patients)          # must equal 6481
sum(is.na(tat$pat_type))             # 0 after coalesce

# ---------------------------------------------------------------------
# STRETCH TASKS (fast finishers)
# ---------------------------------------------------------------------
# S1. Change the goal. Only one line changes.
#     Expect roughly 50-53% over 2.5 h in every group.
tat_goal_hours <- 2.5
tat |>
  group_by(pat_type) |>
  summarize(pct_over_goal = round(100 * mean(total_tat > tat_goal_hours), 1))

# S2. Same pattern, new grouping variable
tat |>
  group_by(gender) |>
  summarize(n_patients = n(), median_total_hrs = median(total_tat))

# S3. Age bands with case_when(), then summarize
tat |>
  mutate(age_band = case_when(
    age < 18 ~ "under 18",
    age < 40 ~ "18-39",
    age < 65 ~ "40-64",
    TRUE     ~ "65+"
  )) |>
  group_by(age_band) |>
  summarize(n_patients = n(), median_total_hrs = median(total_tat))
