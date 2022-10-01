close all;
clear all;
clc;
x=[0 0 0 2 2 2 2 2 2 2 0 0 0]; %input('Enter x:   ')
j=[0 1 2 4 6 9 13 18 25 ];%input('Enter h:   ')
h=fliplr(j);
disp('the 1st sequence is-');
disp(x); 
disp('the 2nd sequence is-');
disp(j);
lx=length(x);
lh=length(h);
n=lx+lh-1;
subplot(3,1,1);
stem(x);
title('1st sequence');
subplot(3,1,2);
stem(j);
title('2nd sequence');
hh=[h zeros(1,n-lh)];
xx=zeros(n);
xx(1:lx,1)=x;
for i=2:n
    for j=2:n
        xx(j,i)=xx(j-1,i-1);
      
    end;
end;
yy=xx*hh';
subplot(3,1,3);
stem(yy);
disp('cross correlate o/p->');
disp(yy');
title('y=cross correlastion of x & j');