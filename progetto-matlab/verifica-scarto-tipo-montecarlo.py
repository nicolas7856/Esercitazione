import numpy as np

np.random.seed(0)  # Imposta il seme per la riproducibilità
Rmax = 5
i = 0
for i in range(Rmax):
    R = 100*i+1  # Numero di righe
    N = 4    # Numero di colonne
    sigma = 0.1
    mu = 1

    Y = mu + sigma * np.random.randn(R, N)  # Generazione dei dati

    mean_Y = np.mean(Y)  # Calcolo della media
    std_Y = np.std(Y, ddof=0)  # Calcolo della deviazione standard (senza correzione di Bessel)

    # print("Media:", mean_Y)
    # print("Deviazione standard:", std_Y)

R = 100
N = 4
teta_cappello_k = 0
k = 2

x = np.random.randn(R, N)
x_segnato = np.mean(x,axis=1)
# shape(teta_cappello_k)
print(x_segnato)
