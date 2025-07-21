clc; 
clear all;
close all;

% --- Parametri ---
fs = 100;               % Frequenza di campionamento [Hz]
Ts = 1/fs;
A = 0.8;                % Ampiezza nota
phi = 0.2;              % Fase
f0 = 0.2;               % Frequenza reale [Hz]
window_size = 1000;      % Finestra visibile nel plot
buffer = zeros(window_size, 1);  % Inizializzazione buffer
t_buffer = zeros(window_size, 1);
n_total = 0;

% Plot iniziale
figure;
h1 = plot(t_buffer, buffer, 'b'); hold on;
h2 = plot(t_buffer, buffer, 'r--');
legend('PPG', 'Stima');
xlabel('Tempo (s)'); ylabel('Ampiezza');
title('PPG Simulato - Real Time');
%xlim([0, window_size*Ts]);
ylim([-1.5, 1.5]);
grid on;
%ciao prova
while true
    % Simula l'arrivo di un nuovo campione
    n_total = n_total + 1;
    t_new = (n_total - 1)*Ts;
    y_new = A * sin(2*pi*f0*t_new + phi) + 0.06*randn();  % Segnale simulato

    % Aggiorna buffer
    buffer = [buffer(2:end); y_new];
    t_buffer = [t_buffer(2:end); t_new];

    % --- Grid Search per stima della frequenza ---
    Ngrid = 500;
    f_grid = linspace(0.5, 3, Ngrid);
    J_grid = zeros(1, Ngrid);

    n = (0:window_size-1)';
    y_temp = buffer(:); % buffer attuale

    for k = 1:Ngrid
        f = f_grid(k);
        s = A * sin(2*pi*f*n*Ts + phi);
        e = y_temp - s;
        J_grid(k) = sum(e.^2);
    end

    [~, idx_min] = min(J_grid);
    f_est = f_grid(idx_min);
    s_est = A * sin(2*pi*f_est*n*Ts + phi);

    % --- Aggiorna il plot ---
    set(h1, 'XData', t_buffer, 'YData', y_temp);
    set(h2, 'XData', t_buffer, 'YData', s_est);
    %xlim([t_buffer(1), t_buffer(end)]);
    drawnow;

    % Puoi rallentare il loop se vuoi visualizzare meglio
    pause(0.01);
    bpm = f_est *60
end
