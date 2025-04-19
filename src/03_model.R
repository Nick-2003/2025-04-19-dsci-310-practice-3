"This script fits a classification model using `tidymodels` to predict the species of a penguin based on its physical characteristics

Usage: src/03-model.R --input_path=<input_path> --output_path_train=<output_path_train> --output_path_test=<output_path_test> --output_path_model=<output_path_model>

Options:
--input_path=<input_path>
--output_path_train=<output_path_train>
--output_path_test=<output_path_test>
--output_path_model=<output_path_model>
" -> doc

library(docopt)
library(readr)
library(rsample)
library(dplyr)
library(parsnip)
library(workflows)

opt <- docopt::docopt(doc)
data <- readr::read_csv(opt$input_path) %>%
  dplyr::mutate(species = as.factor(species))

# Split data
set.seed(123)
data_split <- rsample::initial_split(data, strata = species)
train_data <- rsample::training(data_split)
test_data <- rsample::testing(data_split)

# Define model
penguin_model <- parsnip::nearest_neighbor(mode = "classification", neighbors = 5) %>%
  parsnip::set_engine("kknn")

# Create workflow
penguin_workflow <- workflows::workflow() %>%
  workflows::add_model(penguin_model) %>%
  workflows::add_formula(species ~ .)

# Fit model
penguin_fit <- penguin_workflow %>%
  parsnip::fit(data = train_data)

# Save model
readr::write_rds(penguin_fit, opt$output_path_model) # "work/output/penguin_fit.rds"

# Save train and test data
readr::write_csv(train_data, opt$output_path_train) # "work/data/processed/penguins_train.csv"
readr::write_csv(test_data, opt$output_path_test) # "work/data/processed/penguins_test.csv"