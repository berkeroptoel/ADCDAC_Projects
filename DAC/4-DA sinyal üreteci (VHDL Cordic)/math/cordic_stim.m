
An=1;
for i=0:29
An=An*sqrt(1+power(2,-2*i));
end
K=1/An;

in = -pi/2;
stp = pi/50;
for i=1:50
   [s(i),c(i)] = cordicc(in);
   in = in + stp;
    
end

for i=51:100
   [s(i),c(i)] = cordicc(in);
   in = in - stp;
end

stp = pi/100;
for i=101:200
   [s(i),c(i)] = cordicc(in);
   in = in + stp;
    
end

for i=201:300
   [s(i),c(i)] = cordicc(in);
   in = in - stp;
end

stp = pi/200;
for i=301:500
   [s(i),c(i)] = cordicc(in);
   in = in + stp;
    
end

for i=501:700
   [s(i),c(i)] = cordicc(in);
   in = in - stp;
end

%sine 0-255
ss= s.*128;
ss=ss+128;
plot(ss)
hold on

%cos 0-255
cc= c.*128;
cc=cc+128;
plot(cc)



