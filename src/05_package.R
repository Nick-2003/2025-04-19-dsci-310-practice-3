"This script tests the usage of packages in the report

Usage: src/05-package.R --output_path=<output_path>

Options:
--output_path=<output_path>
" -> doc

library(docopt)
library(package20250419)

opt <- docopt::docopt(doc)

# Explicit namespace use
calls <- c("package20250419::is_leap(2000)", 
           "package20250419::is_leap(1900)", 
           "package20250419::temp_conv(41, 'F', 'C')")

# Evaluate each safely
outputs <- sapply(calls, function(call) {
  tryCatch({
    eval(parse(text = call))
  }, error = function(e) {
    paste("Error:", e$message)
  })
})

# Create dataframe
func_outputs <- data.frame(
  Function = calls,
  Output = outputs,
  stringsAsFactors = FALSE
)
func_outputs

# Write to file
readr::write_csv(func_outputs, opt$output_path) # "work/output/func_outputs.csv"