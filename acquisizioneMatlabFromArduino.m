clc
clear all
close all
% Imposta connessione seriale
serial = serialport("COM3", 9600);      % Sostituisci con la tua porta COM
configureTerminator(serial, "LF");
flush(serial);


% Parametri
N = 100;                           % Numero di campioni da mostrare per finestra
data = zeros(1, N);                % Preallocazione iniziale
x = 1:N;
y      = 100;% vettore Nx1 dei campioni PPG
fs     = 100;        % Hz, frequenza di campionamento
Ts     = 1/fs;
N      = numel(y);

A      = 0.8;        % ampiezza nota
phi    = 0.2;        % sfasamento noto [rad]

% segnale sinusoidale sim. hearthbeat 
A = 200;
alfa = 4;
T = 0.8;
D = 800;

s = A.*exp(-alfa*x*T).*sin(2*pi*x*T/T)+D;
% Imposta il grafico una sola volta
figure;
hPlot = plot(x, data, 'b');
ylim([0, 1023]);                   % Valori analogici da 0 a 1023
xlabel("Campione");
ylabel("Valore analogico");
title("Dati in tempo reale da Arduino");

% Loop continuo di acquisizione
while true
    for i = 1:N
        line = readline(serial);
        value = str2double(line);
        if ~isnan(value)
            data(i) = value;
        else
            data(i) = 0;  % fallback se arriva un valore non valido
        end
    end

    % Aggiorna i dati del grafico
    set(hPlot, 'YData', data);
    drawnow;  % forza l'aggiornamento del grafico
end

% Quando vuoi interrompere il loop premi Ctrl+C o chiudi la finestra grafica
close s