function [t, ppg] = simulate_ppg(fs, duration, hr, noise_level)
    % fs = frequenza di campionamento (Hz)
    % duration = durata del segnale in secondi
    % hr = battiti al minuto
    % noise_level = livello di rumore (es: 0.01)

    t = 0:1/fs:duration;
    bpm = hr;
    f = bpm / 60; % Hz
    ppg = zeros(size(t));

    for k = 0:round(f*duration)
        % Tempo del picco
        peak_time = k/f;
        % Aggiunta di un battito simulato (usiamo gaussiana)
        ppg = ppg + exp(-((t - peak_time)/0.1).^2); 
    end

    % Aggiunta di rumore
    ppg = ppg + noise_level * randn(size(ppg));
end
