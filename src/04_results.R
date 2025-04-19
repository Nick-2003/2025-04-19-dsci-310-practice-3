```R
"This script evaluates the performance of the model using the test dataset

Usage: src/04-results.R --input_path=<input_path> --input_path_train=<input_path_train> --input_path_test=<input_path_test> --input_path_model=<input_path_model>

Options:
--input_path_train=<input_path_train>
--input_path_test=<input_path_test>
--input_path_model=<input_path_model>
--output_path=<output_path>
" -> doc

library(docopt)
library(readr)
library(dplyr)
library(parsnip)
library(yardstick)
library(broom)

opt <- docopt::docopt(doc)

train_data <- readr::read_csv(opt$input_path_train)
test_data <- readr::read_csv(opt$input_path_test)
penguin_fit <- readr::read_rds(opt$input_path_model)

# Predict on test data
predictions <- parsnip::predict(penguin_fit, test_data, type = "class") %>%
  dplyr::bind_cols(test_data)

# Confusion matrix
conf_mat <- yardstick::conf_mat(predictions, truth = species, estimate = .pred_class)
print(conf_mat)

# Save results as tidy CSV
readr::write_csv(broom::tidy(conf_mat), opt$output_path)