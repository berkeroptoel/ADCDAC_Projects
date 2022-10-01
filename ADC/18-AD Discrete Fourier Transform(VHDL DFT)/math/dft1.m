
x=[1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0];
len=length(x);
y=zeros(len,1);

for k=0:len-1
    for n=0:len-1
    y(k+1)=y(k+1)+x(n+1)*exp(-1i*2*pi*k*n/len);   
    end
end


