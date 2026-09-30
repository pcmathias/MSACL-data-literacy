# =====================================================================
# Computational Thinking with GenAI: LEARNER WORKBOOK
#
# How to use this file:
#   - Run ONE section at a time. Highlight the lines, then press
#     Ctrl+Enter (Windows) or Cmd+Enter (Mac).
#   - Fill in every blank marked ___ before you run that section.
#   - Paste code from Claude where it says PASTE HERE.
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
# PART 0. Build your subset
# Pick 3 to 6 tests to keep. Spell them exactly as they appear in the
# data (lowercase, underscores). Choose from:
#   glucose, sodium, potassium, creatinine,
#   alanine_aminotransferase, total_bilirubin
# ---------------------------------------------------------------------
tests_keep <- c("glucose", ___, ___)

read_csv("chem_data.csv", show_col_types = FALSE) |>
  filter(test %in% tests_keep) |>
  write_csv("chem_subset.csv")

chem <- read_csv("chem_subset.csv", show_col_types = FALSE)
glimpse(chem)

# CHECK: How many rows do you have? ________
#        6,481 patients x (number of tests you kept) = ________
#        Do these match?

# ---------------------------------------------------------------------
# COLD PROMPT
# Paste the code Claude gave you for "Write R code to analyze my lab
# chemistry data." Run it. What happened?
# ---------------------------------------------------------------------
# PASTE HERE


# ---------------------------------------------------------------------
# EXERCISE 1. Decomposition (Objective 1)
# No code. Write your sub-tasks on the handout.
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# EXERCISE 2. Pattern recognition (Objective 2)
# This works for ONE test in ONE patient type. Run it first.
# ---------------------------------------------------------------------
chem |>
  filter(test == "glucose", pat_type == "icu") |>
  summarize(n_results = n(), median_value = median(value))

# Now ask Claude to generalize it (prompt on the handout).
# A) every patient type, glucose only
# PASTE HERE


# B) every test you kept, every patient type
# PASTE HERE


# ---------------------------------------------------------------------
# EXERCISE 3. Abstraction (Objective 3)
# No code. Write your data description on the handout.
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# EXERCISE 4. Algorithm design (Objective 4)
# Build your prompt from the handout template. Paste Claude's code here.
# If you get an error, copy the FULL error message back to Claude.
# ---------------------------------------------------------------------
# PASTE HERE


# ---------------------------------------------------------------------
# DEBRIEF. Does this make sense? (Objective 5)
# Run these checks against your result.
# ---------------------------------------------------------------------
n_distinct(chem$mrn)                 # how many patients are in the data?
nrow(chem) / n_distinct(chem$mrn)    # how many rows per patient?

# Add up the patient counts in your TAT table. Total = ________
# Does it equal the number of patients? If not, why not?
