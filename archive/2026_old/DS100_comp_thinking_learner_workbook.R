# =====================================================================
# Computational Thinking with GenAI: LEARNER WORKBOOK
#
# You are not being tested on R today. All the code you need is here
# or comes from Claude.
#
# How to use this file:
#   - Run ONE section at a time. Highlight the lines, then press
#     Ctrl+Enter (Windows) or Cmd+Enter (Mac).
#   - Paste code from Claude where it says PASTE HERE.
#   - If code gives an error, copy the full error message to Claude.
#   - Put chem_data.csv in the same folder as this file, then use
#     Session > Set Working Directory > To Source File Location.
#
# Scenario: ICU clinicians say their chemistry results come back slower.
#   Q1. Does turnaround time (TAT) differ by patient type?
#   Q2. Are we meeting a 3-hour collect-to-verify goal?
# =====================================================================

library(dplyr)
library(readr)

# ---------------------------------------------------------------------
# PART 0. Warm-up: build your subset
# Fill in the two blanks with "potassium" and "creatinine".
# Keep the quote marks.
# ---------------------------------------------------------------------
tests_keep <- c("glucose", ___, ___)

read_csv("chem_data.csv", show_col_types = FALSE) |>
  filter(test %in% tests_keep) |>
  write_csv("chem_subset.csv")

chem <- read_csv("chem_subset.csv", show_col_types = FALSE)
glimpse(chem)

# CHECK: you should have 19,443 rows (6,481 patients x 3 tests).

# ---------------------------------------------------------------------
# COLD PROMPT
# Paste the code Claude gave you. Run it. What happened?
# Do not upload the data file to Claude.
# ---------------------------------------------------------------------
# PASTE HERE


# ---------------------------------------------------------------------
# EXERCISE 1. Decomposition (Objective 1)
# No code. Use the handout.
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# EXERCISE 2. Pattern recognition (Objective 2)
# This works for ONE test in ONE patient type. Run it first.
# ---------------------------------------------------------------------
chem |>
  filter(test == "glucose", pat_type == "icu") |>
  summarize(n_results = n(), median_value = median(value))

# A) Claude's version for every patient type, glucose only
# PASTE HERE


# B) Claude's version for every test and every patient type
# PASTE HERE


# ---------------------------------------------------------------------
# EXERCISE 3. Abstraction (Objective 3)
# Run both blocks. Then find what differs between the code blocks.
# ---------------------------------------------------------------------
chem |>
  filter(test == "glucose") |>
  group_by(pat_type) |>
  summarize(n_results = n(),
            pct_above = round(100 * mean(value > 125), 1))

chem |>
  filter(test == "potassium") |>
  group_by(pat_type) |>
  summarize(n_results = n(),
            pct_above = round(100 * mean(value > 5.0), 1))

# Claude's code from your filled-in prompt template
# PASTE HERE


# ---------------------------------------------------------------------
# EXERCISE 4. Algorithm design (Objective 4)
# Paste the code Claude wrote AFTER you answered its questions
# and approved its plan.
# ---------------------------------------------------------------------
# PASTE HERE


# CHECK: the patient counts in your table should total 6,481,
# and patients with no patient type should still be there as a group.

# ---------------------------------------------------------------------
# DEBRIEF. Does this make sense?
# ---------------------------------------------------------------------
n_distinct(chem$mrn)                 # how many patients are in the data?
nrow(chem) / n_distinct(chem$mrn)    # how many rows per patient?

# Add up the patient counts in your TAT table. Do they total 6,481?
# If the total is 5,393, patients with no patient type were dropped.
