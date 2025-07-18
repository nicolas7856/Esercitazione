import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft, fftfreq


# Esempio di array di dati (sostituisci con i tuoi valori)
values = np.array([521, 513, 509, 501, 505, 500, 502, 498])  # Dati esempio

# Frequenza di campionamento
fs = 1 / (100e-6)  # 10 MHz

# Calcola la FFT
N = len(values)
yf = fft(values)
xf = fftfreq(N, 1 / fs)[:N // 2]

# Traccia il grafico della FFT
plt.figure(figsize=(10, 6))
plt.plot(xf, 2.0 / N * np.abs(yf[:N // 2]))
plt.title("Spettro di Frequenza")
plt.xlabel("Frequenza [Hz]")
plt.ylabel("Ampiezza")
plt.grid()
plt.show()
