close all;
% % % Envolvente compleja

% Dado a que La OOK es idéntica a la 
% modulación binaria unipolar en una señal DSB-SC:

% g(t) = Ac*​m(t)

% Parámetros
Ac = 1;          % amplitud portadora
Rb = 1e3;        % tasa de bits [bits/s]
Tb = 1/Rb;       % tiempo de bit
Fs = 100*Rb;     % frecuencia de muestreo

% Secuencia binaria unipolar
bits = [1 0 1 1 0 0 1 0]; % Crea una secuencia pre definida

% Construcción de la señal modulante m(t)
Ns = round(Fs/Rb);          % muestras por bit
m = repelem(bits, Ns);      % tren de pulsos NRZ unipolar

t = (0:length(m)-1)/Fs;

% Envolvente compleja para ASK/OOK
g = Ac * m;

% FFT de la envolvente compleja
Nfft = 2^nextpow2(length(g));
G = fftshift(fft(g, Nfft))/length(g);
f = (-Nfft/2:Nfft/2-1)*(Fs/Nfft);

% Gráficas
figure;
subplot(2,1,1)
plot(t, g, 'LineWidth', 1.2)
grid on
xlabel('Tiempo [s]')
ylabel('g(t)')
title('Envolvente Compleja de ASK/OOK')

subplot(2,1,2)
plot(f, abs(G), 'LineWidth', 1.2)
grid on
xlabel('Frecuencia [Hz]')
ylabel('|G(f)|')
title('Transformada de Fourier de la Envolvente Compleja')
xlim([-5*Rb 5*Rb])
