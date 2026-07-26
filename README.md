# Proyecto_final_eda_Cajamarca_Inga_Jefferson
# NOMBRE: INGA CEDANO JEFFERSON
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

#### Conclusión general

El análisis exploratorio y las pruebas estadísticas realizadas permiten responder de
forma clara a la pregunta planteada: sí existe una brecha de ingresos por sexo dentro
de los niveles educativos de Cajamarca, y esta no se explica por el tipo de empleo que
ocupan hombres y mujeres. La evidencia descriptiva ya lo insinuaba —10 de 11 niveles
educativos comparables mostraron brechas positivas a favor de los hombres, entre 13% y
44%—, pero el hallazgo más importante no está en esa magnitud bruta, sino en cómo
cambió al someterla a control estadístico. La prueba t simple no detectó diferencias
significativas (p=0.088), un resultado que por sí solo llevaría a descartar la brecha;
sin embargo, ese resultado era engañoso, producto de que hombres y mujeres no están
distribuidos de la misma forma entre niveles educativos en la muestra. Al controlar por
educación mediante ANOVA, el efecto de sexo sí resultó significativo (p=0.0202), y al
sumar la categoría ocupacional como control adicional en el ANCOVA, ese efecto no se
diluyó sino que se intensificó (p=3.04e-09). Este último punto es el más contundente del
análisis: si la brecha respondiera principalmente a que las mujeres se concentran en
empleos peor remunerados (por ejemplo, más informalidad o menos puestos en el sector
privado mejor pagado), controlar por categoría ocupacional debería reducir la brecha, no
aumentarla. Que ocurra lo contrario indica que, dentro de la misma categoría ocupacional
y el mismo nivel educativo, una mujer gana consistentemente menos que un hombre en
Cajamarca — es decir, la brecha no se origina principalmente en qué tipo de trabajo
consiguen, sino en algo que ocurre incluso cuando ambos tienen credenciales y tipo de
empleo comparables. Este trabajo no permite identificar con precisión qué explica esa
diferencia residual, ya que variables clave como años de experiencia real, antigüedad en
el puesto y horas efectivamente trabajadas no fueron incluidas en los modelos; por eso,
una extensión natural de este análisis sería una regresión multivariante que incorpore
esos controles para aislar con mayor precisión qué proporción de la brecha responde a
factores medibles (experiencia, horas trabajadas) y cuánto queda como un residuo no
explicado, que en la literatura sobre brechas salariales suele asociarse a discriminación
o a segregación ocupacional dentro de una misma categoría general.
