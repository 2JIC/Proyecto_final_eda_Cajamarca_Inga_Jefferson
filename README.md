# Proyecto_final_eda_Cajamarca_Inga_Jefferson
Se explora si existe una brecha de ingresos por sexo dentro de cada nivel educativo, controlado por categoria ocupacional en el departamento de Cajamarca

Institucion: Instituto Nacional de Estadistica e Informatica (INEI)
Fuente: Encuesta Nacional de Hogares (ENAHO) 2025, Modulo 500
Objetivo: Explorar si existe una brecha de ingresos por sexodentro de cada nivel educativo, controlando por categoria ocupacional en el departamento de Cajamarca.
Variables principales:
- sexo (p207)
- edad (p208a)
- educacion (p301a)
- categ_ocup (p510): categoria ocupacional
- ingreso (i524a1): ingreso monetario del trabajo principal

Conclusion general
Existe una brecha salarial de genero estadisticamente significativa en Cajamarca (ENAHO 2025), que persiste dentro de cada nivel educativo y dentro de cada categoria ocupacional. La brecha no se explica por diferencias en el tipo de empleo, ya que controlar por esta variable aumenta (no reduce) la significancia del efecto de sexo. Esto sugiere que factores no observados en este analisis (por ejemplo, sesgos de segregacion ocupacional dentro de cada categoria general, discriminacion salarial directa, o diferencias en antiguedad/experiencia no medidas) podrian estar detras de esta brecha persistente. Se recomienda un analisis futuro con regresion multivariante que incluya mas controles (experiencia laboral, antiguedad, horas trabajadas) para aislar mejor el componente de la brecha atribuible especificamente al sexo.
