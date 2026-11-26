
library(shiny)
library(ggplot2)

data <- read.csv("cleaned_diabetes.csv")
model <- readRDS("diabetes_model.rds")

data$OutcomeLabel <- factor(
  data$Outcome,
  levels = c(0, 1),
  labels = c("Non-Diabetic", "Diabetic")
)

ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
      body {
        background: #FFF8EF;
        font-family: Arial, sans-serif;
        color: #38213F;
      }

      .main-header {
        background: linear-gradient(120deg,#38213F,#70415F,#C65D68);
        color: white;
        padding: 35px;
        border-radius: 20px;
        margin: 18px 0 25px;
        box-shadow: 0 10px 30px #38213F25;
      }

      .main-header h1 {
        font-size: 34px;
        font-weight: 800;
      }

      .main-header p {
        color: #FFE5DC;
        font-size: 15px;
      }

      .tagline {
        background: #FFFFFF25;
        padding: 8px 15px;
        border-radius: 25px;
        display: inline-block;
        font-size: 12px;
        letter-spacing: 1px;
      }

      .section-title {
        font-size: 25px;
        font-weight: 800;
        color: #38213F;
        margin: 25px 0;
      }

      .stat-card {
        background: white;
        border-radius: 17px;
        padding: 22px;
        margin-bottom: 20px;
        min-height: 130px;
        box-shadow: 0 7px 22px #38213F12;
        border-top: 5px solid #F16B65;
      }

      .stat-card:nth-child(2) {
        border-top-color: #FFB36B;
      }

      .stat-card p {
        color: #907E91;
        font-size: 12px;
        font-weight: bold;
        letter-spacing: 1px;
      }

      .stat-card h2 {
        color: #70415F;
        font-size: 30px;
        font-weight: 800;
      }

      .panel-card {
        background: white;
        padding: 25px;
        border-radius: 18px;
        margin-bottom: 23px;
        box-shadow: 0 7px 22px #38213F10;
      }

      .well {
        background: white;
        border: 1px solid #F2E5DE;
        border-radius: 18px;
        padding: 23px;
        box-shadow: 0 7px 22px #38213F12;
      }

      .control-label {
        color: #49334D;
        font-weight: bold;
      }

      .form-control {
        border: 1px solid #EBDDD9;
        border-radius: 9px;
        height: 42px;
      }

      .form-control:focus {
        border-color: #F16B65;
        box-shadow: 0 0 0 3px #F16B6522;
      }

      .btn {
        background: linear-gradient(100deg,#70415F,#F16B65);
        color: white;
        border: none;
        border-radius: 10px;
        padding: 13px 18px;
        font-weight: bold;
      }

      .btn:hover {
        background: #38213F;
        color: white;
      }

      .nav-pills {
        margin-bottom: 25px;
      }

      .nav-pills > li > a {
        color: #70415F;
        font-weight: bold;
        border-radius: 10px;
        margin-right: 6px;
        padding: 12px 17px;
      }

      .nav-pills > li.active > a,
      .nav-pills > li.active > a:hover,
      .nav-pills > li.active > a:focus {
        background: #70415F;
        color: white;
      }

      .result-card {
        padding: 30px;
        border-radius: 17px;
        margin-top: 20px;
        background: white;
        box-shadow: 0 7px 22px #38213F12;
      }

      .result-high {
        border-left: 7px solid #F16B65;
        background: #FFF2EE;
      }

      .result-low {
        border-left: 7px solid #69B99A;
        background: #EFF9F3;
      }

      .result-value {
        font-size: 42px;
        font-weight: 800;
        color: #70415F;
      }

      .small-note {
        color: #907E91;
        font-size: 13px;
      }

      .footer {
        text-align: center;
        padding: 28px;
        color: #907E91;
        font-size: 12px;
      }

      h3 {
        color: #38213F;
        font-weight: 750;
      }
    "))
  ),
  
  div(
    class = "main-header",
    div(class = "tagline", "HEALTHCARE ANALYTICS | R PROGRAMMING PBL"),
    h1("Diabetes Risk Analytics"),
    p("Predictive Analysis of Hospital Patient Data"),
    p("Data Science | Logistic Regression | R Shiny")
  ),
  
  tabsetPanel(
    
    type = "pills",
    
    tabPanel(
      "Dashboard",
      
      h3(class = "section-title", "Project Overview"),
      
      fluidRow(
        column(3,
               div(class = "stat-card",
                   p("TOTAL PATIENTS"),
                   h2(nrow(data))
               )
        ),
        
        column(3,
               div(class = "stat-card",
                   p("DIABETIC RECORDS"),
                   h2(sum(data$Outcome == 1))
               )
        ),
        
        column(3,
               div(class = "stat-card",
                   p("NON-DIABETIC"),
                   h2(sum(data$Outcome == 0))
               )
        ),
        
        column(3,
               div(class = "stat-card",
                   p("MODEL ACCURACY"),
                   h2("80.39%")
               )
        )
      ),
      
      div(class = "panel-card",
          h3("Diabetes Distribution"),
          p(class = "small-note",
            "Distribution of patient categories"),
          plotOutput("distribution", height = "320px")
      ),
      
      div(class = "panel-card",
          h3("BMI vs Glucose Analysis"),
          p(class = "small-note",
            "Relationship between BMI and glucose levels"),
          plotOutput("scatter", height = "350px")
      )
    ),
    
    tabPanel(
      "Patient Prediction",
      
      h3(class = "section-title", "Patient Risk Assessment"),
      
      fluidRow(
        
        column(5,
               div(class = "panel-card",
                   
                   h3("Patient Information"),
                   
                   p(class = "small-note",
                     "Enter patient health details"),
                   
                   numericInput("preg", "Pregnancies", 2, min = 0, max = 20),
                   numericInput("glucose", "Glucose Level", 120, min = 1, max = 250),
                   numericInput("bp", "Blood Pressure", 70, min = 1, max = 150),
                   numericInput("skin", "Skin Thickness", 20, min = 0, max = 100),
                   numericInput("insulin", "Insulin Level", 80, min = 0, max = 900),
                   numericInput("bmi", "BMI", 25, min = 1, max = 70),
                   numericInput("dpf", "Diabetes Pedigree Function", 0.5, min = 0, max = 2.5),
                   numericInput("age", "Age", 30, min = 1, max = 100),
                   
                   actionButton(
                     "predict",
                     "Generate Prediction",
                     width = "100%"
                   )
               )
        ),
        
        column(7,
               
               div(class = "panel-card",
                   h3("Prediction Result"),
                   uiOutput("prediction")
               ),
               
               div(class = "panel-card",
                   h3("How It Works"),
                   p("01. Patient health information is collected."),
                   p("02. Input values are passed to the trained model."),
                   p("03. Logistic Regression estimates the probability."),
                   p("04. The result is displayed on the dashboard.")
               )
        )
      )
    ),
    
    tabPanel(
      "Analytics",
      
      h3(class = "section-title", "Model Performance"),
      
      fluidRow(
        
        column(3,
               div(class = "stat-card",
                   p("ACCURACY"),
                   h2("80.39%")
               )
        ),
        
        column(3,
               div(class = "stat-card",
                   p("PRECISION"),
                   h2("78.05%")
               )
        ),
        
        column(3,
               div(class = "stat-card",
                   p("RECALL"),
                   h2("60.38%")
               )
        ),
        
        column(3,
               div(class = "stat-card",
                   p("F1 SCORE"),
                   h2("68.09%")
               )
        )
      ),
      
      div(class = "panel-card",
          h3("Evaluation Metrics"),
          tableOutput("metrics")
      ),
      
      div(class = "panel-card",
          h3("Glucose Distribution"),
          plotOutput("glucose_plot", height = "320px")
      )
    ),
    
    tabPanel(
      "About Project",
      
      h3(class = "section-title", "About Our Project"),
      
      div(class = "panel-card",
          
          h3("Project Description"),
          
          p("Predictive Analytics for Hospital Patient Data and Diabetes Risk analyses patient health information and applies Logistic Regression to estimate diabetes risk."),
          
          h3("Project Objectives"),
          
          tags$ul(
            tags$li("Analyse patient health records."),
            tags$li("Identify diabetes-related patterns."),
            tags$li("Perform data cleaning and preprocessing."),
            tags$li("Build a Logistic Regression model."),
            tags$li("Evaluate model performance."),
            tags$li("Develop an interactive web application.")
          ),
          
          h3("Technology Used"),
          
          p("R Programming, RStudio, Shiny, ggplot2, caret and Logistic Regression."),
          
          h3("Dataset Information"),
          
          p("Pima Indians Diabetes Dataset: 768 records and 9 columns."),
          
          h3("Project Workflow"),
          
          p("Data Collection → Data Analysis → Data Cleaning → EDA → Model Training → Evaluation → Web Application"),
          
          h3("Disclaimer"),
          
          p("This project is for academic purposes. Predictions are not a medical diagnosis.")
      )
    )
  ),
  
  div(
    class = "footer",
    "DIABETES RISK ANALYTICS",
    br(),
    "R PROGRAMMING LAB | PBL PROJECT",
    br(),
    "Academic Project | Healthcare Data Analytics"
  )
)

server <- function(input, output) {
  
  prediction_result <- eventReactive(input$predict, {
    
    patient <- data.frame(
      Pregnancies = input$preg,
      Glucose = input$glucose,
      BloodPressure = input$bp,
      SkinThickness = input$skin,
      Insulin = input$insulin,
      BMI = input$bmi,
      DiabetesPedigreeFunction = input$dpf,
      Age = input$age
    )
    
    validate(
      need(
        all(is.finite(unlist(patient))),
        "Please enter valid patient details."
      )
    )
    
    probability <- as.numeric(
      predict(model, patient, type = "response")
    )
    
    list(
      probability = probability,
      category = ifelse(
        probability >= 0.5,
        "Higher predicted risk",
        "Lower predicted risk"
      )
    )
  })
  
  output$prediction <- renderUI({
    
    if (input$predict == 0) {
      return(
        div(
          class = "result-card",
          h3("Ready for Analysis"),
          p("Enter patient details and generate a prediction.")
        )
      )
    }
    
    result <- prediction_result()
    high <- result$probability >= 0.5
    
    div(
      class = paste(
        "result-card",
        if (high) "result-high" else "result-low"
      ),
      
      h3(result$category),
      
      div(
        class = "result-value",
        paste0(round(result$probability * 100, 2), "%")
      ),
      
      p("Estimated model probability"),
      
      p(
        class = "small-note",
        "Educational prediction only. Not a medical diagnosis."
      )
    )
  })
  
  output$distribution <- renderPlot({
    
    ggplot(
      data,
      aes(x = OutcomeLabel, fill = OutcomeLabel)
    ) +
      geom_bar(width = 0.58) +
      scale_fill_manual(
        values = c("#9670C6", "#F16B65")
      ) +
      labs(
        x = "Patient Category",
        y = "Number of Patients"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        legend.position = "none",
        plot.title = element_text(face = "bold")
      )
  })
  
  output$scatter <- renderPlot({
    
    ggplot(
      data,
      aes(x = BMI, y = Glucose, color = OutcomeLabel)
    ) +
      geom_point(alpha = 0.7, size = 2.2) +
      scale_color_manual(
        values = c("#9670C6", "#F16B65")
      ) +
      labs(
        x = "BMI",
        y = "Glucose Level",
        color = "Patient Category"
      ) +
      theme_minimal(base_size = 13)
  })
  
  output$glucose_plot <- renderPlot({
    
    ggplot(
      data,
      aes(x = Glucose, fill = OutcomeLabel)
    ) +
      geom_histogram(
        bins = 30,
        alpha = 0.75,
        position = "identity"
      ) +
      scale_fill_manual(
        values = c("#9670C6", "#F16B65")
      ) +
      labs(
        x = "Glucose Level",
        y = "Frequency",
        fill = "Patient Category"
      ) +
      theme_minimal(base_size = 13)
  })
  
  output$metrics <- renderTable({
    
    data.frame(
      Metric = c("Accuracy", "Precision", "Recall", "F1 Score"),
      Score = c("80.39%", "78.05%", "60.38%", "68.09%")
    )
    
  }, striped = TRUE, bordered = FALSE, hover = TRUE)
}

shinyApp(ui = ui, server = server)
