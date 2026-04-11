close all;
% Parámetros configurables
A = 1;
N = 8;          % Cantidad de bits para PCM
L  = 2^N;               % niveles de cuantización
fc = 1000;           
Tsig = 1/100000;    
t = 0:Tsig:0.01;     

fs = 10000;          
Ts = 1/fs;                        % Periodo de muestreo
duty_cycle = 0.3; % Ciclo de trabajo (d = tau / T) para PAM


% Señal original

m_t = A * sin(2*pi*fc*t);

% Modulacion PAM Instantaneo

pulse_instant = zeros(size(t));
sample_indices = 1:round(Ts/Tsig):length(t);  % índices de muestreo
pulse_instant(sample_indices) = m_t(sample_indices);


% Solo cuantizamos las muestras (no toda la señal continua)
muestras = m_t(sample_indices);

% Rango de la señal
m_min = min(muestras);
m_max = max(muestras);

delta = (m_max - m_min)/L;

niveles = m_min:delta:m_max;

% Cuantización
mq = zeros(size(muestras));

for i = 1:length(muestras)
    [~, idx] = min(abs(niveles - muestras(i)));
    mq(i) = niveles(idx);
end

figure;

plot(t, m_t, 'm', 'LineWidth', 1.5); hold on;

stem(t(sample_indices), muestras, 'b', 'filled', LineWidth=1.5);

stairs(t(sample_indices), mq, 'k', 'LineWidth', 1.5);

xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Original, PAM Instantánea y Cuantizada');
legend('m(t)', 'PAM Instantánea', 'PAM Cuantificado');

grid on;
xlim([0 0.002]);

error = muestras - mq;

figure;

stem(t(sample_indices), error, 'r', 'filled', 'LineWidth',1.5);

xlabel('Tiempo (s)');
ylabel('Error');
title('Error de Cuantización PCM');

grid on;
xlim([0 0.002]);