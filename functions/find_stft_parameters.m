function y = find_stft_parameters(signal,sampling_rate)

[s,f] = stft(signal,sampling_rate);

y = s;

end