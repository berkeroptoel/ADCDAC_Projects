clear all; clc;

fs = 10e5;
ts = 1/fs;
t = 0:ts:0.005;

s1 = 1+sin(2*pi*10000*t);
s2 = 1+sin(2*pi*10000*t);

s3 = s1.*s2;

y1=filter(Num,1,s3);