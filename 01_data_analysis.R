
data <- read.csv("diabetes.csv")

cat("DATASET STRUCTURE\n")
str(data)

cat("\nDATASET SUMMARY\n")
print(summary(data))

cat("\nMISSING VALUES\n")
print(colSums(is.na(data)))

cat("\nDATASET DIMENSIONS\n")
print(dim(data))

cat("\nDIABETES OUTCOME COUNT\n")
print(table(data$Outcome))

cat("\nZERO VALUES IN MEDICAL COLUMNS\n")
print(colSums(data[, c("Glucose", "BloodPressure",
                       "SkinThickness", "Insulin", "BMI")] == 0))
