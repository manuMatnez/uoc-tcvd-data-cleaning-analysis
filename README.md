# Limpieza y Preprocesado del dataset "Heart Attack Analysis & Prediction Dataset"

## TODO

## Descripción
Este proyecto ha sido desarrollado para la asignatura de Tipología y ciclo de vida de los datos del máster de Ciencia de Datos de la Universitat Oberta de Catalunya y tiene como objetivo realizar el tratamiento de un dataset aplicando técnicas de integración, transformación, limpieza y validación de datos. 

El dataset contiene información de 2111 viviendas de lujo, en venta, disponibles en la provincia de Barcelona. La información incluida en este dataset es una recopilación de 25 características de las propiedades, como son el número de habitaciones, el tipo de inmueble, el número de baños, el barrio donde ubica, el año de construcción, el estado del inmueble y la descripción, entre otras, así como el precio de venta.

## Autores

**Vanessa Moreno González** y **Manuel Ernesto Martínez Martín**

## Acerca de este software

* Este software es parte de la Práctica 2 de la asignatura: "Tipologia y ciclo de vida de los datos".
* Asignatura: Tipologia y ciclo de vida de los datos.
* Master de Data Science.
* [Universitat Oberta of Catalunya.](http://www.uoc.edu/portal/ca/index.html)
* Profesor: Diego Perez

## Dataset

El dataset analizado, es un dataset de clasificación, **Heart Attack Analysis & Prediction Dataset**, que contiene información sobre 13 variables relacionadas con los infartos al corazón. 
Tiene como objetivo, predecir, en cada observación, la presencia de infarto.

Consta de un total de 303 observaciones, con 13 variables posibles predictoras y una variable objetivo. Estas variables son:

+ **age**: Edad del paciente.
+ **sex**: Género del paciente.
  - *0*: Femenino
  - *1*: Masculino
+ **cp**: Tipo de dolor en el pecho.
  - *0*: Angina típica
  - *1*: Angina atípica
  - *2*: Dolor no anginal
  - *3*: Asintomático
+ **trtbps**: Presión arterial en reposo (en mm Hg).
+ **chol**: Colesterol en mg/dl medido mediante un sensor BMI.
+ **fbs**: Nivel de azúcar en sangre en ayunas (> 120 mg/dl).
  - *1*: Verdadero
  - *0*: Falso
+ **restecg**: Resultados electrocardiográficos en reposo.
  - *0*: Normal
  - *1*: Anormalidad con inversiones de onda ST-T y/o alteraciones del segmento ST > 0.05 mV
  - *2*: Hipertrofia ventricular izquierda
+ **thalachh**: Ritmo cardíaco máximo alcanzado.
+ **exng**: Angina inducida por ejercicio.
  - *1*: Sí
  - *0*: No
+ **oldpeak**: Diferencia entre la depresión del segmento ST durante el ejercicio y durante el descanso en un electrocardiograma.
+ **slp**: Pendiente del segmento ST durante el ejercicio en la prueba de esfuerzo.
  - *1*: Ascendente
  - *2*: Plana
  - *3*: Descendente
+ **caa**: Número de vasos principales (0-3).
+ **thall**:  Talasemia, trastorno hereditario de la sangre caracterizado por un menor nivel de hemoglobina.
  - *0*: Ausencia
  - *1*: Talasemia normal
  - *2*: Talasemia fija defectuosa
  - *3*: Talasemia Reversible defectuosa
+ **output**: Variable objetivo.
  - *0*: Menor probabilidad de ataque al corazón
  - *1*: Mayor probabilidad de ataque al corazón

El dataset se ha extraído de kaggel: [**Heart Attack Analysis & Prediction Dataset**](https://www.kaggle.com/datasets/rashikrahmanpritom/heart-attack-analysis-prediction-dataset)

## Licencia

El contenido de este proyecto esta licencia bajo la [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html)
