# Check if at least one argument was provided
if (length(commandArgs(trailingOnly = TRUE)) < 1) {
  cat("Usage: Rscript plt_idscore_distr.r <filename> [title]\n")
  q("no")
}

# Get the filename from the command-line arguments
filename <- commandArgs(trailingOnly = TRUE)[1]

# Set a default title or use the provided title
if (length(commandArgs(trailingOnly = TRUE)) < 2) {
  custom_title <- "Distribution of Values"
} else {
  custom_title <- commandArgs(trailingOnly = TRUE)[2]
}

# Read the data from the specified text file, filtering out non-numeric lines
data <- readLines(filename)

# Convert the data to numeric values, ensuring they are within the [0, 1] range
data <- as.numeric(data)

# Check if there are any numeric values that fall outside the [0, 1] range
if (any(data < 0) || any(data > 1)) {
  cat("Invalid data found. Values must be between 0 and 1.\n")
  q("no")
}

# Check if there are any numeric values left to plot
if (length(data) == 0) {
  cat("No valid numeric data found in the file.\n")
  q("no")
}
# Create a PDF file with the custom title
pdf(file = paste0("plot_", gsub(" ", "_", custom_title), ".pdf"), width = 8, height = 6)

# Create a histogram to visualize the distribution with the custom title
hist(data, main = custom_title, xlab = "Idscores", ylab = "Frequency", col = "lightblue", breaks=100)
