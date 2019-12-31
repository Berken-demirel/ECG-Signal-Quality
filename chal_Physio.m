close all
clc 
clear
%addpath('C:\Users\berkenutku\Desktop\Proje\functions');
%%
Fs = 500;
data = load("data.mat").D;
% filtered_data = load("filtered_data_Physio.mat").data;
% k(i) = kurtosis(filtered_data(i,:,1));
% s(i) = skewness(filtered_data(i,:,1));
for i = 1:998
    signal_to_operate = data{i,2};
    parameters = [];
    for k = 1:12
        RMS(:,1) = movrms(signal_to_operate(:,k), Fs);
        [STFT_real(:,1) STFT_imag(:,1)] = find_stft_parameters(signal_to_operate(:,k),Fs);
        parameters = [parameters ; num2cell([RMS STFT_real STFT_imag],1)];
    end
    data(i,4) = {parameters};
end
%%
% subplot(4,1,1)
% plot((filtered_data(2,:,1)))
% title('Acceptable signal')
% subplot(4,1,2)
% plot(RMS(2,:))
% title('RMS of the acceptable signal')
% subplot(4,1,3)
% plot((filtered_data(3,:,1)))
% title('Unacceptable Signal')
% subplot(4,1,4)
% plot(RMS(3,:))
% title('RMS of the unacceptable signal')


%%
function y = movrms(signal,Fs)

length = round(Fs / 5);

RMS = movstd(signal,length);

y = normalize(RMS,'range');


end

%%
function y = filter_base_power(signal,Fs)

 f1 = 0.5;                                                                    
 f2 = 40;                                                                  
 Wn=[f1 f2] * 2 / Fs;                                                          
 N = 5;                                                     
 [b,a] = butter(N,Wn,'bandpass');                                  
 y = filtfilt(b,a,signal);
end
%%
function y = cross_covariance(signal1,signal2)
       [c,lag] = xcov(signal1,signal2);
       c = c/max(c);
       c = padarray(c,[0 100],'pre');
       c(end-99:end) =[];
       [M,I] = max(c);
       t_lag = lag(I);
       subplot(2,1,1)
       plot(signal1)
       subplot(2,1,2)
       plot(lag,c)
       xlim([0 length(signal1)]);
       y = c(end-4999:end);
end
%%
function y = average_signal_fnc(signal,sampling_rate)
    peaks = Give_me_my_peaks(signal,sampling_rate,0);
    window_width = round(sampling_rate / 5);
    temp = zeros([1 (2*window_width + 1)]);
    for peak = peaks
        temp = temp + signal(1,(peak - window_width):(peak+window_width));
    end
    y = temp;
end
%%
function [real_parts_1, imag_parts_1] = find_stft_parameters(signal,sampling_rate)
FFT_length = 100;

[s,f,t] = stft(signal,sampling_rate,'Window',hamming(FFT_length),'OverlapLength',1,'FFTLength',FFT_length);
signalsFsstTrain{1} = [real(s(:,:)); imag(s(:,:))];
meanTrain{1} = mean(signalsFsstTrain{1},2);
stdTrain{1} = std(signalsFsstTrain{1},[],2);
standardizeFun = @(x) (x - mean(cell2mat(meanTrain),2))./mean(cell2mat(stdTrain),2);
signalsFsstTrain = cellfun(standardizeFun,signalsFsstTrain,'UniformOutput',false);
output = signalsFsstTrain{1,1};
real_parts = output(1:FFT_length,:);
imag_parts = output(FFT_length+1:end,:);


real_parts_1 = reshape(real_parts,1,[]).';

imag_parts_1 = reshape(imag_parts,1,[]).';


end