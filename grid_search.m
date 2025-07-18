clear all
close all
clc
% --- dati e parametri ---
y      = [1:1000,1]';% vettore Nx1 dei campioni PPG
fs     = 100;        % Hz
Ts     = 1/fs;
N      = numel(y);
fs = 100;               % Hz
t = 0:1/fs:10;          % 10 secondi → 1001 campioni
y = 0.8 * sin(2*pi*1.2*t + 0.2) + 0.02 * randn(size(t));
y = y(:);  

A      = 0.8;        % ampiezza nota
phi    = 0.2;        % sfasamento noto [rad]

% griglia di frequenze (0.5–3 Hz → 30–180 BPM)
f_min  = 0.5;
f_max  = 3.0;
Ngrid  = 1000;
f_grid = linspace(f_min, f_max, Ngrid);
J_grid = zeros(size(f_grid));

% calcolo del costo per ogni f
n = (0:N-1)';
for k = 1:Ngrid
    f = f_grid(k);
    s = A * sin(2*pi*f*n*Ts + phi);
    e = y - s;
    J_grid(k) = e' * e;
end

% selezione del minimo
[~, idx]     = min(J_grid);
f_est_grid   = f_grid(idx);
BPM_est_grid = 60 * f_est_grid;

fprintf('Grid search: f = %.4f Hz → BPM = %.1f\n', f_est_grid, BPM_est_grid);

% --- plot dinamico della sinusoide stimata con aggiornamento ogni 100 campioni ---
window_size = 100;      % numero di campioni visualizzati alla volta
s_full = A * sin(2*pi*f_est_grid*n*Ts + phi); % sinusoide stimata

figure;
h1 = plot(n(1:window_size)*Ts, y(1:window_size), 'b'); hold on;
h2 = plot(n(1:window_size)*Ts, s_full(1:window_size), 'r--');
legend('Segnale PPG', 'Sinusoide stimata');
xlabel('Tempo (s)');
ylabel('Ampiezza');
title('Aggiornamento in tempo reale');
xlim([0 window_size/fs]);
ylim([min(y)-0.2, max(y)+0.2]);
grid on;

for k = 1:(floor(N/window_size)-1)
    idx_start = k*window_size + 1;
    idx_end   = idx_start + window_size - 1;

    if idx_end > N
        break
    end

    set(h1, 'XData', n(idx_start:idx_end)*Ts, 'YData', y(idx_start:idx_end));
    set(h2, 'XData', n(idx_start:idx_end)*Ts, 'YData', s_full(idx_start:idx_end));
    
    xlim([n(idx_start)*Ts, n(idx_end)*Ts]);  % aggiorna asse x
    %pause(0.05);  % velocità aggiornamento
end
