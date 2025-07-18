rng(1234); % Imposta il seme per la riproducibilità
R = 1000; % Numero di records per il metodo Monte Carlo
N = 100; % Ampiezza del campione in ogni record mediato (samples per record)
sigma = 0.1; % Deviazione standard rumore
A = 0.3; % Valore di A da stimare
B = 0.7; % Valore di B da stimare
P = 2; % Numero di parametri da stimare

% Genero i dati utili
Y = zeros(N, R);
for r = 1:R
    for n = 0:N-1
        Y(n+1, r) = A + B*n + randn() * sigma;
    end
end

% Creazione della matrice H
H = zeros(2, N); % Inizializza la matrice correttamente

for j = 0:N-1
    H(:, j+1) = [1; j]; % Corregge l'assegnazione con una colonna alla volta
end
H = H.'