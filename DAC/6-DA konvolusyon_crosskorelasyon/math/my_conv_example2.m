clear all
clc
%% Example 2
t4 = -40:40; % Time range
X = zeros(1,length(t4)); % Input signal 
x1 = -150; x2 = 150; % Range of Input Signal
H = zeros(1,length(t4)); % Impulse Response
h1 = -50; h2 = 50; % Range of Impulse Response Signal
Y = zeros(1,length(t4)); xh1 = x1+h1; xh2 = x2+h2; % Convolution output

% Input Signal Generation
x = sin(pi*t4/10)./(pi*t4/10); x(t4==0)=1; % Generate Input Sinc Signal
h = t4./t4; h(t4==0)=1; % Generate Impulse Response
H(t4>=h1&t4<=h2) = h(t4>=h1&t4<=h2); % Fit the input signal within range
X(t4>=x1&t4<=x2) = x(t4>=x1&t4<=x2); % Fit the impulse response within range


k2=length(X);
n2=length(H);
U2=[H,zeros(1,n2)]; 
V2=[X,zeros(1,k2)]; 
for k2=1:n2+k2-1
    Y(k2)=0;
    for j2=1:k2
        if(k2-j2+1>0)
            Y(k2)=Y(k2)+U2(j2)*V2(k2-j2+1);
        else
        end
    end
end

stem(Y); figure(1);
title('Without conv function');

konvolusyon = conv(U2,V2); figure(2);
stem(konvolusyon);
title('Using conv function');