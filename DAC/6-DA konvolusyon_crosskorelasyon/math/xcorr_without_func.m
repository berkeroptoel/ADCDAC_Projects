x=[0 0 0 2 2 2 2 2 2 2 0 0 0]; 
y=[0 1 2 4 6 9 13 18 25 ];

m=length(x);
n=length(y);
k=m+n-1;

%h=fliplr(j);
for t=1:length(y)
   h(t)=y(length(y)-t+1); 
end

xx=zeros(k);
xx(1:m,1)=x;

hh=[h zeros(1,m-1)];

for i=2:k
    for j=2:k
        xx(j,i)=xx(j-1,i-1);
    end;
end;

%yy=xx*hh';
for a=1:k
    yy(a)=0;
    for b=1:k
        yy(a) = yy(a)+(xx(a,b)*hh(b));
    end
end

stem(yy);