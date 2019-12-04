function [RR_interval,bpm] = calculate_RR_intervals(peaks_index,sampling_rate)

RR_intervals = [];
time_interval_between_RR = [];
peaks_length = length(peaks_index);
Fs = sampling_rate;

for i = 1:(peaks_length-1)
    temp = peaks_index(i+1) - peaks_index(i);
    RR_intervals = [RR_intervals temp];
end
time_interval_between_RR = RR_intervals ./ Fs;

RR_interval = time_interval_between_RR;
bpm = 60 ./ time_interval_between_RR ;

end

