M = 16; % QAM order
fs = 16000; % Sampling frequency in Hz
Ts = 1/fs; % Sampling interval in s
fc = 1000; % Carrier frequency in Hz (must be < fs/2 and > fg)
Rs = 100; % Symbol rate
Ns = 20; % Number of symbols

x = randi(Ns, 1, M)-1;
y = modulate(qammod(x,M));

L = fs / Rs; % Oversampling factor

% Impulse shaping
y_a = reshape(repmat(y', L, 1), 1, length(y)*L);
%% Modulation
I = real(y_a);
Q = imag(y_a);
t = 0 : Ts : (length(y_a) - 1) * Ts;
C1 = I .* sin(2*pi * fc * t);
C2 = Q .* cos(2*pi * fc * t);
s = C1 + C2;
%% Demodulation
r_I = s .* sin(2*pi * fc * t);
r_Q = s .* -cos(2*pi * fc * t);
%% Filter

% Design filter with least-squares method
N     = 50;           % Order
Fpass = Rs/2;         % Passband Frequency
Fstop = 2*fc - Rs/2;  % Stopband Frequency
Wpass = 1;            % Passband Weight
Wstop = 1;            % Stopband Weight

% Calculate the coefficients using the FIRLS function.
b  = firls(N, [0 Fpass Fstop fs/2]/(fs/2), [1 1 0 0], [Wpass Wstop]);

% Filtering
w_I = filter(b, 1, r_I);
w_Q = filter(b, 1, r_Q);
%% Sampling
u_I = downsample(w_I, L, L/2);
u_Q = downsample(w_Q, L, L/2);
plot(u_I, u_Q, '.');
