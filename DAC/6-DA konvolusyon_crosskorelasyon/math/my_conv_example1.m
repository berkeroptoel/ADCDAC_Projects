clear all
clc
%% Example 1
t1=-10:20;
exponential=3*exp(0.4*t1);


t2 = -10:0;
t3 = 0:10;

u1 = zeros(size(t2));
u2 = ones(size(t3));
unit_step = [u1 u2];


m1=length(exponential);
n1=length(unit_step);
U1=[exponential,zeros(1,n1)]; 
V1=[unit_step,zeros(1,m1)]; 
for k1=1:n1+m1-1
    W(k1)=0;
    for j1=1:m1
        if(k1-j1+1>0)
            W(k1)=W(k1)+U1(j1)*V1(k1-j1+1);
        else
        end
    end
end

stem(W); figure(1);
title('Without conv function');

konvolusyon = conv(U1,V1); figure(2);
stem(konvolusyon);
title('Using conv function');

