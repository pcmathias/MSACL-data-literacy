# =====================================================================
# Computational Thinking with GenAI: ANSWER KEY (facilitators)
# Scenario: ICU clinicians say their chemistry results come back slower.
#   Q1. Does turnaround time (TAT) differ by patient type?
#   Q2. Are we meeting a 3-hour collect-to-verify goal?
# Our lab's target (not in the director's question): 90% within 3 hours.
# Tested with R 4.3.3 and dplyr 1.1.4.
# Claude's code will differ between learners. Judge it by its OUTPUT.
# =====================================================================

library(dplyr)
library(readr)

# ---------------------------------------------------------------------
# PART 0. Warm-up: build the subset
# ---------------------------------------------------------------------
tests_keep <- c("glucose", "potassium", "creatinine")

read_csv("chem_data.csv", show_col_types = FALSE) |>
  filter(test %in% tests_keep) |>
  write_csv("chem_subset.csv")

chem <- read_csv("chem_subset.csv", show_col_types = FALSE)
glimpse(chem)
# Expect: 19,443 rows (6,481 patients x 3 tests) and 14 columns

# ---------------------------------------------------------------------
# COLD PROMPT. What to expect (from test runs in free Claude, Oct 2026)
# ---------------------------------------------------------------------
#
# Example 1 (very basic): Write R code to answer these two questions for a 
# core lab director who is answering a concern from an ICU physician. 
# Q1. Does turnaround time differ by patient type? 
# Q2, Are we meeting a 3-hour collect-to-verify goal?
#
#
# Example 2 (with data description): Write R code to answer these two questions. 
# Do it correctly and double-check your work. Q1. Does turnaround time differ 
# by patient type? Q2. Are we meeting a 3-hour collect-to-verify goal? 
# My data is in a file called chem_subset.csv. The columns are: mrn, gender, 
# age, pregnancy_status_at_exam, collect_dt, receive_dt, verify_dt, pat_type, 
# payor_groups, last_name, col_rec_tat, rec_ver_tat, test, value.
#
# Notes from tests:
# - No data description given: Claude invents column names and a
#   synthetic dataset. The code runs on ITS data and fails on ours.
# - Column names given: long working code (about 200 lines) plus a list
#   of assumptions. In one test it dropped patients with no patient type
#   and assumed a 90% target. Its table then totals 5,393, not 6,481.
# - Claude asked no questions in any test unless told to ask first.

# ---------------------------------------------------------------------
# EXERCISE 1. Decomposition (Objective 1) -- no code
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# EXERCISE 2. Pattern recognition (Objective 2)
# ---------------------------------------------------------------------

# Starter code: one test, one patient type
chem |>
  filter(test == "glucose", pat_type == "icu") |>
  summarize(n_results = n(), median_value = median(value))
# Expect: n_results 1103, median_value 92

# A) every patient type, glucose only
chem |>
  filter(test == "glucose") |>
  group_by(pat_type) |>
  summarize(n_results = n(), median_value = median(value))
# Expect: 6 rows (5 patient types + NA). Median 92 in every row.

# B) every test, every patient type
chem |>
  group_by(test, pat_type) |>
  summarize(n_results = n(), median_value = median(value),
            .groups = "drop") |>
  print(n = 20)
# Expect: 18 rows. Medians nearly identical across patient types.

# ---------------------------------------------------------------------
# EXERCISE 3. Abstraction (Objective 3)
# ---------------------------------------------------------------------

# The two code blocks learners run. They differ in two places.
chem |>
  filter(test == "glucose") |>
  group_by(pat_type) |>
  summarize(n_results = n(),
            pct_above = round(100 * mean(value > 125), 1))
# Expect: icu 9.1  (range across patient types 7.3 to 9.7)

chem |>
  filter(test == "potassium") |>
  group_by(pat_type) |>
  summarize(n_results = n(),
            pct_above = round(100 * mean(value > 5.0), 1))
# Expect: icu 1.8  (range 0.8 to 1.8)

# Template filled with "creatinine" and "1.2"
chem |>
  filter(test == "creatinine") |>
  group_by(pat_type) |>
  summarize(n_results = n(),
            pct_above = round(100 * mean(value > 1.2), 1))
# Expect: icu 7.4  (range 6.8 to 9.4)
# Second fill, "glucose" and "125": icu 9.1, same as the first block.

# FACILITATOR DEMO (2 min): the template as an R function
pct_above <- function(test_name, cutoff) {
  chem |>
    filter(test == test_name) |>
    group_by(pat_type) |>
    summarize(n_results = n(),
              pct_above = round(100 * mean(value > cutoff), 1))
}

pct_above("glucose", 125)
pct_above("potassium", 5.0)
pct_above("creatinine", 1.2)   # a new case costs one line

# ---------------------------------------------------------------------
# EXERCISE 4. Algorithm design (Objective 4)

# Example 1 (cold prompt with data description, ask first): 
# Write R code to answer these two questions. Do it correctly and 
# double-check your work. Q1. Does turnaround time differ by patient type? 
# Q2. Are we meeting a 3-hour collect-to-verify goal? 
# My data is in a file called chem_subset.csv. The columns are: mrn, gender, 
# age, pregnancy_status_at_exam, collect_dt, receive_dt, verify_dt, pat_type, 
# payor_groups, last_name, col_rec_tat, rec_ver_tat, test, value. 
# If anything essential is missing, ask me before answering.
#
#
# Example 2 (using prompting framework with ask first):
# Task: Write R code to answer two questions. 
# Q1. Does turnaround time differ by patient type? 
# Q2. Are we meeting a 3-hour collect-to-verify goal? 
#
# Context: I am a core lab director answering a concern from an ICU 
# physician, who says ICU chemistry results come back slower than results 
# for other units. Our target is ____% of patients within 3 hours. 
# I am new to R. 
#
# Material: My data is in a file called chem_subset.csv. I can't upload it. 
# The columns are: [paste the column names]. One row is ____. 
# Each patient has ____ rows. The columns col_rec_tat and rec_ver_tat are 
# turnaround times in ____. 
#
# Constraints: Use dplyr. Count patients, not rows. For patients with 
# no patient type, ____. Tell me anything you assume. 
#
# Output: First give me your plan as numbered steps. Do not write code until 
# I approve the plan. Then give me one table by patient type with the number 
# of patients, the median total turnaround time and the percent within 
# 3 hours, plus one sentence answering each question. Keep the code short, 
# with a comment on each step. 
#
# If anything essential is missing, ask me before answering.



# Reference solution, with our lab's answers to Claude's questions:
#   - one row is one test result; use one row per patient
#   - total TAT = collect to verify, in hours
#   - keep missing patient type as its own group
#   - target: 90% of patients within 3 hours
# ---------------------------------------------------------------------

n_distinct(chem$mrn)
# Expect: 6481 patients

tat <- chem |>
  distinct(mrn, .keep_all = TRUE) |>
  mutate(total_tat = col_rec_tat + rec_ver_tat,
         pat_type  = coalesce(pat_type, "missing"))

goal_hours <- 3
goal_pct   <- 90

tat_summary <- tat |>
  group_by(pat_type) |>
  summarize(
    n_patients       = n(),
    median_total_hrs = round(median(total_tat), 2),
    p90_total_hrs    = round(quantile(total_tat, 0.9), 2),
    pct_within_3h    = round(100 * mean(total_tat <= goal_hours), 1)
  ) |>
  arrange(desc(median_total_hrs), pat_type)

tat_summary
# Expect:
# pat_type      n_patients median_total_hrs p90_total_hrs pct_within_3h
# inpatient           1067             2.55          3.39          73.4
# missing             1088             2.55          3.38          73.1
# outpatient          1072             2.55          3.36          75.2
# client              1092             2.53          3.37          74.5
# icu                 1103             2.53          3.38          74.1
# cancer center       1059             2.51          3.37          73.9
# Claude often reports minutes: 2.53 hours = 152 minutes.

# Q1: does TAT differ by patient type?
kruskal.test(total_tat ~ pat_type, data = tat)
# Expect: p = 0.90. No difference. ICU is not slower.

# Q2: are we meeting the goal?
round(100 * mean(tat$total_tat <= goal_hours), 1)
# Expect: 74.0% within 3 hours. Target is 90%. We are NOT meeting the goal.

# ---------------------------------------------------------------------
# DEBRIEF. Sense checks
# ---------------------------------------------------------------------
sum(tat_summary$n_patients)          # must equal 6481
nrow(chem) / n_distinct(chem$mrn)    # 3 rows per patient

# Two ways a table can go wrong, for reference:
# 1. Missing patient type dropped: 5 groups, total 5393 (1,088 patients lost)
sum(!is.na(distinct(chem, mrn, .keep_all = TRUE)$pat_type))
# 2. Rows counted as patients: icu = 3309, not 1103
sum(chem$pat_type == "icu", na.rm = TRUE)

# ---------------------------------------------------------------------
# OPTIONAL STRETCH (fast finishers)
# ---------------------------------------------------------------------
tat |>
  group_by(gender) |>
  summarize(n_patients = n(), median_total_hrs = median(total_tat))
# Expect: Female 3322 (2.53), Male 3159 (2.54)
