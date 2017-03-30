

Como medir la carga en el servidor

### Ejercicio 3 Tema 2: Cómo analizar la carga del servidor

*Opción 1 - Comando Uptime:* Uptime  especifica el tiempo que el sistema lleva en marcha y la carga media que soporta ( en el ultimo minuto,
últimos 5 min o últimos 15 min).

*Opción 2 - Comando top:* Muestra cada T segundos carga media, procesos,consumo de memoria ,etc. Normalmente se ejecuta de forma interactiva

*Opción 3 - Monitor sar:* Usado para la detección de cuellos de botella. Ofrece info del uso del proceesador, se puede ejecutar de forma interactiva o programar
para obtener ficheros historicos saDD.

	Ejemplo: `sar -u 1 30` . Uso del procesador cada segundo hasta 30 muestras. 

*Opción 4 - ps* :Muestra la capacidad física ocupada por un proceso y el tiempo que lleva ejectuandose