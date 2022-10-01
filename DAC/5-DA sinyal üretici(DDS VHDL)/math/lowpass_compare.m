%% DDS Algorithm Synthesis
clear all; clc;
% target frequency to generate
fOut = input('The frequency you want to create:');
nco_res = 32;
fs = 1000000;
tuningWord = 2^nco_res*fOut/fs    % DDS tuning word for target frequency
phAcc = 1;                        % Phase accumulator counter
phAcc1 = 1; 
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
%Plot signal
plot(dacVal,'LineWidth',2)

%find tuning word hex value 
fi(tuningWord,0,32,0);
hex(ans)

%% Low-Pass Filter (preferably)
hold on;
clear all; clc;
% target frequency to generate
fOut = input('The frequency you want to create:');
nco_res = 32;
fs = 1000000;
tuningWord = 2^nco_res*fOut/fs    % DDS tuning word for target frequency
phAcc1 = 1; 
LUTres1 = 5;                         % resolution of LUT
LUT1 = sin(2*pi*(0:2^LUTres1-1)./2^LUTres1); 

for i=1:2^nco_res / tuningWord + 1
count1 = phAcc1 / 2^(nco_res - LUTres1);
count1 = round(count1);
    if count1 < 1
       count1 = 1;
    else
        count1 = count1;
    end
dacVal2(i) = LUT1(count1); 
phAcc1 = phAcc1 + tuningWord;
end


xlabel('Sample');
ylabel('Amplitude');
plot(dacVal2)

xlabel('Sample');
ylabel('Amplitude');
dacVal3 = lowpass(dacVal2,150,fs);
plot(dacVal3,'LineWidth',2)
legend('256 LUT','32 LUT', '32 LUT Lowpass');
