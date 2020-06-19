function first_part = first_part(raw_data)

%% filter design
Fs = 1000;  % Sampling Frequency

N    = 32;       % Order
Fc1  = 0.05;     % First Cutoff Frequency
Fc2  = 40;       % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hamming(N+1);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
%% filtering

filtered_signal = filter(b,1,raw_data);
%% Peak Detection

[~,qrs_i_raw,~] = pan_tompkin(filtered_signal,Fs,0); % Find peaks with delay due to filtering

R_peaks = find_peaks(filtered_signal,qrs_i_raw,Fs); %Find exact R peaks locations

% figure,plot(filtered_signal)
% hold on
% plot(R_peaks,filtered_signal(R_peaks),'*r')
%% Beat segmentation
signal_to_segment = filtered_signal;

indexes = R_peaks;

segmented_beat = [];
segmented_signals = {};
window_width_left = floor(Fs / 4);
window_width_right = floor(Fs / 2.5);
count = 1;
for i = indexes
    low_limit = floor(i - window_width_left);
    upper_limit = floor(i + window_width_right);
    
    if upper_limit >= length(signal_to_segment)
        upper_limit = length(signal_to_segment);
    end
    
    if low_limit <= 0
        low_limit = 1;
    end

    segmented_beat = signal_to_segment(low_limit:upper_limit);
    
    segmented_signals{count,1} = segmented_beat;
    
    count = count + 1;
end

segmented_signal = segmented_signals;
%% DWT

data_to_process = segmented_signal;

x = length(data_to_process);

for k = 1:x
    
    beat_to_process = data_to_process{k,1};
    
    [c,l] = wavedec(beat_to_process,4,'db6');
    
    [cd1,cd2,cd3,cd4] = detcoef(c,l,[1 2 3 4]);
    
    coeffs{1,1} = cd1;
    
    coeffs{2,1} = cd2;
    
    coeffs{3,1} = cd3;
    
    coeffs{4,1} = cd4;
    
    coeffs{5,1} = appcoef(c,l,'db6',1);
    
    coeffs{6,1} = appcoef(c,l,'db6',2);
    
    coeffs{7,1} = appcoef(c,l,'db6',3);
    
    coeffs{8,1} = appcoef(c,l,'db6',4);
    
    segmented_signals{k,2} = coeffs;
end
 %% Feature extraction
 



end