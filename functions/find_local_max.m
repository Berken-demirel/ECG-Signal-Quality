function y = find_local_max(signal,sampling_rate,threshold)

peaks_found = [];
possible_peaks=[];
signal_length = length(signal);
Fs = sampling_rate;

for i = 2:(signal_length-1)
   if signal(i) >= signal(i+1)  &&  signal(i) > threshold &&  signal(i-1) <= signal(i)
       possible_peaks = [possible_peaks i];
   end
   
end

window_width = 0.3 * Fs; % (set the limit of heart rate) for 150 bpm 
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