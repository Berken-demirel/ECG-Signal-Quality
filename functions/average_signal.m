function y = average_signal(signal,sampling_rate)
    peaks = Give_me_my_peaks(signal,sampling_rate,0);
    window_width = round(sampling_rate / 5);
    temp = zeros([1 (2*window_width + 1)]);
    for peak = peaks
        temp = temp + signal(1,(peak - window_width):(peak+window_width));
    end
    y = temp;
end