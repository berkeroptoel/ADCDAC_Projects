function [y,tw,angg] = DFT11(x)

len=length(x);
y=zeros(len,1);

for k=0:len-1
    for n=0:len-1
    pp=mod(k*n,len);
    aa=2*pi*pp/len;
    %aa=unitcircle_cast(aa);
    wn=exp(-1i*aa);
    angg(k+1,n+1)=aa;
    tw(k+1,n+1)=wn;
    y(k+1)=y(k+1)+x(n+1)*wn; 
    %y(k+1)=y(k+1)+x(n+1)*(cos(-2*pi*k*n/len)+1i*sin(-2*pi*k*n/len));
    end
end

%FFT
%https://www.youtube.com/watch?v=RioJKiSBlyg
%https://www.youtube.com/watch?v=A6eBcTHlEL4
%https://www.mathworks.com/matlabcentral/fileexchange/42214-radix-2-fast-fourier-transform-decimation-in-time-frequency
%https://www.mathworks.com/matlabcentral/fileexchange/36032-16-point-radix-2-dif-fft
%http://www.themobilestudio.net/the-fourier-transform-part-14
%https://www.youtube.com/watch?v=ncujb2BifBU
%https://ie.u-ryukyu.ac.jp/~wada/design07/spec_e.html

end

