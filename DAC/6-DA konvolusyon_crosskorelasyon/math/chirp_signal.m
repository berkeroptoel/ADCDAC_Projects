fs=500; %sampling frequency : number of samples per second
t=0:1/fs:1; %time base - upto 1 second
t1=1;

f0=1;% starting frequency of the chirp
f1=fs/20; %frequency of the chirp at t1=1 second

T=t1-t(1);
k=(f1-f0)/T;
x=cos(2*pi*(k/2*t+f0).*t);

plot(t,x);
title('Chirp Signal');
xlabel('Time(s)');
ylabel('Amplitude');
