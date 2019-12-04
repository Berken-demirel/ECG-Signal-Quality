function process = Give_me_my_peaks(signal,fs,bool)
%%
Artifacts_Location = [];
%%  Noise cancelation(Filtering)( 5-15 Hz)  %%
if fs == 200
%  remove the mean of Signal %
  signal = signal - mean(signal);
%% ==== Low Pass Filter  H(z) = ((1 - z^(-6))^2)/(1 - z^(-1))^2 ==== %%
   Wn = 12*2/fs;
   N = 4;                                                                  % order of 3 less processing
   [a,b] = butter(N,Wn,'low');                                             % bandpass filtering
   signal_l = filtfilt(a,b,signal); 
   signal_l = signal_l/ max(abs(signal_l));
%% ==== High Pass filter H(z) = (-1+32z^(-16)+z^(-32))/(1+z^(-1)) ==== %%
   Wn = 5*2/fs;
   N = 6;                                                                  % order of 3 less processing
   [a,b] = butter(N,Wn,'high');                                            % bandpass filtering
   signal_h = filtfilt(a,b,signal_l); 
   signal_h = signal_h/ max(abs(signal_h));
else
%%  bandpass filter for Noise cancelation of other sampling frequencies(Filtering)
 f1=10;                                                                     % cuttoff low frequency to get rid of baseline wander
 f2=20;                                                                     % cuttoff frequency to discard high frequency noise
 Wn=[f1 f2]*2/fs;                                                           % cutt off based on fs
 N = 10;                                                                     % order of 3 less processing
 [z, p, k] = butter(N,Wn,'bandpass');                                       % bandpass filtering
 [sos, g] = zp2sos(z,p,k);
 signal_h = filtfilt(sos,g,signal);
 signal_h = signal_h/ max( abs(signal_h));
end
%% derivative filter %%
% ------ H(z) = (1/8T)(-z^(-2) - 2z^(-1) + 2z + z^(2)) --------- %
if fs ~= 200
 int_c = (5-1)/(fs*1/40);
 b = interp1(1:5,[1 2 0 -2 -1].*(1/8)*fs,1:int_c:5);
else
 b = [1 2 0 -2 -1].*(1/8)*fs;   
end

signal_d = filtfilt(b,1,signal_h);
signal_d = signal_d/max(signal_d);
%%  Squaring
signal_squared = signal_d.^2;
%%  Moving average 
window_width = round(0.1 * fs);
b = (1 / window_width) * ones(window_width,1);
signal_last = filtfilt(b,1,signal_squared);
%%

signal_last = (signal_last - min(signal_last)) / (max(signal_last) - min(signal_last));

if bool == 1
    figure,
    plot(signal_last)
    title('end of fitering with moving average')
end
%%
if(~isempty(Artifacts_Location))
    for n = 1:(length(Artifacts_Location(1,:)) / 2)
        Artifacts_Location(:,n) = [];
    end
    for i = 1:2:(length(Artifacts_Location(1,:)))
        first_index = Artifacts_Location(1,i);
        last_index = Artifacts_Location(1,i+1);
        signal_d(first_index:last_index,1) = 0;
    end
end

% figure()
% plot(signal_d)
% title('Extract motion artifact point')


%%
local_max_of_processed_signal = find_local_max(signal_last, fs, 0.01);

values_of_local_max = signal_last(local_max_of_processed_signal);

%% Check Values of local max

mean_of_local_max = mean(values_of_local_max);

temp = 0;
for i = 1:length(values_of_local_max) - 1
    if values_of_local_max(i) > mean_of_local_max * 0.3
        if (values_of_local_max(i+1) - values_of_local_max(i) > 2 * values_of_local_max(i))
            local_max_of_processed_signal(i + 1 - temp) = [];
            temp = temp + 1;
        end
    else
        local_max_of_processed_signal(i - temp) = [];
        temp = temp + 1;
    end
end

real_peaks = find_peaks(signal,local_max_of_processed_signal,fs);

%%
%%
%Obtain beat per minute values 
[RR_interval,bpm] = calculate_RR_intervals(real_peaks,fs);
%%
if bool == 1
    figure()
    plot(signal)
    hold on
    plot(real_peaks, signal(real_peaks),'*r')
    title('Signal with peak detection')
end

if bool == 1
    figure()
    plot(RR_interval)
    title('RR interval')
end

process = real_peaks;
end
