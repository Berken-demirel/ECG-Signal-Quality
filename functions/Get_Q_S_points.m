function [Q,S,QRS_dur] = Get_Q_S_points(signal,sampling_rate,bool)

Q_locations = [];
S_locations = [];
QRS_duration = [];
R_peaks_location = Give_me_my_peaks(signal,sampling_rate,0);
length_of_signal = length(signal);
length_of_peaks = length(R_peaks_location);
Fs = sampling_rate;
window_width = 0.1 * Fs ; % 10ms


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

if bool == 1
    
    figure,
    plot(signal)
    hold on
    plot(R_peaks_location,signal(R_peaks_location),'*r')
    hold on
    plot(Q,signal(Q),'*g')
    hold on
    plot(S,signal(S),'*m')
    title('Signal with QRS points')
    
end

end

