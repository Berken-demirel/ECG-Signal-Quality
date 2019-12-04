function y = find_peaks(signal,local_max_of_processed_signal,fs)


peak_location = 0;
real_peaks =[];
window_width = round(fs / 30);

for i = local_max_of_processed_signal
    low_limit = round(i - window_width);
    upper_limit = round(i + window_width);
    
    temp = -Inf;
    for k = low_limit:upper_limit
        if signal(k) >= temp
            peak_location = k;
            temp = signal(k);
        end
    end
    real_peaks = [real_peaks peak_location];
end

y = real_peaks;

end