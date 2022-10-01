%% Chirp Signal for FPGA
A = 1;  %Amplitude
Ts = 0.000001; %Sampling period
Fs = 1/Ts;
%% 50 KHz
F1 = 50000; %Frequency1
t1 = 0:Ts:0.00002;
s1 = A*cos(2*pi*F1*t1); 
%% 25 kHz
F2 = 25000; %Frequency 
t2 = 0:Ts:0.00004;
s2 = A*cos(2*pi*F2*t2); 
%% 16.667 kHz
F3 = 16667; %Frequency 
t3 = 0:Ts:0.00006;
s3 = A*cos(2*pi*F3*t3); 
%% 12.5 kHz
F4 = 12500; %Frequency 
t4 = 0:Ts:0.00008;
s4 = A*cos(2*pi*F4*t4); 
%% 10 kHz
F5 = 10000; %Frequency 
t5 = 0:Ts:0.0001;
s5 = A*cos(2*pi*F5*t5); 
%% 8.334 kHz
F6 = 8334; %Frequency 
t6 = 0:Ts:0.00012;
s6 = A*cos(2*pi*F6*t6); 
%% 7.143 kHz
F7 = 7143; %Frequency 
t7 = 0:Ts:0.00014;
s7 = A*cos(2*pi*F7*t7); 
%% 6.25 kHz
F8 = 6250; %Frequency 
t8 = 0:Ts:0.00016;
s8 = A*cos(2*pi*F8*t8); 
%% 5.556 kHz
F9 = 5556; %Frequency 
t9 = 0:Ts:0.00018;
s9 = A*cos(2*pi*F9*t9); 
%% 5 kHz
F10 = 5000; %Frequency 
t10 = 0:Ts:0.0002;
s10 = A*cos(2*pi*F10*t10); 
%% Plot Chirp
s=[s1 s2 s3 s4 s5 s6 s7 s8 s9 s10];

t_k=0:Ts:0.001;
f_10kHz=sin(2*pi*10000*t_k); 

z=conv(s,f_10kHz);
ttt=0:Ts:0.002109;
plot(ttt,z);
