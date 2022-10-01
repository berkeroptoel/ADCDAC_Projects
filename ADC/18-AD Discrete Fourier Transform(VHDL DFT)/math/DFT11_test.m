Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 64;               % Length of signal
t = (0:L-1)*T;        % Time vector
S = sin(2*pi*50*t);
S = S.*512;
S = S +512;
%[SS,twd,agl]=DFT11([1,2,3,4,4,3,2,1]);

[SS,twd,agl]=DFT11(S);
PP=abs(SS);

