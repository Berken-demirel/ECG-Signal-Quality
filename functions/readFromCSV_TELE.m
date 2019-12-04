function [DB,fm,fs,rail_mv] = readFromCSV_TELE(DATA_PATH)
%%
% [DB,fm,fs,rail_mv] = readFromCSV_TELE(DATA_PATH)
%
% Extracts the data for each of the 250 telehealth ECG records of the TELE database [1] 
% and returns a structure containing all data, annotations and masks.
%
% IN:   DATA_PATH - String. The path containing the .hdr and .dat files
%
% OUT:  DB      -   1xM Structure. Contains the extracted data from the M (250) data files. 
%                   The structure has fields:
%                       * data_orig_ind    -  1x1 double. The index of the data file in the original
%                                             dataset of 300 records (see [1]) - for tracking purposes.
%                       * ecg_mv           -  1xN double. The ecg samples (mV). N is the number of samples for the data file.
%                       * qrs_annotations  -  1xN double. The qrs complexes - value of 1 where a qrs is located and 0 otherwise.
%                       * visual_mask      -  1xN double. The visually determined artifact mask - value of 1 where the data is masked and 0 otherwise.
%                       * software_mask    -  1xN double. The software artifact mask - value of 1 where the data is masked and 0 otherwise.
%       fm      -   1x1 double. The mains frequency (Hz)
%       fs      -   1x1 double. The sampling frequency (Hz)
%       rail_mv -   1x2 double. The bottom and top rail voltages (mV)
%
% If you use this code or data, please cite as follows:
%
% [1] H. Khamis, R. Weiss, Y. Xie, C-W. Chang, N. H. Lovell, S. J. Redmond, 
% "QRS detection algorithm for telehealth electrocardiogram recordings," 
% IEEE Transaction in Biomedical Engineering, vol. 63(7), p. 1377-1388, 
% 2016.
%
% Last Modified: 05/09/2016
%

fm = 50;
fs = 500;
rail_mv = [-5.554198887532222,5.556912223578890];

DB = [];
for tInd=1:250   
    % READ FROM DATA FILE
    files = dir(fullfile(DATA_PATH,sprintf('%d_*.dat',tInd)));   %# list all *.xyz files
    files = {files.name}';                      %'# file names
    temp = sscanf(files{1},'%d_%d.dat',2);
    oInd = temp(2);
    fid = fopen(fullfile(DATA_PATH,files{1}),'r');
    A = fscanf(fid,'%f,%d,%d,%d\n',[4,Inf]);
    fclose(fid);
    
    DB(tInd).data_orig_ind = oInd;
    DB(tInd).ecg_mv = A(1,:);
    DB(tInd).annotated_qrs = A(2,:);
    DB(tInd).visual_mask = A(3,:);
    DB(tInd).software_mask = A(4,:);
end



