G1=0.25;
G2=0.25;
G3=0.25;
G4=0.25;
f1=2e3;
f2=5e3;
f3=12e3;
f4=25e3;

Fs = 1e6;            % Sampling frequency                    
T = 1/Fs;              % Sampling period
L = 500;
L1 = Fs/f1;             % Length of signal
L2 = Fs/f2;
L3 = Fs/f3;
L4 = Fs/f4;
t = (0:L-1)*T;
t1 = (0:L1-1)*T;         % Time vector
t2 = (0:L2-1)*T;
t3 = (0:L3-1)*T;
t4 = (0:L4-1)*T;
f = Fs*(0:(L/2))/L;    % freq vector

S1 = G1*sin(2*pi*f1*t);
S2 = G2*sin(2*pi*f2*t);
S3 = G3*sin(2*pi*f3*t);
S4 = G4*sin(2*pi*f4*t);

Ssum=S1+S2+S3+S4;

Ssum=Ssum.*128;
Ssum=Ssum+128;
S_sum=round(Ssum);
S_sum=fi(S_sum,0,8,0);

fid_coe = fopen('wavesum.coe','w+');
fprintf(fid_coe,'memory_initialization_radix=16;\n');
fprintf(fid_coe,'memory_initialization_vector=\n');
fprintf(fid_coe,'%x,\n',S_sum(:,:));
fclose(fid_coe);
