
data <- read.csv("diabetes.csv")

clean_data <- data

cols <- c("Glucose", "BloodPressure",
          "SkinThickness", "Insulin", "BMI")

for (col in cols) {
  clean_data[[col]][clean_data[[col]] == 0] <- NA
}

for (col in cols) {
  clean_data[[col]][is.na(clean_data[[col]])] <-
    median(clean_data[[col]], na.rm = TRUE)
}

cat("Missing Values After Cleaning:\n")
print(colSums(is.na(clean_data)))

cat("\nCleaned Dataset:\n")
print(dim(clean_data))

write.csv(clean_data, "cleaned_diabetes.csv",
          row.names = FALSE)
