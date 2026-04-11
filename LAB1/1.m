% Parámetros configurables

A = 1;              
fc = 1000;           
Tsig = 1/100000;    
t = 0:Tsig:0.01;     

fs = 10000;          
duty_cycle = 0.3; % Ciclo de trabajo (d = tau / T) para PAM


% Señal original

m_t = A * sin(2*pi*fc*t);

%Grafica de la original
figure;
plot(t, m_t ,'m', LineWidth=1.5)
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('Señal Sinusoidal de 1000 Hz y Amplitud 1')
grid on

xlim([0 0.002]);
% Modulacion PAM natural

Ts = 1/fs;                        % Periodo de muestreo
tau = duty_cycle * Ts;            % Duracion del pulso
pulse_natural = zeros(size(t));

for k = 0:floor(max(t)/Ts)
    idx = (t >= k*Ts) & (t < k*Ts + tau);
    pulse_natural(idx) = m_t(idx);
end

%Grafica PAM natural
figure;
plot(t, m_t, 'm', 'LineWidth', 1.5); hold on
plot(t, pulse_natural, 'r', LineWidth=1.5); 
xlabel('t (s)');
ylabel('amplitud');
title('modulación PAM con muestreo natural');
legend('señal original', 'señal PAM');
grid on

xlim([0 0.002]);

% Modulacion PAM Instantaneo

pulse_instant = zeros(size(t));
sample_indices = 1:round(Ts/Tsig):length(t);  % índices de muestreo
pulse_instant(sample_indices) = m_t(sample_indices);

%Grafica PAM instantaneo
figure;
plot(t, m_t, 'm', 'LineWidth', 1.5); hold on

stem(t(sample_indices), pulse_instant(sample_indices), 'b', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal PAM Instantáneo');
legend('Señal Original','Señal PAM')
grid on;

xlim([0 0.002]);

% Graficar todas

figure;
plot(t, m_t, 'm', 'LineWidth', 1.5); hold on;
plot(t, pulse_natural, 'r', 'LineWidth', 1);

stem(t(sample_indices), pulse_instant(sample_indices), 'b', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal Original y Modulaciones PAM');
legend('Señal Original', 'PAM Natural', 'PAM Instantáneo');
grid on;

xlim([0 0.002]);

% Transformada de Fourier

N = length(t);
f = (0:N-1)*(1/(Tsig*N));   % Vector de frecuencias

M_f = abs(fft(m_t))/N;
PN_f = abs(fft(pulse_natural))/N;
PI_f = abs(fft(pulse_instant))/N;

% Solo porcion positiva
half_N = ceil(N/2);
f_pos = f(1:half_N);
M_f_pos = abs(M_f(1:half_N));
PN_f_pos = abs(PN_f(1:half_N));
PI_f_pos = abs(PI_f(1:half_N));

% Graficar todas
figure;
plot(f_pos, M_f_pos, 'b', 'LineWidth', 1.5); hold on;
plot(f_pos, PN_f_pos, 'r', 'LineWidth', 1);
plot(f_pos, PI_f_pos, 'g', 'LineWidth', 1);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
title('Transformada de Fourier - Señal Original y PAM');
legend('Señal Original', 'PAM Natural', 'PAM Instantáneo');
grid on;


xlim([0 35000]);