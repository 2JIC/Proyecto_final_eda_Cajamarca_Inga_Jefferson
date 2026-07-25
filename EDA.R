#=========================================================
# PROYECTO FINAL 2 - ANALISIS EXPLORATORIO DE DATOS (EDA)
# Fuente: INEI - ENAHO 2025, Modulo 500 (Empleo e Ingresos)
# Departamento analizado: Cajamarca
#=========================================================

# ---------------------------------------------------------
# 1. CONTEXTO DEL CONJUNTO DE DATOS
# ---------------------------------------------------------
# Institucion: Instituto Nacional de Estadistica e Informatica (INEI)
# Fuente: Encuesta Nacional de Hogares (ENAHO) 2025, Modulo 500
# Objetivo: Explorar si existe una brecha de ingresos por sexo
#           dentro de cada nivel educativo, controlando por categoria ocupacional
#           en el departamento de Cajamarca.
# Variables principales:
#   - sexo (p207)
#   - edad (p208a)
#   - educacion (p301a)
#   - categ_ocup (p510): categoria ocupacional
#   - ingreso (i524a1): ingreso monetario del trabajo principal

library(haven)
library(dplyr)
library(ggplot2)
library(psych)

# ---------------------------------------------------------
# 2. IMPORTACION DE DATOS
# ---------------------------------------------------------
enaho_500 <- read_dta("Proyecto_Final/data/enaho01a-2025-500.dta")

enaho_500 <- enaho_500 %>%
  mutate(dpto = substr(as.character(ubigeo), 1, 2))

# ---------------------------------------------------------
# 3. LIMPIEZA Y PREPARACION
# ---------------------------------------------------------
datos <- enaho_500 %>%
  select(
    dpto, sexo = p207, edad = p208a, educacion = p301a,
    categ_ocup = p510, ingreso = i524a1
  ) %>%
  filter(dpto == "06") %>%
  filter(ingreso > 0) %>%
  na.omit() %>%
  mutate(
    log_ingreso = log(ingreso),
    grupo_edad = cut(
      edad,
      breaks = c(14, 24, 34, 44, 54, 64, 100),
      labels = c("14-24", "25-34", "35-44", "45-54", "55-64", "65+"),
      right = TRUE
    )
  )
# ---------------------------------------------------------
# 4. ESTADISTICAS DESCRIPTIVAS
# ---------------------------------------------------------
describe(datos %>% select(ingreso, edad))

# ANALISIS:
# - ingreso: media=19785.49, mediana=13529, SD=19330. La gran
#   diferencia entre media y mediana, junto con el skew=2.49 y
#   kurtosis=11.35, confirman una distribucion fuertemente sesgada
#   a la derecha: un grupo pequenio de casos con ingresos muy altos
#   (hasta 192,020) infla el promedio, mientras la mayoria gana
#   bastante menos (13,529 o menos). Esto justifica el uso de
#   log_ingreso en los graficos y modelos estadisticos, ya que en
#   la escala original no se cumple el supuesto de normalidad
#   necesario para pruebas parametricas como t-test o ANOVA.
# - edad: media=38.94 y mediana=38 son muy cercanas (skew=0.24),
#   lo que indica una distribucion razonablemente simetrica. El
#   rango (14 a 79 anios) es consistente con poblacion en edad de
#   trabajar, ya filtrada por tener ingreso reportado.

tabla_edu_sexo <- table(as_factor(datos$educacion), as_factor(datos$sexo))
tabla_edu_sexo

# ANALISIS:
# - En los niveles educativos bajos (Primaria Incompleta: 30H/20M;
#   Primaria Completa: 63H/27M; Secundaria Completa: 112H/42M) los
#   hombres predominan claramente en la muestra de trabajadores con
#   ingreso reportado.
# - "Superior No Universitaria Completa" es de las pocas categorias
#   con relativa paridad (52H/55M).
# - Los grupos con "n" muy bajo por sexo (ej. "Sin Nivel": 5H/6M)
#   deben interpretarse con cautela, ya que cualquier comparacion
#   de ingreso promedio ahi tiene poca fiabilidad estadistica por
#   el tamanio de muestra reducido.

tabla_ocup_sexo <- table(as_factor(datos$categ_ocup), as_factor(datos$sexo))
tabla_ocup_sexo

# ANALISIS:
# - La mayoria de la muestra se concentra en dos categorias:
#   "Empresa o Patrono Privado" (341H/153M) y "Administracion
#   Publica" (90H/90M, perfectamente paritaria).
# - Las demas categorias (FFAA, Empresa Publica, SERVICE, Otra)
#   tienen muy pocas observaciones y son poco relevantes para el
#   analisis estadistico.
# - En el sector privado la proporcion hombre/mujer es mas desigual
#   (ratio ~2.2:1) que en el sector publico (ratio 1:1), lo que
#   sugiere una mejor paridad de genero en el empleo publico dentro
#   de esta muestra.

promedio_ingreso_edu_sexo <- datos %>%
  group_by(educacion = as_factor(educacion), sexo = as_factor(sexo)) %>%
  summarise(
    ingreso_promedio = mean(ingreso),
    ingreso_mediana = median(ingreso),
    n = n(),
    .groups = "drop"
  ) %>%
  arrange(educacion, sexo)
promedio_ingreso_edu_sexo

# ANALISIS:
# - En casi todos los niveles educativos, el ingreso promedio de
#   hombres supera al de mujeres: Primaria Incompleta (11,652 vs
#   6,567; brecha ~44%), Primaria Completa (11,576 vs 8,065; ~30%),
#   Secundaria Incompleta (8,797 vs 7,147; ~19%).
# - Excepcion notable: "Sin Nivel", donde la mediana de mujeres casi
#   iguala a la de hombres (4,128 vs 2,998), aunque la media del
#   hombre es mayor (8,653 vs 4,836), lo que sugiere un valor
#   atipico masculino que infla el promedio en ese grupo.
# - La brecha parece mas amplia en los niveles bajos (primaria) que
#   en secundaria, lo que sugeriria que la brecha salarial se
#   reduce (aunque no desaparece) a mayor nivel educativo. Esto se
#   debe confirmar revisando los niveles superiores y de
#   maestria/doctorado.

# ---------------------------------------------------------
# 5. VISUALIZACION DE DATOS (ggplot2)
# ---------------------------------------------------------
# Grafico 1: Distribucion del ingreso (log, por la fuerte asimetria esperada)
g1 <- ggplot(datos, aes(x = log_ingreso)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "black") +
  labs(
    title = "Distribucion del ingreso (escala logaritmica)",
    subtitle = "Trabajadores con ingreso reportado - ENAHO 2025",
    x = "Log(ingreso mensual)",
    y = "Frecuencia"
  ) +
  theme_minimal()
g1

# Grafico 2: Ingreso segun sexo
g2 <- ggplot(datos, aes(x = as_factor(sexo), y = log_ingreso)) +
  geom_boxplot(fill = "forestgreen", alpha = 0.7) +
  labs(
    title = "Ingreso segun sexo",
    subtitle = "Escala logaritmica - ENAHO 2025",
    x = "Sexo",
    y = "Log(ingreso mensual)"
  ) +
  theme_minimal()
g2

# Grafico 3: Ingreso segun nivel educativo, separado por sexo (hallazgo clave)
g3 <- ggplot(datos, aes(x = as_factor(educacion), y = log_ingreso, fill = as_factor(sexo))) +
  geom_boxplot() +
  labs(
    title = "Ingreso segun nivel educativo y sexo",
    subtitle = "Escala logaritmica - ENAHO 2025",
    x = "Nivel educativo",
    y = "Log(ingreso mensual)",
    fill = "Sexo"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
g3

# Grafico 4: Ingreso promedio por educacion y sexo (barras agrupadas)
g4 <- ggplot(promedio_ingreso_edu_sexo,
             aes(x = educacion, y = ingreso_promedio, fill = sexo)) +
  geom_col(position = "dodge") +
  labs(
    title = "Ingreso promedio por nivel educativo y sexo",
    subtitle = "ENAHO 2025",
    x = "Nivel educativo",
    y = "Ingreso promedio (S/)",
    fill = "Sexo"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
g4

# ---------------------------------------------------------
# 6. GUARDAR GRAFICOS INDIVIDUALES Y COLLAGE (figures/)
# ---------------------------------------------------------
# install.packages("patchwork")
library(patchwork)

ggsave("figures/g1_distribucion_ingreso.png", g1, width = 7, height = 5, dpi = 300)
ggsave("figures/g2_ingreso_sexo.png", g2, width = 7, height = 5, dpi = 300)
ggsave("figures/g3_ingreso_educacion_sexo.png", g3, width = 8, height = 6, dpi = 300)
ggsave("figures/g4_ingreso_promedio_barras.png", g4, width = 8, height = 6, dpi = 300)

collage <- (g1 | g2) / (g3 | g4)
ggsave("figures/collage_graficos.png", collage, width = 14, height = 10, dpi = 300)
