close all;

% Datos medidos
EbN0_dB = 1:11;

% Valores en log (las salidas del Number Sink)
% 0 reemplazado por -7
BER_log_BPSK = [-2.81, -3.13, -3.52, -4.022, -4.62, -5.38, -6.31, -7.53, -9.1, -7, -7];
BER_log_QPSK = [-2.81, -3.13, -3.53, -4.02, -4.63, -5.38, -6.30, -7.48, -8.80, -9.80, -7];
BER_log_8PSK = [-2.24, -2.40, -2.59, -2.82, -3.11, -3.40, -3.90, -4.44, -5.11, -5.93, -6.97];

% Convertir a BER real
BER_BPSK = 10.^BER_log_BPSK;
BER_QPSK = 10.^BER_log_QPSK;
BER_8PSK = 10.^BER_log_8PSK;

% Graficar
figure;
semilogy(EbN0_dB, BER_BPSK, 'b-o', 'LineWidth', 1.5, 'DisplayName', 'BPSK');
hold on;
semilogy(EbN0_dB, BER_QPSK, 'r-s', 'LineWidth', 1.5, 'DisplayName', 'QPSK');
semilogy(EbN0_dB, BER_8PSK, 'g-^', 'LineWidth', 1.5, 'DisplayName', '8-PSK');
grid on;
xlabel('Eb/N0 (dB)');
ylabel('BER');
title('BER vs Eb/N0 para BPSK, QPSK y 8PSK');
legend('Location', 'southwest');
