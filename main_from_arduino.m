clc; 
clear all;
close all;

% --- Parametri ---
fs = 100;               % Frequenza di campionamento [Hz]
Ts = 1/fs;
A = 1;                % Ampiezza nota
phi = 0.2;              % Fase
f0 = 0.2;               % Frequenza reale [Hz]
window_size = 1000;      % Finestra visibile nel plot
buffer = zeros(window_size, 1);  % Inizializzazione buffer
t_buffer = zeros(window_size, 1);
n_total = 0;
data_from_serial = 0; % Variabile per salvare il valore dalla seriale
offset = 512;

% Imposta connessione seriale
serial = serialport("COM3", 9600);      % Controllare la COM del pc
configureTerminator(serial, "LF");
flush(serial);

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

while true
    % Simula l'arrivo di un nuovo campione
    n_total = n_total + 1;
    t_new = (n_total - 1)*Ts;
    % y_new = A * sin(2*pi*f0*t_new + phi) + 0.06*randn();  % Segnale simulato
    % Lettura del valore dalla seriale
    line = readline(serial);
        value = str2double(line);
        if ~isnan(value)
            data_from_serial = value;
        else
            data_from_serial = 0;  % fallback se arriva un valore non
            % valido
        end
    % Aggiorna buffer
    buffer = [buffer(2:end); data_from_serial];
    t_buffer = [t_buffer(2:end); t_new];

    % --- Grid Search per stima della frequenza ---
    Ngrid = 500;
    f_grid = linspace(0.5, 3, Ngrid);
    J_grid = zeros(1, Ngrid);

    n = (0:window_size-1)';
    y_temp = buffer(:); % buffer attuale

    for k = 1:Ngrid
        f = f_grid(k);
        s = (A * sin(2*pi*f*n*Ts + phi)) + offset;
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
