
library(caret)

data <- read.csv("cleaned_diabetes.csv")

data$Outcome <- factor(
  data$Outcome,
  levels = c(0, 1),
  labels = c("Non-Diabetic", "Diabetic")
)

set.seed(123)

index <- createDataPartition(
  data$Outcome,
  p = 0.8,
  list = FALSE
)

train_data <- data[index, ]
test_data <- data[-index, ]

model <- glm(
  Outcome ~ .,
  data = train_data,
  family = binomial
)

probabilities <- predict(
  model,
  test_data,
  type = "response"
)

predictions <- ifelse(
  probabilities >= 0.5,
  "Diabetic",
  "Non-Diabetic"
)

predictions <- factor(
  predictions,
  levels = levels(test_data$Outcome)
)

results <- confusionMatrix(
  predictions,
  test_data$Outcome,
  positive = "Diabetic"
)

cat("MODEL SUMMARY\n")
print(summary(model))

cat("\nCONFUSION MATRIX\n")
print(results)

cat("\nMODEL ACCURACY\n")
print(results$overall["Accuracy"])

cat("\nPRECISION\n")
print(results$byClass["Precision"])

cat("\nRECALL\n")
print(results$byClass["Recall"])

cat("\nF1 SCORE\n")
print(results$byClass["F1"])

saveRDS(model, "diabetes_model.rds")

cat("\nModel saved successfully!\n")


