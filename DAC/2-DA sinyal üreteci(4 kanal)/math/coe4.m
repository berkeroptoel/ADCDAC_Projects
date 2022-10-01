G1=1;
G2=1;
G3=1;
G4=1;
f1=2e3;
f2=5e3;
f3=10e3;
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

S1=S1.*128;
S1=S1+128;
S11=round(S1);
S11=fi(S11,0,8,0);

S2=S2.*128;
S2=S2+128;
S22=round(S2);
S22=fi(S22,0,8,0);

S3=S3.*128;
S3=S3+128;
S33=round(S3);
S33=fi(S33,0,8,0);

S4=S4.*128;
S4=S4+128;
S44=round(S4);
S44=fi(S44,0,8,0);


fid_coe = fopen('wave1.coe','w+');
fprintf(fid_coe,'memory_initialization_radix=16;\n');
fprintf(fid_coe,'memory_initialization_vector=\n');
fprintf(fid_coe,'%x,\n',S11(:,:));
fclose(fid_coe);

fid_coe = fopen('wave2.coe','w+');
fprintf(fid_coe,'memory_initialization_radix=16;\n');
fprintf(fid_coe,'memory_initialization_vector=\n');
fprintf(fid_coe,'%x,\n',S22(:,:));
fclose(fid_coe);

fid_coe = fopen('wave3.coe','w+');
fprintf(fid_coe,'memory_initialization_radix=16;\n');
fprintf(fid_coe,'memory_initialization_vector=\n');
fprintf(fid_coe,'%x,\n',S33(:,:));
fclose(fid_coe);

fid_coe = fopen('wave4.coe','w+');
fprintf(fid_coe,'memory_initialization_radix=16;\n');
fprintf(fid_coe,'memory_initialization_vector=\n');
fprintf(fid_coe,'%x,\n',S44(:,:));
fclose(fid_coe);

% S=S1+S2+S3;
% Y = abs(fft(S)/L);
% Y_O = Y(1:L/2+1);
% Y_O(2:end-1) = 2*Y_O(2:end-1);
% plot(f,Y_O);


% Y1 = abs(fft(S1)/L);
% Y2 = abs(fft(S2)/L);
% Y3 = abs(fft(S3)/L);
% 
% O1 = Y1(1:L/2+1);
% O1(2:end-1) = 2*O1(2:end-1);
% O2 = Y2(1:L/2+1);
% O2(2:end-1) = 2*O2(2:end-1);
% O3 = Y3(1:L/2+1);
% O3(2:end-1) = 2*O3(2:end-1);
% 
% O=O1+O2+O3;
% plot(f,O) 



