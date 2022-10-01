function Xk = dft_test(xn,N)
%To compute the dft of the sequence x(n)
L = length(xn);
%Check for the length of the DFT
if(N<L)
    error('Length of DFT should be greater than the input sequence');
end
x1 = [xn zeros(1,N-L)];%Zero padding to the input sequence and assigning the value to the other vector
%Twiddle factors
for n=0:1:N-1
for k=0:1:N-1
p = exp(2*pi*-1i*n*k/N);
x2(k+1,n+1) = p;
end
end
Xk=x1*x2;