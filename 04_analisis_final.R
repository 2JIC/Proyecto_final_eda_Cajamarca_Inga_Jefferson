#=========================================================
# PROYECTO FINAL 2 - ANALISIS FINAL (PARTE 2)
# Fuente: INEI - ENAHO 2025, Modulo 500
#=========================================================
# PREGUNTA DE ANALISIS:
# ¿Existe una brecha de ingresos por sexo dentro de cada nivel
# educativo, y esa brecha persiste (o se explica parcialmente)
# al controlar por categoria ocupacional en el departamento de Cajamarca?
#=========================================================

library(haven)
library(dplyr)
library(ggplot2)

# Se asume que "datos" ya fue generado en EDA.R.
if (!exists("datos")) {
  stop("Ejecuta primero EDA.R para generar el objeto 'datos'.")
}

# ---------------------------------------------------------
# 1. TABLA COMPARATIVA: BRECHA DE INGRESO POR SEXO Y EDUCACION
# ---------------------------------------------------------
brecha <- datos %>%
  group_by(educacion = as_factor(educacion), sexo = as_factor(sexo)) %>%
  summarise(ingreso_promedio = mean(ingreso), .groups = "drop") %>%
  tidyr::pivot_wider(names_from = sexo, values_from = ingreso_promedio) %>%
  mutate(brecha_pct = (Hombre - Mujer) / Hombre * 100)

brecha

# ---------------------------------------------------------
# 2. PRUEBA T: INGRESO HOMBRE VS MUJER (GLOBAL)
# ---------------------------------------------------------
t.test(log_ingreso ~ as_factor(sexo), data = datos)

# ---------------------------------------------------------
# 3. ANOVA DE DOS FACTORES: SEXO x EDUCACION SOBRE INGRESO
# ---------------------------------------------------------
modelo_anova <- aov(log_ingreso ~ as_factor(sexo) * as_factor(educacion), data = datos)
summary(modelo_anova)

# ---------------------------------------------------------
# 4. ANCOVA: CONTROLANDO POR CATEGORIA OCUPACIONAL
# ---------------------------------------------------------
# Aqui usamos "otra variable del modulo 500" (categ_ocup) para
# verificar si la brecha persiste incluso controlando por el tipo
# de categoria ocupacional (dependiente, independiente, sector
# publico/privado, etc.) de cada persona.
modelo_ancova <- aov(log_ingreso ~ as_factor(categ_ocup) + as_factor(sexo) * as_factor(educacion),
                     data = datos)
summary(modelo_ancova)

# ---------------------------------------------------------
# 5. VISUALIZACION ADICIONAL (grafico para publicar en LinkedIn/X)
# ---------------------------------------------------------
g_final <- ggplot(brecha, aes(x = reorder(educacion, brecha_pct), y = brecha_pct)) +
  geom_col(fill = "darkorange") +
  coord_flip() +
  labs(
    title = "Brecha salarial de genero por nivel educativo",
    subtitle = "Porcentaje de diferencia (Hombre vs Mujer) - ENAHO 2025",
    x = "Nivel educativo",
    y = "Brecha (%)"
  ) +
  theme_minimal()
g_final

# Guardar grafico final
ggsave("figures/g_final_brecha_salarial.png", g_final, width = 8, height = 6, dpi = 300)

#=========================================================
# 6. CONCLUSIONES
#=========================================================
# Pregunta: ¿Existe una brecha de ingresos por sexo dentro de cada 
# nivel educativo, y esa brecha persiste (o se explica 
# parcialmente) al controlar por categoria ocupacional?

# Tabla de brecha por nivel educativo
# La brecha porcentual (Hombre vs Mujer) es positiva y considerable 
# en la mayoria de niveles: desde 18.8% en "secun. Incompleta" 
# hasta 44.1% en "Sin Nivel", con un pico en Maestria/Doctorado en 
# terminos absolutos (S/ 68,875 vs S/ 45,375). La unica excepcion 
# es "Superior No Universitaria Completa", donde la brecha es 
# negativa (-4.95%), es decir, ahi las mujeres ganan ligeramente 
# mas en promedio. No se observa un patron monotonico claro donde 
# la brecha se reduzca sistematicamente a mayor nivel educativo.

# Prueba t global
# El t-test simple (Hombre vs Mujer, sin distinguir educacion) da 
# p=0.088, no significativo al 5%. Esto podria interpretarse 
# erroneamente como "no hay brecha", pero es enganoso: al no 
# controlar por educacion, el resultado se ve afectado por la 
# distinta composicion educativa entre hombres y mujeres en la 
# muestra (ver tabla_edu_sexo).

# ANOVA de dos factores (sexo x educacion)
# Al controlar por nivel educativo, el efecto de "sexo" SI resulta 
# significativo (p=0.0202). Esto confirma que la brecha real solo 
# se hace visible cuando se compara dentro de un mismo nivel 
# educativo, y que el t-test global la habia enmascarado por 
# diferencias en la composicion educativa entre hombres y mujeres.
# El termino de interaccion sexo:educacion NO es significativo 
# (p=0.3521), lo que indica que la magnitud de la brecha no varia 
# de forma estadisticamente distinta entre niveles educativos: 
# existe una brecha de fondo relativamente constante, mas alla de 
# las diferencias porcentuales observadas en la tabla descriptiva.

# ANCOVA controlando por categoria ocupacional
# Resultado clave: al agregar categ_ocup al modelo, el efecto de 
# "sexo" no desaparece ni se reduce, sino que se hace MAS fuerte y 
# mas significativo (p=3.04e-09 vs p=0.0202 sin controlar). Esto 
# es contrario a la hipotesis inicial de que la brecha se explicaria 
# por diferencias en el tipo de empleo (publico/privado, 
# dependiente/independiente). Lo que sugiere en realidad es que la 
# categoria ocupacional estaba "enmascarando" parte de la brecha: 
# una vez que se compara dentro de la MISMA categoria ocupacional, 
# la diferencia de ingresos entre hombres y mujeres es aun mas 
# marcada y consistente.

#### Conclusión general

# El análisis exploratorio y las pruebas estadísticas realizadas permiten responder de
# forma clara a la pregunta planteada: sí existe una brecha de ingresos por sexo dentro
# de los niveles educativos de Cajamarca, y esta no se explica por el tipo de empleo que
# ocupan hombres y mujeres. La evidencia descriptiva ya lo insinuaba —10 de 11 niveles
# educativos comparables mostraron brechas positivas a favor de los hombres, entre 13% y
# 44%—, pero el hallazgo más importante no está en esa magnitud bruta, sino en cómo
# cambió al someterla a control estadístico. La prueba t simple no detectó diferencias
# significativas (p=0.088), un resultado que por sí solo llevaría a descartar la brecha;
# sin embargo, ese resultado era engañoso, producto de que hombres y mujeres no están
# distribuidos de la misma forma entre niveles educativos en la muestra. Al controlar por
# educación mediante ANOVA, el efecto de sexo sí resultó significativo (p=0.0202), y al
# sumar la categoría ocupacional como control adicional en el ANCOVA, ese efecto no se
# diluyó sino que se intensificó (p=3.04e-09). Este último punto es el más contundente del
# análisis: si la brecha respondiera principalmente a que las mujeres se concentran en
# empleos peor remunerados (por ejemplo, más informalidad o menos puestos en el sector
# privado mejor pagado), controlar por categoría ocupacional debería reducir la brecha, no
# aumentarla. Que ocurra lo contrario indica que, dentro de la misma categoría ocupacional
# y el mismo nivel educativo, una mujer gana consistentemente menos que un hombre en
# Cajamarca — es decir, la brecha no se origina principalmente en qué tipo de trabajo
# consiguen, sino en algo que ocurre incluso cuando ambos tienen credenciales y tipo de
# empleo comparables. Este trabajo no permite identificar con precisión qué explica esa
# diferencia residual, ya que variables clave como años de experiencia real, antigüedad en
# el puesto y horas efectivamente trabajadas no fueron incluidas en los modelos; por eso,
# una extensión natural de este análisis sería una regresión multivariante que incorpore
# esos controles para aislar con mayor precisión qué proporción de la brecha responde a
# factores medibles (experiencia, horas trabajadas) y cuánto queda como un residuo no
# explicado, que en la literatura sobre brechas salariales suele asociarse a discriminación
# o a segregación ocupacional dentro de una misma categoría general.
