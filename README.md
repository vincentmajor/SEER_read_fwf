# SEER_read_fwf

A simple script to help R users read the SEER ASCII files. 

The gist:

* The script reads the contents of [a SAS script from the SEER website](https://seer.cancer.gov/manuals/read.seer.research.nov2017.sas).
* The SAS script is scraped for:
  * The field names, descriptions, start positions and widths.
* A local file is read with these field positions and names resulting in a tibble.

#### Requirements

* R
* [tidyverse](https://github.com/tidyverse/tidyverse)
