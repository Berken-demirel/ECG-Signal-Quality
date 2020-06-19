%% Berken Utku Demirel
clearvars
clc
close all
%% Load data
raw_data = load('raw_data.mat').raw_data; 

features = first_part(raw_data);