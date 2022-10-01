% Taylor için hatanýn gözlenmesi
k=1;
for i=-pi/2:pi/50:pi/2
    a(k)=i;             %Double or float point calculation
    b(k)=fi(i,1,32,15);  %Fixed point calculation
    k=k+1;
end 

ty=0;
ty1=0;
for j=1:1:7
 ty = ty +((-1)^(j+1))*((b.^(2*j-1))/(factorial(2*j-1)));   %Fixed point calculation
 ty1 = ty1 +((-1)^(j+1))*((a.^(2*j-1))/(factorial(2*j-1))); %Double or float point calculation
end

figure(1);
grid on;
plot(ty,'LineWidth',2);
hold on;
plot(ty1,'LineWidth',2);
legend('Fixed point represent','Real number represent');


%Power için hatanýn gözlenmesi

k=1;
for i=-pi/2:pi/50:pi/2
    a(k)=i;             %Double or float point calculation
    b(k)=fi(i,1,32,15);  %Fixed point calculation
    k=k+1;
end 


for j=1:1:7
 pwr = (a.^(2*j-1));   %Fixed point calculation
 pwr1 = (b.^(2*j-1)); %Double or float point calculation
end


figure(2);
plot(pwr,'LineWidth',2);
hold on;
plot(pwr1,'LineWidth',2);
legend('Real number represent','Fixed point represent');