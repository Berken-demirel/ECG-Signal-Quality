clc 
clear all
close all
%%
[file,path] = uiputfile('*.mat','Workspace File');

full_path = strcat(path, file);

data_st = load(full_path);

data = data_st.val(1,:);

Fs = 300;
%% Plot raw data
figure,
plot(data)
title('Raw data')
%% Get R peaks and draw 
R_peaks = Give_me_my_peaks(data,Fs,1);
%% Get Q and S points and draw
[Q,S,QS_dur] = Get_Q_S_points(data,Fs,0);
%% Get T points
Give_T_peaks(data,Fs,0);

