close all;

% Parámetros
f0 = 1;                 % Frecuencia base
alphas = [0 0.25 0.75 1];

% Ancho de banda total
B = @(alpha) f0*(1+alpha);   % es como un B(alpha) = f0*(1+alpha)

% Ejes
t = linspace(0, 5, 1000);    % t >= 0
f = linspace(-2, 2, 1000);   % luego se escala con B

%% FIGURA RESPUESTA AL IMPULSO
figure;
hold on;

for a = alphas
    
    f_delta = a * f0;
    
    % Evitar división por cero
    h = zeros(size(t));
    
    for i = 1:length(t)
        if t(i) == 0
            h(i) = 2*f0;
        elseif abs(t(i)) == 1/(4*f_delta) && a ~= 0
            % Caso especial (evita infinito)
            h(i) = (pi*f0/2)*sin(pi/(2*a));
        else
            h(i) = 2*f0 * ...
                (sin(2*pi*f0*t(i))/(2*pi*f0*t(i))) * ...
                (cos(2*pi*f_delta*t(i)) / (1 - (4*f_delta*t(i))^2));
        end
    end
    
    plot(t, h, 'DisplayName', ['\alpha = ' num2str(a)]);
end

title('Respuesta al impulso - Coseno alzado');
xlabel('t');
ylabel('h_e(t)');
legend;
grid on;

%% FIGURA RESPUESTA EN FRECUENCIA
figure;
hold on;

for a = alphas
    
    B_val = f0*(1+a);
    f_delta = a*f0;
    f1 = f0 - f_delta;
    
    H = zeros(size(f));
    
    for i = 1:length(f)
        if abs(f(i)) < f1
            H(i) = 1;
        elseif abs(f(i)) >= f1 && abs(f(i)) <= B_val
            H(i) = 0.5 * (1 + cos(pi*(abs(f(i)) - f1)/(2*f_delta)));
        else
            H(i) = 0;
        end
    end
    
    plot(f, H, 'DisplayName', ['\alpha = ' num2str(a)]);
end

title('Respuesta en frecuencia - Coseno alzado');
xlabel('f');
ylabel('H_e(f)');
legend;
grid on;


%% Parámetros
Nbits = 1e2;        % 10^2 bits
alpha_vals = [0 0.25 0.75 1];
sps = 15;            % 10: muestras por símbolo (oversampling)
span = 6;           % duración del filtro en símbolos
SNR = 40;           % 20 dB (puedes variar)

% Generar bits NRZ-L
bits = randi([0 1], 1, Nbits);
symbols = 2*bits - 1;   % NRZ-L: 0→-1, 1→+1

% Loop para distintos alpha
for a = alpha_vals
    
    % Filtro coseno alzado
    rrc = rcosdesign(a, span, sps, 'normal');  
    
    % Upsampling
    upsampled = upsample(symbols, sps);
    
    % Filtrado (forma del pulso)
    tx = conv(upsampled, rrc, 'same');
    
    % Canal AWGN
    rx = awgn(tx, SNR, 'measured');
    
    % Figura
    figure;
    eyediagram(rx, 2*sps);  % 2 símbolos por ventana
    
    title(['Diagrama de ojo (alpha = ' num2str(a) ')']);
end

%%% Bajar frec de muestreo -> bajar sps
