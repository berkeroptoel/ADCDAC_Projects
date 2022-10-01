Fs = 1e6; 
T = 1/Fs; 
G1= 1;
f1= 10e3;
L1 = 256;%Fs/f1;
% t1 = (0:Fs/f1-1)*T;
S1 = G1*sin(2*pi*(0:2^8-1)./2^8);%sin(2*pi*f1*t1);
sin(2*pi*(0:2^8-1)./2^8);

S1=S1.*100;
S1=S1+128;
S11=round(S1);
S11=fi(S11,0,8,0);

fid_coe = fopen('sinwave.coe','w+');
fprintf(fid_coe,'memory_initialization_radix=16;\n');
fprintf(fid_coe,'memory_initialization_vector=\n');
fprintf(fid_coe,'%x,\n',S11(:,:));
fclose(fid_coe);