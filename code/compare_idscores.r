# Check if at least two arguments were provided
if (length(commandArgs(trailingOnly = TRUE)) < 2) {
  cat("Usage: Rscript compare_idscore_density.r <filename1> <filename2> [plot_type] [title] [legend1] [legend2]\n")
  q("no")
}

# Get the filenames, plot type, and custom title from the command-line arguments
filename1 <- commandArgs(trailingOnly = TRUE)[1]
filename2 <- commandArgs(trailingOnly = TRUE)[2]
plot_type <- ifelse(length(commandArgs(trailingOnly = TRUE)) >= 3, tolower(commandArgs(trailingOnly = TRUE)[3]), "histogram")

# Set a default title or use the provided title
if (length(commandArgs(trailingOnly = TRUE)) < 4) {
  custom_title <- "Distribution of Values"
} else {
  custom_title <- commandArgs(trailingOnly = TRUE)[4]
}

# Set default legends or use provided legends
legend1 <- filename1
legend2 <- filename2

if (length(commandArgs(trailingOnly = TRUE)) >= 5) {
  legend1 <- commandArgs(trailingOnly = TRUE)[5]
}

if (length(commandArgs(trailingOnly = TRUE)) >= 6) {
  legend2 <- commandArgs(trailingOnly = TRUE)[6]
}

# Function to read and filter non-numeric lines
read_and_filter <- function(filename) {
  data <- readLines(filename)
  numeric_data <- as.numeric(data)
  numeric_data <- numeric_data[!is.na(numeric_data)]
  numeric_data <- numeric_data[numeric_data >= 0 & numeric_data <= 1]
  return(numeric_data)
}

# Read and filter data from the specified text files
data1 <- read_and_filter(filename1)
data2 <- read_and_filter(filename2)

# Check if there are any numeric values left to plot
if (length(data1) == 0 || length(data2) == 0) {
  cat("No valid numeric data found in one or both of the files.\n")
  q("no")
}

# Create a PDF file with the custom title
pdf(file = paste0("plot_", gsub(" ", "_", custom_title), ".pdf"), width = 8, height = 6)

if (plot_type == "histogram") {
  # Create histograms to visualize the combined distribution with the custom title
  hist(data1, main = custom_title, xlab = "Idscores", ylab = "Frequency", col = "red", breaks = 100, 
       xlim = c(0, 1), ylim = c(0, 20), border = "black", probability = TRUE)
  hist(data2, col = "blue", add = TRUE, breaks = 100, 
       xlim = c(0, 1), ylim = c(0, 20), probability = TRUE)
} else if (plot_type == "density") {
  # Create density plots to visualize the distribution with the custom title
  plot_range <- range(0, 1)  # Adjust the range as needed
  plot(density(data1, from = plot_range[1], to = plot_range[2]), type = 'l', col = "red",
       main = custom_title, xlab = "Idscores", ylab = "Density")
  lines(density(data2, from = plot_range[1], to = plot_range[2]), col = "blue")
} else {
  cat("Invalid plot type. Use 'histogram' or 'density'.\n")
  q("no")
}

# Set legends
legend1 <- tools::file_path_sans_ext(basename(legend1))
legend2 <- tools::file_path_sans_ext(basename(legend2))
legend("topleft", legend = c(legend1, legend2), fill= c("red","blue" ))
