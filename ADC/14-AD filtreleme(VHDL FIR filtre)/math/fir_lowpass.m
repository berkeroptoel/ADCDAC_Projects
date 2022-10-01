fs = 1e6; 
T = 1/fs; 
G1 = 1;

f1 = 10e3;
f2 = 10e4;
L = 1000;
t1 = (0:L-1)*T;
t2 = (0:L-1)*T;

S1 = G1*sin(2*pi*f1*t1);
S2 = G1*sin(2*pi*f2*t2);
S3 = S1 + S2;

%% fir_lowpass.fda dosyas�nda katsay�lar� �ektikten sonra �al��t�r�lmas� gereken komut
% S3 sinyalinin olu�turulan filtreye g�re filtrelenmesi
y1=filter(Num,1,S3);