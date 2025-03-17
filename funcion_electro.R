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

# Crear vector de tiempo
t <- seq(0, length(ecg_ch1) / fs, by = 1 / fs)

# Graficar ECG (Canal 1)
plot(t[1:length(ecg_ch1)], ecg_ch1, type = "l", col = "black", 
     main = "Electrocardiograma (ECG)", xlab = "Tiempo (s)", ylab = "Amplitud (mV)")

#Hasta ahora hemos hecho: 
#   Usamos los valores correctos del archivo .hea para interpretar los datos.
#   Convertimos la señal a mV usando los factores de conversión adecuados.
#   Graficamos ECG con la escala de tiempo correcta.



