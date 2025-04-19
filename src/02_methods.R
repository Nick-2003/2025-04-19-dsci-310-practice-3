"This script performs exploratory data analysis (EDA) and prepares the data for modeling

Usage: src/02-methods.R --input_path=<input_path> --output_path_summary=<output_path_summary> --output_path_plot=<output_path_plot> --output_path_data=<output_path_data>

Options:
--input_path=<input_path>
--output_path_summary=<output_path_summary>
--output_path_plot=<output_path_plot>
--output_path_data=<output_path_data>
" -> doc

library(docopt)
library(readr)
library(dplyr)
library(ggplot2)

opt <- docopt::docopt(doc)

data <- readr::read_csv(opt$input_path) %>%
  dplyr::mutate(species = as.factor(species))

# Summary statistics
dplyr::glimpse(data)
summary <- dplyr::summarise(data,
  mean_bill_length = mean(bill_length_mm),
  mean_bill_depth = mean(bill_depth_mm),
  mean_flipper_length = mean(flipper_length_mm),
  mean_body_mass = mean(body_mass_g)
)

# Visualizations
penguins_boxplot <- ggplot2::ggplot(data, ggplot2::aes(x = species, y = bill_length_mm, fill = species)) +
  ggplot2::geom_boxplot() +
  ggplot2::theme_minimal()

# Prepare data for modeling
data <- data %>%
  dplyr::select(species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  dplyr::mutate(species = as.factor(species))

# Save data
readr::write_csv(summary, opt$output_path_summary) # "work/output/penguins_summary.csv"
ggplot2::ggsave(opt$output_path_plot, penguins_boxplot) # "work/output/penguins_boxplot.png"
readr::write_csv(data, opt$output_path_data) # "work/data/processed/penguins_processed.csv"