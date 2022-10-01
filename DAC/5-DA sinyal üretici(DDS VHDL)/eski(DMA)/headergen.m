Fs = 1e6; 
T = 1/Fs; 
G1= 1;
f1= 10e3;
L1 = Fs/f1;
t1 = (0:L1-1)*T;
S1 = G1*sin(2*pi*f1*t1);

S1=S1.*128;
S1=S1+128;
S11=round(S1);
S11=fi(S11,0,8,0);

%Sine wave
L = Fs/f1;

fid = fopen('sine.h', 'w');
fprintf(fid, 'u8 S11[L] = \n');
fprintf(fid, '{\n');

for i = 1:L
    fprintf(fid, '%d, ', S11(i));
    if (mod(i, 16) == 0)
        fprintf(fid, '\n');
    end
end

fprintf(fid, '};\n');
fclose(fid);