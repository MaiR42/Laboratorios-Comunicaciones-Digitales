close all;
% Bits
bits = [1 0 1 1 0 0 1 0];

% Parametros
Ac = 1;
Rb = 1e3;

Tb = 1/Rb;
Fs = 100*Rb;


fdev = 2e3;   % desviacion de frecuencia (Δf)

Ns = round(Fs/Rb);

% Señal polar
m = repelem(2*bits-1, Ns);

t = (0:length(m)-1)/Fs;

% Integral discreta de m(t)
phi = 2*pi*fdev*cumsum(m)/Fs;

% Envolvente compleja
g = Ac * exp(1j*phi);

% FFT
Nfft = 2^nextpow2(length(g));

G = fftshift(fft(g,Nfft))/length(g);

f = (-Nfft/2:Nfft/2-1)*(Fs/Nfft);

% Graficas
figure;

subplot(3,1,1)
plot(t,m)
grid on
title('Señal binaria polar')
xlabel('Tiempo [s]')

subplot(3,1,2)
plot(t,real(g))
grid on
title('Parte real de la envolvente compleja')
xlabel('Tiempo [s]')

subplot(3,1,3)
plot(f,abs(G))
grid on
title('Transformada de Fourier de g(t)')
xlabel('Frecuencia [Hz]')
xlim([-10e3 10e3])
