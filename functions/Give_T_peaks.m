function T_peaks_locations = Give_T_peaks(signal,Fs,bool)

%% S point find
R_peaks_location = Give_me_my_peaks(signal,Fs,0);
[Q,S,~] = Get_Q_S_points(signal,Fs,0);
%% T wave peaks settings

window_width = round(0.46 * Fs);

T_peaks = [];
signal_to_send_local_max = (window_width);
T_wave_section = zeros(1 , length(signal));

if (S(end) + window_width) > length(signal)
    S(end) = [];
end
%% T wave filtering
 f1 = 0.5;                                                            
 f2 = 30;                                                                     
 Wn=[f1 f2] * 2 / Fs;                                                           
 N = 10;                                                                  
 [z, p, k] = butter(N,Wn,'bandpass');                                       
 [sos, g] = zp2sos(z,p,k);
 signal_T = filtfilt(sos,g,signal);


%% T wave section

for i = S
    for k = i: (i + window_width - 1)
        T_wave_section(k) = signal_T(k);
    end
end

%% Normalization settings

min_of_signal = min(T_wave_section);
max_of_signal = max(T_wave_section);

%% Filtering
for k = 1: (length(T_wave_section))
    if T_wave_section(k) == 0
        T_wave_section(k) = -Inf;
    end
end

%% Normalization
T_wave_section = (T_wave_section - min_of_signal)/(max_of_signal - min_of_signal);

%% T wave section local max find

T_peaks = find_local_max(T_wave_section,Fs,0.01);

if bool == 1
    figure,
    plot(signal)
    hold on
    plot(R_peaks_location,signal(R_peaks_location),'*r')
    hold on
    plot(Q,signal(Q),'*g')
    hold on 
    plot(S,signal(S),'*b')
    hold on
    plot(T_peaks,signal(T_peaks),'*m')
    title('processed signal')
end


T_peaks_location = T_peaks;
end
    

