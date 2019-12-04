function RR_interval_checker = Check_RR_interval(RR_interval, R_peaks, bpm)

RR_interval_max = 60 / 50; % least 40 bpm 
RR_interval_min = 60 / 150; % max 160 bpm
RR_interval_change = 2 ;

for i = 1 : length(RR_interval) - 1
    sample_first = R_peaks(i);
    sample_last = R_peaks(i+1);
    
    if (bpm(i) - bpm(i+1) > 40)
        
        fprintf('Motion artifact in the %i.RR interval (between the %i and %i samples \n',i, sample_first, sample_last);
        
    elseif ( bpm(i) - bpm(i+1) < 40)
        
        fprintf('Motion Artifact in the %i RR interval (between the %i and %i samples \n', i , sample_first, sample_last);
        
    elseif ~( (RR_interval(i) <= RR_interval_max) && (RR_interval(i) >= RR_interval_min) )

        fprintf('Might be motion artifact in the %i.RR interval (between the %i and %i samples \n',i, sample_first, sample_last);
        
    end
   
    
end





end