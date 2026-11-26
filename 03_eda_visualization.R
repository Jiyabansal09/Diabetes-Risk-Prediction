
library(ggplot2)

data <- read.csv("cleaned_diabetes.csv")

dir.create("graphs", showWarnings = FALSE)

data$Outcome <- factor(
  data$Outcome,
  levels = c(0, 1),
  labels = c("Non-Diabetic", "Diabetic")
)

p1 <- ggplot(data, aes(x = Outcome, fill = Outcome)) +
  geom_bar() +
  labs(title = "Diabetes Distribution",
       x = "Patient Category",
       y = "Number of Patients") +
  theme_minimal()

print(p1)

ggsave("graphs/diabetes_distribution.png", p1)

p2 <- ggplot(data, aes(x = Glucose, fill = Outcome)) +
  geom_histogram(bins = 30, alpha = 0.7) +
  labs(title = "Glucose Level Distribution",
       x = "Glucose Level",
       y = "Frequency") +
  theme_minimal()

print(p2)

ggsave("graphs/glucose_analysis.png", p2)

p3 <- ggplot(data, aes(x = BMI, y = Glucose,
                       color = Outcome)) +
  geom_point() +
  labs(title = "BMI vs Glucose Analysis",
       x = "BMI",
       y = "Glucose Level") +
  theme_minimal()

print(p3)

ggsave("graphs/bmi_glucose.png", p3)
