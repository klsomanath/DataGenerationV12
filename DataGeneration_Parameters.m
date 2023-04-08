 clc;
clear;
g=rectwin(63);
h=rectwin(63);
imgSize = 50;
A = 0.316228; % Corresponding voltage Vpp of 0dBm Power 
%% Parameters Declaration %%
sampling_frequency = 2.7e9;
sampling_time = 1/sampling_frequency;
carrier_frequency = 2e9;
deltaf = 250e6;
data_segment_length = 2048;
t3 = 1:data_segment_length;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FMCW %
sampling_duration =data_segment_length/sampling_frequency;
m = 1;
modulation_period = (sampling_duration)/m;
% Timing Specification %
t = 0:sampling_time:sampling_duration-sampling_time;
no_of_periods = sampling_duration/modulation_period;
no_of_samples = modulation_period/sampling_time;
tfmcw = (1:length(t))/sampling_frequency;
tfmcws = (1:no_of_samples)/sampling_frequency;
% FMCW Generation %
phi0 = 0;
for ai=1:no_of_periods
    for aj=1:no_of_samples
        f(ai,aj) = carrier_frequency + (deltaf/modulation_period)*tfmcws(aj);
    end
end
Frequency_Segment = reshape(f',1,[]);
FMCW = A*exp(1j*2*pi*Frequency_Segment.*tfmcw);
writematrix(FMCW);
clear f;
[CWD,~,~] = FTCWD(FMCW(1:data_segment_length)',t3,data_segment_length,g,h,1,0,imgSize);
imwrite(CWD,'FMCW.png');
figure(1);
imagesc(CWD);
clear CWD
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Poly Phase

chirp_duration = 10e-6;
M = 4;
Nc = M^2;
sampling_duration = data_segment_length/sampling_frequency;
no_of_samples = floor(sampling_duration/sampling_time);
t = 0:sampling_time:sampling_duration-sampling_time;
tfmcw = (1:length(t))/sampling_frequency;
tfmcws = (1:no_of_samples)/sampling_frequency;
for ii = 1:M
    for jj = 1:M
        phaseCodeP2(ii,jj) = mod((-2*pi/M*((M-(2*jj-1)))*((jj-1)*M+(ii-1))),2*pi);
    end
end
phaseCodeP21 = reshape(phaseCodeP2',1,[]);
no_of_segments = floor(length(t)/Nc);
for k=1:no_of_samples
    f(k) = carrier_frequency + (deltaf/sampling_duration)*tfmcws(k);
end
Frequency_Segment = f;
kk = 0;
for l = 1:Nc
    for m = 1:no_of_segments
         P2Code(l,m) = exp(-1j*((2*pi*Frequency_Segment(m+kk).*tfmcw(m+kk))+phaseCodeP21(l)));
    end
    kk = kk + no_of_segments;
end
P2Code1 = reshape( P2Code',1,[]);
writematrix(P2Code1)
[CWD,~,~] = FTCWD(P2Code1(1:data_segment_length)',t3,data_segment_length,g,h,1,0,imgSize);
imwrite(CWD,'P2.png')
figure(2);
imagesc(CWD);