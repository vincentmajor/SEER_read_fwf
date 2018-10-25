## Vincent Major
## October 25 2018
## Script to read the SEER file dictionary and use it to read SEER ASCII data files.

library(tidyverse)
library(stringr)

#### Reading the file dictionary ----
## https://seer.cancer.gov/manuals/read.seer.research.nov2017.sas

sas.raw <- read_lines("https://seer.cancer.gov/manuals/read.seer.research.nov2017.sas")
sas.df <- tibble(raw = sas.raw) %>% 
  ## remove first few rows by insisting an @ that defines the start index of that field
  filter(str_detect(raw, "@")) %>% 
  ## extract out the start, width and column name+description fields
  mutate(start = str_replace(str_extract(raw, "@ [[:digit:]]{1,3}"), "@ ", ""),
         width = str_replace(str_extract(raw, "\\$char[[:digit:]]{1,2}"), "\\$char", ""),
         col_name = str_extract(raw, "[[:upper:]]+[[:upper:][:digit:][:punct:]]+"),
         col_desc = str_trim(str_replace(str_replace(str_extract(raw, "\\/\\*.+\\*\\/"), "\\/\\*", ""), "\\*\\/", "" )) ) %>% 
  ## coerce to integers
  mutate_at(vars(start, width), funs(as.integer)) %>% 
  ## calculate the end position
  mutate(end = start + width - 1)

column_mapping <- sas.df %>% 
  select(col_name, col_desc)

#### read the file with the start+end positions----

## CHANGE THIS LINE
file_path = "data/test_COLRECT.txt"

## read the file with the fixed width positions
data.df <- read_fwf(file_path, 
                    fwf_positions(sas.df$start, sas.df$end, sas.df$col_name))
## result is a tibble
