```R
"This script loads data for analysis

Usage: src/01-load_data.R --output_path=<output_path>

Options:
--output_path=<output_path>
" -> doc

library(docopt)
library(readr)
library(dplyr)
library(tidyr)

opt <- docopt::docopt(doc)

data <- palmerpenguins::penguins

# Initial cleaning: Remove missing values
data <- data %>% tidyr::drop_na()

# Save data
readr::write_csv(data, opt$output_path) # "data/raw/penguins.csv"