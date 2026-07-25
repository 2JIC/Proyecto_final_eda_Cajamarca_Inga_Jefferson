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

## Pregunta: ¿Existe una brecha de ingresos por sexo dentro de cada nivel educativo, y esa brecha persiste (o se explica parcialmente) al controlar por categoria ocupacional?

#### Tabla de brecha por nivel educativo
La brecha porcentual (Hombre vs Mujer) es positiva y considerable en la mayoria de niveles: desde 18.8% en "secun. Incompleta" hasta 44.1% en "Sin Nivel", con un pico en Maestria/Doctorado en terminos absolutos (S/ 68,875 vs S/ 45,375). La unica excepcion es "Superior No Universitaria Completa", donde la brecha es negativa (-4.95%), es decir, ahi las mujeres ganan ligeramente mas en promedio. No se observa un patron monotonico claro donde la brecha se reduzca sistematicamente a mayor nivel educativo.

#### Prueba t global
El t-test simple (Hombre vs Mujer, sin distinguir educacion) da p=0.088, no significativo al 5%. Esto podria interpretarse erroneamente como "no hay brecha", pero es enganoso: al no controlar por educacion, el resultado se ve afectado por la distinta composicion educativa entre hombres y mujeres en la muestra (ver tabla_edu_sexo).

#### ANOVA de dos factores (sexo x educacion)
Al controlar por nivel educativo, el efecto de "sexo" SI resulta significativo (p=0.0202). Esto confirma que la brecha real solo se hace visible cuando se compara dentro de un mismo nivel educativo, y que el t-test global la habia enmascarado por diferencias en la composicion educativa entre hombres y mujeres.El termino de interaccion sexo:educacion NO es significativo (p=0.3521), lo que indica que la magnitud de la brecha no varia de forma estadisticamente distinta entre niveles educativos: existe una brecha de fondo relativamente constante, mas alla de las diferencias porcentuales observadas en la tabla descriptiva.

#### ANCOVA controlando por categoria ocupacional
Resultado clave: al agregar categ_ocup al modelo, el efecto de "sexo" no desaparece ni se reduce, sino que se hace MAS fuerte y mas significativo (p=3.04e-09 vs p=0.0202 sin controlar). Esto es contrario a la hipotesis inicial de que la brecha se explicaria por diferencias en el tipo de empleo (publico/privado, dependiente/independiente). Lo que sugiere en realidad es que la categoria ocupacional estaba "enmascarando" parte de la brecha: una vez que se compara dentro de la MISMA categoria ocupacional, la diferencia de ingresos entre hombres y mujeres es aun mas marcada y consistente.

#### Conclusion general
Existe una brecha salarial de genero estadisticamente significativa en Cajamarca (ENAHO 2025), que persiste dentro de cada nivel educativo y dentro de cada categoria ocupacional. La brecha no se explica por diferencias en el tipo de empleo, ya que controlar por esta variable aumenta (no reduce) la significancia del efecto de sexo. Esto sugiere que factores no observados en este analisis (por ejemplo, sesgos de segregacion ocupacional dentro de cada categoria general, discriminacion salarial directa, o diferencias en antiguedad/experiencia no medidas) podrian estar detras de esta brecha persistente. Se recomienda un analisis futuro con regresion multivariante que incluya mas controles (experiencia laboral, antiguedad, horas trabajadas) para aislar mejor el componente de la brecha atribuible especificamente al sexo.
