# Librerias
if(!require("corrplot")) install.packages("corrplot"); library("corrplot")
if(!require("dplyr")) install.packages("dplyr"); library("dplyr")
if(!require("tidyr")) install.packages("tidyr"); library("tidyr")
if(!require("ggplot2")) install.packages("ggplot2"); library("ggplot2")
if(!require("pROC")) install.packages("pROC"); library("pROC")
if(!require('kableExtra')) install.packages('kableExtra'); library('kableExtra')

### Descripción del dataset ###

# Carga del fichero
heartAttack <- read.csv('../data/heart_in.csv')

# Nombres de las variables del dataset separados por coma
heartAttack.var_names <- sub(",\\s(?!.*,\\s)", " y ", paste(names(heartAttack), collapse = ", "), perl = TRUE)

# Estructura del dataset
str(heartAttack)

# Gráfica general de las variables numéricas
heartAttack %>%
  select_if(is.numeric) %>%
  gather() %>%
  ggplot(aes(value)) +
  geom_bar(fill = "pink") +
  facet_wrap(~ key, scales = 'free') +
  theme(axis.text = element_text(size = 6))

# Nombres de las variables categoricas
categorical_var <- c("sex", "caa", "cp", "fbs", "restecg", "exng", "slp", "thall")

# Nombres de las variables numéricas
numerical_var <- c("age", "trtbps", "chol", "thalachh", "oldpeak")

# Conversión de variables numéricas categoricas a factor
heartAttack <- heartAttack %>%
  mutate(across(all_of(categorical_var), factor))

### Integración y selección ###

# Coeficiente de correlación de Pearson (variables numéricas sin la target) + plot de correlación
selected_vars <- c(numerical_var, "output")
cor_pearson <- cor(heartAttack[selected_vars], method = "pearson")
corrplot(cor_pearson, method = "color", tl.col = "black", tl.srt = 45, order = "AOE", 
         tl.cex = 0.7, number.cex = 0.7, sig.level = 0.01, addCoef.col = "firebrick")
cor_pearson_output <- round(cor_pearson["output", ], 2)
cor_pearson_output

# Prueba de Fisher
fisher_results <- list()
for (var in categorical_var) {
  fisher_result <- fisher.test(heartAttack[[var]], heartAttack$output)
  fisher_results[[var]] <- fisher_result
}
fisher_results

### Limpieza de los datos ###

# Estructura del dataset después de los cambios
str(heartAttack)
summary(heartAttack)

# Búsqueda de variables numéricas con ceros
colSums(heartAttack %>% select(all_of(numerical_var)) == 0)

# Búsqueda de NAs
colSums(is.na(heartAttack))

# Función auxiliar para la identificación de valores atípicos
count_outliers<-function(var){
  return (length(boxplot.stats(var)$out))
}

# Identificación de valores atípicos
heartAttack.numeric_vars <- heartAttack %>% select(all_of(numerical_var))
sapply(heartAttack.numeric_vars, function(var) count_outliers(var))

# Plot de los valores atípicos
numeric_box_plot <-heartAttack.numeric_vars %>% gather() %>% ggplot(aes(value)) +
geom_boxplot(fill="coral") + facet_wrap(~key,scales='free') + theme(axis.text=element_text(size=8)) + labs(title = "Boxplot para buscar Outliers")
numeric_box_plot

# Registros totales antes de eliminar valores atípicos
reg_totales <- nrow(heartAttack)

# Muestra de valores atípicos por cada variable
chol.out <- sort(unique(boxplot.stats(heartAttack$chol)$out))
oldpeak.out <- sort(unique(boxplot.stats(heartAttack$oldpeak)$out))
thalachh.out <- sort(unique(boxplot.stats(heartAttack$thalachh)$out))
trtbps.out <- sort(unique(boxplot.stats(heartAttack$trtbps)$out))

cat("Valores atípicos de 'chol':", chol.out,"con un total de", nrow(heartAttack[(heartAttack$chol %in% chol.out),]) ,"registros", "\n")
cat("Valores atípicos de 'oldpeak':", oldpeak.out,"con un total de", nrow(heartAttack[(heartAttack$oldpeak %in% oldpeak.out),]) ,"registros", "\n")
cat("Valores atípicos de 'thalachh':", thalachh.out,"con un total de", nrow(heartAttack[(heartAttack$thalachh %in% thalachh.out),]) ,"registros", "\n")
cat("Valores atípicos de 'trtbps':", trtbps.out,"con un total de", nrow(heartAttack[(heartAttack$trtbps %in% trtbps.out),]) ,"registros", "\n")

# Eliminación de valores atípicos
heartAttack <-
  heartAttack[!(
    heartAttack$chol %in% chol.out |
    heartAttack$oldpeak %in% oldpeak.out |
    heartAttack$thalachh %in% thalachh.out |
    heartAttack$trtbps %in% trtbps.out
  ), ]

# Eliminación de la categoría 4 en 'caa'
heartAttack <- heartAttack[!(heartAttack$caa %in% 4),]
heartAttack$caa <- droplevels(heartAttack$caa)

# Muestra de registros sin valores atípicos
reg_no_outliers <- nrow(heartAttack)
cat("Cantidad de registros antes", reg_totales,"y después de eliminar los valores atípicos", reg_no_outliers, "\n")

### Análisis de los datos ###

# Visualización de la distribución de age en un histograma
ggplot(heartAttack, aes(x = age)) +
  geom_histogram(fill = "steelblue", color = "white", bins = 30) +
  labs(x = "Age", y = "Frecuencia", title = "Distribucion de Age")

# Discretización de la variable age
age_breaks <- c(0, 45, 60, 80)
heartAttack$age_discretized <-
  cut(
    heartAttack$age,
    breaks = age_breaks,
    labels = c("Jovenes", "Media", "Vejez"),
    include.lowest = TRUE
  )

# Visualización del mínimo y máximo de age para cada categoría
max_min_age <- tapply(heartAttack$age, heartAttack$age_discretized, range)
max_jovenes <- max_min_age[["Jovenes"]][2]
min_jovenes <- max_min_age[["Jovenes"]][1]
max_medio <- max_min_age[["Media"]][2]
min_medio <- max_min_age[["Media"]][1]
max_vejez <- max_min_age[["Vejez"]][2]
min_vejez <- max_min_age[["Vejez"]][1]

cat("Jovenes -", "Mínimo:", min_jovenes,"Máximo:", max_jovenes, "\n")
cat("Medio -", "Mínimo:", min_medio,"Máximo:", max_medio, "\n")
cat("Vejez -", "Mínimo:", min_vejez,"Máximo:", max_vejez, "\n")

# Comprobación de normalidad de la variable trtbps con Gráfico Q-Q
group_names <- unique(heartAttack$age_discretized)
par(mfrow = c(length(group_names), 2)) 
for (i in 1:length(group_names)) {
  group <- group_names[i]
  group_data <- subset(heartAttack, age_discretized == group)
  qqnorm(group_data$trtbps, main = paste("Grupo:", group, "- Variable: trtbps"))
  qqline(group_data$trtbps, col = "#FC4E07")
}

# Comprobación de normalidad por grupo con Shapiro-Wilk
group_names <- unique(heartAttack$age_discretized)
for (group in group_names) {
  group_data <- subset(heartAttack, age_discretized == group)
  shapiro_test_trtbps <- shapiro.test(group_data$trtbps)
  cat("Grupo:", group, "\n")
  cat("El p-value de trtbps es:", shapiro_test_trtbps$p.value, "\n")
   if (shapiro_test_trtbps$p.value >= 0.05) {
    cat("La variable 'trtbps' en el grupo", group, "sigue una distribución normal.\n")
  } else {
    cat("La variable 'trtbps' en el grupo", group, "no sigue una distribución normal.\n")
  }
  cat("\n")
}

# Análisis de diferencias entre el tipo de dolor en el pecho y el sexo en las observaciones con infarto con Chi-cuadrado
infarto <- subset(heartAttack, output== 1)
tabla <- table(infarto$cp, infarto$sex)
tabla
chi_square <- chisq.test(tabla)
chi_square

# Análisis con Kruskal-Wallis para la presión arterial y los diferentes grupos de edad
kruskal_trtbps <- kruskal.test(trtbps~age_discretized, data=heartAttack)
kruskal_trtbps

# Separación del data set en 70% entrenamiento y 30% test para Regresión logística
set.seed(23)
train_index <- sample(1:nrow(heartAttack), nrow(heartAttack) * 0.7)  
train <- heartAttack[train_index, ]
test <- heartAttack[-train_index, ]

# Modelo de regresión logística 1 con todas las variables
model <- glm(output ~ ., data = train, family = binomial)
summary(model)

# Modelo de regresión logística 2 con las variables significativas: cp, oldpeak y caa
model_2 <- glm(output ~ cp + oldpeak + caa, data = train, family = binomial)
summary(model_2)

### Representación de los resultados ###

# Representación de la variable sex y cp con gráfico de líneas
infarto_porcentaje <- infarto %>%
  group_by(sex, cp) %>%
  summarize(n = n()) %>%
  mutate(percentage = n / sum(n))
etiquetas_cp <- c("Angina típica", "Angina atípica", "Dolor no anginal", "Asintomático")
etiquetas_sex <- c("Femenino", "Masculino")

ggplot(data = infarto_porcentaje, aes(x = cp, y = percentage, color = sex, group = sex)) +
  geom_line() +
  labs(x = "cp", y = "Porcentaje de observaciones (%)") +
  ggtitle("Porcentaje de observaciones por cp y sexo") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal() +
  scale_x_discrete(labels = etiquetas_cp) +
  scale_color_discrete(labels = etiquetas_sex)

# Gráfica de valores esperados y obtenidos en sex y cp
observados <- chi_square$observed
esperados <- chi_square$expected
categorias_sex <- c("Femenino", "Masculino")
categorias_cp <- c("Angina típica", "Angina atípica", "Dolor no anginal", "Asintomático")
datos <- data.frame(cp = rep(categorias_cp, length(categorias_sex)),
                    sexo = rep(categorias_sex, each = length(categorias_cp)),
                    observados = as.vector(observados),
                    esperados = as.vector(esperados))
colores <- c("steelblue", "darkorange")

ggplot(data = datos, aes(x = cp, fill = sexo)) +
  geom_bar(aes(y = observados), position = position_dodge(width = 0.9), stat = "identity", width = 0.4) +
  geom_bar(aes(y = esperados), position = position_dodge(width = 0.9), fill = "gray", alpha = 0.5, stat = "identity", width = 0.4) +
  labs(x = "CP", y = "Valor", fill = "Sexo") +
  ggtitle("Valores Observados y Esperados por CP y Sexo") +
  scale_fill_manual(values = colores) +
  theme_minimal() +
  theme(legend.position = "top")

# Tabla de valores
kable(datos,
  caption = "Tabla de valores", row.names = FALSE, longtable = TRUE) %>%
  column_spec(1, width = "12em") %>%
  column_spec(2, width = "12em") %>%
  column_spec(3, width = "6em") %>%
  column_spec(4, width = "10em") %>%
  kable_styling(latex_options = c("hold_position", "repeat_header"))

# Distribución de los datos Chi-cuadrado
grados_libertad <- length(unique(infarto$sex)) * (length(unique(infarto$cp)) - 1)
# Valores para la distribución chi-cuadrado
x <- seq(0, 20, 0.1) 
# Generamos la función de densidad chi-cuadrado
y <- dchisq(x, df = grados_libertad)  
# Graficamos la distribución chi-cuadrado
plot(x, y, type = "l", lwd = 2,
     xlab = "Valor chi-cuadrado", ylab = "Densidad",
     main = "Distribución Chi-Cuadrado")
# Obtenemos el valor observado del estadístico chi-cuadrado
valor_observado <- chi_square$statistic
# Agregamos la línea vertical para el valor observado chi-cuadrado
abline(v = valor_observado, col = "red", lwd = 2)
text(valor_observado, 0.03, paste("Valor observado:", round(valor_observado, 2)),
     pos = 4, col = "red")

nivel_significancia <- 0.05  

valor_critico <- qchisq(1 - nivel_significancia, df = grados_libertad)
# Agregamos la línea vertical para el valor crítico
abline(v = valor_critico, col = "blue", lwd = 2)
text(valor_critico, 0.11, paste("Valor crítico:", round(valor_critico, 2)),
     pos = 2, col = "blue")


# Histograma de la variable trtbps en cada grupo de edad
heartAttack_filtered <- heartAttack[, c("trtbps", "age_discretized")]
ggplot(heartAttack_filtered, aes(x = trtbps, fill = age_discretized)) +
  geom_histogram(binwidth = 10, position = "stack", colour='black') +
  labs(x = "trtbps", y = "Frecuencia") +
  ggtitle("Histograma de trtbps por Grupo de Edad") +
  theme_minimal()

# Boxplot para buscar diferencias en los grupos de edad en base a trtbps
ggplot(heartAttack, aes(x = age_discretized, y = trtbps, fill = age_discretized)) +
  geom_boxplot(color = "black") +
  labs(x = "Grupo de Edad", y = "trtbps") +
  ggtitle("Distribución de trtbps por Grupo de Edad") +
  theme_minimal()

# Media de trtbps de cada grupo de edad
means <- tapply(heartAttack$trtbps, heartAttack$age_discretized, mean)
print(means)

# Predicción con Regresión logística
predicted <- predict(model_2, newdata = test, type = "response") > 0.5

# Matriz de confusión
confusion_matrix <- table(predicted, test$output)

# Matriz de confusión normalizada
normalized_confusion_matrix <- prop.table(confusion_matrix, margin = 1)
print(normalized_confusion_matrix)

# Obtención y visualización de la curva ROC y del area bajo la curva
predicted_probs <- predict(model_2, newdata = test, type = "response")
labels <- test$output 
auc <- roc(test$output, predicted_probs)
roc_obj <- roc(labels, predicted_probs)
plot(roc_obj, main = "Curva ROC")
auc

# Creación det csv de salida
write.csv(heartAttack,'../data/heart_out.csv')