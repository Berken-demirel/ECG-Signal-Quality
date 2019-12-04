 function [R_peaks , Q_points , S_points , RR_interval, bpm, QRS_dur] = Get_parameters(signal, sampling_rate, threshold)
R_peaks = find_peaks(signal, sampling_rate, threshold);
[Q_points , S_points, QRS_dur] = Get_Q_S_points(signal, R_peaks, sampling_rate);
[RR_interval, bpm] = calculate_RR_intervals(R_peaks, sampling_rate);
end
%[R_peaks , Q_points , S_points , RR_interval,bpm] = Get_parameters(signal, sampling_rate, threshold)
%%
%Function for R points


function y = find_peaks(signal,sampling_rate,threshold)

peaks_found = [];
possible_peaks=[];
signal_length = length(signal);
Fs = sampling_rate;

for i = 2:(signal_length-1)
   if signal(i) >= signal(i+1)  &&  signal(i) > threshold &&  signal(i-1) <= signal(i)
       possible_peaks = [possible_peaks i];
   end
   
end

window_width = 0.4 * Fs; % (set the limit of heart rate) for 200 bpm 
peaks_found = possible_peaks;
peaks_length = length(possible_peaks);

temp = 0;

for i = 1:(peaks_length-1)
    short = i - temp;
    if peaks_found(short + 1) - peaks_found(short) <= window_width && signal(peaks_found(short + 1)) >= signal(peaks_found(short))
        peaks_found(short) = [];
        temp = temp + 1;
    elseif peaks_found(short + 1) - peaks_found(short) <= window_width && signal(peaks_found(short + 1)) <= signal(peaks_found(short))
        peaks_found(short + 1) = [];
        temp = temp + 1;
    end
end


y = peaks_found;

end
%% Function for Q, S points and QRS duration

function [Q,S,QRS_dur] = Get_Q_S_points(signal, R_peaks_location,sampling_rate)

Q_locations = [];
S_locations = [];
QRS_duration = [];
length_of_signal = length(signal);
length_of_peaks = length(R_peaks_location);
Fs = sampling_rate;
window_width = 0.05 * Fs ; % 10ms

for k = 1 : (length_of_peaks)
    temp = R_peaks_location(k);
    Q_possible_locations = [];
    Q_possible_locations_value =[];
    S_possible_locations = [];
    S_possible_locations_value =[];
    coeff = 0;
    
    if temp - window_width > 1
        for i = temp - round(window_width)  : temp
            if signal(i) <= signal(i+1) && signal(i-1) >=  signal(i)
                Q_possible_locations = [Q_possible_locations i];
                Q_possible_locations_value = [Q_possible_locations_value signal(i)];
            end
        end
    end
    
    
    if temp + window_width < length_of_signal
        for i = temp : temp + round(window_width)
             if signal(i) <= signal(i+1) && signal(i-1) >=  signal(i) 
                 S_possible_locations = [S_possible_locations i];
                 S_possible_locations_value = [S_possible_locations_value signal(i)];
             end
        end
    end
   
    if temp - window_width < 1
        coeff = temp - round(window_width) - 2;
        for i = temp - round(window_width) - coeff : temp
            if signal(i) <= signal(i+1) && signal(i-1) >=  signal(i)
                Q_possible_locations = [Q_possible_locations i];
                Q_possible_locations_value = [Q_possible_locations_value signal(i)];
            end
        end
    end
  
    if temp + window_width > length_of_signal
        for i = temp : length_of_signal - 1
             if signal(i) <= signal(i+1) && signal(i-1) >=  signal(i) 
                 S_possible_locations = [S_possible_locations i];
                 S_possible_locations_value = [S_possible_locations_value signal(i)];
             end
        end
    end
    
          
        
    
%     for i = temp - round(window_width) : temp + round(window_width)
%         if signal(i) <= signal(i+1) && signal(i-1) >=  signal(i) && i < temp && No_Q_point == 0
%             Q_possible_locations = [Q_possible_locations i ];
%             Q_possible_locations_value = [Q_possible_locations_value signal(i)];
%         elseif signal(i) <= signal(i+1) && signal(i-1) >=  signal(i) && i > temp && No_S_point == 0
%             S_possible_locations = [S_possible_locations i];
%             S_possible_locations_value = [S_possible_locations_value signal(i)];
%         end
%     end

         [M_Q,I_Q] = min(Q_possible_locations_value);
         [M_S,I_S] = min(S_possible_locations_value);
         Q_locations = [Q_locations Q_possible_locations(I_Q)];
         S_locations = [S_locations S_possible_locations(I_S)];
end

if length(S_locations) == length(Q_locations)
    S_Q_points_difference = S_locations - Q_locations ;
    QRS_duration = S_Q_points_difference ./ Fs ; 
end

Q = Q_locations;
S = S_locations;
QRS_dur = QRS_duration;

end


%%
%Function for RR_interval
function [y,y1] = calculate_RR_intervals(peaks_index,sampling_rate)

RR_intervals = [];
time_interval_between_RR = [];
peaks_length = length(peaks_index);
Fs = sampling_rate;

for i = 1:(peaks_length-1)
    temp = peaks_index(i+1) - peaks_index(i);
    RR_intervals = [RR_intervals temp];
end
time_interval_between_RR = RR_intervals ./ Fs;

y = time_interval_between_RR;
y1 = 60 ./ time_interval_between_RR ;

end

