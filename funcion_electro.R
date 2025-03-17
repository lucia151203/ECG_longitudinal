# Rutas de los archivos
dat_path <- "ECGPCG0003.dat"

# Parámetros de la señal
num_samples <- 240000  # Total de muestras
num_channels <- 2       # Dos canales en la señal
fs <- 8000             # Frecuencia de muestreo en Hz

# Leer el archivo binario
con <- file(dat_path, "rb")
ecg_data <- readBin(con, what = "integer", size = 2, n = num_samples * num_channels, endian = "little")
close(con)

# Convertir a matriz para separar los canales
ecg_matrix <- matrix(ecg_data, ncol = num_channels, byrow = TRUE)

# Extraer los canales
ecg_ch1 <- ecg_matrix[,1] / 110554.8863  # Convertir a mV

t <- seq(0, (length(ecg_ch1) - 1) / fs, length.out = length(ecg_ch1))

# Graficar ECG
plot(t, ecg_ch1, type = "l", col = "black", 
     main = "Electrocardiograma (ECG)", xlab = "Tiempo (s)", ylab = "Amplitud (mV)")

#Hasta ahora hemos hecho: 
#   Usamos los valores correctos del archivo .hea para interpretar los datos.
#   Convertimos la señal a mV usando los factores de conversión adecuados.
#   Graficamos ECG con la escala de tiempo correcta.


install.packages("pracma")  # Para detección de picos
install.packages("ggplot2") # Para visualización

library(pracma)
library(ggplot2)

# Detección de Picos R 
altura_minima <- 0.6 * max(ecg_ch1)  
distancia_minima <- fs / 10  

# Detectar picos R
picos <- findpeaks(ecg_ch1, minpeakheight = altura_minima, minpeakdistance = distancia_minima)

# Verificar si hay picos detectados antes de graficar
if (!is.null(picos)) {
  posiciones_R <- picos[,2]  
  amplitudes_R <- ecg_ch1[posiciones_R]  
  
  # Graficar la señal ECG con los picos R
  plot(t, ecg_ch1, type = "l", col = "blue",
       main = "Detección de picos R en el ECG", xlab = "Tiempo (s)", ylab = "Amplitud (mV)")
  
  points(t[posiciones_R], amplitudes_R, col = "red", pch = 19)  # Picos R en rojo
  
} else {
  print(" No se detectaron picos R. Ajusta los parámetros.")
}
