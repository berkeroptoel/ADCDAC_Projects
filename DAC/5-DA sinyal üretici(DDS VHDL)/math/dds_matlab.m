%% DDS Algorithm Synthesis
clear all; clc;
% target frequency to generate
fOut = input('The frequency you want to create:');
nco_res = 32;
fs = 1000000;
tuningWord = 2^nco_res*fOut/fs    % DDS tuning word for target frequency
phAcc = 1;                        % Phase accumulator counter

%generate look-up table
LUTres = 8;                         % resolution of LUT
LUT = sin(2*pi*(0:2^LUTres-1)./2^LUTres); 

for i=1:2^nco_res / tuningWord + 1
count = phAcc / 2^(nco_res - LUTres);
count = round(count);
    if count < 1
       count = 1;
    else
        count = count;
    end
dacVal(i) = LUT(count); 
phAcc = phAcc + tuningWord;
end
%Plot signal
plot(dacVal,'LineWidth',2)
xlabel('Sample');
ylabel('Amplitude');

%find tuning word hex value 
fi(tuningWord,0,32,0);
hex(ans)

%% Low-Pass Filter (preferably)
%hold on;
%dacVal2 = lowpass(dacVal,150,fs);
%plot(dacVal2)
