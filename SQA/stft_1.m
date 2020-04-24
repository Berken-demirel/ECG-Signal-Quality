clearvars
close all
clc
%% Data-STFT
data = load('data_resampled.mat').data_resampled;

features = {};
counter = 1;
for i = 1:length(data(:,2))
    processed_data = data(:,i);
    features(i,1) = {stft(processed_data,250,'Window',kaiser(256,2),'OverlapLength',220,'FFTLength',512)};
end