clc;
clear;
g=rectwin(63);
h=rectwin(63);
imgSize = 50;
A = 0.316228; % Corresponding voltage Vpp of 0dBm Power 
%% Parameters Declaration %%
sampling_frequency = 15e3;
sampling_time = 1/sampling_frequency;
sampling_duration = 1e-3;
t = 0:sampling_time:sampling_duration-sampling_time;
carrier_frequency = 500e6;
data_segment_length = 128;
t3 = 1:data_segment_length;
waveform = 'Costas';
% datasetCWD = 'Dataset_2.7GHz_2GHz_1024';
% mkdir(datasetCWD);
% mkdir(fullfile(datasetCWD,waveform));
no_of_signals = 1;
disp(['Generating ',waveform,' waveform........']);
index=0;
freq = [2 4 8 5 10 9 7 3 6 1]*(1/sampling_duration);
for xx=1:length(freq)
    cpf=sampling_duration*freq(xx);
    SAR=ceil(sampling_frequency/freq(xx));
    for n=1:SAR*cpf
        costasCode(index+1)=A*exp(-1j*2*pi*freq(xx)*(n-1)*sampling_time);
        index = index +1;
    end
end
sampledSegment = costasCode(1:data_segment_length);
% sampledSegment = awgn(sampledSegment,SNR,'measured');
[CWD_TFD,~,~] = FTCWD(sampledSegment',t3,data_segment_length,g,h,1,0,imgSize);
imagesc(CWD_TFD);
% path = strcat("Dataset_2.7GHz_2GHz_1024\",waveform,"\",waveform,"_File_No_",string(idx),"_SNR_(",string(SNR(n)),").txt");
% fileId = fopen(fullfile(path),'w');
% fprintf(fileId,"%e\n",sampledSegment);
% fclose(fileId);
% imwrite(CWD_TFD,fullfile(strcat("Dataset_2.7GHz_2GHz_1024\",waveform,"\",waveform,"_File_No_",string(idx),"_SNR_(",string(SNR(n)),").png")));