
x=[0 0 0 2 2 2 2 2 2 2 0 0 0]; %input('Enter x:   ')
h=[0 1 2 4 6 9 13 18 25 ];%input('Enter h:   ')

m=length(x);
n=length(h);
X=[x,zeros(1,n)]; 
H=[h,zeros(1,m)]; 
for i=1:n+m-1
    Y(i)=0;
    for j=1:m
        if(i-j+1>0)
            Y(i)=Y(i)+X(j)*H(i-j+1);
        end
    end
end

stem(Y);